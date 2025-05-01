import 'package:app_ui/app_ui.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/overview/spending_by_category/bloc/spending_by_category_bloc.dart';
import 'package:felicash/overview/spending_by_category/models/category_spending_stat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

part '../widgets/spending_by_category_list.dart';
part '../widgets/spending_by_category_pie_chart.dart';

class SpendingByCategorySection extends StatelessWidget {
  const SpendingByCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpendingByCategoryBloc, SpendingByCategoryState>(
      builder: (context, state) {
        if (state.status == SpendingByCategoryStatus.loading) {
          return const Card(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.categorySpendingStats.isEmpty) {
          return const _EmptyStateView();
        }

        return const Card(
          child: AnimatedSize(
            alignment: Alignment.topCenter,
            duration: Duration(milliseconds: 410),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Title(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    _PieChart(),
                    _SelectedCategorySection(),
                  ],
                ),
                _SpendingByCategoryList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyStateView extends StatelessWidget {
  const _EmptyStateView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Title(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xlg,
                vertical: AppSpacing.xxlg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  Icon(
                    Icons.pie_chart_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.spendingByCategorySectionEmptyStateTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.spendingByCategorySectionEmptyStateSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        l10n.spendingByCategorySectionTitle,
        style: theme.textTheme.titleMedium,
      ),
    );
  }
}
