import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_app/commons/const/colors.dart';
import 'package:watch_app/constants.dart';

class runPace extends StatelessWidget {
  const runPace({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            Text(
              "페이스",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 5),

            
            // countdown  값 받아오기
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                Icon(
                  Icons.speed,
                  size: 35,
                  color: GREEN_COLOR,
                ),

                SizedBox(width: 5),

                // pace  값 받아오기
                Text(
                  "10'58''",
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
