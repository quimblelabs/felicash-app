part of 'transactions_bloc.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState extends Equatable {
  const TransactionsState({
    required this.transactions,
    required this.status,
    required this.hasReachedEnd,
  });

  const TransactionsState.initial()
      : transactions = const [],
        status = TransactionsStatus.initial,
        hasReachedEnd = false;
  const TransactionsState.loading()
      : transactions = const [],
        status = TransactionsStatus.loading,
        hasReachedEnd = false;

  final List<TransactionModel> transactions;
  final TransactionsStatus status;
  final bool hasReachedEnd;

  TransactionsState copyWith({
    List<TransactionModel>? transactions,
    TransactionsStatus? status,
    bool? hasReachedEnd,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      status: status ?? this.status,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object?> get props => [transactions, status, hasReachedEnd];
}
