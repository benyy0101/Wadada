import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/multimainpage/component/room.dart';

class MultiMain extends StatelessWidget{
  const MultiMain({super.key});

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
                      Text('시간모드 - 멀티',
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 120,
                      height: 45,
                      decoration: BoxDecoration(
                        color: GREEN_COLOR,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '방 생성하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color.fromARGB(255, 204, 204, 204)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '방 코드를 입력하세요',
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10), 
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 80,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: DARK_GREEN_COLOR,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '검색',
                          style: TextStyle(
                            color: DARK_GREEN_COLOR,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: const [
                    Room(),
                  ],
                )
              ],
          ),
        ),
      );
  }
}