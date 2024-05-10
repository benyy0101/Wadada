import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:wadada/repository/loginRepo.dart';

class LoginController extends GetxController {
  final LoginRepository loginRepository;
  final storage = FlutterSecureStorage();
  LoginDto loginInfo = LoginDto(
      kakao_id: 'kakaoId',
      kakao_nickname: 'kakaoNickname',
      kakao_email: 'kakaoEmail',
      jwtToken: Jwt(grantType: '', accessToken: ''));

  LoginController({required this.loginRepository});

  Future<void> login() async {
    try {
      loginInfo = await loginRepository.loginToServer();
      print(loginInfo.jwtToken.accessToken);
      await storage.write(
          key: 'accessToken',
          value:
              "${loginInfo.jwtToken.grantType} ${loginInfo.jwtToken.accessToken}");
      await storage.write(key: 'kakaoId', value: loginInfo.kakao_id);
      await storage.write(
          key: 'kakaoNickname', value: loginInfo.kakao_nickname);
      await storage.write(key: 'kakaoEmail', value: loginInfo.kakao_email);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
