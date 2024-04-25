import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:percent_indicator/percent_indicator.dart';

class avatarWidget extends StatelessWidget {
  const avatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[avatarContainer(), levelWidget()]);
  }
}

class avatarContainer extends StatelessWidget {
  const avatarContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 500,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/temp_chars.png',
              height: 300,
            ),
            Text(
              "짚신이",
              style: TextStyle(color: DARK_GREEN_COLOR, fontSize: 30),
            )
          ],
        ));
  }
}

class levelWidget extends StatelessWidget {
  const levelWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        color: OATMEAL_COLOR,
        child: Center(child: levelContainer()),
      ),
    );
  }
}

class levelContainer extends StatelessWidget {
  const levelContainer({super.key});
  final int level = 123;
  final double percentage = 0.75;
  final int remaining = 29;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Lv. " + level.toString(),
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: <Widget>[
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width * 0.7,
                  lineHeight: 14.0,
                  percent: percentage,
                  backgroundColor: Colors.white,
                  progressColor: GREEN_COLOR,
                  barRadius: Radius.circular(30),
                ),
                Text(
                  (percentage * 100).round().toString() + " %",
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Text(
                  "다음 레벨까지 ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  remaining.toString(),
                  style: TextStyle(fontSize: 20, color: GREEN_COLOR),
                ),
                Text(
                  " 남았어요!",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )
          ],
        ));
  }
}
