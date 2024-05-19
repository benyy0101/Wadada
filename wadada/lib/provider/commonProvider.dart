import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wadada/models/profile.dart';

class ProfileProvider {
  late Dio _dio;
  final storage = FlutterSecureStorage();

  ProfileProvider() {
    _dio = Dio();
    _dio.options.baseUrl = 'https://k10a704.p.ssafy.io/Common';
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Authorization'] = storage.read(key: 'accessToken');
    
  }

  Future<Response<dynamic>> profileDelete(String alt, String lat) async {
    final response =
        await _dio.post('/landmark', data: {"altitude": alt, "latitude": lat});
    return response;
  }
}
