import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/loginController.dart';
import 'package:wadada/provider/loginProvider.dart';
import 'package:wadada/repository/loginRepo.dart';
import 'package:wadada/screens/mypage/layout.dart';
import 'package:wadada/screens/singlemainpage/single_main.dart';

import 'package:get/get.dart';

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
                  Text(
                    '혼자 달려',
                    style: TextStyle(
                        color: DARK_GREEN_COLOR,
                        fontSize: 40,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '친구랑 달려',
                    style: TextStyle(
                        color: DARK_GREEN_COLOR,
                        fontSize: 40,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '일단 달려',
                    style: TextStyle(
                        color: DARK_GREEN_COLOR,
                        fontSize: 40,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '와다다',
                    style: TextStyle(
                        color: DARK_GREEN_COLOR,
                        fontSize: 40,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 50),
          KakaoLoginButton(),
        ],
      ),
    );
  }
}

class KakaoLoginButton extends StatelessWidget {
  const KakaoLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController(
        loginRepository: LoginRepository(provider: LoginProvider())));
    return GetBuilder<LoginController>(
      builder: (LoginController controller) {
        return GestureDetector(
          onTap: () => {
            controller.login().then((value) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyPageLayout()));
            })
          },
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
      },
    );
  }
}




// Future<void> signWithKakao(BuildContext context) async {
//   try {
//     OAuthToken token;
//     // 카카오톡 실행 가능 여부 확인 (앱설치되어 있으면 )
//     if (await isKakaoTalkInstalled()) {
//       token = await UserApi.instance.loginWithKakaoTalk();
//       print('카카오톡 앱으로 로그인 성공');
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SingleMain()));
//       // 앱 설치 안 되어있으면 카카오계정으로 로그인
//     } else {
//       token = await UserApi.instance.loginWithKakaoAccount();
//       print('카카오계정으로 로그인 성공');
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SingleMain()));
//     }
    
//     print('로그인 성공');
//     print('엑세스토큰: ${token.accessToken}');
//     await sendTokenToServer(token.accessToken);
    
    
//   } catch (error) {
//     print('로그인 실패 $error');
//   }
// }

// Future<void> sendTokenToServer(String accessToken) async {
//   try {
//     var url = Uri.parse('https://k10a704.p.ssafy.io/Wadada/auth/login');
//     Map<String, dynamic> res = {
//       'code': accessToken
//     };
    
//     print(jsonEncode(res));  // {"code":"T58J8ySbYsfRtg46K_Up8FLMGOBZwfYhylAKKclfAAABjy2ONb76Fwx8Dt1GgQ"}

//     var response = await http.post(
//       url, 
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(res),
//     );
    
//     if (response.statusCode == 200) {https://meeting.ssafy.com/s10p30a7/channels/a704#
//       print('서버에 토큰 전송 성공');
//       print('결과 ${response.body}');
//     } else {
//       print('서버에 토큰 전송 실패: ${response.body}');
//     }
//   } catch (e) {
//     print('요청 처리 중 에러 발생: $e');
//   }

// }


// signWithKakao(BuildContext context) async {
//   // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
//   if (await isKakaoTalkInstalled()) {
//     try {
//       // 응답값 확인
//       // 카카오톡으로 로그인 시도
//       OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
//       print('슛슛 카카오톡으로 로그인 성공');
      
//       // 원래 요청 코드
//       // await UserApi.instance.loginWithKakaoTalk();


//       // 로그인 후 액세스 토큰 얻기
//       // AccessToken token = await TokenManager.instance.getToken();
//       // print('카카오 로그인 성공: Access Token: ${token.accessToken}');

//       // // 얻어진 액세스 토큰을 서버에 전송
//       // await sendTokenToServer(token.accessToken);

//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SingleMain()));
//     } catch (error) {
//       print('카카오톡으로 로그인 실패 $error');

//       // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
//       if (error is PlatformException && error.code == 'CANCELED') {
//           return;
//       }
//       // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
//       try {
//           // 
//           OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
//           print('슛슛 카카오계정으로 로그인 성공');


//           // 요청 코드
//           // await UserApi.instance.loginWithKakaoAccount();
//           print('카카오계정으로 로그인 성공');
//           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SingleMain()));
//       } catch (error) {
//           print('카카오계정으로 로그인 실패 $error');
//       }
//     }
//   } else {

//     try {
//       // 카카오톡 미설치 상태에서 바로 카카오계정으로 로그인 시도
//       OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
//       print('33카카오계정으로 로그인 성공');

//       // await UserApi.instance.loginWithKakaoAccount();
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SingleMain()));
//     } catch (error) {
//       print('카카오계정으로 로그인 실패 $error');
//     }
//   }
// }