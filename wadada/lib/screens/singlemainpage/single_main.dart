import 'package:flutter/material.dart';
import 'package:wadada/common/component/logout.dart';
import 'package:wadada/screens/singlemainpage/component/select_mode.dart';
import 'package:wadada/screens/singlemainpage/component/single_record.dart';

class SingleMain extends StatelessWidget{
  const SingleMain({super.key});

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
                  icon: 'assets/images/shoes.png', 
                  name: '자유모드', 
                  des: '자유롭게 달리고 기록합니다.',
                  btn: '28',
                ),
                SizedBox(height: 30,),
                SelectMode(
                  icon: 'assets/images/map.png', 
                  name: '챌린지모드', 
                  des: '코스를 뛰고, 기록에 도전하세요.',
                  btn: '8',
                ),
                SizedBox(height: 30,),
                LogoutButton(),
              ],
          ),
        ),
      );
  }
}