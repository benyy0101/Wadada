import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:wadada/common/const/colors.dart';

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  final double sales;
}

class LineChart extends StatelessWidget {
  final List<SalesData> chartData = [
    SalesData(DateTime(2010), 35),
    SalesData(DateTime(2011), 28),
    SalesData(DateTime(2012), 34),
    SalesData(DateTime(2013), 32),
    SalesData(DateTime(2014), 40)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      child: SfCartesianChart(
          backgroundColor: OATMEAL_COLOR,
          primaryXAxis: DateTimeAxis(),
          series: <CartesianSeries>[
            // Renders line chart
            LineSeries<SalesData, DateTime>(
                dataSource: chartData,
                xValueMapper: (SalesData sales, _) => sales.year,
                yValueMapper: (SalesData sales, _) => sales.sales)
          ]),
    );
  }
}
