import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:wadada/provider/loginProvider.dart';
import 'package:wadada/util/serializable.dart';

abstract class AbstractLoginRepository {
  Future<LoginDto> loginToServer();
  Future logoutFromServer();
}

class LoginDto {
  final String? kakao_id;
  final String? kakao_nickname;
  final String? kakao_email;
  final Jwt jwtToken;

  LoginDto({
    required this.kakao_id,
    required this.kakao_nickname,
    required this.kakao_email,
    required this.jwtToken,
  });

  factory LoginDto.fromJson(Map<String, dynamic> json) {
    return LoginDto(
      kakao_id:
          json['member_id'] != null ? json['member_id'] as String : "no id",
      kakao_nickname: json['kakao_nickname'] != null
          ? json['kakao_nickname'] as String
          : "no_id",
      kakao_email: json['kakao_email'] != null
          ? json['kakao_email'] as String
          : "no_email",
      jwtToken: json['jwtToken'] != null
          ? Jwt.fromJson(json['jwtToken'] as Map<String, dynamic>)
          : Jwt(grantType: "no_granttype", accessToken: "no_accesstoken"),
    );
  }

  @override
  String toString() {
    return 'LoginDto{kakao_id: $kakao_id, kakao_nickname: $kakao_nickname, kakao_email: $kakao_email, jwtToken: $jwtToken}';
  }
}

class Jwt {
  final String grantType;
  final String accessToken;

  Jwt({required this.grantType, required this.accessToken});

  factory Jwt.fromJson(Map<String, dynamic> json) {
    return Jwt(grantType: json['grantType'], accessToken: json['accessToken']);
  }
}

class LoginRepository implements AbstractLoginRepository {
  final LoginProvider provider;

  LoginRepository({required this.provider});

  @override
  Future<LoginDto> loginToServer() async {
    try {
      // print(await KakaoSdk.origin);

      OAuthToken token;
      // 카카오톡 실행 가능 여부 확인 (앱설치되어 있으면 )
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      Response res = await provider.kakaoLogin(token.accessToken);
      return LoginDto.fromJson(res.data);
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
