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
      storage.write(key: 'accessToken', value: loginInfo.jwtToken.accessToken);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
