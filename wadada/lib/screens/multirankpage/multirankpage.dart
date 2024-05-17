import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wadada/common/component/tabbars.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/stompController.dart';
import 'package:wadada/screens/mainpage/layout.dart';
// import 'package:wadada/screens/multimainpage/component/room.dart';
import 'package:wadada/screens/multiresultpage/multiresultpage.dart';
import 'package:wadada/screens/singlemainpage/single_main.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MultiRank extends StatefulWidget{
  final nickname = '닉네임';
  final rank = 1;
  final StompController controller;
  
  final Duration elapsedTime;
    final List<LatLng> coordinates;
    final LatLng startLocation;
    final LatLng endLocation;
    final String totaldist;
    final List<Map<String, double>> distanceSpeed;
    final List<Map<String, double>> distancePace;
    final int myRank;
    final List<dynamic> endRank;

    const MultiRank({super.key, 
        required this.elapsedTime,
        required this.coordinates,
        required this.startLocation,
        required this.endLocation,
        required this.totaldist,
        required this.distanceSpeed,
        required this.distancePace,
        required this.myRank,
        required this.endRank,
        required this.controller,
    });

  // void _handleEndButtonPress(BuildContext context) {

  // }

  @override
  _MultiRankState createState() => _MultiRankState();
}

class _MultiRankState extends State<MultiRank> {
  String nickname = '';

  @override
  void initState() {
    super.initState();
    loadNickname();  // 비동기 함수 호출
    // if (widget.controller.client.isActive) {
    //   widget.controller.client.deactivate();
    //   print('client 구독 끊음');
    // }

    if (widget.controller.newclient.isActive) {
      widget.controller.newclient.deactivate();
      print('newclient 구독 끊음');
    }
  }

  void _handleEndButtonPress(BuildContext context) {
    // if (_clockKey.currentState != null) {
        // Duration elapsedTime = _clockKey.currentState!.elapsed;
        // double elapsedSeconds = _clockKey.currentState!.getElapsedSeconds();
        // _clockKey.currentState!.setRunning(false);

        // List<LatLng> coordinates = myMap.getCoordinates();
        // List<Map<String, double>> distanceSpeed = myMap.getdistanceSpeed();
        // List<Map<String, double>> distancePace = myMap.getdistancePace();

        // Duration elapsedTime = Duration(seconds: elapsedSeconds.round());
        // String formattedElapsedTime = formatElapsedTime(elapsedTime);

        // final formattedElapsedTime = formatElapsedTime(elapsedTime);
        
        // _sendRecordToServer();

        print('스피드 - ${widget.distanceSpeed}');
        print('페이스 - ${widget.distancePace}');

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MultiResult(
                  elapsedTime: widget.elapsedTime,
                  coordinates: widget.coordinates,
                  startLocation: widget.startLocation,
                  endLocation: widget.endLocation,
                  totaldist: widget.totaldist,
                  distanceSpeed: widget.distanceSpeed,
                  distancePace: widget.distancePace,
                  endRank: widget.endRank,
                  controller: widget.controller,
              ),
          ),
      );
    // }
    // Navigator.push(context, MaterialPageRoute(builder: (context) => SingleResult()));
  }

  Future<void> loadNickname() async {
    final storage = FlutterSecureStorage();
    final loadedNickname = await storage.read(key: 'kakaoNickname');
    if (loadedNickname != null) {
      setState(() {
        nickname = loadedNickname;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
        Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              SizedBox(height: 150),
              SizedBox(
                width: 300,
                child: Image.asset('assets/images/running_result.png', width: 300),
              ),
              SizedBox(height: 20),
              Text('$nickname 님의 등수는\n${widget.myRank}등입니다 !',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 100),
              GestureDetector(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => SingleMain()));
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
                    child: Text('순위 & 통계 확인하기',
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MainLayout()));
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
            ]
          ),
          )
      );
    }
}