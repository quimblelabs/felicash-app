part of '../view/transactions_page.dart';

class TransactionListFilterButton extends StatelessWidget {
  const TransactionListFilterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _onPressed(context),
      icon: const Icon(Icons.filter_list),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final result = await showModalBottomSheet<TransactionListFilter?>(
      context: context,
      useRootNavigator: true,
      builder: (context) => const TransactionListFilterModal(),
    );
    if (result == null) return;
    if (!context.mounted) return;
    context.read<TransactionListFilterCubit>().updateFilter(result);
  }
}
