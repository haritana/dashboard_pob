import 'package:dashboard_pob/const/constanta.dart';
import 'package:dashboard_pob/data/daily_chart.dart';
import 'package:dashboard_pob/model/daily_chart.dart';
import 'package:dashboard_pob/widget/custom_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartCard extends StatelessWidget {
  const LineChartCard({required this.dailyChart, super.key});

  final List<DailyChart> dailyChart;

  @override
  Widget build(BuildContext context) {
    final data = DailyChartConverter.drawChartDaily(dailyChart);
  
    return CustomCard(
      child: dailyChart.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Daily Personal on Boarding", style: titleStyle),
                const SizedBox(height: 30),
                AspectRatio(
                  aspectRatio: 16 / 6,
                  child: LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(
                        handleBuiltInTouches: true,
                      ),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return data.bottomLabel[value.toInt()] != null
                                  ? SideTitleWidget(
                                      fitInside: SideTitleFitInsideData(
                                          enabled: true,
                                          axisPosition: value,
                                          parentAxisSize: meta.parentAxisSize,
                                          distanceFromEdge: value),
                                      meta: meta,
                                      space: 5,
                                      angle: -3.14 / 6,
                                      child: Text(
                                          data.bottomLabel[value.toInt()]
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[400])),
                                    )
                                  : const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return data.leftLabel[value.toInt()] != null
                                  ? Text(
                                      data.leftLabel[value.toInt()].toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[400]))
                                  : const SizedBox();
                            },
                            showTitles: true,
                            interval: 50,
                            reservedSize: 40,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          color: selectionColor,
                          barWidth: 2.5,
                          belowBarData: BarAreaData(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [selectionColor, Colors.transparent],
                            ),
                            show: true,
                          ),
                          dotData: FlDotData(show: false),
                          spots: data.spot,
                        ),
                        LineChartBarData(
                          color: selectionColor,
                          barWidth: 2.5,
                          belowBarData: BarAreaData(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [selectionColor, Colors.transparent],
                            ),
                            show: true,
                          ),
                          dotData: FlDotData(show: false),
                          spots: data.spot,
                        )
                      ],
                      minX: 0,
                      maxX: 30,
                      maxY: maxYChart.toDouble(),
                      minY: -5,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
