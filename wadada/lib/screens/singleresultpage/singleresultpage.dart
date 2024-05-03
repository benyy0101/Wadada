import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:wadada/common/const/colors.dart';

class SingleResult extends StatefulWidget {
  final Duration elapsedTime;
  final List<LatLng> coordinates;
  final LatLng? startLocation;
  final LatLng? endLocation;
  final String totaldist;

  const SingleResult({
    super.key,
    required this.elapsedTime,
    required this.coordinates,
    this.startLocation,
    this.endLocation,
    required this.totaldist,
  });

  @override
  _SingleResultState createState() => _SingleResultState();
}

class _SingleResultState extends State<SingleResult> {
  KakaoMapController? mapController;
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    // Format time
    int hours = widget.elapsedTime.inHours % 24;
    int minutes = widget.elapsedTime.inMinutes % 60;
    int seconds = widget.elapsedTime.inSeconds % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = seconds.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '나의 기록',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(height: 15),
            // Time and route section
            _buildTimeAndRouteSection(formattedHours, formattedMinutes, formattedSeconds),
            SizedBox(height: 40),
            // Distance section
            _buildDistanceSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeAndRouteSection(String hours, String minutes, String seconds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '소요 시간',
          style: TextStyle(
            color: GRAY_500,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        _buildTimeDisplay(hours, minutes, seconds),
        SizedBox(height: 40),
        Text(
          '나의 경로',
          style: TextStyle(
            color: GRAY_500,
            fontSize: 17,
            fontWeight: FontWeight.bold,
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
      height: 230,
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
                width: 50,
                height: 54,
                offsetX: 15,
                offsetY: 44,
                markerImageSrc: 'https://github.com/jjeong41/t/assets/103355863/955c2700-e829-426d-a4a0-4806d3f5c085',
              ),
            );
          }

          if (widget.endLocation != null) {
            markers.add(
              Marker(
                markerId: 'end',
                latLng: widget.endLocation!,
                width: 50,
                height: 54,
                offsetX: 15,
                offsetY: 44,
                markerImageSrc: 'https://github.com/jjeong41/t/assets/103355863/955c2700-e829-426d-a4a0-4806d3f5c085',
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
              LatLng(minLat, minLng), // southwest
              LatLng(maxLat, maxLng)  // northeast
          ];
          mapController?.fitBounds(bounds);
        },
        polylines: polylines.toList(),
        markers: markers.toList(),
        center: widget.startLocation ?? widget.coordinates[0],
      ),
    );
  }

  }

  Widget _buildDistanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          '이동 거리',
          style: TextStyle(
            color: GRAY_500,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        // Text(
        //   '${totaldist} km',
        //   style: TextStyle(
        //     color: GRAY_500,
        //     fontSize: 17,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // Add content here for displaying distance
      ],
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
      width: 54,
      height: 65,
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
