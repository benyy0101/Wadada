import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:wadada/common/component/lineChart.dart';
import 'package:wadada/common/component/tabbars.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/models/DistanceHeartbeat.dart';
import 'package:wadada/screens/singlemainpage/single_main.dart';
// import 'package:fl_chart/fl_chart.dart';

class SingleResult extends StatefulWidget {
  final Duration elapsedTime;
  final List<LatLng> coordinates;
  final LatLng? startLocation;
  final LatLng? endLocation;
  final String totaldist;
  final List<Map<String, double>> distanceSpeed;
  final List<Map<String, double>> distancePace;
  final List<DistanceHeartbeat>? distanceHeartbeatList;

  const SingleResult({
    super.key,
    required this.elapsedTime,
    required this.coordinates,
    this.startLocation,
    this.endLocation,
    required this.totaldist,
    required this.distanceSpeed,
    required this.distancePace,
    this.distanceHeartbeatList,
  });

  @override
  _SingleResultState createState() => _SingleResultState();
}

class _SingleResultState extends State<SingleResult> {
  KakaoMapController? mapController;
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int hours = widget.elapsedTime.inHours % 24;
    int minutes = widget.elapsedTime.inMinutes % 60;
    int seconds = widget.elapsedTime.inSeconds % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = seconds.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '나의 기록',
          style: TextStyle(
            color: GRAY_900,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(height: 15),
            _buildTimeAndRouteSection(
                formattedHours, formattedMinutes, formattedSeconds),
            SizedBox(height: 40),
            // _buildDistanceSection(),
            SizedBox(
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '이동 거리',
                    style: TextStyle(
                      color: GRAY_500,
                      fontSize: 19,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${widget.totaldist} km',
                    style: TextStyle(
                      color: GREEN_COLOR,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '속도 (km/h)',
                style: TextStyle(
                  color: GRAY_500,
                  fontSize: 19,
                ),
              ),
              SizedBox(height: 10),
              _buildSpeedLineChart(),
            ]),
            SizedBox(height: 30),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '페이스',
                style: TextStyle(
                  color: GRAY_500,
                  fontSize: 19,
                ),
              ),
              SizedBox(height: 10),
              _buildPaceLineChart(),
            ]),
            SizedBox(height: 30),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '심박수',
                style: TextStyle(
                  color: GRAY_500,
                  fontSize: 19,
                ),
              ),
              SizedBox(height: 10),
              _buildHearbeatLineChart(),
            ]),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Get.to(MainLayout());
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => SingleMain(),
                //   ),
                // );
              },
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: GREEN_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    child: Text('종료하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ))),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeAndRouteSection(
      String hours, String minutes, String seconds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          '소요 시간',
          style: TextStyle(
            color: GRAY_500,
            fontSize: 19,
          ),
        ),
        SizedBox(height: 5),
        _buildTimeDisplay(hours, minutes, seconds),
        SizedBox(height: 40),
        Text(
          '나의 경로',
          style: TextStyle(
            color: GRAY_500,
            fontSize: 19,
          ),
        ),
        SizedBox(height: 5),
        _buildKakaoMap(),
      ],
    );
  }

  Widget _buildTimeDisplay(String hours, String minutes, String seconds) {
    return Row(
      children: [
        _TimeContainer(digit: hours[0]),
        SizedBox(width: 5),
        _TimeContainer(digit: hours[1]),
        SizedBox(width: 7),
        Text(':', style: _timeSeparatorStyle),
        SizedBox(width: 7),
        _TimeContainer(digit: minutes[0]),
        SizedBox(width: 5),
        _TimeContainer(digit: minutes[1]),
        SizedBox(width: 7),
        Text(':', style: _timeSeparatorStyle),
        SizedBox(width: 7),
        _TimeContainer(digit: seconds[0]),
        SizedBox(width: 5),
        _TimeContainer(digit: seconds[1]),
      ],
    );
  }

  Widget _buildKakaoMap() {
    return SizedBox(
      width: 400,
      height: 250,
      child: KakaoMap(
        onMapCreated: (controller) {
          mapController = controller;

          Polyline polyline = Polyline(
            polylineId: 'polyline1',
            points: widget.coordinates,
            strokeColor: Color(0xff386DFF),
            strokeOpacity: 0.5,
            strokeWidth: 10,
            strokeStyle: StrokeStyle.solid,
          );
          polylines.add(polyline);

          if (widget.startLocation != null) {
            markers.add(
              Marker(
                markerId: 'start',
                latLng: widget.startLocation!,
                width: 30,
                height: 54,
                markerImageSrc:
                    'https://github.com/jjeong41/t/assets/103355863/4e6d205d-694e-458c-b992-8ea7c27b85b1',
              ),
            );
          }

          if (widget.endLocation != null) {
            markers.add(
              Marker(
                markerId: 'end',
                latLng: widget.endLocation!,
                width: 30,
                height: 54,
                markerImageSrc:
                    'https://github.com/jjeong41/t/assets/103355863/f52baea5-c46e-47ec-b541-80a0b081f6db',
              ),
            );
          }

          setState(() {});

          double minLat = double.infinity;
          double maxLat = -double.infinity;
          double minLng = double.infinity;
          double maxLng = -double.infinity;

          for (LatLng latLng in widget.coordinates) {
            minLat = minLat > latLng.latitude ? latLng.latitude : minLat;
            maxLat = maxLat < latLng.latitude ? latLng.latitude : maxLat;
            minLng = minLng > latLng.longitude ? latLng.longitude : minLng;
            maxLng = maxLng < latLng.longitude ? latLng.longitude : maxLng;
          }

          LatLng southWest = LatLng(minLat, minLng);
          LatLng northEast = LatLng(maxLat, maxLng);

          List<LatLng> bounds = [
            LatLng(minLat, minLng),
            LatLng(maxLat, maxLng)
          ];
          mapController?.fitBounds(bounds);
        },
        polylines: polylines.toList(),
        markers: markers.toList(),
        center: widget.startLocation ?? widget.coordinates[0],
      ),
    );
  }

  TextStyle get _timeSeparatorStyle {
    return TextStyle(
      color: GREEN_COLOR,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _TimeContainer({required String digit}) {
    return Container(
      decoration: BoxDecoration(
        color: OATMEAL_COLOR,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 43,
      height: 60,
      child: Center(
        child: Text(
          digit,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: GREEN_COLOR,
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedLineChart() {
    List<ChartData> myChartData = widget.distanceSpeed.map((data) {
      return ChartData(
          // (data['dist']! * 1000).toInt(),
          data['dist']! / 1000,
          data['speed']! * 3.6);
    }).toList();

    return LineChart<ChartData>(
      chartData: myChartData,
      metrics: '',
      graphType: 'speed',
    );
  }

  double formatPaceAsDecimal(double paceInSecondsPerKm) {
    int minutes = paceInSecondsPerKm ~/ 60;
    double seconds = paceInSecondsPerKm % 60;

    double paceInMinutesAndSeconds = minutes + (seconds / 60);
    return paceInMinutesAndSeconds;
  }

  Widget _buildPaceLineChart() {
    List<ChartData> myChartData = widget.distancePace.map((data) {
      return ChartData(
          data['dist']! / 1000, formatPaceAsDecimal(data['pace']!));
    }).toList();

    // LineChart 사용
    return LineChart<ChartData>(
      chartData: myChartData,
      metrics: 'km/h',
      graphType: 'pace',
    );
  }

  Widget _buildHearbeatLineChart() {
    if (widget.distanceHeartbeatList == null || widget.distanceHeartbeatList!.isEmpty) {
      return Text("심박수 데이터가 없습니다.", style: TextStyle(fontSize: 16, color: Colors.grey));
    }

    List<ChartData> myChartData = widget.distanceHeartbeatList!.map((data) {
      return ChartData(data.distance / 1000, double.parse(data.heartbeat));
    }).toList();


    return LineChart<ChartData>(
      chartData: myChartData,
      metrics: 'bpm',
      graphType: 'heartbeat',
    );
  }
}
