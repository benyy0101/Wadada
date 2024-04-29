import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';

class MyMap extends StatelessWidget{
  // const SingleFreeRun({super.key, required this.time, required this.dist});
  const MyMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        height: 230,
        decoration: BoxDecoration(
          color: OATMEAL_COLOR,
        ),
        child: Text('지도',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: GREEN_COLOR,
            fontWeight: FontWeight.bold,
          ),
        )
      );
    }
}