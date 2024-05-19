import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TimeBar extends StatefulWidget{
  // final double dist;
  // const ProgressBar({super.key, required this.dist});
  final int initialTime;
  final double elapsedTime;

  const TimeBar({super.key, required this.initialTime, required this.elapsedTime});

  @override
  State<TimeBar> createState() => TimebarState();
}

class TimebarState extends State<TimeBar>{
  @override
  Widget build(BuildContext context) {
    double percent = 0.0;
    // double percent = 0.15;
    if (widget.initialTime > 0) {
      double totalInitialTimeInSeconds = widget.initialTime * 60.0;
      percent = widget.elapsedTime / totalInitialTimeInSeconds;
      print('total $totalInitialTimeInSeconds');
      print('소요 시간 ${widget.elapsedTime}');
      // percent = (totalInitialTimeInSeconds - widget.elapsedTime) / totalInitialTimeInSeconds;
      percent = percent.clamp(0.0, 1.0); // 계산된 퍼센트를 0과 1 사이로 제한합니다.
    }

    return Column(
        children: [
        Container(
          alignment: FractionalOffset(percent, 1 - percent),
          child: FractionallySizedBox(
            child: Image.asset('assets/images/run_clock.png', width: 20)),
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