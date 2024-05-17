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
  RxBool isRecommendButtonPressed = false.obs;
  // RxDouble userlatitude = 0.0.obs;
  // RxDouble userlongitude = 0.0.obs;
  RxBool isFlagRequested = false.obs;
  ValueNotifier<bool> flagrequested = ValueNotifier<bool>(false);
  final int roomIdx;

  String accessToken = '';
  late String serverUrl;
  int receivedRoomSeq = 0;
  // RxBool gameStartResponse = false.obs;  // 게임 시작 메시지
  // RxBool gamego = false.obs;
  ValueNotifier<bool> gameStartResponse = ValueNotifier<bool>(false);
  ValueNotifier<bool> gamego = ValueNotifier<bool>(false);
  ValueNotifier<int> requestinfo = ValueNotifier<int>(0);
  ValueNotifier<List<dynamic>> ranking = ValueNotifier<List<dynamic>>([]);
  ValueNotifier<List<dynamic>> memberInfoList = ValueNotifier<List<dynamic>>([]);
  ValueNotifier<Set<dynamic>> multiflag = ValueNotifier<Set<dynamic>>({});
  ValueNotifier<List<dynamic>> centerplace = ValueNotifier<List<dynamic>>([]);
  ValueNotifier<double> userlatitude = ValueNotifier<double>(0.0);
  ValueNotifier<double> userlongitude = ValueNotifier<double>(0.0);
  ValueNotifier<List<dynamic>> flagend = ValueNotifier<List<dynamic>>([]);
  late dynamic unsubscribeFn;
  RxList<CurrentMember> members = <CurrentMember>[].obs;
  MultiRepository repo = MultiRepository(provider: MultiProvider());
  bool isStart = false;
  bool get1 = false;
  bool getflag = false;
  RxBool isOwner = false.obs;
  int numReady = 0;
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
  // late SimpleRoom roomInfo;

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

                ever(isRecommendButtonPressed, (isPressed) {
                  // print("@@@@@@@@@@@@@@ $isPressed");
                  // print("////////////////// $isRecommendButtonPressed");
                  isPressed = isRecommendButtonPressed.value;
                  if (isPressed) {
                    client.send(destination: '/pub/flag/$roomIdx');
                    print('목적지 추천 버튼이 눌렸으므로 깃발 요청을 보냅니다.');
                    isRecommendButtonPressed.value = false; // 상태 변수 초기화
                    // print(isRecommendButtonPressed);
                    // print(isRecommendButtonPressed);
                  }

                });

                print('깃발 요청 오면 여깅 ${res['body']}');

                // print(res['body'][roomIdx.toString()]);

                // 깃발
                if (res['body']['message'] == "깃발요청") {
                  flagrequested.value = true;
                  print('나 방장임? $isOwner');
                }

                if (res['body']['message'] == "사용자 위치 정보가 없습니다") {
                  flagrequested.value = false;
                }

                if (res['body']['latitude'] != null) {
                  flagrequested.value = false;
                  print('깃발 위치 받아옴 ${res['body']}');
                  userlatitude.value = res['body']['latitude'];
                  print('${userlatitude.value}');
                  userlongitude.value = res['body']['longitude'];
                  print('방장인지 아닌지 확인 $isOwner');
                }

                // attend
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

                    client.deactivate();
                    // await Future.delayed(Duration(seconds: 2));

                    setupNewSubscription(newRoomSeq);
                    // client.deactivate();

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

  //  void sendFlagRequest(int roomIdx) {
  //     client.send(destination: 'https://k10a704.p.ssafy.io/Multi/ws/pub/flag/$roomIdx');
  //     print('목적지 추천 버튼이 눌렸으므로 깃발 요청을 보냅니다.');
  //     isRecommendButtonPressed = false.obs; // 상태 변수 초기화
  // }

  void setupNewSubscription(int newRoomSeq) async {
    // client.deactivate();
    // if (client.isActive) {
    //   client.deactivate();
    // }
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
                  final url = Uri.parse('https://k10a704.p.ssafy.io/Multi/game/rank/$newRoomSeq');
                  final storage = FlutterSecureStorage();
                  String? accessToken = await storage.read(key: 'accessToken');
                  final dio = Dio();

                  try {
                    dynamic response;
                    if (isOwner.value) {
                      if (get1 == false) {
                        response = await dio.get(url.toString(),
                            options: Options(headers: {
                              'Content-Type': 'application/json',
                              'Accept': 'application/json',
                              'authorization': accessToken
                            }));
                        get1 = true;
                      }
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
                        requestinfo.value += 1 ;
                        // requestinfo.value = '';
                        print('dd');
                      }

                      if (resp['body']['memberInfo'] != null) {
                        ranking.value = resp['body']['memberInfo'];
                        print('랭킹 ${ranking.value}');
                      }

                      // if (resp['body']['message'] == "ㅇㅇ") {
                        // flagend.value = resp['body']['memberInfo'];
                      // }
                  } catch (e) {
                    print('ㅇㅇ 요청 처리 중 에러 발생: $e');
                    // return {};
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
  }

//   void flaginfo(int roomIdx) {
//   try {
//     if (client.isActive) {
//       client.send(destination: 'https://k10a704.p.ssafy.io/Multi/ws/pub/flag/$roomIdx');
//       print("--------------깃발 요청-----------------");
//     } else {
//       throw Exception("깃발 요청 x");
//     }
//   } catch (e) {
//     print(e);
//   }
// }

//   void flaginfo(int roomIdx) async {
//   try {
//     if (client.isActive) {
//       String? accessToken = await storage.read(key: 'accessToken');
      
//       client.subscribe(
//         destination: '/sub/flag/$roomIdx',
//         headers: {
//           'Authorization': accessToken ??
//               'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
//         },
//         callback: (frame) async {
//           try {
//             Map<String, dynamic> res = jsonDecode(frame.body!);
//             if (res['body'].runtimeType == String &&
//                 res['statusCodeValue'] != 200) {
//               throw Exception(jsonDecode(frame.body!)['body']);
//             } else if (res['body'].runtimeType == String) {
//               res['body'] = jsonDecode(res['body']);
//             }

//             print("응답 수신: ${res['body']}");

//             // 응답 처리 로직 추가
//             if (res['body']['message'] == "깃발요청") {
//               if (!getflag) {
//                 final url = Uri.parse('https://k10a704.p.ssafy.io/Multi/flag');
//                 final requestBody = jsonEncode({
//                   "roomIdx": roomIdx,
//                 });

//                 final dio = Dio();
//                 var response = await dio.post(
//                   url.toString(),
//                   data: requestBody,
//                   options: Options(headers: {
//                     'Content-Type': 'application/json',
//                     'Accept': 'application/json',
//                     'authorization': accessToken,
//                   }),
//                 );

//                 print("깃발 요청 전송: $response");

//                 getflag = true;
//               }
//             }

//             if (res['body'] == "사용자 위치 정보가 없습니다") {
//               getflag = false;
//               multiflag.value = {};
//             }

//             if (res['body']['latitude'] != null) {
//               getflag = false;
//               multiflag.value = res['body'];
//             }
//           } catch (e) {
//             print("깃발 요청 응답 처리 중 에러 발생: $e");
//           }
//         },
//       );

//       client.send(destination: '/pub/flag/$roomIdx');
//       print("--------------깃발 요청-----------------");
//     } else {
//       throw Exception("깃발 요청 x");
//     }
//   } catch (e) {
//     print(e);
//   }
// }

  // void flaginfo(int roomIdx) {
  //   try {
  //     if (client.isActive) {
  //        Map<String, dynamic> resp = jsonDecode(frame.body!);
  //         if (resp['body'].runtimeType == String &&
  //             resp['statusCodeValue'] != 200) {
  //           throw Exception(jsonDecode(frame.body!)['body']);
  //         } else if (resp['body'].runtimeType == String) {
  //           resp['body'] = jsonDecode(resp['body']);
  //         }
  //       client.send(destination: 'https://k10a704.p.ssafy.io/Multi/ws/pub/flag/$roomIdx');
  //       print("--------------깃발 요청-----------------");
  //       print(res['body']);
  //       // print(response);
  //     } else {
  //       throw Exception("깃발 요청 x");
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // void flaginfo(int roomIdx) async {
  //   print('Subscribing to flag info for roomIdx: $roomIdx');
  //   String? accessToken = await storage.read(key: 'accessToken');
  //   flagclient = StompClient(
  //     config: StompConfig.sockJS(
  //       url: dotenv.env['STOMP_URL']!,
  //       onConnect: (p0) {
  //         if (client.isActive) {
  //           flagclient.subscribe(
  //             destination: '/pub/flag/$roomIdx',
  //             headers: {
  //               'Authorization': accessToken ??
  //                   'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
  //             },
  //             callback: (frame) async {
  //               try {

  //                 Map<String, dynamic> res = jsonDecode(frame.body!);
  //                 if (res['body'].runtimeType == String &&
  //                     res['statusCodeValue'] != 200) {
  //                   throw Exception(jsonDecode(frame.body!)['body']);
  //                 } else if (res['body'].runtimeType == String) {
  //                   res['body'] = jsonDecode(res['body']);
  //                 }

  //                 print(res['body']);

  //                 final url = Uri.parse('https://k10a704.p.ssafy.io/Multi/flag');
  //                 final storage = FlutterSecureStorage();
  //                 String? accessToken = await storage.read(key: 'accessToken');
  //                 final dio = Dio();
  //                 dynamic response;

  //                 if (res['body']['message'] == "깃발요청") {
  //                   if (getflag == false) {
  //                     final requestBody = jsonEncode({
  //                       "roomIdx": roomIdx,
  //                       // "latitude": totalDistanceInt,
  //                       // "longitude": intelapsedseconds,
  //                     });

  //                     response = await dio.post(
  //                       url.toString(),
  //                       data: requestBody,
  //                       options: Options(headers: {
  //                         'Content-Type': 'application/json',
  //                         'Accept': 'application/json',
  //                         'authorization': accessToken,
  //                       }),
  //                     );

  //                     print("요청보냄");

  //                     getflag = true;
  //                   }
  //                 }

  //                 if (res['body'] == "사용자 위치 정보가 없습니다") {
  //                   getflag = false;
  //                   multiflag.value = {};
  //                 }

  //                 if (res['body']['latitude'] != null) {

  //                   getflag = false;
  //                   multiflag.value = res['body'];
  //                 }
                  
  //                 } catch(e) {
  //                   print(e);
  //                 }

  //               // } catch(e) {
  //               //   print(e);
  //               },
  //             // },
  //           );
  //           client.send(destination: 'https://k10a704.p.ssafy.io/Multi/ws/pub/flag/$roomIdx');
  //         }
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
    print('레디');
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
        isOwner.value = true;
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