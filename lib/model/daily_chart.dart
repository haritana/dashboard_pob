import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';

List<DailyChart> dailyChartFromJson(String str) => List<DailyChart>.from(json
    .decode(str)
    .cast<Map<String, dynamic>>()
    .map((x) => DailyChart.fromJson(x)));

String dailyChartToJson(List<DailyChart> data) =>
    json.encode(data.map((x) => x.toJson()).toList());

List<DailyChart> listChartDecode(List<dynamic> respon) =>
    respon.map((x) => DailyChart.fromJson(x)).toList();

class DailyChart {
  final int id;
  final String date;
  final int total;

  DailyChart({
    required this.id,
    required this.date,
    required this.total,
  });

  factory DailyChart.fromJson(Map<String, dynamic> json) => DailyChart(
        id: json["id"],
        date: json["date"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "total": total,
      };
}

class DrawChartDaily {
  const DrawChartDaily({
    required this.spot,
    required this.leftLabel,
    required this.bottomLabel,
  });
  final List<FlSpot> spot;
  final Map<int, String> leftLabel;
  final Map<int, String> bottomLabel;
}
