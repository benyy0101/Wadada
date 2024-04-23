import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';

void main() {

  runApp(const App());
}


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: OATMEAL_COLOR,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo_green.png'),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                  Text('혼자 달려',
                    style: TextStyle(
                      color: DARK_GREEN_COLOR,
                      fontSize: 40,
                      fontWeight: FontWeight.w800),

                    ),
                  Text('친구랑 달려',
                    style: TextStyle(
                      color: DARK_GREEN_COLOR,
                      fontSize: 40,
                      fontWeight: FontWeight.w800),

                    ),
                  Text('일단 달려',
                    style: TextStyle(
                      color: DARK_GREEN_COLOR,
                      fontSize: 40,
                      fontWeight: FontWeight.w800),
                    ),
                  Text('와다다',
                    style: TextStyle(
                      color: DARK_GREEN_COLOR,
                      fontSize: 40,
                      fontWeight: FontWeight.w800),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 50
            ),
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 2, // 그림자 범위
                    blurRadius: 5, // 그림자 흐림 정도
                    offset: Offset(1, 5), // 그림자 위치
                  ),
                ],
              ),
              child: Image.asset('assets/images/kakao_button.png'),
            ),
          ],
        ),
      ),
    );
  }
}