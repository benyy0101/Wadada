import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';


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
                Tab(icon: Icon(Icons.insert_chart), text: '나의기록'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.person),
              Icon(Icons.groups),
              Icon(Icons.emoji_events),
              Icon(Icons.insert_chart),
            ],
          ),
        ),
      ),
    );
  }
}

