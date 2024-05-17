import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:wadada/common/component/tabbars.dart';
import 'package:wadada/repository/loginRepo.dart';
import 'package:wadada/screens/multimainpage/multi_main.dart';
import 'package:wadada/screens/newprofilepage/layout.dart';
import 'package:wadada/screens/singlemainpage/single_main.dart';
import 'package:wadada/screens/newprofilepage/profileReady.dart';

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
      //print(loginInfo);
      await storage.write(
          key: 'accessToken',
          value:
              "${loginInfo.jwtToken.grantType} ${loginInfo.jwtToken.accessToken}");
      await storage.write(key: 'kakaoId', value: loginInfo.kakao_id);
      await storage.write(
          key: 'kakaoNickname', value: loginInfo.kakao_nickname);
      await storage.write(key: 'kakaoEmail', value: loginInfo.kakao_email);

      if (loginInfo.kakao_nickname == '임시') {
        Get.to(ProfileReady());
      } else {
        Get.to(MainLayout());
      }
    } catch (e) {
      print(e);
    }
  }
}
