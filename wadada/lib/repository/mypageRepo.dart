import 'package:dio/src/response.dart';
import 'package:wadada/models/mypage.dart';
import 'package:wadada/provider/mypageProvider.dart';

//어떤 api가 있는지 정리
abstract class AbstractMypageRepository {
  Future<MonthlyRecord> getMonthlyRecord(DateTime date);
  Future<SingleDetail> getSingleDetail(RecordRequest req);
  Future<MultiDetail> getMultiDetail(RecordRequest req);
  Future<MarathonDetail> getMarathonDetail(RecordRequest req);
}

class MypageRepository implements AbstractMypageRepository {
  final MypageAPI mypageAPI;

  MypageRepository({
    required this.mypageAPI,
  });

  @override
  Future<MarathonDetail> getMarathonDetail(RecordRequest req) async {
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
  Future<MultiDetail> getMultiDetail(RecordRequest req) async {
    try {
      Response res = await mypageAPI.getMultiDetail(req);
      return MultiDetail.fromJson(res.data);
    } catch (e) {
      print("ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<SingleDetail> getSingleDetail(RecordRequest req) async {
    try {
      Response res = await mypageAPI.getSingleDetail(req);
      return SingleDetail.fromJson(res.data);
    } catch (e) {
      print("ERROR: $e");
      rethrow;
    }
  }
}
