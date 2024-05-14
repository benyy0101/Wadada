import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:wadada/models/mypage.dart';

const serverUrl = "";

class MypageAPI {
  late Dio _dio;
  final storage = FlutterSecureStorage();

  MypageAPI() {
    _dio = Dio();
    _dio.options.baseUrl = 'https://k10a704.p.ssafy.io/Wadada/record/';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<void> setAuth() async {
    _dio.options.headers['Authorization'] =
        await storage.read(key: 'accessToken');
  }

  Future<Response<dynamic>> getMonthlyRecord(DateTime date) async {
    await setAuth();
    String formattedDate = DateFormat('yyyy-MM').format(date);
    final response = await _dio.get('${formattedDate}');
    return response;
  }

  Future<Response<dynamic>> getSingleDetail(int req) async {
    await setAuth();
    final response = await _dio.get('single/${req}');
    return response;
  }

  Future<Response<dynamic>> getMultiDetail(int req) async {
    await setAuth();
    final response = await _dio.get('multi/${req}');
    return response;
  }

  Future<Response<dynamic>> getMarathonDetail(int req) async {
    await setAuth();
    final response = await _dio.get('marathon/${req}');
    return response;
  }

  Future<Response> imageUpload(String path) async {
    await setAuth();
    _dio.options.headers['Content-Type'] = 'multipart/form-data';

    final formData = FormData.fromMap(
        {'profileImageFile': await MultipartFile.fromFile(path!)});

    final response = await _dio.post('image', data: formData);
    return response;
  }
}
