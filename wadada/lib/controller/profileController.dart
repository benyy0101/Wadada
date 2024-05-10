import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wadada/models/profile.dart';
import 'package:wadada/repository/profileRepo.dart';

class ProfileController extends GetxController {
  final ProfileRepository repo;
  Profile profile = Profile(
      memberNickname: '',
      memberBirthday: DateTime(1995, 03, 04),
      memberGender: '',
      memberEmail: '',
      memberProfileImage: '');
  bool isNicknameValid = true;

  ProfileController({required this.repo});

  //PROFILE-003
  void patchProfile(Profile newProfile) async {
    try {
      profile = await repo.profilePatch(newProfile);
      return;
    } catch (e) {
      print('컨트롤러 에러');
      print(e);
      rethrow;
    }
  }

  //PROFILE-005
  void validateNickname(String nickname) async {
    try {
      isNicknameValid = await repo.checkNickname(nickname);
      return;
    } catch (e) {
      print('컨트롤러 에러');
      print(e);
      rethrow;
    }
  }

  
}
