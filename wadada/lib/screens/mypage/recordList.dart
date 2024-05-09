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

  @override
  Widget build(BuildContext context) {
    Get.put(MypageController(
        mypageRepository: MypageRepository(mypageAPI: MypageAPI())));
    return GetBuilder<MypageController>(
      builder: (MypageController controller) {
        controller.fetchMonthlyRecords();
        final Map<String, List<SimpleRecord>> groupedRecords = {};

        controller.records.monthlyRecord.forEach((record) {
          final formattedDate =
              DateFormat('yyyy-MM-dd').format(record.recordCreatedAt);
          if (!groupedRecords.containsKey(formattedDate)) {
            groupedRecords[formattedDate] = [record];
          } else {
            groupedRecords[formattedDate]!.add(record);
          }
        });

        final sortedKeys = groupedRecords.keys.toList()
          ..sort((a, b) => a.compareTo(b));

        return Container(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: ListView(
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
                        RecordCard(records: groupedRecords[key]!)
                      ],
                    )))
                .toList(),
          ),
        );
      },
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
            title: Text(simple.recordType),
            subtitle: Row(
              children: [
                Text(typeConverter(simple.recordType)),
                SizedBox(
                  width: 20.0,
                ),
                Text(simple.recordDist.toString() + " km"),
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
              icon: const Icon(Icons.arrow_forward_ios_rounded),
            ));
      }).toList(),
    );
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
