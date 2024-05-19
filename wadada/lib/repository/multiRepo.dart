import 'package:wadada/models/multiroom.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:dio/src/response.dart';
import 'package:wadada/models/mypage.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:dio/src/response.dart';

abstract class AbstractMultiRepository {
  Future<RoomInfo> createRoom(MultiRoom roomInfo);
}

class MultiRepository extends AbstractMultiRepository {
  final MultiProvider provider;

  MultiRepository({
    required this.provider,
  });

  //MULTI-001
  Future<List<SimpleRoom>> multiRoomGet(int mode) async {
    try {
      Response res = await provider.multiRoomGet(mode.toString());
      List<SimpleRoom> resSerialized = [];
      res.data.forEach((item) {
        resSerialized.add(SimpleRoom.fromJson(item));
      });
      return resSerialized;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //MULTI-002
  Future<List<SimpleRoom>> multiRoomSearch(String concatTags) async {
    try {
      Response res = await provider.multiRoomSearch(concatTags);
      List<SimpleRoom> list = [];
      res.data.forEach((item) {
        list.add(SimpleRoom.fromJson(item));
      });
      return list;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //MULTI-003
  @override
  Future<RoomInfo> createRoom(MultiRoom roomInfo) async {
    try {
      Response res = await provider.multiRoomCreate(roomInfo);
      int roomIdx = res.data['roomIdx'];
      // int roomSeq = res.data['roomSeq'];
      RoomInfo info = RoomInfo(
        roomIdx: roomIdx,
        roomSeq: roomInfo.roomSeq,
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

  //MULTI-006
  Future<int> sendStartLocation(
      double lat, double long, int roomIdx, int people) async {
    MultiRoomGameStart start = MultiRoomGameStart(
        roomIdx: roomIdx,
        recordStartLocation: 'POINT($lat $long)',
        recordPeople: people);
    try {
      print("--------------------");
      print(start);
      Response res = await provider.multiRoomGameStart(start);
      return res.data;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //MULTI-007
  Future<int> endGame(MultiRoomGameEnd data) async {
    // MultiRoomGameEnd start = MultiRoomGameEnd(
    //     roomIdx: ,
    //     recordStartLocation: point,
    //     recordMode: '',
    //     recordImage: '',
    //     recordDist: null,
    //     recordTime: null,
    //     recordEndLocation: null,
    //     recordWay: '',
    //     recordSpeed: '',
    //     recordHeartbeat: '',
    //     recordPace: '',
    //     recordRank: null);
    try {
      Response res = await provider.multiRoomGameEnd(data);
      return res.data;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
