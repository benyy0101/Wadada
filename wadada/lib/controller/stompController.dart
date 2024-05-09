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

  StompController({required this.roomIdx}) {
    client = StompClient(
      config: StompConfig.sockJS(
        url: dotenv.env['STOMP_URL']!,
        onConnect: (StompFrame frame) {
          client.subscribe(
            destination: '/sub/attend/$roomIdx',
            headers: {
              'Authorization':
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
                List<dynamic> membersJson = res['body'][roomIdx.toString()];
                if (membersJson.isNotEmpty) {
                  List<CurrentMember> temp = membersJson.map((item) {
                    // Create a CurrentMember object from each JSON item
                    return CurrentMember.fromJson(item);
                  }).toList();
                  temp.forEach((element) {
                    members.add(element);
                  });
                }
              } catch (e) {
                print(e);
                rethrow;
              }
            },
          );
        }, // Pass the onConnect method as a callback here
        webSocketConnectHeaders: {
          "transports": ["websocket"],
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
        },
        stompConnectHeaders: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    print("-------------------client activated--------------");
    client.activate();
  }

  Future<void> _init() async {
    await dotenv.load(fileName: 'assets/env/.env');
    final storage = FlutterSecureStorage();
    serverUrl = dotenv.env['SERVER_URL'] ?? "";
    accessToken = storage.read(key: 'accessToken') as String;
  }

  void attend(int roomIdx) {
    client.send(destination: '/pub/attend/$roomIdx');
  }

  void out(int roomIdx) {
    client.send(destination: '/pub/out/$roomIdx');
  }

  void ready(int roomIdx) {
    client.send(destination: '/pub/change/ready/$roomIdx');
  }

  void setGameStart() {
    isStart = !isStart;
  }

  void disconnect() {
    client.deactivate();
  }
}
