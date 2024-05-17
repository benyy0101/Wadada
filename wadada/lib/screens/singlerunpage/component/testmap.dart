// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:kakao_map_plugin/kakao_map_plugin.dart';
// import 'package:wadada/common/const/colors.dart';
// import 'package:location/location.dart' as location;
// // import 'package:geolocator/geolocator.dart' as geolocator;
// import 'dart:math';

// class MyMap1 extends StatefulWidget {
//   final String appKey;
//   LatLng? startLocation;
//   LatLng? endLocation;
//   List<LatLng> coordinates = [];

//   List<LatLng> getCoordinates() {
//     return coordinates;
//   }

//   ValueNotifier<double> totalDistanceNotifier = ValueNotifier<double>(0.0);
//   ValueNotifier<double> speedNotifier = ValueNotifier<double>(0.0);
//   ValueNotifier<double> paceNotifier = ValueNotifier<double>(0.0);
//   ValueNotifier<LatLng?> startLocationNotifier = ValueNotifier<LatLng?>(null);
//   ValueNotifier<LatLng?> endLocationNotifier = ValueNotifier<LatLng?>(null);

//   List<Map<String, double>> distanceSpeed = [];
//   List<Map<String, double>> distancePace = [];

//   List<Map<String, double>> getdistanceSpeed() {
//     return distanceSpeed;
//   }

//   List<Map<String, double>> getdistancePace() {
//     return distancePace;
//   }

//   MyMap1({super.key, required this.appKey});

//   void _updateTotalDistance(double distance) {
//     totalDistanceNotifier.value += distance;
//   }

//   @override
//   State<MyMap1> createState() => _MyMap1State();
// }

// class _MyMap1State extends State<MyMap1> {
//   double? currentLatitude;
//   double? currentLongitude;

//   double totalDistance = 0.0;
//   double? previousLatitude;
//   double? previousLongitude;

//   DateTime? previousTime;
//   late DateTime startTime;

//   KakaoMapController? mapController;
//   location.Location locationService = location.Location();
//   StreamSubscription<location.LocationData>? locationStream;
//   // StreamSubscription<geolocator.Position>? realTimePositionStream;
//   Set<Polyline> polylines = {};
//   Set<Marker> markers = {};
//   // Set<PolyLine> polylines = {};

//   @override
//   void initState() {
//     super.initState();

//      AuthRepository.initialize(
//       appKey: widget.appKey,
//       // baseUrl: widget.baseUrl,
//     );


//     // widget.startLocation = null;
//     // widget.endLocation = null;

//     startTime = DateTime.now();
//     _startTrackingLocation();
//   }

//   // Haversine 공식으로 두 점 사이의 거리를 계산하는 함수
//   double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
//       // 지구의 반지름 (km)
//       const double R = 6371.0;

//       // 위도와 경도 차이 계산
//       double dLat = toRadians(lat2 - lat1);
//       double dLon = toRadians(lon2 - lon1);

//       // Haversine 공식에 따라 두 점 사이의 거리를 계산
//       double a = sin(dLat / 2) * sin(dLat / 2) +
//                 cos(toRadians(lat1)) * cos(toRadians(lat2)) *
//                 sin(dLon / 2) * sin(dLon / 2);

//       double c = 2 * atan2(sqrt(a), sqrt(1 - a));

//       // 거리 계산
//       double distance = R * c;

//       // 거리 (km)를 m 단위로 변환하여 반환
//       return distance * 1000;
//   }

//   // 각도(도)를 라디안으로 변환하는 함수
//   double toRadians(double degrees) {
//       return degrees * pi / 180;
//   }

//   Future<void> _startTrackingLocation() async {
//     // 위치 서비스가 활성화되어 있는지 확인
//     bool serviceEnabled = await locationService.serviceEnabled();
//     if (!serviceEnabled) {
//         serviceEnabled = await locationService.requestService();
//         if (!serviceEnabled) {
//             throw Exception('위치 서비스가 비활성화되어 있습니다.');
//         }
//     }

//     // 위치 권한을 확인
//     location.PermissionStatus permission = await locationService.hasPermission();
//     if (permission == location.PermissionStatus.denied) {
//         permission = await locationService.requestPermission();
//         if (permission == location.PermissionStatus.denied) {
//             throw Exception('위치 권한이 거부되었습니다.');
//         }
//     }

//     // 위치 데이터가 변경될 때 호출되는 스트림 구독 시작
//     locationStream = locationService.onLocationChanged.listen((location.LocationData locationData) {
//       setState(() {
//           previousLatitude = currentLatitude;
//           previousLongitude = currentLongitude;
//           currentLatitude = locationData.latitude;
//           currentLongitude = locationData.longitude;

//           // 시작 위치 설정
//           if (widget.startLocation == null) {
//               widget.startLocation = LatLng(currentLatitude!, currentLongitude!);
//               widget.startLocationNotifier.value = widget.startLocation;
//           }

//           // 종료 위치 업데이트
//           widget.endLocation = LatLng(currentLatitude!, currentLongitude!);
//           // widget.endLocationNotifier.value = widget.endLocation;

//           // 경로 추가
//           widget.coordinates.add(LatLng(currentLatitude!, currentLongitude!));

//           // 이전 위치가 존재할 경우 거리 및 속도 계산
//           if (previousLatitude != null && previousLongitude != null) {
//               double distance = haversineDistance(
//                 previousLatitude!,
//                 previousLongitude!,
//                 currentLatitude!,
//                 currentLongitude!,
//               );


//               // 총 거리 업데이트
//               totalDistance += distance;
//               Duration timeDiff = DateTime.now().difference(previousTime!);
//               double totalTime = DateTime.now().difference(startTime).inSeconds.toDouble();

//               // 속도(m/s) 및 페이스(s/km) 계산
//               // double currentSpeed = distance / timeDiff.inSeconds;
//               // double paceInSecondsPerKm = (timeDiff.inSeconds / 60) / (distance / 1000);

//               // 속도 (m/s)
//               double currentSpeed = distance / timeDiff.inSeconds;
//               widget.speedNotifier.value = currentSpeed * 3.6;
//               // double roundedSpeed = double.parse(currentSpeed.toStringAsFixed(2));

//               // 페이스(s/km)

//               double paceInSecondsPerKm; // 변수 선언

//               if (totalTime == 0) {
//                   // totalTime이 0일 경우
//                   paceInSecondsPerKm = 0.0;
//               } else {
//                   // totalTime이 0이 아닐 경우
//                   paceInSecondsPerKm = totalTime / (totalDistance / 1000);
//               }

//               // paceInSecondsPerKm 값을 위에서 계산한 후 사용
//               widget.paceNotifier.value = paceInSecondsPerKm;

//               widget._updateTotalDistance(distance);

//               widget.distanceSpeed.add({
//                   "dist": totalDistance,
//                   "speed": currentSpeed,
//               });

//               widget.distancePace.add({
//                   "dist": totalDistance,
//                   "pace": paceInSecondsPerKm,
//               });

//               previousTime = DateTime.now();

//               void updateLocation(double latitude, double longitude) {
//                 widget.coordinates.add(LatLng(currentLatitude!, currentLongitude!));
//               }

//               updateLocation(currentLatitude!, currentLongitude!);

//               if (mapController != null) {
//                 LatLng newCenter = LatLng(currentLatitude!, currentLongitude!);
//                 mapController!.setCenter(newCenter);
//                 Polyline existingPolyline = polylines.first;
//                 existingPolyline.points?.add(newCenter);
//               }

//               markers.removeWhere((marker) => marker.markerId == 'currentLocation');
//               markers.add(Marker(
//                   markerId: 'currentLocation',
//                   latLng: LatLng(currentLatitude!, currentLongitude!),
//                   width: 30,
//                   height: 30,
//                   offsetX: 15,
//                   offsetY: 15,
//                   markerImageSrc: 'https://github.com/jjeong41/t/assets/103355863/5ff2a217-8cbc-4e41-b6c2-0ff12103b40b',
//                   zIndex: 10,
//               ));
//           }

//           // 현재 위치 마커 업데이트

//           // 경로 업데이트
//           // if (polylines.isNotEmpty) {
//           //     Polyline existingPolyline = polylines.first;
//           //     existingPolyline.points?.add(LatLng(currentLatitude!, currentLongitude!));
//           // }

//           setState(() {});
//       });
//         });
// }


//   @override
//   void dispose() {
//     locationStream?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // 현재 위도와 경도가 없는 경우 로딩 화면 표시
//     if (currentLatitude == null || currentLongitude == null) {
//       return Center(
//         child: CircularProgressIndicator(
//           color: GREEN_COLOR,
//         ),
//       );
//     }

//     // 위치가 있는 경우 지도 표시
//     return SizedBox(
//       width: 400,
//       height: 230,
//       child: KakaoMap(
//         onMapCreated: (controller) {
//           mapController = controller;

//           // 초기 시작 위치에 마커 추가
//           markers.add(Marker(
//               markerId: 'start',
//               latLng: LatLng(currentLatitude!, currentLongitude!),
//               width: 50,
//               height: 54,
//               offsetX: 15,
//               offsetY: 44,
//               markerImageSrc:
//                 'https://github.com/jjeong41/t/assets/103355863/955c2700-e829-426d-a4a0-4806d3f5c085',
//             ),
//           );

//           polylines.add(
//             Polyline(
//               polylineId: 'polyline1',
//               points: [],
//               strokeColor: Color(0xff386DFF),
//               strokeOpacity: 0.5,
//               strokeWidth: 10,
//               strokeStyle: StrokeStyle.solid,
//             ),
//           );

//           // 초기 지도 중심 설정
//           // mapController?.setCenter(LatLng(currentLatitude!, currentLongitude!));

//           setState(() {});
//         },

//         polylines: polylines.toList(),
//         markers: markers.toList(),
//         center: LatLng(currentLatitude!, currentLongitude!),
//       ),
//     );
//   }
// }