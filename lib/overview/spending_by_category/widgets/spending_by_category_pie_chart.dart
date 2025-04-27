part of '../view/spending_by_category_section.dart';

class _PieChart extends StatelessWidget {
  const _PieChart();

  List<CircularSeries<CategorySpendingStat, String>> _getDefaultPieSeries(
    List<CategorySpendingStat> data,
    CategorySpendingStat? selectedItem,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final reversed = data.reversed.toList();
    final explodeIndex = reversed.indexWhere((e) => e == selectedItem);
    final total = reversed.fold<double>(0, (pv, e) => pv + e.spending);

    return <CircularSeries<CategorySpendingStat, String>>[
      DoughnutSeries<CategorySpendingStat, String>(
        key: ValueKey(total.toString()),
        dataSource: reversed,
        animationDuration: 800,
        onPointTap: (pointInteractionDetails) {
          if (pointInteractionDetails.pointIndex == null) {
            return;
          }
          context.read<SpendingByCategoryBloc>().add(
                SpendingByCategorySelectedCategoryChanged(
                  reversed[pointInteractionDetails.pointIndex!],
                ),
              );
        },
        innerRadius: '70%',
        explodeOffset: '5%',
        explodeIndex: explodeIndex,
        cornerStyle: CornerStyle.bothCurve,
        strokeWidth: 10,
        explode: true,
        strokeColor: theme.colorScheme.surfaceContainerLowest,
        pointColorMapper: (CategorySpendingStat data, _) => data.category.color,
        xValueMapper: (CategorySpendingStat data, _) => data.category.name,
        yValueMapper: (CategorySpendingStat data, _) => data.spending,
        dataLabelMapper: (data, index) {
          final percent = (data.spending / total) * 100;
          final value = percent.toStringAsFixed(1);
          return '$value%';
        },
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.outer,
          labelPosition: ChartDataLabelPosition.outside,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final data = context.select(
      (SpendingByCategoryBloc bloc) => bloc.state.categorySpendingStats,
    );
    final initialSelectedItem = context.select(
      (SpendingByCategoryBloc bloc) => bloc.state.selectedCategorySpendingStat,
    );
    final series = _getDefaultPieSeries(data, initialSelectedItem, context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: SizedBox(
        height: 280,
        child: SfCircularChart(
          margin: const EdgeInsets.all(AppSpacing.lg),
          series: series,
        ),
      ),
    );
  }
}

class _SelectedCategorySection extends StatelessWidget {
  const _SelectedCategorySection();

  @override
  Widget build(BuildContext context) {
    final selectedItem = context.select(
      (SpendingByCategoryBloc bloc) => bloc.state.selectedCategorySpendingStat,
    );
    if (selectedItem == null) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final amountValue = selectedItem.spending > 100000
        ? selectedItem.spending.toCompactCurrency(
            locale: l10n.localeName,
            symbol: r'$',
          )
        : selectedItem.spending.toCurrency(
            locale: l10n.localeName,
            symbol: r'$',
          );
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 150),
      child: AnimatedSwitcher(
        transitionBuilder: (child, animation) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
        duration: const Duration(milliseconds: 410),
        reverseDuration: Duration.zero,
        child: Transform.translate(
          offset: const Offset(0, AppSpacing.xs),
          child: Column(
            key: ValueKey(selectedItem.category),
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  amountValue,
                  maxLines: 1,
                  style: theme.textTheme.headlineMedium,
                ),
              ),
              Text(
                selectedItem.category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: selectedItem.category.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
