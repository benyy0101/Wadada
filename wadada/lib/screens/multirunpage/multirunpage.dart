import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
// import 'package:flutter/rendering.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/stompController.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:wadada/repository/multiRepo.dart';
import 'package:wadada/screens/multiendpage/multiendpage.dart';
import 'package:wadada/screens/multirankpage/multirankpage.dart';
import 'package:wadada/screens/multiresultpage/multiresultpage.dart';
import 'package:wadada/screens/multirunpage/multierror.dart';
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

class MultiRun extends StatefulWidget{
  final int time;
  final int dist;
  final String appKey;
  final StompController controller;
  final MultiController multiController;
  final double centerlat;
  final double centerlong;
  SimpleRoom roomInfo;
  MultiRun({
    super.key, 
    required this.time, 
    required this.dist, 
    required this.appKey, 
    required this.controller, 
    required this.multiController, 
    required this.roomInfo,
    required this.centerlat,
    required this.centerlong,
  });
  
  @override
  _MultiRunState createState() => _MultiRunState();
}

class _MultiRunState extends State<MultiRun> {
  late StompClient stompClient;
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> isCountdownNotifier = ValueNotifier<bool>(false);
  int countdown = 5;
  Timer? countdownTimer;
  bool showCountdown = false;
  int currentTab = 0;
  int? recordSeq;
  double totalDistance = 0.0;
  int totalDistanceInt = 0;
  String formattedDistance = '0.00';
  List<dynamic>? rankingData = [];
  List<dynamic>? flagranking = [];
  ValueNotifier<Duration> elapsedTimeNotifier = ValueNotifier<Duration>(Duration.zero);
  final GlobalKey<ClockState> _clockKey = GlobalKey<ClockState>();
  late Clock clock;
  late MyMap myMap;
  final GlobalKey<MyMapState> myMapStateKey = GlobalKey<MyMapState>();
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

    int moderoom = widget.roomInfo.roomMode;

    // print('들어온 시간 ${widget.time}');
    // print('들어온 거리 ${widget.dist}');

    // _initWebSocketListener();

    myMap = MyMap(appKey: widget.appKey, key: myMapStateKey, centerplace: LatLng(widget.centerlat, widget.centerlong), moderoom: moderoom);
    onPageLoaded();
    // _onGameGoChanged();
    
    // widget.controller.gamego.addListener(_onGameGoChanged);
    startGameGoTimer();
    print('ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ: ${widget.controller.gameStartResponse.value}');

    clock = Clock(key: _clockKey, time: widget.time, elapsedTimeNotifier: elapsedTimeNotifier, onTimerEnd: _onTimerEnd,);

    widget.controller.requestinfo.addListener(() {
      sendrequestInfo();
    });

    if (widget.roomInfo.roomMode == 1) {
      widget.controller.ranking.addListener(() {
        setState(() {
          rankingData = widget.controller.ranking.value;
        });
        updateRankingData(rankingData);
      });
    }
    _subscribeToTotalDistance();

    if (widget.roomInfo.roomMode == 2) {
      widget.controller.ranking.addListener(() {
        setState(() {
          rankingData = widget.controller.ranking.value;
        });
      });
    }

    isLoadingNotifier.addListener(_checkFlagModeCondition);
    isCountdownNotifier.addListener(_checkFlagModeCondition);

    myMapStateKey.currentState?.startGame();
  }

  void _checkFlagModeCondition() {
    if (widget.roomInfo.roomMode == 3 && !isLoadingNotifier.value && !isCountdownNotifier.value) {
      myMap.currentLocationNotifier.addListener(() {
        if (myMap.currentLocationNotifier.value != null) {
          setState(() {
            firstflag(myMap.currentLocationNotifier.value);
          });
        }
      });

      widget.controller.ranking.addListener(() {
        setState(() {
          rankingData = widget.controller.ranking.value;
        });
      });

      widget.controller.flagend.addListener(() {
        setState(() {
          flagranking = widget.controller.flagend.value;
        });
        updateFlagRanking(flagranking);
      });
    }
  }

  void _onTimerEnd() {
    updateRanking2Data(rankingData);
  }

  void updateFlagRanking(List<dynamic>? newFlagData) async {
    if (newFlagData == null || newFlagData.isEmpty) return;

    final storage = FlutterSecureStorage();
    String? username1 = await storage.read(key: 'kakaoNickname');
    final myRank = rankingData!.indexWhere((member) => member['memberNickname'] == username1);
    List<dynamic>? endranking = newFlagData;

    double elapsedSeconds = _clockKey.currentState!.getElapsedSeconds();
    _clockKey.currentState!.setRunning(false);

    List<LatLng> coordinates = myMap.getCoordinates();
    List<Map<String, double>> distanceSpeed = myMap.getdistanceSpeed();
    List<Map<String, double>> distancePace = myMap.getdistancePace();

    Duration elapsedTime = Duration(seconds: elapsedSeconds.round());
    String formattedElapsedTime = formatElapsedTime(elapsedTime);
    _sendRecordToServer();
    myMapStateKey.currentState?.endGame();

    // 게임 결과 페이지로 이동
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
            myRank: myRank+1,
            endRank: endranking,
            controller: widget.controller,
        ),
      ),
    );
  }

  void firstflag(LatLng? currentLocation) async {
      double flagdistance = Geolocator.distanceBetween(
        currentLocation!.latitude,
        currentLocation.longitude,
        widget.centerlat,
        widget.centerlong,
      );

      print('깃발이랑 거리 $flagdistance');

      if (flagdistance < 8) {
        print('깃발이랑 거리 가까움');
        // // print('ㅇㅇ');
        final dio = Dio();
        final url = Uri.parse('https://k10a704.p.ssafy.io/Multi/game/end/${widget.controller.receivedRoomSeq}');
        final storage = FlutterSecureStorage();
        String? accessToken = await storage.read(key: 'accessToken');
        // String? username1 = await storage.read(key: 'kakaoNickname');

        try {
          final response = await dio.get(url.toString(),
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'authorization': accessToken
            }));

          if (response.statusCode == 200) {
            // final data = response.data as String;
            print('깃발 끝 통신 성공');
            // return data;
          } else if (response.statusCode == 204) {
            print('204');
            // return {};
          } else {
            print('서버 요청 실패: ${response.statusCode}');
            // return {};
          }
        } catch (e) {
          print('요청 처리 중 에러 발생: $e');
          // return {};
        }  
      }
    }

  void updateRanking2Data(List<dynamic>? newRankingData) async {
    if (newRankingData == null || newRankingData.isEmpty) return;

    final storage = FlutterSecureStorage();
    String? username1 = await storage.read(key: 'kakaoNickname');
    final myRank = rankingData!.indexWhere((member) => member['memberNickname'] == username1);
    List<dynamic>? endranking = newRankingData;

    double elapsedSeconds = _clockKey.currentState!.getElapsedSeconds();
    _clockKey.currentState!.setRunning(false);

    List<LatLng> coordinates = myMap.getCoordinates();
    List<Map<String, double>> distanceSpeed = myMap.getdistanceSpeed();
    List<Map<String, double>> distancePace = myMap.getdistancePace();

    Duration elapsedTime = Duration(seconds: elapsedSeconds.round());
    String formattedElapsedTime = formatElapsedTime(elapsedTime);
    _sendRecordToServer();
    myMapStateKey.currentState?.endGame();

    // 게임 결과 페이지로 이동
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
            myRank: myRank+1,
            endRank: endranking,
            controller: widget.controller,
        ),
      ),
    );
  }


  void updateRankingData(List<dynamic>? newRankingData) async {
    if (newRankingData == null || newRankingData.isEmpty) return;

    final exceedingMembers = rankingData!.where((member) => member['memberDist'] >= (widget.dist * 1000)).toList();

    if (exceedingMembers.isNotEmpty) {
      final storage = FlutterSecureStorage();
      String? username1 = await storage.read(key: 'kakaoNickname');
      final myRank = rankingData!.indexWhere((member) => member['memberNickname'] == username1);
      List<dynamic>? endranking = newRankingData;

      double elapsedSeconds = _clockKey.currentState!.getElapsedSeconds();
      _clockKey.currentState!.setRunning(false);

      List<LatLng> coordinates = myMap.getCoordinates();
      List<Map<String, double>> distanceSpeed = myMap.getdistanceSpeed();
      List<Map<String, double>> distancePace = myMap.getdistancePace();

      Duration elapsedTime = Duration(seconds: elapsedSeconds.round());
      String formattedElapsedTime = formatElapsedTime(elapsedTime);
      _sendRecordToServer();
      myMapStateKey.currentState?.endGame();

      // 게임 결과 페이지로 이동
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
              myRank: myRank+1,
              endRank: endranking,
              controller: widget.controller,
          ),
        ),
      );
    }
  }

  void _subscribeToTotalDistance() {
    myMap.totalDistanceNotifier.addListener(() {
      setState(() {
        totalDistance = myMap.totalDistanceNotifier.value;
        totalDistanceInt = totalDistance.round();
        double distanceInKm = totalDistance / 1000.0;
        formattedDistance = distanceInKm.toStringAsFixed(2);
      });
    });
  }

  Future<void> sendrequestInfo() async {
    final dio = Dio();
      final url = Uri.parse('https://k10a704.p.ssafy.io/Multi/game/data');
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');
      String? username1 = await storage.read(key: 'kakaoNickname');
      // int totalDistance11 = 0;

      // myMap.totalDistanceNotifier.addListener(() {
      //   setState(() {
      //     totalDistance1 = myMap.totalDistanceNotifier.value;
      //     totalDistance11 = totalDistance1.round();
      //     // double distanceInKm = totalDistance / 1000.0;
      //     // formattedDistance = distanceInKm.toStringAsFixed(2);
      //   });
      // });

      double elapsedSeconds = _clockKey.currentState!.getElapsedSeconds();
      int intelapsedseconds = elapsedSeconds.toInt();
      double requestlat = myMap.currentLocationNotifier.value!.latitude;
      double requestlong = myMap.currentLocationNotifier.value!.longitude;

      // int totalDistance1 = totalDistance.toInt();

      final requestBody = jsonEncode({
        "roomSeq": widget.controller.receivedRoomSeq,
        "userDist": totalDistanceInt,
        "userTime": intelapsedseconds,
        "userName": username1,
        "userLat": requestlat,
        "userLng": requestlong,
      });

      print('roomSeq111111: ${widget.controller.receivedRoomSeq}');
      print('userTime: $intelapsedseconds');
      print('userDist: $totalDistanceInt');
      print('userName: $username1');

      try {
        final response = await dio.post(
          url.toString(),
          data: requestBody,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'authorization': accessToken,
          }),
        );


        if (response.statusCode == 200) {
          print('현재 정보 전송 성공: ${response.data}');
        } else {
          print('서버 요청 실패: ${response.statusCode}');
        }
      } catch (e) {
        print('거리 보내기 - 요청 처리 중 에러 발생: $e');
      }
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
          isCountdownNotifier.value = false;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _clockKey.currentState?.start();
        });
        }
      });
    });
  }

  @override
  void dispose() {
    stompClient.deactivate();
    countdownTimer?.cancel();
    myMapStateKey.currentState?.endGame();
    myMapStateKey.currentState?.dispose();
    // _requestinfoSubscription.cancel();
    super.dispose();
  }

  void startGameGoTimer() {
    Timer(Duration(seconds: 30), () {
        if (!widget.controller.gamego.value) {
          closeLoadingAndStartCountdown();
        }
      });
  }

  // void _onGameGoChanged() {
  //   // bool response = widget.controller.gamego.value;
  //   if (widget.controller.gamego.value) {
  //     // 게임 시작 처리 로직을 여기에 추가합니다.
  //     closeLoadingAndStartCountdown();
  //   }
  // }

  void onPageLoaded() {
    if (widget.controller.gameStartResponse.value) {
      myMap.startLocationNotifier.addListener(() {
        if (myMap.startLocation != null) {
            print('보냄');
            sendLocationToServer();
        } else {
          Get.to(() => MultiError(controller: widget.controller));
        }
      });
    }

    widget.controller.gamego.addListener(() {
      print('gamego value 들어오나 ${widget.controller.gamego.value}');
      if (widget.controller.gamego.value) {
        print('closeloadingandstartcountdown true임');
        closeLoadingAndStartCountdown();
      }
    });

    // myMap.startLocationNotifier.addListener(() {
    //   if (myMap.startLocation != null) {
    //       sendLocationToServer();
    //   }
    // });

    // myMap.startLocationNotifier.addListener(() {
    //   if (myMap.startLocation != null) {
    //       print("ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ");
    //   }
    // });

    // // 30초 후에 로딩 창이 닫히도록 타이머 설정
    // Timer(Duration(seconds: 30), () {
    //   print('30초 지남');
    //   // 30초 후에 로딩 창 닫기 및 카운트다운 시작
    //   closeLoadingAndStartCountdown();
    // });
  }

  void closeLoadingAndStartCountdown() {
    setState(() {
      isLoadingNotifier.value = false;
      isCountdownNotifier.value = true;
    });
    startTimers();
  }

  MultiController controller = Get.find<MultiController>();

  // 008 controller
  // Future<void> sendLocationToServer() async {
  //   final startLocation = myMap.startLocation;

  //   double lat = startLocation!.latitude;
  //   double long = startLocation.longitude;
  //   int roomIdx = widget.controller.receivedRoomSeq;
  //   int people = widget.roomInfo.roomPeople;

  //   controller.sendStartLocation(lat, long, roomIdx, people);
  //   print('ㅇㅇ');
  // }

  Future<void> sendLocationToServer() async {
    final startLocation = myMap.startLocation;
    final dio = Dio();
    int recordMode = widget.time > 0 ? 2 : 1;
        
    if (startLocation != null) {
      final url = Uri.parse('https://k10a704.p.ssafy.io/Multi/start');
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');

      final requestBody = jsonEncode({
        // "recordMode": recordMode,
        "recordStartLocation": "POINT(${startLocation.latitude} ${startLocation.longitude})",
        "recordPeople": widget.roomInfo.roomPeople,
        // "roomSeq": widget.controller.receivedRoomSeq,
        "roomSeq": widget.controller.receivedRoomSeq,
      });
      
      try {
        final response = await dio.post(
          url.toString(),
          data: requestBody,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'authorization': accessToken,
          }),
        );
        
        if (response.statusCode == 200) {
          // recordSeq = response.data;
          final responseData = response.data as Map<String, dynamic>;
          recordSeq = responseData['recordSeq'] as int?;
          print('서버 요청 성공: $recordSeq');
        } else {
          print('서버 요청 실패: ${response.statusCode}');
        }
      } catch (e) {
          print(widget.controller.receivedRoomSeq);
          print(widget.roomInfo.roomPeople);
          print('요청 처리 중 에러 발생: $e');
      }
    } else {
        print("초기 위치를 찾을 수 없습니다.");
    }
  }

  String formatPace(double paceInSecondsPerKm) {
    int minutes = 0;
    int seconds = 0;
    if (paceInSecondsPerKm.isNaN || paceInSecondsPerKm.isInfinite) {
      minutes = 0;
      seconds = 0;
    } else {
      minutes = (paceInSecondsPerKm / 60).floor();
      seconds = (paceInSecondsPerKm % 60).round();
    }

    return "$minutes'${seconds.toString().padLeft(2, '0')}''";
  }

  String formatElapsedTime(Duration elapsedTime) {
    int hours = elapsedTime.inHours;
    int minutes = elapsedTime.inMinutes.remainder(60);
    int seconds = elapsedTime.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // 009 controller
  // Future<void> _sendRecordToServer() async {
  //   final MultiController multiController = Get.put(MultiController(repo: MultiRepository(provider: MultiProvider())));

  //   final startLocation = myMap.startLocation;
  //   final endLocation = myMap.endLocation;

  //   int recordMode = widget.time > 0 ? 2 : 1;

  //   double elapsedSeconds = _clockKey.currentState!.getElapsedSeconds();
  //   int intelapsedseconds = elapsedSeconds.toInt();
  //   print('초 시간? $intelapsedseconds');
  //   Duration elapsedTime = Duration(seconds: elapsedSeconds.round());
  //   String formattedElapsedTime = formatElapsedTime(elapsedTime);
  //   print(formattedElapsedTime);

  //   List<LatLng> coordinates = myMap.getCoordinates();
  //   List<Map<String, double>> distanceSpeed = myMap.getdistanceSpeed();
  //   List<Map<String, double>> distancePace = myMap.getdistancePace();

  //   int totalDistanceInt = totalDistance.floor();

  //   MultiRoomGameEnd gameEndData = MultiRoomGameEnd(
  //     roomSeq: widget.controller.receivedRoomSeq, // 수정 필요
  //     recordImage: 'your_record_image',
  //     recordDist: totalDistanceInt,
  //     recordTime: intelapsedseconds,
  //     recordStartLocation: "POINT(${startLocation?.latitude} ${startLocation?.longitude})",
  //     recordEndLocation: "POINT(${endLocation?.latitude} ${endLocation?.longitude})", 
  //     recordWay: jsonEncode(coordinates),
  //     recordSpeed: jsonEncode(distanceSpeed),
  //     recordPace: jsonEncode(distancePace),
  //     recordHeartbeat: jsonEncode(distancePace),
  //     recordRank: 1, // 수정 필요
  //   );

  //   multiController.gameEndInfo = gameEndData;
  //   multiController.endGame();
  // }

  Future<void> _sendRecordToServer() async {
    final startLocation = myMap.startLocation;
    final endLocation = myMap.endLocation;
    final url = Uri.parse('https://k10a704.p.ssafy.io/Multi/result');
    final dio = Dio();
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');
    String? username1 = await storage.read(key: 'kakaoNickname');
    final myRank = rankingData!.indexWhere((member) => member['memberNickname'] == username1);
    
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

    final requestBody = jsonEncode({
        "roomSeq": widget.controller.receivedRoomSeq,
        "recordImage": 'https://github.com/jjeong41/t/assets/103355863/4e6d205d-694e-458c-b992-8ea7c27b85b1',
        "recordDist": totalDistance, // int
        "recordTime": intelapsedseconds, // int
        "recordStartLocation": "POINT(${startLocation?.latitude} ${startLocation?.longitude})",
        "recordEndLocation": "POINT(${endLocation?.latitude} ${endLocation?.longitude})",
        "recordWay": jsonEncode(coordinates),
        "recordSpeed": jsonEncode(distanceSpeed),
        "recordPace": jsonEncode(distancePace),
        "recordHeartbeat": jsonEncode(distancePace),
        "recordRank": myRank + 1,
    });

    try {
      final response = await dio.post(
        url.toString(),
        data: requestBody,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': accessToken ?? 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDUyNzIxNzM3IiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE0ODgzODg1fQ.7nS18Nv6vBsmIIzOh03-_RYS1UHcXDLygj9PUwDN1Vo',
        }),
      );

      if (response.statusCode == 200) {
        print('responseData type: ${response.data.runtimeType}');
        print('서버 요청 성공 - 결과 저장');
      } else {
        print('서버 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('요청 처리 중 에러 발생: $e');
    }
    print(jsonDecode(requestBody));
  }

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

        // _sendRecordToServer();

        print('스피드 - $distanceSpeed');
        print('페이스 - $distancePace');
        myMapStateKey.currentState?.endGame();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiEnd(
                elapsedTime: elapsedTime,
                coordinates: coordinates,
                startLocation: coordinates.first,
                endLocation: coordinates.last,
                totaldist: formattedDistance,
                distanceSpeed: distanceSpeed,
                distancePace: distancePace,
                controller: widget.controller,
                // myRank: -1,
                // endRank: const [],
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
    int currentPageIndex = 0;

    if (widget.dist > 0) {
        progressBar = DistBar(dist: widget.dist, formattedDistance: double.parse(formattedDistance));
    }
    // } else if (widget.time > 0) {
    //     double elapsedSeconds = _clockKey.currentState?.getElapsedSeconds() ?? 0.0;
    //     double elapsedTimeInSeconds = elapsedSeconds;

    //     progressBar = ValueListenableBuilder<Duration>(
    //         valueListenable: elapsedTimeNotifier,
    //         builder: (context, elapsedDuration, _) {
    //             // Convert Duration to double
    //             double elapsedTimeInSeconds = elapsedDuration.inSeconds.toDouble();
                
    //             // Pass the elapsed time in seconds to TimeBar
    //             return TimeBar(
    //                 initialTime: widget.time,
    //                 elapsedTime: elapsedTimeInSeconds,
    //             );
    //         },
    //     );
    // }

    Clock clockWidget = Clock(
        key: _clockKey,
        time: widget.time,
        elapsedTimeNotifier: elapsedTimeNotifier,
        onTimerEnd: _onTimerEnd,
    );

    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: (!isLoadingNotifier.value && !isCountdownNotifier.value)
                ? AppBar(
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(25),
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
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                              decoration: currentTab == 0
                                  ? BoxDecoration(
                                      color: GREEN_COLOR,
                                      borderRadius: BorderRadius.circular(8),
                                    )
                                  : null,
                              child: Text(
                                '정보',
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
                              child: Text(
                                '지도',
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
                      ),
                    ),
                  )
                : null,
            body: SingleChildScrollView(
              child: Stack(
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
                                SizedBox(height: 20),
                                progressBar,
                                SizedBox(height: 35),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '이동거리',
                                            style: TextStyle(
                                              color: GRAY_500,
                                              fontSize: 19,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          ValueListenableBuilder<double>(
                                            valueListenable: myMap.totalDistanceNotifier,
                                            builder: (context, totalDistance, _) {
                                              return Text(
                                                '$formattedDistance km',
                                                style: TextStyle(
                                                  color: GREEN_COLOR,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '현재 페이스',
                                            style: TextStyle(
                                              color: GRAY_500,
                                              fontSize: 19,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          ValueListenableBuilder<double>(
                                            valueListenable: myMap.paceNotifier,
                                            builder: (context, pace, _) {
                                              String formattedPace = formatPace(pace);
                                              return Text(
                                                formattedPace,
                                                style: TextStyle(
                                                  color: GREEN_COLOR,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.time == 0 ? '소요 시간' : '남은 시간',
                                      style: TextStyle(
                                        color: GRAY_500,
                                        fontSize: 19,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    clockWidget,
                                  ],
                                ),
                                SizedBox(height: 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '현재 속도',
                                      style: TextStyle(
                                        color: GRAY_500,
                                        fontSize: 19,
                                      ),
                                    ),
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
                                          ),
                                        );
                                      },
                                    ),
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
                            Text(
                              '실시간 순위',
                              style: TextStyle(
                                color: GRAY_500,
                                fontSize: 19,
                              ),
                            ),
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
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                              width: 400,
                              height: 200,
                              child: rankingData!.isEmpty
                                  ? Center(
                                      child: Text(
                                        '곧 실시간 순위가 나타납니다',
                                        style: TextStyle(fontSize: 16, color: Colors.grey),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Expanded(
                                          child: PageView.builder(
                                            itemCount: (rankingData!.length / 3).ceil(),
                                            onPageChanged: (pageIndex) {
                                              setState(() {
                                                currentPageIndex = pageIndex;
                                              });
                                            },
                                            itemBuilder: (context, pageIndex) {
                                              final startIndex = pageIndex * 3;
                                              final endIndex = (startIndex + 3).clamp(0, rankingData!.length);
                                              final currentPageData = rankingData!.sublist(startIndex, endIndex);

                                              return Column(
                                                children: currentPageData.map((ranking) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          '${ranking['memberRank']}',
                                                          style: TextStyle(
                                                            color: DARK_GREEN_COLOR,
                                                            fontSize: 23,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 20),
                                                        if (ranking['memberProfile'] != null &&
                                                            ranking['memberProfile'].isNotEmpty)
                                                          CircleAvatar(
                                                            backgroundImage: NetworkImage(ranking['memberProfile']),
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
                                                          '${ranking['memberNickname']}',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          '${(ranking['memberDist'] / 1000).toStringAsFixed(2)} km',
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
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: List.generate((rankingData!.length / 3).ceil(), (index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    currentPageIndex = index;
                                                  });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Icon(
                                                    Icons.circle,
                                                    size: 10,
                                                    color: currentPageIndex == index ? GREEN_COLOR : Colors.grey,
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
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
                              child: Text(
                                '종료하기',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
          if (isLoadingNotifier.value)
            Positioned.fill(
              child: Scaffold(
                backgroundColor: OATMEAL_COLOR,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(
                        color: GREEN_COLOR,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (isCountdownNotifier.value)
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