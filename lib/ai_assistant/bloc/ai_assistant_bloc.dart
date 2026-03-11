import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ai_client/ai_client.dart';
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash/ai_assistant/cubit/ai_assistant_view_cubit.dart';
import 'package:felicash/ai_assistant/models/ai_assistant_request_model.dart';
import 'package:felicash_storage_client/felicash_storage_client.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_models/shared_models.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'ai_processing_event.dart';
part 'ai_processing_state.dart';

/// Bloc responsible for handling AI assistant operations including
/// processing text and image inputs to extract transaction information.
class AiAssistantBloc extends Bloc<AiAssistantEvent, AiAssistantState> {
  /// Creates a new instance of [AiAssistantBloc].
  ///
  /// Requires [aiClient] for AI processing operations,
  /// [felicashStorageClient] for file storage operations,
  /// [walletRepository], [categoryRepository], and [transactionRepository]
  /// for data access.
  AiAssistantBloc({
    required AiClient aiClient,
    required FelicashStorageClient felicashStorageClient,
    required WalletRepository walletRepository,
    required CategoryRepository categoryRepository,
    required TransactionRepository transactionRepository,
  })  : _aiClient = aiClient,
        _felicashStorageClient = felicashStorageClient,
        _walletRepository = walletRepository,
        _categoryRepository = categoryRepository,
        _transactionRepository = transactionRepository,
        super(const AiAssistantInitial()) {
    on<AiAssistantLoadResourceRequested>(_onLoadResourceRequested);
    on<AiAssistantStartProcessing>(_onStartProcessing);
    on<AiAssistantRetryProcess>(_onRetryProcess);
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
  final FelicashStorageClient _felicashStorageClient;
  final WalletRepository _walletRepository;
  final CategoryRepository _categoryRepository;
  final TransactionRepository _transactionRepository;

  CancelableOperation<AiAssistantRequestModel>? _processingCancelable;
  List<BaseWalletModel> walletsParameter = [];
  List<CategoryModel> categoriesParameter = [];
  List<TransactionTypeEnum> transactionTypesParameter = [];

  /// Loads necessary resources for AI processing
  Future<void> _onLoadResourceRequested(
    AiAssistantLoadResourceRequested event,
    Emitter<AiAssistantState> emit,
  ) async {
    try {
      await Future.wait([
        _loadWallets(event.walletsParameter),
        _loadCategories(event.categoriesParameter),
      ]);
      transactionTypesParameter = TransactionTypeEnum.availableValues;
    } catch (e) {
      log('Error loading resources: $e');
      walletsParameter = [];
      categoriesParameter = [];
      transactionTypesParameter = TransactionTypeEnum.availableValues;
    }
  }

  /// Loads wallet data from repository or uses provided wallets
  Future<void> _loadWallets(List<BaseWalletModel> providedWallets) async {
    walletsParameter = providedWallets.isNotEmpty
        ? providedWallets
        : await _walletRepository.getWalletsFuture(
            const GetWalletQuery(archived: false),
          );
  }

  /// Loads category data from repository or uses provided categories
  Future<void> _loadCategories(List<CategoryModel> providedCategories) async {
    categoriesParameter = providedCategories.isNotEmpty
        ? providedCategories
        : await _categoryRepository.getCategoriesFuture(
            const GetCategoryQuery(enabled: true),
          );
  }

  /// Starts the AI processing operation
  Future<void> _onStartProcessing(
    AiAssistantStartProcessing event,
    Emitter<AiAssistantState> emit,
  ) async {
    final currentHistory = state.history;
    var newProcess = AiAssistantRequestModel(
      text: event.requestMessage,
      attachments: event.images,
      status: AiProcessingStatus.initial,
    );

    // Update state to processing
    newProcess = newProcess.copyWith(status: AiProcessingStatus.processing);
    emit(AiAssistantInProgress(history: [...currentHistory, newProcess]));

    try {
      final knowledgeBase = _createKnowledgeBaseBody(event.sourceWallet);

      // Choose processing method based on input type
      final handler = switch (event.mode) {
        AiAssistantMode.assistant =>
          _handleOnAssistantMode(newProcess, event, knowledgeBase),
        AiAssistantMode.transaction => event.images.isNotEmpty
            ? _handleExtractFromImage(newProcess, event, knowledgeBase)
            : _handleExtractFromText(newProcess, event, knowledgeBase),
      };

      _processingCancelable = CancelableOperation.fromFuture(handler);

      final result = await _processingCancelable?.value;
      if (result != null && state is AiAssistantInProgress) {
        emit(
          AiAssistantCompleted(
            process: result,
            history: [...currentHistory, result],
          ),
        );
      }
    } catch (error, stackTrace) {
      final failedProcess =
          _handleProcessingError(newProcess, error, stackTrace);
      emit(
        AiAssistantFailed(
          process: failedProcess,
          history: [...currentHistory, failedProcess],
        ),
      );
    }
  }

  /// Handles errors during processing
  AiAssistantRequestModel _handleProcessingError(
    AiAssistantRequestModel process,
    Object error,
    StackTrace stackTrace,
  ) {
    log(
      'Error processing transaction: $error',
      error: error,
      stackTrace: stackTrace,
    );
    return process.copyWith(
      status: AiProcessingStatus.failed,
      response: const ProcessingResponse(
        responseText: 'Transaction processing failed',
      ),
    );
  }

  Future<void> _onRetryProcess(
    AiAssistantRetryProcess event,
    Emitter<AiAssistantState> emit,
  ) async {
    final currentHistory = List<AiAssistantRequestModel>.from(state.history);

    final retryProcessIndex = currentHistory.indexWhere(
      (process) => process.id == event.processId,
    );
    if (retryProcessIndex == -1) {
      throw Exception('Process not found');
    }
    // Find the process to retry in history
    final processToRetry = currentHistory[retryProcessIndex];

    // Create a new process based on the original one
    final newProcess = processToRetry.copyWith(
      status: AiProcessingStatus.processing,
    );

    try {
      currentHistory[retryProcessIndex] = newProcess;
      emit(
        AiAssistantInProgress(history: currentHistory),
      );

      final knowledgeBase = _createKnowledgeBaseBody(event.sourceWallet);

      Future<AiAssistantRequestModel> handler;
      if (newProcess.attachments.isNotEmpty) {
        handler = _handleExtractFromImage(
          newProcess,
          AiAssistantStartProcessing(
            mode: event.mode,
            requestMessage: newProcess.text,
            images: newProcess.attachments,
            sourceWallet: event.sourceWallet,
          ),
          knowledgeBase,
        );
      } else {
        handler = _handleExtractFromText(
          newProcess,
          AiAssistantStartProcessing(
            mode: event.mode,
            requestMessage: newProcess.text,
            sourceWallet: event.sourceWallet,
          ),
          knowledgeBase,
        );
      }

      _processingCancelable = CancelableOperation.fromFuture(handler);

      await _processingCancelable?.value.then((value) {
        if (state is! AiAssistantInProgress) return;
        currentHistory[retryProcessIndex] = value;
        emit(
          AiAssistantCompleted(process: value, history: currentHistory),
        );
      });
    } catch (error, stackTrace) {
      log(
        'Error retrying process: $error',
        error: error,
        stackTrace: stackTrace,
      );
      final failedProcess = newProcess.copyWith(
        status: AiProcessingStatus.failed,
        response: const ProcessingResponse(
          responseText: 'Transaction processing failed',
        ),
      );
      currentHistory[retryProcessIndex] = failedProcess;
      emit(
        AiAssistantFailed(
          process: failedProcess,
          history: currentHistory,
        ),
      );
    }
  }

  /// Cancels the current processing operation
  void _onCancelProcessing(
    AiAssistantCancelProcessing event,
    Emitter<AiAssistantState> emit,
  ) {
    _processingCancelable?.cancel();
    _processingCancelable = null;
    emit(AiAssistantCancelled(history: state.history));
  }

  /// Resets the AI assistant state
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

  /// Processes image input to extract transaction data
  Future<AiAssistantRequestModel> _handleExtractFromImage(
    AiAssistantRequestModel newProcess,
    AiAssistantStartProcessing event,
    KnowledgeBaseBody knowledgeBase,
  ) async {
    try {
      final uploadedPath = await _felicashStorageClient.uploadFileFromPath(
        path: event.images.first,
        bucketName: 'transaction.attachments',
      );

      if (uploadedPath.isEmpty) {
        return newProcess.copyWith(
          status: AiProcessingStatus.failed,
          response: const ProcessingResponse(
            responseText: 'Transaction processing failed',
          ),
        );
      }

      final body = PostExtractTransactionFromOCRInvoiceBody(
        queryText: uploadedPath,
        knowledgeBase: knowledgeBase,
      );

      final res = await _aiClient.postExtractTransactionFromOCRInvoice(body);
      final data = res.firstOrNull;

      if (data == null) {
        return newProcess.copyWith(
          status: AiProcessingStatus.failed,
          response: const ProcessingResponse(
            responseText: 'Transaction processing failed',
          ),
        );
      }

      final transactions = await _processExtractedTransactions(
        data.output?.extractedTransactions,
        event.sourceWallet,
      );

      return newProcess.copyWith(
        status: AiProcessingStatus.completed,
        response: ProcessingResponse(
          responseText: data.output?.responseText ?? '',
          transactions: transactions,
        ),
      );
    } on FileSystemException catch (_) {
      return newProcess.copyWith(
        status: AiProcessingStatus.failed,
        response: const ProcessingResponse(
          responseText: 'Transaction processing failed',
        ),
      );
    }
  }

  /// Processes text input to extract transaction data
  Future<AiAssistantRequestModel> _handleExtractFromText(
    AiAssistantRequestModel newProcess,
    AiAssistantStartProcessing event,
    KnowledgeBaseBody knowledgeBase,
  ) async {
    final res = await _aiClient
        .postExtractTransactionFromText(
          PostExtractTransactionFromTextBody(
            queryText: event.requestMessage,
            knowledgeBase: knowledgeBase,
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

    final transactions = await _processExtractedTransactions(
      res.output?.extractedTransactions,
      event.sourceWallet,
    );

    return newProcess.copyWith(
      status: AiProcessingStatus.completed,
      response: ProcessingResponse(
        responseText: res.output?.responseText ?? '',
        transactions: transactions,
      ),
    );
  }

  Future<AiAssistantRequestModel> _handleOnAssistantMode(
    AiAssistantRequestModel newProcess,
    AiAssistantStartProcessing event,
    KnowledgeBaseBody knowledgeBase,
  ) async {
    final timezoneNamed = await FlutterTimezone.getLocalTimezone();
    final res = await _aiClient
        .postQuery(
          PostQueryBody(
            queryText: event.requestMessage,
            timezone: timezoneNamed,
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

    return newProcess.copyWith(
      status: AiProcessingStatus.completed,
      response: ProcessingResponse(
        responseText: res.response?.response ?? '',
      ),
    );
  }

  /// Processes extracted transactions, creates transaction models and saves them
  Future<List<TransactionModel>> _processExtractedTransactions(
    List<ExtractedTransaction>? extractedTransactions,
    BaseWalletModel sourceWallet,
  ) async {
    final transactionsData = <TransactionModel>[];
    if (extractedTransactions == null || extractedTransactions.isEmpty) {
      return transactionsData;
    }

    // Create a map for faster category lookups
    final categoryMap = {
      for (final category in categoriesParameter) category.id: category,
    };

    for (final extracted in extractedTransactions) {
      CategoryModel? category;
      if (extracted.category?.id != null) {
        category = categoryMap[extracted.category!.id];
      }

      final transaction = extracted.toTransactionModel(
        wallet: sourceWallet,
        category: category,
      );
      transactionsData.add(transaction);
    }

    // Save all transactions to repository
    for (final transaction in transactionsData) {
      await _transactionRepository.createTransaction(transaction);
    }

    return transactionsData;
  }

  /// Creates knowledge base body for AI processing
  KnowledgeBaseBody _createKnowledgeBaseBody(
    BaseWalletModel sourceWallet,
  ) {
    return KnowledgeBaseBody(
      sourceWallet: WalletKnowledgeBaseBody(
        id: sourceWallet.id,
        name: sourceWallet.name,
        description: sourceWallet.description,
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
    );
  }

  @override
  Future<void> close() {
    _processingCancelable?.cancel();
    _processingCancelable = null;
    return super.close();
  }
}

extension on ExtractedTransaction {
  /// Converts an extracted transaction to a transaction model
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
