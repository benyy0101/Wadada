import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/mainpage/layout.dart';

class StartPageLayout extends StatefulWidget {
  const StartPageLayout({super.key});

  @override
  State<StartPageLayout> createState() => _StartPageLayoutState();
}

class _StartPageLayoutState extends State<StartPageLayout> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      Get.to(MainPageLayout());
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => MainPageLayout()),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: OATMEAL_COLOR,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_green.png', width: 130),
            ],
          ),
        ));
  }
}
