import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wadada/screens/multirunpage/multirunpage.dart';
import 'package:wadada/screens/singleoptionpage/component/select_dist_option.dart';
import 'package:wadada/screens/singleoptionpage/component/select_time_option.dart';
import 'package:wadada/screens/singlerunpage/single_free_run.dart';
import 'package:geolocator/geolocator.dart';

class SingleOption extends StatefulWidget{
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
    } else if (selectedDistOptionState != null && selectedDistOptionState.isError) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('위치 서비스가 비활성화되어 있습니다.'),
            ),
          );
          return;
        }

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('위치 권한을 허용해주세요.'),
              ),
            );
            return;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('위치 권한을 허용해주세요.'),
            ),
          );
          return;
        }

        if (selectedTimeOptionState != null) {
            double time = selectedTimeOptionState.time ?? 0.0;
            String appKey = dotenv.env['APP_KEY'] ?? '';
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleFreeRun(dist: 0, time: time, appKey: appKey),
              ),
            );
        } else if (selectedDistOptionState != null) {
            double dist = selectedDistOptionState.dist ?? 0.0;
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
      body:
        Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          child:Column(
            children: [
              SizedBox(
                height: 45,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Column(children: [
                    Text('자유모드 - 싱글',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      )
                    ),
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
                      style: TextStyle(color: Colors.black54, fontSize: 19),
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
                        borderRadius: BorderRadius.circular(10)
                      ),
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
                          )
                        )
                      ),
                    )
                  ),
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
                            )
                          )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}