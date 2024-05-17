import 'package:wadada/util/serializable.dart';

class MultiRoom {
  int roomPeople;
  int roomSeq;
  int roomDist;
  int roomMode;
  int roomSecret;
  String roomTag;
  int roomTime;
  String roomTitle;

  MultiRoom(
      {required this.roomPeople,
      required this.roomSeq,
      required this.roomDist,
      required this.roomMode,
      required this.roomSecret,
      required this.roomTag,
      required this.roomTime,
      required this.roomTitle});

  // Deserialize JSON to MultiRoom object
  factory MultiRoom.fromJson(Map<String, dynamic> json) {
    return MultiRoom(
      roomPeople: json['roomPeople'] as int,
      roomSeq: json['roomSeq'] as int,
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
      'roomIdx': roomSeq,
      'roomDist': roomDist,
      'roomMode': roomMode,
      'roomSecret': roomSecret,
      'roomTag': roomTag,
      'roomTime': roomTime,
      'roomTitle': roomTitle,
    };
  }

  @override
  String toString() {
    return 'MultiRoom(roomSeq: $roomSeq, roomPeople: $roomPeople, roomDist: $roomDist, roomMode: $roomMode, roomSecret: $roomSecret, roomTag: "$roomTag", roomTime: $roomTime, roomTitle: "$roomTitle")';
  }
}

class RoomInfo extends MultiRoom {
  final int roomIdx;

  RoomInfo(
      {required this.roomIdx,
      required super.roomSeq,
      required super.roomPeople,
      required super.roomDist,
      required super.roomMode,
      required super.roomSecret,
      required super.roomTag,
      required super.roomTime,
      required super.roomTitle});

  @override
  String toString() {
    return 'RoomInfo(roomIdx: $roomIdx, roomPeople: $roomPeople, roomDist: $roomDist, roomMode: $roomMode, roomSecret: $roomSecret, roomTag: $roomTag, roomTime: $roomTime, roomTitle: $roomTitle, roomSeq: $roomSeq)';
  }
}

class MultiRoomAttend implements Serializable {
  String memberNickname;
  String memberGender; //F/M
  String memberProfileImage;
  int memberLevel;
  String memberId;

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
  int roomIdx;
  String recordStartLocation;
  int recordPeople;

  MultiRoomGameStart({
    required this.roomIdx,
    required this.recordStartLocation,
    required this.recordPeople,
  });

  factory MultiRoomGameStart.fromJson(Map<String, dynamic> json) {
    return MultiRoomGameStart(
      roomIdx: json['roomIdx'] as int,
      recordStartLocation: json['recordStartLocation'] as String,
      recordPeople: json['recordPeople'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'roomIdx': roomIdx,
        'recordStartLocation': recordStartLocation,
        'recordPeople': recordPeople,
      };

  @override
  String toString() {
    return 'MultiRoomGameStart(roomIdx: $roomIdx, recordStartLocation: $recordStartLocation, recordPeople: $recordPeople)';
  }
}

class MultiRoomGameEnd {
  // String recordMode;
  String recordImage;
  int recordDist;
  int recordTime;
  String recordStartLocation;
  String recordEndLocation;
  String recordWay; // JSON
  String recordSpeed; // JSON
  String recordHeartbeat; // JSON
  String recordPace; // JSON
  int recordRank;
  int roomSeq;

  MultiRoomGameEnd({
    required this.roomSeq,
    required this.recordImage,
    required this.recordDist,
    required this.recordTime,
    required this.recordStartLocation,
    required this.recordEndLocation,
    required this.recordWay,
    required this.recordSpeed,
    required this.recordHeartbeat,
    required this.recordPace,
    required this.recordRank,
  });

  factory MultiRoomGameEnd.fromJson(Map<String, dynamic> json) {
    return MultiRoomGameEnd(
      roomSeq: json['roomSeq'] as int,
      recordImage: json['recordImage'] as String,
      recordDist: json['recordDist'] as int,
      recordTime: json['recordTime'] as int,
      recordStartLocation: json['recordStartLocation'] as String,
      recordEndLocation: json['recordEndLocation'] as String,
      recordWay: json['recordWay'] as String,
      recordSpeed: json['recordSpeed'] as String,
      recordHeartbeat: json['recordHeartbeat'] as String,
      recordPace: json['recordPace'] as String,
      recordRank: json['recordRank'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'roomSeq': roomSeq,
        'recordImage': recordImage,
        'recordDist': recordDist,
        'recordTime': recordTime,
        'recordStartLocation': recordStartLocation,
        'recordEndLocation': recordEndLocation,
        'recordWay': recordWay,
        'recordSpeed': recordSpeed,
        'recordHeartbeat': recordHeartbeat,
        'recordPace': recordPace,
        'recordRank': recordRank,
      };

  @override
  String toString() {
    return 'MultiRoomGameEnd(roomSeq: $roomSeq, recordImage: $recordImage, recordDist: $recordDist, recordTime: $recordTime, recordStartLocation: $recordStartLocation, recordEndLocation: $recordEndLocation, recordWay: $recordWay, recordSpeed: $recordSpeed, recordHeartbeat: $recordHeartbeat, recordPace: $recordPace, recordRank: $recordRank)';
  }
}

class MemberInGame {
  String memberNickname;
  String memberId;
  String memberGender;
  String memberProfileImage;
  int memberLevel;
  bool memberReady;
  bool manager;

  MemberInGame(
      {required this.memberNickname,
      required this.memberId,
      required this.memberGender,
      required this.memberProfileImage,
      required this.memberLevel,
      required this.memberReady,
      required this.manager});
}

class SimpleRoom {
  int roomIdx;
  String roomTitle;
  int roomPeople;
  String? roomTag;
  int roomSecret;
  int roomMode;
  int roomDist;
  int roomTime;
  int? nowRoomPeople;
  // int roomSeq;

  SimpleRoom({
    required this.roomIdx,
    required this.roomTitle,
    required this.roomPeople,
    required this.roomSecret,
    this.roomTag,
    required this.roomMode,
    required this.roomDist,
    required this.roomTime,
    required this.nowRoomPeople,
    // required this.roomSeq,
  });

  // Convert SimpleRoom object to a Map
  Map<String, dynamic> toJson() {
    return {
      'roomIdx': roomIdx,
      'roomTitle': roomTitle,
      'roomPeople': roomPeople,
      'roomTag': roomTag,
      'roomSecret': roomSecret,
      'roomMode': roomMode,
      'roomDist': roomDist,
      'roomTime': roomTime,
      'nowRoomPeople': nowRoomPeople,
      // 'roomSeq': roomSeq,
    };
  }

  // Create SimpleRoom object from JSON map
  factory SimpleRoom.fromJson(Map<String, dynamic> json) {
    return SimpleRoom(
      roomIdx: json['roomIdx'] as int,
      roomTitle: json['roomTitle'] as String,
      roomPeople: json['roomPeople'] as int,
      roomTag: json['roomTag'] as String?,
      roomSecret: json['roomSecret'] as int,
      roomMode: json['roomMode'] as int,
      roomDist: json['roomDist'] as int,
      roomTime: json['roomTime'] as int,
      // roomSeq: json['roomSeq'] as int,
      nowRoomPeople: json['nowRoomPeople'] as int,
    );
  }

  @override
  String toString() {
    return 'SimpleRoom{ roomIdx: $roomIdx, roomTitle: $roomTitle, roomPeople: $roomPeople, roomTag: $roomTag, roomSecret: $roomSecret, roomMode: $roomMode, roomDist: $roomDist, roomTime: $roomTime, nowRoomPeople: $nowRoomPeople}';
  }
  // String toString() {
  //   return 'SimpleRoom{ roomIdx: $roomIdx, roomTitle: $roomTitle, roomPeople: $roomPeople, roomTag: $roomTag, roomSecret: $roomSecret, roomMode: $roomMode, nowRoomPeople: $nowRoomPeople }';
  // }
}
