part of '../view/spending_by_category_section.dart';

class _SpendingByCategoryList extends StatelessWidget {
  const _SpendingByCategoryList();

  @override
  Widget build(BuildContext context) {
    final categoryStats = context.select(
      (SpendingByCategoryBloc bloc) => bloc.state.categorySpendingStats,
    );
    if (categoryStats.isEmpty) {
      return const SizedBox.shrink();
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: categoryStats.length,
      itemBuilder: (context, index) {
        final stat = categoryStats[index];
        return _SpendingByCategoryItem(stat: stat);
      },
    );
  }
}

class _SpendingByCategoryItem extends StatelessWidget {
  const _SpendingByCategoryItem({required this.stat});
  final CategorySpendingStat stat;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: stat.category.color,
        foregroundColor: stat.category.color.onContainer,
        child: IconWidget(
          icon: stat.category.icon,
          size: 16,
        ),
      ),
      title: Text(stat.category.name),
      trailing: Text(
        stat.spending.toCurrency(
          locale: l10n.localeName,
          // TODO(tuanhm): Replace with user setting base currency
          symbol: r'$',
        ),
      ),
    );
  }
}
