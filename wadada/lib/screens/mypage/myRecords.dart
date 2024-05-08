import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wadada/common/component/lineChart.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/mypageController.dart';
import 'package:wadada/models/mypage.dart';
import 'package:wadada/provider/mypageProvider.dart';
import 'package:wadada/repository/mypageRepo.dart';

class temp extends chartData {
  temp(super.distance, super.numerics);
}

class MyRecords extends StatelessWidget {
  final List<temp> chartData = [
    temp(12, 160),
    temp(13, 150),
    temp(14, 120),
    temp(15, 80),
    temp(16, 110)
  ];

  MyRecords({super.key, required this.recordSeq, required this.recordType});
  final int recordSeq;
  final String recordType;

  @override
  Widget build(BuildContext context) {
    Get.put(MypageController(
        mypageRepository: MypageRepository(mypageAPI: MypageAPI())));

    return Scaffold(
        appBar: AppBar(
          title: Text('나의 기록'),
          centerTitle: true,
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: GetBuilder<MypageController>(
                    builder: (MypageController mypagecontroller) {
                  RecordRequest req = RecordRequest(
                      recordSeq: recordSeq, recordType: recordType);
                  mypagecontroller.fetchDetail(req);
                  return ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      SimpleContainer(title: '날짜', content: '2024-01-01'),
                      SizedBox(
                        height: 40,
                      ),
                      SimpleContainer(title: '이동거리', content: '1.23 km'),
                      SizedBox(
                        height: 40,
                      ),
                      TypeContainer(
                          title: '게임 종류', content: '거리 모드', type: '멀티'),
                      SizedBox(
                        height: 40,
                      ),
                      SimpleContainer(title: '소요 시간', content: '추후 반영 예정'),
                      SizedBox(
                        height: 40,
                      ),
                      RouteContainer(
                        title: '나의 경로',
                        content: Image.asset(
                          'assets/images/temp_map.png',
                          width: MediaQuery.of(context).size.width * 0.9,
                        ),
                      ),
                      ChartContainer(
                        title: '페이스',
                        data: chartData,
                      ),
                      ChartContainer(
                        title: '속도',
                        data: chartData,
                      ),
                      ChartContainer(
                        title: '심박수',
                        data: chartData,
                      ),
                      SizedBox(
                        height: 80,
                      )
                    ],
                  );
                }))
          ],
        ));
  }
}

class SimpleContainer extends StatelessWidget {
  final String title;
  final String content;
  const SimpleContainer(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: mainTextStyle,
            ),
            SizedBox(height: 20),
            Text(content, style: highlightTextStyle)
          ],
        )
      ],
    );
  }
}

class RouteContainer extends StatelessWidget {
  final String title;
  final Image content;
  const RouteContainer({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: mainTextStyle,
            ),
            SizedBox(height: 20),
            content
          ],
        )
      ],
    );
  }
}

class TypeContainer extends StatelessWidget {
  final String title;
  final String content;
  final String type;
  const TypeContainer(
      {super.key,
      required this.title,
      required this.content,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: mainTextStyle,
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Text(content, style: highlightTextStyle),
                SizedBox(
                  width: 20,
                ),
                Text(type,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: GRAY_400))
              ],
            )
          ],
        )
      ],
    );
  }
}

class ChartContainer extends StatelessWidget {
  final List<temp> data;
  final String title;
  const ChartContainer({super.key, required this.data, required this.title});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: GRAY_500),
              ),
              SizedBox(
                height: 20,
              ),
              LineChart<temp>(
                chartData: data,
                metrics: 'hz',
                graphType: 'speed',
              )
            ],
          )
        ],
      ),
    );
  }
}
