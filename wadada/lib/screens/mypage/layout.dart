import 'package:flutter/material.dart';
import 'package:wadada/common/component/logout.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/mypage/avartar.dart';
import 'package:wadada/screens/mypage/editProfile.dart';
import 'package:wadada/screens/mypage/recordList.dart';
import 'package:wadada/screens/mypage/smallNav.dart';

import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/mypage/smallNav.dart';

import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/mypage/smallNav.dart';
import 'package:wadada/screens/newprofilepage/layout.dart';

class MyPageLayout extends StatefulWidget {
  const MyPageLayout({super.key});

  @override
  State<MyPageLayout> createState() => _MyPageLayoutState();
}

class _MyPageLayoutState extends State<MyPageLayout>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 45,
            ),
            Text('멀티모드',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                )),
            PreferredSize(
              preferredSize:
                  Size.fromHeight(100), // Specify the preferred height
              child: SizedBox(
                height: 100,
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  labelColor: DARK_GREEN_COLOR,
                  indicatorColor: Colors.transparent,
                  unselectedLabelColor: GRAY_400,
                  tabs: const [
                    Tab(
                      text: "내 기록",
                      icon: Icon(
                        Icons.history_edu_rounded,
                        size: 30.0,
                      ),
                    ),
                    Tab(
                      text: "아바타",
                      icon: Icon(
                        Icons.sentiment_very_satisfied_rounded,
                        size: 30.0,
                      ),
                    ),
                    Tab(
                      text: "프로필 수정",
                      icon: Icon(
                        Icons.access_alarm,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 100,
                child: TabBarView(
                  controller: _tabController,
                  children: [RecordList(), avatarWidget(), EditProfile()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
