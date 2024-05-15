import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/screens/marathoninfopage/marathoninfopage.dart';
import 'package:wadada/screens/marathonmainpage/component/marathoncard.dart';
import 'package:wadada/screens/singleoptionpage/single_free_option.dart';
import 'package:wadada/common/component/logout.dart';
import 'package:wadada/screens/singlemainpage/component/select_mode.dart';
import 'package:wadada/screens/singlemainpage/component/single_record.dart';
import 'package:dio/dio.dart';

class MarathonMain extends StatefulWidget{
  const MarathonMain({super.key});

  @override
  _MarathonMainState createState() => _MarathonMainState();
}

class _MarathonMainState extends State<MarathonMain> {
  List<Map<String, dynamic>> coming = [];
  List<Map<String, dynamic>> past = [];

  @override
  void initState() {
    super.initState();
    tempData();
  }

  void tempData() {
    List<Map<String, dynamic>> marathons = [
      {
        'date': '2024-05-11',
        'startTime': '10:00',
        'endTime': '15:00',
        'distance': 5,
        'participants': 100,
        'image': 'https://github.com/jjeong41/t/assets/103355863/e3eb9518-0f43-4577-ab50-bbfbe6fbe4fa',
        'type': 'upcoming',
      },
      {
        'date': '2024-05-05',
        'startTime': '15:00',
        'endTime': '18:00',
        'distance': 10,
        'participants': 200,
        'image': 'https://github.com/jjeong41/t/assets/103355863/7ba67d84-a297-44c8-9999-d45a34b4f785',
        'type': 'past',
      },
      {
        'date': '2024-05-03',
        'startTime': '08:00',
        'endTime': '11:00',
        'distance': 3,
        'participants': 50,
        'image': 'https://github.com/jjeong41/t/assets/103355863/7ba67d84-a297-44c8-9999-d45a34b4f785',
        'type': 'past',
      },
    ];

    // 현재 날짜
    DateTime currentDateTime = DateTime.now();

    setState(() {
      coming = marathons.where((marathon) {
        DateTime startDateTime = DateTime.parse('${marathon['date']}T${marathon['startTime']}');
        DateTime endDateTime = DateTime.parse('${marathon['date']}T${marathon['endTime']}');

        int daysLeft = startDateTime.difference(currentDateTime).inDays;
        marathon['daysLeft'] = daysLeft;

        return startDateTime.isAfter(currentDateTime) || 
          (currentDateTime.isAfter(startDateTime) && currentDateTime.isBefore(endDateTime)) &&
          marathon['type'] == 'coming';
      }).toList();
        
      past = marathons.where((marathon) {
        DateTime startDateTime = DateTime.parse('${marathon['date']}T${marathon['startTime']}');
        DateTime endDateTime = DateTime.parse('${marathon['date']}T${marathon['endTime']}');
        
        return endDateTime.isBefore(currentDateTime) && marathon['type'] == 'past';
      }).toList();
    });
  }

  // Future<Map<String, dynamic>> fetchData() async {
  //   final url = Uri.parse('https://k10a704.p.ssafy.io/Marathon');

  //   final dio = Dio();

  //   try {
  //     final response = await dio.get(
  //       url.toString(),
  //       options: Options(headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDUyNzIxNzM3IiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE0NjgxNTkwfQ.zvrnuEckvfBuhc7kjMDf6HYHTt8RpJIUOifcc6o1Fk8',
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //           // 성공적으로 응답을 받았을 때
  //           final data = response.data as Map<String, dynamic>;
  //           print('통신 성공');
  //           return data;
  //       } else if (response.statusCode == 204) {
  //           // 204 상태 코드 (No Content)
  //           print('204');
  //           return {};
  //       } else {
  //           print('서버 요청 실패: ${response.statusCode}');
  //           return {};
  //     }
  //   } catch (e) {
  //     print('요청 처리 중 에러 발생: $e');
  //     return {};
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   title: '마라톤'
        // ),
        body: 
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 30, right: 30),
            child:Column(
              children: [
                SizedBox(
                  height: 45,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Column(children: [
                      Text('마라톤',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                    ],
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                if (coming.isEmpty)
                  const Text(
                    '진행 예정인 마라톤이 없습니다.',
                    style: TextStyle(
                      color: GRAY_400,
                      fontSize: 19,
                    ),
                  )
                else
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('진행 예정인 마라톤',
                          style: TextStyle(
                            color: GRAY_400,
                            fontSize: 19,
                          ),
                        ), 
                        SizedBox(height: 20),
                        ...coming.map((marathon) {
                          // coming 배열에 있는 카드를 클릭할 때 이동할 페이지
                          void handleTap(Map<String, dynamic> marathon, bool isPast) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MarathonInfo(
                                  marathon: marathon,
                                  isPast: isPast,
                              ),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              MarathonCard(
                                marathon: marathon,
                                isPast: false,
                                onTap: () => handleTap(marathon, false), // 클릭 이벤트
                              ),
                              SizedBox(height: 15),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                SizedBox(height: 30),
                Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('지난 마라톤',
                          style: TextStyle(
                            color: GRAY_400,
                            fontSize: 19,
                          ),
                        ), 
                        SizedBox(height: 20),
                        ...past.map((marathon) {
                          // coming 배열에 있는 카드를 클릭할 때 이동할 페이지
                          void handleTap(Map<String, dynamic> marathon, bool isPast) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MarathonInfo(
                                  marathon: marathon,
                                  isPast: isPast,
                              ),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              MarathonCard(
                                marathon: marathon,
                                isPast: true,
                                onTap: () => handleTap(marathon, true), // 클릭 이벤트
                              ),
                              SizedBox(height: 25),
                            ],
                          );
                        }),
                      ],
                      ),
                    ),
              ],
          ),
        ),
      );
  }
}
