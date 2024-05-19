import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wadada/commons/const/colors.dart';
import 'package:wadada/screens/components/AndroidCommunication.dart';
import 'dart:async';
import 'package:watch_connectivity/watch_connectivity.dart';

class runHeart extends StatefulWidget {
  const runHeart({super.key});

  @override
  State<runHeart> createState() => _runHeartState();
}

class _runHeartState extends State<runHeart> {

  // 코틀린에서 심박센서에서 가져온 값
  static const MethodChannel _channel = MethodChannel('com.ssafy.wadada/heart_rate');

  // 초기 심박수 일단 설정을 ??로 해두고
  String _heartRate = '??';
  // 컨트롤러 슛
  final StreamController<String> _streamController = StreamController<String>();

  // 워치앱에서 플러터앱으로 보낼 심박수 값 
  final _watch = WatchConnectivity();

  var _supported = false;
  var _paired = false;
  var _reachable = false;
  bool _connected = false;
  final _log = <String>[];

  @override
  void initState() {
    super.initState();

    // 워치센서에서 심박수 받는 것
    _channel.setMethodCallHandler(_handleMethod);
    _streamController.stream.listen((heartRate) {
      setState(() {
        _heartRate = heartRate;
      });
    });

    // 워치에서 앱으로 심박수 보내는
    // 워치 연결 상태 확인 및 세션 활성화
    // initPlatformState();
    // _initWear();
  }

  // 안드로이드 네이티브 코드에서 호출될 메서드 핸들러 (추가)
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "updateHeartRate":
        // 심박수 값을 double로 파싱해
        final double heartRateDouble = double.parse(call.arguments.toString());
        final int heartRateInt = heartRateDouble.toInt(); // 67.0 이런식으로 나오는거 거슬려서 수정
        _streamController.add(heartRateInt.toString());
        break;
    }
  }



  void sendMessage(String heartRate) {
    final message = {'heartRate': heartRate};
    _watch.sendMessage(message).then((_) {
      print("Heart rate sent: $heartRate");
    }).catchError((error) {
      print("Failed to send heart rate: $error");
    });
  }

  void sendContext(_heartRate) {
    final context = {
      '_heartRate': _heartRate,
    };
    _watch.updateApplicationContext(context);
    setState(() => _log.add('보내진 context: $context'));
  }


  // 추가 코드
  @override
  void dispose() {
    _streamController.close(); // 스트림 컨트롤러를 닫어 리소스 해제
    super.dispose();
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
            "심박수",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
          ),

          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.heart_broken,
                size: 35,
                color: GREEN_COLOR,
              ),

              const SizedBox(width: 5),

              Text(
                _heartRate, 
                style: const TextStyle(color: GREEN_COLOR, fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    ));
  }
}

