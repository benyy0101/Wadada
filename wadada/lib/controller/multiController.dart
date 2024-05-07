import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wadada/models/multiroom.dart';
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
}
