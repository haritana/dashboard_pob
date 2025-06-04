import 'dart:async';

import 'package:dashboard_pob/const/constanta.dart';
import 'package:dashboard_pob/model/event_cardholder.dart';
import 'package:dashboard_pob/widget/pie_chart.dart';
import 'package:dashboard_pob/widget/pob_detail.dart';
import 'package:dashboard_pob/widget/profile.dart';
import 'package:flutter/material.dart';

class POBSummaryWidget extends StatefulWidget {
  const POBSummaryWidget({required this.event, super.key});
  final StreamController<List<EventCardholder>> event;
  @override
  State<POBSummaryWidget> createState() => _POBSummaryWidgetState();
}

class _POBSummaryWidgetState extends State<POBSummaryWidget> {
  StreamSubscription<List<EventCardholder>>? _eventSubscription;

  List<EventCardholder> listEvent = [];
  void listenEvent() {
    _eventSubscription =
        widget.event.stream.asBroadcastStream().listen((event) {
      setState(() {
        listEvent = event;
      });
    });
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    listenEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return listEvent.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            decoration: const BoxDecoration(
              color: cardBackgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total POB',
                    style: titleStyle,
                  ),
                  SizedBox(height: 20),

                  Chart(
                    listEvent: listEvent,
                  ),
                  SummaryDetails(),
                  SizedBox(height: 16),
                  const Text(
                    "Live Personnel Data",
                    style: titleStyle,
                  ),
                  ProfileCard(cardholder: listEvent.last),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
  }
}
