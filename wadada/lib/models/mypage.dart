import 'dart:math';

import 'package:flutter/material.dart';

//MYPAGE-001
class MonthlyRecord {
  final List<SimpleRecord> monthlyRecord;
  MonthlyRecord({required this.monthlyRecord});
}

class SimpleRecord {
  final int recordSeq;
  final String recordType;
  final double recordDist;
  //언제 달렸는지 확인용
  final DateTime recordCreatedAt;

  SimpleRecord(
      {required this.recordCreatedAt,
      required this.recordType,
      required this.recordDist,
      required this.recordSeq});
}

//MYPAGE-002
class SingleDetail {
  final String recordType;
  final int recordRank;
  final String recordImage;
  final double recordDist;
  final TimeOfDay recordTime;
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
    required String this.recordType,
    required int this.recordRank,
    required String this.recordImage,
    required double this.recordDist,
    required TimeOfDay this.recordTime,
    required Point this.recordStartLocation,
    required Point this.recordEndLocation,
    required List<Point> this.recordSpeed,
    required List<Point> this.recordHeartbeat,
    required List<Point> this.recordPace,
    required DateTime this.recordCreatedAt,
    required double this.recordMeanSpeed,
    required double this.recordMeanPace,
    required double this.recordMeanHeartbeat,
  });
}

//MYPAGE-003
class MultiDetail extends SingleDetail {
  final List<Rank> rankings;
  MultiDetail(this.rankings,
      {required super.recordType,
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
}

class Rank {
  final String name;
  final String metric;
  final String profileImage;

  Rank({required this.name, required this.metric, required this.profileImage});
}

//MYPAGE-004
class MarathonDetail extends SingleDetail {
  final List<RankMarathon> rankings;
  MarathonDetail(this.rankings,
      {required super.recordType,
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
}

class RankMarathon extends Rank {
  final int rank;
  RankMarathon(this.rank,
      {required super.name,
      required super.metric,
      required super.profileImage});
}
