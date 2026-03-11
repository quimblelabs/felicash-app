part of 'transaction_list_filter_cubit.dart';

class TransactionListFilterState extends Equatable {
  const TransactionListFilterState({
    required this.initialFilter,
    required this.filter,
  });

  const TransactionListFilterState.initial({
    required this.initialFilter,
  }) : filter = initialFilter;

  final TransactionListFilter initialFilter;
  final TransactionListFilter filter;

  TransactionListFilterState copyWith({
    TransactionListFilter? filter,
  }) {
    return TransactionListFilterState(
      initialFilter: initialFilter,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [filter, initialFilter];
}
