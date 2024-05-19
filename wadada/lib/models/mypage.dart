import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wadada/common/component/lineChart.dart';
import 'package:wadada/util/serializable.dart';

//Request는 직렬화(Serializable)를, Response는 역직렬화 해줘야 사용가능함

Duration parseTimeOfDay(int seconds) {
  // Calculate hours, minutes, and remaining seconds
  int hours = seconds ~/ 3600;
  int remainingSeconds = seconds % 3600;
  int minutes = remainingSeconds ~/ 60;
  int remainingSecondsFinal = remainingSeconds % 60;

  return Duration(
    hours: hours,
    minutes: minutes,
    seconds: remainingSecondsFinal,
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
    print(list);
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
  int recordMode;

  SimpleRecord(
      {required this.recordCreatedAt,
      required this.recordType,
      required this.recordDist,
      required this.recordSeq,
      required this.recordMode});

  factory SimpleRecord.fromJson(Map<String, dynamic> json) {
    return SimpleRecord(
      recordSeq: json['recordSeq'] ?? 0,
      recordType: json['recordType'] ?? '0',
      recordDist: json['recordDist'] ?? 0,
      recordMode: json['recordMode'] ?? 0,
      recordCreatedAt: json['recordCreatedAt'] != null
          ? DateTime.parse(json['recordCreatedAt'])
          : DateTime.now(),
    );
  }
}

//MYPAGE-002
class SingleDetail {
  final String recordType;
  final int recordRank;
  final String recordImage;
  final int recordDist;
  final Duration recordTime;
  final String recordStartLocation;
  final String recordEndLocation;
  final List<ChartData> recordSpeed;
  final List<ChartData> recordHeartbeat;
  final List<ChartData> recordPace;
  final DateTime recordCreatedAt;
  final int recordMeanSpeed;
  final int recordMeanPace;
  final int recordMeanHeartbeat;

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
    print('======================');
    print(json);
    print(DateTime.parse(json['recordCreatedAt']));
    return SingleDetail(
      recordType: json['recordType'].toString() ?? '',
      recordRank: json['recordRank'] ?? 0,
      recordImage: '',
      recordDist: json['recordDist'] ?? 0,
      recordTime: parseTimeOfDay(json['recordTime'] ?? 0),
      recordStartLocation: json['recordStartLocation'] ?? '',
      recordEndLocation: json['recordEndLocation'] ?? '',
      recordSpeed: (json['recordSpeed'] != null
          ? (jsonDecode(json['recordSpeed']) as List? ?? [])
              .map((item) => ChartData.fromJson(jsonDecode(item)))
              .toList()
          : []),
      recordHeartbeat: (json['recordHeartBeat'] != null
          ? (jsonDecode(json['recordHeartBeat']) as List? ?? [])
              .map((item) => ChartData.fromJson(jsonDecode(item)))
              .toList()
          : []),
      recordPace: (json['recordPace'] != null
          ? (jsonDecode(json['recordPace']) as List? ?? []).map((item) {
              print(item.runtimeType);
              return ChartData.fromJson(jsonDecode(item));
            }).toList()
          : []),
      recordCreatedAt: json['recordCreatedAt'] != null
          ? DateTime.parse(json['recordCreatedAt'])
          : DateTime.now(),
      recordMeanSpeed: json['recordMeanSpeed'] ?? 0,
      recordMeanPace: json['recordMeanPace'] ?? 0,
      recordMeanHeartbeat: json['recordMeanHeartbeat'] ?? 0,
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
    required int recordDist,
    required Duration recordTime,
    required String recordStartLocation,
    required String recordEndLocation,
    required List<ChartData> recordSpeed,
    required List<ChartData> recordHeartbeat,
    required List<ChartData> recordPace,
    required DateTime recordCreatedAt,
    required int recordMeanSpeed,
    required int recordMeanPace,
    required int recordMeanHeartbeat,
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
      recordType: json['recordType']?.toString() ?? '',
      recordRank: json['recordRank'] ?? 0,
      recordImage: json['recordImage']?.toString() ?? '',
      recordDist: json['recordDist'] ?? 0,
      recordTime: parseTimeOfDay(json['recordTime'] ?? 0),
      recordStartLocation: json['recordStartLocation']?.toString() ?? '',
      recordEndLocation: json['recordEndLocation']?.toString() ?? '',
      recordSpeed: (json['recordSpeed'] != null
          ? (jsonDecode(json['recordSpeed']) as List? ?? [])
              .map((item) => ChartData.fromJson(item))
              .toList()
          : []),
      recordHeartbeat: (json['recordHeartbeat'] != null
          ? (jsonDecode(json['recordHeartbeat']) as List? ?? [])
              .map((item) => ChartData.fromJson(item))
              .toList()
          : []),
      recordPace: (json['recordPace'] != null
          ? (jsonDecode(json['recordPace']) as List? ?? [])
              .map((item) => ChartData.fromJson(item))
              .toList()
          : []),
      recordCreatedAt: json['recordCreatedAt'] != null
          ? DateTime.parse(json['recordCreatedAt'] as String)
          : DateTime.now(),
      recordMeanSpeed: json['recordMeanSpeed'] ?? 0,
      recordMeanPace: json['recordMeanPace'] ?? 0,
      recordMeanHeartbeat: json['recordMeanHeartbeat'] ?? 0,
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
    required int recordDist,
    required Duration recordTime,
    required String recordStartLocation,
    required String recordEndLocation,
    required List<ChartData> recordSpeed,
    required List<ChartData> recordHeartbeat,
    required List<ChartData> recordPace,
    required DateTime recordCreatedAt,
    required int recordMeanSpeed,
    required int recordMeanPace,
    required int recordMeanHeartbeat,
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
      recordType: json['recordType']?.toString() ?? '',
      recordRank: json['recordRank'] ?? 0,
      recordImage: json['recordImage']?.toString() ?? '',
      recordDist: json['recordDist'] ?? 0,
      recordTime: parseTimeOfDay(json['recordTime'] ?? 0),
      recordStartLocation: json['recordStartLocation']?.toString() ?? '',
      recordEndLocation: json['recordEndLocation']?.toString() ?? '',
      recordSpeed: (json['recordSpeed'] != null
          ? (jsonDecode(json['recordSpeed']) as List? ?? [])
              .map((item) => ChartData.fromJson(item))
              .toList()
          : []),
      recordHeartbeat: (json['recordHeartbeat'] != null
          ? (jsonDecode(json['recordHeartbeat']) as List? ?? [])
              .map((item) => ChartData.fromJson(item))
              .toList()
          : []),
      recordPace: (json['recordPace'] != null
          ? (jsonDecode(json['recordPace']) as List? ?? [])
              .map((item) => ChartData.fromJson(item))
              .toList()
          : []),
      recordCreatedAt: json['recordCreatedAt'] != null
          ? DateTime.parse(json['recordCreatedAt'] as String)
          : DateTime.now(),
      recordMeanSpeed: json['recordMeanSpeed'] ?? 0,
      recordMeanPace: json['recordMeanPace'] ?? 0,
      recordMeanHeartbeat: json['recordMeanHeartbeat'] ?? 0,
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
