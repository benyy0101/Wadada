import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/singleresultpage/singleresultpage.dart';

import 'package:wadada/screens/singlerunpage/component/clock.dart';
import 'package:wadada/screens/singlerunpage/component/map.dart';
import 'package:wadada/screens/singlerunpage/component/dist_bar.dart';
import 'package:wadada/screens/singlerunpage/component/time_bar.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:dio/dio.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


class SingleFreeRun extends StatefulWidget{
  final double time;
  final double dist;
  final String appKey;
  // const SingleFreeRun({super.key, required this.time, required this.dist});
  const SingleFreeRun({super.key, required this.time, required this.dist, required this.appKey});
  
  @override
  _SingleFreeRunState createState() => _SingleFreeRunState();
}

class _SingleFreeRunState extends State<SingleFreeRun> {
  int? recordSeq;
  double totalDistance = 0.0;
  String formattedDistance = '0.00';
  final GlobalKey<ClockState> _clockKey = GlobalKey<ClockState>();
  late Clock clock;

  late MyMap myMap;

  @override
  void initState() {
    super.initState();

    myMap = MyMap(appKey: widget.appKey);

    myMap.startLocationNotifier.addListener(() {
      if (myMap.startLocation != null) {
          sendLocationToServer();
      }
    });

    clock = Clock(key: _clockKey, time: widget.time);
    _subscribeToTotalDistance();
    // sendLocationToServer();
  }

  Future<void> sendLocationToServer() async {
    final startLocation = myMap.startLocation;
    final dio = Dio();
        
    if (startLocation != null) {
      final url = Uri.parse('https://k10a704.p.ssafy.io/Single/start');

      final requestBody = jsonEncode({
        "recordStartLocation": "POINT(${startLocation.latitude} ${startLocation.longitude})"
      });
      
      try {
        final response = await dio.post(
          url.toString(),
          data: requestBody,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDUyNzIxNzM3IiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE0NjgxNTkwfQ.zvrnuEckvfBuhc7kjMDf6HYHTt8RpJIUOifcc6o1Fk8',
          }),
        );
        
        if (response.statusCode == 200) {
          // 서버 응답 성공 처리
          // final responseData = jsonDecode(response.data);
          // print('responseData type: ${responseData.runtimeType}');
          // recordSeq = responseData['recordSeq'] as int;
          recordSeq = response.data;
          print('서버 요청 성공: $recordSeq');
        } else {
          print('서버 요청 실패: ${response.statusCode}');
        }
      } catch (e) {
          print('요청 처리 중 에러 발생: $e');
      }
    } else {
        print("초기 위치를 찾을 수 없습니다.");
    }
  }

  void _subscribeToTotalDistance() {
    myMap.totalDistanceNotifier.addListener(() {
      setState(() {
        totalDistance = myMap.totalDistanceNotifier.value;
        double distanceInKm = totalDistance / 1000.0;
        formattedDistance = distanceInKm.toStringAsFixed(2);
      });
    });
  }

  String formatPace(double paceInSecondsPerKm) {
    int minutes = (paceInSecondsPerKm / 60).floor();
    int seconds = (paceInSecondsPerKm % 60).round();

    return "$minutes'${seconds.toString().padLeft(2, '0')}''";
  }

  String formatElapsedTime(Duration elapsedTime) {
    int hours = elapsedTime.inHours;
    int minutes = elapsedTime.inMinutes.remainder(60);
    int seconds = elapsedTime.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // 기록을 서버에 전송하는 함수
  Future<void> _sendRecordToServer() async {
    final startLocation = myMap.startLocation;
    final endLocation = myMap.endLocation;
    final url = Uri.parse('https://k10a704.p.ssafy.io/Single/result');
    final dio = Dio();
    
    final elapsedTime = _clockKey.currentState?.elapsed ?? Duration.zero;
    final formattedElapsedTime = formatElapsedTime(elapsedTime);
    print(formattedElapsedTime);

    final requestBody = jsonEncode({
        "singleRecordSeq": recordSeq,
        "recordImage": 'image_url_here',
        "recordDist": formattedDistance,
        "recordTime": formattedElapsedTime,
        "recordStartLocation": "POINT(${startLocation?.latitude} ${startLocation?.longitude})",
        "recordEndLocation": "POINT(${endLocation?.latitude} ${endLocation?.longitude})",
        // "recordSpeed": "[{\"time\": 0, \"speed\": 15}, {\"time\": 1800, \"speed\": 10}]",
        // "recordPace": "{\"pace\": \"5:00\"}",
        "recordHeartbeat": "{\"unit\": \"bpm\", \"average\": 150}",
        // "recordMeanSpeed": myMap.speedNotifier.value,
        // "recordMeanPace": myMap.paceNotifier.value, 
    });

    // try {
    //   final response = await dio.post(
    //     url.toString(),
    //     data: requestBody,
    //     options: Options(headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDUyNzIxNzM3IiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE0ODkwMjQ1fQ.GABjqHm8MXBSgzv3ckROkNu3HeEyUrwrcQhsY-zWPSA',
    //     }),
    //   );

    //   if (response.statusCode == 200) {
    //     // 서버 응답 성공 처리
    //     // final responseData = jsonDecode(response.data);
    //     print('responseData type: ${response.data.runtimeType}');
    //     // recordSeq = responseData['recordSeq'] as int;
    //     // recordSeq = response.data;
    //     print('서버 요청 성공 - 결과 저장');
    //   } else {
    //     print('서버 요청 실패: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   print('요청 처리 중 에러 발생: $e');
    // }
    print(jsonDecode(requestBody));
  }

  void _handleEndButtonPress(BuildContext context) {
    if (_clockKey.currentState != null) {
        Duration elapsedTime = _clockKey.currentState!.elapsed;
        _clockKey.currentState!.setRunning(false);

        List<LatLng> coordinates = myMap.getCoordinates();

        final formattedElapsedTime = formatElapsedTime(elapsedTime);
        
        _sendRecordToServer();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleResult(
                elapsedTime: elapsedTime,
                coordinates: coordinates,
                startLocation: coordinates.first,
                endLocation: coordinates.last,
                totaldist: formattedElapsedTime,
            ),
          ),
        );
    }

    // Navigator.push(context, MaterialPageRoute(builder: (context) => SingleResult()));
  }

  void _showEndModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Color(0xffD6D6D6),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 50),
              Text('종료하시겠습니까?',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Text('중간에 종료하는 경우\n현재까지의 기록으로 분석이 이루어집니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 50),
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      print('종료하기 버튼이 클릭됨');
                      // _handleEndButtonPress(context);
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => SingleResult()));
                      // clock.(false); // Clock 멈추기
                      // Duration elapsedTime = _clockKey.currentState?.elapsed ?? Duration.zero;
                      // 종료 시 실행할 작업
                      // elapsedTime을 endlocation으로 넘겨주는 로직 추가
                      _handleEndButtonPress(context);
                    },
                    child: Container(
                      width:double.maxFinite,
                      decoration: BoxDecoration(
                        color: GREEN_COLOR,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        child: Text('종료하기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      _clockKey.currentState?.setRunning(true);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width:double.maxFinite,
                      decoration: BoxDecoration(
                        color: GRAY_400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        child: Text('취소',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget progressBar = Container();

    if (widget.dist > 0) {
        progressBar = DistBar(dist: widget.dist, formattedDistance: double.parse(formattedDistance));
    } else if (widget.time > 0) {
        // progressBar = TimeBar(initialTime: widget.time);
        Duration elapsedTime = _clockKey.currentState?.elapsed ?? Duration.zero;
        double elapsedTimeInSeconds = elapsedTime.inSeconds.toDouble();
        double remainingTimeInSeconds = widget.time - elapsedTimeInSeconds;
        double progressPercentage = 1.0 - (remainingTimeInSeconds / widget.time);
        progressBar = TimeBar(initialTime: widget.time, elapsedTime: elapsedTimeInSeconds);
    }

    Clock clockWidget = Clock(key: _clockKey, time: widget.time);

    // double totalDistance = myMap.getTotalDistance();
    // String formattedDistance = totalDistance.toStringAsFixed(2);

    return Scaffold(
        backgroundColor: Colors.white,
        body:
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 60,
                ),
                progressBar,
                SizedBox(
                    height: 45,
                ),
                // 나의경로
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('나의 경로',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      )
                    ),
                    SizedBox(height: 10),
                    myMap,
                  ],
                ),
                SizedBox(height: 35),
                // 이동거리, 현재 페이스
                    // formattedDistance = totalDistance.toStringAsFixed(2);
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('이동거리',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                              )
                            ),
                            SizedBox(height: 5),
                            ValueListenableBuilder<double>(
                              valueListenable: myMap.totalDistanceNotifier,
                              builder: (context, totalDistance, _) {
                                // double distanceInKm = totalDistance / 1000.0;
                                // formattedDistance = distanceInKm.toStringAsFixed(2);
                                return Text('$formattedDistance km',
                                  style: TextStyle(
                                    color: GREEN_COLOR,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                  )
                                );
                              }
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('현재 페이스',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                              )
                            ),
                            SizedBox(height: 5),
                            ValueListenableBuilder<double>(
                              valueListenable: myMap.paceNotifier,
                              builder: (context, pace, _) {
                                String formattedPace = formatPace(pace);
                                return Text(formattedPace,
                                  style: TextStyle(
                                    color: GREEN_COLOR,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                  )
                                );
                              }
                            ),
                          ],
                        ),
                        ),
                      ],
                    ),
                SizedBox(height: 30),
                // 소요 시간
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.time == 0? '소요 시간' : '남은 시간',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      )
                    ),
                    SizedBox(height: 10),
                    // Clock(time: widget.time),
                    clockWidget,
                  ],
                ),
                SizedBox(height: 30),
                // 현재 속도
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('현재 속도',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      )
                    ),
                    SizedBox(height: 5),
                    ValueListenableBuilder<double>(
                      valueListenable: myMap.speedNotifier,
                      builder: (context, speed, _) {
                        return Text('${speed.toStringAsFixed(2)} km/h',
                          style: TextStyle(
                            color: GREEN_COLOR,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          )
                        );
                      }
                    ),
                  ],
                ),
                SizedBox(height: 40),
                // 종료 버튼
                GestureDetector(
                  onTap: () {
                    _showEndModal(context);
                  },
                  child: Container(
                    width:double.maxFinite,
                    decoration: BoxDecoration(
                      color: GREEN_COLOR,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: Text('종료하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
      );
  }
}