import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/mypageController.dart';
import 'package:wadada/models/mypage.dart';
import 'package:wadada/provider/mypageProvider.dart';
import 'package:wadada/repository/mypageRepo.dart';
import 'package:wadada/screens/mypage/myRecords.dart';

class RecordList extends StatelessWidget {
  RecordList({super.key});

  MypageController controller = Get.put(MypageController(
      mypageRepository: MypageRepository(mypageAPI: MypageAPI())));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Obx(
        () {
          controller.fetchMonthlyRecords();
          if (controller.isLoading.value) {
            // Display spinner while data is being fetched
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // Data has been fetched, display the list
            print("WHY");
            final sortedKeys = controller.groupedRecords.value.keys.toList()
              ..sort((a, b) => a.compareTo(b));
            return ListView(
              shrinkWrap: true,
              children: sortedKeys
                  .map((key) => Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              key.toString(),
                              style: TextStyle(color: GRAY_400),
                            ),
                            SizedBox(height: 10.0),
                            RecordCard(
                                records: controller.groupedRecords.value[key]!)
                          ],
                        ),
                      ))
                  .toList(),
            );
          }
        },
      ),
    );
  }
}

class RecordCard extends StatelessWidget {
  const RecordCard({super.key, required this.records});
  final List<SimpleRecord> records;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: OATMEAL_COLOR,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 0,
              blurRadius: 5.0,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ListTileWidget(records: records));
  }
}

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({super.key, required this.records});
  final List<SimpleRecord> records;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: records.map<Widget>((simple) {
        return ListTile(
            title: Text(modeConverter(simple.recordType)),
            contentPadding: EdgeInsets.all(10),
            titleTextStyle: TextStyle(fontSize: 20, color: DARK_GREEN_COLOR),
            subtitleTextStyle: TextStyle(fontSize: 14, color: GRAY_400),
            subtitle: Row(
              children: [
                Text(typeConverter(simple.recordType)),
                SizedBox(
                  width: 20.0,
                ),
                Text("${simple.recordDist} km"),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                Get.to(MyRecords(
                  recordSeq: simple.recordSeq,
                  recordType: simple.recordType,
                ));
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => MyRecords(
                //               recordSeq: simple.recordSeq,
                //               recordType: simple.recordType,
                //             )));
              },
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: GRAY_500,
              ),
            ));
      }).toList(),
    );
  }
}

String modeConverter(String target) {
  if (target == '1') {
    return '거리모드';
  } else if (target == '2') {
    return '시간모드';
  } else {
    return '마라톤';
  }
}

String typeConverter(String target) {
  if (target == '1') {
    return '싱글';
  } else if (target == '2') {
    return '멀티';
  } else {
    return '마라톤';
  }
}
