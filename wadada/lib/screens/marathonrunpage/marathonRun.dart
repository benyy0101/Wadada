import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
// import 'package:flutter/rendering.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/marathonController.dart';
import 'package:wadada/controller/stompController.dart';
import 'package:wadada/models/marathon.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:wadada/repository/marathonRepo.dart';
import 'package:wadada/repository/multiRepo.dart';
import 'package:wadada/screens/mainpage/layout.dart';
import 'package:wadada/screens/multirankpage/multirankpage.dart';
import 'package:wadada/screens/multiresultpage/multiresultpage.dart';
import 'package:wadada/screens/singleresultpage/singleresultpage.dart';

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
import 'package:wadada/controller/stompController.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MarathonRun extends StatefulWidget {
  SimpleMarathon roomInfo;
  MarathonRun({super.key, required this.roomInfo});

  @override
  _MarathonState createState() => _MarathonState();
}

class _MarathonState extends State<MarathonRun> {
  late StompClient stompClient;
  bool isLoading = true;
  bool iscountdown = false;
  int countdown = 5;
  Timer? countdownTimer;
  bool showCountdown = false;
  int currentTab = 0;
  int? recordSeq;
  double totalDistance = 0.0;
  int totalDistanceInt = 0;
  String formattedDistance = '0.00';
  ValueNotifier<Duration> elapsedTimeNotifier =
      ValueNotifier<Duration>(Duration.zero);
  final GlobalKey<ClockState> _clockKey = GlobalKey<ClockState>();

  StompController stompController = Get.put(StompController(roomIdx: -1));
  // late Clock clock;
  late MyMap myMap;
  late dynamic unsubscribeFn;

  bool allDataReceived = false;
  bool gameStartMessageReceived = false;
  String receivedMessage = '';

  void _toggleButton(int index) {
    setState(() {
      currentTab = index;
    });
  }

  @override
  void initState() {
    super.initState();

    myMap = MyMap(
      appKey: dotenv.env['APP_KEY'] ?? 'f508d67320677608aea64e5d6a9a3005',
      centerplace: LatLng(-1, -1),
      moderoom: -1,
    );
    onPageLoaded();
    startGameGoTimer();
    _subscribeToTotalDistance();
  }

  void _subscribeToTotalDistance() {
    myMap.totalDistanceNotifier.addListener(() {
      setState(() {
        totalDistance = myMap.totalDistanceNotifier.value;
        totalDistanceInt = totalDistance.round();
        double distanceInKm = totalDistance / 1000.0;
        formattedDistance = distanceInKm.toStringAsFixed(2);
        stompController.dist = totalDistanceInt;
      });
    });
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
          iscountdown = false;
          _clockKey.currentState?.start();
        }
      });
    });
  }

  @override
  void dispose() {
    stompClient.deactivate();
    countdownTimer?.cancel();
    // _requestinfoSubscription.cancel();
    super.dispose();
  }

  void startGameGoTimer() {
    Timer(Duration(seconds: 30), () {
      if (stompController.gamego.value) {
        closeLoadingAndStartCountdown();
      }
    });
  }

  void onPageLoaded() {
    if (stompController.gameStartResponse.value) {
      myMap.startLocationNotifier.addListener(() {
        if (myMap.startLocation != null) {
          print('보냄');
          //sendLocationToServer();
        }
      });
    }

    stompController.gamego.addListener(() {
      print('gamego value 들어오나 ${stompController.gamego.value}');
      if (stompController.gamego.value) {
        print('closeloadingandstartcountdown true임');
        closeLoadingAndStartCountdown();
      }
    });
  }

  void closeLoadingAndStartCountdown() {
    setState(() {
      isLoading = false;
      iscountdown = true;
    });
    startTimers();
  }

  String formatPace(double paceInSecondsPerKm) {
    // Check if the pace is NaN or Infinity
    if (paceInSecondsPerKm.isNaN || paceInSecondsPerKm.isInfinite) {
      return "0'00''";
    }

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
    final startLocation = myMap.startLocation;
    final endLocation = myMap.endLocation;
    String nickname = await storage.read(key: 'kakaoNickname') ?? "";
    double elapsedSeconds = _clockKey.currentState!.getElapsedSeconds();
    int intelapsedseconds = elapsedSeconds.toInt();
    print('초 시간? $intelapsedseconds');
    Duration elapsedTime = Duration(seconds: elapsedSeconds.round());
    String formattedElapsedTime = formatElapsedTime(elapsedTime);
    print(formattedElapsedTime);

    List<LatLng> coordinates = myMap.getCoordinates();
    List<Map<String, double>> distanceSpeed = myMap.getdistanceSpeed();
    int total = 0;
    int meanSpeed = 0;
    int meanPace = 0;
    if (distanceSpeed.isNotEmpty) {
      for (var element in distanceSpeed) {
        if (element['speed']!.isNaN || element['speed']!.isInfinite) {
        } else {
          total += element['speed']!.floor();
        }
      }
      meanSpeed = (total / distanceSpeed.length).floor();
    }
    List<Map<String, double>> distancePace = myMap.getdistancePace();
    if (distancePace.isNotEmpty) {
      total = 0;
      for (var item in distancePace) {
        if (item['pace']!.isNaN || item['pace']!.isInfinite) {
        } else {
          total += item['pace']!.floor();
        }
      }
      meanPace = (total / distancePace.length).floor();
    }

    MarathonController marathonController = Get.put(MarathonController());
    int myRank = -1;
    stompController.rankingList.map((item) {
      if (item.memberName == nickname) {
        myRank = item.memberRank;
      }
    });
    int totalDistanceInt = totalDistance.floor();
    String? temp = await storage.read(key: 'accessToken');
    print('날리기전 토큰 $temp');

    marathonController.marathon.value.marathonSeq = widget.roomInfo.marathonSeq;
    marathonController.marathon.value.marathonRecordRank = myRank;
    marathonController.marathon.value.marathonRecordStart =
        "POINT(${startLocation?.latitude} ${startLocation?.longitude})";
    marathonController.marathon.value.marathonRecordWay =
        jsonEncode(coordinates);
    marathonController.marathon.value.marathonRecordEnd =
        "POINT(${endLocation?.latitude} ${endLocation?.longitude})";
    marathonController.marathon.value.marathonRecordDist = totalDistanceInt;
    marathonController.marathon.value.marathonRecordTime = intelapsedseconds;
    marathonController.marathon.value.marathonRecordImage = '';
    marathonController.marathon.value.marathonRecordPace =
        jsonEncode(distancePace);
    marathonController.marathon.value.marathonRecordMeanPace = meanPace;
    marathonController.marathon.value.marathonRecordSpeed =
        jsonEncode(distanceSpeed);
    marathonController.marathon.value.marathonRecordMeanSpeed = meanSpeed;
    marathonController.marathon.value.marathonRecordHeartbeat = '';
    marathonController.marathon.value.marathonRecordMeanHeartbeat = -1;
    marathonController.marathon.value.marathonRecordIsWin =
        myRank == 1 ? true : false;

    marathonController.endMarathon();
  }

  void _handleEndButtonPress(BuildContext context) {
    StompController stompController =
        Get.put(StompController(roomIdx: widget.roomInfo.marathonSeq));
    stompController.client.deactivate();
    // print(stompController.client.isActive);
    if (_clockKey.currentState != null) {
      // Duration elapsedTime = _clockKey.currentState!.elapsed;
      double elapsedSeconds = _clockKey.currentState!.getElapsedSeconds();
      _clockKey.currentState!.setRunning(false);

      List<LatLng> coordinates = myMap.getCoordinates();
      List<Map<String, double>> distanceSpeed = myMap.getdistanceSpeed();
      List<Map<String, double>> distancePace = myMap.getdistancePace();

      Duration elapsedTime = Duration(seconds: elapsedSeconds.round());

      _sendRecordToServer();

      print('스피드 - $distanceSpeed');
      print('페이스 - $distancePace');
      Get.to(
        SingleResult(
          elapsedTime: elapsedTime,
          coordinates: coordinates,
          startLocation: coordinates.first,
          endLocation: coordinates.last,
          totaldist: formattedDistance,
          distanceSpeed: distanceSpeed,
          distancePace: distancePace,
          // controller: widget.controller,
          // myRank: -1,
          // endRank: const [],
        ),
      );

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => SingleResult(
      //       elapsedTime: elapsedTime,
      //       coordinates: coordinates,
      //       startLocation: coordinates.first,
      //       endLocation: coordinates.last,
      //       totaldist: formattedDistance,
      //       distanceSpeed: distanceSpeed,
      //       distancePace: distancePace,
      //       // controller: widget.controller,
      //       // myRank: -1,
      //       // endRank: const [],
      //     ),
      //   ),
      // );
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
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => SingleResult()));
                      // clock.(false); // Clock 멈추기
                      // Duration elapsedTime = _clockKey.currentState?.elapsed ?? Duration.zero;
                      // 종료 시 실행할 작업
                      // elapsedTime을 endlocation으로 넘겨주는 로직 추가
                      _handleEndButtonPress(context);
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
                      Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    Widget progressBar = Container();
    int currentPageIndex = 0;
    int remainingTime =
        widget.roomInfo.marathonEnd.difference(DateTime.now()).inSeconds;
    progressBar = DistBar(
        dist: widget.roomInfo.marathonDist,
        formattedDistance: double.parse(formattedDistance));

    Clock clockWidget = Clock(
      onTimerEnd: () {},
      key: _clockKey,
      time: remainingTime,
      elapsedTimeNotifier: elapsedTimeNotifier,
    );

    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: isLoading? null : AppBar(
        appBar: (!isLoading && !iscountdown)
            ? AppBar(
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(
                      50), // Adjust the height to accommodate the padding
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20), // Add padding below the buttons
                    child: Container(
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 11),
                            decoration: currentTab == 0
                                ? BoxDecoration(
                                    color: GREEN_COLOR,
                                    borderRadius: BorderRadius.circular(8),
                                  )
                                : null,
                            child: Text(
                              '정보',
                              style: TextStyle(
                                color: currentTab == 0
                                    ? Colors.white
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 150,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 11),
                            decoration: currentTab == 1
                                ? BoxDecoration(
                                    color: GREEN_COLOR,
                                    borderRadius: BorderRadius.circular(8),
                                  )
                                : null,
                            child: Text(
                              '지도',
                              style: TextStyle(
                                color: currentTab == 1
                                    ? Colors.white
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : null,
        body: Stack(children: [
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: SingleChildScrollView(
              // Wrap with SingleChildScrollView
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
                                        )),
                                    SizedBox(height: 5),
                                    ValueListenableBuilder<double>(
                                        valueListenable:
                                            myMap.totalDistanceNotifier,
                                        builder: (context, totalDistance, _) {
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
                                          String formattedPace =
                                              formatPace(pace);
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
                              Text(remainingTime == 0 ? '소요 시간' : '남은 시간',
                                  style: TextStyle(
                                    color: GRAY_500,
                                    fontSize: 19,
                                  )),
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
                                  )),
                              SizedBox(height: 5),
                              ValueListenableBuilder<double>(
                                  valueListenable: myMap.speedNotifier,
                                  builder: (context, speed, _) {
                                    return Text(
                                        '${speed.toStringAsFixed(2)} km/h',
                                        style: TextStyle(
                                          color: GREEN_COLOR,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700,
                                        ));
                                  }),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            '나의 경로',
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
                          )),
                      SizedBox(height: 15),
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
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        width: 400,
                        height: 200,
                        child: stompController.rankingList.isEmpty
                            ? Center(
                                child: Text(
                                  '곧 실시간 순위가 나타납니다',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Column(
                                children: [
                                  Expanded(child: Obx(() {
                                    return Column(
                                      children: stompController.rankingList
                                          .map((ranking) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${ranking.memberRank}',
                                                style: TextStyle(
                                                  color: DARK_GREEN_COLOR,
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              if (ranking
                                                  .memberImage.isNotEmpty)
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      ranking.memberImage),
                                                  radius: 20,
                                                )
                                              else
                                                CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  radius: 20,
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              SizedBox(width: 15),
                                              Text(
                                                ranking.memberName,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '${(ranking.memberDist / 1000).toStringAsFixed(2)} km',
                                                style: TextStyle(
                                                  color: DARK_GREEN_COLOR,
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  })),
                                ],
                              ),
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
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                  color: OATMEAL_COLOR,
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(
                            color: GREEN_COLOR,
                          ),
                        ]),
                  )),
            ),
          if (iscountdown)
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
        ]));
  }
}
