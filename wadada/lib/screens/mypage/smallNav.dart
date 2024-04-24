import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';

class SmallNav extends StatelessWidget {
  const SmallNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      TabBar(tabs: <Widget>[Tab(text: "1"), Tab(text: "2"), Tab(text: "3")])
    ]);
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: [
    //     IconButton(
    //         onPressed: () {},
    //         tooltip: '내 기록을 봅니다',
    //         icon: const Column(
    //           children: [
    //             Icon(
    //               Icons.history_edu_rounded,
    //               size: 50.0,
    //             ),
    //             SizedBox(height: 5.0),
    //             Text('내 기록')
    //           ],
    //         )),
    //     IconButton(
    //         onPressed: () {},
    //         tooltip: '',
    //         icon: const Column(
    //           children: [
    //             Icon(
    //               Icons.sentiment_very_satisfied_rounded,
    //               size: 50,
    //             ),
    //             SizedBox(height: 5.0),
    //             Text('아바타')
    //           ],
    //         )),
    //     IconButton(
    //         onPressed: () {},
    //         tooltip: '프로필을 수정합니다.',
    //         icon: const Column(
    //           children: [
    //             Icon(
    //               Icons.access_alarm,
    //               size: 50.0,
    //             ),
    //             SizedBox(height: 5.0),
    //             Text('프로필 수정')
    //           ],
    //         )),
    //   ],
    // );
  }
}
