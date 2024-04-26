import 'dart:math';

import 'package:flutter/material.dart';

class RecordRequest {
  final int recordSeq;
  final String recordType;

  RecordRequest({required this.recordSeq, required this.recordType});
}

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
  MarathonDetail(
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
}

class RankMarathon extends Rank {
  final int rank;
  RankMarathon(
      {required this.rank,
      required super.name,
      required super.metric,
      required super.profileImage});
}
