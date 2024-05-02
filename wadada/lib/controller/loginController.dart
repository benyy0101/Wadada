import 'package:get/get.dart';
import 'package:wadada/repository/loginRepo.dart';

class LoginController extends GetxController {
  final LoginRepository loginRepository;

  final LoginDto loginInfo = LoginDto(kakaoId: 'kakaoId', kakaoNickname: 'kakaoNickname', kakaoEmail: 'kakaoEmail', jwtToken: Jwt(grantType: '', accessToken: ''));

  LoginController({required this.loginRepository});

  void login() async {
    try {
      loginRepository.loginToServer();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
