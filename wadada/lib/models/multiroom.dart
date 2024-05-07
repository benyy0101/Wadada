import 'package:wadada/models/mypage.dart';
import 'package:wadada/util/serializable.dart';

class MultiRoom {
  final int roomPeople;
  final int roomDist;
  final int roomMode;
  final int roomSecret;
  final String roomTag;
  final int roomTime;
  final String roomTitle;

  MultiRoom(
      {required this.roomPeople,
      required this.roomDist,
      required this.roomMode,
      required this.roomSecret,
      required this.roomTag,
      required this.roomTime,
      required this.roomTitle});
}

class MultiRoomAttend implements Serializable {
  final String memberNickname;
  final String memberGender; //F/M
  final String memberProfileImage;
  final int memberLevel;
  final String memberId;

  MultiRoomAttend(
      {required this.memberNickname,
      required this.memberGender,
      required this.memberProfileImage,
      required this.memberLevel,
      required this.memberId});

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

class MultiRoomGameStart {
  final String recordMode;
  final Point recordStartLocation;
  final int recordPeople;

  MultiRoomGameStart(
      {required this.recordMode,
      required this.recordStartLocation,
      required this.recordPeople});
}

class MultiRoomGameEnd {
  final String recordMode;
  final String recordImage;
  final double recordDist;
  final Duration recordTime;
  final Point recordStartLocation;
  final Point recordEndLocation;
  final String recordWay; //json
  final String recordSpeed; // json
  final String recordHeartbeat; //json
  final String recordPace; //json
  final int recordRank;

  MultiRoomGameEnd(
      {required this.recordMode,
      required this.recordImage,
      required this.recordDist,
      required this.recordTime,
      required this.recordStartLocation,
      required this.recordEndLocation,
      required this.recordWay,
      required this.recordSpeed,
      required this.recordHeartbeat,
      required this.recordPace,
      required this.recordRank});
}
