import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/models/profile.dart';

class ProfileProvider {
  late Dio _dio;
  final storage = FlutterSecureStorage();

  ProfileProvider() {
    _dio = Dio();
    _dio.options.baseUrl = 'https://k10a704.p.ssafy.io/Multi';
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Authorization'] = storage.read(key: 'accessToken');
  }

  Future<Response<dynamic>> multiRoomGet(String mode) async {
    final response = await _dio.get(
      '/${mode}',
    );
    return response;
  }

  Future<Response<dynamic>> multiRoomSearch(String title) async {
    final response = await _dio.get(
      '/${title}',
    );
    return response;
  }

  Future<Response<dynamic>> multiRoomCreate(MultiRoom room) async {
    final response = await _dio.post('/create', data: room);
    return response;
  }

  Future<Response<dynamic>> multiRoomAttend(String roomSeq) async {
    final response = await _dio.get(
      '/attend/${roomSeq}',
    );
    return response;
  }

  Future<Response<dynamic>> multiRoomGameStart(
      MultiRoomGameStart startInfo) async {
    final response = await _dio.post('/start', data: startInfo);
    return response;
  }

  Future<Response<dynamic>> multiRoomGameEnd(MultiRoomGameEnd endInfo) async {
    final response = await _dio.patch('/result', data: endInfo);
    return response;
  }
}
