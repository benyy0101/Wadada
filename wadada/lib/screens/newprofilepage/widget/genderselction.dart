// 성별 선택
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';

class GenderSelectionWidget extends StatefulWidget {
  const GenderSelectionWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GenderSelectionWidgetState createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  // 성별 선택 상태를 저장하는 변수
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedGender = "여성";
            });
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: selectedGender == "여성" ? GREEN_COLOR : OATMEAL_COLOR,
            elevation: 5,
            shadowColor: Colors.black,
            minimumSize: const Size(100, 60),
          ),
          child: const Text(
            "여성", 
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedGender = "남성";
            });
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: selectedGender == "남성" ? GREEN_COLOR : OATMEAL_COLOR,
            elevation: 5,
            shadowColor: Colors.black,
            minimumSize: const Size(100, 60),
          ),
          child: const Text(
            "남성", 
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
