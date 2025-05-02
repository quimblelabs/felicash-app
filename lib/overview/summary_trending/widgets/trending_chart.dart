part of '../view/summary_trending_section.dart';

extension on DailySummary {
  double getYValue(TransactionTypeEnum type) {
    return switch (type) {
      TransactionTypeEnum.expense => expense.abs(),
      TransactionTypeEnum.income => income.abs(),
      TransactionTypeEnum.transfer || TransactionTypeEnum.unknown => 0,
    };
  }
}

class _TrendingChart extends StatelessWidget {
  const _TrendingChart();

  List<CartesianSeries<DailySummary, DateTime>> _getLineSeries(
    List<DailySummary> summaries,
    TransactionTypeEnum type,
    Color color,
  ) {
    final dataSource = <DailySummary>[];
    final now = DateTime.now();
    // Start day of month
    final start = DateTime(now.year, now.month);
    // End day of month
    final end = DateTime(now.year, now.month + 1);
    for (var i = start; i.isBefore(end); i = i.add(const Duration(days: 1))) {
      // If the date is not in the summaries, add a new daily summary
      // with 0 expense and income.
      final summary = summaries.firstWhereOrNull((e) => e.date.isSameDay(i));
      if (summary == null) {
        dataSource.add(DailySummary(date: i, expense: 0, income: 0));
      } else {
        dataSource.add(summary);
      }
    }
    final lineSeries = SplineAreaSeries<DailySummary, DateTime>(
      key: ValueKey(type.jsonKey),
      dataSource: dataSource,
      borderColor: color,
      borderWidth: 3,
      animationDuration: 800,
      splineType: SplineType.cardinal,
      cardinalSplineTension: 0.9,
      gradient: LinearGradient(
        colors: [
          color.withValues(alpha: .4),
          color.withValues(alpha: .2),
          color.withValues(alpha: .1),
          color.withValues(alpha: 0),
        ],
        stops: const [0.1, 0.3, 0.5, 1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      color: color,
      markerSettings: const MarkerSettings(isVisible: true),
      sortFieldValueMapper: (DailySummary summary, _) => summary.date,
      xValueMapper: (DailySummary summary, _) => summary.date,
      yValueMapper: (DailySummary summary, _) {
        // Hide value after now
        if (summary.date.isAfter(now)) {
          return null;
        }
        return summary.getYValue(type);
      },
    );
    return [lineSeries];
  }

  Color _getColor(TransactionTypeEnum? type, BuildContext context) {
    switch (type) {
      case TransactionTypeEnum.expense:
        return AppColors.crimsionRed.colorSchemeOf(context).color;
      case TransactionTypeEnum.income:
        return AppColors.dollarBill.colorSchemeOf(context).color;
      case TransactionTypeEnum.transfer:
      case TransactionTypeEnum.unknown:
      case null:
        return Theme.of(context).colorScheme.onSurface;
    }
  }

  void _onMarkerRender(
    MarkerRenderArgs args,
    List<CartesianSeries<DailySummary, DateTime>> series,
    Color color,
  ) {
    final point = args.pointIndex;
    if (point == null) return;
    final data = series.first.dataSource?.elementAtOrNull(point);
    final now = DateTime.now();
    if (data?.date.isSameDay(now) ?? false) {
      args
        ..borderWidth = 2
        ..color = color;
    } else {
      args
        ..markerWidth = 0
        ..markerHeight = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final summaries = context.select(
      (SummaryTrendingSectionBloc bloc) => bloc.state.dailySummaries,
    );

    final selectedType = context.select(
      (SummaryTrendingSectionBloc bloc) => bloc.state.selectedTransactionType,
    );

    final color = _getColor(selectedType, context);
    final series = _getLineSeries(summaries, selectedType, color);
    return SizedBox(
      height: 250,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        margin: const EdgeInsets.all(AppSpacing.xlg),
        trackballBehavior: TrackballBehavior(
          enable: true,
          markerSettings: TrackballMarkerSettings(
            markerVisibility: TrackballVisibilityMode.visible,
            color: color.onContainer,
            borderColor: color,
          ),
          hideDelay: 3000,
          activationMode: ActivationMode.singleTap,
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
          tooltipAlignment: ChartAlignment.near,
          builder: (context, trackballDetails) {
            final points = trackballDetails.groupingModeInfo?.points ?? [];
            if (points.isEmpty || points.length > 2) {
              return const SizedBox();
            }
            final point = points.first;
            if (point.y == null) return const SizedBox();
            final date = point.x;
            final amount = point.y;
            return _TooltipItem(
              type: selectedType,
              date: date as DateTime,
              amount: amount! as double,
            );
          },
        ),
        onMarkerRender: (args) => _onMarkerRender(args, series, color),
        primaryYAxis: const NumericAxis(isVisible: false),
        primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.d(),
          interval: 5,
          majorGridLines: const MajorGridLines(width: 0),
        ),
        series: series,
      ),
    );
  }
}

class _TooltipItem extends StatelessWidget {
  const _TooltipItem({
    required this.type,
    required this.date,
    required this.amount,
  });

  final TransactionTypeEnum type;
  final DateTime date;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // DateFormat.yMEd(l10n.localeName).format(date),
            date.yMMMEd(l10n.localeName),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          Text(
            (type == TransactionTypeEnum.expense ? -amount : amount).toCurrency(
              locale: l10n.localeName,
              // TODO: Replace with currency symbol
              symbol: SupportedCurrencies.vnd.symbol,
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
