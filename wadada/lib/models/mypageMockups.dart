import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wadada/models/mypage.dart';

MonthlyRecord mypage001response = MonthlyRecord(monthlyRecord: list);

List<SimpleRecord> list = [
  SimpleRecord(
      recordCreatedAt: DateTime(2024, 1, 1),
      recordType: '멀티',
      recordDist: 3.2,
      recordSeq: 31),
  SimpleRecord(
      recordCreatedAt: DateTime(2024, 1, 1),
      recordType: '멀티',
      recordDist: 3.2,
      recordSeq: 32),
  SimpleRecord(
      recordCreatedAt: DateTime(2024, 1, 1),
      recordType: '멀티',
      recordDist: 3.2,
      recordSeq: 33),
  SimpleRecord(
      recordCreatedAt: DateTime(2024, 1, 2),
      recordType: '멀티',
      recordDist: 3.2,
      recordSeq: 34),
  SimpleRecord(
      recordCreatedAt: DateTime(2024, 1, 3),
      recordType: '멀티',
      recordDist: 3.2,
      recordSeq: 35),
];

List<Point> points = [
  Point(34, 123),
  Point(872, 12),
  Point(34, 15),
  Point(543, 16),
  Point(654, 1764),
  Point(23, 1234),
  Point(45, 11),
  Point(4, 894),
];

SingleDetail mypage002res = SingleDetail(
    recordType: '멀티',
    recordRank: 3,
    recordImage: "recordImage",
    recordDist: 123,
    recordTime: Duration(seconds: 60),
    recordStartLocation: Point(0, 0),
    recordEndLocation: Point(1, 1),
    recordSpeed: points,
    recordHeartbeat: points,
    recordPace: points,
    recordCreatedAt: DateTime(2023, 12, 3),
    recordMeanSpeed: 32,
    recordMeanPace: 32.1,
    recordMeanHeartbeat: 231.2);

List<Rank> rankList = [
  Rank(name: '', metric: '', profileImage: ''),
  Rank(name: '', metric: '', profileImage: ''),
  Rank(name: '', metric: '', profileImage: ''),
  Rank(name: '', metric: '', profileImage: ''),
];

MultiDetail mypage003 = MultiDetail(
  rankings: rankList,
  recordType: '멀티',
  recordRank: 3,
  recordImage: "recordImage",
  recordDist: 123,
  recordTime: Duration(seconds: 60),
  recordStartLocation: Point(0, 0),
  recordEndLocation: Point(1, 1),
  recordSpeed: points,
  recordHeartbeat: points,
  recordPace: points,
  recordCreatedAt: DateTime(2023, 12, 3),
  recordMeanSpeed: 32,
  recordMeanPace: 32.1,
  recordMeanHeartbeat: 231.2,
);

List<RankMarathon> marathonList = [
  RankMarathon(name: '', metric: '', profileImage: '', rank: 1),
  RankMarathon(name: '', metric: '', profileImage: '', rank: 2),
  RankMarathon(name: '', metric: '', profileImage: '', rank: 3),
  RankMarathon(name: '', metric: '', profileImage: '', rank: 4),
];

MarathonDetail mypage004 = MarathonDetail(
  rankings: marathonList,
  recordType: '멀티',
  recordRank: 3,
  recordImage: "recordImage",
  recordDist: 123,
  recordTime: Duration(seconds: 60),
  recordStartLocation: Point(0, 0),
  recordEndLocation: Point(1, 1),
  recordSpeed: points,
  recordHeartbeat: points,
  recordPace: points,
  recordCreatedAt: DateTime(2023, 12, 3),
  recordMeanSpeed: 32,
  recordMeanPace: 32.1,
  recordMeanHeartbeat: 231.2,
);
