import 'dart:async';

import 'package:ai_client/ai_client.dart';
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash/voice_transaction/models/transaction_processing_result.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'transaction_processing_event.dart';
part 'transaction_processing_state.dart';

class TransactionProcessingBloc
    extends Bloc<TransactionProcessingEvent, TransactionProcessingState> {
  TransactionProcessingBloc({
    required AiClient aiClient,
  })  : _aiClient = aiClient,
        super(const TransactionProcessingInitial()) {
    on<TransactionProcessingStartProcessing>(_onStartProcessing);
    on<TransactionProcessingCancelProcessing>(
      _onCancelProcessing,
      transformer: droppable(), // Only one operation at a time
    );
    on<TransactionProcessingReset>(
      _onReset,
      transformer: restartable(),
    );
  }

  final AiClient _aiClient;

  CancelableOperation<TransactionProcessingResult>? _processingCancelable;

  Future<void> _onStartProcessing(
    TransactionProcessingStartProcessing event,
    Emitter<TransactionProcessingState> emit,
  ) async {
    final currentHistory = state.history;
    final newProcess = TransactionProcessingResult(
      source: event.requestMessage,
      status: TransactionProcessingStatus.initial,
    );

    emit(
      TransactionProcessingInProgress(history: [...currentHistory, newProcess]),
    );

    try {
      _processingCancelable = CancelableOperation.fromFuture(
        Future<TransactionProcessingResult>.delayed(const Duration(seconds: 2),
            () {
          return newProcess.copyWith(
            status: TransactionProcessingStatus.completed,
            processingResult: ProcessingResult(
              responseText: 'Transaction processed successfully',
              transaction: TransactionModel.empty.copyWith(
                notes: newProcess.source,
                category: CategoryModel.empty.copyWith(name: 'Food and Drinks'),
              ),
            ),
          );
        }),
      );

      await _processingCancelable!.value.then((value) {
        if (state is! TransactionProcessingInProgress) return;
        emit(
          TransactionProcessingCompleted(
            process: value,
            history: [...currentHistory, value],
          ),
        );
      });
    } catch (error) {
      final failedProcess = newProcess.copyWith(
        status: TransactionProcessingStatus.failed,
        processingResult: const ProcessingResult(
          responseText: 'Transaction processing failed',
        ),
      );

      emit(
        TransactionProcessingFailed(
          history: [...currentHistory, failedProcess],
        ),
      );
    }
  }

  void _onCancelProcessing(
    TransactionProcessingCancelProcessing event,
    Emitter<TransactionProcessingState> emit,
  ) {
    _processingCancelable?.cancel();
    _processingCancelable = null;
    emit(TransactionProcessingCancelled(history: state.history));
  }

  void _onReset(
    TransactionProcessingReset event,
    Emitter<TransactionProcessingState> emit,
  ) {
    if (event.keepHistory) {
      emit(TransactionProcessingInitial(state.history));
    } else {
      emit(const TransactionProcessingInitial());
    }
  }

  @override
  Future<void> close() {
    _processingCancelable?.cancel();
    _processingCancelable = null;
    return super.close();
  }
}
