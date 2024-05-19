import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wadada/models/marathon.dart';
import 'package:wadada/models/profile.dart';

class MarathonProvider {
  late Dio _dio;
  final storage = FlutterSecureStorage();
  String accessToken = '';
  MarathonProvider() {
    _dio = Dio();
    _dio.options.baseUrl = 'https://k10a704.p.ssafy.io/Marathon';
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Authorization'] = storage.read(key: 'accessToken');
  }

  Future<void> setAuth() async {
    _dio.options.headers['Authorization'] =
        await storage.read(key: 'accessToken');
    accessToken = _dio.options.headers['Authorization'];
    print(_dio.options.headers['Authorization']);
  }

  //MARAHTON-001
  Future<Response<dynamic>> marathonGetRoom() async {
    await setAuth();

    final response = await _dio.get('');
    return response;
  }

//MARAHTON-002
  Future<Response<dynamic>> marathonGetParticipant(String marathonSeq) async {
    await setAuth();
    final response = await _dio.get(
      '/participate/$marathonSeq',
    );

    return response;
  }

  //MARATHON-003
  Future<Response<dynamic>> marathonRank(String marathonSeq) async {
    await setAuth();
    final response = await _dio.get(
      '/rank/$marathonSeq',
    );

    return response;
  }

  //MARAHTON-005
  Future<Response<dynamic>> attendMarathon(String marathonSeq) async {
    await setAuth();
    final response = await _dio.get(
      '/attend/$marathonSeq',
    );
    return response;
  }

  //MARAHTON-005:
  Future<Response<dynamic>> marathonStart(MarathonStart start) async {
    await setAuth();
    final response = await _dio.post('/start', data: start.toJson());
    return response;
  }

  //MARAHTON-005:
  Future<Response<dynamic>> marathonEnd(Marathon data) async {
    //await setAuth();
    _dio.options.headers['Authorization'] = accessToken;
    final response = await _dio.post('/result', data: data.toJson());
    return response;
  }

  Future<Response<dynamic>> distSave(DistanceRecord data) async {
    await setAuth();
    final response = await _dio.post('/post', data: data.toJson());
    return response;
  }
}
