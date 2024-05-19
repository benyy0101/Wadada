import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/marathonmainpage/marathonmainpage.dart';
import 'package:wadada/screens/multimainpage/multi_main.dart';
import 'package:wadada/screens/mypage/layout.dart';
import 'package:wadada/screens/singlemainpage/single_main.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.all(0),
            child: Text('WADADA',
              style: TextStyle(
                fontFamily: 'Lundry',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 0,
          padding: EdgeInsets.zero,
          color: OATMEAL_COLOR,
          child: TabBar(
            indicatorColor: Colors.transparent,
            labelColor: DARK_GREEN_COLOR,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(
                  icon: Icon(Icons.person),
                  text: '싱글',
                  iconMargin: EdgeInsets.all(0)),
              Tab(
                  icon: Icon(Icons.group),
                  text: '멀티',
                  iconMargin: EdgeInsets.all(0)),
              Tab(
                  icon: Icon(Icons.emoji_events),
                  text: '마라톤',
                  iconMargin: EdgeInsets.all(0)),
              Tab(
                  icon: Icon(Icons.insert_chart),
                  text: '내 정보',
                  iconMargin: EdgeInsets.all(0)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleMain(),
            MultiMain(),
            MarathonMain(),
            MyPageLayout(),
          ],
        ),
      ),
    );
  }
}
