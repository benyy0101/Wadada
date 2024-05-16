import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:watch_app/commons/const/colors.dart';
import 'package:watch_app/constants.dart';


class DataReceiver {
  static const platform = MethodChannel('/data_channel');

  static void startListening() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "receiveDataFromSender") {
        String formattedPace = call.arguments['formattedPace'];
        processData(formattedPace);
      }
    });
  }

  static void processData(String formattedPace) {
    // 수신된 데이터를 처리합니다.
    print("수신된 데이터: $formattedPace");
  }
}


class runPace extends StatefulWidget {
  const runPace({super.key});

  @override
  _runPaceState createState() => _runPaceState();
}

class _runPaceState extends State<runPace> {
  String paceValue = "0'00''"; // 초기 페이스값 설정하고

  // static const platformChannel = MethodChannel('com.example/data_channel');
  

  @override
  void initState() {
    super.initState();
    DataReceiver.startListening();
    // platformChannel.setMethodCallHandler(_receiveFromKotlin);
  }


  // Future<void> _receiveFromKotlin(MethodCall call) async {
  //   if (call.method == "updatePace") {
  //     final String pace = call.arguments;
  //     setPaceValue(pace);
  //   }
  // }
  

  void setPaceValue(String newValue) {
    print('페이스 값 업데이트 : $newValue');
    setState(() {
      paceValue = newValue;
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
                  paceValue,
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
