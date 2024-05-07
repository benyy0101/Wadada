import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StompProvider {
  late StompClient client;
  late DotEnv env;
  final int roomIdx;
  StompProvider({required this.roomIdx}) {
    client = StompClient(
      config: StompConfig.sockJS(
        url: 'https://k10a704.p.ssafy.io/Multi/ws',
        onConnect: (StompFrame frame) {
          client.subscribe(
            destination: '/sub/attend/$roomIdx',
            headers: {
              'Authorization':
                  'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
            },
            callback: (frame) {
              //print(frame.body);
              print(jsonDecode(frame.body!)['body']);

              //List<dynamic> result = jsonDecode(frame.body!);
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
    client.activate();
  }

  // void onConnect(StompFrame frame) {
  //   client.subscribe(
  //     destination: '/sub/attend/0',
  //     headers: {
  //       'Authorization':
  //           'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNDYzNDMxNDUzIiwiYXV0aCI6IlJPTEVfU09DSUFMIiwiZXhwIjoxNzE1NDA1MzkzfQ.dmjUkVX1sFe9EpYhT3SGO3uC7q1dLIoddBvzhoOSisM'
  //     },
  //     callback: (frame) {
  //       print(frame.body);
  //       //List<dynamic> result = jsonDecode(frame.body!);
  //       //print(result);
  //     },
  //   );
  // }

  void attend(int roomIdx) {
    client.send(destination: '/pub/attend/$roomIdx');
  }

  void out(int roomIdx) {
    client.send(destination: '/pub/out/$roomIdx');
  }

  void disconnect() {
    client.deactivate();
  }
}
