// 생성 취소 버튼
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/singlemainpage/single_main.dart';

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
