import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wadada/common/component/lineChart.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/mypageController.dart';
import 'package:wadada/models/mypage.dart';
import 'package:wadada/provider/mypageProvider.dart';
import 'package:wadada/repository/mypageRepo.dart';

class temp extends ChartData {
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
    MypageController controller = Get.put(MypageController(
        mypageRepository: MypageRepository(mypageAPI: MypageAPI())));
    String date = '';
    String distance = '';
    String recordTypeString = '';
    String recordMode = '';
    Duration duration = Duration();
    List<ChartData> phase = [];
    List<ChartData> speed = [];
    List<ChartData> heartRate = [];
    print('recordSeq');
    print(recordSeq);
    print('recordType');
    print(recordType);
    if (int.parse(recordType) == 1) {
      //거리, 시간 담는
      recordMode = '';
      recordTypeString = '싱글';
      controller.fetchSingleDetail(
          RecordRequest(recordSeq: recordSeq, recordType: recordType));

      SingleDetail singleDetail = controller.singleDetail;

      DateTime createdAt = singleDetail.recordCreatedAt;
      date = '${createdAt.year}-${createdAt.month}-${createdAt.day}';
      distance =
          singleDetail.recordDist.toString(); // Assuming recordDist is a String
      duration =
          singleDetail.recordTime; // Assuming recordTime is already a Duration
      phase = singleDetail.recordPace;
      speed = singleDetail.recordSpeed;
      heartRate = singleDetail.recordHeartbeat;
    } else if (int.parse(recordType) == 2) {
      recordMode = '';
      recordTypeString = '멀티';
      controller.fetchMultiDetail(
          RecordRequest(recordSeq: recordSeq, recordType: recordType));
      MultiDetail multiDetail = controller.multiDetail;
      print(multiDetail);
      DateTime createdAt = multiDetail.recordCreatedAt;
      date = '${createdAt.year}-${createdAt.month}-${createdAt.day}';
      distance =
          multiDetail.recordDist.toString(); // Assuming recordDist is a String
      duration =
          multiDetail.recordTime; // Assuming recordTime is already a Duration
      phase = multiDetail.recordPace;
      speed = multiDetail.recordSpeed;
      heartRate = multiDetail.recordHeartbeat;
      // Assuming datadate = '${createdAt.year}-${createdAt.month}-${createdAt.day}'; assignment for multiDetail if needed
    } else {
      recordMode = '';
      recordTypeString = '마라톤';
      controller.fetchMarathonDetail(
          RecordRequest(recordSeq: recordSeq, recordType: recordType));
      MarathonDetail marathonDetail = controller.marathonDetail;
      print(marathonDetail);
      DateTime createdAt = marathonDetail.recordCreatedAt;
      date = '${createdAt.year}-${createdAt.month}-${createdAt.day}';
      distance = marathonDetail.recordDist
          .toString(); // Assuming recordDist is a String
      duration = marathonDetail
          .recordTime; // Assuming recordTime is already a Duration
      phase = marathonDetail.recordPace;
      speed = marathonDetail.recordSpeed;
      heartRate = marathonDetail.recordHeartbeat;
      // Assuming data assignment for marathon
      //
      //Detail if needed
    }

    String _formatTime(int value) {
      return value.toString().padLeft(2, '0');
    }

    List<String> _splitTime(String timePart) {
      return timePart.split('');
    }

    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    String formattedHours = _formatTime(hours);
    String formattedMinutes = _formatTime(minutes);
    String formattedSeconds = _formatTime(seconds);

    List<String> splithours = _splitTime(formattedHours);
    List<String> splitminutes = _splitTime(formattedMinutes);
    List<String> splitseconds = _splitTime(formattedSeconds);
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
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    SimpleContainer(title: '날짜', content: date),
                    SizedBox(
                      height: 40,
                    ),
                    SimpleContainer(title: '이동거리', content: distance),
                    SizedBox(
                      height: 40,
                    ),
                    TypeContainer(
                        title: '게임 종류',
                        content: recordMode,
                        type: recordTypeString),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      '걸린 시간',
                      style: mainTextStyle,
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        children: [
                          TimeContainer(splithours[0], context),
                          SizedBox(width: 5),
                          TimeContainer(splithours[1], context),
                          SizedBox(width: 7),
                          Text(':',
                              style: TextStyle(
                                  color: GREEN_COLOR,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(width: 7),
                          TimeContainer(splitminutes[0], context),
                          SizedBox(width: 5),
                          TimeContainer(splitminutes[1], context),
                          SizedBox(width: 7),
                          Text(':',
                              style: TextStyle(
                                  color: GREEN_COLOR,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(width: 7),
                          TimeContainer(splitseconds[0], context),
                          SizedBox(width: 5),
                          TimeContainer(splitseconds[1], context),
                        ],
                      ),
                    ),
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
                      data: phase,
                    ),
                    ChartContainer(
                      title: '속도',
                      data: speed,
                    ),
                    ChartContainer(
                      title: '심박수',
                      data: heartRate,
                    ),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ))
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
  final List<ChartData> data;
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
              LineChart<ChartData>(
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

Widget TimeContainer(String digit, BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: OATMEAL_COLOR,
      borderRadius: BorderRadius.circular(10),
    ),
    width: MediaQuery.of(context).size.width * .12,
    height: MediaQuery.of(context).size.height * .07,
    child: Center(
      child: Text(
        digit,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: GREEN_COLOR,
        ),
      ),
    ),
  );
}
