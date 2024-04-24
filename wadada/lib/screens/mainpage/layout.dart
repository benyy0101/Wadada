import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';

class MainPageLayout extends StatelessWidget {
  const MainPageLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          _KakaoButton(),
        ],
      ),
    );
  }
}



class _KakaoButton extends StatelessWidget {
  const _KakaoButton({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(1, 5),
          ),
        ],
      ),
      child: Image.asset('assets/images/kakao_button.png'),
    );
  }
}