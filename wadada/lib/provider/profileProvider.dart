import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wadada/models/profile.dart';

class ProfileProvider {
  late Dio _dio;
  final storage = FlutterSecureStorage();
  String accessToken = '';
  ProfileProvider() {
    _dio = Dio();
    _dio.options.baseUrl = 'https://k10a704.p.ssafy.io/Wadada/profile';
    _dio.options.headers['Content-Type'] = 'application/json';
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

  Future<Response<dynamic>> profileDelete() async {
    await setAuth();
    final response = await _dio.delete(
      'profile',
    );
    return response;
  }

  Future<Response<dynamic>> profilePatch(Profile profile) async {
    await setAuth();
    final response = await _dio.patch('', data: profile);
    return response;
  }

  Future<Response<dynamic>> profileGet() async {
    await setAuth();
    final response = await _dio.get('');
    return response;
  }

  Future<Response> nickNameValidate(String nickName) async {
    await setAuth();
    final response = await _dio.get('/${nickName}');
    return response;
  }
}
