import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginProvider {
  late Dio _dio;

  LoginProvider() {
    _dio = Dio();
    _dio.options.baseUrl = 'https://k10a704.p.ssafy.io/Wadada/auth';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<Response<dynamic>> kakaoLogin(String code) async {
    try {
      final response = await _dio.post('/login', data: {'code': code});
      return response;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Response<dynamic>> logout() async {
    final _storage = const FlutterSecureStorage();
    final token = await _storage.read(key: 'accessToken');
    _dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await _dio.get('logout');
      return response;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
