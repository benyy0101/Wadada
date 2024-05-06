import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';

class MultiRoomDetail extends StatefulWidget {
  const MultiRoomDetail({super.key});

  @override
  _MultiRoomDetailState createState() => _MultiRoomDetailState();
}

class _MultiRoomDetailState extends State<MultiRoomDetail> {

  bool isButtonPressed = false;

  int countdown = 5; // 카운트다운 시작 숫자

  void startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown <= 0) {
        timer.cancel(); // 타이머 종료
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('거리모드 - 멀티'),
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
                child: Container( // Container를 추가하여 왼쪽 여백을 주는 방법
                  margin: const EdgeInsets.only(left: 20.0), // 여기에서 왼쪽 여백을 조정
                  child: IntrinsicWidth(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green, // 적절한 색상 코드 사용
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                        child: Text(
                          '스펀지밥의 방',
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
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, color: DARK_GREEN_COLOR),
                          SizedBox(width: 10),
                          Text('방 정보', style: TextStyle(fontSize: 20, color: DARK_GREEN_COLOR, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          // 첫 번째 컬럼
                          Column(
                            children: [
                              Icon(Icons.location_on, color: DARK_GREEN_COLOR),
                              SizedBox(height: 20),
                              Icon(Icons.people, color: DARK_GREEN_COLOR),
                              SizedBox(height: 20),
                              Icon(Icons.lock, color: DARK_GREEN_COLOR),
                            ],
                          ),
                          SizedBox(width: 10),
                          // 두 번째 컬럼
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('거리'),
                              SizedBox(height: 20),
                              Text('참여 인원'),
                              SizedBox(height: 20),
                              Text('비밀방'),
                            ],
                          ),
                          SizedBox(width: 40), // 컬럼 사이의 간격
                          // 세 번째 컬럼
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('10km'),
                              SizedBox(height: 20),
                              Text('1/3'),
                              SizedBox(height: 20),
                              Text(''),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 20),


                    // Row(
                    //   children: [
                    //     Container(
                    //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    //       decoration: BoxDecoration(
                    //         color: Colors.green,
                    //         borderRadius: BorderRadius.circular(20),
                    //       ),
                    //       child: Text(
                    //         '#직장인',
                    //         style: TextStyle(fontSize: 12, color: Colors.white),
                    //       ),
                    //     ),

                    // ],),
                      

                    // Text('#직장인', 
                    // style: TextStyle(
                    //   fontSize: 12, 
                    //   color: Colors.white,
                    //   backgroundColor: DARK_GREEN_COLOR
                    //   )
                    // )




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
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.flag, color: DARK_GREEN_COLOR),
                          SizedBox(width: 10),
                          Text('참가자', style: TextStyle(fontSize: 20, color: DARK_GREEN_COLOR, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 40),


                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0), // 첫 번째 Column에 대한 양옆 padding
                            child: Column(
                              children: [
                                Icon(Icons.person_add_alt_1, color: DARK_GREEN_COLOR),
                                SizedBox(height: 20),
                                Icon(Icons.person, color: DARK_GREEN_COLOR),
                                SizedBox(height: 20),
                                Icon(Icons.person, color: DARK_GREEN_COLOR),
                              ],
                            ),
                          ),
                          SizedBox(width: 30), // 아이콘과 참가자 이름 사이의 간격
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0), // 두 번째 Column에 대한 양옆 padding
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('스펀지밥', style: TextStyle(fontSize: 15, color: DARK_GREEN_COLOR, fontWeight: FontWeight.bold),),
                                SizedBox(height: 20),
                                Text('아린시치', style: TextStyle(fontSize: 15, color: DARK_GREEN_COLOR, fontWeight: FontWeight.bold),),
                                SizedBox(height: 20),
                                Text('커피보이', style: TextStyle(fontSize: 15, color: DARK_GREEN_COLOR, fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                          SizedBox(width: 30), // 참가자 이름과 준비완료/준비중 사이의 간격
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0), // 세 번째 Column에 대한 양옆 padding
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('준비중', style: TextStyle(fontSize: 15, color: DARK_GREEN_COLOR),),
                                SizedBox(height: 20),
                                Text('준비완료', style: TextStyle(fontSize: 15, color: GRAY_400),),
                                SizedBox(height: 20),
                                Text('준비완료', style: TextStyle(fontSize: 15, color: GRAY_400),),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 40),


                      TextButton(
                        onPressed: () async {
                          setState(() {
                            isButtonPressed = true;
                          });

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              startCountdown();
                              return AlertDialog(
                                  backgroundColor: Colors.transparent, 
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '달리기를 시작합니다!',
                                        style: TextStyle(fontSize: 25, color: Colors.white),
                                      ),
                                      SizedBox(height: 20), // 문구와 카운트다운 사이의 간격
                                      Text(
                                        countdown > 0 ? '$countdown' : '', // 카운트다운 값이 0보다 클 때만 숫자 표시
                                        style: TextStyle(fontSize: 50, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                
                              );
                            }
                          );

                          await Future.delayed(Duration(seconds: 5)); 
                          Navigator.pop(context);
                          // 진행으로 라우팅
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => ))
                        },
                         style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: isButtonPressed ? Colors.grey[400] : GREEN_COLOR,
                          padding: EdgeInsets.symmetric(horizontal: 130, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('준비완료'), 
                      ),

                      const SizedBox(height: 10),

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: GRAY_400,
                          padding: EdgeInsets.symmetric(horizontal: 110, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.exit_to_app),
                            Text("  방 나가기 "),
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