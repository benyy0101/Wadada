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
  final String recordStartLocation;
  final String recordEndLocation;
  final List<Map<String, dynamic>> recordSpeed;
  final List<Map<String, dynamic>> recordHeartbeat;
  final List<Map<String, dynamic>> recordPace;
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
    return SingleDetail(
      recordType: json['recordType'] as String,
      recordRank: json['recordRank'] as int,
      recordImage: json['recordImage'] as String,
      recordDist: json['recordDist'] as double,
      recordTime: _parseTimeOfDay(json['recordTime'] as String),
      recordStartLocation: json['recordStartLocation'] as String,
      recordEndLocation: json['recordEndLocation'] as String,
      recordSpeed: List<Map<String, dynamic>>.from(json['recordSpeed'] as List),
      recordHeartbeat:
          List<Map<String, dynamic>>.from(json['recordHeartbeat'] as List),
      recordPace: List<Map<String, dynamic>>.from(json['recordPace'] as List),
      recordCreatedAt: DateTime.parse(json['recordCreatedAt'] as String),
      recordMeanSpeed: json['recordMeanSpeed'] as double,
      recordMeanPace: json['recordMeanPace'] as double,
      recordMeanHeartbeat: json['recordMeanHeartbeat'] as double,
    );
  }

  Map<String, dynamic> toJson() => {
        'recordType': recordType,
        'recordRank': recordRank,
        'recordImage': recordImage,
        'recordDist': recordDist,
        'recordTime': recordTime.inMilliseconds,
        'recordStartLocation': recordStartLocation,
        'recordEndLocation': recordEndLocation,
        'recordSpeed': recordSpeed,
        'recordHeartbeat': recordHeartbeat,
        'recordPace': recordPace,
        'recordCreatedAt': recordCreatedAt.toIso8601String(),
        'recordMeanSpeed': recordMeanSpeed,
        'recordMeanPace': recordMeanPace,
        'recordMeanHeartbeat': recordMeanHeartbeat,
      };

  @override
  String toString() {
    return 'SingleDetail(recordType: $recordType, recordRank: $recordRank, recordImage: $recordImage, recordDist: $recordDist, recordTime: $recordTime, recordStartLocation: $recordStartLocation, recordEndLocation: $recordEndLocation, recordSpeed: $recordSpeed, recordHeartbeat: $recordHeartbeat, recordPace: $recordPace, recordCreatedAt: $recordCreatedAt, recordMeanSpeed: $recordMeanSpeed, recordMeanPace: $recordMeanPace, recordMeanHeartbeat: $recordMeanHeartbeat)';
  }
}

//MYPAGE-003
class MultiDetail extends SingleDetail {
  final List<Rank> rankings;

  MultiDetail({
    required this.rankings,
    required String recordType,
    required int recordRank,
    required String recordImage,
    required double recordDist,
    required Duration recordTime,
    required String recordStartLocation,
    required String recordEndLocation,
    required List<Map<String, dynamic>> recordSpeed,
    required List<Map<String, dynamic>> recordHeartbeat,
    required List<Map<String, dynamic>> recordPace,
    required DateTime recordCreatedAt,
    required double recordMeanSpeed,
    required double recordMeanPace,
    required double recordMeanHeartbeat,
  }) : super(
          recordType: recordType,
          recordRank: recordRank,
          recordImage: recordImage,
          recordDist: recordDist,
          recordTime: recordTime,
          recordStartLocation: recordStartLocation,
          recordEndLocation: recordEndLocation,
          recordSpeed: recordSpeed,
          recordHeartbeat: recordHeartbeat,
          recordPace: recordPace,
          recordCreatedAt: recordCreatedAt,
          recordMeanSpeed: recordMeanSpeed,
          recordMeanPace: recordMeanPace,
          recordMeanHeartbeat: recordMeanHeartbeat,
        );

  factory MultiDetail.fromJson(Map<String, dynamic> json) {
    List<Rank> rankings = (json['rankings'] as List)
        .map((rankJson) => Rank.fromJson(rankJson))
        .toList();

    return MultiDetail(
      rankings: rankings,
      recordType: json['recordType'] as String,
      recordRank: json['recordRank'] as int,
      recordImage: json['recordImage'] as String,
      recordDist: json['recordDist'] as double,
      recordTime: _parseTimeOfDay(json['recordTime'] as String),
      recordStartLocation: json['recordStartLocation'] as String,
      recordEndLocation: json['recordEndLocation'] as String,
      recordSpeed: (json['recordSpeed'] as List).cast<Map<String, dynamic>>(),
      recordHeartbeat:
          (json['recordHeartbeat'] as List).cast<Map<String, dynamic>>(),
      recordPace: (json['recordPace'] as List).cast<Map<String, dynamic>>(),
      recordCreatedAt: DateTime.parse(json['recordCreatedAt'] as String),
      recordMeanSpeed: json['recordMeanSpeed'] as double,
      recordMeanPace: json['recordMeanPace'] as double,
      recordMeanHeartbeat: json['recordMeanHeartbeat'] as double,
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
    required String recordType,
    required int recordRank,
    required String recordImage,
    required double recordDist,
    required Duration recordTime,
    required String recordStartLocation,
    required String recordEndLocation,
    required List<Map<String, dynamic>> recordSpeed,
    required List<Map<String, dynamic>> recordHeartbeat,
    required List<Map<String, dynamic>> recordPace,
    required DateTime recordCreatedAt,
    required double recordMeanSpeed,
    required double recordMeanPace,
    required double recordMeanHeartbeat,
  }) : super(
          recordType: recordType,
          recordRank: recordRank,
          recordImage: recordImage,
          recordDist: recordDist,
          recordTime: recordTime,
          recordStartLocation: recordStartLocation,
          recordEndLocation: recordEndLocation,
          recordSpeed: recordSpeed,
          recordHeartbeat: recordHeartbeat,
          recordPace: recordPace,
          recordCreatedAt: recordCreatedAt,
          recordMeanSpeed: recordMeanSpeed,
          recordMeanPace: recordMeanPace,
          recordMeanHeartbeat: recordMeanHeartbeat,
        );

  factory MarathonDetail.fromJson(Map<String, dynamic> json) {
    var rankingsList = (json['rankings'] as List)
        .map((item) => RankMarathon.fromJson(item))
        .toList();

    return MarathonDetail(
      rankings: rankingsList,
      recordType: json['recordType'] as String,
      recordRank: json['recordRank'] as int,
      recordImage: json['recordImage'] as String,
      recordDist: json['recordDist'] as double,
      recordTime: _parseTimeOfDay(json['recordTime'] as String),
      recordStartLocation: json['recordStartLocation'] as String,
      recordEndLocation: json['recordEndLocation'] as String,
      recordSpeed: (json['recordSpeed'] as List).cast<Map<String, dynamic>>(),
      recordHeartbeat:
          (json['recordHeartbeat'] as List).cast<Map<String, dynamic>>(),
      recordPace: (json['recordPace'] as List).cast<Map<String, dynamic>>(),
      recordCreatedAt: DateTime.parse(json['recordCreatedAt'] as String),
      recordMeanSpeed: json['recordMeanSpeed'] as double,
      recordMeanPace: json['recordMeanPace'] as double,
      recordMeanHeartbeat: json['recordMeanHeartbeat'] as double,
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
