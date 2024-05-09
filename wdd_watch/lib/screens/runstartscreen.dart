import 'package:flutter/material.dart';
import 'package:watch_app/commons/const/colors.dart';

// 달리기 시작 알림 화면
class RunStartScreen extends StatefulWidget {
  const RunStartScreen({super.key});

  @override
  State<RunStartScreen> createState() => _RunStartScreenState();
}

class _RunStartScreenState extends State<RunStartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            const SizedBox(height: 10),
            Text(
              "달리기를 시작합니다!",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '5',
              style: TextStyle(color: GREEN_COLOR, fontSize: 35, fontWeight: FontWeight.bold))
          ],
        ),
      )
    );
  }
}
