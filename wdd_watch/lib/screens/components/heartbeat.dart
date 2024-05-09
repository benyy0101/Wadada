import 'package:flutter/material.dart';
import 'package:watch_app/commons/const/colors.dart';

class runHeart extends StatelessWidget {
  const runHeart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            Text(
              "심박수",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 5),


            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                Icon(
                  Icons.heart_broken,
                  size: 35,
                  color: GREEN_COLOR,
                ),

                SizedBox(width: 5),

                 // 심박수 센서에서 값 가져오기
                Text(
                  "130",
                  style: TextStyle(color: GREEN_COLOR, fontSize: 35, fontWeight: FontWeight.bold)
                )
              ],

            )
          ],
        ),
      )
    );
  }
}
