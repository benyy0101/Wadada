import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';

class Room extends StatelessWidget{
  const Room({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 200,
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
        child: Row(
          children: [
            Text('방 코드',
              style: TextStyle(
                color: DARK_GREEN_COLOR,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 30),
            Container(
              // decoration: BoxDecoration(
              //   color: Colors.black
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Row(
                    children: [
                      Column(
                        children: [
                          Icon(Icons.location_on, color: DARK_GREEN_COLOR), // 위치 아이콘
                          SizedBox(height: 10),
                          Icon(Icons.people, color: DARK_GREEN_COLOR), // 참여 인원 아이콘
                          SizedBox(height: 10),
                          Icon(Icons.lock, color: DARK_GREEN_COLOR), // 비밀방 아이콘
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('거리', style: TextStyle(color: DARK_GREEN_COLOR, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('참여 인원', style: TextStyle(color: DARK_GREEN_COLOR, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('비밀방', style: TextStyle(color: DARK_GREEN_COLOR, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('10km'),
                          SizedBox(height: 10),
                          Text('1/3'),
                          SizedBox(height: 10),
                          Text(''),
                        ],
                      ),
                      ],
                  )
                ],
              )
            )
          ],
        )
      ),
    );
  }
}