import 'package:app_ui/app_ui.dart';
import 'package:app_utils/app_utils.dart';
import 'package:currency_repository/currency_repository.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/overview/summary_trending/bloc/summary_trending_section_bloc.dart';
import 'package:felicash/overview/summary_trending/models/daily_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_models/shared_models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

part '../widgets/trending_chart.dart';

extension on TransactionTypeEnum {
  String name(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      TransactionTypeEnum.expense =>
        l10n.summaryTrendingSectionExpenseTypeLabel,
      TransactionTypeEnum.income => l10n.summaryTrendingSectionIncomeTypeLabel,
      TransactionTypeEnum.transfer =>
        l10n.summaryTrendingSectionTransferTypeLabel,
      TransactionTypeEnum.unknown =>
        l10n.summaryTrendingSectionUnknownTypeLabel,
    };
  }
}

class SummaryTrendingSection extends StatelessWidget {
  const SummaryTrendingSection({super.key});
  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _Title()),
              _TransactionTypeSelector(),
            ],
          ),
          _TotalAmount(),
          _TrendingChart(),
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
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Text(
        l10n.summaryTrendingSectionTitle,
        style: theme.textTheme.titleMedium,
      ),
    );
  }
}

class _TransactionTypeSelector extends StatelessWidget {
  const _TransactionTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedType = context
        .read<SummaryTrendingSectionBloc>()
        .state
        .selectedTransactionType;
    return DropdownButtonHideUnderline(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: DropdownMenu(
          initialSelection: selectedType,
          dropdownMenuEntries: [
            TransactionTypeEnum.expense,
            TransactionTypeEnum.income,
          ]
              .map(
                (e) => DropdownMenuEntry(
                  value: e,
                  label: e.name(context),
                  leadingIcon: Icon(
                    e.icon,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
              .toList(),
          onSelected: (value) {
            if (value == null) {
              return;
            }
            context
                .read<SummaryTrendingSectionBloc>()
                .add(SummaryTrendingSectionTransactionTypeChanged(value));
          },
          width: 150,
        ),
      ),
    );
  }
}

class _TotalAmount extends StatelessWidget {
  const _TotalAmount();

  @override
  Widget build(BuildContext context) {
    final selectedType = context.select(
      (SummaryTrendingSectionBloc bloc) => bloc.state.selectedTransactionType,
    );
    final totalAmount = context
        .select(
      (SummaryTrendingSectionBloc bloc) => bloc.state.dailySummaries,
    )
        .fold<double>(
      0,
      (previousValue, element) {
        return previousValue +
            (selectedType == TransactionTypeEnum.expense
                ? element.expense
                : element.income);
      },
    );
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            totalAmount.toCurrency(
              locale: l10n.localeName,
              // TODO(tuanhm): Replace with your currency symbol
              symbol: SupportedCurrencies.vnd.symbol,
            ),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: selectedType == TransactionTypeEnum.expense
                  ? Colors.red
                  : Colors.green,
            ),
          ),
          Text(
            l10n.summaryTrendingSectionTotalAmountText,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
