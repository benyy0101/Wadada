import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_connect/connect.dart';
import 'package:wadada/models/profile.dart';

class ProfileProvider extends GetConnect {
  @override
  void onInit() async {
    httpClient.baseUrl = 'https://k10a704.p.ssafy.io/Marathon/';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 10);
    final _storage = const FlutterSecureStorage();
    final token = await _storage.read(key: 'accessToken');
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] = 'Bearer ${token}';
      return request;
    });
  }

  Future<Response> profileDelete(String mode) async {
    final response = await delete(
      'profile',
    );
    return response;
  }
}
