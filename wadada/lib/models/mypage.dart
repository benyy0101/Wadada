import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wadada/util/serializable.dart';

//Request는 직렬화(Serializable)를, Response는 역직렬화 해줘야 사용가능함

Duration _parseTimeOfDay(String timeString) {
  final hoursAndMinutes = timeString.split(':');
  return Duration(
    hours: int.parse(hoursAndMinutes[0]),
    minutes: int.parse(hoursAndMinutes[1]),
    seconds: int.parse(hoursAndMinutes[2]),
  );
}

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);

  // JSON을 Dart 객체로 변환하는 팩토리 생성자
  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      json['x'] as double,
      json['y'] as double,
    );
  }

  // Dart 객체를 JSON으로 변환하는 메소드
  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
      };
}

class RecordRequest implements Serializable {
  final int recordSeq;
  final String recordType;

  RecordRequest({required this.recordSeq, required this.recordType});

  @override
  Map<String, dynamic> toJson() {
    return {
      'recordSeq': recordSeq,
      'recordType': recordType,
    };
  }
}

//MYPAGE-001
class MonthlyRecord {
  final List<SimpleRecord> monthlyRecord;
  MonthlyRecord({required this.monthlyRecord});

  factory MonthlyRecord.fromJson(Map<String, dynamic> json) {
    var list = json['monthlyRecord'] as List;
    List<SimpleRecord> monthlyRecordList =
        list.map((item) => SimpleRecord.fromJson(item)).toList();

    return MonthlyRecord(monthlyRecord: monthlyRecordList);
  }
}

class SimpleRecord {
  final int recordSeq;
  final String recordType;
  final int recordDist;
  //언제 달렸는지 확인용
  final DateTime recordCreatedAt;

  SimpleRecord(
      {required this.recordCreatedAt,
      required this.recordType,
      required this.recordDist,
      required this.recordSeq});

  factory SimpleRecord.fromJson(Map<String, dynamic> json) {
    return SimpleRecord(
      recordSeq: json['recordSeq'] as int,
      recordType: json['recordType'] as String,
      recordDist: json['recordDist'] as int,
      recordCreatedAt: DateTime.parse(json['recordCreatedAt'] as String),
    );
  }
}

//MYPAGE-002
class SingleDetail {
  final String recordType;
  final int recordRank;
  final String recordImage;
  final double recordDist;
  final Duration recordTime;
  final Point recordStartLocation;
  final Point recordEndLocation;
  final List<Point> recordSpeed;
  final List<Point> recordHeartbeat;
  final List<Point> recordPace;
  final DateTime recordCreatedAt;
  final double recordMeanSpeed;
  final double recordMeanPace;
  final double recordMeanHeartbeat;

  SingleDetail({
    required this.recordType,
    required this.recordRank,
    required this.recordImage,
    required this.recordDist,
    required this.recordTime,
    required this.recordStartLocation,
    required this.recordEndLocation,
    required this.recordSpeed,
    required this.recordHeartbeat,
    required this.recordPace,
    required this.recordCreatedAt,
    required this.recordMeanSpeed,
    required this.recordMeanPace,
    required this.recordMeanHeartbeat,
  });

  factory SingleDetail.fromJson(Map<String, dynamic> json) {
    var speedList =
        (json['recordSpeed'] as List).map((i) => Point.fromJson(i)).toList();
    var heartbeatList = (json['recordHeartbeat'] as List)
        .map((i) => Point.fromJson(i))
        .toList();
    var paceList =
        (json['recordPace'] as List).map((i) => Point.fromJson(i)).toList();

    return SingleDetail(
      recordType: json['recordType'],
      recordRank: json['recordRank'],
      recordImage: json['recordImage'],
      recordDist: json['recordDist'],
      recordTime: _parseTimeOfDay(json['recordTime']),
      recordStartLocation: Point.fromJson(json['recordStartLocation']),
      recordEndLocation: Point.fromJson(json['recordEndLocation']),
      recordSpeed: speedList,
      recordHeartbeat: heartbeatList,
      recordPace: paceList,
      recordCreatedAt: DateTime.parse(json['recordCreatedAt']),
      recordMeanSpeed: json['recordMeanSpeed'],
      recordMeanPace: json['recordMeanPace'],
      recordMeanHeartbeat: json['recordMeanHeartbeat'],
    );
  }
}

//MYPAGE-003
class MultiDetail extends SingleDetail {
  final List<Rank> rankings;
  MultiDetail(
      {required this.rankings,
      required super.recordType,
      required super.recordRank,
      required super.recordImage,
      required super.recordDist,
      required super.recordTime,
      required super.recordStartLocation,
      required super.recordEndLocation,
      required super.recordSpeed,
      required super.recordHeartbeat,
      required super.recordPace,
      required super.recordCreatedAt,
      required super.recordMeanSpeed,
      required super.recordMeanPace,
      required super.recordMeanHeartbeat});

  factory MultiDetail.fromJson(Map<String, dynamic> json) {
    List<Rank> rankings = (json['rankings'] as List)
        .map((rankJson) => Rank.fromJson(rankJson))
        .toList();

    return MultiDetail(
      rankings: rankings,
      recordType: json['recordType'],
      recordRank: json['recordRank'],
      recordImage: json['recordImage'],
      recordDist: json['recordDist'].toDouble(),
      recordTime: _parseTimeOfDay(json['recordTime']),
      recordStartLocation: Point.fromJson(json['recordStartLocation']),
      recordEndLocation: Point.fromJson(json['recordEndLocation']),
      recordSpeed:
          List<Point>.from(json['recordSpeed'].map((x) => Point.fromJson(x))),
      recordHeartbeat: List<Point>.from(
          json['recordHeartbeat'].map((x) => Point.fromJson(x))),
      recordPace:
          List<Point>.from(json['recordPace'].map((x) => Point.fromJson(x))),
      recordCreatedAt: DateTime.parse(json['recordCreatedAt']),
      recordMeanSpeed: json['recordMeanSpeed'].toDouble(),
      recordMeanPace: json['recordMeanPace'].toDouble(),
      recordMeanHeartbeat: json['recordMeanHeartbeat'].toDouble(),
    );
  }
}

class Rank {
  final String name;
  final String metric;
  final String profileImage;

  Rank({required this.name, required this.metric, required this.profileImage});
  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(
      name: json['name'],
      metric: json['metric'],
      profileImage: json['profileImage'],
    );
  }
}

//MYPAGE-004
class MarathonDetail extends SingleDetail {
  final List<RankMarathon> rankings;

  MarathonDetail({
    required this.rankings,
    required super.recordType,
    required super.recordRank,
    required super.recordImage,
    required super.recordDist,
    required super.recordTime,
    required super.recordStartLocation,
    required super.recordEndLocation,
    required super.recordSpeed,
    required super.recordHeartbeat,
    required super.recordPace,
    required super.recordCreatedAt,
    required super.recordMeanSpeed,
    required super.recordMeanPace,
    required super.recordMeanHeartbeat,
  });

  factory MarathonDetail.fromJson(Map<String, dynamic> json) {
    var rankingsList = (json['rankings'] as List)
        .map((item) => RankMarathon.fromJson(item))
        .toList();

    return MarathonDetail(
      rankings: rankingsList,
      recordType: json['recordType'],
      recordRank: json['recordRank'],
      recordImage: json['recordImage'],
      recordDist: json['recordDist'].toDouble(),
      recordTime: _parseTimeOfDay(json['recordTime']),
      recordStartLocation: json['recordStartLocation'],
      recordEndLocation: json['recordEndLocation'],
      recordSpeed: json['recordSpeed'].toDouble(),
      recordHeartbeat: json['recordHeartbeat'].toDouble(),
      recordPace: json['recordPace'].toDouble(),
      recordCreatedAt: DateTime.parse(json['recordCreatedAt']),
      recordMeanSpeed: json['recordMeanSpeed'].toDouble(),
      recordMeanPace: json['recordMeanPace'].toDouble(),
      recordMeanHeartbeat: json['recordMeanHeartbeat'].toDouble(),
    );
  }
}

class RankMarathon extends Rank {
  final int rank;

  RankMarathon({
    required this.rank,
    required super.name,
    required super.metric,
    required super.profileImage,
  });

  factory RankMarathon.fromJson(Map<String, dynamic> json) {
    return RankMarathon(
      rank: json['rank'],
      name: json['name'],
      metric: json['metric'],
      profileImage: json['profileImage'],
    );
  }
}
