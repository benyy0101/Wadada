import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wadada/commons/const/colors.dart';
import 'package:wadada/constants.dart';
import 'package:watch_connectivity/watch_connectivity.dart';


class runPace extends StatefulWidget {
  // final String pace;
  const runPace({
    super.key
  });

  @override
  _runPaceState createState() => _runPaceState();
}

class _runPaceState extends State<runPace> {
  String pace = "0'00''"; // 초기 페이스값 설정하고
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
          if (message.containsKey('formattedPace')) {
            pace = message['formattedPace'].toString();
            print(pace);
          }
        },
      ),
    );
  }


  void setPaceValue(String newValue) {
    print('페이스 값 업데이트 : $newValue');
    setState(() {
      pace = newValue;
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
              "페이스",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 5),

            
            // countdown  값 받아오기
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                const Icon(
                  Icons.speed,
                  size: 35,
                  color: GREEN_COLOR,
                ),

                const SizedBox(width: 5),

                // pace  값 받아오기
                Text(
                  pace,
                  style: const TextStyle(color: GREEN_COLOR, fontSize: 35, fontWeight: FontWeight.bold)
                ),
  
              ],

            )
          ],
        ),
      )
    );
  }
}
