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
    controller.client.activate();
// Introduce a delay to allow time for activation to complete
    Future.delayed(Duration(milliseconds: 2000), () {
      // Now you can proceed with other actions
      print("send--------------------");
      controller.attend(roomInfo.roomIdx);
      //print(isHost);
      if (controller.numReady == controller.members.length - 1) toStart = true;
    });
    //if (roomInfo.roomTag!.isNotEmpty) tags = roomInfo.roomTag!.split('#');
  }

  void initControllers() {
    controller = StompController(roomIdx: roomInfo.roomIdx);
    multiController =
        MultiController(repo: MultiRepository(provider: MultiProvider()));
  }

  void splitTags() {
    List<String> temp = roomInfo.roomTag!.split('#');

    temp.forEach((item) {
      if (item != '') {
        tags.add("#" + item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('거리모드 - 멀티',
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
                        borderRadius: BorderRadius.circular(10),
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
                              color: DARK_GREEN_COLOR, size: 30),
                          SizedBox(width: 10),
                          Text('방 정보',
                              style: TextStyle(
                                  fontSize: 25,
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
                                size: 30,
                              ),
                              SizedBox(height: 20),
                              Icon(
                                Icons.people,
                                color: DARK_GREEN_COLOR,
                                size: 30,
                              ),
                              SizedBox(height: 20),
                              Icon(
                                Icons.lock,
                                color: DARK_GREEN_COLOR,
                                size: 30,
                              ),
                            ],
                          ),
                          SizedBox(width: 15),
                          // 두 번째 컬럼
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SizedBox(height: 5),
                              Text(
                                '거리',
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
                                '${roomInfo.roomDist} km',
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
                        childAspectRatio: 3, // Number of columns
                        shrinkWrap:
                            true, // Ensure that the GridView only occupies the space it needs
                        physics:
                            NeverScrollableScrollPhysics(), // Disable scrolling
                        children: List.generate(tags.length, (index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
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
                            size: 40,
                          ),
                          SizedBox(width: 10),
                          Text('참가자',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: DARK_GREEN_COLOR,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 30),
                      Obx(() {
                        final members = controller.members;
                        if (members == null || members.isEmpty) {
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
                                padding: EdgeInsets.symmetric(vertical: 10.0),
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
  GameOwner({super.key});

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
