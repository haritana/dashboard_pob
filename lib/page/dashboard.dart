import 'dart:async';
import 'dart:developer';

import 'package:dashboard_pob/const/constanta.dart';
import 'package:dashboard_pob/core/socket_service.dart';
import 'package:dashboard_pob/data/pob_sync.dart';
import 'package:dashboard_pob/model/daily_chart.dart';
import 'package:dashboard_pob/model/event_cardholder.dart';
import 'package:dashboard_pob/widget/dashboard.dart';
import 'package:dashboard_pob/widget/pob_summary.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({required this.title, super.key});

  final String title;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final StreamController<List<DailyChart>> _chartController =
      StreamController.broadcast();

  final StreamController<List<EventCardholder>> _eventController =
      StreamController.broadcast();

  StreamController<Map<String, int>> pobZone = StreamController.broadcast();
  void listeningSocket() async {
    SocketService.on('chart', (eDaily) {
      try {
        if (eDaily != null) {
          var result = listChartDecode(eDaily);
          _chartController.add(result);
        } else {
          _chartController.add([]);
        }
      } catch (e, stack) {
        log('Error handling eventCard: $e\n$stack');
      }
    });

    SocketService.on('eventCard', (data) {
      try {
        if (data != null) {
          var result = listEventCardholder(data as List<dynamic>);
          _eventController.add(result);
          CalculationPob.getPOBPerDoor(result);
        } else {
          _eventController.add([]);
        }
      } catch (e, stack) {
        log('Error handling eventCard: $e\n$stack');
      }
    });
  }

  @override
  void initState() {
    SocketService.init();
    listeningSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: DashboardWidget(
                  event: _eventController, dailyChart: _chartController),
            ),
            Expanded(
              flex: 3,
              child: POBSummaryWidget(
                event: _eventController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
