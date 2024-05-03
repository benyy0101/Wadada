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
    _dio.options.headers['Authorization'] = storage.read(key: 'accessToken');
  }

  Future<Response<dynamic>> profileDelete(String code) async {
    final response = await _dio.delete(
      'profile',
    );
    return response;
  }

  Future<Response<dynamic>> profilePatch(Profile profile) async {
    final response = await _dio.patch('profile', data: profile);
    return response;
  }

  Future<Response<dynamic>> profileGet(Profile profile) async {
    final response = await _dio.get('profile');
    return response;
  }

  Future<Response> nickNameValidate(String nickName) async {
    final response = await _dio.post('profile', data: nickName);
    return response;
  }
}
