import 'package:flutter/material.dart';
import 'package:wadada/common/component/lineChart.dart';

class MyRecords extends StatelessWidget {
  const MyRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [LineChart()],
      ),
    );
  }
}
