import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/singlemainpage/single_main.dart';

class SingleResult extends StatefulWidget{
  const SingleResult({super.key});

  @override
  SingleFreeModeState createState() => SingleFreeModeState();
}

class SingleFreeModeState extends State<SingleResult> {
  // SelectDistOptionState? distOptionState;
  // SelectTimeOptionState? timeOptionState;

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
                    Text('나의 통계',
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
                    Text('통계 페이지'),
                  ],
                ),
              ),
              SizedBox(height: 80),
              GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SingleMain()));
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
            ],
          ),
        ),
      );
  }
}