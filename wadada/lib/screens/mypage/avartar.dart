import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wadada/controller/profileController.dart';
import 'package:wadada/repository/profileRepo.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const <Widget>[AvatarContainer(), LevelWidget(), SizedBox(height: 50,)],
      ),
    );
  }
}

class AvatarContainer extends StatelessWidget {
  const AvatarContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/temp_chars.png',
              height: 300,
            ),
            Text(
              "짚신이",
              style: TextStyle(color: DARK_GREEN_COLOR, fontSize: 30),
            ),
          ],
        ));
  }
}

class LevelWidget extends StatelessWidget {
  const LevelWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        color: OATMEAL_COLOR,
        child: Center(child: LevelContainer()),
      ),
    );
  }
}

class LevelContainer extends StatelessWidget {
  ProfileController controller =
      Get.put(ProfileController(repo: ProfileRepository()));
  LevelContainer({super.key});
  final int level = 123;
  final double percentage = 0.75;
  final int remaining = 29;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Obx(() {
              return Text(
                "Lv. ${controller.profile.value.memberLevel}",
                style: TextStyle(fontSize: 30),
              );
            }),
            SizedBox(
              height: 20.0,
            ),
            Obx(() {
              if (!controller.isFetching.value) {
                return CircularProgressIndicator();
              } else {
                return Row(
                  children: <Widget>[
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width * 0.7,
                      lineHeight: 14.0,
                      percent: controller.profile.value.memberExp / 100,
                      backgroundColor: Colors.white,
                      progressColor: GREEN_COLOR,
                      barRadius: Radius.circular(30),
                    ),
                    Text(
                      "${controller.profile.value.memberExp} %",
                    ),
                  ],
                );
              }
            }),
          ],
        ));
  }
}
