import 'package:flutter/material.dart';
import 'package:wadada/common/component/lineChart.dart';

class temp extends chartData {
  temp(super.distance, super.numerics);
}

class MyRecords extends StatelessWidget {
  final List<temp> chartData = [
    temp(12, 160),
    temp(13, 150),
    temp(14, 120),
    temp(15, 80),
    temp(16, 110)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: LineChart(
        chartData: chartData,
        metrics: 'hz',
      )),
    );
  }
}
