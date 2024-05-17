import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:intl/intl.dart';

class ChartData {
  ChartData(this.distance, this.numerics);

  final double distance;
  final double numerics;

  Map<String, dynamic> toJson() {
    return {
      'distance': distance,
      'numerics': numerics,
    };
  }

  factory ChartData.fromJson(Map<String, dynamic> json) {
    if (json['speed']) {
      return ChartData(
        json['dist'] as double,
        json['speed'] as double,
      );
    } else if (json['pace']) {
      return ChartData(
        json['dist'] as double,
        json['pace'] as double,
      );
    } else {
      return ChartData(
      json['dist'] as double,
      json['heartrate'] as double,
      );
    }
  }
}

class LineChart<T extends ChartData> extends StatelessWidget {
  final List<T> chartData;
  final String metrics;
  final String graphType;
  const LineChart({
    super.key,
    required this.chartData,
    required this.metrics,
    required this.graphType,
  });

  @override
  Widget build(BuildContext context) {
    // double maxDist = chartData.map((data) => data.distance).reduce((a, b) => a > b ? a : b);

    // double interval;
    // if (maxDist <= 5.0) {
    //   interval = 0.5;
    // } else {
    //   interval = 1.0;
    // }

    String formatTime(double timeInMinutes) {
      int minutes = timeInMinutes.floor();
      int seconds = ((timeInMinutes - minutes) * 60).round();
      return "$minutes'${seconds.toString().padLeft(2, '0')}''";
    }

    yValueMapper(data, _) => data.numerics;
    final yAxisFormatter = graphType == 'pace'
        ? (axisLabelRenderArgs) {
            final value = axisLabelRenderArgs.value.toDouble();
            final formattedTime = formatTime(value);
            return ChartAxisLabel(
              formattedTime,
              TextStyle(
                fontSize: 12,
                // fontWeight: FontWeight.bold,
                // color: Colors.black,
              ),
            );
          }
        : null;

    return Center(
        child: Container(
      height: 210,
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: OATMEAL_COLOR,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 3.0,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: SfCartesianChart(
        primaryXAxis: NumericAxis(
          majorGridLines: MajorGridLines(color: Colors.transparent),
          numberFormat: NumberFormat('0.0 km'),
          interval: 0.5,
        ),
        primaryYAxis: NumericAxis(
          rangePadding: ChartRangePadding.additional,
          minimum: 0,
          axisLabelFormatter: yAxisFormatter,
        ),
        backgroundColor: OATMEAL_COLOR,
        palette: const [
          GREEN_COLOR,
        ],
        series: <CartesianSeries>[
          LineSeries<T, double>(
              dataSource: chartData,
              xValueMapper: (T data, int _) => data.distance,
              yValueMapper: (T data, int _) => data.numerics),
        ],
      ),
    ));
  }
}
