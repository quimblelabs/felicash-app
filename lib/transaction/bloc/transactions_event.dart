part of 'transactions_bloc.dart';

sealed class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object> get props => [];
}

final class TransactionsInitialSubscriptionRequested extends TransactionsEvent {
  const TransactionsInitialSubscriptionRequested({
    this.filter = TransactionListFilter.empty,
  });
  final TransactionListFilter filter;

  @override
  List<Object> get props => [filter];
}

final class TransactionsNextSubscriptionRequested extends TransactionsEvent {
  const TransactionsNextSubscriptionRequested({
    this.filter = TransactionListFilter.empty,
  });
  final TransactionListFilter filter;

  @override
  List<Object> get props => [filter];
}
