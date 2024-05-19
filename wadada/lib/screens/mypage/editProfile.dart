import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/marathonController.dart';
import 'package:wadada/controller/profileController.dart';
import 'package:wadada/models/marathon.dart';
import 'package:wadada/provider/marthonProvider.dart';
import 'package:wadada/repository/marathonRepo.dart';
import 'package:wadada/repository/profileRepo.dart';
import 'package:wadada/screens/newprofilepage/widget/birthdate.dart';
import 'package:wadada/screens/newprofilepage/widget/custom_text_form_field.dart';
import 'package:wadada/screens/newprofilepage/widget/genderselction.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    ProfileController profileController =
        Get.put(ProfileController(repo: ProfileRepository()));
    Uint8List? _image;

    TextEditingController textEditingController = TextEditingController(
        text: profileController.profile.value.memberNickname);

    Future _pickImageFromGallery() async {
      final returnImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnImage == null) return;
      setState(() {
        _image = File(returnImage.path).readAsBytesSync();
        profileController.uploadImage(returnImage.path);
      });
      // ignore: use_build_context_synchronously
      Get.back();
      //Navigator.of(context).pop(); // 모달 닫
    }

// 카메라
    Future _pickImageFromCamera() async {
      final returnImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (returnImage == null) return;
      setState(() {
        print('--------------************');
        _image = File(returnImage.path).readAsBytesSync();
        profileController.uploadImage(returnImage.path);
      });
      // ignore: use_build_context_synchronously
      Get.back();
      // Navigator.of(context).pop(); // 모달 닫
    }

    void showImagePickerOption(BuildContext context) {
      showModalBottomSheet(
          backgroundColor: OATMEAL_COLOR,
          context: context,
          builder: (builder) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 6,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: SizedBox(
                          child: Column(
                            children: [
                              Icon(
                                Icons.image,
                                size: 70,
                              ),
                              Text("갤러리")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromCamera();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: SizedBox(
                          child: Column(
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 70,
                              ),
                              Text("카메라")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              GestureDetector(onTap: () {
                showImagePickerOption(context);
              }, child: Obx(() {
                return CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(
                          profileController.profile.value.memberProfileImage)
                      as ImageProvider,
                );
              })),
            ],
          ),
          const SizedBox(height: 20),
          // 닉네임
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 닉네임 입력
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _NickName(),
                    _SubTitle(),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: textEditingController,
                  hintText: '닉네임을 입력하세요',
                  onChanged: (String value) {
                    if (value != '') {
                      profileController.validateNickname(value);
                      profileController.profile.value.memberNickname = value;
                    }
                  },
                ),
                Obx(
                  () {
                    return Visibility(
                      child: Text('이미 있는 닉네임입니다'),
                      visible: !profileController.isNicknameValid.value,
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // 성별
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 70.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 성별
                Align(
                  alignment: Alignment.centerLeft,
                  child: _Gender(),
                ),

                SizedBox(height: 20),

                // 성별 선택
                GenderSelectionWidget(),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // 생년월일
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 70.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 생년월일
                Align(
                  alignment: Alignment.centerLeft,
                  child: _Birthdate(),
                ),
                SizedBox(height: 20),
                // 생년월일 선택
                Calendar(),
              ],
            ),
          ),
          const SizedBox(height: 60),
          _MyButton()
        ],
      ),
    );
  }
}

// 닉네임
// ignore: unused_element
class _NickName extends StatelessWidget {
  // ignore: use_super_parameters
  const _NickName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Text(
      '닉네임',
      // ignore: prefer_const_constructors
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

// 닉네임 안내 멘트
// ignore: unused_element
class _SubTitle extends StatelessWidget {
  // ignore: use_super_parameters
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Text(
      ' 2자 이상 14자 이하의 닉네임을 정해주세요',
      // ignore: prefer_const_constructors
      style: TextStyle(
        fontSize: 11,
        color: GRAY_400,
      ),
    );
  }
}

// 성별
// ignore: unused_element
class _Gender extends StatelessWidget {
  // ignore: use_super_parameters
  const _Gender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Text(
      '성별',
      // ignore: prefer_const_constructors
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

// 생년월일
// ignore: unused_element
class _Birthdate extends StatelessWidget {
  // ignore: use_super_parameters
  const _Birthdate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Text(
      '생년월일',
      // ignore: prefer_const_constructors
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

// 생성 취소 버튼
class _MyButton extends StatelessWidget {
  ProfileController profileController =
      Get.put(ProfileController(repo: ProfileRepository()));
  // ignore: unused_element
  _MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextButton(
          onPressed: () {
            // print(profileController.profile.value);
            profileController.patchProfile(profileController.profile.value);
          },
          style: TextButton.styleFrom(
            backgroundColor: GREEN_COLOR,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            minimumSize: const Size(350, 60),
          ),
          child: const Text(
            '수정하기',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            MarathonProvider provider = MarathonProvider();
            MarathonRepository repo = MarathonRepository();
            MarathonController controller = MarathonController();
            controller.endMarathon();
          },
          style: TextButton.styleFrom(
            backgroundColor: GRAY_400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            minimumSize: const Size(350, 60),
          ),
          child: const Text(
            "로그아웃",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            //여기 수정 버튼 필요
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.orange[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            minimumSize: const Size(350, 60),
          ),
          child: const Text(
            "탈퇴하기",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
