import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/marathonController.dart';
import 'package:wadada/models/marathon.dart';
import 'package:wadada/screens/marathoninfopage/marathoninfopage.dart';
import 'package:wadada/screens/marathonmainpage/component/marathoncard.dart';
import 'package:wadada/screens/singleoptionpage/single_free_option.dart';
import 'package:wadada/common/component/logout.dart';
import 'package:wadada/screens/singlemainpage/component/select_mode.dart';
import 'package:wadada/screens/singlemainpage/component/single_record.dart';
import 'package:dio/dio.dart';

class MarathonMain extends StatefulWidget {
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
    MarathonController controller = Get.put(MarathonController());
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: '마라톤'
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Obx(
              () {
                if (controller.marathonList.value.length == 0) {
                  controller.fetchList();
                  return const Text(
                    '진행 예정인 마라톤이 없습니다.',
                    style: TextStyle(
                      color: GRAY_400,
                      fontSize: 19,
                    ),
                  );
                }
                return Column(children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '진행 예정인 마라톤',
                          style: TextStyle(
                            color: GRAY_400,
                            fontSize: 19,
                          ),
                        ),
                        SizedBox(height: 20),
                        ...controller.marathonList.value
                            .where((marathon) => marathon.isDeleted == false)
                            .map((marathon) {
                          // coming 배열에 있는 카드를 클릭할 때 이동할 페이지
                          void handleTap(SimpleMarathon marathon, bool isPast) {
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
                                onTap: () =>
                                    handleTap(marathon, false), // 클릭 이벤트
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
                        Text(
                          '지난 마라톤',
                          style: TextStyle(
                            color: GRAY_400,
                            fontSize: 19,
                          ),
                        ),
                        SizedBox(height: 20),
                        ...controller.marathonList.value
                            .where((marathon) => marathon.isDeleted == true)
                            .map((marathon) {
                          // coming 배열에 있는 카드를 클릭할 때 이동할 페이지

                          return Column(
                            children: [
                              MarathonCard(
                                marathon: marathon,
                                isPast: true,
                              ),
                              SizedBox(height: 25),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ]);
              },
            )
          ],
        ),
      ),
    );
  }
}
