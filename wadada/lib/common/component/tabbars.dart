import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/mypage/layout.dart';
import 'package:wadada/screens/singlemainpage/single_main.dart';


class TabBars extends StatelessWidget {
  const TabBars({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            color: OATMEAL_COLOR,
            child: TabBar(
              indicatorColor: Colors.transparent,
              labelColor: DARK_GREEN_COLOR,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(icon: Icon(Icons.person), text: '싱글모드'),
                Tab(icon: Icon(Icons.groups), text: '멀티모드'),
                Tab(icon: Icon(Icons.emoji_events), text: '마라톤'),
                Tab(icon: Icon(Icons.insert_chart), text: '마이페이지'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SingleMain(),
              // Icon(Icons.person),
              Icon(Icons.groups), // 아직 멀티 페이지가 없어서 임시로 넣어놓음
              // 아직 마라톤도 없어서 임시로 넣어놓음
              Icon(Icons.emoji_events),
              MyPageLayout(),
              // Icon(Icons.insert_chart),
            ],
          ),
        ),
      ),
    );
  }
}

