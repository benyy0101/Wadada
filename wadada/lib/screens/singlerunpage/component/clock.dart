import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class Clock extends StatefulWidget {
  final int time;
  final ValueNotifier<Duration> elapsedTimeNotifier;
  final VoidCallback onTimerEnd;
  const Clock({
    super.key,
    required this.time,
    required this.elapsedTimeNotifier,
    required this.onTimerEnd,
  });

  @override
  State<Clock> createState() => ClockState();
}

class ClockState extends State<Clock> {
  Duration _elapsed = Duration.zero;
  ValueNotifier<Duration> elapsedTimeNotifier =
      ValueNotifier<Duration>(Duration.zero);
  ValueNotifier<Duration> endTimeNotifier = ValueNotifier(Duration.zero);
  Duration get elapsed => _elapsed;
  bool _isRunning = false;

  List<String> savetimes = [];
  late Timer _timer;

  // 워치랑
  final WatchConnectivityBase _watch = WatchConnectivity();
  final MethodChannel channel = MethodChannel('watch_connectivity');
  // var _supported = false;
  // var _paired = false;
  // var _reachable = false;
  bool _connected = false;
  final _log = <String>[];

  @override
  void initState() {
    super.initState();

    print('시간 ${widget.time}');
    // 넘어온 값 0 이상이면 타이머
    if (widget.time > 0) {
      int timerDurationInSeconds = (widget.time * 60).round();
      _elapsed = Duration(seconds: timerDurationInSeconds);

      _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        if (_isRunning) {
          setState(() {
            _elapsed -= Duration(milliseconds: 100);

            if (_elapsed <= Duration.zero) {
              _isRunning = false;
              _timer.cancel();
              _elapsed = Duration.zero;
              widget.onTimerEnd();
            }
          });
        }
      });
    } else {
      // 넘어온 값 0이면 스톱워치
      _timer = Timer.periodic(Duration(milliseconds: 100), _onTick);
    }

    initPlatformState();
    // 워치 초기화
    // _initWear();

    //
  }

  // 워치 관련코드
  void _initWear() {
    _watch.messageStream.listen((message) => setState(() {
          _connected = true;
        }));
  }

  // sendMessage  워치한테 보내는 함수(실행해야 메세지가 전송됨 -> 주기적으로 호출)
  void sendMessage(formattedHours, formattedMinutes, formattedSeconds) {
    final message = {
      'formattedHours': formattedHours,
      'formattedMinutes': formattedMinutes,
      'formattedSeconds': formattedSeconds,
    };
    _watch.sendMessage(message);
    setState(() => _log.add('메세지: $message'));
  }

  // void sendContext(formattedHours, formattedMinutes, formattedSeconds) {
  //   final context = {
  //     'formattedHours': formattedHours,
  //     'formattedMinutes': formattedMinutes,
  //     'formattedSeconds': formattedSeconds,
  //   };
  //   _watch.updateApplicationContext(context);
  //   setState(() => _log.add('보내진 context: $context'));
  // }

  void initPlatformState() async {
    // _supported = await _watch.isSupported;
    // _paired = await _watch.isPaired;
    // _reachable = await _watch.isReachable;
    setState(() {});
  }

  void start() {
    setState(() {
      _isRunning = true;
    });
  }

  void setRunning(bool isRunning) {
    print('setRunning called with: $isRunning');
    setState(() {
      _isRunning = isRunning;
    });
    print('_isRunning state is now: $_isRunning');
  }

  double getElapsedSeconds() {
    if (widget.time > 0) {
      return (widget.time * 60) - _elapsed.inSeconds.toDouble();
    } else {
      return _elapsed.inSeconds.toDouble();
    }
  }

  @override
  void dispose() {
    print('Clock dispose called');
    _timer.cancel();
    super.dispose();
  }

  void _onTick(Timer timer) {
    if (_isRunning) {
      // setState(() {
      //   _elapsed += Duration(milliseconds: 100);
      //   elapsedTimeNotifier.value = _elapsed;
      // });

      setState(() {
        if (widget.time > 0) {
          _elapsed -= Duration(milliseconds: 100);
          if (_elapsed <= Duration.zero) {
            _isRunning = false;
            _elapsed = Duration.zero;
            _timer.cancel();
            widget.onTimerEnd();
          }
        } else {
          _elapsed += Duration(milliseconds: 100);
        }
        widget.elapsedTimeNotifier.value = _elapsed;

        // 시간, 분, 초 업데이트 메소드 호출
        sendTimeUpdate();
      });
    }
  }

  // 시간, 분, 초 업데이트
  void sendTimeUpdate() {
    final hours = _elapsed.inHours.toString().padLeft(2, '0');
    final minutes = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    // sendMessage 호출
    // sendMessage(hours, minutes, seconds);
  }

  String _formatTime(int value) {
    return value.toString().padLeft(2, '0');
  }

  List<String> _splitTime(String timePart) {
    return timePart.split('');
  }

  Widget TimeContainer(String digit) {
    return Container(
      decoration: BoxDecoration(
        color: OATMEAL_COLOR,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 43,
      height: 60,
      child: Center(
        child: Text(
          digit,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: GREEN_COLOR,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int hours = _elapsed.inHours % 24;
    int minutes = _elapsed.inMinutes % 60;
    int seconds = _elapsed.inSeconds % 60;

    String formattedHours = _formatTime(hours);
    String formattedMinutes = _formatTime(minutes);
    String formattedSeconds = _formatTime(seconds);

    List<String> splithours = _splitTime(formattedHours);
    List<String> splitminutes = _splitTime(formattedMinutes);
    List<String> splitseconds = _splitTime(formattedSeconds);

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        children: [
          TimeContainer(splithours[0]),
          SizedBox(width: 5),
          TimeContainer(splithours[1]),
          SizedBox(width: 7),
          Text(':',
              style: TextStyle(
                  color: GREEN_COLOR,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          SizedBox(width: 7),
          TimeContainer(splitminutes[0]),
          SizedBox(width: 5),
          TimeContainer(splitminutes[1]),
          SizedBox(width: 7),
          Text(':',
              style: TextStyle(
                  color: GREEN_COLOR,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          SizedBox(width: 7),
          TimeContainer(splitseconds[0]),
          SizedBox(width: 5),
          TimeContainer(splitseconds[1]),
        ],
      ),
    );
  }
}
