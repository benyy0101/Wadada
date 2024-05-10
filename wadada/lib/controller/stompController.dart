import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:wadada/models/stomp.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StompController extends GetxController {
  late StompClient client;
  final int roomIdx;
  late String accessToken;
  late String serverUrl;
  RxList<CurrentMember> members = <CurrentMember>[].obs;
  bool isStart = false;
  int numReady = -1;

  StompController({required this.roomIdx}) {
    client = StompClient(
      config: StompConfig.sockJS(
        url: dotenv.env['STOMP_URL']!,
        onConnect: (StompFrame frame) {
          client.subscribe(
            destination: '/sub/attend/$roomIdx',
            headers: {
              'Authorization': dotenv.env['accessToken'] ??
                  'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
            },
            callback: (frame) {
              try {
                print("Incoming Messages:--------------------");

                //에러메세지: 해당방에 입장해 있거나, 이미 나간 방일때
                Map<String, dynamic> res = jsonDecode(frame.body!);
                print(res['body']);
                if (res['body'].runtimeType == String &&
                    res['statusCodeValue'] != 200) {
                  throw Exception(jsonDecode(frame.body!)['body']);
                }

                //게임 스타트
                if (res['body'].runtimeType == String &&
                    res['statusCodeValue'] == 200) {
                  setGameStart();
                  return;
                }
                //Null값 처리
                if (res['body'][roomIdx.toString()] == null) {
                  throw Exception("해당 방의 정보가 없습니다.");
                }

                //참가자 list화
                fromJson(res['body'][roomIdx.toString()]);
                countReady();
              } catch (e) {
                print(e);
                rethrow;
              }
            },
          );
        }, // Pass the onConnect method as a callback here
        webSocketConnectHeaders: {
          "transports": ["websocket"],
          'Authorization': dotenv.env['accessToken'] ??
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
        },
        stompConnectHeaders: {
          'Authorization': dotenv.env['accessToken'] ??
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
  }

  Future<void> _init() async {
    await dotenv.load(fileName: 'assets/env/.env');
    final storage = FlutterSecureStorage();
    serverUrl = dotenv.env['SERVER_URL'] ?? "";
    accessToken = storage.read(key: 'accessToken') as String;
  }

  void attend(int roomIdx) {
    client.activate();
    print("-------------attend-------------");
    try {
      if (client.isActive) {
        client.send(destination: '/pub/attend/$roomIdx');
        print("--------------published------------------");
      } else {
        throw Exception("서버가 준비되어 있지 않습니다.");
      }
    } catch (e) {
      print(e);
    }
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

  void countReady() {
    members.forEach((item) {
      if (item.memberReady == true) numReady++;
    });
  }

  void out(int roomIdx) {
    print("--------------socket OUT---------");
    client.send(destination: '/pub/out/$roomIdx');
  }

  void ready(int roomIdx) {
    client.send(destination: '/pub/change/ready/$roomIdx');
  }

  void setGameStart() {
    isStart = !isStart;
  }

  void disconnect() {
    print("-----controller deactivated---------");
    out(roomIdx);
    client.deactivate();
  }

  @override
  void dispose() {
    out(roomIdx);
    disconnect();
  }
}
