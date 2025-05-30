import 'package:fl_chart/fl_chart.dart';

class POBDonutGraphData {
  const POBDonutGraphData({
    required this.total,
    required this.pieChart,
  });

  final int total;
  final List<PieChartSectionData> pieChart;
}
