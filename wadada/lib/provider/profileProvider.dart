import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wadada/models/profile.dart';

class ProfileProvider {
  late Dio _dio;
  final storage = FlutterSecureStorage();

  ProfileProvider() {
    _dio = Dio();
    _dio.options.baseUrl = 'https://k10a704.p.ssafy.io/Wadada/profile';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<void> setAuth() async {
    _dio.options.headers['Authorization'] =
        await storage.read(key: 'accessToken');
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
