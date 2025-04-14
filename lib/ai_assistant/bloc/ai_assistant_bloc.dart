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
import 'package:wallet_repository/wallet_repository.dart';

part 'ai_processing_event.dart';
part 'ai_processing_state.dart';

const _mockKnowledgeBase = KnowledgeBaseBody(
  categories: [
    CategoryKnowledgeBaseBody(
      id: '751b0c10-d10e-472b-b953-d7463fecb819',
      name: 'Ăn uống',
      description: 'Các giao dịch chi trả cho việc ăn uống.',
    ),
    CategoryKnowledgeBaseBody(
      id: '5346a559-7eab-4682-90da-ee8e510784d1',
      name: 'Mua sắm',
      description: 'Các giao dịch chi trả cho việc mua sắm.',
    ),
  ],
  transactionTypes: [
    'income',
    're_payment',
    'lending',
    'borrowing',
    'expense',
    'debt_collecting',
    'transfer',
  ],
  wallets: [
    WalletKnowledgeBaseBody(
      id: '0df79f43-efc2-42f7-8277-611bb752eba0',
      name: 'Ví tiền mặt',
      description: 'Ví dùng cho các chi tiêu và thu nhập bằng tiền mặt',
    ),
    // WalletKnowledgeBaseBody(
    //   id: 'd88fe0bd-a91d-499a-898c-395e7e5c0c50',
    //   name: 'Ví tiết kiệm',
    //   description: 'Ví chứa các khoản tiết kiệm của tôi',
    // ),
  ],
  sourceWallet: WalletKnowledgeBaseBody(
    id: '0df79f43-efc2-42f7-8277-611bb752eba0',
    name: 'Ví tiền mặt',
    description: 'Ví dùng cho các chi tiêu và thu nhập bằng tiền mặt',
  ),
);

class AiAssistantBloc extends Bloc<AiAssistantEvent, AiAssistantState> {
  AiAssistantBloc({
    required AiClient aiClient,
  })  : _aiClient = aiClient,
        super(const AiAssistantInitial()) {
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

  CancelableOperation<AiAssistantRequestModel>? _processingCancelable;

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
                // TODO(tuamhm): Implement the real knowledge base
                knowledgeBase: _mockKnowledgeBase,
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
            // TODO(tuanhm): Get the wallet, category from the current
            // knowledge base
            final wallet = BasicWalletModel.empty;
            final category = CategoryModel.empty.copyWith(
              id: e.category?.id,
              name: e.category?.name,
            );

            final transaction = e.toTransactionModel(
              // Replace with the real wallet
              wallet: wallet,
              category: category,
            );
            transactionsData.add(transaction);
          }
        }

        // TODO(tuanhm): Save all transactions to the database

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
    required CategoryModel category,
  }) {
    final now = DateTime.now();
    return TransactionModel(
      id: '',
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
