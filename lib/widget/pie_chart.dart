import 'package:dashboard_pob/const/constanta.dart';
import 'package:dashboard_pob/data/pob_tracker.dart';
import 'package:dashboard_pob/model/donut_graph.dart';
import 'package:dashboard_pob/model/event_cardholder.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  const Chart({required this.listEvent, super.key});

  final List<EventCardholder> listEvent;

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  POBDonutGraphData pieChart() {
    final totalPob = POBTracker.pobNotifier.value;
    final data = POBTracker.staticDoors;

    return POBDonutGraphData(total: totalPob, pieChart: [
      PieChartSectionData(
        color: officeColor,
        value: double.parse('${data[officeDoor]}'),
        showTitle: false,
        radius: 30,
      ),
      PieChartSectionData(
        color: orfColor,
        value: double.parse('${data[orfDoor]}'),
        showTitle: false,
        radius: 14,
      ),
      PieChartSectionData(
        color: orfCCRColor,
        value: double.parse('${data[ccrDoor]}'),
        showTitle: false,
        radius: 18,
      ),
      PieChartSectionData(
        color: orfServerColor,
        value: double.parse('${data[serverORFDoor]}'),
        showTitle: false,
        radius: 16,
      ),
      PieChartSectionData(
        color: officeServerColor,
        value: double.parse('${data[serverOfficeDoor]}'),
        showTitle: false,
        radius: 18,
      ),
      PieChartSectionData(
        color: officeCROColor,
        value: double.parse('${data[croDoor]}'),
        showTitle: false,
        radius: 20,
      ),
      PieChartSectionData(
        color: portalColor,
        value: double.parse('${data[portalDoor]}'),
        showTitle: false,
        radius: 25,
      ),
    ]);
  }

  //String totalPOB = '0';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: pieChart().pieChart,
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                '${pieChart().total}',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      height: 0.5,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
