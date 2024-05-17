import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wadada/models/marathon.dart';
import 'package:wadada/models/profile.dart';
import 'package:wadada/provider/mypageProvider.dart';
import 'package:wadada/repository/marathonRepo.dart';

class MarathonController extends GetxController {
  final MarathonRepository repo = MarathonRepository();
  final storage = FlutterSecureStorage();
  RxList<SimpleMarathon> marathonList = <SimpleMarathon>[].obs;
  RxList<MarathonParticipant> participantList = <MarathonParticipant>[].obs;
  RxBool isAttend = false.obs;
  RxBool isStart = false.obs;
  RxInt marathonRecordSeq = 0.obs;

  Rx<MyMarathonRecord> marathonRecord = MyMarathonRecord(
          memberName: '', memberImage: '', memberDist: -1, memberTime: -1)
      .obs;

  Rx<Marathon> marathon = Marathon(
    marathonSeq: 0,
    marathonRecordRank: 0,
    marathonRecordStart: '',
    marathonRecordWay: '',
    marathonRecordEnd: '',
    marathonRecordDist: 0,
    marathonRecordTime: 0,
    marathonRecordImage: '',
    marathonRecordPace: '',
    marathonRecordMeanPace: 0,
    marathonRecordSpeed: '',
    marathonRecordMeanSpeed: 0,
    marathonRecordHeartbeat: '',
    marathonRecordMeanHeartbeat: 0,
    marathonRecordIsWin: false,
  ).obs;

  void fetchList() async {
    print("---------------fetchList------------");
    marathonList.value = await repo.getMarathonList();
  }

  Future<int> attendMarathon(String marathonSeq) async {
    return await repo.attendMarathon(marathonSeq);
  }

  void endMarathon() async {
    await repo.endMarathon(marathon.value);
  }

  void getAttendant(String marathonSeq) async {
    participantList.value = await repo.getParticipant(marathonSeq);
  }

  void getRank(String marathonSeq) async {
    marathonRecord.value = await repo.getRank(marathonSeq);
  }

  Future<void> startMarathon(String lat, String long) async {
    String point = "POINT(${lat} ${long})";
    int dead = 125;
    marathonRecordSeq.value = await repo.startMarathon(
        MarathonStart(marathonRecordStart: point, marathonSeq: dead));
  }
}
