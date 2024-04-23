import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';


class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;

  const CustomTextFormField({
    this.hintText,
    this.errorText,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: DARK_GREEN_COLOR,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: '닉네임을 입력해주세요',
        errorText: '이미 있는 닉네임입니다.',
      ),
    );
  }
}