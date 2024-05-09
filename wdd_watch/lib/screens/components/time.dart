import 'package:flutter/material.dart';
import 'package:watch_app/commons/const/colors.dart';

class runTime extends StatelessWidget {
  const runTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            Text(
              "달린 시간",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),


            // countdown  값 받아오기
            const Text(
              '00:01:50',
              style: TextStyle(color: GREEN_COLOR, fontSize: 35, fontWeight: FontWeight.bold))
          ],
        ),
      )
    );
  }
}
