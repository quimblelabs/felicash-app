import 'package:app_ui/app_ui.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/overview/spending_by_category/bloc/spending_by_category_bloc.dart';
import 'package:felicash/overview/spending_by_category/models/category_spending_stat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

part '../widgets/spending_by_category_pie_chart.dart';
part '../widgets/spending_by_category_list.dart';

class SpendingByCategorySection extends StatelessWidget {
  const SpendingByCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Spending by category',
        style: theme.textTheme.titleMedium,
      ),
    );
  }
}
