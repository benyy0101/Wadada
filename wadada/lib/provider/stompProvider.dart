import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StompProvider {
  late StompClient client;
  late String serverUrl = "";
  late String accessToken = "";

  void makeEnv() async {
    await dotenv.load(fileName: 'assets/env/.env');
    serverUrl = dotenv.env['SERVER_URL'] ?? "";
    final storage = FlutterSecureStorage();
    storage.read(key: 'accessToken');
  }

  StompProvider() {
    makeEnv();
    client = StompClient(
      config: StompConfig.sockJS(
        url: serverUrl,
        onConnect: onConnect, // Pass the onConnect method as a callback here
        webSocketConnectHeaders: {
          "transports": ["websocket"],
          'Authorization': accessToken
        },
        stompConnectHeaders: {'Authorization': accessToken},
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    client.activate();
  }

  void onConnect(StompFrame frame) {
    client.subscribe(
      destination: '/sub/attend/1',
      headers: {'Authorization': accessToken},
      callback: (frame) {
        print(frame.body);
        List<dynamic> result = jsonDecode(frame.body!);
        if (!result.isEmpty) {
          for (var item in result) {
            print(item.toString()); // Access properties of each item as needed
          }
        }
      },
    );
  }

  void send() {
    client.send(destination: '/pub/in/3');
  }
}
