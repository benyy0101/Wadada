import 'package:flutter/material.dart';
import 'package:wadada/screens/singleoptionpage/component/select_option.dart';
// import 'package:wadada/screens/singlerunpage/single_free_run.dart';

class SingleFreeMode extends StatelessWidget{
  const SingleFreeMode({super.key});

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
                    children: const [
                      Text('거리 설정',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        )
                      ),
                      SizedBox(height:10),
                      SelectOption(option: '거리', optionstr: '(km)'),
                      SizedBox(height:40),
                      Text('시간 설정',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        )
                      ),
                      SizedBox(height:10),
                      SelectOption(option: '시간', optionstr: '(분)'),
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
                        onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => SingleFreeIng()));
                        },
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