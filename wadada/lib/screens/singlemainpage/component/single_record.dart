import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class SingleRecord extends StatefulWidget {
  const SingleRecord({super.key});

  @override
  _SingleRecordState createState() => _SingleRecordState();
}

class _SingleRecordState extends State<SingleRecord> {
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
  }

  Future<Map<String, dynamic>> fetchData() async {
    final url = Uri.parse('https://k10a704.p.ssafy.io/Single');
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');
    print('토큰 $accessToken');
    final dio = Dio();

    try {
      final response = await dio.get(url.toString(),
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'authorization': accessToken
          }));

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        print('통신 성공');
        return data;
      } else if (response.statusCode == 204) {
        print('204');
        return {};
      } else {
        print('서버 요청 실패: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('요청 처리 중 에러 발생 싱글레코드: $e');
      return {};
    }
  }

  String formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int secs = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  // 초를 mm:ss 형식으로 변환하는 함수
  String formatPace(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;

    return '${minutes.toString()}' "'${secs.toString().padLeft(2, '0')}\"";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('데이터를 가져오는 중 에러가 발생했습니다.'));
        } else if (snapshot.data != null && snapshot.data!.isEmpty) {
          return Container(
              decoration: BoxDecoration(
                color: Color(0xffF6F4E9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                child: Center(
                    child: Text('최근 기록이 없습니다.',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: GRAY_900))),
              ));
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          final recordTime = data['recordTime'];
          final recordDist = data['recordDist'];
          final recordPace = data['recordPace'] as double;
          final recordHeartbeat = data['recordHeartbeat'];

          double changeDist = recordDist / 1000;
          String formattedChangeDist = changeDist.toStringAsFixed(2);

          // 초를 hh:mm:ss로 변환
          String formattedTime = formatDuration(recordTime);

          // double recordPace를 int로 변환한다
          int recordPaceInt = recordPace.toInt();

          // int recordPace를 mm:ss 형식으로 변환
          String formattedPace = formatPace(recordPaceInt);

          print(recordTime);

          return Container(
            decoration: BoxDecoration(
              color: Color(0xffF6F4E9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(1, 2),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
                padding: const EdgeInsets.all(30),
                child: GridView(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.7,
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('총 운동거리',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: GRAY_900)),
                        SizedBox(height: 10),
                        Text('$formattedChangeDist km',
                            style: TextStyle(
                              color: GREEN_COLOR,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('총 소요시간',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: GRAY_900)),
                        SizedBox(height: 10),
                        Text(formattedTime,
                            style: TextStyle(
                              color: GREEN_COLOR,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('평균 페이스',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: GRAY_900)),
                        SizedBox(height: 10),
                        Text(formattedPace,
                            style: TextStyle(
                              color: GREEN_COLOR,
                              fontSize: formattedPace.length > 8 ? 22 : 30,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('평균 심박수',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: GRAY_900)),
                        SizedBox(height: 10),
                        Text('$recordHeartbeat',
                            style: TextStyle(
                              color: GREEN_COLOR,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    ),
                  ],
                )),
          );
        } else {
          return Center(child: Text('데이터가 없습니다.'));
        }
      },
    );
  }
}
