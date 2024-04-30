import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:intl/intl.dart';

class chartData {
  chartData(this.distance, this.numerics);
  final int distance;
  final double numerics;
}

class LineChart<T extends chartData> extends StatelessWidget {
  final List<T> chartData;
  final String metrics;
  LineChart({
    super.key,
    required this.chartData,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: OATMEAL_COLOR,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 0,
              blurRadius: 5.0,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: SfCartesianChart(
            primaryXAxis: NumericAxis(
              majorGridLines: MajorGridLines(color: Colors.transparent),
              numberFormat: NumberFormat('### km'),
            ),
            primaryYAxis: NumericAxis(
                numberFormat: NumberFormat('### $metrics'),
                rangePadding: ChartRangePadding.additional,
                //Aligns the y-axis labels
                anchorRangeToVisiblePoints: false),
            backgroundColor: OATMEAL_COLOR,
            palette: [
              GREEN_COLOR
            ],
            series: <CartesianSeries>[
              // Renders line chart
              LineSeries<T, int>(
                  dataSource: chartData,
                  xValueMapper: (data, _) => data.distance,
                  yValueMapper: (data, _) => data.numerics)
            ]),
      ),
    );
  }
}
