import 'package:wadada/models/multiroom.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:dio/src/response.dart';
import 'package:wadada/screens/multimainpage/component/room.dart';

abstract class AbstractMultiRepository {
  Future<RoomInfo> createRoom(MultiRoom roomInfo);
}

class MultiRepository extends AbstractMultiRepository {
  final MultiProvider provider;

  MultiRepository({
    required this.provider,
  });

  @override
  Future<RoomInfo> createRoom(MultiRoom roomInfo) async {
    try {
      Response res = await provider.multiRoomCreate(roomInfo);
      int roomIdx = int.parse(res.data.keys.first);
      RoomInfo info = RoomInfo(
        roomIdx: roomIdx,
        roomPeople: roomInfo.roomPeople,
        roomDist: roomInfo.roomDist,
        roomMode: roomInfo.roomMode,
        roomSecret: roomInfo.roomSecret,
        roomTag: roomInfo.roomTag,
        roomTime: roomInfo.roomTime,
        roomTitle: roomInfo.roomTitle,
      );
      return info;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
