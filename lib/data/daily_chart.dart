import 'package:dashboard_pob/const/constanta.dart';
import 'package:dashboard_pob/model/daily_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart' as intl;

class DailyChartConverter {
  static DrawChartDaily drawChartDaily(List<DailyChart> dataChart) {
    Map<int, String> bottomLabel = {};
    List<FlSpot> spot = [];

    String formattedDate(String date) =>
        intl.DateFormat('dd-MMM').format(DateTime.parse(date));

    for (int i = 0; i < dataChart.length; i++) {
      spot.add(FlSpot((i + 1).toDouble(), dataChart[i].total.toDouble()));
      bottomLabel[i] = formattedDate(dataChart[i].date);
    }
    return DrawChartDaily(
        spot: spot, leftLabel: leftLabel, bottomLabel: bottomLabel);
  }
}
