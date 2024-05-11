import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watch_app/commons/const/colors.dart';

class runHeart extends StatefulWidget {
  const runHeart({super.key});

  @override
  State<runHeart> createState() => _runHeartState();
}

class _runHeartState extends State<runHeart> {
  static const MethodChannel _channel = MethodChannel('com.example.watch_app/heart_rate');
  // 초기 심박수 일단 설정을 ??로 해두고
  String _heartRate = '??';

  @override
  void initState() {
    super.initState();
    _getHeartRate();
  }
  //     final int result = await _channel.invokeMethod('getHeartRate');

  Future<void> _getHeartRate() async {
    String heartRate;
    try {
      // MethodChannel로 심박수 데이터 요청보내고
      final double result = await _channel.invokeMethod('getHeartRate');
      heartRate = result.toString(); // 결과값 스트링으로 슛
    } on PlatformException {
      heartRate = '힝구리핑퐁';
    }

    setState(() {
      _heartRate = heartRate;
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
