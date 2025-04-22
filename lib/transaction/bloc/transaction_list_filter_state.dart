part of 'transaction_list_filter_cubit.dart';

class TransactionListFilterState extends Equatable {
  const TransactionListFilterState({
    required this.filter,
  });

  final TransactionListFilter filter;

  TransactionListFilterState copyWith({
    TransactionListFilter? filter,
  }) {
    return TransactionListFilterState(
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [filter];
}
