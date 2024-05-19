import 'dart:async';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wadada/models/DistanceHeartbeat.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
// import 'package:flutter/rendering.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/screens/singleresultpage/singleresultpage.dart';

import 'package:wadada/screens/singlerunpage/component/clock.dart';
import 'package:wadada/screens/singlerunpage/component/map.dart';
import 'package:wadada/screens/singlerunpage/component/dist_bar.dart';
import 'package:wadada/screens/singlerunpage/component/testmap.dart';
import 'package:wadada/screens/singlerunpage/component/time_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:dio/dio.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class SingleFreeRun extends StatefulWidget {
  final int time;
  final int dist;
  final String appKey;
  const SingleFreeRun(
      {super.key,
      required this.time,
      required this.dist,
      required this.appKey});

  @override
  _SingleFreeRunState createState() => _SingleFreeRunState();
}

class _SingleFreeRunState extends State<SingleFreeRun> {
  bool isLoading = true;
  bool isLocked = false;
  int countdown = 5;
  Timer? countdownTimer;
  bool showCountdown = false;
  int? recordSeq;
  double totalDistance = 0.0;
  String formattedDistance = '0.00';
  // ValueNotifier<double> elapsedTimeNotifier = ValueNotifier<double>(0.0);
  ValueNotifier<Duration> elapsedTimeNotifier =
      ValueNotifier<Duration>(Duration.zero);
  final GlobalKey<ClockState> _clockKey = GlobalKey<ClockState>();
  late Clock clock;

  late MyMap myMap;

  // 워치랑
  final _watch = WatchConnectivity();
  static const eventChannel = EventChannel('com.ssafy.wadada/watch');
  final MethodChannel channel = const MethodChannel('watch_connectivity');
  var _supported = false;
  var _paired = false;
  final _reachable = false;
  final bool _connected = false;
  final _log = <String>[];
  String formattedPace = '';
  // 마지막으로 전송된 페이스 값
  final String _lastSentPace = '';
  List<DistanceHeartbeat> distanceHeartbeatList = [];

  // 워치에서 심박수 가져와

  final GlobalKey<MyMapState> myMapStateKey = GlobalKey<MyMapState>();
  @override
  void initState() {
    super.initState();

    startTimers();
    // 여기서 슛?
    _enableEventReceiver();

    myMap = MyMap(
      appKey: widget.appKey,
      key: myMapStateKey,
      centerplace: LatLng(0.0, 0.0),
      moderoom: -1,
    );

    myMap.startLocationNotifier.addListener(() {
      if (myMap.startLocationNotifier.value != null) {
        sendLocationToServer();
        // setState(() {
        //     isLoading = false;
        // });
      }
    });

    clock = Clock(
      key: _clockKey,
      time: widget.time,
      elapsedTimeNotifier: elapsedTimeNotifier,
      onTimerEnd: _onTimerEnd,
    );
    _subscribeToTotalDistance();
    // requestPermissions();
    myMapStateKey.currentState?.startGame();
    // sendLocationToServer();
    // 워치 초기화
    _watch.sendMessage({
      'formattedPace': "0'00",
    });
    // myMap.paceNotifier.addListener(_onPaceUpdated);
  }

  void _enableEventReceiver() {
    eventChannel.receiveBroadcastStream().listen(
      (data) {
        setState(() {
          var heartbeat = jsonDecode(data);
          if (heartbeat["heartbeat"] != null) {
            // 문자열을 정수로 변환
            int? heartbeatValue = int.tryParse(heartbeat["heartbeat"]);

            if (heartbeatValue != null && heartbeatValue > 0) {
              distanceHeartbeatList.add(
                  DistanceHeartbeat(totalDistance, heartbeat["heartbeat"]));
            }
          } else {
            print("Heartbeat data is missing or null");
          }
        });
      },
      onError: (error) {
        setState(() {
          print("Error: ${error.message}");
        });
      },
    );
  }

  void sendMessage(formattedPace) {
    final message = {
      'formattedPace': formattedPace,
      // 'splitHours': splitHours,
      // 'splitMinutes': splitMinutes,
      // 'splitSeconds': splitSeconds,
    };
    _watch.sendMessage(message);
    setState(() => _log.add('메세지: $message'));
  }

  void sendContext(formattedPace) {
    final context = {
      'formattedPace': formattedPace,
    };
    _watch.updateApplicationContext(context);
    setState(() => _log.add('보내진 context: $context'));
  }

  void initPlatformState() async {
    _supported = await _watch.isSupported;
    _paired = await _watch.isPaired;
    // _reachable = await _watch.isReachable;
    setState(() {});
  }

  // 워치 권한 허용 관련 코드
  void requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.location,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
    ].request();

    if (statuses[Permission.bluetooth]?.isGranted == true &&
        statuses[Permission.location]?.isGranted == true &&
        statuses[Permission.bluetoothScan]?.isGranted == true &&
        statuses[Permission.bluetoothConnect]?.isGranted == true &&
        statuses[Permission.bluetoothAdvertise]?.isGranted == true) {
      scanForDevices();
    } else {
      print("Permissions not granted.");
    }
  }

  void scanForDevices() async {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
    try {
      // Get devices connected to the system
      List<BluetoothDevice> devices = await FlutterBluePlus.systemDevices;

      if (devices.isEmpty) {
        print("No system devices found.");
      } else {
        for (BluetoothDevice device in devices) {
          print(
              "System device: ${device.advName} (ID: ${device.platformName})");
        }
      }
    } catch (e) {
      print("Error retrieving system devices: $e");
    }
  }

  // void _onPaceUpdated() {
  //   // 페이스가 업뎃 시 호출
  //   String currentFormattedPace = formatPace(myMap.paceNotifier.value);
  //   // 현재 페이스가 마지막 전송 페이스랑 다를 경우에만 메시지 슛.
  //   if (_lastSentPace != currentFormattedPace) {
  //     sendMessage(currentFormattedPace);
  //     _lastSentPace = currentFormattedPace; // 페이스를 업뎃
  //   }
  // }

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
    // myMap.paceNotifier.removeListener(_onPaceUpdated);

    myMapStateKey.currentState?.dispose();
    super.dispose();
  }

  Future<void> sendLocationToServer() async {
    final startLocation = myMap.startLocation;
    final dio = Dio();
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');
    int recordMode = widget.time > 0 ? 2 : 1;

    if (startLocation != null) {
      final url = Uri.parse('https://k10a704.p.ssafy.io/Single/start');
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');

      final requestBody = jsonEncode({
        "recordMode": recordMode,
        "recordStartLocation":
            "POINT(${startLocation.latitude} ${startLocation.longitude})"
      });

      try {
        final response = await dio.post(
          url.toString(),
          data: requestBody,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'authorization': accessToken ??
                'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM',
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
  Future<void> sendRecordToServer() async {
    final startLocation = myMap.startLocation;
    final endLocation = myMap.endLocation;
    final url = Uri.parse('https://k10a704.p.ssafy.io/Single/result');
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');
    final dio = Dio();

    int recordMode = widget.time > 0 ? 2 : 1;

    // final elapsedTime = _clockKey.currentState?.elapsed ?? Duration.zero;
    // final formattedElapsedTime = formatElapsedTime(elapsedTime);
    // print(formattedElapsedTime);
    double elapsedSeconds = _clockKey.currentState!.getElapsedSeconds();
    int intelapsedseconds = elapsedSeconds.toInt();
    print('초 시간? $intelapsedseconds');
    Duration elapsedTime = Duration(seconds: elapsedSeconds.round());
    String formattedElapsedTime = formatElapsedTime(elapsedTime);
    print(formattedElapsedTime);

    List<LatLng> coordinates = myMap.getCoordinates();
    List<Map<String, double>> distanceSpeed = myMap.getdistanceSpeed();
    List<Map<String, double>> distancePace = myMap.getdistancePace();

    //

    // 평균 속도 계산
    double calculateAverageSpeed(List<Map<String, double>> distanceSpeed) {
      if (distanceSpeed.isEmpty) return 0.0;
      double totalSpeed = 0.0;
      for (Map<String, double> entry in distanceSpeed) {
        totalSpeed += entry['speed'] ?? 0.0;
      }
      double averageSpeed = totalSpeed / distanceSpeed.length;
      return averageSpeed;
    }

    // 평균 페이스 계산
    double calculateAveragePace(List<Map<String, double>> distancePace) {
      if (distancePace.isEmpty) return 0.0;
      double totalPace = 0.0;
      for (Map<String, double> entry in distancePace) {
        totalPace += entry['pace'] ?? 0.0;
      }
      double averagePace = totalPace / distancePace.length;
      return averagePace;
    }

    int calculateAverageHeartbeat() {
      if (distanceHeartbeatList.isEmpty) return 0;
      int totalBeat = 0;
      int cnt = distanceHeartbeatList.length;
      for (DistanceHeartbeat beat in distanceHeartbeatList) {
        totalBeat += int.parse(beat.heartbeat);
      }
      int averageBeat = (totalBeat / cnt) as int;
      return averageBeat;
    }

    // // 초 단위의 페이스를 km/h로 변환
    // double convertPaceToKmPerHour(double paceInSecondsPerKm) {
    //     if (paceInSecondsPerKm == 0) return 0.0; // 0으로 나누는 오류 방지
    //     return 3600 / paceInSecondsPerKm;
    // }

    double averageSpeed = calculateAverageSpeed(distanceSpeed);
    double averagePaceInSecondsPerKm = calculateAveragePace(distancePace);
    // double averagePaceInKmPerHour = convertPaceToKmPerHour(averagePaceInSecondsPerKm);

    averageSpeed = double.parse(averageSpeed.toStringAsFixed(2)) * 1000;
    // averagePaceInSecondsPerKm = double.parse(averagePaceInSecondsPerKm.toStringAsFixed(2)) * 1000;
    // double formattedDistanceInMeters = double.parse(formattedDistance) * 1000;

    // if (averageSpeed.isNaN || averageSpeed.isInfinite) {
    //   averageSpeed = 0.0; // Set a default value or handle the NaN case
    // } else {
    //   averageSpeed = double.parse(averageSpeed.toStringAsFixed(2)) * 1000;
    // }

    // if (averagePaceInSecondsPerKm.isNaN ||
    //     averagePaceInSecondsPerKm.isInfinite) {
    //   averagePaceInSecondsPerKm =
    //       0.0; // Set a default value or handle the NaN case
    // } else {
    //   // You can uncomment this line if you want to handle pace as well
    //   averagePaceInSecondsPerKm =
    //       double.parse(averagePaceInSecondsPerKm.toStringAsFixed(2)) * 1000;
    // }

// Convert to integers
    int intaveragespeed = averageSpeed.toInt();
    int intaveragepaceinkmperhour = averagePaceInSecondsPerKm.toInt();
    // int intformatteddistanceinmeters = formattedDistanceInMeters.toInt();

    // print('평균 속도 $intaveragespeed');
    // print('평균 페이스 $intaveragepaceinkmperhour');
    // print('총 거리 $totalDistance');

    final requestBody = jsonEncode({
      "recordMode": recordMode,
      "singleRecordSeq": recordSeq,
      "recordImage":
          'https://github.com/jjeong41/t/assets/103355863/4e6d205d-694e-458c-b992-8ea7c27b85b1',
      "recordDist": totalDistance,
      "recordTime": intelapsedseconds, // int
      "recordStartLocation":
          "POINT(${startLocation?.latitude} ${startLocation?.longitude})",
      "recordEndLocation":
          "POINT(${endLocation?.latitude} ${endLocation?.longitude})",
      "recordWay": jsonEncode(coordinates),
      "recordSpeed": jsonEncode(distanceSpeed),
      "recordPace": jsonEncode(distancePace),
      "recordHeartbeat": jsonEncode(distanceHeartbeatList),
      "recordMeanSpeed": intaveragespeed, // int
      "recordMeanPace": intaveragepaceinkmperhour, // int
      "recordMeanHeartbeat": calculateAverageHeartbeat() // int
    });

    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');
      final response = await dio.post(
        url.toString(),
        data: requestBody,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': accessToken ??
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM',
        }),
      );

      if (response.statusCode == 200) {
        // 서버 응답 성공 처리
        // final responseData = jsonDecode(response.data);
        print('responseData type: ${response.data.runtimeType}');
        // recordSeq = responseData['recordSeq'] as int;
        // recordSeq = response.data;
        print('서버 요청 성공 - 결과 저장');
      } else {
        print('서버 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('요청 처리 중 에러 발생zzzzzzzzzz: $e');
    }
    print(jsonDecode(requestBody));
  }

  void handleEndButtonPress(BuildContext context) {
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

      // final formattedElapsedTime = formatElapsedTime(elapsedTime);

      sendRecordToServer();

      print('스피드 - $distanceSpeed');
      print('페이스 - $distancePace');
      myMapStateKey.currentState?.endGame();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleResult(
            elapsedTime: elapsedTime,
            coordinates: coordinates,
            startLocation: coordinates.first,
            endLocation: coordinates.last,
            totaldist: formattedDistance,
            distanceSpeed: distanceSpeed,
            distancePace: distancePace,
            distanceHeartbeatList:
                distanceHeartbeatList.isNotEmpty ? distanceHeartbeatList : null,
          ),
        ),
      );
    }

    // Navigator.push(context, MaterialPageRoute(builder: (context) => SingleResult()));
  }

  void showEndModal(BuildContext context) {
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
              Text(
                '종료하시겠습니까?',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Text(
                '중간에 종료하는 경우\n현재까지의 기록으로 분석이 이루어집니다.',
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
                      dispose();
                      handleEndButtonPress(context);
                    },
                    child: Container(
                      width: double.maxFinite,
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
                              ))),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      _clockKey.currentState?.setRunning(true);
                      Get.back();
                      // Navigator.pop(context);
                    },
                    child: Container(
                      width: double.maxFinite,
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
                              ))),
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

  void _onTimerEnd() {
    // 타이머가 종료되었을 때 실행할 로직
  }

  @override
  Widget build(BuildContext context) {
    Widget progressBar = Container();

    if (widget.dist > 0) {
      progressBar = DistBar(
          dist: widget.dist,
          formattedDistance: double.parse(formattedDistance));
    } else if (widget.time > 0) {
      // progressBar = TimeBar(initialTime: widget.time);
      double elapsedSeconds =
          _clockKey.currentState?.getElapsedSeconds() ?? 0.0;
      double elapsedTimeInSeconds = elapsedSeconds;
      // Duration elapsedTime = Duration(seconds: elapsedSeconds.round());
      // Duration elapsedTime = _clockKey.currentState?.elapsed ?? Duration.zero;
      // double elapsedTimeInSeconds = elapsedTime.inSeconds.toDouble();
      // progressBar = TimeBar(initialTime: widget.time);

      // progressBar = ValueListenableBuilder<Duration>(
      //     valueListenable: elapsedTimeNotifier,
      //     builder: (context, elapsedDuration, _) {
      //         // Convert Duration to double
      //         double elapsedTimeInSeconds = elapsedDuration.inSeconds.toDouble();

      //         // Pass the elapsed time in seconds to TimeBar
      //         return TimeBar(
      //             initialTime: widget.time,
      //             elapsedTime: elapsedTimeInSeconds,
      //         );
      //     },
      // );
    }

    // Duration elapsedDuration = Duration(seconds: elapsedTimeNotifier.value.round());

    Clock clockWidget = Clock(
      key: _clockKey,
      time: widget.time,
      elapsedTimeNotifier: elapsedTimeNotifier,
      onTimerEnd: _onTimerEnd,
    );

    // double totalDistance = myMap.getTotalDistance();
    // String formattedDistance = totalDistance.toStringAsFixed(2);

    void onLockButtonPressed() {
      setState(() {
        isLocked = !isLocked;
      });
    }

    void onUnlockButtonPressed() {
      setState(() {
        isLocked = false;
      });
    }

    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 45),
                        progressBar,
                        SizedBox(height: 35),
                        // 나의 경로
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('나의 경로',
                                style: TextStyle(
                                  color: GRAY_500,
                                  fontSize: 19,
                                )),
                            SizedBox(height: 10),
                            myMap,
                            // myMap1,
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
                                        color: GRAY_500,
                                        fontSize: 19,
                                      )),
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
                                            ));
                                      }),
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
                                      )),
                                  SizedBox(height: 5),
                                  ValueListenableBuilder<double>(
                                      valueListenable: myMap.paceNotifier,
                                      builder: (context, pace, _) {
                                        formattedPace = formatPace(pace);

                                        // sendMessage(formattedPace);

                                        return Text(formattedPace,
                                            style: TextStyle(
                                              color: GREEN_COLOR,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w700,
                                            ));
                                      }),
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
                            Text(widget.time == 0 ? '소요 시간' : '남은 시간',
                                style: TextStyle(
                                  color: GRAY_500,
                                  fontSize: 19,
                                )),
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
                                  color: GRAY_500,
                                  fontSize: 19,
                                )),
                            SizedBox(height: 5),
                            ValueListenableBuilder<double>(
                                valueListenable: myMap.speedNotifier,
                                builder: (context, speed, _) {
                                  return Text('${speed.toStringAsFixed(2)} km/h',
                                      style: TextStyle(
                                        color: GREEN_COLOR,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                      ));
                                }),
                          ],
                        ),
                        SizedBox(height: 50),
                        // 종료 버튼
                        GestureDetector(
                          onTap: () {
                            showEndModal(context);
                          },
                          child: Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: GREEN_COLOR,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text('종료하기',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Scaffold(
                backgroundColor: OATMEAL_COLOR,
                body: Center(
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
        ],
      ),
    );

  }
}
