import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/multirunpage/multirunpage.dart';
import 'package:wadada/screens/singleoptionpage/component/select_dist_option.dart';
import 'package:wadada/screens/singleoptionpage/component/select_time_option.dart';
import 'package:wadada/screens/singleoptionpage/singleerror.dart';
import 'package:wadada/screens/singlerunpage/single_free_run.dart';
import 'package:geolocator/geolocator.dart';

class SingleOption extends StatefulWidget {
  final bool isDistMode;
  const SingleOption({super.key, required this.isDistMode});

  @override
  SingleFreeModeState createState() => SingleFreeModeState();
}

class SingleFreeModeState extends State<SingleOption> {
  SelectDistOptionState? distOptionState;
  SelectTimeOptionState? timeOptionState;

  void clickstart() async {
    FocusScope.of(context).unfocus();

    SelectTimeOptionState? selectedTimeOptionState;
    SelectDistOptionState? selectedDistOptionState;

    if (widget.isDistMode) {
      selectedDistOptionState = distOptionState;
    } else {
      selectedTimeOptionState = timeOptionState;
    }

    bool hasError = false;
    if (selectedTimeOptionState != null && selectedTimeOptionState.isError) {
      hasError = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(selectedTimeOptionState.errorText ?? '오류 발생'),
        ),
      );
    } else if (selectedDistOptionState != null &&
        selectedDistOptionState.isError) {
      hasError = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(selectedDistOptionState.errorText ?? '오류 발생'),
        ),
      );
    }

    if (!hasError) {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          serviceEnabled = await Geolocator.openLocationSettings();
          if (!serviceEnabled) {
            Get.to(() => SingleError());
            return;
          }
          return;
        }

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          // 권한이 부여되지 않으면 사용자에게 메시지를 표시하고 앱을 종료
          // 권한을 받지 못하면 런을 시작할 수 없음
          Get.to(() => SingleError());
          return;
        }
        }

        if (permission == LocationPermission.deniedForever) {
          Get.to(() => SingleError());
          return;
        }

        if (selectedTimeOptionState != null) {
            int time = selectedTimeOptionState.time;
            String appKey = dotenv.env['APP_KEY'] ?? '';
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleFreeRun(dist: 0, time: time, appKey: appKey),
              ),
            );
        } else if (selectedDistOptionState != null) {
          print('거리모드ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ');
            int dist = selectedDistOptionState.dist;
            String appKey = dotenv.env['APP_KEY'] ?? '';
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleFreeRun(dist: dist, time: 0, appKey: appKey),
              ),
            );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 45,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        if (widget.isDistMode)
                          Text('거리모드 - 싱글',
                              style: TextStyle(
                                color: GRAY_900,
                                fontSize: 20,
                              )),
                        if (!widget.isDistMode)
                          Text('시간모드 - 싱글',
                              style: TextStyle(
                                color: GRAY_900,
                                fontSize: 20,
                              )),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                if (widget.isDistMode) // 거리 모드
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '거리 설정',
                        style: TextStyle(color: GRAY_500, fontSize: 19),
                      ),
                      SizedBox(height: 10),
                      SelectDistOption(
                        option: '거리',
                        optionstr: '(km)',
                        onStateUpdated: (state) {
                          setState(() {
                            distOptionState = state;
                          });
                        },
                      ),
                    ],
                  ),
                if (!widget.isDistMode) // 시간 모드
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '시간 설정',
                        style: TextStyle(color: Colors.black54, fontSize: 19),
                      ),
                      SizedBox(height: 10),
                      SelectTimeOption(
                        option: '시간',
                        optionstr: '(분)',
                        onStateUpdated: (state) {
                          setState(() {
                            timeOptionState = state;
                          });
                        },
                      ),
                    ],
                  ),
                SizedBox(height: 80),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffADB5BD),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                child: Text('취소',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ))),
                          )),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: clickstart,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff5BC879),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              child: Text('시작하기',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ))),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
