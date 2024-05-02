import 'package:flutter/material.dart';
import 'package:wadada/common/component/lineChart.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class SingleResult extends StatelessWidget{
  final Duration elapsedTime;
  final List<LatLng> coordinates;

  const SingleResult({super.key, required this.elapsedTime, required this.coordinates});

  String _formatTime(int value) {
      return value.toString().padLeft(2, '0');
    }

  List<String> _splitTime(String timePart) {
    return timePart.split('');
  }
  
  Widget TimeContainer(String digit) {
    return Container(
      decoration: BoxDecoration(
        color: OATMEAL_COLOR,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 54,
      height: 65,
      child: Center(
        child: Text(digit,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: GREEN_COLOR,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int hours = elapsedTime.inHours % 24;
    int minutes = elapsedTime.inMinutes % 60;
    int seconds = elapsedTime.inSeconds % 60;

    String formattedHours = _formatTime(hours);
    String formattedMinutes = _formatTime(minutes);
    String formattedSeconds = _formatTime(seconds);

    List<String> splithours = _splitTime(formattedHours);
    List<String> splitminutes = _splitTime(formattedMinutes);
    List<String> splitseconds = _splitTime(formattedSeconds);

    Set<Polyline> polylines = {};
    KakaoMapController? mapController;

    return Scaffold(
      appBar: AppBar(
        title: Text('나의 기록',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          )
        ),
        centerTitle: true,
        // backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(
          children: [
            SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('소요 시간',
                  style: TextStyle(
                    color: GRAY_500,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  )
                ),
                SizedBox(height: 5),
                Container(
                  child: Row(
                    children: [
                      TimeContainer(splithours[0]),
                      SizedBox(width: 5),
                      TimeContainer(splithours[1]),

                      SizedBox(width: 7),
                      Text(':', 
                        style: TextStyle(
                          color: GREEN_COLOR,
                          fontSize: 30, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                      SizedBox(width: 7),
                      
                      TimeContainer(splitminutes[0]),
                      SizedBox(width: 5),
                      TimeContainer(splitminutes[1]),

                      SizedBox(width: 7),
                      Text(':',
                        style: TextStyle(
                          color: GREEN_COLOR,
                          fontSize: 30, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                      SizedBox(width: 7),

                      TimeContainer(splitseconds[0]),
                      SizedBox(width: 5),
                      TimeContainer(splitseconds[1]),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('나의 경로',
                  style: TextStyle(
                    color: GRAY_500,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  )
                ),
                SizedBox(height: 5),
                SizedBox(
                  width: 400,
                  height: 230,
                  child: KakaoMap(
                    onMapCreated: ((controller) async {
                      mapController = controller;

                      polylines.add(
                        Polyline(
                          polylineId: 'polyline_${polylines.length}',
                          points: [LatLng(37.5015633, 127.0387), LatLng(37.5015612, 127.0386466), LatLng(37.5015125, 127.0384261)],
                          strokeColor: Colors.blue,
                          strokeOpacity: 0.4,
                          strokeWidth: 15,
                          strokeStyle: StrokeStyle.solid,
                        ),
                      );

                      print(coordinates);
                      
                    }
                    ),
                    polylines: polylines.toList(),
                    center: coordinates[0],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('이동 거리',
                  style: TextStyle(
                    color: GRAY_500,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  )
                ),
                SizedBox(height: 5),
              ],
            ),
          ],
        )
      )
    );
  }
}