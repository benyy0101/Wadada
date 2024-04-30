import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wadada/models/mypage.dart';
import 'package:wadada/models/singlepage.dart';
import 'package:wadada/repository/singlepageRepo.dart';

class SinglepageController extends GetxController {
  final SingleRepository singlerepository;

  // Rx 타입으로 변경
  final Rx<RecentRecord> _recentrecord = Rx<RecentRecord>(RecentRecord(
      recordTime: Duration.zero,
      recordDist: -1,
      recordSpeed: [],
      recordHeartbeat: [],
      recordPace: [],
  ));

  SinglepageController({
    required this.singlerepository,
  });

  @override
  void onInit() {
    super.onInit();
    // fetchMonthlyRecords();
    fetchRecentRecord();
  }

  //singlepage001
  void fetchRecentRecord() async {
    try {
      _recentrecord.value = await singlerepository.getRecentRecord();
    } catch (e) {
      print(e);
    }
  }
}
