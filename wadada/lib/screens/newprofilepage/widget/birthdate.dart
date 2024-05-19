// 생년월일
// ignore: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/profileController.dart';
import 'package:wadada/repository/profileRepo.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  ProfileController profileController =
      Get.put(ProfileController(repo: ProfileRepository()));
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.transparent,
        child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: GREEN_COLOR,
              padding:
                  const EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(1910),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                setState(() {
                  date = selectedDate;
                  profileController.profile.value.memberBirthday = date;
                });
              }
            },
            child: Obx(() {
              return Text(
                DateFormat('yyyy년 MM월 dd일')
                    .format(profileController.profile.value.memberBirthday),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              );
            })),
      ),
    );
  }
}
