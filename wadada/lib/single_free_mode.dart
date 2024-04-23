import 'package:flutter/material.dart';
import 'package:wadada/component/select_option.dart';

class SingleFreeMode extends StatelessWidget{
  const SingleFreeMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    children: const [
                      Text('거리설정',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        )
                      ),
                      SizedBox(height:10),
                      SelectOption(),
                    ],
                  ),
                ),
              ],
          ),
        ),
      );
  }
}