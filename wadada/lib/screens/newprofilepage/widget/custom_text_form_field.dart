import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const CustomTextFormField({
    required this.onChanged,
    this.autofocus = false,
    this.obscureText = false,
    this.hintText,
    this.errorText,
    this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: DARK_GREEN_COLOR,
        width: 1.0,
      ),
    );

    return TextFormField(
      controller: controller,
      cursorColor: DARK_GREEN_COLOR,
      // 비밀번호 입력할 때
      obscureText: obscureText,
      autofocus: autofocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(
          color: GRAY_400,
          fontSize: 14.0,
        ),
        fillColor: Colors.white12,
        filled: true,
        border: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: GREEN_COLOR,
          ),
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:wadada/common/const/colors.dart';

// class CustomTextFormField extends StatelessWidget {
//   final String? hintText;
//   final bool obscureText;
//   final bool autofocus;
//   final ValueChanged<String>? onChanged;
//   final FormFieldValidator<String>? validator; // validator 추가

//   const CustomTextFormField({
//     required this.onChanged,
//     this.validator, // validator 초기화
//     this.autofocus = false,
//     this.obscureText = false,
//     this.hintText,
//     super.key, String? errorText,
//   });

//   @override
//   Widget build(BuildContext context) {
//     const baseBorder = OutlineInputBorder(
//       borderSide: BorderSide(
//         color: DARK_GREEN_COLOR,
//         width: 1.0,
//       ),
//     );

//     return TextFormField(
//       cursorColor: DARK_GREEN_COLOR,
//       obscureText: obscureText,
//       autofocus: autofocus,
//       onChanged: onChanged,
//       validator: validator, 
//       decoration: InputDecoration(
//         contentPadding: const EdgeInsets.all(20),
//         hintText: hintText,
//         hintStyle: const TextStyle(
//           color: GRAY_COLOR,
//           fontSize: 14.0,
//         ),
//         fillColor: Colors.white12,
//         filled: true,
//         border: baseBorder,
//         focusedBorder: baseBorder.copyWith(
//           borderSide: baseBorder.borderSide.copyWith(
//             color: GREEN_COLOR,
//           ),
//         ),
//       ),
//     );
//   }
// }


// class MyFormWidget extends StatefulWidget {
//   const MyFormWidget({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _MyFormWidgetState createState() => _MyFormWidgetState();
// }

// class _MyFormWidgetState extends State<MyFormWidget> {
//   final _formKey = GlobalKey<FormState>(); // Form의 상태를 관리할 키

//   Future<bool> isNicknameDuplicated(String nickname) async {
//   // 여기에 데이터베이스 조회 로직 구현
//   // 예시로는, 닉네임이 중복되었다고 가정하고 true를 반환
//   return true; // 또는 false
// }

// // 닉네임 중복 메시지 관리
// String? _nicknameErrorMessage;

// // Form 키
// // ignore: unused_field
// final _myformKey = GlobalKey<FormState>();

// @override
// Widget build(BuildContext context) {
//   return Form(
//     key: _formKey,
//     child: Column(
//       children: [
//         CustomTextFormField(
//           hintText: "닉네임",
//           errorText: _nicknameErrorMessage, 
//           onChanged: (value) {
//             // 필요한 경우 onChanged 이벤트 처리
//           },
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             // 닉네임 중복 검사
//             bool duplicated = await isNicknameDuplicated("ii");

//             // 중복 O -> 에러 메시지를 설정하고 상태 업데이트
//             if (duplicated) {
//               setState(() {
//                 _nicknameErrorMessage = "이미 사용 중인 닉네임입니다.";
//               });
//             } else {
//               setState(() {
//                 _nicknameErrorMessage = null;
//               });
//               // 폼 제출
//             }
//           },
//           child: const Text('제출'),
//         ),
//       ],
//     ),
//   );
// }
// }
