import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wadada/common/const/colors.dart';

class MyMap extends StatefulWidget{
  // const SingleFreeRun({super.key, required this.time, required this.dist});
  final String appKey;
  ValueNotifier<double> totalDistanceNotifier = ValueNotifier<double>(0.0);
  ValueNotifier<double> speedNotifier = ValueNotifier<double>(0.0);
  ValueNotifier<double> paceNotifier = ValueNotifier<double>(0.0);

  MyMap({super.key, required this.appKey});

  void _updateTotalDistance(double distance) {
    totalDistanceNotifier.value += distance;
    // print(totalDistanceNotifier.value);
    // print('업데이트');
  }

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  double? currentLatitude;
  double? currentLongitude;

  double totalDistance = 0.0;
  double? previousLatitude;
  double? previousLongitude;

  DateTime? previousTime;
  late DateTime startTime;

  KakaoMapController? mapController;
  StreamSubscription<Position>? positionStream;
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  // Set<PolyLine> polylines = {};

  @override
  void initState() {
    super.initState();

    AuthRepository.initialize(
      appKey: widget.appKey,
      // baseUrl: widget.baseUrl,
    );

    startTime = DateTime.now();

    _startTrackingLocation();
  }

  Future<void> _startTrackingLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location services are disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) throw Exception('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied; we cannot request permissions.');
    }

    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );

    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
      if (position != null) {
        setState(() {
          previousLatitude = currentLatitude;
          previousLongitude = currentLongitude;
          currentLatitude = position.latitude;
          currentLongitude = position.longitude;

          if (previousLatitude != null && previousLongitude != null) {
            double distance = Geolocator.distanceBetween(
              previousLatitude!,
              previousLongitude!,
              currentLatitude!,
              currentLongitude!,
            );
            
            totalDistance += distance;
            Duration timeDiff = DateTime.now().difference(previousTime!);
            double totalTime = DateTime.now().difference(startTime).inSeconds.toDouble();
            
            // 속도
            double currentSpeed = distance / timeDiff.inSeconds;
            widget.speedNotifier.value = currentSpeed;

            // 페이스
            double paceInSecondsPerKm = totalTime / (totalDistance / 1000);
            widget.paceNotifier.value = paceInSecondsPerKm;

            widget._updateTotalDistance(distance);
          }
          previousTime = DateTime.now();

          if (mapController != null) {
            LatLng newCenter = LatLng(currentLatitude!, currentLongitude!);
            mapController!.setCenter(newCenter);
            Polyline existingPolyline = polylines.first;
            existingPolyline.points?.add(newCenter);
          }

          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    // 스트림 구독 해제
    positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentLatitude == null || currentLongitude == null) {
      return Center(
        child: CircularProgressIndicator(
          color: GREEN_COLOR,
        ),
      );
    }

    return SizedBox(
        width: 400,
        height: 230,
        child: KakaoMap(
          onMapCreated: (controller) {
          mapController = controller;

          markers.add(Marker(
            markerId: UniqueKey().toString(),
            latLng: LatLng(currentLatitude!, currentLongitude!),
            width: 50,
            height: 54,
            offsetX: 15,
            offsetY: 44,
            markerImageSrc:
              // 'https://w7.pngwing.com/pngs/96/889/png-transparent-marker-map-interesting-places-the-location-on-the-map-the-location-of-the-thumbnail.png',
              'https://github.com/jinddobaegi/algo/assets/103355863/323a6acf-5b7b-4cf0-8b79-0807fd6080aa',
              // 'assets/images/shoes.png',
          ));

          polylines.add(
            Polyline(
              polylineId: 'polyline1',
              points: [],
              strokeColor: Color(0xff386DFF),
              strokeOpacity: 1,
              strokeWidth: 10,
              strokeStyle: StrokeStyle.solid,
            ),
          );

            setState(() {});
          },

          polylines: polylines.toList(),
          markers: markers.toList(),
          center: LatLng(currentLatitude ?? 37.501307, currentLongitude ?? 127.039622),
          // center: currentLocation,
        ),
      );
    }
}