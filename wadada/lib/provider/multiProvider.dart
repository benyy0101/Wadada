import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_connect/connect.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/models/profile.dart';

class ProfileProvider extends GetConnect {
  @override
  void onInit() async {
    httpClient.baseUrl = 'https://k10a704.p.ssafy.io/Multi';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 10);
    final _storage = const FlutterSecureStorage();
    final token = await _storage.read(key: 'accessToken');
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] = 'Bearer ${token}';
      return request;
    });
  }

  Future<Response> multiRoomGet(String mode) async {
    final response = await get(
      '/${mode}',
    );
    return response;
  }

  Future<Response> multiRoomSearch(String title) async {
    final response = await get(
      '/${title}',
    );
    return response;
  }

  Future<Response> multiRoomCreate(MultiRoom room) async {
    final response = await post('/create', room);
    return response;
  }

  Future<Response> multiRoomAttend(String roomSeq) async {
    final response = await get(
      '/attend/${roomSeq}',
    );
    return response;
  }

  Future<Response> multiRoomGameStart(MultiRoomGameStart startInfo) async {
    final response = await post('/start', startInfo);
    return response;
  }

  Future<Response> multiRoomGameEnd(MultiRoomGameEnd endInfo) async {
    final response = await patch('/result', endInfo);
    return response;
  }
}
