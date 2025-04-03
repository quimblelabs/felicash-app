part of 'transaction_processing_bloc.dart';

sealed class TransactionProcessingState extends Equatable {
  const TransactionProcessingState(this.history);
  final List<TransactionProcessingResult> history;
  @override
  List<Object?> get props => [history];
}

class TransactionProcessingInitial extends TransactionProcessingState {
  const TransactionProcessingInitial([
    super.history = const [],
  ]);
}

class TransactionProcessingStarted extends TransactionProcessingState {
  const TransactionProcessingStarted({
    required List<TransactionProcessingResult> history,
  }) : super(history);
}

class TransactionProcessingInProgress extends TransactionProcessingState {
  const TransactionProcessingInProgress({
    required List<TransactionProcessingResult> history,
  }) : super(history);
}

class TransactionProcessingCompleted extends TransactionProcessingState {
  const TransactionProcessingCompleted({
    required this.process,
    required List<TransactionProcessingResult> history,
  }) : super(history);
  final TransactionProcessingResult process;

  @override
  List<Object?> get props => [process, ...super.props];
}

class TransactionProcessingFailed extends TransactionProcessingState {
  const TransactionProcessingFailed({
    required List<TransactionProcessingResult> history,
  }) : super(history);
}

class TransactionProcessingCancelled extends TransactionProcessingState {
  const TransactionProcessingCancelled({
    required List<TransactionProcessingResult> history,
  }) : super(history);
}
