part of 'transaction_processing_bloc.dart';

sealed class TransactionProcessingEvent extends Equatable {
  const TransactionProcessingEvent();

  @override
  List<Object> get props => [];
}

class TransactionProcessingStartProcessing extends TransactionProcessingEvent {
  const TransactionProcessingStartProcessing(this.requestMessage);
  final String requestMessage;

  @override
  List<Object> get props => [requestMessage, ...super.props];
}

/// Cancel the current transaction processing
class TransactionProcessingCancelProcessing
    extends TransactionProcessingEvent {}

/// Reset the transaction processing state to initial state
///
/// If [keepHistory] is true, the history will be kept
/// otherwise the history will be cleared
class TransactionProcessingReset extends TransactionProcessingEvent {
  const TransactionProcessingReset({
    this.keepHistory = false,
  });
  final bool keepHistory;
  @override
  List<Object> get props => [keepHistory, ...super.props];
}
