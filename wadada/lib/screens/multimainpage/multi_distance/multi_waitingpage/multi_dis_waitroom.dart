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
  int roomMode;

  MultiDisWait({required this.roomMode});

  @override
  _MultiDisWait createState() => _MultiDisWait(roomMode: roomMode);
}

class _MultiDisWait extends State<MultiDisWait> {
  int roomMode;

  _MultiDisWait({required this.roomMode});
  final controller = Get.put(
      MultiController(repo: MultiRepository(provider: MultiProvider())));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late String titleText = '';
    // controller.getMultiRoomsByMode(1);
    if (roomMode == 1) {
      titleText = '거리모드 - 멀티';
    } else if (roomMode == 2) {
      titleText = '시간모드 - 멀티';
    } else {
      titleText = '만남모드 - 멀티';
    }
    controller.getMultiRoomsByMode(roomMode);
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText,
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
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.to(MultiDistanceRoomForm(
                          roomMode: roomMode,
                        ));
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
                      child: CustomSearchField(
                        controller:
                            TextEditingController(), // You can pass your own TextEditingController
                        hintText: 'Enter room title to search',
                      ),
                    ),
                  ],
                ),

                Obx(() {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.roomList.length,
                      itemBuilder: (context, idx) {
                        return GestureDetector(
                            onTap: () {
                              Get.to(() => MultiRoomDetail(
                                  roomInfo: controller.roomList[idx]));
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

class CustomSearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const CustomSearchField({
    Key? key,
    required this.controller,
    this.hintText = 'Enter your search query',
  }) : super(key: key);

  @override
  _CustomSearchFieldState createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5),
          hintText: widget.hintText,
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Colors
                    .green), // Assuming GREEN_COLOR is defined as Colors.green
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        onTap: () {
          _focusNode
              .requestFocus(); // Manually request focus when the text field is tapped
        },
      ),
    );
  }
}
