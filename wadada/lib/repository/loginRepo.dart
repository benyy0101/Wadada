import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:wadada/provider/loginProvider.dart';
import 'package:wadada/util/serializable.dart';

abstract class AbstractLoginRepository {
  Future<LoginDto> loginToServer();
  Future logoutFromServer();
}

class LoginDto {
  final String kakaoId;
  final String kakaoNickname;
  final String kakaoEmail;
  final Jwt jwtToken;

  LoginDto(
      {required this.kakaoId,
      required this.kakaoNickname,
      required this.kakaoEmail,
      required this.jwtToken});

  factory LoginDto.fromJson(Map<String, dynamic> json) {
    return LoginDto(
        kakaoId: json['kakaoId'],
        kakaoNickname: json['kakaoNickname'],
        kakaoEmail: json['kakaoEmail'],
        jwtToken: json['jwtToken']);
  }
}

class Jwt {
  final String grantType;
  final String accessToken;

  Jwt({required this.grantType, required this.accessToken});
}

class LoginRepository extends GetxService implements AbstractLoginRepository {
  final LoginProvider provider;

  LoginRepository({required this.provider});
  
  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<LoginDto> loginToServer() async {
    try {
      OAuthToken token;
      // 카카오톡 실행 가능 여부 확인 (앱설치되어 있으면 )
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      Response res = await provider.kakaoLogin(token.accessToken);
      return LoginDto.fromJson(res.body);
    } catch (error) {
      print('로그인 실패 $error');
      rethrow;
    }
  }

  @override
  Future logoutFromServer() {
    // TODO: implement logoutFromServer
    throw UnimplementedError();
  }
}
