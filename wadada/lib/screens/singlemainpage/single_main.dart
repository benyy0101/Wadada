import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wadada/screens/singleoptionpage/single_free_option.dart';
import 'package:wadada/common/component/logout.dart';
import 'package:wadada/screens/singlemainpage/component/select_mode.dart';
import 'package:wadada/screens/singlemainpage/component/single_record.dart';

class SingleMain extends StatelessWidget {
  const SingleMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(
          children: [
            SizedBox(
              height: 45,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Column(
                  children: [
                    Text('싱글모드',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
            Container(
              child: Row(
                children: const [
                  Text('김태수님의 최근 기록',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ))
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
                Get.to(SingleOption(
                  isDistMode: true,
                ));
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => SingleOption(isDistMode: true)),
                // );
              },
            ),
            SizedBox(
              height: 25,
            ),
            SelectMode(
              icon: 'assets/images/clock_2.png',
              name: '시간모드',
              des: '목표한 시간만큼 달려보세요.',
              btn: '28',
              onTapAction: () {
                Get.to(SingleOption(
                  isDistMode: false,
                ));
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => SingleOption(isDistMode: false)),
                // );
              },
            ),
            SizedBox(
              height: 25,
            ),
            SelectMode(
              icon: 'assets/images/map.png',
              name: '챌린지모드',
              des: '코스를 뛰고, 기록에 도전하세요.',
              btn: '8',
              onTapAction: () {
                Get.to(SingleOption(
                  isDistMode: false,
                ));
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => SingleOption(isDistMode: false)),
                // );
              },
            ),
            SizedBox(
              height: 30,
            ),
            // LogoutButton(),
            TestButton(),
          ],
        ),
      ),
    );
  }
}
