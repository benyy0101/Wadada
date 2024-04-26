import 'package:flutter/material.dart';
import 'package:wadada/screens/singleoptionpage/component/select_dist_option.dart';
import 'package:wadada/screens/singleoptionpage/component/select_time_option.dart';
import 'package:wadada/screens/singlerunpage/single_free_run.dart';

class SingleFreeMode extends StatefulWidget{
  const SingleFreeMode({super.key});

  @override
  SingleFreeModeState createState() => SingleFreeModeState();
}

class SingleFreeModeState extends State<SingleFreeMode> {
  SelectDistOptionState? distOptionState;
  SelectTimeOptionState? timeOptionState;

  void clickstart() {
    if (timeOptionState?.errorText != null) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(timeOptionState?.errorText ?? '오류 발생'),
      //   ),
      // );
      return;
    }

    double time = timeOptionState?.time ?? 0.0;
    // double dist = distOptionState?.dist ?? 0.0;
    Navigator.push(context, MaterialPageRoute(builder: (context) => SingleFreeRun(time:time)));
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
              Container(
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('거리 설정',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      )
                    ),
                    SizedBox(height:10),
                    SelectDistOption(
                      option: '거리',
                      optionstr: '(km)',
                      onStateUpdated: (state) {
                        setState(() {
                            distOptionState = state;
                        });
                      },
                    ),
                    SizedBox(height:40),
                    Text('시간 설정',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      )
                    ),
                    SizedBox(height:10),
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