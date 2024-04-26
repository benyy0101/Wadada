import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wadada/models/mypage.dart';
import 'package:wadada/repository/mypageRepo.dart';

class MypageController extends GetxController {
  final MypageRepository mypageRepository;
  final Rx<MonthlyRecord> _records =
      Rx<MonthlyRecord>(MonthlyRecord(monthlyRecord: []));
  // Rx 타입으로 변경
  final Rx<SingleDetail> _singleDetail = Rx<SingleDetail>(SingleDetail(
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
      recordMeanHeartbeat: -1));
  final Rx<MultiDetail> _multiDetail = Rx<MultiDetail>(MultiDetail(
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
      recordMeanHeartbeat: -1));
  final Rx<MarathonDetail> _marathonDetail = Rx<MarathonDetail>(MarathonDetail(
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
      recordMeanHeartbeat: -1));

  MypageController({
    required this.mypageRepository,
  });

  @override
  void onInit() {
    super.onInit();
    fetchMonthlyRecords();
  }

  //mypage001
  void fetchMonthlyRecords() async {
    try {
      _records.value = await mypageRepository.getMonthlyRecord(DateTime.now());
    } catch (e) {
      print(e);
    }
  }

  //mypage002
  void fetchSingleDetail(RecordRequest req) async {
    try {
      _singleDetail.value = await mypageRepository.getSingleDetail(req);
    } catch (e) {
      print(e);
    }
  }

  //mypage003
  void fetchMultiDetail(RecordRequest req) async {
    try {
      _multiDetail.value = await mypageRepository.getMultiDetail(req);
    } catch (e) {
      print(e);
    }
  }

  //mypage004
  void fetchMarathonDetail(RecordRequest req) async {
    try {
      _marathonDetail.value = await mypageRepository.getMarathonDetail(req);
    } catch (e) {
      print(e);
    }
  }
}
