import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wadada/common/component/tabbars.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/stompController.dart';

class SingleError extends StatefulWidget {
  const SingleError({super.key});

  @override
  _SingleErrorState createState() => _SingleErrorState();
}

class _SingleErrorState extends State<SingleError> {

  @override
  void initState() {
    super.initState();

    // if (widget.controller.client.isActive) {
    //   widget.controller.client.deactivate();
    //   print('client 구독 끊음');
    // }   

    // if (widget.controller.newclient.isActive) {
    //   widget.controller.newclient.deactivate();
    //   print('newclient 구독 끊음');
    // }   
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height * 0.8;
    return Scaffold(
        body: SafeArea(
            child: SizedBox(
      width: screenWidth, // Set container width to screen width
      height: screenHeight, // Set container height to screen height
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Text("위치를 받지 못했습니다.\n위치 설정을 허용해주세요.",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Image.asset('assets/images/dizzy_face.png'),
          TextButton(
            onPressed: () {
              Get.to(() => MainLayout());
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  GREEN_COLOR), // Set background color
              foregroundColor:
                  MaterialStateProperty.all(Colors.white), // Set text color
              textStyle: MaterialStateProperty.all(
                  TextStyle(fontSize: 18)), // Set text style
              padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                  vertical: 20, horizontal: 100)), // Set padding
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))), // Set button shape
            ),
            child: Text('종료하기'),
          )
        ],
      ),
    )));
  }
}
