import 'dart:async';

import 'package:ai_client/ai_client.dart';
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash/ai_assistant/models/ai_assistant_request_model.dart';
import 'package:shared_models/shared_models.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'ai_processing_event.dart';
part 'ai_processing_state.dart';

class AiAssistantBloc extends Bloc<AiAssistantEvent, AiAssistantState> {
  AiAssistantBloc({
    required AiClient aiClient,
    required WalletRepository walletRepository,
    required CategoryRepository categoryRepository,
    required TransactionRepository transactionRepository,
  })  : _aiClient = aiClient,
        _walletRepository = walletRepository,
        _categoryRepository = categoryRepository,
        _transactionRepository = transactionRepository,
        super(const AiAssistantInitial()) {
    on<AiAssistantLoadResourceRequested>(_onLoadResourceRequested);
    on<AiAssistantStartProcessing>(_onStartProcessing);
    on<AiAssistantCancelProcessing>(
      _onCancelProcessing,
      transformer: droppable(), // Only one operation at a time
    );
    on<AiAssistantReset>(
      _onReset,
      transformer: restartable(),
    );
  }

  final AiClient _aiClient;
  final WalletRepository _walletRepository;
  final CategoryRepository _categoryRepository;
  final TransactionRepository _transactionRepository;

  CancelableOperation<AiAssistantRequestModel>? _processingCancelable;
  List<BaseWalletModel> walletsParameter = [];
  List<CategoryModel> categoriesParameter = [];
  List<TransactionTypeEnum> transactionTypesParameter = [];

  Future<void> _onLoadResourceRequested(
    AiAssistantLoadResourceRequested event,
    Emitter<AiAssistantState> emit,
  ) async {
    try {
      walletsParameter = event.walletsParameter.isNotEmpty
          ? event.walletsParameter
          : await _walletRepository.getWalletsFuture(
              const GetWalletQuery(
                archived: false,
              ),
            );
      categoriesParameter = event.categoriesParameter.isNotEmpty
          ? event.categoriesParameter
          : await _categoryRepository.getCategoriesFuture(
              const GetCategoryQuery(
                enabled: true,
              ),
            );
    } catch (e) {
      walletsParameter = [];
      categoriesParameter = [];
    }
    transactionTypesParameter = TransactionTypeEnum.availableValues;
  }

  Future<void> _onStartProcessing(
    AiAssistantStartProcessing event,
    Emitter<AiAssistantState> emit,
  ) async {
    final currentHistory = state.history;
    var newProcess = AiAssistantRequestModel(
      source: event.requestMessage,
      status: AiProcessingStatus.initial,
    );

    emit(AiAssistantInProgress(history: [...currentHistory, newProcess]));

    try {
      newProcess = newProcess.copyWith(status: AiProcessingStatus.processing);
      emit(
        AiAssistantInProgress(
          history: [...currentHistory, newProcess],
        ),
      );

      Future<AiAssistantRequestModel> processMessage() async {
        final res = await _aiClient
            .postExtractTransactionFromText(
              PostExtractTransactionFromTextBody(
                queryText: event.requestMessage,
                knowledgeBase: KnowledgeBaseBody(
                  sourceWallet: WalletKnowledgeBaseBody(
                    id: event.sourceWallet.id,
                    name: event.sourceWallet.name,
                    description: event.sourceWallet.description,
                  ),
                  wallets: walletsParameter
                      .map(
                        (e) => WalletKnowledgeBaseBody(
                          id: e.id,
                          name: e.name,
                          description: e.description,
                        ),
                      )
                      .toList(),
                  categories: categoriesParameter
                      .map(
                        (e) => CategoryKnowledgeBaseBody(
                          id: e.id,
                          name: e.name,
                          description: e.description,
                        ),
                      )
                      .toList(),
                  transactionTypes: transactionTypesParameter
                      .map(
                        (e) => e.jsonKey,
                      )
                      .toList(),
                ),
              ),
            )
            .then((r) => r.firstOrNull);
        if (res == null) {
          return newProcess.copyWith(
            status: AiProcessingStatus.failed,
            response: const ProcessingResponse(
              responseText: 'Transaction processing failed',
            ),
          );
        }

        final transactions = res.output?.extractedTransactions;
        final transactionsData = <TransactionModel>[];
        if (transactions != null && transactions.isNotEmpty) {
          for (final e in transactions) {
            final wallet = event.sourceWallet;
            CategoryModel? category;
            if (e.category != null) {
              for (final categoryParameter in categoriesParameter) {
                if (categoryParameter.id == e.category?.id) {
                  category = categoryParameter;
                  break;
                }
              }
            }
            final transaction = e.toTransactionModel(
              wallet: wallet,
              category: category,
            );
            transactionsData.add(transaction);
          }
        }
        for (final transaction in transactionsData) {
          await _transactionRepository.createTransaction(transaction);
        }
        return newProcess.copyWith(
          status: AiProcessingStatus.completed,
          response: ProcessingResponse(
            responseText: res.output?.responseText ?? '',
            transactions: transactionsData,
          ),
        );
      }

      _processingCancelable = CancelableOperation.fromFuture(processMessage());

      await _processingCancelable?.value.then((value) {
        if (state is! AiAssistantInProgress) return;
        emit(
          AiAssistantCompleted(
            process: value,
            history: [...currentHistory, value],
          ),
        );
      });
    } catch (error) {
      final failedProcess = newProcess.copyWith(
        status: AiProcessingStatus.failed,
        response: const ProcessingResponse(
          responseText: 'Transaction processing failed',
        ),
      );

      emit(
        AiAssistantFailed(
          process: failedProcess,
          history: [...currentHistory, failedProcess],
        ),
      );
    }
  }

  void _onCancelProcessing(
    AiAssistantCancelProcessing event,
    Emitter<AiAssistantState> emit,
  ) {
    _processingCancelable?.cancel();
    _processingCancelable = null;
    emit(AiAssistantCancelled(history: state.history));
  }

  void _onReset(
    AiAssistantReset event,
    Emitter<AiAssistantState> emit,
  ) {
    if (event.keepHistory) {
      emit(AiAssistantInitial(state.history));
    } else {
      emit(const AiAssistantInitial());
    }
  }

  @override
  Future<void> close() {
    _processingCancelable?.cancel();
    _processingCancelable = null;
    return super.close();
  }
}

extension on ExtractedTransaction {
  TransactionModel toTransactionModel({
    required BaseWalletModel wallet,
    CategoryModel? category,
  }) {
    final now = DateTime.now();
    return TransactionModel(
      id: const Uuid().v4(),
      notes: notes,
      category: category,
      transactionType: TransactionTypeEnum.fromJsonKey(transactionType ?? ''),
      amount: amount ?? 0,
      transactionDate: transactionDate ?? now,
      wallet: wallet,
      createdAt: now,
      updatedAt: now,
    );
  }
}
