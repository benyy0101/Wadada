import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
// import 'package:wadada/common/component/myRecords.dart';
import 'package:wadada/screens/mainpage/layout.dart';
//import 'package:wadada/common/pages/mainpage.dart';
// import 'package:wadada/screens/mypage/layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wadada/screens/singlemainpage/single_main.dart';
import 'dart:io';
import 'package:wadada/screens/mypage/layout.dart';

void main() async {
  HttpOverrides.global = NoCheckCertificateHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/env/.env');
  
  String nativeAppKey = dotenv.env['NATIVE_APP_KEY'] ?? "기본값"; 
  String javaScriptAppKey = dotenv.env['JAVASCRIPT_APP_KEY'] ?? "기본값";

  final appKey = dotenv.env['APP_KEY'] ?? '';

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
      nativeAppKey: nativeAppKey,
      javaScriptAppKey: javaScriptAppKey,
  );

  HttpOverrides.global = MyHttpOverrides();

  setupInterceptor();
  runApp(const MyApp());
}

class NoCheckCertificateHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: SingleMain(),
      // home: MainPageLayout(),
      // home: MyPageLayout(),
    );
  }
}


 class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;

  }
}
