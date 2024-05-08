import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/multiController.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:wadada/repository/multiRepo.dart';
import 'package:wadada/screens/multimainpage/multi_distance/multi_waitingpage/options/multi_select_dist_option.dart';
import 'package:wadada/screens/singleoptionpage/component/select_dist_option.dart';

class MultiTimeRoomForm extends StatefulWidget {
  const MultiTimeRoomForm({super.key});

  @override
  MultiTimeRoomFormState createState() => MultiTimeRoomFormState();
}

class MultiTimeRoomFormState extends State<MultiTimeRoomForm> {
  SelectDistOptionState? distOptionState;
  // 각 입력 필드를 위한 TextEditingController 인스턴스 생성
  final participantController = TextEditingController();
  final passwordController = TextEditingController();
  final hashTagController = TextEditingController();

  @override
  void dispose() {
    // 컨트롤러를 dispose하여 리소스 누수를 방지합니다.
    participantController.dispose();
    passwordController.dispose();
    hashTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(MultiController(repo: MultiRepository(provider: MultiProvider())));
    return GetBuilder<MultiController>(builder: (MultiController controller) {
      MultiRoom test = MultiRoom(
          roomPeople: 3,
          roomDist: 2,
          roomMode: 1,
          roomSecret: 1111,
          roomTag: '#싸피',
          roomTime: 3,
          roomTitle: 'test');
      return Scaffold(
        appBar: AppBar(
          title: const Text('시간모드 - 멀티',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          // 여기에 SingleChildScrollView 추가
          child: Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      MultiSelectDistOption(
                        option_dis: '거리',
                        optionstr_dis: '(km)',
                        option_people: '참여 인원',
                        optionstr_people: '(명)',
                        option_password: '비밀 번호',
                        option_hash: '해시태그',
                        // onStatedistUpdated: (state) {
                        //   setState(() {
                        //     distOptionState = state as SelectDistOptionState?;
                        //   });
                        // },
                        // onStatepeopleUpdated: (state) {
                        //   setState(() {
                        //     distOptionState = state as SelectDistOptionState?;
                        //   });
                        // },
                        // onStatepasswordUpdated: (state) {
                        //   setState(() {
                        //     distOptionState = state as SelectDistOptionState?;
                        //   });
                        // },
                        // onStatehashtagUpdated: (state) {
                        //   setState(() {
                        //     distOptionState = state as SelectDistOptionState?;
                        //   });
                        // },
                      )
                    ],
                  ),
                ),
                SizedBox(height: 50),

                // 취소 / 생성하기 버튼
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xffADB5BD),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              child: Text('취소',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ))),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // 방 생성 로직
                          try {
                            controller.creatMultiRoom(test);
                          } catch (error) {
                            print('로그아웃 실패: $error');
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff5BC879),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              child: Text('생성하기',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ))),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
