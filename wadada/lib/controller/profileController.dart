import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wadada/models/profile.dart';
import 'package:wadada/provider/mypageProvider.dart';
import 'package:wadada/repository/mypageRepo.dart';
import 'package:wadada/repository/profileRepo.dart';
import 'package:wadada/screens/newprofilepage/Error.dart';
import 'package:wadada/screens/newprofilepage/ProfileFinish.dart';

class ProfileController extends GetxController {
  final ProfileRepository repo;
  final MypageRepository mypageRepo = MypageRepository(mypageAPI: MypageAPI());
  final storage = FlutterSecureStorage();
  late Rx<Profile> profile = Profile(
    memberNickname: '',
    memberBirthday: DateTime(1995, 03, 04),
    memberGender: '',
    memberEmail: '',
    memberProfileImage: '',
    memberExp: -1,
    memberLevel: -1,
  ).obs;
  RxBool isNicknameValid = true.obs;
  RxBool isFetching = false.obs;

  ProfileController({required this.repo});

  @override
  void onInit() async {
    super.onInit();
    profile.value = await repo.profileGet();
    // final storage = FlutterSecureStorage();
    // String? temp = await storage.read(key: 'kakaoNickname');
    // print('-------------------------');
    // print(temp);
    // profile.value.memberNickname = temp ?? "";
  }

  void getProfile() async {
    try {
      profile.value = await repo.profileGet();
      print(profile.value);
      isFetching.value = true;
    } catch (e) {
      print('--------------profile get-----------------');
      print(e);
    }
  }

  //PROFILE-003
  patchProfile(Profile newProfile) async {
    try {
      await repo.profilePatch(newProfile);
      await storage.write(
          key: 'kakaoNickname', value: profile.value.memberNickname);
      Get.to(ProfileFinish());
      return;
    } catch (e) {
      print('컨트롤러 에러');
      Get.to(ProfileError());
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
      print("-----------------s3url0--------------");
      print(s3url);
      profile.value.memberProfileImage = s3url;
    } catch (e) {
      print(e);
    }
  }
}
