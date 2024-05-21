import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/models/profile.dart';

class MultiProvider {
  late Dio _dio;
  final storage = FlutterSecureStorage();
  String accessToken = '';
  MultiProvider() {
    _dio = Dio();
    _dio.options.baseUrl = 'https://k10a704.p.ssafy.io/Multi';
    _dio.options.headers['Content-Type'] = 'application/json';
    //_dio.options.headers['Authorization'] = storage.read(key: 'accessToken');
  }

  Future<void> setAuth() async {
    String? temp = await storage.read(key: 'accessToken');
    if (temp != null) {
      _dio.options.headers['Authorization'] = temp;
      accessToken = temp;
    } else {
      _dio.options.headers['Authorization'] = accessToken;
    }
    print("-----------------token--------------------");
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
    print(title);
    final response = await _dio.get(
      '/tag/$title',
    );
    return response;
  }

  Future<Response<dynamic>> multiRoomCreate(MultiRoom room) async {
    await setAuth();
    final response = await _dio.post('/create', data: room.toJson());
    print("--------------create------------------");
    print(response.data);
    return response;
  }

  //DEAD END
  Future<Response<dynamic>> multiRoomAttend(String roomSeq) async {
    await setAuth();
    final response = await _dio.get(
      '/attend/$roomSeq',
    );
    return response;
  }

  //MULTI-006
  Future<Response<dynamic>> multiRoomGameStart(
      MultiRoomGameStart startInfo) async {
    await setAuth();
    final response = await _dio.post('/start', data: startInfo.toJson());
    return response;
  }

  //MULTI-007
  Future<Response<dynamic>> multiRoomGameEnd(MultiRoomGameEnd endInfo) async {
    await setAuth();
    final response = await _dio.post('/result', data: endInfo.toJson());
    return response;
  }
}
