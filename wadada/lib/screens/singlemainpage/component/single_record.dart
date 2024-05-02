import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class SingleRecord extends StatefulWidget {
  const SingleRecord({super.key});

  @override
  _SingleRecordState createState() => _SingleRecordState();
}

class _SingleRecordState extends State<SingleRecord>{
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
  }

  Future<Map<String, dynamic>> fetchData() async {
    final url = Uri.parse('https://k10a704.p.ssafy.io/Single');

    final dio = Dio();

    try {
      final response = await dio.get(
        url.toString(),
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDUyNzIxNzM3IiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE0NjgxNTkwfQ.zvrnuEckvfBuhc7kjMDf6HYHTt8RpJIUOifcc6o1Fk8',
        }),
      );

      if (response.statusCode == 200) {
            // 성공적으로 응답을 받았을 때
            final data = response.data as Map<String, dynamic>;
            print('통신 성공');
            return data;
        } else if (response.statusCode == 204) {
            // 204 상태 코드 (No Content)
            print('204');
            return {};
        } else {
            print('서버 요청 실패: ${response.statusCode}');
            return {};
      }
    } catch (e) {
      print('요청 처리 중 에러 발생: $e');
      return {};
    }
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
            width: 400,
            child: Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Center(
                child: Text('최근 기록이 없습니다.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )
                )
              ),
            )
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          final recordTime = data['recordTime'];
          final recordDist = data['recordDist'];
          final recordSpeed = data['recordSpeed'];
          final recordPace = data['recordPace'];
          final recordHeartbeat = data['recordHeartbeat'];

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
            width: 400,
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 30, bottom: 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('총 운동거리',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            SizedBox(height: 10),
                            Text('$recordDist km',
                              style: TextStyle(
                                color: GREEN_COLOR,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              )
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('총 소요시간',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            SizedBox(height: 10),
                            Text('$recordTime',
                              style: TextStyle(
                                color: GREEN_COLOR,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('평균 페이스',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            SizedBox(height: 10),
                            Text('$recordPace km/h',
                              style: TextStyle(
                                color: GREEN_COLOR,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              )
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('평균 심박수',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            SizedBox(height: 10),
                            Text('$recordHeartbeat',
                              style: TextStyle(
                                color: GREEN_COLOR,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
            return Center(child: Text('데이터가 없습니다.'));
          }
      },
    );
  }
}