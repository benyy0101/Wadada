import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:wadada/common/component/tabbars.dart';
import 'package:wadada/screens/mainpage/layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:wadada/common/pages/mainpage.dart';
import 'package:wadada/screens/mypage/layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wadada/screens/newprofilepage/layout.dart';
import 'package:wadada/screens/multimainpage/multi_main.dart';
import 'package:wadada/screens/singlemainpage/single_main.dart';
import 'dart:io';
import 'package:wadada/screens/mypage/layout.dart';

void main() async {
  HttpOverrides.global = NoCheckCertificateHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/env/.env');

  String nativeAppKey = dotenv.env['NATIVE_APP_KEY'] ?? "기본값";
  String javaScriptAppKey = dotenv.env['JAVASCRIPT_APP_KEY'] ?? "기본값";
  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: nativeAppKey,
    javaScriptAppKey: javaScriptAppKey,
  );

  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp());
}

class NoCheckCertificateHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  final storage = FlutterSecureStorage();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget homeWidget;
    if (storage.read(key: 'accessToken') != null) {
      homeWidget = MainLayout();
    } else {
      homeWidget = MainPageLayout();
    }
    return homeWidget;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
