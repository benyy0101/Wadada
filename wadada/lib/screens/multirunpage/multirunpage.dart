import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:wadada/repository/multiRepo.dart';
import 'package:wadada/screens/multirankpage/multirankpage.dart';
import 'package:wadada/screens/multiresultpage/multiresultpage.dart';

import 'package:wadada/screens/singlerunpage/component/clock.dart';
import 'package:wadada/screens/singlerunpage/component/map.dart';
import 'package:wadada/screens/singlerunpage/component/dist_bar.dart';
import 'package:wadada/screens/singlerunpage/component/time_bar.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:dio/dio.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:wadada/controller/multiController.dart';

class MultiRun extends StatefulWidget{
  final double time;
  final double dist;
  final String appKey;
  const MultiRun({super.key, required this.time, required this.dist, required this.appKey});
  
  @override
  _MultiRunState createState() => _MultiRunState();
}

class _MultiRunState extends State<MultiRun> {
  bool isLoading = true;
  int countdown = 5;
  Timer? countdownTimer;
  bool showCountdown = false;
  int currentTab = 0;
  int? recordSeq;
  double totalDistance = 0.0;
  String formattedDistance = '0.00';
  ValueNotifier<Duration> elapsedTimeNotifier = ValueNotifier<Duration>(Duration.zero);
  final GlobalKey<ClockState> _clockKey = GlobalKey<ClockState>();
  late Clock clock;

  late MyMap myMap;

  void _toggleButton(int index) {
    setState(() {
      currentTab = index;
    });
  }

  @override
  void initState() {
    super.initState();

    startTimers();

    myMap = MyMap(appKey: widget.appKey);

    myMap.startLocationNotifier.addListener(() {
      if (myMap.startLocation != null) {
          sendLocationToServer();
      }
    });

    clock = Clock(key: _clockKey, time: widget.time, elapsedTimeNotifier: elapsedTimeNotifier,);
    _subscribeToTotalDistance();
  }

  void startTimers() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        showCountdown = true;
      });
      startCountdown();
    });
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
        if (countdown <= 0) {
          timer.cancel();
          isLoading = false;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _clockKey.currentState?.start();
        });
        }
      });
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  MultiController controller = Get.find<MultiController>();

  // 008 controller
  // Future<void> sendLocationToServer() async {
  //   final startLocation = myMap.startLocation;

  //   double lat = startLocation!.latitude;
  //   double long = startLocation.longitude;
  //   int roomIdx = 1; // 수정 필요
  //   int people = 4; // 수정 필요

  //   controller.sendStartLocation(lat, long, roomIdx, people);
  // }

  Future<void> sendLocationToServer() async {
    final startLocation = myMap.startLocation;
    final dio = Dio();
    int recordMode = widget.time > 0 ? 2 : 1;
        
    if (startLocation != null) {
      final url = Uri.parse('https://k10a704.p.ssafy.io/Multi/start');

      final requestBody = jsonEncode({
        "recordMode": recordMode,
        "recordStartLocation": "POINT(${startLocation.latitude} ${startLocation.longitude})",
        // "recordPeople": 1,
      });
      
      try {
        final response = await dio.post(
          url.toString(),
          data: requestBody,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDUyNzIxNzM3IiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE0ODgzODg1fQ.7nS18Nv6vBsmIIzOh03-_RYS1UHcXDLygj9PUwDN1Vo',
          }),
        );
        
        if (response.statusCode == 200) {
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

  // 009 controller
  Future<void> _sendRecordToServer() async {
    final MultiController multiController = Get.put(MultiController(repo: MultiRepository(provider: MultiProvider())));

    final startLocation = myMap.startLocation;
    final endLocation = myMap.endLocation;

    int recordMode = widget.time > 0 ? 2 : 1;

    double elapsedSeconds = _clockKey.currentState!.getElapsedSeconds();
    int intelapsedseconds = elapsedSeconds.toInt();
    print('초 시간? $intelapsedseconds');
    Duration elapsedTime = Duration(seconds: elapsedSeconds.round());
    String formattedElapsedTime = formatElapsedTime(elapsedTime);
    print(formattedElapsedTime);

    List<LatLng> coordinates = myMap.getCoordinates();
    List<Map<String, double>> distanceSpeed = myMap.getdistanceSpeed();
    List<Map<String, double>> distancePace = myMap.getdistancePace();

    int totalDistanceInt = totalDistance.floor();

    MultiRoomGameEnd gameEndData = MultiRoomGameEnd(
      roomIdx: 1, // 수정 필요
      recordImage: 'your_record_image',
      recordDist: totalDistanceInt,
      recordTime: intelapsedseconds,
      recordStartLocation: "POINT(${startLocation?.latitude} ${startLocation?.longitude})",
      recordEndLocation: "POINT(${endLocation?.latitude} ${endLocation?.longitude})", 
      recordWay: jsonEncode(coordinates),
      recordSpeed: jsonEncode(distanceSpeed),
      recordPace: jsonEncode(distancePace),
      recordHeartbeat: jsonEncode(distancePace),
      recordRank: 1, // 수정 필요
    );

    multiController.gameEndInfo = gameEndData;
    multiController.endGame();
  }

  // Future<void> _sendRecordToServer() async {
  //   final startLocation = myMap.startLocation;
  //   final endLocation = myMap.endLocation;
  //   final url = Uri.parse('https://k10a704.p.ssafy.io/Multi/result');
  //   final dio = Dio();

  //   int recordMode = widget.time > 0 ? 2 : 1;
    
  //   // final elapsedTime = _clockKey.currentState?.elapsed ?? Duration.zero;
  //   // final formattedElapsedTime = formatElapsedTime(elapsedTime);
  //   // print(formattedElapsedTime);
  //   double elapsedSeconds = _clockKey.currentState!.getElapsedSeconds();
  //   int intelapsedseconds = elapsedSeconds.toInt();
  //   print('초 시간? $intelapsedseconds');
  //   Duration elapsedTime = Duration(seconds: elapsedSeconds.round());
  //   String formattedElapsedTime = formatElapsedTime(elapsedTime);
  //   print(formattedElapsedTime);

  //   List<LatLng> coordinates = myMap.getCoordinates();
  //   List<Map<String, double>> distanceSpeed = myMap.getdistanceSpeed();
  //   List<Map<String, double>> distancePace = myMap.getdistancePace();

  //   // 평균 속도 계산
  //   double calculateAverageSpeed(List<Map<String, double>> distanceSpeed) {
  //       double totalSpeed = 0.0;
  //       for (Map<String, double> entry in distanceSpeed) {
  //           totalSpeed += entry['speed'] ?? 0.0;
  //       }
  //       double averageSpeed = totalSpeed / distanceSpeed.length;
  //       return averageSpeed;
  //   }

  //   // 평균 페이스 계산
  //   double calculateAveragePace(List<Map<String, double>> distancePace) {
  //       double totalPace = 0.0;
  //       for (Map<String, double> entry in distancePace) {
  //           totalPace += entry['pace'] ?? 0.0;
  //       }
  //       double averagePace = totalPace / distancePace.length;
  //       return averagePace;
  //   }

  // double averageSpeed = calculateAverageSpeed(distanceSpeed);
  // double averagePaceInSecondsPerKm = calculateAveragePace(distancePace);
  // averageSpeed = double.parse(averageSpeed.toStringAsFixed(2)) * 1000;

  // int intaveragespeed = averageSpeed.toInt();
  // int intaveragepaceinkmperhour = averagePaceInSecondsPerKm.toInt();

  //   final requestBody = jsonEncode({
  //       "recordMode": recordMode,
  //       "singleRecordSeq": recordSeq,
  //       "recordImage": 'https://github.com/jjeong41/t/assets/103355863/4e6d205d-694e-458c-b992-8ea7c27b85b1',
  //       "recordDist": totalDistance, // int
  //       "recordTime": intelapsedseconds, // int
  //       "recordStartLocation": "POINT(${startLocation?.latitude} ${startLocation?.longitude})",
  //       "recordEndLocation": "POINT(${endLocation?.latitude} ${endLocation?.longitude})",
  //       "recordWay": jsonEncode(coordinates),
  //       "recordSpeed": jsonEncode(distanceSpeed),
  //       "recordPace": jsonEncode(distancePace),
  //       "recordHeartbeat": jsonEncode(distancePace),
  //       "recordRank": 2,
  //       "recordMeanSpeed": intaveragespeed, // int
  //       "recordMeanPace": intaveragepaceinkmperhour, // int
  //       "recordMeanHeartbeat": 0 // int
  //   });

  //   try {
  //     final response = await dio.patch(
  //       url.toString(),
  //       data: requestBody,
  //       options: Options(headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDUyNzIxNzM3IiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE0ODgzODg1fQ.7nS18Nv6vBsmIIzOh03-_RYS1UHcXDLygj9PUwDN1Vo',
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       print('responseData type: ${response.data.runtimeType}');
  //       print('서버 요청 성공 - 결과 저장');
  //     } else {
  //       print('서버 요청 실패: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('요청 처리 중 에러 발생: $e');
  //   }
  //   print(jsonDecode(requestBody));
  // }

  void _handleEndButtonPress(BuildContext context) {
    if (_clockKey.currentState != null) {
        // Duration elapsedTime = _clockKey.currentState!.elapsed;
        double elapsedSeconds = _clockKey.currentState!.getElapsedSeconds();
        _clockKey.currentState!.setRunning(false);

        List<LatLng> coordinates = myMap.getCoordinates();
        List<Map<String, double>> distanceSpeed = myMap.getdistanceSpeed();
        List<Map<String, double>> distancePace = myMap.getdistancePace();

        Duration elapsedTime = Duration(seconds: elapsedSeconds.round());
        String formattedElapsedTime = formatElapsedTime(elapsedTime);

        // final formattedElapsedTime = formatElapsedTime(elapsedTime);
        
        _sendRecordToServer();

        print('스피드 - $distanceSpeed');
        print('페이스 - $distancePace');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiRank(
                elapsedTime: elapsedTime,
                coordinates: coordinates,
                startLocation: coordinates.first,
                endLocation: coordinates.last,
                totaldist: formattedDistance,
                distanceSpeed: distanceSpeed,
                distancePace: distancePace,
            ),
          ),
        );
        // Navigator.push(context, MaterialPageRoute(builder: (context) => MultiRank()));
    }
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
                  fontSize: 19,
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
                            fontSize: 19,
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
                            fontSize: 19,
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
        double elapsedSeconds = _clockKey.currentState?.getElapsedSeconds() ?? 0.0;
        double elapsedTimeInSeconds = elapsedSeconds;
        // Duration elapsedTime = Duration(seconds: elapsedSeconds.round());
        // Duration elapsedTime = _clockKey.currentState?.elapsed ?? Duration.zero;
        // double elapsedTimeInSeconds = elapsedTime.inSeconds.toDouble();

        progressBar = ValueListenableBuilder<Duration>(
            valueListenable: elapsedTimeNotifier,
            builder: (context, elapsedDuration, _) {
                // Convert Duration to double
                double elapsedTimeInSeconds = elapsedDuration.inSeconds.toDouble();
                
                // Pass the elapsed time in seconds to TimeBar
                return TimeBar(
                    initialTime: widget.time,
                    elapsedTime: elapsedTimeInSeconds,
                );
            },
        );
    }

    // Duration elapsedDuration = Duration(seconds: elapsedTimeNotifier.value.round());

    Clock clockWidget = Clock(
        key: _clockKey,
        time: widget.time,
        elapsedTimeNotifier: elapsedTimeNotifier,
    );

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: isLoading? null : AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(25), 
          child: 
            Container(
              // height: 40,
              decoration: BoxDecoration(
                color: OATMEAL_COLOR,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ToggleButtons(
                isSelected: [currentTab == 0, currentTab == 1],
                onPressed: _toggleButton,
                fillColor: OATMEAL_COLOR,
                borderColor: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                borderWidth: 0,
                children: [
                  Container(
                    width: 150,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                    decoration: currentTab == 0
                        ? BoxDecoration(
                            color: GREEN_COLOR,
                            borderRadius: BorderRadius.circular(8),
                          )
                        : null,
                    child: Text('정보',
                      style: TextStyle(
                        color: currentTab == 0 ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 150,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                    decoration: currentTab == 1
                        ? BoxDecoration(
                            color: GREEN_COLOR,
                            borderRadius: BorderRadius.circular(8),
                          )
                        : null,
                    child: Text('지도',
                      style: TextStyle(
                        color: currentTab == 1 ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
            ),
            )
          ),
        ),
        body: Stack(
          children: [
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IndexedStack(
                  index: currentTab,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 20,
                        ),
                        progressBar,
                        SizedBox(height: 35),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('이동거리',
                                      style: TextStyle(
                                          color: GRAY_500,
                                          fontSize: 19,
                                      )
                                    ),
                                    SizedBox(height: 5),
                                    ValueListenableBuilder<double>(
                                      valueListenable: myMap.totalDistanceNotifier,
                                      builder: (context, totalDistance, _) {
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
                                          color: GRAY_500,
                                          fontSize: 19,
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
                                color: GRAY_500,
                                fontSize: 19,
                              )
                            ),
                            SizedBox(height: 10),
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
                                color: GRAY_500,
                                fontSize: 19,
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
                          ],),
                          ],
                        ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          SizedBox(height: 20),
                          Text('나의 경로',
                              style: TextStyle(
                                  color: GRAY_500,
                                  fontSize: 19,
                              ),
                          ),
                          SizedBox(height: 10),
                          myMap, // 지도 위젯
                        ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('실시간 순위',
                        style: TextStyle(
                          color: GRAY_500,
                          fontSize: 19,
                        )
                      ),
                      SizedBox(height: 15),
                      // ValueListenableBuilder<double>(
                      //   valueListenable: myMap.speedNotifier,
                      //   builder: (context, speed, _) {
                      //     return Text('${speed.toStringAsFixed(2)} km/h',
                      //       style: TextStyle(
                      //         color: GREEN_COLOR,
                      //         fontSize: 30,
                      //         fontWeight: FontWeight.w700,
                      //       )
                      //     );
                      //   }
                      // ),
                      Container(
                        decoration: BoxDecoration(
                        color: Color(0xffF6F4E9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      width: 400,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: const [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text('1',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: DARK_GREEN_COLOR,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text('닉네임',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text('00:02:23',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: DARK_GREEN_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      )
                      ),
                    ],
                  ),
                SizedBox(height: 50),
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
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        )
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (isLoading)
            Positioned.fill(
              child: Container(
                color: OATMEAL_COLOR,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '잠시 후에\n달리기를 시작합니다.',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 59, 59, 59),
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (showCountdown)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            countdown > 0 ? countdown.toString() : '',
                            style: TextStyle(
                              color: GREEN_COLOR,
                              fontSize: 150,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ]
      )
    );
  }
}