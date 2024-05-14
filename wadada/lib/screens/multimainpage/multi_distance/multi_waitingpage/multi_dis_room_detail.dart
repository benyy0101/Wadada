import 'dart:async';
import 'dart:ffi'; 
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/loginController.dart';
import 'package:wadada/controller/multiController.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/provider/loginProvider.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:wadada/controller/stompController.dart';
import 'package:wadada/repository/loginRepo.dart';
import 'package:wadada/repository/multiRepo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wadada/screens/multimainpage/multi_main.dart';
import 'package:wadada/screens/multirunpage/multirunpage.dart';
import 'package:wadada/screens/singlemainpage/single_main.dart';
import 'package:wadada/screens/singlerunpage/single_free_run.dart';
import 'package:geolocator/geolocator.dart';

class MultiRoomDetail extends StatefulWidget {
  SimpleRoom roomInfo;

  MultiRoomDetail({super.key, required this.roomInfo});

  @override
  _MultiRoomDetailState createState() =>
      _MultiRoomDetailState(roomInfo: roomInfo);
}

class _MultiRoomDetailState extends State<MultiRoomDetail> {
  SimpleRoom roomInfo;
  late StompController controller;
  late MultiController multiController;
  List<String> tags = [];
  String titleText = '';
  String optionMetric = '';
  String roomOption = '';
  final storage = FlutterSecureStorage();

  bool isHost = false;
  bool isButtonPressed = false;
  bool toStart = false;

  _MultiRoomDetailState({
    required this.roomInfo,
  }) {
    splitTags();
    initControllers();
    print("-----------------initiating websocket----------------");
    controller.attend(roomInfo.roomIdx);
    setRoomInfo();
  }

  void initControllers() {
    controller = StompController(roomIdx: roomInfo.roomIdx);
    multiController =
        MultiController(repo: MultiRepository(provider: MultiProvider()));
  }

  void splitTags() {
    List<String> temp = roomInfo.roomTag!.split('#');

    for (var item in temp) {
      if (item != '') {
        tags.add("#$item");
      }
    }
  }

  void setRoomInfo() {
    print(roomInfo.roomMode);
    if (roomInfo.roomMode == 1) {
      titleText = '거리모드 - 멀티';
      roomOption = '거리';
      optionMetric = 'km';
    } else if (roomInfo.roomMode == 2) {
      titleText = '시간모드 - 멀티';
      roomOption = '시간';
      optionMetric = '분';
    } else {
      titleText = '만남모드 - 멀티';
      roomOption = '';
      optionMetric = '';
    }
  }

  @override
  void initState() {
    super.initState();

    // // 게임 시작 응답을 감시하여 처리
    // ever(controller.gameStartResponse.value, (bool response) {
    //   if (response) {
    //     // 게임 시작 응답을 받았을 때 처리할 로직을 여기에 작성
    //     _checkAndRequestLocationPermissionForAllParticipants();
    //   }
    // });

    controller.gameStartResponse.addListener(() {
      bool value = controller.gameStartResponse.value;
      if (value == true) {
        _checkAndRequestLocationPermission();
      }
      // print('Gamego value changed: $value');
    });
  }

  Future<void> _checkAndRequestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 비활성화되어 있으면 사용자에게 위치 서비스를 활성화하도록 요청
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        // 사용자가 위치 서비스를 활성화하지 않으면 앱을 종료
        return;
      }
    }

    // 현재 위치 권한 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // 사용자가 위치 권한을 영구적으로 거부한 경우 설정 앱으로 이동하여 사용자가 권한을 변경할 수 있도록 안내
      await Geolocator.openAppSettings();
      return;
    }

    if (permission == LocationPermission.denied) {
      // 사용자가 위치 권한을 거부한 경우 권한을 요청
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // 권한이 부여되지 않으면 사용자에게 메시지를 표시하고 앱을 종료
        // 권한을 받지 못하면 런을 시작할 수 없음
        return;
      }
    }

    // 위치 권한이 허용된 경우, 멀티런 페이지로 이동
    String appKey = dotenv.env['APP_KEY'] ?? '';
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => MultiRun(
    //       time: 0,
    //       dist: roomInfo.roomDist,
    //       appKey: appKey,
    //       controller: controller,
    //       multiController: multiController,
    //       roomInfo: roomInfo,
    //     ),
    //   ),
    // );
    // ).then((_) {
    //   controller.client.deactivate();
    // });
    // 위치 권한이 허용된 경우, 멀티런 페이지로 이동
    if (mounted) {
      String appKey = dotenv.env['APP_KEY'] ?? '';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiRun(
            time: 0,
            dist: roomInfo.roomDist,
            appKey: appKey,
            controller: controller,
            multiController: multiController,
            roomInfo: roomInfo,
          ),
        ),
      ).then((_) {
      controller.client.deactivate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(titleText,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(width: 20),
              // 방 이름
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  child: IntrinsicWidth(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 10),
                        child: Text(
                          roomInfo.roomTitle,
                          // controller.getMultiRoomsByMode(1).roomList[roomIdx],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // 방 정보
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: OATMEAL_COLOR,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.info_outline,
                              color: DARK_GREEN_COLOR, size: 25),
                          SizedBox(width: 10),
                          Text('방 정보',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: DARK_GREEN_COLOR,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          // 첫 번째 컬럼
                          Column(
                            children: const [
                              SizedBox(height: 10),
                              Icon(
                                Icons.location_on,
                                color: DARK_GREEN_COLOR,
                                size: 28,
                              ),
                              SizedBox(height: 20),
                              Icon(
                                Icons.people,
                                color: DARK_GREEN_COLOR,
                                size: 28,
                              ),
                              SizedBox(height: 20),
                              Icon(
                                Icons.lock,
                                color: DARK_GREEN_COLOR,
                                size: 28,
                              ),
                            ],
                          ),
                          SizedBox(width: 15),
                          // 두 번째 컬럼
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                roomOption,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: DARK_GREEN_COLOR),
                              ),
                              SizedBox(height: 20),
                              Text(
                                '참여 인원',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: DARK_GREEN_COLOR),
                              ),
                              SizedBox(height: 20),
                              Text(
                                '비밀방',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: DARK_GREEN_COLOR),
                              ),
                            ],
                          ),
                          SizedBox(width: 40),
                          // 세 번째 컬럼
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                '${roomInfo.roomDist} $optionMetric',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: DARK_GREEN_COLOR),
                              ),
                              SizedBox(height: 20),
                              //현재인원 받아와야 하는 곳
                              Obx(
                                () => Text(
                                    '${controller.members.length} / ${roomInfo.roomPeople}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: DARK_GREEN_COLOR)),
                              ),
                              SizedBox(height: 20),
                              Text('',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: DARK_GREEN_COLOR)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 5, // Number of columns
                        shrinkWrap:
                            true, // Ensure that the GridView only occupies the space it needs
                        physics:
                            NeverScrollableScrollPhysics(), // Disable scrolling
                        children: List.generate(tags.length, (index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 2),
                            child: Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: DARK_GREEN_COLOR,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    tags[index],
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 참가자
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: OATMEAL_COLOR,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.flag,
                            color: DARK_GREEN_COLOR,
                            size: 28,
                          ),
                          SizedBox(width: 10),
                          Text('참가자',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: DARK_GREEN_COLOR,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 20),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     controller.flaginfo(roomInfo.roomIdx);
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: DARK_GREEN_COLOR, // Background color
                      //   ),
                      //   child: Text("목적지 추천"),
                      // ),
                      Obx(() {
                        final members = controller.members;
                        if (members.isEmpty) {
                          // Show a loading indicator or a placeholder
                          return Center(
                            child:
                                CircularProgressIndicator(), // Or any other placeholder widget
                          );
                        } else {
                          // Show the list when data is available
                          return ListView.builder(
                            itemCount: members.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final member = members[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage(member.memberProfileImage),
                                  ),
                                  title: Text(
                                    member.memberNickname,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: member.manager
                                          ? Colors.deepPurpleAccent
                                          : DARK_GREEN_COLOR,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '레벨: ${member.memberLevel}',
                                    style: TextStyle(
                                      color: DARK_GREEN_COLOR,
                                    ),
                                  ),
                                  trailing: member.manager
                                      ? GameOwner()
                                      : PlayerCondition(
                                          isReady: member.memberReady),
                                ),
                              );
                            },
                          );
                        }
                      }),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),

              //팀원일때 준비 버튼
              Visibility(
                visible: controller.isOwner,
                child: TextButton(
                  onPressed: () {
                    controller.ready(roomInfo.roomIdx);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        isButtonPressed ? Colors.grey[400] : GREEN_COLOR,
                    padding: EdgeInsets.only(
                        left: 155, right: 155, top: 10, bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '준비완료',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              //방장일때 레디 버튼
              Visibility(
                  visible: !controller.isOwner,
                  child: Obx(() {
                    print("controller.numREady--------------");
                    print(controller.numReady);
                    return TextButton(
                      onPressed:
                          controller.numReady == controller.members.length - 1
                              ? () {
                                  controller.gameStart();
                                }
                              : null,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            controller.numReady == controller.members.length - 1
                                ? GREEN_COLOR
                                : Colors.grey[400],
                        padding: EdgeInsets.only(
                            left: 155, right: 155, top: 10, bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        '시작하기',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  })),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  controller.out(roomInfo.roomIdx);
                  Get.back();
                  //Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      Colors.grey[400], // GRAY_400 대신 실제 색상 값을 사용하세요.
                  padding: EdgeInsets.only(
                      left: 135, right: 135, top: 10, bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.exit_to_app),
                    Text("  방 나가기 ", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerCondition extends StatelessWidget {
  bool isReady;
  PlayerCondition({super.key, required this.isReady});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isReady ? DARK_GREEN_COLOR : GRAY_400,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isReady ? '준비완료' : '대기중',
        style: TextStyle(fontSize: 15, color: Colors.white),
      ),
    );
  }
}

class GameOwner extends StatelessWidget {
  const GameOwner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: DARK_GREEN_COLOR,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "방장",
        style: TextStyle(fontSize: 15, color: Colors.white),
      ),
    );
  }
}
