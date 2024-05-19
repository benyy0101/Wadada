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
    List<Widget> buildHashtags(String? tags) {
    if (tags == null || tags.isEmpty) {
      return [];
    }

    return tags
      .split('#')
        .where((tag) => tag.isNotEmpty)
        .map((tag) => Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: DARK_GREEN_COLOR,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('#$tag', style: TextStyle(color: Colors.white)),
            ))
        .toList();
    }

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 15),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Icon(Icons.location_on, color: DARK_GREEN_COLOR),
                          SizedBox(height: 10),
                          Icon(Icons.people, color: DARK_GREEN_COLOR),
                          SizedBox(height: 10),
                          Icon(
                            roomInfo.roomSecret != -1
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
                            roomInfo.roomSecret != -1 ? '비밀방' : '공개방',
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
            if (roomInfo.roomTag!.isNotEmpty) SizedBox(height: 15), // Add SizedBox if hashtags are present
            if (roomInfo.roomTag!.isNotEmpty)
              Row(
                children: [
                  SizedBox(width: 15),
                  Expanded(
                    child: Wrap(
                      spacing: 8.0, // spacing between hashtags
                      children: buildHashtags(roomInfo.roomTag),
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