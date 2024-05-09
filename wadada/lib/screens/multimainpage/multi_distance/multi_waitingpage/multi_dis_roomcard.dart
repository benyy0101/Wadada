import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/multiController.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:wadada/repository/multiRepo.dart';

// ignore: must_be_immutable
class DisRoomInfoCard extends StatelessWidget {
  SimpleRoom roomInfo;

  DisRoomInfoCard({super.key, required this.roomInfo});

  @override
  Widget build(BuildContext context) {
    Get.put(MultiController(repo: MultiRepository(provider: MultiProvider())));
    return GetBuilder<MultiController>(builder: (MultiController controller) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: OATMEAL_COLOR,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center, // 세로 기준 가운데 정렬
              children: [
                // 방 제목
                Expanded(
                  flex: 1, // 왼쪽 부분 (방 코드)의 크기 조절
                  child: Text(
                    roomInfo.roomTitle,
                    style: TextStyle(
                      color: DARK_GREEN_COLOR,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                // 세부 정보
                Expanded(
                  flex: 3, // 오른쪽 부분 (세부 정보)의 크기 조절
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Icon(Icons.location_on, color: DARK_GREEN_COLOR),
                          SizedBox(height: 10),
                          Icon(Icons.people, color: DARK_GREEN_COLOR),
                          SizedBox(height: 10),
                          Icon(
                            roomInfo.roomSecret != null
                                ? Icons.lock
                                : Icons.lock_open,
                            color: DARK_GREEN_COLOR,
                          )
                        ],
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('거리',
                              style: TextStyle(
                                  color: DARK_GREEN_COLOR,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 12),
                          Text('참여 인원',
                              style: TextStyle(
                                  color: DARK_GREEN_COLOR,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 12),
                          Text(
                            roomInfo.roomSecret != null ? '비밀방' : '공개방',
                            style: TextStyle(
                              color: DARK_GREEN_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${roomInfo.roomDist}  km'),
                          SizedBox(height: 12),
                          Text(
                              '${roomInfo.nowRoomPeople} / ${roomInfo.roomPeople}'),
                          SizedBox(height: 12),
                          Text(''),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
