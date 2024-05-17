// 성별 선택
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/profileController.dart';
import 'package:wadada/repository/profileRepo.dart';

class GenderSelectionWidget extends StatefulWidget {
  const GenderSelectionWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GenderSelectionWidgetState createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  // 성별 선택 상태를 저장하는 변수
  String? selectedGender;
  ProfileController profileController =
      Get.put(ProfileController(repo: ProfileRepository()));

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Obx(() {
          return TextButton(
            onPressed: () {
              setState(() {
                selectedGender = "여성";
                profileController.profile.value.memberGender = 'F';
                print(
                    "------------profileController.profile.value.memberGender--------------");
                print(profileController.profile.value.memberGender);
                print(profileController.profile.value.memberProfileImage);
              });
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor:
                  profileController.profile.value.memberGender == "F"
                      ? GREEN_COLOR
                      : OATMEAL_COLOR,
              shadowColor: Colors.black,
              minimumSize: const Size(100, 60),
            ),
            child: const Text(
              "여성",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          );
        }),
        Obx(() {
          return TextButton(
            onPressed: () {
              setState(() {
                selectedGender = "남성";
                profileController.profile.value.memberGender = 'M';
                print(
                    "------------profileController.profile.value.memberGender--------------");
                print(profileController.profile.value.memberGender);
              });
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor:
                  profileController.profile.value.memberGender == "M"
                      ? GREEN_COLOR
                      : OATMEAL_COLOR,
              shadowColor: Colors.black,
              minimumSize: const Size(100, 60),
            ),
            child: const Text(
              "남성",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          );
        })
      ],
    );
  }
}
