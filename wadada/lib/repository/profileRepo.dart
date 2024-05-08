import 'package:dio/dio.dart';
import 'package:wadada/models/profile.dart';
import 'package:wadada/provider/profileProvider.dart';

class ProfileRepository {
  ProfileProvider provider = ProfileProvider();

  //PROFILE-004
  Future<Profile> profileGet() async {
    try {
      Response res = await provider.profileGet();
      return Profile.fromJson(res.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //PROFILE-003
  Future<Profile> profilePatch(Profile profile) async {
    try {
      Response res = await provider.profilePatch(profile);
      return Profile.fromJson(res.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //PROFILE-002
  Future<void> profileDelete() async {
    try {
      await provider.profileDelete();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //PROFILE-005
  Future<bool> checkNickname(String nickname) async {
    try {
      Response res = await provider.nickNameValidate(nickname);
      return res.data['is_duplication'];
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
