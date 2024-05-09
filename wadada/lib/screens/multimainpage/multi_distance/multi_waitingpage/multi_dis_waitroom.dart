import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/multiController.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:wadada/repository/multiRepo.dart';
import 'package:wadada/screens/multimainpage/multi_distance/multi_waitingpage/multi_dis_room_detail.dart';
import 'package:wadada/screens/multimainpage/multi_distance/multi_waitingpage/multi_dis_roomcard.dart';
import 'package:wadada/screens/multimainpage/multi_distance/multi_waitingpage/multi_dist_room_form.dart';

class MultiDisWait extends StatefulWidget {
  MultiDisWait();

  @override
  _MultiDisWait createState() => _MultiDisWait();
}

class _MultiDisWait extends State<MultiDisWait> {
  final controller = Get.put(
      MultiController(repo: MultiRepository(provider: MultiProvider())));

  @override
  void initState() {
    super.initState();
    // Call the method to fetch data with the provided parameter
    controller.getMultiRoomsByMode(1);
  }

  @override
  Widget build(BuildContext context) {
    // controller.getMultiRoomsByMode(1);
    return Scaffold(
      appBar: AppBar(
        title: const Text('거리모드 - 멀티',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.only(
                left: 30,
                right: 30,
                bottom: 20), // Add padding to the bottom to avoid overflow
            child: Column(
              children: [
                // Rest of your content
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MultiDistanceRoomForm()),
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
                Obx(() {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.roomList.length,
                      itemBuilder: (context, idx) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MultiRoomDetail(
                                        roomInfo: controller.roomList[idx])),
                              );
                            },
                            child: Column(children: [
                              const SizedBox(height: 30),
                              DisRoomInfoCard(
                                  roomInfo: controller.roomList[idx]),
                            ]));
                      });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
