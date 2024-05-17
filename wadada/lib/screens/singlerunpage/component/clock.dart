import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';

class Clock extends StatefulWidget{
  final int time;
  final ValueNotifier<Duration> elapsedTimeNotifier;
  final VoidCallback onTimerEnd;
  const Clock({super.key, required this.time, required this.elapsedTimeNotifier, required this.onTimerEnd,});

  @override
  State<Clock> createState() => ClockState();
}

class ClockState extends State<Clock> {
  Duration _elapsed = Duration.zero;
  ValueNotifier<Duration> elapsedTimeNotifier = ValueNotifier<Duration>(Duration.zero);
  ValueNotifier<Duration> endTimeNotifier = ValueNotifier(Duration.zero);
  Duration get elapsed => _elapsed;
  bool _isRunning = false;
  
  List<String> savetimes = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();

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
            });
    }
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
      width: 54,
      height: 65,
      child: Center(
        child: Text(digit,
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

    return Container(
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
              fontWeight: FontWeight.bold
            )
          ),
          SizedBox(width: 7),
          
          TimeContainer(splitminutes[0]),
          SizedBox(width: 5),
          TimeContainer(splitminutes[1]),

          SizedBox(width: 7),
          Text(':',
            style: TextStyle(
              color: GREEN_COLOR,
              fontSize: 30, 
              fontWeight: FontWeight.bold
            )
          ),
          SizedBox(width: 7),

          TimeContainer(splitseconds[0]),
          SizedBox(width: 5),
          TimeContainer(splitseconds[1]),
        ],
      ),
    );
  }
}