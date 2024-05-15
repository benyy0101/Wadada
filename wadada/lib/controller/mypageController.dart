import 'dart:io';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:wadada/models/mypage.dart';
import 'package:wadada/repository/mypageRepo.dart';

class MypageController extends GetxController {
  final MypageRepository mypageRepository;
  RxBool isLoading = true.obs;
  Rx<MonthlyRecord> records = MonthlyRecord(monthlyRecord: []).obs;
  RxMap<String, List<SimpleRecord>> groupedRecords =
      <String, List<SimpleRecord>>{}.obs;
  SingleDetail singleDetail = SingleDetail(
      recordType: '',
      recordRank: -1,
      recordImage: '',
      recordDist: -1,
      recordTime: Duration.zero,
      recordStartLocation: '',
      recordEndLocation: '',
      recordSpeed: [],
      recordHeartbeat: [],
      recordPace: [],
      recordCreatedAt: DateTime.now(),
      recordMeanSpeed: -1,
      recordMeanPace: -1,
      recordMeanHeartbeat: -1);
  MultiDetail multiDetail = MultiDetail(
      rankings: [],
      recordType: '',
      recordRank: -1,
      recordImage: '',
      recordDist: -1,
      recordTime: Duration.zero,
      recordStartLocation: '',
      recordEndLocation: '',
      recordSpeed: [],
      recordHeartbeat: [],
      recordPace: [],
      recordCreatedAt: DateTime.now(),
      recordMeanSpeed: -1,
      recordMeanPace: -1,
      recordMeanHeartbeat: -1);
  MarathonDetail marathonDetail = MarathonDetail(
      rankings: [],
      recordType: '',
      recordRank: -1,
      recordImage: '',
      recordDist: -1,
      recordTime: Duration.zero,
      recordStartLocation: '',
      recordEndLocation: '',
      recordSpeed: [],
      recordHeartbeat: [],
      recordPace: [],
      recordCreatedAt: DateTime.now(),
      recordMeanSpeed: -1,
      recordMeanPace: -1,
      recordMeanHeartbeat: -1);

  MypageController({
    required this.mypageRepository,
  });

  //mypage001
  void fetchMonthlyRecords() async {
    try {
      records.value = await mypageRepository.getMonthlyRecord(DateTime.now());
      records.value.monthlyRecord.forEach((record) {
        final formattedDate =
            DateFormat('yyyy-MM-dd').format(record.recordCreatedAt);
        if (!groupedRecords.containsKey(formattedDate)) {
          groupedRecords[formattedDate] = [record];
        } else {
          bool flag = false;
          groupedRecords[formattedDate]!.forEach((item) {
            if (item.recordSeq == record.recordSeq) flag = true;
          });
          if (flag == false) groupedRecords[formattedDate]!.add(record);
        }
      });
      isLoading.value = false;
      print(isLoading);
      // print(groupedRecords.value);
    } catch (e) {
      print(e);
    }
  }

  //mypage002
  void fetchSingleDetail(RecordRequest req) async {
    try {
      singleDetail = await mypageRepository.getSingleDetail(req.recordSeq);
      print("repo");
    } catch (e) {
      print(e);
    }
  }

  //mypage003
  void fetchMultiDetail(RecordRequest req) async {
    try {
      isLoading = true.obs;
      multiDetail = await mypageRepository.getMultiDetail(req.recordSeq);
      isLoading = false.obs;
    } catch (e) {
      print(e);
    }
  }

  //mypage004
  void fetchMarathonDetail(RecordRequest req) async {
    try {
      marathonDetail = await mypageRepository.getMarathonDetail(req.recordSeq);
    } catch (e) {
      print(e);
    }
  }

  fetchDetail(RecordRequest req) async {
    print("recordtype");
    print(req);
    try {
      if (req.recordType == '1') {
        singleDetail = await mypageRepository.getSingleDetail(req.recordSeq);
      } else if (req.recordType == '2') {
        multiDetail = await mypageRepository.getMultiDetail(req.recordSeq);
      } else {
        marathonDetail =
            await mypageRepository.getMarathonDetail(req.recordSeq);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  void uploadImage(String path) async {
    try {
      String temp = await mypageRepository.uploadImage(path);
      print(temp);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
