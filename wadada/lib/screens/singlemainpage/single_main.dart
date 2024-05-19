import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/profileController.dart';
import 'package:wadada/repository/profileRepo.dart';
import 'package:wadada/screens/singleoptionpage/single_free_option.dart';
import 'package:wadada/common/component/logout.dart';
import 'package:wadada/screens/singlemainpage/component/select_mode.dart';
import 'package:wadada/screens/singlemainpage/component/single_record.dart';

class SingleMain extends StatelessWidget {
  SingleMain({super.key});
  ProfileController profileController =
      Get.put(ProfileController(repo: ProfileRepository()));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                children: [
                  Obx(() {
                    return Text(
                        '${profileController.profile.value.memberNickname}님의 최근 기록',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        ));
                  })
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SingleRecord(),
            SizedBox(
              height: 30,
            ),
            SelectMode(
              icon: 'assets/images/shoes.png',
              name: '거리모드',
              des: '목표한 거리만큼 달려보세요.',
              btn: '28',
              onTapAction: () {
                // Get.to(SingleOption(
                //   isDistMode: true,
                // ));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleOption(isDistMode: true)),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            SelectMode(
              icon: 'assets/images/clock.png',
              name: '시간모드',
              des: '목표한 시간만큼 달려보세요.',
              btn: '28',
              onTapAction: () {
                // Get.to(SingleOption(
                //   isDistMode: false,
                // ));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleOption(isDistMode: false)),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            SelectMode(
              icon: 'assets/images/map.png',
              name: '챌린지모드',
              des: '코스를 뛰고, 기록에 도전하세요.',
              btn: '8',
              onTapAction: () {
              },
            ),
            SizedBox(
              height: 20,
            ),
            // LogoutButton(),
            // TestButton(),
          ],
        ),
      ),
    );
  }
}
