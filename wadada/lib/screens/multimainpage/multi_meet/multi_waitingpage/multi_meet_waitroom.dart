import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/multimainpage/multi_distance/multi_waitingpage/multi_dis_room_detail.dart';
import 'package:wadada/screens/multimainpage/multi_distance/multi_waitingpage/multi_dis_roomcard.dart';
import 'package:wadada/screens/multimainpage/multi_distance/multi_waitingpage/multi_dist_room_form.dart';

class MultiMeetWait extends StatelessWidget {
  const MultiMeetWait({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('만남모드 - 멀티', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              // 방 생성 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 방 생성하는 폼으로 슛
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MultiDistanceRoomForm()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: GREEN_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(90, 40), 
                    ),
                    child: const Text('방 생성하기'),
                  ),

                ],
              ),
              const SizedBox(height: 10),
              // 검색 창과 검색 버튼
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 39,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          hintText: '방 제목을 검색하세요.',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: GREEN_COLOR), 
                          ),
                          enabledBorder: OutlineInputBorder( 
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey), 
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // 검색 로직

                    },
                     style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: DARK_GREEN_COLOR, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: DARK_GREEN_COLOR),
                      ),
                    ),
                    child: Text('검색'),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // RoomInfoCard(),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MultiRoomDetail()),
                  // );
                },
                // child: RoomInfoCard(),
              ),
              const SizedBox(height: 30),
              // RoomInfoCard(),
             
            ],
          ),
        ),
      ),
    );
  }
}
