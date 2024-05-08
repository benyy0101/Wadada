import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/models/profile.dart';

class MultiProvider {
  late Dio _dio;
  final storage = FlutterSecureStorage();

  MultiProvider() {
    _dio = Dio();
    _dio.options.baseUrl = 'https://k10a704.p.ssafy.io/Multi';
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Authorization'] = storage.read(key: 'accessToken');
  }

  Future<void> setAuth() async {
    _dio.options.headers['Authorization'] =
        await storage.read(key: 'accessToken');
    // _dio.options.headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM';


    print(_dio.options.headers['Authorization']);
  }

  Future<Response<dynamic>> multiRoomGet(String mode) async {
    await setAuth();
    final response = await _dio.get(
      '/$mode',
    );
    return response;
  }

  Future<Response<dynamic>> multiRoomSearch(String title) async {
    await setAuth();
    final response = await _dio.get(
      '/$title',
    );
    return response;
  }

  Future<Response<dynamic>> multiRoomCreate(MultiRoom room) async {
    await setAuth();
    print(_dio.options.headers['Authorization']);
    final response = await _dio.post('/create', data: room.toJson());
    return response;
  }

  Future<Response<dynamic>> multiRoomAttend(String roomSeq) async {
    setAuth();
    final response = await _dio.get(
      '/attend/$roomSeq',
    );
    return response;
  }

  Future<Response<dynamic>> multiRoomGameStart(
      MultiRoomGameStart startInfo) async {
    setAuth();
    final response = await _dio.post('/start', data: startInfo);
    return response;
  }

  Future<Response<dynamic>> multiRoomGameEnd(MultiRoomGameEnd endInfo) async {
    setAuth();
    final response = await _dio.patch('/result', data: endInfo);
    return response;
  }
}

