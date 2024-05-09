import 'dart:io';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wadada/models/mypage.dart';
import 'package:wadada/repository/mypageRepo.dart';

class MypageController extends GetxController {
  final MypageRepository mypageRepository;
  MonthlyRecord records = MonthlyRecord(monthlyRecord: []);
  // Rx 타입으로 변경
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
      records = await mypageRepository.getMonthlyRecord(DateTime.now());
    } catch (e) {
      print(e);
    }
  }

  //mypage002
  void fetchSingleDetail(RecordRequest req) async {
    try {
      singleDetail = await mypageRepository.getSingleDetail(req.recordSeq);
    } catch (e) {
      print(e);
    }
  }

  //mypage003
  void fetchMultiDetail(RecordRequest req) async {
    try {
      multiDetail = await mypageRepository.getMultiDetail(req.recordSeq);
    } catch (e) {
      print(e);
    }
  }

  //mypage004
  void fetchMarathonDetail(String req) async {
    try {
      marathonDetail = await mypageRepository.getMarathonDetail(req.hashCode);
    } catch (e) {
      print(e);
    }
  }

  fetchDetail(RecordRequest req) async {
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

  void uploadImage(File file) async {
    try {
      String temp = await mypageRepository.uploadImage(file);
      print(temp);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
