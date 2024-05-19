import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/marathonController.dart';
import 'package:wadada/controller/stompController.dart';
import 'package:wadada/models/marathon.dart';
import 'package:wadada/screens/marathonrunpage/marathonRun.dart';

class InfoDetail extends StatelessWidget {
  final SimpleMarathon marathon;
  final bool isPast;

  const InfoDetail({super.key, required this.marathon, required this.isPast});

  @override
  Widget build(BuildContext context) {
    final textColor = isPast ? GRAY_400 : Colors.black;
    final cardColor = isPast ? Color(0xffF2F2F2) : OATMEAL_COLOR;
    MarathonController controller = Get.put(MarathonController());
    String formatDateTime(DateTime dateTime) {
      if (dateTime.minute != 0) {
        String formattedDateTime =
            '${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour}시 ${dateTime.minute}분';
        return formattedDateTime;
      } else {
        String formattedDateTime =
            '${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour}시';
        return formattedDateTime;
      }
    }

    String calculateDday(DateTime targetDate) {
      Duration diff = targetDate.difference(DateTime.now());
      if (diff.inDays == 0) {
        return 'DAY';
      } else {
        return diff.inDays.toString();
      }
    }

    return Container(
      padding: EdgeInsets.all(45),
      // color: cardColor,
      child: Column(
        children: [
          // if (marathon.containsKey('image'))
          //     Image.network(
          //       marathon['image'],
          //       height: 220,
          //       width: double.infinity,
          //       fit: BoxFit.cover,
          //     ),
          // SizedBox(height: 40),
          Image.asset(
            'assets/images/sports_medal_3d.png',
            height: 250,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      isPast ? GRAY_400 : (isPast ? Colors.grey : GREEN_COLOR),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isPast ? '종료' : 'D-${calculateDday(marathon.marathonStart)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              // Icon(Icons.arrow_forward_ios, color: isPast ? GRAY_400 : GREEN_COLOR),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.calendar_month_rounded, color: textColor),
              SizedBox(width: 10),
              Text(
                '일시',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(width: 58),
              Expanded(
                child: Text(
                  '${formatDateTime(marathon.marathonStart)}\n ~\n${formatDateTime(marathon.marathonEnd)}',
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.flag_outlined, color: textColor),
              SizedBox(width: 10),
              Text(
                '거리',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(width: 58),
              Expanded(
                child: Text(
                  '${marathon.marathonDist} km',
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.people_alt_rounded, color: textColor),
              SizedBox(width: 10),
              Text(
                '참여 인원',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  '${marathon.marathonDist}명',
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          GestureDetector(
            onTap: () async {
              int idx = await controller
                  .attendMarathon(marathon.marathonSeq.toString());
              print('-----------roomChannel-------------');
              print(idx);
              StompController stompController =
                  Get.put(StompController(roomIdx: 100));
              stompController.marathonInfo.value = marathon;

              if (idx != -1) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("성공적으로 참여했습니다!🥳")));
                stompController.marthonSeq.value = marathon.marathonSeq;
                stompController.attendMarathon(idx);

                // await marathonController.startMarathon('1', '1');
                // print("------------marathonRecordSeq--------------------");
                // print(marathonController.marathonRecordSeq.value);

                // Get.to(MarathonRun(
                //   time: -1,
                //   dist: 10,
                //   appKey: '',
                //   controller: stompController,
                //   marathonController: marathonController,
                //   roomInfo: SimpleMarathon(
                //       marathonSeq: -1,
                //       marathonRound: -1,
                //       marathonDist: 20,
                //       marathonParticipate: 20,
                //       marathonStart: DateTime.now(),
                //       marathonEnd: DateTime.now(),
                //       isDeleted: false),
                // ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("서버가 아파요. 다시 시도해 주세요😡")));
              }
            },
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: isPast ? GRAY_400 : GREEN_COLOR,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  child: Text(isPast ? '종료된 마라톤입니다.' : '참여하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ))),
            ),
          ),
        ],
      ),
    );
  }
}
