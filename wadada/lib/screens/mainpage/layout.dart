import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:wadada/common/component/tabbars.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/singlemainpage/single_main.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: true,);
final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
final dio = Dio();
  // ..options = BaseOptions(
  //   baseUrl: 'https://k10a704.p.ssafy.io/Wadada',
  //   validateStatus: (status) {
  //     return status! < 500; // 500 미만의 모든 상태 코드를 성공으로 간주합니다.
  //   },
  // );

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => signWithKakao(context),
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


Future<void> signWithKakao(BuildContext context) async {
  try {
    OAuthToken token;
    // 카카오톡 실행 가능 여부 확인 (앱설치되어 있으면 )
    if (await isKakaoTalkInstalled()) {
      token = await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡 앱으로 로그인 성공');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SingleMain()));
      // 앱 설치 안 되어있으면 카카오계정으로 로그인
    } else {
      token = await UserApi.instance.loginWithKakaoAccount();
      print('카카오계정으로 로그인 성공');
      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TabBars()));
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SingleMain()));
    }
    
    await sendTokenToServer(token.accessToken);
    // const surl = 'https://k10a704.p.ssafy.io/Wadada/profile'; 
    // Map<String, dynamic> plz = {
    //   "memberNickname": "ㅋㅋㅋㅋㅋㅋ",
    //   "memberBirthday": "1990-01-01",
    //   "memberGender": "F",
    //   "memberEmail": "sample@example.com",
    //   "memberProfileImage": "https://s3.example.com/path/to/image.jpg"
    // };

    // final single = await dio.patch(
    //   surl,
    //   options: Options(
    //     headers: {'Content-Type' : 'application/json'},
    //   ),
    //   data: jsonEncode(plz)
    // );
    // print(single.data);
    
  } catch (error) {
    print('로그인 실패 $error');
  }
}

Future<void> sendTokenToServer(String accessToken) async {
  try {
    const url = 'https://k10a704.p.ssafy.io/Wadada/auth/login';
    Map<String, dynamic> res = {'code': accessToken};  // 카카오 토큰
    // print(jsonEncode(res));  // {"code":"T58J8ySbYsfRtg46K_Up8FLMGOBZwfYhylAKKclfAAABjy2ONb76Fwx8Dt1GgQ"}

    // 서버에 요청 보내기
    var response = await dio.post(
      url, 
      options: Options(
        headers: {'Content-Type': 'application/json'}
      ),
      data: jsonEncode(res), 
    );
    
    if (response.statusCode == 200) {
      print('서버에 토큰 전송 성공');
      print('결과 ${response.data}');
      final responseData = response.data;
      // print(responseData['jwtToken']['accessToken']);
      
      // jwt accesstoken 저장
      await storage.write(key: 'server_token', value: responseData['jwtToken']['accessToken']);
      // final wadada = await storage.read(key: 'server_token');
      // print(wadada);

    } else {
      print('서버에 토큰 전송 실패: ${response.data}');
    }
  } catch (e) {
    print('요청 처리 중 에러 발생: $e');
  }
}

void setupInterceptor() {
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Secure Storage에서 jwt 토큰 읽어옴
      String? jwtToken = await storage.read(key: 'server_token');
      if (jwtToken != null) {
        // 읽어온 토큰 헤더에 추가
        options.headers["Authorization"] = "Bearer $jwtToken";
        print('헤더에 싣는다');
        print(options.headers);
      }
      // 요청 진행 킵고잉
      return handler.next(options); 
    },
    onResponse: (response, handler) {
      // 요청 성공
      print('성공 슛');
      return handler.next(response);
    },
    // ignore: deprecated_member_use
    onError: (DioError e, handler) {
      // 요청 실패
      print('실패 우웩');
      return handler.next(e);
    },
  ));
}