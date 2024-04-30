import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:wadada/common/const/colors.dart';
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
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPageLayout()));

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
            side: BorderSide(color: GREEN_COLOR)
          )
        )
      ),
      child: Text('로그아웃'),
    );
  }
}
