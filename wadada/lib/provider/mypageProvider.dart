import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wadada/models/mypage.dart';

const serverUrl = "";

class MypageAPI extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://your-api-url.com';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 10);
  }

  Future<Response> getMonthlyRecord(DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM').format(date);
    final response = await get('record/$formattedDate');
    return response;
  }

  Future<Response> getSingleDetail(RecordRequest req) async {
    final response = await post('record/single', req);
    return response;
  }

  Future<Response> getMultiDetail(RecordRequest req) async {
    final response = await post('record/multi', req);
    return response;
  }

  Future<Response> getMarathonDetail(RecordRequest req) async {
    final response = await post('users/marathon', req);
    return response;
  }
}
