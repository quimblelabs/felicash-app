import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'dart:math';

void main() {
  return runApp(_ChartApp());
}

class _ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      home: TrackballBuilderGroupAllPoints(),
    );
  }
}

class TrackballBuilderGroupAllPoints extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  TrackballBuilderGroupAllPoints({Key? key}) : super(key: key);

  @override
  _TrackballBuilderGroupAllPointsState createState() => _TrackballBuilderGroupAllPointsState();
}

class _TrackballBuilderGroupAllPointsState extends State<TrackballBuilderGroupAllPoints> {
  @override
  void initState() {
    super.initState();
  }

  List<ChartSampleData> data = <ChartSampleData>[
    ChartSampleData(
      'Food',
      55,
      40,
      45,
      48,
    ),
    ChartSampleData(
      'Transport',
      33,
      45,
      54,
      28,
    ),
    ChartSampleData(
      'Medical',
      43,
      23,
      20,
      34,
    ),
    ChartSampleData(
      'Clothes',
      32,
      54,
      23,
      54,
    ),
    ChartSampleData(
      'Books',
      56,
      18,
      43,
      55,
    ),
    ChartSampleData(
      'Others',
      23,
      54,
      33,
      56,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: Column(children: [
          //Initialize the chart widget
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Half yearly sales analysis'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip

              trackballBehavior: TrackballBehavior(
                enable: true,
                activationMode: ActivationMode.singleTap,
                tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                builder:
                    (BuildContext context, TrackballDetails trackballDetails) {
                  final grouping = trackballDetails.groupingModeInfo;
                  if (grouping == null) {
                    return const SizedBox.shrink();
                  }

                  final points = grouping.points;
                  final seriesList = grouping.visibleSeriesList;

                  if (points.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final firstPoint = points.first;
                  final xVal = firstPoint.x;
                  final headerText = xVal?.toString() ?? '';

                  final rowWidgets = <Widget>[];
                  double maxWidth = 0;
                  double totalHeight = 0;

                  // Header
                  final headerSize = measureText(
                    headerText,
                    const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  );
                  maxWidth = headerSize.width;
                  totalHeight += headerSize.height + 16; // Add padding

                  // Divider height
                  totalHeight += 2;

                  // Rows
                  for (int i = 0; i < points.length; i++) {
                    final CartesianChartPoint point = points[i];
                    final dynamic series =
                        i < seriesList.length ? seriesList[i] : null;

                    final seriesName = (series?.name ?? '').toString();
                    final seriesColor = Colors.grey;

                    final yVal = point.y;
                    if (yVal == null) continue;

                    String displayValue = '${yVal.toStringAsFixed(0)}%';

                    // Build the widget
                    final trackballItemWidget = _buildTrackballItem(
                        seriesName, displayValue, seriesColor);

                    // Measure the trackball item
                    final trackballItemText = '$seriesName: $displayValue';
                    final itemSize = measureText(
                      trackballItemText,
                      const TextStyle(color: Colors.white),
                    );

                    maxWidth = max(maxWidth,
                        itemSize.width + 14); // Adjust width with padding
                    totalHeight +=
                        itemSize.height + 6; // Add spacing between rows
                    rowWidgets.add(trackballItemWidget);
                  }

                  // Final adjustment
                  maxWidth += 16; // Padding for container
                  totalHeight += 8; // Bottom padding

                  return Container(
                    width: maxWidth,
                    height: totalHeight,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          headerText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(color: Colors.white54),
                        ...rowWidgets,
                      ],
                    ),
                  );
                },
              ),
              series: <CartesianSeries<ChartSampleData, String>>[
                StackedColumnSeries<ChartSampleData, String>(
                    dataSource: data,
                    xValueMapper: (ChartSampleData sales, _) => sales.x,
                    yValueMapper: (ChartSampleData sales, _) => sales.yValue,
                    name: 'John',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true)),
                StackedColumnSeries<ChartSampleData, String>(
                    dataSource: data,
                    xValueMapper: (ChartSampleData sales, _) => sales.x,
                    yValueMapper: (ChartSampleData sales, _) => sales.yValue,
                    name: 'farah',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true)),
                StackedColumnSeries<ChartSampleData, String>(
                    dataSource: data,
                    xValueMapper: (ChartSampleData sales, _) => sales.x,
                    yValueMapper: (ChartSampleData sales, _) =>
                        sales.thirdSeriesYValue,
                    name: 'joe',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true)),
              ]),
        ]));
  }
}

class ChartSampleData {
  ChartSampleData(this.x, this.y, this.yValue, this.secondSeriesYValue,
      this.thirdSeriesYValue);

  final String x;
  final double y;
  final double yValue;
  final double secondSeriesYValue;
  final double thirdSeriesYValue;
}

Widget _buildTrackballItem(String title, String value, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$title: $value',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}
