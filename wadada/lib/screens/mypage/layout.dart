import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/mypage/smallNav.dart';

class MyPageLayout extends StatelessWidget {
  const MyPageLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('마이페이지'),
        ),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [SmallNav(), RecordList()],
      ),
    );
  }
}

class RecordList extends StatelessWidget {
  const RecordList({super.key});

  @override
  Widget build(BuildContext context) {
    const list = ['2024-01-01', '2024-01-02', '2024-01-03'];
    return Container(
      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: ListView(
        shrinkWrap: true,
        children: list
            .map((e) => Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.toString(),
                      style: TextStyle(color: GRAY_400),
                    ),
                    SizedBox(height: 10.0),
                    RecordCard()
                  ],
                )))
            .toList(),
      ),
    );
  }
}

class RecordCard extends StatelessWidget {
  const RecordCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: OATMEAL_COLOR,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 0,
              blurRadius: 5.0,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ListTileWidget());
  }
}

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            title: const Text('자유 모드'),
            subtitle: const Row(
              children: [
                Text('싱글'),
                SizedBox(
                  width: 20.0,
                ),
                Text('2.1km'),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                print("HIHIHIHIHI");
              },
              icon: const Icon(Icons.arrow_forward_ios_rounded),
            )),
        ListTile(
            title: const Text('자유 모드'),
            subtitle: const Row(
              children: [
                Text('싱글'),
                SizedBox(
                  width: 20.0,
                ),
                Text('2.1km'),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                print("HIHIHIHIHI");
              },
              icon: const Icon(Icons.arrow_forward_ios_rounded),
            )),
        ListTile(
            title: const Text('자유 모드'),
            subtitle: const Row(
              children: [
                Text('싱글'),
                SizedBox(
                  width: 20.0,
                ),
                Text('2.1km'),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                print("HIHIHIHIHI");
              },
              icon: const Icon(Icons.arrow_forward_ios_rounded),
            )),
      ],
    );
  }
}
