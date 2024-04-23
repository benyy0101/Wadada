import 'package:flutter/material.dart';
import 'package:wadada/component/select_mode.dart';
import 'package:wadada/component/single_record.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: 
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child:Column(
              children: [
                SizedBox(
                  height: 45,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Column(children: [
                      Text('싱글모드',
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
                  child:Row(
                    children: const [
                      Text('김태수님의 최근 기록',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        )
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                SingleRecord(),
                SizedBox(height: 50,),
                SelectMode(
                  icon: 'assets/shoes.png', 
                  name: '자유모드', 
                  des: '자유롭게 달리고 기록합니다.',
                  btn: '30',
                ),
                SizedBox(height: 30,),
                SelectMode(
                  icon: 'assets/shoes.png', 
                  name: '챌린지모드', 
                  des: '코스를 뛰고, 기록에 도전하세요.',
                  btn: '7',
                ),
              ],
          ),
        ),
      ),
    );
  }
}