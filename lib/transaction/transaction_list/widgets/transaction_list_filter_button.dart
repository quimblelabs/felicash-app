part of '../view/transactions_page.dart';

class TransactionListFilterButton extends StatelessWidget {
  const TransactionListFilterButton({
    super.key,
  });

  int _countFilter(TransactionListFilter filter) {
    var count = 0;
    if (filter.categories.isNotEmpty) count++;
    if (filter.wallets.isNotEmpty) count++;
    if (filter.types.isNotEmpty) count++;
    if (filter.searchKey.isNotEmpty) count++;
    if (filter.from != null || filter.to != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final filter =
        context.select<TransactionListFilterCubit, TransactionListFilter>(
      (value) => value.state.filter,
    );
    final count = _countFilter(filter);
    return Badge(
      isLabelVisible: count > 0,
      label: Text(count.toString()),
      child: IconButton(
        onPressed: () => _onPressed(context),
        icon: const Icon(Icons.filter_list),
      ),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final result = await context.pushNamed<TransactionListFilter?>(
      AppRouteNames.transactionListFilters,
      extra: context.read<TransactionListFilterCubit>().state.filter,
    );
    if (result == null) return;
    if (!context.mounted) return;
    context.read<TransactionListFilterCubit>().updateFilter(result);
  }
}
