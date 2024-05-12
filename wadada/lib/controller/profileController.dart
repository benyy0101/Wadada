import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wadada/models/profile.dart';
import 'package:wadada/provider/mypageProvider.dart';
import 'package:wadada/repository/mypageRepo.dart';
import 'package:wadada/repository/profileRepo.dart';

class ProfileController extends GetxController {
  final ProfileRepository repo;
  final MypageRepository mypageRepo = MypageRepository(mypageAPI: MypageAPI());
  Rx<Profile> profile = Profile(
          memberNickname: '',
          memberBirthday: DateTime(1995, 03, 04),
          memberGender: '',
          memberEmail: '',
          memberProfileImage: '')
      .obs;
  RxBool isNicknameValid = true.obs;

  ProfileController({required this.repo});

  //PROFILE-003
  void patchProfile(Profile newProfile) async {
    try {
      await repo.profilePatch(newProfile);
      return;
    } catch (e) {
      print('컨트롤러 에러');
      print(e);
    }
  }

  //PROFILE-005
  void validateNickname(String nickname) async {
    try {
      if (await repo.checkNickname(nickname)) {
        isNicknameValid = true.obs;
      } else {
        isNicknameValid = true.obs;
      }
      return;
    } catch (e) {
      print('컨트롤러 에러');
      print(e);
      rethrow;
    }
  }

  void uploadImage(String path) async {
    try {
      String? s3url = await mypageRepo.uploadImage(path);
      // print("-----------------s3url0--------------");
      // print(s3url);
      profile.value.memberProfileImage = s3url;
    } catch (e) {
      print(e);
    }
  }
}
