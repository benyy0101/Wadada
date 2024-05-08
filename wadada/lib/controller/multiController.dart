import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/models/mypage.dart';
import 'package:wadada/repository/multiRepo.dart';

class MultiController extends GetxController {
  final MultiRepository repo;

  RoomInfo info = RoomInfo(
      roomIdx: -1,
      roomPeople: -1,
      roomDist: -1,
      roomMode: -1,
      roomSecret: -2,
      roomTag: '',
      roomTime: -1,
      roomTitle: '');

  List<SimpleRoom> roomList = [];
  int recordSeq = -1;

  MultiRoomGameEnd gameEndInfo = MultiRoomGameEnd(
      roomIdx: -1,
      recordStartLocation: 'POINT(-1 -1)',
      recordMode: '',
      recordImage: '',
      recordDist: -1,
      recordTime: Duration.zero,
      recordEndLocation: 'Point(-1 -1)',
      recordWay: '',
      recordSpeed: '',
      recordHeartbeat: '',
      recordPace: '',
      recordRank: -1);

  MultiController({required this.repo});

  void creatMultiRoom(MultiRoom roomInfo) async {
    try {
      info = await repo.createRoom(roomInfo);
      update();
    } catch (e) {
      print("방이 생성되지 않았습니다. 다시 시도해 주세요");
      print(e);
      rethrow;
    }
  }

  void getMultiRoomsByMode(int mode) async {
    try {
      roomList = await repo.multiRoomGet(mode);
      update();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  void sendStartLocation(
      String lat, String long, int roomIdx, int people) async {
    try {
      recordSeq = await repo.sendStartLocation(lat, long, roomIdx, people);
      update();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //컨트롤러 gameEndInfo 변수를 보내기만 하는 함수
  void endGame() async {
    try {
      int result = await repo.endGame(gameEndInfo);
      if (result.runtimeType != int && result == recordSeq) {
        throw Exception("recordSeq가 일치하지 않습니다.");
      }
    } catch (e) {
      print(e);
    }
  }
}
