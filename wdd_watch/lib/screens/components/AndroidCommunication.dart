import 'package:flutter/services.dart';

class AndroidCommunication {
  static const _channel = MethodChannel('com.ssafy.wadada/communication');

  static Future<String?> sendMessageToMobile(String message) async {
    try {
      final String result = await _channel.invokeMethod('sendMessageToMobile', {'message': message});
      return result;
    } on PlatformException catch (e) {
      print("Failed to send message: ${e.message}");
      return null;
    }
  }
}