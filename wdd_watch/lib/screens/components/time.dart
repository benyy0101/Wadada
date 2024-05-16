import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wadada/commons/const/colors.dart';
import 'package:watch_connectivity/watch_connectivity.dart';


class runTime extends StatefulWidget {
  const runTime({
    super.key
  });

  @override
  State<runTime> createState() => _runTimeState();
}

class _runTimeState extends State<runTime> {
  String hours = "00";
  String minutes = "00";
  String seconds = "00"; 
  final _watch = WatchConnectivity();
  final _supported = false;
  final _paired = false;
  final _reachable = false;
  final MethodChannel channel = const MethodChannel('watch_connectivity');

  @override
  void initState() {
    super.initState();
    _initWear();

  }

  void _initWear() {
    _watch.messageStream.listen(
      (message) => setState(
        () {
          if (message.containsKey('formattedHours')) {
            hours = message['formattedHours'].toString();
            print(hours);
          }
          if (message.containsKey('formattedMinutes')) {
            minutes = message['formattedMinutes'].toString();
            print(minutes);
          }
          if (message.containsKey('formattedSeconds')) {
            seconds = message['formattedSeconds'].toString();
            print(seconds);
          }
        },
      ),
    );
  }

  void setTimeValue(String HourValue, MinuteValue, SecondValue) {
    print('시간 업데이트 : $HourValue $MinuteValue $SecondValue');
    setState(() {
      hours = HourValue;
      minutes = MinuteValue;
      seconds = SecondValue;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            Text(
              "달린 시간",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),


            // countdown  값 받아오기
            Text(
              "$hours:$minutes:$seconds",
              style: const TextStyle(color: GREEN_COLOR, fontSize: 35, fontWeight: FontWeight.bold)),
          ],
        ),
      )
    );
  }
}
