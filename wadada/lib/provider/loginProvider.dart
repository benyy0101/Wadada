import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_connect/connect.dart';

class LoginProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();
  }

  void setUrl() {
    httpClient.baseUrl = 'https://k10a704.p.ssafy.io/Wadada/auth';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 10);
  }

  Future<Response> kakaoLogin(String code) async {
    setUrl();
    print(code);
    final response = await post('/login', {'code': code});
    print("------------------------------------");
    print(response.statusCode);
    print(response.body);
    return response;
  }

  Future<Response> logout() async {
    final _storage = const FlutterSecureStorage();
    final token = await _storage.read(key: 'accessToken');
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] = 'Bearer ${token}';
      return request;
    });
    final response = await get(
      'logout',
    );
    return response;
  }
}
