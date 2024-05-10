import 'dart:io';

import 'package:dio/src/response.dart';
import 'package:wadada/models/mypage.dart';
import 'package:wadada/provider/mypageProvider.dart';

//어떤 api가 있는지 정리
abstract class AbstractMypageRepository {
  Future<MonthlyRecord> getMonthlyRecord(DateTime date);
  Future<SingleDetail> getSingleDetail(int req);
  Future<MultiDetail> getMultiDetail(int req);
  Future<MarathonDetail> getMarathonDetail(int req);
  Future<String> uploadImage(File file);
}

class MypageRepository implements AbstractMypageRepository {
  final MypageAPI mypageAPI;

  MypageRepository({
    required this.mypageAPI,
  });

  @override
  Future<MarathonDetail> getMarathonDetail(int req) async {
    try {
      Response res = await mypageAPI.getMarathonDetail(req);
      return MarathonDetail.fromJson(res.data);
    } catch (e) {
      print("ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<MonthlyRecord> getMonthlyRecord(DateTime date) async {
    try {
      Response res = await mypageAPI.getMonthlyRecord(date);

      return MonthlyRecord.fromJson(res.data);
    } catch (e) {
      print("ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<MultiDetail> getMultiDetail(int req) async {
    try {
      Response res = await mypageAPI.getMultiDetail(req);
      return MultiDetail.fromJson(res.data);
    } catch (e) {
      print("ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<SingleDetail> getSingleDetail(int req) async {
    try {
      Response res = await mypageAPI.getSingleDetail(req);
      return SingleDetail.fromJson(res.data);
    } catch (e) {
      print("ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<String> uploadImage(File file) async {
    try {
      Response res = await mypageAPI.imageUpload(file);
      return res.data['child_picture'];
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
