import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/multiController.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/models/mypage.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:wadada/controller/stompController.dart';
import 'package:wadada/repository/multiRepo.dart';
import 'package:wadada/screens/mainpage/layout.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          await UserApi.instance.logout();
          // 로그아웃 성공 시 처리
          print('로그아웃 성공');
          Get.to(MainPageLayout());
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (context) => MainPageLayout()));
        } catch (error) {
          // 로그아웃 실패 시 처리
          print('로그아웃 실패: $error');
        }
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(OATMEAL_COLOR),
          foregroundColor: MaterialStateProperty.all<Color>(GREEN_COLOR),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: GREEN_COLOR)))),
      child: Text('로그아웃'),
    );
  }
}

class TestButton extends StatelessWidget {
  const TestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MultiController>(builder: (MultiController controller) {
      MultiRoom test = MultiRoom(
          roomPeople: 3,
          roomDist: 2,
          roomMode: 1,
          roomSecret: 1111,
          roomTag: '#싸피',
          roomTime: 3,
          roomTitle: 'test',
          roomSeq: -1);
      //StompProvider provider = StompProvider(roomIdx: 0);
      return ElevatedButton(
        onPressed: () {
          try {
            //controller.getMultiRoomsByMode(1);
            controller.sendStartLocation(0.0, 0.0, 3, 3);
            //print(controller.roomList.toString());
          } catch (error) {
            // 로그아웃 실패 시 처리
            print('로그아웃 실패: $error');
          }
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(OATMEAL_COLOR),
            foregroundColor: MaterialStateProperty.all<Color>(GREEN_COLOR),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: GREEN_COLOR)))),
        child: Text(controller.info.roomIdx.toString()),
      );
    });
  }
}
