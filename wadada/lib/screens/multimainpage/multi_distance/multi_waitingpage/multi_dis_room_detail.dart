import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
// import 'dart:ffi'; 
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/loginController.dart';
import 'package:wadada/controller/multiController.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/provider/loginProvider.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:wadada/controller/stompController.dart';
import 'package:wadada/repository/loginRepo.dart';
import 'package:wadada/repository/multiRepo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wadada/screens/multimainpage/multi_main.dart';
import 'package:wadada/screens/multirunpage/multierror.dart';
import 'package:wadada/screens/multirunpage/multirunpage.dart';
import 'package:wadada/screens/singlemainpage/single_main.dart';
import 'package:wadada/screens/singlerunpage/single_free_run.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:wadada/screens/multimainpage/multi_distance/multi_waitingpage/multi_dis_waitroom.dart';

class MultiRoomDetail extends StatefulWidget {
  SimpleRoom roomInfo;

  MultiRoomDetail({super.key, required this.roomInfo});

  @override
  _MultiRoomDetailState createState() =>
      _MultiRoomDetailState(roomInfo: roomInfo);
}

class _MultiRoomDetailState extends State<MultiRoomDetail> {
  SimpleRoom roomInfo;
  late StompController controller;
  late MultiController multiController;
  KakaoMapController? mapController;
  List<String> tags = [];
  String titleText = '';
  String optionMetric = '';
  String roomOption = '';
  final storage = FlutterSecureStorage();
  ValueNotifier<bool> centerloading = ValueNotifier<bool>(false);

  bool isHost = false;
  bool isButtonPressed = false;
  bool toStart = false;
  bool showMap = false;

  Set<Marker> markers = {};
  double centerlat = 0.0;
  double centerlong = 0.0;

  _MultiRoomDetailState({
    required this.roomInfo,
  }) {
    splitTags();
    initControllers();
    print("-----------------initiating websocket----------------");
    controller.attend(roomInfo.roomIdx);
    setRoomInfo();
  }

  void initControllers() {
    controller = StompController(roomIdx: roomInfo.roomIdx);
    multiController =
        MultiController(repo: MultiRepository(provider: MultiProvider()));
  }

  void splitTags() {
    List<String> temp = roomInfo.roomTag!.split('#');

    for (var item in temp) {
      if (item != '') {
        tags.add("#$item");
      }
    }
  }

  void setRoomInfo() {
    print(roomInfo.roomMode);
    if (roomInfo.roomMode == 1) {
      titleText = '거리모드 - 멀티';
      roomOption = '거리';
      optionMetric = 'km';
    } else if (roomInfo.roomMode == 2) {
      titleText = '시간모드 - 멀티';
      roomOption = '시간';
      optionMetric = '분';
    } else {
      titleText = '만남모드 - 멀티';
      roomOption = '거리';
      optionMetric = 'km';
    }
  }

  @override
  void initState() {
    super.initState();

    AuthRepository.initialize(
      appKey: 'f508d67320677608aea64e5d6a9a3005',
      // baseUrl: widget.baseUrl,
    );

    // if (centerlat == 0.0 && centerlong == 0.0) {
    //   setState(() {
    //     toStart = false;
    //   });
    // }

    controller.gameStartResponse.addListener(() {
      bool value = controller.gameStartResponse.value;
      if (value == true) {
        _checkAndRequestLocationPermission();
      }
      // print('Gamego value changed: $value');
    });

    controller.flagrequested.addListener(() {
      bool value = controller.flagrequested.value;
      if (value == true) {
        sendlocationforflag();
        centerloading.value = true;
        print("활성화 true");
      } else {
        centerloading.value = false;
        print("활성화 false");
      }
    });

    controller.userlatitude.addListener(() {
      double userlat = controller.userlatitude.value;
      // setState(() {
      // 특정 변수를 업데이트
      // 예를 들어, 목적지 추천 버튼 옆에 보여줄 변수를 업데이트
      // centerlat = userlat;
      if (mounted) {
        setState(() {
          centerlat = userlat;
        });
      }
    });

    controller.userlongitude.addListener(() {
      double userlong = controller.userlongitude.value;
      // setState(() {
      // 특정 변수를 업데이트
      // 예를 들어, 목적지 추천 버튼 옆에 보여줄 변수를 업데이트
      // centerlong = userlong;
      if (mounted) {
        setState(() {
          centerlong = userlong;
        });
      }
    });
    // controller.attend(roomInfo.roomIdx, isRecommendButtonPressed);
  }

  Future<void> sendlocationforflag() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 비활성화되어 있으면 사용자에게 위치 서비스를 활성화하도록 요청
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        // 사용자가 위치 서비스를 활성화하지 않으면 앱을 종료
        return;
      }
    }

    // 현재 위치 권한 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // 사용자가 위치 권한을 영구적으로 거부한 경우 설정 앱으로 이동하여 사용자가 권한을 변경할 수 있도록 안내
      await Geolocator.openAppSettings();
      return;
    }

    if (permission == LocationPermission.denied) {
      // 사용자가 위치 권한을 거부한 경우 권한을 요청
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String appKey = dotenv.env['APP_KEY'] ?? '';

    final dio = Dio();
    final url = Uri.parse('https://k10a704.p.ssafy.io/Multi/flag');
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    final requestBody = jsonEncode({
      "roomIdx": roomInfo.roomIdx,
      "latitude": position.latitude,
      "longitude": position.longitude,
    });

    try {
      final response = await dio.post(
        url.toString(),
        data: requestBody,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': accessToken,
        }),
      );

      // 응답 확인
      if (response.statusCode == 200) {
        // 요청이 성공적으로 처리되었을 때의 동작
        print('Location sent successfully');
      } else {
        // 요청이 실패했을 때의 동작
        print('Failed to send location. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // 오류 처리
      print('Error sending location: $error');
    }
  }

  Future<void> _checkAndRequestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 비활성화되어 있으면 사용자에게 위치 서비스를 활성화하도록 요청
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        Get.to(() => MultiError(controller: controller));
        return;
      }
    }

    // 현재 위치 권한 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // 사용자가 위치 권한을 영구적으로 거부한 경우 설정 앱으로 이동하여 사용자가 권한을 변경할 수 있도록 안내
      Get.to(() => MultiError(controller: controller));
      // await Geolocator.openAppSettings();
      return;
    }

    if (permission == LocationPermission.denied) {
      // 사용자가 위치 권한을 거부한 경우 권한을 요청
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // 권한이 부여되지 않으면 사용자에게 메시지를 표시하고 앱을 종료
        // 권한을 받지 못하면 런을 시작할 수 없음
        Get.to(() => MultiError(controller: controller));
        return;
      }
    }

    if (mounted) {
      // print('입력받은 시간 ${roomInfo.roomTime}');
      // print('입력받은 거리 ${roomInfo.roomDist}');
      String appKey = dotenv.env['APP_KEY'] ?? '';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiRun(
            time: roomInfo.roomTime,
            dist: roomInfo.roomDist,
            appKey: appKey,
            controller: controller,
            multiController: multiController,
            roomInfo: roomInfo,
            centerlat: centerlat,
            centerlong: centerlong,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(titleText, style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(width: 20),
              // 방 이름
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  child: IntrinsicWidth(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 5),
                        child: IconButton(
                          icon: Icon(
                            Icons.link,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            //클릭하면 복사 슛
                          },

                          // controller.getMultiRoomsByMode(1).roomList[roomIdx],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // ElevatedButton(onPressed: null, child: Text('테스트')),
              // 방 정보
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: OATMEAL_COLOR,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.info_outline,
                              color: DARK_GREEN_COLOR, size: 25),
                          SizedBox(width: 10),
                          Text('방 정보',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: DARK_GREEN_COLOR,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          // 첫 번째 컬럼
                          Column(
                            children: [
                              SizedBox(height: 7),
                              Icon(
                                Icons.location_on,
                                color: DARK_GREEN_COLOR,
                                size: 28,
                              ),
                              SizedBox(height: 20),
                              Icon(
                                Icons.people,
                                color: DARK_GREEN_COLOR,
                                size: 28,
                              ),
                              SizedBox(height: 20),
                              Icon(
                                roomInfo.roomSecret != -1
                                    ? Icons.lock
                                    : Icons.lock_open,
                                color: DARK_GREEN_COLOR,
                                size: 28,
                              ),
                            ],
                          ),
                          SizedBox(width: 15),
                          // 두 번째 컬럼
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                                Text(
                                  roomOption,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: DARK_GREEN_COLOR),
                                ),
                              SizedBox(height: 20),
                              Text(
                                '참여 인원',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: DARK_GREEN_COLOR),
                              ),
                              SizedBox(height: 20),
                              Text(
                                roomInfo.roomSecret == -1 ? '공개방' : '비밀방',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: DARK_GREEN_COLOR),
                              ),
                            ],
                          ),
                          SizedBox(width: 40),
                          // 세 번째 컬럼
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              if (roomInfo.roomMode == 1 || roomInfo.roomMode == 3)
                                Text(
                                  '${roomInfo.roomDist} $optionMetric',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: DARK_GREEN_COLOR),
                                ),
                              if (roomInfo.roomMode == 2)
                                Text(
                                    '${roomInfo.roomTime} $optionMetric',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: DARK_GREEN_COLOR),
                                  ),
                              // if (roomInfo.roomMode != 3)
                                SizedBox(height: 20),
                              //현재인원 받아와야 하는 곳
                              Obx(
                                () => Text(
                                    '${controller.members.length} / ${roomInfo.roomPeople}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: DARK_GREEN_COLOR)),
                              ),
                              SizedBox(height: 20),
                              Text('',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: DARK_GREEN_COLOR)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 3, // Number of columns
                        shrinkWrap:
                            true, // Ensure that the GridView only occupies the space it needs
                        physics:
                            NeverScrollableScrollPhysics(), // Disable scrolling
                        children: List.generate(tags.length, (index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 2),
                            child: Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: DARK_GREEN_COLOR,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    tags[index],
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 참가자
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: OATMEAL_COLOR,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.flag,
                            color: DARK_GREEN_COLOR,
                            size: 28,
                          ),
                          SizedBox(width: 10),
                          Text('참가자',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: DARK_GREEN_COLOR,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 20),
                      Visibility(
                        visible: roomInfo.roomMode == 3,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ValueListenableBuilder<bool>(
                                  valueListenable: centerloading,
                                  builder: (context, isButtonEnabled, _) {
                                    return ValueListenableBuilder<bool>(
                                      valueListenable: controller.isOwnerNotifier,
                                      builder: (context, isOwnerValue, _) {
                                        print('isOwner: $isOwnerValue');
                                        print('isButtonEnabled: $isButtonEnabled');

                                        return ElevatedButton(
                                          onPressed: isOwnerValue == false
                                              ? null
                                              : () {
                                                  print('Flag info button pressed');
                                                  print('활성화 $isButtonEnabled');
                                                  if (!isButtonEnabled) {
                                                    controller.isRecommendButtonPressed.value = true;
                                                    setState(() {
                                                      showMap = false;
                                                    });
                                                  }
                                                },
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                              if (isButtonEnabled) {
                                                return Colors.grey;
                                              } else {
                                                return DARK_GREEN_COLOR;
                                              }
                                            }),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            ),
                                          ),
                                          child: const Text(
                                            '목적지 추천',
                                            style: TextStyle(fontSize: 18, color: Colors.white),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                SizedBox(width: 50),
                                ValueListenableBuilder<bool>(
                                  valueListenable: centerloading,
                                  builder: (context, isMapButtonVisible, _) {
                                    return Visibility(
                                      visible: !isMapButtonVisible && (controller.userlatitude.value != 0.0 || controller.userlongitude.value != 0.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showMap = !showMap;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          child: Text(
                                            showMap ? '위치 확인' : '위치 확인',
                                            style: TextStyle(fontSize: 18, color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Visibility(
                              visible: showMap && !centerloading.value,
                              child: ValueListenableBuilder<double>(
                                valueListenable: controller.userlatitude,
                                builder: (context, centerlat, _) {
                                  return ValueListenableBuilder<double>(
                                    valueListenable: controller.userlongitude,
                                    builder: (context, centerlong, _) {
                                      return SizedBox(
                                        width: 400,
                                        height: 230,
                                        child: KakaoMap(
                                          onMapCreated: (mapcontroller) {
                                            mapController = mapcontroller;
                                            markers.clear();
                                            markers.add(Marker(
                                              markerId: 'flag',
                                              latLng: LatLng(centerlat, centerlong),
                                              width: 50,
                                              height: 54,
                                              offsetX: 15,
                                              offsetY: 44,
                                              markerImageSrc: 'https://github.com/jjeong41/t/assets/103355863/37743a13-bbd0-4744-9e7c-7ef262fc14c0',
                                            ));
                                            setState(() {});
                                          },
                                          markers: markers.toList(),
                                          center: LatLng(centerlat, centerlong),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ]
                        ),
                      ),

                      SizedBox(height: 10),
                      Obx(() {
                        final members = controller.members;
                        if (members.isEmpty) {
                          // Show a loading indicator or a placeholder
                          return Center(
                            child:
                                CircularProgressIndicator(), // Or any other placeholder widget
                          );
                        } else {
                          // Show the list when data is available
                          return ListView.builder(
                            itemCount: members.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final member = members[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(member.memberProfileImage),
                                  ),
                                  title: Text(
                                    member.memberNickname,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: member.manager
                                          ? Colors.deepPurpleAccent
                                          : DARK_GREEN_COLOR,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '레벨: ${member.memberLevel}',
                                    style: TextStyle(
                                      color: DARK_GREEN_COLOR,
                                    ),
                                  ),
                                  trailing: member.manager
                                      ? GameOwner()
                                      : PlayerCondition(
                                          isReady: member.memberReady),
                                ),
                              );
                            },
                          );
                        }
                      }),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),

              //팀원일때 준비 버튼
              Obx(() {
                if (!controller.isOwner.value) {
                  return TextButton(
                    onPressed: () {
                      controller.ready(roomInfo.roomIdx);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          isButtonPressed ? Colors.grey[400] : GREEN_COLOR,
                      minimumSize:
                          ui.Size(MediaQuery.of(context).size.width * .9, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '준비완료',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                } else {
                  bool canStartGame = controller.numReady == controller.members.length - 1;
                  bool isCenterLocationSet = widget.roomInfo.roomMode == 3 ? (centerlat != 0.0 && centerlong != 0.0) : true;

                  return TextButton(
                    onPressed:
                          canStartGame && isCenterLocationSet
                            ? () {
                                controller.gameStart();
                              }
                            : null,
                    style: TextButton.styleFrom(
                      minimumSize:
                          ui.Size(MediaQuery.of(context).size.width * .9, 50),
                      foregroundColor: Colors.white,
                      backgroundColor:
                          canStartGame && isCenterLocationSet
                              ? GREEN_COLOR
                              : Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '시작하기',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }
              }),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  controller.out(roomInfo.roomIdx);
                  Get.to(MultiDisWait(roomMode: roomInfo.roomMode));
                  //Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      Colors.grey[400], // GRAY_400 대신 실제 색상 값을 사용하세요.
                  minimumSize:
                      ui.Size(MediaQuery.of(context).size.width * .9, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.exit_to_app),
                    Text("  방 나가기 ", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerCondition extends StatelessWidget {
  bool isReady;
  PlayerCondition({super.key, required this.isReady});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isReady ? DARK_GREEN_COLOR : GRAY_400,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isReady ? '준비완료' : '대기중',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}

class GameOwner extends StatelessWidget {
  const GameOwner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: DARK_GREEN_COLOR,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "방장",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
