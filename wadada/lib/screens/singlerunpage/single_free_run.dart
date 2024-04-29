import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/singleresultpage/singleresultpage.dart';

import 'package:wadada/screens/singlerunpage/component/clock.dart';
import 'package:wadada/screens/singlerunpage/component/map.dart';
import 'package:wadada/screens/singlerunpage/component/dist_bar.dart';
import 'package:wadada/screens/singlerunpage/component/time_bar.dart';

class SingleFreeRun extends StatefulWidget{
  final double time;
  final double dist;
  final String appKey;
  // const SingleFreeRun({super.key, required this.time, required this.dist});
  const SingleFreeRun({super.key, required this.time, required this.dist, required this.appKey});
  
  @override
  _SingleFreeRunState createState() => _SingleFreeRunState();
}

class _SingleFreeRunState extends State<SingleFreeRun> {
  double totalDistance = 0.0;
  String formattedDistance = '0.00';

  late MyMap myMap;

  @override
  void initState() {
    super.initState();
    myMap = MyMap(appKey: widget.appKey);
    _subscribeToTotalDistance();
  }

  void _subscribeToTotalDistance() {
    myMap.totalDistanceNotifier.addListener(() {
      setState(() {
        totalDistance = myMap.totalDistanceNotifier.value;
        formattedDistance = totalDistance.toStringAsFixed(2);
        // print(totalDistance);
        // print(formattedDistance);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget progressBar = Container();

    if (widget.dist > 0) {
        progressBar = DistBar();
    } else if (widget.time > 0) {
        progressBar = TimeBar();
    }

    // double totalDistance = myMap.getTotalDistance();
    // String formattedDistance = totalDistance.toStringAsFixed(2);

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
                progressBar,
                SizedBox(
                    height: 45,
                ),
                // 나의경로
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('나의 경로',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      )
                    ),
                    SizedBox(height: 10),
                    MyMap(appKey: widget.appKey),
                  ],
                ),
                SizedBox(height: 35),
                // 이동거리, 현재 페이스
                Row(
                  children: [
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
                          // Text('1.21km',
                          //   style: TextStyle(
                          //     color: GREEN_COLOR,
                          //     fontSize: 30,
                          //     fontWeight: FontWeight.w700,
                          //   )
                          // ),
                          Text('$formattedDistance km',
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
                        children: const [
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
                    Text(widget.time == 0? '소요 시간' : '남은 시간',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      )
                    ),
                    SizedBox(height: 10),
                    Clock(time: widget.time),
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
                GestureDetector(
                  onTap: () {
                    _showEndModal(context);
                  },
                  child: Container(
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
                ),
              ],
            ),
          ),
      );
  }
}

void _showEndModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Color(0xffD6D6D6),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 50),
              Text('종료하시겠습니까?',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Text('중간에 종료하는 경우\n현재까지의 기록으로 분석이 이루어집니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 50),
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SingleResult()));
                    },
                    child: Container(
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width:double.maxFinite,
                      decoration: BoxDecoration(
                        color: GRAY_400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        child: Text('취소',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        );
      },
    );
  }