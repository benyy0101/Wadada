import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:wadada/models/stomp.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:wadada/repository/multiRepo.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StompController extends GetxController {
  StompClient client = StompClient(config: StompConfig(url: ''));
  final int roomIdx;
  String accessToken = '';
  late String serverUrl;
  RxList<CurrentMember> members = <CurrentMember>[].obs;
  MultiRepository repo = MultiRepository(provider: MultiProvider());
  bool isStart = false;
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
                  throw Exception(res['body']);
                } else if (res['body'].runtimeType == String) {
                  res['body'] = jsonDecode(res['body']);
                }
                //게임 스타트
                if (res['body']['action'] == "/Multi/start") {
                  print("READY TO START");
                  return;
                }
                //Null값 처리
                if (res['body'][roomIdx.toString()] == null) {
                  throw Exception("해당 방의 정보가 없습니다.");
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
          print("--------------published ${roomIdx}------------------");
        } else {
          throw Exception("서버가 준비되어 있지 않습니다.");
        }
      } catch (e) {
        print(e);
      }
    });
  }

  void fromJson(List<dynamic> list) {
    if (list.isNotEmpty) {
      List<CurrentMember> temp = list.map((item) {
        return CurrentMember.fromJson(item);
      }).toList();
      members.clear();
      temp.forEach((element) {
        members.add(element);
      });
    }
  }

  Future<void> findMe() async {
    String kakaoId = await storage.read(key: 'kakaoId') ?? "nothing";
    members.forEach((element) {
      if (element.memberId == kakaoId) {
        itMe = element;
      }
    });
  }

  void countReady() {
    numReady = 0;
    members.forEach((item) {
      if (item.memberReady == true) numReady++;
    });
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
    members.forEach((element) {
      // print(element.memberId);
      if (element.memberId == kakaoId && element.manager == true) {
        isOwner.value = true;
      }
    });
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
