import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/models/multiroom.dart';

class MyMap extends StatefulWidget {
  // const SingleFreeRun({super.key, required this.time, required this.dist});

  final String appKey;
  LatLng? startLocation;
  LatLng? endLocation;
  List<LatLng> coordinates = [];
  LatLng centerplace;
  final int moderoom;

  List<LatLng> getCoordinates() {
    return coordinates;
  }

  ValueNotifier<double> totalDistanceNotifier = ValueNotifier<double>(0.0);
  ValueNotifier<double> speedNotifier = ValueNotifier<double>(0.0);
  ValueNotifier<double> paceNotifier = ValueNotifier<double>(0.0);
  ValueNotifier<LatLng?> startLocationNotifier = ValueNotifier<LatLng?>(null);
  ValueNotifier<LatLng?> endLocationNotifier = ValueNotifier<LatLng?>(null);
  ValueNotifier<LatLng?> currentLocationNotifier = ValueNotifier<LatLng?>(null);

  List<Map<String, double>> distanceSpeed = [];
  List<Map<String, double>> distancePace = [];

  List<Map<String, double>> getdistanceSpeed() {
    return distanceSpeed;
  }

  List<Map<String, double>> getdistancePace() {
    return distancePace;
  }

  MyMap(
      {super.key,
      required this.appKey,
      required this.centerplace,
      required this.moderoom});

  void _updateTotalDistance(double distance) {
    totalDistanceNotifier.value += distance;
  }

  @override
  State<MyMap> createState() => MyMapState();

  // void disposeState(GlobalKey<MyMapState> key) {
  //   final MyMapState? state = key.currentState;
  //   print("dispose");
  //   print(state);
  //   state?.dispose();
  // }
}

class MyMapState extends State<MyMap> {
  double? currentLatitude;
  double? currentLongitude;

  double totalDistance = 0.0;
  double? previousLatitude;
  double? previousLongitude;

  DateTime? previousTime;
  late DateTime startTime;

  KakaoMapController? mapController;
  StreamSubscription<Position>? positionStream;
  // StreamSubscription<geolocator.Position>? realTimePositionStream;
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
    print("-----------initState------------------");
    startGame();
    // _startTrackingLocation();
    // _subscribeToRealTimeLocationUpdates();
  }

  Future<void> _startTrackingLocation() async {
    // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) throw Exception('Location services are disabled.');

    // LocationPermission permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) throw Exception('Location permissions are denied');
    // }

    // if (permission == LocationPermission.deniedForever) {
    //   throw Exception('Location permissions are permanently denied; we cannot request permissions.');
    // }

    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );
    print("--------start Tracking-----------------------");
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (position != null) {
        print("--------position start----------------");
        setState(() {
          previousLatitude = currentLatitude;
          previousLongitude = currentLongitude;
          currentLatitude = position.latitude;
          currentLongitude = position.longitude;

          if (widget.startLocation == null) {
            widget.startLocation = LatLng(currentLatitude!, currentLongitude!);
            widget.startLocationNotifier.value = widget.startLocation;
          }

          widget.endLocation = LatLng(currentLatitude!, currentLongitude!);
          widget.currentLocationNotifier.value =
              LatLng(currentLatitude!, currentLongitude!);

          if (previousLatitude != null && previousLongitude != null) {
            double distance = Geolocator.distanceBetween(
              previousLatitude!,
              previousLongitude!,
              currentLatitude!,
              currentLongitude!,
            );

            totalDistance += distance;
            Duration timeDiff = DateTime.now().difference(previousTime!);
            double totalTime =
                DateTime.now().difference(startTime).inSeconds.toDouble();
            // double totalDistanceKm = totalDistance / 1000;
            // double roundedTotalDistanceKm = double.parse(totalDistanceKm.toStringAsFixed(2));

            // 속도 (m/s)
            double currentSpeed = 0;
            if (timeDiff.inSeconds != 0) {
              currentSpeed = distance / timeDiff.inSeconds;
            }
            widget.speedNotifier.value = currentSpeed * 3.6;
            // double roundedSpeed = double.parse(currentSpeed.toStringAsFixed(2));

            // 페이스(s/km)
            double paceInSecondsPerKm = 0;
            if (totalDistance != 0) {
              paceInSecondsPerKm = totalTime / (totalDistance / 1000);
            }

            widget.paceNotifier.value = paceInSecondsPerKm;

            widget._updateTotalDistance(distance);

            if (totalDistance.isFinite &&
                !totalDistance.isNaN &&
                currentSpeed.isFinite &&
                !currentSpeed.isNaN) {
              widget.distanceSpeed.add({
                "dist": totalDistance,
                "speed": currentSpeed,
              });
            }

            if (totalDistance.isFinite &&
                !totalDistance.isNaN &&
                paceInSecondsPerKm.isFinite &&
                !paceInSecondsPerKm.isNaN) {
              widget.distancePace.add({
                "dist": totalDistance,
                "pace": paceInSecondsPerKm,
              });
            }
          }
          // }

          previousTime = DateTime.now();

          void updateLocation(double latitude, double longitude) {
            widget.coordinates.add(LatLng(currentLatitude!, currentLongitude!));
          }

          updateLocation(currentLatitude!, currentLongitude!);

          if (mapController != null) {
            LatLng newCenter = LatLng(currentLatitude!, currentLongitude!);
            mapController!.setCenter(newCenter);
            Polyline existingPolyline = polylines.first;
            existingPolyline.points?.add(newCenter);
          }

          markers.removeWhere((marker) => marker.markerId == 'currentlocation');

          markers.add(Marker(
            markerId: 'currentlocation',
            latLng: LatLng(currentLatitude!, currentLongitude!),
            width: 30,
            height: 30,
            offsetX: 15, // width의 절반 값을 지정합니다.
            offsetY: 15,
            markerImageSrc:
                'https://github.com/jjeong41/t/assets/103355863/5ff2a217-8cbc-4e41-b6c2-0ff12103b40b',
            zIndex: 15,
          ));

          setState(() {});
        });
      }
    });

    // positionStream = Geolocator.getPositionStream(locationSettings: realTimeLocationSettings).listen((Position? position) {
    //   if (position != null) {
    //     setState(() {
    //       LatLng newLocation = LatLng(position.latitude, position.longitude);

    //       markers.removeWhere((marker) => marker.markerId == 'currentLocationMarker');

    //       markers.add(Marker(
    //           markerId: 'currentLocationMarker',
    //           latLng: newLocation,
    //           width: 30,
    //           height: 30,
    //           markerImageSrc: 'https://github.com/jjeong41/t/assets/103355863/5ff2a217-8cbc-4e41-b6c2-0ff12103b40b',
    //       ));

    //       mapController?.setCenter(newLocation);

    //       setState(() {});
    //   });
    //   }
    // });
  }

  // Future<void> _subscribeToRealTimeLocationUpdates() async {
  //   final realTimeLocationSettings = LocationSettings(
  //     accuracy: LocationAccuracy.high,
  //     distanceFilter: 0,
  //   );

  //   realTimePositionStream = Geolocator.getPositionStream(
  //     locationSettings: realTimeLocationSettings,
  //   ).listen((Position? position) {
  //     if (position != null) {
  //       LatLng newLocation = LatLng(position.latitude, position.longitude);

  //       _updateMapWithNewLocation(newLocation);
  //     } else {
  //       print("-------------------no position found------------------------");
  //     }
  //   });
  // }

  // void _updateMapWithNewLocation(LatLng newLocation) {
  //   markers.removeWhere((marker) => marker.markerId == 'currentLocationMarker');

  //   markers.add(Marker(
  //     markerId: 'currentLocationMarker',
  //     latLng: newLocation,
  //     width: 30,
  //     height: 30,
  //     markerImageSrc:
  //         'https://github.com/jjeong41/t/assets/103355863/5ff2a217-8cbc-4e41-b6c2-0ff12103b40b',
  //   ));

  //   mapController?.setCenter(newLocation);
  //   setState(() {});
  // }

  void _stopTrackingLocation() {
    positionStream?.cancel();
    positionStream = null;
    print("Location tracking stopped.");
  }

  void startGame() {
    startTime = DateTime.now();
    _startTrackingLocation();
    print('지도 시작');
  }

  void endGame() {
    _stopTrackingLocation();
  }

  @override
  void dispose() {
    print("really cancelling positions?");
    _stopTrackingLocation();
    super.dispose();
  }

  // @override
  // void dispose() {
  //   // 스트림 구독 해제
  //   print("really cancelling positions?");
  //   // realTimePositionStream?.cancel();
  //   positionStream?.cancel();
  //   // _stopTrackingLocation();
  //   super.dispose();
  // }

  @override
  void didPop() {
    // Your logic when MyWidget is popped from the navigation stack
    print('MyWidget popped from the navigation stack');
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

    // double mapWidth = widget.runmode == 2 ? 600 : 400;
    // double mapHeight = widget.runmode == 2 ? 350 : 230;

    return SizedBox(
      width: 400,
      height: 230,
      child: KakaoMap(
        onMapCreated: (controller) {
          mapController = controller;

          markers.add(Marker(
            markerId: 'start',
            latLng: LatLng(currentLatitude!, currentLongitude!),
            width: 50,
            height: 54,
            offsetX: 15,
            offsetY: 44,
            markerImageSrc:
                // 'https://w7.pngwing.com/pngs/96/889/png-transparent-marker-map-interesting-places-the-location-on-the-map-the-location-of-the-thumbnail.png',
                'https://github.com/jjeong41/t/assets/103355863/955c2700-e829-426d-a4a0-4806d3f5c085',
            zIndex: 12,
          ));

          // markers.add(Marker(
          //   markerId: 'currentLocationMarker',
          //   latLng: LatLng(currentLatitude!, currentLongitude!),
          //   width: 30,
          //   height: 30,
          //   // offsetX: 15,
          //   // offsetY: 44,
          //   markerImageSrc:
          //     // 'https://w7.pngwing.com/pngs/96/889/png-transparent-marker-map-interesting-places-the-location-on-the-map-the-location-of-the-thumbnail.png',
          //     'https://github.com/jjeong41/t/assets/103355863/955c2700-e829-426d-a4a0-4806d3f5c085',
          // ));

          if (widget.moderoom == 3) {
            markers.add(Marker(
              markerId: 'flag',
              latLng: widget.centerplace,
              width: 50,
              height: 54,
              offsetX: 15,
              offsetY: 44,
              markerImageSrc:
                  'https://github.com/jjeong41/t/assets/103355863/37743a13-bbd0-4744-9e7c-7ef262fc14c0',
              zIndex: 10,
            ));
          }

          polylines.add(
            Polyline(
              polylineId: 'polyline1',
              points: [],
              strokeColor: Color(0xff386DFF),
              strokeOpacity: 0.5,
              strokeWidth: 10,
              strokeStyle: StrokeStyle.solid,
            ),
          );

          setState(() {});
        },

        polylines: polylines.toList(),
        markers: markers.toList(),
        center: LatLng(
            currentLatitude ?? 37.501307, currentLongitude ?? 127.039622),
        // center: currentLocation,
      ),
    );
  }
}
