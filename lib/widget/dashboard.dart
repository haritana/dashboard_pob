import 'dart:async';

import 'package:dashboard_pob/data/pob_tracker.dart';
import 'package:dashboard_pob/model/cardholder_model.dart';
import 'package:dashboard_pob/model/daily_chart.dart';
import 'package:dashboard_pob/model/event_cardholder.dart';
import 'package:dashboard_pob/widget/activity.dart';
import 'package:dashboard_pob/widget/dialog_member.dart';
import 'package:dashboard_pob/widget/header_widget.dart';
import 'package:dashboard_pob/widget/line_chart.dart';
import 'package:flutter/material.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget(
      {required this.dailyChart, required this.event, super.key});

  final StreamController<List<DailyChart>> dailyChart;
  final StreamController<List<EventCardholder>> event;

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  StreamSubscription<List<EventCardholder>>? _eventSubscription;
  StreamSubscription<List<DailyChart>>? _dailySubscription;
  List<EventCardholder> listEvent = [];
  List<DailyChart> listDaily = [];

  final track = POBTracker();

  void listenEvent() {
    _eventSubscription =
        widget.event.stream.asBroadcastStream().listen((event) {
      setState(() {
        listEvent = event;
      });
    });

    _dailySubscription =
        widget.dailyChart.stream.asBroadcastStream().listen((daily) {
      setState(() {
        listDaily = daily;
      });
    });
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    _dailySubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    listenEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 5),
          const HeaderWidget(),
          const SizedBox(height: 10),
          ActivityDetailsCard(
              zonaCount: POBTracker.getPOBPerDoor(listEvent),
              onTap: (zone) {
                List<CardholderModel> member = [];
                member = POBTracker.getCardholderOnZoneReport(zone, listEvent);
                if (member.isNotEmpty) {
                  openDialogMember(
                      zone: zone, cardholder: member, context: context);
                }
              }),
          const SizedBox(height: 16),
          LineChartCard(
            dailyChart: listDaily,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
