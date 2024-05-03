import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wadada/screens/singleoptionpage/component/select_dist_option.dart';
import 'package:wadada/screens/singleoptionpage/component/select_time_option.dart';
import 'package:wadada/screens/singlerunpage/single_free_run.dart';

class SingleOption extends StatefulWidget{
  final bool isDistMode;
  const SingleOption({super.key, required this.isDistMode});

  @override
  SingleFreeModeState createState() => SingleFreeModeState();
}

class SingleFreeModeState extends State<SingleOption> {
  SelectDistOptionState? distOptionState;
  SelectTimeOptionState? timeOptionState;

  void clickstart() {
    SelectTimeOptionState? selectedTimeOptionState;
    SelectDistOptionState? selectedDistOptionState;

    if (widget.isDistMode) {
        selectedDistOptionState = distOptionState;
    } else {
        selectedTimeOptionState = timeOptionState;
    }

    if (selectedTimeOptionState != null) {
      if (selectedTimeOptionState.isError == true) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(selectedTimeOptionState.errorText ?? '오류 발생'),
              ),
          );
          return;
      }
      double time = selectedTimeOptionState.time ?? 0.0;
      String appKey = dotenv.env['APP_KEY'] ?? '';
      Navigator.push(context, MaterialPageRoute(builder: (context) => SingleFreeRun(dist: 0, time: time, appKey: appKey)));
    } else if (selectedDistOptionState != null) {
      if (selectedDistOptionState.isError == true) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(selectedDistOptionState.errorText ?? '오류 발생'),
              ),
          );
          return;
      }
      double dist = selectedDistOptionState.dist ?? 0.0;
      String appKey = dotenv.env['APP_KEY'] ?? '';
      Navigator.push(context, MaterialPageRoute(builder: (context) => SingleFreeRun(dist: dist, time: 0, appKey: appKey)));
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
              // Container(
              //   child:Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text('거리 설정',
              //         style: TextStyle(
              //           color: Colors.black54,
              //           fontSize: 15,
              //         )
              //       ),
              //       SizedBox(height:10),
              //       SelectDistOption(
              //         option: '거리',
              //         optionstr: '(km)',
              //         onStateUpdated: (state) {
              //           setState(() {
              //               distOptionState = state;
              //           });
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              if (widget.isDistMode) // 거리 모드
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '거리 설정',
                      style: TextStyle(color: Colors.black54, fontSize: 15),
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
                      style: TextStyle(color: Colors.black54, fontSize: 15),
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