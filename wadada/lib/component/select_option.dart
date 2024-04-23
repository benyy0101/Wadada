import 'package:flutter/material.dart';

class SelectOption extends StatelessWidget{
  const SelectOption({super.key});
  // final String icon, name, des, btn;
  
  // const SelectOption({
  //   super.key,
  //   required this.icon,
  //   required this.name,
  //   required this.des,
  //   required this.btn,
  // });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color(0xffF6F4E9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2, // 그림자 범위
              blurRadius: 5, // 그림자 흐림 정도
              offset: Offset(1, 2), // 그림자 위치
            ),
          ],
        ),
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: const [
              Text(
                '거리',
                style: TextStyle(
                  fontSize: 20,
                  // fontWeight: FontWeight.bold,
              )),
              SizedBox(height:20),
            ],
          )
        ),
      );
  }
}