import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';

class DistBar extends StatefulWidget{
  // final double dist;
  // const ProgressBar({super.key, required this.dist});
  final int dist;
  final double formattedDistance;

  const DistBar({super.key, required this.dist, required this.formattedDistance});

  @override
  State<DistBar> createState() => ProgressBarState();
}

class ProgressBarState extends State<DistBar>{

  @override
  Widget build(BuildContext context) {
    // double percent = 0.15;
    double percent = min(widget.formattedDistance / widget.dist, 1.0);

    return Column(
        children: [
        Container(
          alignment: FractionalOffset(percent, 1 - percent),
          child: FractionallySizedBox(
            child: Image.asset('assets/images/running.png', width: 20)),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearPercentIndicator(
            padding: EdgeInsets.zero,
            percent: percent,
            lineHeight: 10,
            backgroundColor: Color(0xffF6F4E9),
            progressColor: GREEN_COLOR,
            barRadius: Radius.circular(20),
          ),
        ),
      ],
    );
  }
}