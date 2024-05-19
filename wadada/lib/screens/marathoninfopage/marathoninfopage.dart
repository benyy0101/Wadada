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
      body: Container(
        child: SizedBox(
          height: MediaQuery.of(context).size.height -
              kToolbarHeight, // 앱바 높이를 제외한 전체 높이로 설정
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentTab == 0)
                    // Expanded(
                    //   child: InfoDetail(
                    //     marathon: widget.marathon,
                    //     isPast: isPast,
                    //   ),
                    // ),
                    InfoDetail(
                      marathon: widget.marathon,
                      isPast: isPast,
                    ),
                  if (currentTab == 1)
                    Expanded(
                      child: People(
                        marathon: widget.marathon,
                        isPast: isPast,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
