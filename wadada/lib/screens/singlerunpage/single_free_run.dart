import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/singlerunpage/component/clock.dart';
import 'package:wadada/screens/singlerunpage/component/map.dart';
import 'package:wadada/screens/singlerunpage/component/progress_bar.dart';

class SingleFreeRun extends StatelessWidget{
  final double time;
  // final double dist;
  // const SingleFreeRun({super.key, required this.time, required this.dist});
  const SingleFreeRun({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 60,
                ),
                ProgressBar(),
                SizedBox(
                    height: 45,
                ),
                // 나의경로
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('나의 경로',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      )
                    ),
                    SizedBox(height: 10),
                    MyMap(),
                  ],
                ),
                SizedBox(height: 35),
                // 이동거리, 현재 페이스
                Row(
                  children: const [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('이동거리',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            )
                          ),
                          SizedBox(height: 5),
                          Text('1.21km',
                            style: TextStyle(
                              color: GREEN_COLOR,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            )
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('현재 페이스',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            )
                          ),
                          SizedBox(height: 5),
                          Text('10',
                            style: TextStyle(
                              color: GREEN_COLOR,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // 소요 시간
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(time == 0? '소요 시간' : '남은 시간',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      )
                    ),
                    SizedBox(height: 10),
                    Clock(time: time),
                  ],
                ),
                SizedBox(height: 30),
                // 심박수
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('심박수',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      )
                    ),
                    SizedBox(height: 5),
                    Text('100',
                      style: TextStyle(
                        color: GREEN_COLOR,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      )
                    ),
                  ],
                ),
                SizedBox(height: 40),
                // 종료 버튼
                Container(
                  width:double.maxFinite,
                  decoration: BoxDecoration(
                    color: GREEN_COLOR,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    child: Text('종료하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      )
                    )
                  ),
                ),
              ],
            ),
          ),
      );
  }
}