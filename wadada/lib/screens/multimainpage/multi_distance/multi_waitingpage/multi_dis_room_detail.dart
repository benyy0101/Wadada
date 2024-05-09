import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/multiController.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:wadada/controller/stompProvider.dart';
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
  late List<String> tags;
  _MultiRoomDetailState({
    required this.roomInfo,
  }) {
    controller = StompController(roomIdx: roomInfo.roomIdx);
    if (roomInfo.roomTag!.isNotEmpty) tags = roomInfo.roomTag!.split('#');
  }
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                                () => Text('1 / ${roomInfo.roomPeople}',
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
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: DARK_GREEN_COLOR,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '#직장인',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: DARK_GREEN_COLOR,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '#저녁런닝',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ],
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
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0), // 첫 번째 Column에 대한 양옆 padding
                            child: Column(
                              children: const [
                                Icon(Icons.person_add_alt_1,
                                    color: DARK_GREEN_COLOR, size: 30),
                                SizedBox(height: 20),
                                Icon(Icons.person,
                                    color: DARK_GREEN_COLOR, size: 30),
                                SizedBox(height: 20),
                                Icon(Icons.person,
                                    color: DARK_GREEN_COLOR, size: 30),
                              ],
                            ),
                          ),
                          SizedBox(width: 30), // 아이콘과 참가자 이름 사이의 간격
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0), // 두 번째 Column에 대한 양옆 padding
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  '스펀지밥',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: DARK_GREEN_COLOR,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  '아린시치',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: DARK_GREEN_COLOR,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  '커피보이',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: DARK_GREEN_COLOR,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30), // 참가자 이름과 준비완료/준비중 사이의 간격
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0), // 세 번째 Column에 대한 양옆 padding
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: DARK_GREEN_COLOR,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '준비중',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: GRAY_400,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '준비완료',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: GRAY_400,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '준비완료',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                if (!isButtonPressed) {
                                  setState(() {
                                    isButtonPressed = true;
                                  });
                                }

                                // 진행할 페이지
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: isButtonPressed
                                    ? Colors.grey[400]
                                    : GREEN_COLOR,
                                padding: EdgeInsets.only(
                                    left: 120, right: 120, top: 10, bottom: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                '준비완료',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                //Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors
                                    .grey[400], // GRAY_400 대신 실제 색상 값을 사용하세요.
                                padding: EdgeInsets.only(
                                    left: 100, right: 95, top: 10, bottom: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.exit_to_app),
                                  Text("  방 나가기 ",
                                      style: TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
