class MarathonStart {
  String marathonRecordStart;
  int marathonSeq;

  // Constructor
  MarathonStart({required this.marathonRecordStart, required this.marathonSeq});

  // toString method
  @override
  String toString() {
    return 'MarathonStart(marathonRecordStart: $marathonRecordStart, marathonSeq: $marathonSeq)';
  }

  // fromJson method
  factory MarathonStart.fromJson(Map<String, dynamic> json) {
    return MarathonStart(
      marathonRecordStart: json['marathonRecordStart'],
      marathonSeq: json['marathonSeq'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'marathonRecordStart': marathonRecordStart,
      'marathonSeq': marathonSeq,
    };
  }
}

class Marathon {
  int marathonSeq;
  int marathonRecordRank;
  String marathonRecordStart;
  String marathonRecordWay;
  String marathonRecordEnd;
  int marathonRecordDist;
  int marathonRecordTime;
  String marathonRecordImage;
  String marathonRecordPace;
  int marathonRecordMeanPace;
  String marathonRecordSpeed;
  int marathonRecordMeanSpeed;
  String marathonRecordHeartbeat;
  int marathonRecordMeanHeartbeat;
  bool marathonRecordIsWin;

  Marathon({
    required this.marathonSeq,
    required this.marathonRecordRank,
    required this.marathonRecordStart,
    required this.marathonRecordWay,
    required this.marathonRecordEnd,
    required this.marathonRecordDist,
    required this.marathonRecordTime,
    required this.marathonRecordImage,
    required this.marathonRecordPace,
    required this.marathonRecordMeanPace,
    required this.marathonRecordSpeed,
    required this.marathonRecordMeanSpeed,
    required this.marathonRecordHeartbeat,
    required this.marathonRecordMeanHeartbeat,
    required this.marathonRecordIsWin,
  });

  @override
  String toString() {
    return 'Marathon{marathonSeq: $marathonSeq, marathonRecordRank: $marathonRecordRank, marathonRecordStart: $marathonRecordStart, marathonRecordWay: $marathonRecordWay, marathonRecordEnd: $marathonRecordEnd, marathonRecordDist: $marathonRecordDist, marathonRecordTime: $marathonRecordTime, marathonRecordImage: $marathonRecordImage, marathonRecordPace: $marathonRecordPace, marathonRecordMeanPace: $marathonRecordMeanPace, marathonRecordSpeed: $marathonRecordSpeed, marathonRecordMeanSpeed: $marathonRecordMeanSpeed, marathonRecordHeartbeat: $marathonRecordHeartbeat, marathonRecordMeanHeartbeat: $marathonRecordMeanHeartbeat, marathonRecordIsWin: $marathonRecordIsWin}';
  }

  Map<String, dynamic> toJson() {
    return {
      'marathonSeq': marathonSeq,
      'marathonRecordRank': marathonRecordRank,
      'marathonRecordStart': marathonRecordStart,
      'marathonRecordWay': marathonRecordWay,
      'marathonRecordEnd': marathonRecordEnd,
      'marathonRecordDist': marathonRecordDist,
      'marathonRecordTime': marathonRecordTime,
      'marathonRecordImage': marathonRecordImage,
      'marathonRecordPace': marathonRecordPace,
      'marathonRecordMeanPace': marathonRecordMeanPace,
      'marathonRecordSpeed': marathonRecordSpeed,
      'marathonRecordMeanSpeed': marathonRecordMeanSpeed,
      'marathonRecordHeartbeat': marathonRecordHeartbeat,
      'marathonRecordMeanHeartbeat': marathonRecordMeanHeartbeat,
      'marathonRecordIsWin': marathonRecordIsWin,
    };
  }

  factory Marathon.fromJson(Map<String, dynamic> json) {
    return Marathon(
      marathonSeq: json['marathonSeq'],
      marathonRecordRank: json['marathonRecordRank'],
      marathonRecordStart: json['marathonRecordStart'],
      marathonRecordWay: json['marathonRecordWay'],
      marathonRecordEnd: json['marathonRecordEnd'],
      marathonRecordDist: json['marathonRecordDist'],
      marathonRecordTime: json['marathonRecordTime'],
      marathonRecordImage: json['marathonRecordImage'],
      marathonRecordPace: json['marathonRecordPace'],
      marathonRecordMeanPace: json['marathonRecordMeanPace'],
      marathonRecordSpeed: json['marathonRecordSpeed'],
      marathonRecordMeanSpeed: json['marathonRecordMeanSpeed'],
      marathonRecordHeartbeat: json['marathonRecordHeartbeat'],
      marathonRecordMeanHeartbeat: json['marathonRecordMeanHeartbeat'],
      marathonRecordIsWin: json['marathonRecordIsWin'],
    );
  }
}

class SimpleMarathon {
  int marathonSeq;
  int marathonRound;
  int marathonDist;
  int marathonParticipate;
  DateTime marathonStart;
  DateTime marathonEnd;
  bool isDeleted;

  SimpleMarathon({
    required this.marathonSeq,
    required this.marathonRound,
    required this.marathonDist,
    required this.marathonParticipate,
    required this.marathonStart,
    required this.marathonEnd,
    required this.isDeleted,
  });

  @override
  String toString() {
    return 'SimpleMarathon{marathonSeq: $marathonSeq, marathonRound: $marathonRound, marathonDist: $marathonDist, marathonParticipate: $marathonParticipate, marathonStart: $marathonStart, marathonEnd: $marathonEnd, isDeleted: $isDeleted}';
  }

  Map<String, dynamic> toJson() {
    return {
      'marathonSeq': marathonSeq,
      'marathonRound': marathonRound,
      'marathonDist': marathonDist,
      'marathonParticipate': marathonParticipate,
      'marathonStart': marathonStart.toIso8601String(),
      'marathonEnd': marathonEnd.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  factory SimpleMarathon.fromJson(Map<String, dynamic> json) {
    return SimpleMarathon(
      marathonSeq: json['marathonSeq'],
      marathonRound: json['marathonRound'],
      marathonDist: json['marathonDist'],
      marathonParticipate: json['marathonParticipate'],
      marathonStart: DateTime.parse(json['marathonStart']),
      marathonEnd: DateTime.parse(json['marathonEnd']),
      isDeleted: json['isDeleted'],
    );
  }
}

class MarathonParticipant {
  String memberName;
  String memberImage;

  MarathonParticipant({
    required this.memberName,
    required this.memberImage,
  });

  @override
  String toString() {
    return 'MarathonParticipant{memberName: $memberName, memberImage: $memberImage}';
  }

  Map<String, dynamic> toJson() {
    return {
      'memberName': memberName,
      'memberImage': memberImage,
    };
  }

  factory MarathonParticipant.fromJson(Map<String, dynamic> json) {
    return MarathonParticipant(
      memberName: json['memberName'],
      memberImage: json['memberImage'],
    );
  }
}

class MyMarathonRecord {
  String memberName;
  String memberImage;
  int memberDist;
  int memberTime;

  MyMarathonRecord({
    required this.memberName,
    required this.memberImage,
    required this.memberDist,
    required this.memberTime,
  });

  @override
  String toString() {
    return 'MyMarathonRecord{memberName: $memberName, memberImage: $memberImage, memberDist: $memberDist, memberTime: $memberTime}';
  }

  Map<String, dynamic> toJson() {
    return {
      'memberName': memberName,
      'memberImage': memberImage,
      'memberDist': memberDist,
      'memberTime': memberTime,
    };
  }

  factory MyMarathonRecord.fromJson(Map<String, dynamic> json) {
    return MyMarathonRecord(
      memberName: json['memberName'],
      memberImage: json['memberImage'],
      memberDist: json['memberDist'],
      memberTime: json['memberTime'],
    );
  }
}

class DistanceRecord {
  int roomSeq;
  String userName;
  int userDist;
  int userTime;

  DistanceRecord({
    required this.roomSeq,
    required this.userName,
    required this.userDist,
    required this.userTime,
  });

  @override
  String toString() {
    return 'DistanceRecord{roomSeq: $roomSeq, userName: $userName, userDist: $userDist, userTime: $userTime}';
  }

  factory DistanceRecord.fromJson(Map<String, dynamic> json) {
    return DistanceRecord(
      roomSeq: json['roomSeq'] as int? ?? 0,
      userName: json['userName'] as String? ?? '',
      userDist: json['userDist'] as int? ?? 0,
      userTime: json['userTime'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomSeq': roomSeq,
      'userName': userName,
      'userDist': userDist,
      'userTime': userTime,
    };
  }
}
