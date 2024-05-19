import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wadada/common/component/logout.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/marathonController.dart';
import 'package:wadada/controller/profileController.dart';
import 'package:wadada/models/marathon.dart';
import 'package:wadada/repository/profileRepo.dart';
import 'package:wadada/screens/marathonrunpage/marathonRun.dart';
import 'package:wadada/screens/mypage/avartar.dart';
import 'package:wadada/screens/mypage/editProfile.dart';
import 'package:wadada/screens/mypage/recordList.dart';

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
    ProfileController controller =
        Get.put(ProfileController(repo: ProfileRepository()));
    MarathonController marathonController = Get.put(MarathonController());
    controller.getProfile();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
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
                  tabs: [
                    Tab(
                        text: "내 기록",
                        iconMargin: EdgeInsets.zero,
                        icon: Image.asset(
                          'assets/images/person_running_3d_light.png',
                          width: 50,
                        )),
                    Tab(
                        text: "아바타",
                        iconMargin: EdgeInsets.zero,
                        icon: Image.asset(
                          'assets/images/melting_face_3d.png',
                          width: 50,
                        )),
                    Tab(
                        text: "프로필 수정",
                        iconMargin: EdgeInsets.zero,
                        icon: Image.asset(
                          'assets/images/bell_3d.png',
                          width: 50,
                        )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 100,
                child: TabBarView(
                  controller: _tabController,
                  children: [RecordList(), AvatarWidget(), EditProfile()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
