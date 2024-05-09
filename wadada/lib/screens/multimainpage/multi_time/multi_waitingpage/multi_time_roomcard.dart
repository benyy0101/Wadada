import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';

class TimeRoomInfoCard extends StatelessWidget {
  const TimeRoomInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: OATMEAL_COLOR,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(1, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, // 세로 기준 가운데 정렬
            children: [
              // 방 코드
              Expanded(
                flex: 1, // 왼쪽 부분 (방 코드)의 크기 조절
                child: Text(
                  '스펀지밥',
                  style: TextStyle(
                    color: DARK_GREEN_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // 세부 정보
              Expanded(
                flex: 3, // 오른쪽 부분 (세부 정보)의 크기 조절
                child: Row(
                  children: [
                    Column(
                      children: [
                        Icon(Icons.watch_later_outlined, color: DARK_GREEN_COLOR),
                        SizedBox(height: 10),
                        Icon(Icons.people, color: DARK_GREEN_COLOR),
                        SizedBox(height: 10),
                        Icon(Icons.lock, color: DARK_GREEN_COLOR),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('시간', 
                          style: TextStyle(
                            color: DARK_GREEN_COLOR, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        SizedBox(height: 13),
                        Text('참여 인원', 
                          style: TextStyle(
                            color: DARK_GREEN_COLOR, 
                            fontWeight: FontWeight.bold
                            )
                          ),
                        SizedBox(height: 13),
                        Text('비밀방', 
                          style: TextStyle(
                            color: DARK_GREEN_COLOR, 
                            fontWeight: FontWeight.bold
                            )
                          ),
                      ],
                    ),
                    SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('35 분'),
                        SizedBox(height: 13),
                        Text('1/3'),
                        SizedBox(height: 13),
                        Text(''),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
