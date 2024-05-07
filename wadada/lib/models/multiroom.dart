import 'package:wadada/models/mypage.dart';
import 'package:wadada/util/serializable.dart';

class MultiRoom {
  final int roomPeople;
  final int roomDist;
  final int roomMode;
  final int? roomSecret;
  final String roomTag;
  final int roomTime;
  final String roomTitle;

  MultiRoom(
      {required this.roomPeople,
      required this.roomDist,
      required this.roomMode,
      this.roomSecret,
      required this.roomTag,
      required this.roomTime,
      required this.roomTitle});

  // Deserialize JSON to MultiRoom object
  factory MultiRoom.fromJson(Map<String, dynamic> json) {
    return MultiRoom(
      roomPeople: json['roomPeople'] as int,
      roomDist: json['roomDist'] as int,
      roomMode: json['roomMode'] as int,
      roomSecret: json['roomSecret'] as int,
      roomTag: json['roomTag'] as String,
      roomTime: json['roomTime'] as int,
      roomTitle: json['roomTitle'] as String,
    );
  }

  // Serialize MultiRoom object to JSON
  Map<String, dynamic> toJson() {
    return {
      'roomPeople': roomPeople,
      'roomDist': roomDist,
      'roomMode': roomMode,
      'roomSecret': roomSecret,
      'roomTag': roomTag,
      'roomTime': roomTime,
      'roomTitle': roomTitle,
    };
  }
}

class RoomInfo extends MultiRoom {
  final int roomIdx;

  RoomInfo(
      {required this.roomIdx,
      required super.roomPeople,
      required super.roomDist,
      required super.roomMode,
      required super.roomSecret,
      required super.roomTag,
      required super.roomTime,
      required super.roomTitle});
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

class MemberInGame {
  final String memberNickname;
  final String memberId;
  final String memberGender;
  final String memberProfileImage;
  final int memberLevel;
  final bool memberReady;
  final bool manager;

  MemberInGame(
      {required this.memberNickname,
      required this.memberId,
      required this.memberGender,
      required this.memberProfileImage,
      required this.memberLevel,
      required this.memberReady,
      required this.manager});
}
