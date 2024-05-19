import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/models/marathon.dart';
import 'package:wadada/screens/marathoninfopage/component/infodetail.dart';
import 'package:wadada/screens/marathoninfopage/component/people.dart';
import 'package:wadada/screens/singleoptionpage/single_free_option.dart';
import 'package:wadada/common/component/logout.dart';
import 'package:wadada/screens/singlemainpage/component/select_mode.dart';
import 'package:wadada/screens/singlemainpage/component/single_record.dart';
import 'package:dio/dio.dart';

class MarathonInfo extends StatefulWidget {
  final SimpleMarathon marathon;
  final bool isPast;

  const MarathonInfo({super.key, required this.marathon, required this.isPast});

  @override
  _MultiInfoState createState() => _MultiInfoState();
}

class _MultiInfoState extends State<MarathonInfo> {
  int currentTab = 0;

  void _toggleButton(int index) {
    setState(() {
      currentTab = index;
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
    final isPast = widget.isPast;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          title: Text(
            '마라톤',
            style: TextStyle(
              color: GRAY_900,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: OATMEAL_COLOR,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ToggleButtons(
                  isSelected: [currentTab == 0, currentTab == 1],
                  onPressed: _toggleButton,
                  fillColor: OATMEAL_COLOR,
                  borderColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  borderWidth: 0,
                  children: [
                    Container(
                      width: 150,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                      decoration: currentTab == 0
                          ? BoxDecoration(
                              color: GREEN_COLOR,
                              borderRadius: BorderRadius.circular(8),
                            )
                          : null,
                      child: Text(
                        '정보',
                        style: TextStyle(
                          color: currentTab == 0 ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 150,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                      decoration: currentTab == 1
                          ? BoxDecoration(
                              color: GREEN_COLOR,
                              borderRadius: BorderRadius.circular(8),
                            )
                          : null,
                      child: Text(
                        isPast ? '랭킹' : '참가자',
                        style: TextStyle(
                          color: currentTab == 1 ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 50),
          child: Column(
            children: [
              if (currentTab == 0)
                InfoDetail(
                  marathon: widget.marathon,
                  isPast: isPast,
                ),
              if (currentTab == 1)
                People(
                  marathon: widget.marathon,
                  isPast: isPast,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
