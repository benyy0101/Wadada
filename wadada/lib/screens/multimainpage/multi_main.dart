import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wadada/screens/multimainpage/widget/multi_select_mode.dart';
import 'package:wadada/screens/multimainpage/multi_distance/multi_waitingpage/multi_dis_waitroom.dart';

class MultiMain extends StatelessWidget {
  const MultiMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(left: 30, right: 30, top: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              MultiSelectMode(
                icon: 'assets/images/shoes.png',
                name: '거리모드',
                des: '목표한 거리만큼 달려보세요.',
                btn: '28',
                onTapAction: () {
                  Get.to(MultiDisWait(
                    roomMode: 1,
                  ));
                },
              ),
              SizedBox(
                height: 30,
              ),
              MultiSelectMode(
                icon: 'assets/images/clock.png',
                name: '시간모드',
                des: '목표한 거리만큼 달려보세요.',
                btn: '28',
                onTapAction: () {
                  Get.to(MultiDisWait(
                    roomMode: 2,
                  ));
                },
              ),
              SizedBox(
                height: 30,
              ),
              MultiSelectMode(
                icon: 'assets/images/map.png',
                name: '만남모드',
                des: '목표한 장소에서 만나보세요.',
                btn: '28',
                onTapAction: () {
                  Get.to(MultiDisWait(roomMode: 3));
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MultiMeetWait()),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
