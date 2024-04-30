import 'package:get/get.dart';
import 'package:wadada/models/singlepage.dart';
import 'package:wadada/provider/singlepageProvider.dart';

//어떤 api가 있는지 정리
abstract class AbstractMypageRepository {
  Future<RecentRecord> getRecentRecord();
}

class SingleRepository extends GetxService implements AbstractMypageRepository {
  final SinglepageAPI singlepageAPI;

  SingleRepository({
    required this.singlepageAPI,
  });

  @override
  Future<RecentRecord> getRecentRecord() async {
    try {
      Response res = await singlepageAPI.getRecentRecord();
      return RecentRecord.fromJson(res.body);
    } catch (e) {
      print("ERROR: $e");
      rethrow;
    }
  }
}
