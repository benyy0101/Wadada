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
      recordStartLocation: Point(-1, -1),
      recordEndLocation: Point(-1, -1),
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
      recordStartLocation: Point(-1, -1),
      recordEndLocation: Point(-1, -1),
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
      recordStartLocation: Point(-1, -1),
      recordEndLocation: Point(-1, -1),
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
      singleDetail = await mypageRepository.getSingleDetail(req);
    } catch (e) {
      print(e);
    }
  }

  //mypage003
  void fetchMultiDetail(RecordRequest req) async {
    try {
      multiDetail = await mypageRepository.getMultiDetail(req);
    } catch (e) {
      print(e);
    }
  }

  //mypage004
  void fetchMarathonDetail(RecordRequest req) async {
    try {
      marathonDetail = await mypageRepository.getMarathonDetail(req);
    } catch (e) {
      print(e);
    }
  }
}
