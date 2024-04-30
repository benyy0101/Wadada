import 'package:get/get.dart';
import 'package:intl/intl.dart';

const serverUrl = "";

class SinglepageAPI extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://your-api-url.com';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 10);
  }

  Future<Response> getRecentRecord() async {
    final response = await get('Single');
    return response;
  }

  Future<Response> postRecordStart() async {
    final response = await get('Single/start');
    return response;
  }

  Future<Response> postRecordResult() async {
    final response = await get('Single/result');
    return response;
  }
}
