import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:wadada/common/const/colors.dart';

class MainPageLayout extends StatelessWidget {
  const MainPageLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OATMEAL_COLOR,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo_green.png'),
          const SizedBox(
            height: 20,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                Text('혼자 달려',
                  style: TextStyle(
                    color: DARK_GREEN_COLOR,
                    fontSize: 40,
                    fontWeight: FontWeight.w800),

                  ),
                Text('친구랑 달려',
                  style: TextStyle(
                    color: DARK_GREEN_COLOR,
                    fontSize: 40,
                    fontWeight: FontWeight.w800),

                  ),
                Text('일단 달려',
                  style: TextStyle(
                    color: DARK_GREEN_COLOR,
                    fontSize: 40,
                    fontWeight: FontWeight.w800),
                  ),
                Text('와다다',
                  style: TextStyle(
                    color: DARK_GREEN_COLOR,
                    fontSize: 40,
                    fontWeight: FontWeight.w800),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 50
          ),
          KakaoLoginButton(),
        ],
      ),
    );
  }
}


class KakaoLoginButton extends StatelessWidget {
  const KakaoLoginButton({super.key});

  // 카카오톡 앱을 통한 로그인 시도
  void _loginWithKakaoTalk(BuildContext context) async {
    try {
      var token = await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공, 액세스 토큰: ${token.accessToken}');
    } catch (error) {
      print('카카오톡으로 로그인 실패: $error');
      _loginWithKakaoAccount(context); // 카카오톡 로그인 실패 시, 카카오 계정 로그인 시도
    }
  }

  // 카카오 계정(이메일/비밀번호)을 통한 로그인 시도
  void _loginWithKakaoAccount(BuildContext context) async {
    try {
      var token = await UserApi.instance.loginWithKakaoAccount();
      print('카카오 계정으로 로그인 성공, 액세스 토큰: ${token.accessToken}');
    } catch (error) {
      print('카카오 계정으로 로그인 실패: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => signWithKakao(),
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(1, 5),
            ),
          ],
        ),
        child: Image.asset('assets/images/kakao_button.png'),
      ),
    );
  }
}


signWithKakao() async {
  // 카카오톡 실행 가능 여부 확인
  // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
  if (await isKakaoTalkInstalled()) {
    try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');

      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (error is PlatformException && error.code == 'CANCELED') {
          return;
      }
      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
      try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
      } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
      }
    }
  } else {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      print('카카오계정으로 로그인 성공');
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }
}
