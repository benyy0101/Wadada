import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wadada/screens/newprofilepage/widget/birthdate.dart';
import 'package:wadada/screens/newprofilepage/widget/custom_text_form_field.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wadada/screens/newprofilepage/widget/genderselction.dart';
import 'package:http/http.dart' as http;
import 'package:wadada/screens/singlemainpage/single_main.dart';

class NewProfileLayout extends StatefulWidget {
  const NewProfileLayout({super.key});

  @override
  State<NewProfileLayout> createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfileLayout> {
  Uint8List? _image;
  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 프로필 생성
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('프로필 생성'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 110),

            // 프로필 동그라미

            CircleAvatar(
              radius: 100,
              backgroundImage: _image != null
                  ? MemoryImage(_image!)
                  : const NetworkImage(
                          "https://www.studiopeople.kr/common/img/default_profile.png")
                      as ImageProvider,
            ),
            Positioned(
                bottom: -0,
                left: 140,
                child: IconButton(
                    onPressed: () {
                      showImagePickerOption(context);
                    },
                    icon: const Icon(Icons.add_a_photo))),

            const SizedBox(height: 20),

            // 닉네임
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 닉네임 입력
                  const Row(
                    children: [
                      _NickName(),
                      _SubTitle(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    hintText: '닉네임을 입력하세요',
                    onChanged: (String value) {},
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

            const _MyButton()
          ],
        ),
      ),
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: GREEN_COLOR,
        context: context,
        builder: (builder) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
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
                            Text("Gallery")
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
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 70,
                          ),
                          Text("Camera")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

// 갤러리
  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
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
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    // ignore: use_build_context_synchronously
    Get.back();
    // Navigator.of(context).pop(); // 모달 닫
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
        fontSize: 21,
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
      '       2자 이상 14자 이하의 닉네임을 정해주세요',
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
        fontSize: 21,
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
        fontSize: 21,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

// 생성 취소 버튼
class _MyButton extends StatelessWidget {
  // ignore: unused_element
  const _MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: GRAY_400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            minimumSize: const Size(130, 42),
          ),
          child: const Text(
            "취소",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 30),
        TextButton(
          onPressed: () {
            Get.to(SingleMain());
            // Navigator.pushReplacementNamed(context, '/');
          },
          style: TextButton.styleFrom(
            backgroundColor: GREEN_COLOR,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            minimumSize: const Size(130, 42),
          ),
          child: const Text(
            '생성하기',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}


// 이거 수정 매우매우 필요한 상태 
// 입력받은 값을 보내는 코드 필요
// Future<void> sendMemberInfoToServer() async {
//     final memberinfo = 
//     final dio = Dio();
        
//     if (memberinfo != null) {
//       final url = Uri.parse('https://k10a704.p.ssafy.io/Wadada/profile');

//       final requestBody = jsonEncode({
//         "memberNickname": "SampleNickname",
//         "memberBirthday": "1990-01-01",
//         "memberGender": "F",
//         "memberEmail": "sample@example.com",
//         "memberProfileImage": "https://s3.example.com/path/to/image.jpg"
//       });
      
//       try {
//         final response = await dio.post(
//           url.toString(),
//           data: requestBody,
//           options: Options(
//             headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//             'authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDUyNzIxNzM3IiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE0ODkwMjQ1fQ.GABjqHm8MXBSgzv3ckROkNu3HeEyUrwrcQhsY-zWPSA',
//             }
//           ),
//         );
        
//         if (response.statusCode == 200) {

//           print('서버 요청 성공');
//         } else {
//           print('서버 요청 실패: ${response.statusCode}');
//         }
//       } catch (e) {
//           print('요청 처리 중 에러 발생: $e');
//       }
//     } else {
//         print("에러에러에러");
//     }
//   }
