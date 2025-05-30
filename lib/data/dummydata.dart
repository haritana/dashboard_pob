import 'dart:convert';

import 'package:dashboard_pob/const/constanta.dart';
import 'package:dashboard_pob/model/card_zone.dart';
import 'package:dashboard_pob/model/cardholder_model.dart';
import 'package:dashboard_pob/model/daily_chart.dart';
import 'package:dashboard_pob/model/donut_graph.dart';
import 'package:dashboard_pob/model/event_cardholder.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';

// class CardZonaDetails {
final fakeZonaModel = const [
  CardZonaModel(value: "100", title: "Office Area", color: yellowZone),
  CardZonaModel(value: "5", title: "Server Office", color: redZone),
  CardZonaModel(value: "35", title: "CRO", color: redZone),
  CardZonaModel(value: "50", title: "ORF Area", color: yellowZone),
  CardZonaModel(value: "10", title: "CCR Area", color: redZone),
  CardZonaModel(value: "1", title: "Server Area", color: redZone),
];
// }

class GraphModel {
  final double x;
  final double y;

  const GraphModel({required this.x, required this.y});
}

class BarGraphModel {
  final String label;
  final Color color;
  final List<GraphModel> graph;

  const BarGraphModel(
      {required this.label, required this.color, required this.graph});
}

class ScheduledModel {
  final String title;
  final String date;

  const ScheduledModel({required this.title, required this.date});
}

class LineData {
  final spots = const [
    FlSpot(1.0, 80.0), FlSpot(2.0, 110.0), FlSpot(3.0, 100.0),
    FlSpot(4.0, 120.0), FlSpot(5.0, 90.0), FlSpot(6.0, 80.0),
    FlSpot(7.0, 110.0), FlSpot(8.0, 100.0),
    FlSpot(9.0, 120.0), FlSpot(10.0, 90.0), FlSpot(11.0, 80.0),
    FlSpot(12.0, 110.0), FlSpot(13.0, 100.0),
    FlSpot(14.0, 120.0), FlSpot(15.0, 90.0), FlSpot(16.0, 80.0),
    FlSpot(17.0, 110.0), FlSpot(18.0, 200.0),
    FlSpot(19.0, 120.0), FlSpot(20.0, 90.0), FlSpot(21.0, 80.0),
    FlSpot(22.0, 110.0), FlSpot(23.0, 100.0),
    FlSpot(24.0, 120.0), FlSpot(25.0, 90.0), FlSpot(26.0, 80.0),
    FlSpot(27.0, 110.0), FlSpot(28.0, 100.0),
    FlSpot(29.0, 120.0), FlSpot(30.0, 200.0),

    // FlSpot(1.68, 21.04),
    // FlSpot(2.84, 26.23),
    // FlSpot(5.19, 19.82),
    // FlSpot(6.01, 24.49),
    // FlSpot(7.81, 19.82),
    // FlSpot(9.49, 23.50),
    // FlSpot(12.26, 19.57),
    // FlSpot(15.63, 20.90),
    // FlSpot(20.39, 39.20),
    // FlSpot(23.69, 75.62),
    // FlSpot(26.21, 46.58),
    // FlSpot(29.87, 42.97),
    // FlSpot(32.49, 46.54),
    // FlSpot(35.09, 40.72),
    // FlSpot(38.74, 43.18),
    // FlSpot(41.47, 59.91),
    // FlSpot(43.12, 53.18),
    // FlSpot(46.30, 91.10),
    // FlSpot(47.88, 81.59),
    // FlSpot(51.71, 75.53),
    // FlSpot(54.21, 78.95),
    // FlSpot(55.23, 86.94),
    // FlSpot(57.40, 78.98),
    // FlSpot(60.49, 74.38),
    // FlSpot(64.30, 48.34),
    // FlSpot(67.17, 70.74),
    // FlSpot(70.35, 75.43),
    // FlSpot(73.39, 69.88),
    // FlSpot(75.87, 80.04),
    // FlSpot(77.32, 74.38),
    // FlSpot(81.43, 68.43),
    // FlSpot(86.12, 69.45),
    // FlSpot(90.06, 78.60),
    // FlSpot(94.68, 46.05),
    // FlSpot(98.35, 42.80),
    // FlSpot(101.25, 53.05),
    // FlSpot(103.07, 46.06),
    // FlSpot(106.65, 42.31),
    // FlSpot(108.20, 32.64),
    // FlSpot(110.40, 45.14),
    // FlSpot(114.24, 53.27),
    // FlSpot(116.60, 42.13),
    // FlSpot(118.52, 57.60),
  ];

  final leftTitle = {
    0: '0',
    50: '50',
    100: '100',
    150: '150',
    200: '200',
    250: '250'
  };
  final bottomTitle = {
    0: '1 Jan',
    1: '2 Jan',
    2: '3 Jan',
    3: '4 Jan',
    4: '5 Jan',
    5: '6 Jan',
    6: '7 Jan',
    7: '8 Jan',
    8: '9 Jan',
    9: '10 Jan',
    10: '1 Feb',
    11: '2 Feb',
    12: '3 Feb',
    13: '4 Feb',
    14: '5 Feb',
    15: '6 Feb',
    16: '7 Feb',
    17: '8 Feb',
    18: '9 Feb',
    19: '10 Feb',
    20: '1 Mar',
    21: '2 Mar',
    22: '3 Mar',
    23: '4 Mar',
    24: '5 Mar',
    25: '6 Mar',
    26: '7 Mar',
    27: '8 Mar',
    28: '9 Mar',
    29: '10 Mar',
    30: '11 Mar',
    //1: 'Feb',
    // 20: 'Mar',
    // 30: 'Apr',
    // 40: 'May',
    // 50: 'Jun',
    // 60: 'Jul',
    // 70: 'Aug',
    // 80: 'Sep',
    // 90: 'Oct',
    // 100: 'Nov',
    // 110: 'Dec',
    // 111: 'Dec1',
  };
}

class BarGraphData {
  final data = [
    const BarGraphModel(
        label: "Activity Level",
        color: Color(0xFFFEB95A),
        graph: [
          GraphModel(x: 0, y: 8),
          GraphModel(x: 1, y: 10),
          GraphModel(x: 2, y: 7),
          GraphModel(x: 3, y: 4),
          GraphModel(x: 4, y: 4),
          GraphModel(x: 5, y: 6),
        ]),
    const BarGraphModel(label: "Nutrition", color: Color(0xFFF2C8ED), graph: [
      GraphModel(x: 0, y: 8),
      GraphModel(x: 1, y: 10),
      GraphModel(x: 2, y: 9),
      GraphModel(x: 3, y: 6),
      GraphModel(x: 4, y: 6),
      GraphModel(x: 5, y: 7),
    ]),
    const BarGraphModel(
        label: "Hydration Level",
        color: Color(0xFF20AEF3),
        graph: [
          GraphModel(x: 0, y: 7),
          GraphModel(x: 1, y: 10),
          GraphModel(x: 2, y: 7),
          GraphModel(x: 3, y: 4),
          GraphModel(x: 4, y: 4),
          GraphModel(x: 5, y: 10),
        ]),
  ];

  final label = ['M', 'T', 'W', 'T', 'F', 'S'];
}

//class POBEventChartDatad {
final paiChartSelectionDatas = POBDonutGraphData(total: 55, pieChart: [
  PieChartSectionData(
    color: orfColor,
    value: 305,
    showTitle: false,
    radius: 25,
  ),
  PieChartSectionData(
    color: orfCCRColor,
    value: 20,
    showTitle: false,
    radius: 22,
  ),
  PieChartSectionData(
    color: orfServerColor,
    value: 5,
    showTitle: false,
    radius: 19,
  ),
  PieChartSectionData(
    color: officeColor,
    value: 250,
    showTitle: false,
    radius: 16,
  ),
  PieChartSectionData(
    color: officeServerColor,
    value: 5,
    showTitle: false,
    radius: 13,
  ),
  PieChartSectionData(
    color: officeCROColor,
    value: 3,
    showTitle: false,
    radius: 13,
  ),
]);
//}

class ScheduleTasksData {
  final scheduled = const [
    ScheduledModel(title: "Hatha Yoga", date: "Today, 9AM - 10AM"),
    ScheduledModel(title: "Body Combat", date: "Tomorrow, 5PM - 6PM"),
    ScheduledModel(title: "Hatha Yoga", date: "Wednesday, 9AM - 10AM"),
  ];
}

Future<List<EventCardholder>> getFakeCardholder() async {
  final response = await rootBundle.loadString('assets/data/fakejson.json');

  final result = json.decode(response);
  return result
      .map<EventCardholder>((json) => EventCardholder.fromJson(json))
      .toList();
}

Future<List<EventCardholder>> fakeJason() async => await getFakeCardholder();

final fakeCardholder = [
  CardholderModel(
      ftItemId: 154654,
      firstName: 'Rooby Haritana',
      cardNumber: '1515',
      relationCode: 0,
      company: 'PT. RSI',
      image: 'assets/image/rooby.png',
      workSchedule: '5-2',
      departement: 'ICT'),
  CardholderModel(
      ftItemId: 1234,
      firstName: 'Ronaldo',
      cardNumber: '1515123',
      relationCode: 0,
      company: 'PT. RSI 2',
      image: 'assets/image/rooby.png',
      workSchedule: '5-2',
      departement: 'ICT'),
  CardholderModel(
      ftItemId: 123,
      firstName: 'Mohammad Salah',
      cardNumber: '1515',
      relationCode: 0,
      company: 'PT. RSI 3',
      image: 'assets/image/rooby.png',
      workSchedule: '5-2',
      departement: 'ICT'),
];

final dec = jsonEncode(mapDaily);

final fakeDaily = dailyChartFromJson(dec);

List<Map<String, dynamic>> mapDaily = [
  {"id": 1, "date": "2025-03-01T03:45:00.018Z", "total": 110},
  {"id": 2, "date": "2025-03-02T03:50:00.759Z", "total": 123},
  {"id": 3, "date": "2025-03-03T03:55:00.366Z", "total": 125},
  {"id": 4, "date": "2025-03-04T04:00:00.857Z", "total": 135},
  {"id": 5, "date": "2025-03-05T04:05:00.334Z", "total": 132},
  {"id": 6, "date": "2025-03-06T04:15:00.571Z", "total": 135},
  {"id": 7, "date": "2025-03-07T04:20:00.433Z", "total": 153},
  {"id": 8, "date": "2025-03-08T04:25:00.045Z", "total": 121},
  {"id": 9, "date": "2025-03-09T04:30:00.738Z", "total": 124},
  {"id": 10, "date": "2025-03-10T04:35:00.558Z", "total": 126},
  {"id": 11, "date": "2025-03-11T04:40:00.303Z", "total": 121},
  {"id": 12, "date": "2025-03-12T04:45:00.015Z", "total": 111},
  {"id": 13, "date": "2025-03-13T04:50:00.793Z", "total": 114},
  {"id": 14, "date": "2025-03-14T04:55:00.541Z", "total": 125},
  {"id": 15, "date": "2025-03-15T05:00:00.253Z", "total": 122},
  {"id": 16, "date": "2025-03-16T05:05:00.971Z", "total": 122},
  {"id": 17, "date": "2025-03-17T05:10:00.687Z", "total": 111},
  {"id": 18, "date": "2025-03-18T05:15:00.362Z", "total": 178},
  {"id": 19, "date": "2025-03-19T05:20:00.139Z", "total": 109},
  {"id": 20, "date": "2025-03-20T05:25:00.668Z", "total": 172},
  {"id": 21, "date": "2025-03-21T05:30:00.215Z", "total": 176},
  {"id": 22, "date": "2025-03-22T05:35:00.660Z", "total": 120},
  {"id": 23, "date": "2025-03-23T05:40:00.107Z", "total": 102},
  {"id": 24, "date": "2025-03-24T05:45:00.653Z", "total": 132},
  {"id": 25, "date": "2025-04-25T01:45:00.196Z", "total": 155},
  {"id": 26, "date": "2025-04-26T02:00:00.973Z", "total": 122},
  {"id": 27, "date": "2025-04-27T02:10:00.173Z", "total": 125},
  {"id": 28, "date": "2025-04-28T06:50:00.177Z", "total": 100}
];
