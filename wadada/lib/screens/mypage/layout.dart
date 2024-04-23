import 'package:flutter/material.dart';

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

class SmallNav extends StatelessWidget {
  const SmallNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            onPressed: () {},
            tooltip: '내 기록을 봅니다',
            icon: const Column(
              children: [
                Icon(
                  Icons.history_edu_rounded,
                  size: 50.0,
                ),
                SizedBox(height: 5.0),
                Text('내 기록')
              ],
            )),
        IconButton(
            onPressed: () {},
            tooltip: '',
            icon: const Column(
              children: [
                Icon(
                  Icons.sentiment_very_satisfied_rounded,
                  size: 50,
                ),
                SizedBox(height: 5.0),
                Text('아바타')
              ],
            )),
        IconButton(
            onPressed: () {},
            tooltip: '프로필을 수정합니다.',
            icon: const Column(
              children: [
                Icon(
                  Icons.access_alarm,
                  size: 50.0,
                ),
                SizedBox(height: 5.0),
                Text('프로필 수정')
              ],
            )),
      ],
    );
  }
}

class RecordList extends StatelessWidget {
  const RecordList({super.key});

  @override
  Widget build(BuildContext context) {
    const list = ['2024-01-01', '2024-01-02', '2024-01-03'];
    return Container(
      padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
      child: ListView(
        shrinkWrap: true,
        children: list
            .map((e) => Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(e.toString()), RecordCard()],
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
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            color: Colors.amber,
            child: Column(
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
            )));
  }
}
