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

// SINGLEPAGE-001
class RecentRecord {
  final Duration recordTime;
  final double recordDist;
  final List<double> recordSpeed;
  final List<double> recordHeartbeat;
  final List<double> recordPace;

  RecentRecord({
    required this.recordTime,
    required this.recordDist,
    required this.recordSpeed,
    required this.recordHeartbeat,
    required this.recordPace,
  });

  factory RecentRecord.fromJson(Map<String, dynamic> json) {
    final recordTime = Duration(seconds: json['recordTime'] as int);

    final recordSpeed = List<double>.from(json['recordSpeed']);
    final recordHeartbeat = List<double>.from(json['recordHeartbeat']);
    final recordPace = List<double>.from(json['recordPace']);

    return RecentRecord(
      recordTime: recordTime,
      recordDist: json['recordDist'] as double,
      recordSpeed: recordSpeed,
      recordHeartbeat: recordHeartbeat,
      recordPace: recordPace,
    );
  }
}