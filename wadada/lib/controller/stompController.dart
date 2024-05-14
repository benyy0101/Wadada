import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/models/stomp.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:wadada/repository/multiRepo.dart';
import 'package:wadada/screens/multimainpage/multi_main.dart';
import 'package:wadada/screens/multirunpage/multirunpage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StompController extends GetxController {
  StompClient client = StompClient(config: StompConfig(url: ''));
  StompClient newclient = StompClient(config: StompConfig(url: ''));
  StompClient flagclient = StompClient(config: StompConfig(url: ''));
  bool isNewClientActivated = false;
  final int roomIdx;

  String accessToken = '';
  late String serverUrl;
  int receivedRoomSeq = 0;
  // RxBool gameStartResponse = false.obs;  // 게임 시작 메시지
  // RxBool gamego = false.obs;
  ValueNotifier<bool> gameStartResponse = ValueNotifier<bool>(false);
  ValueNotifier<bool> gamego = ValueNotifier<bool>(false);
  ValueNotifier<String> requestinfo = ValueNotifier<String>('');
  ValueNotifier<List<dynamic>> ranking = ValueNotifier<List<dynamic>>([]);
  ValueNotifier<List<dynamic>> memberInfoList = ValueNotifier<List<dynamic>>([]);
  ValueNotifier<Set<dynamic>> multiflag = ValueNotifier<Set<dynamic>>({});
  late dynamic unsubscribeFn;
  RxList<CurrentMember> members = <CurrentMember>[].obs;
  MultiRepository repo = MultiRepository(provider: MultiProvider());
  bool isStart = false;
  bool get1 = false;
  bool getflag = false;
  late bool isOwner = false;
  late int numReady = 0;
  CurrentMember itMe = CurrentMember(
      memberNickname: 'memberNickname',
      memberGender: 'memberGender',
      memberProfileImage: 'memberProfileImage',
      memberId: 'memberId',
      memberLevel: -1,
      memberReady: false,
      manager: false);
  final storage = FlutterSecureStorage();
  StompController({required this.roomIdx});

  @override
  Future<void> onInit() async {
    super.onInit();
    await dotenv.load(fileName: 'assets/env/.env');
    final storage = FlutterSecureStorage();
    serverUrl = dotenv.env['SERVER_URL'] ?? "";
    accessToken = await storage.read(key: 'accessToken') ?? 'no Token';
  }

  void attend(int roomIdx) async {
    print("-------------attend-------------");
    String? accessToken = await storage.read(key: 'accessToken');
    // bool unsubscribed = false;
    client = StompClient(
      config: StompConfig.sockJS(
        url: dotenv.env['STOMP_URL']!,
        onConnect: (p0) {
          client.subscribe(
            destination: '/sub/attend/$roomIdx',
            headers: {
              'Authorization': accessToken ??
                  'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
            },
            callback: (frame) async {
              try {
                print("Incoming Messages:--------------------");

                //에러메세지: 해당방에 입장해 있거나, 이미 나간 방일때
                Map<String, dynamic> res = jsonDecode(frame.body!);
                print('-----res[body]-----------------');
                print(res['body']);
                if (res['body'].runtimeType == String &&
                    res['statusCodeValue'] != 200) {
                  throw Exception(jsonDecode(frame.body!)['body']);
                } else if (res['body'].runtimeType == String) {
                  res['body'] = jsonDecode(res['body']);
                }

                print(res['body'][roomIdx.toString()]);

                if (res['body'] == null) {
                  print("null임");
                  return;
                }

                if (res['body']['message'] == "게임이 시작되었습니다") {
                  print("multigo");
                  gamego.value = true;
                  // print('gamego 값 ${gamego.value}');
                  // print('방장인지 아닌지 $isOwner');

                  // if (isOwner) {
                    // client.deactivate();
                    // print('여기까지는 됨');

                    int newRoomSeq = res['body']['roomSeq'];
                    print('roomSeq $newRoomSeq');

                    setupNewSubscription(newRoomSeq);
                    client.deactivate();

                  return;
                }

                //게임 스타트
                if (res['body']['action'] == "/Multi/start") {
                  print("multistart");
                  gameStartResponse.value = true;
                  print('start 응답 값 : ${gameStartResponse.value}');
                  receivedRoomSeq = res['body']['roomSeq'];
                  // print(res['body']);
                  return;
                }
                //Null값 처리
                if (res['body'][roomIdx.toString()] == null) {
                  // throw Exception("해당 방의 정보가 없습니다.");
                  return;
                }

                //참가자 list화
                fromJson(res['body'][roomIdx.toString()]);

                countReady();
                await checkOwner();
                await findMe();
              } catch (e) {
                print(e);
                rethrow;
              }
            },
          );
        },
// Pass the onConnect method as a callback here
        webSocketConnectHeaders: {
          "transports": ["websocket"],
          'Authorization': accessToken ??
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
        },
        stompConnectHeaders: {
          'Authorization': accessToken ??
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    client.activate();
    Future.delayed(Duration(milliseconds: 2000), () {
      try {
        if (client.isActive) {
          client.send(destination: '/pub/attend/$roomIdx');
          print("--------------published $roomIdx------------------");
        } else {
          throw Exception("서버가 준비되어 있지 않습니다.");
        }
      } catch (e) {
        print(e);
      }
    });
  }

  void setupNewSubscription(int newRoomSeq) async {
    // client.deactivate();
    if (client.isActive) {
      client.deactivate();
    }
    String? accessToken = await storage.read(key: 'accessToken');
    newclient = StompClient(
      config: StompConfig.sockJS(
        url: dotenv.env['STOMP_URL']!,
        onConnect: (p0) {
          newclient.subscribe(
            destination: '/sub/game/$newRoomSeq',
            headers: {
              'Authorization': accessToken ??
                  'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
            },
            callback: (frame) async {
              try {
                if (isOwner) {
                  final url = Uri.parse('https://k10a704.p.ssafy.io/Multi/game/rank/$newRoomSeq');
                  final storage = FlutterSecureStorage();
                  String? accessToken = await storage.read(key: 'accessToken');
                  final dio = Dio();

                  try {
                    dynamic response;
                    if (get1 == false) {
                      response = await dio.get(url.toString(),
                          options: Options(headers: {
                            'Content-Type': 'application/json',
                            'Accept': 'application/json',
                            'authorization': accessToken
                          }));
                      get1 = true;
                    }
                    // print('확인 ${response.data}');

                    // if (response.statusCode == 200) {
                      Map<String, dynamic> resp = jsonDecode(frame.body!);
                      if (resp['body'].runtimeType == String &&
                          resp['statusCodeValue'] != 200) {
                        throw Exception(jsonDecode(frame.body!)['body']);
                      } else if (resp['body'].runtimeType == String) {
                        resp['body'] = jsonDecode(resp['body']);
                      }
                      print('최종 ${resp['body']}');

                      if (resp['body']['message'] == "멤버INFO요청") {
                        requestinfo.value = resp['body']['message'];
                        requestinfo.value = '';
                      }

                      if (resp['body']['memberInfo'] != null) {
                        ranking.value = resp['body']['memberInfo'];
                        print('랭킹 ${ranking.value}');
                      }

                      // requestinfo.value = resp['body']['action'];
                      // requestinfo.value = '';
                      // ranking.value = resp['body']['memberInfo'];
                      // print('body ${resp['body']}');
                      // print('랭킹 ${ranking.value}');
                      // print('랭킹 타입 ${ranking.value.runtimeType}');

                      // final data = response.data as Map<String, dynamic>;
                      // final jsonData = jsonDecode(response.data);
                      // print('제발요 ${response.data.runtimeType}');
                      // print('디코딩된 JSON 데이터: $jsonData');
                      // print('방장 통신 성공');
                      // return data;
                  //   } else if (response.statusCode == 204) {
                  //     print('204');
                  //     // return {};
                  //   } else {
                  //     print('서버 요청 실패: ${response.statusCode}');
                  //     // return {};
                  //   }
                  } catch (e) {
                    print('ㅇㅇ 요청 처리 중 에러 발생: $e');
                    // return {};
                  }
                }

              } catch(e) {
                print(e);
              }
            },
          );
        },
        webSocketConnectHeaders: {
          "transports": ["websocket"],
          'Authorization': accessToken ??
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
        },
        stompConnectHeaders: {
          'Authorization': accessToken ??
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
        },
        onWebSocketError: (dynamic error) => print('WebSocket error: $error'),
      ),
    );

    newclient.activate();
  // }
  }

  // void flaginfo(int roomIdx) async {
  //   // client.deactivate();
  //   // if (client.isActive) {
  //   //   client.deactivate();
  //   // }
  //   String? accessToken = await storage.read(key: 'accessToken');
  //   flagclient = StompClient(
  //     config: StompConfig.sockJS(
  //       url: dotenv.env['STOMP_URL']!,
  //       onConnect: (p0) {
  //         flagclient.subscribe(
  //           destination: '/Multi/ws/pub/flag/$roomIdx',
  //           headers: {
  //             'Authorization': accessToken ??
  //                 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
  //           },
  //           callback: (frame) async {
  //             try {
  //               Map<String, dynamic> res = jsonDecode(frame.body!);
  //               if (res['body'].runtimeType == String &&
  //                   res['statusCodeValue'] != 200) {
  //                 throw Exception(jsonDecode(frame.body!)['body']);
  //               } else if (res['body'].runtimeType == String) {
  //                 res['body'] = jsonDecode(res['body']);
  //               }

  //               final url = Uri.parse('https://k10a704.p.ssafy.io/Multi/flag');
  //               final storage = FlutterSecureStorage();
  //               String? accessToken = await storage.read(key: 'accessToken');
  //               final dio = Dio();
  //               dynamic response;

  //               if (res['body']['message'] == "깃발요청") {
  //                 if (getflag == false) {
  //                   final requestBody = jsonEncode({
  //                     "roomIdx": roomIdx,
  //                     // "latitude": totalDistanceInt,
  //                     // "longitude": intelapsedseconds,
  //                   });

  //                   response = await dio.post(
  //                     url.toString(),
  //                     data: requestBody,
  //                     options: Options(headers: {
  //                       'Content-Type': 'application/json',
  //                       'Accept': 'application/json',
  //                       'authorization': accessToken,
  //                     }),
  //                   );

  //                   getflag = true;
  //                 }
  //               }

  //               if (res['body'] == "사용자 위치 정보가 없습니다") {
  //                 multiflag.value = {};
  //               }

  //               if (res['body']['latitude'] != null) {
  //                 multiflag.value = res['body'];
  //               }
                
  //               } catch(e) {
  //                 print(e);
  //               }

  //             // } catch(e) {
  //             //   print(e);
  //             },
  //           // },
  //         );
  //       },
  //       webSocketConnectHeaders: {
  //         "transports": ["websocket"],
  //         'Authorization': accessToken ??
  //             'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
  //       },
  //       stompConnectHeaders: {
  //         'Authorization': accessToken ??
  //             'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
  //       },
  //       onWebSocketError: (dynamic error) => print('WebSocket error: $error'),
  //     ),
  //   );

  //   flagclient.activate();
  // // }
  // }

  void fromJson(List<dynamic> list) {
    if (list.isNotEmpty) {
      List<CurrentMember> temp = list.map((item) {
        return CurrentMember.fromJson(item);
      }).toList();
      members.clear();
      for (var element in temp) {
        members.add(element);
      }
    }
  }

  Future<void> findMe() async {
    String kakaoId = await storage.read(key: 'kakaoId') ?? "nothing";
    for (var element in members) {
      if (element.memberId == kakaoId) {
        itMe = element;
      }
    }
  }

  void countReady() {
    numReady = 0;
    for (var item in members) {
      if (item.memberReady == true) numReady++;
    }
  }

  void out(int roomIdx) {
    print("--------------socket OUT $roomIdx---------");
    client.send(destination: '/pub/out/$roomIdx');
  }

  void ready(int roomIdx) {
    client.send(destination: '/pub/change/ready/$roomIdx');
  }

  void gameStart() {
    print("-----------------start game $roomIdx------------");
    client.send(destination: '/pub/game/start/$roomIdx');
  }

  void setGameStart() {
    isStart = !isStart;
  }

  void disconnect() {
    print("-----controller deactivated---------");
    out(roomIdx);
    client.deactivate();
  }

  Future<void> checkOwner() async {
    String kakaoId = await storage.read(key: 'kakaoId') ?? "nothing";
    // print(kakaoId);
    if (kakaoId == "nothing") {
      throw Exception("카카오 아이디가 없습니다.");
    }
    for (var element in members) {
      // print(element.memberId);
      if (element.memberId == kakaoId && element.manager == true) {
        isOwner = true;
      }
    }
    print('isOwner------------------------------');
    print(isOwner);
  }

  Future<void> onConnect() async {
    String? accessToken = await storage.read(key: 'accessToken');
    print("-----------------acwesbot-------------");
    print(accessToken);
  }

  @override
  void dispose() {
    out(roomIdx);
    disconnect();
  }
}
