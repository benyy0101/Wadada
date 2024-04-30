import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
// import 'package:wadada/common/component/myRecords.dart';
import 'package:wadada/screens/mainpage/layout.dart';
//import 'package:wadada/common/pages/mainpage.dart';
// import 'package:wadada/screens/mypage/layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wadada/screens/mypage/layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/env/.env');
  
  String nativeAppKey = dotenv.env['NATIVE_APP_KEY'] ?? "기본값"; 
  String javaScriptAppKey = dotenv.env['JAVASCRIPT_APP_KEY'] ?? "기본값";
  

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
      nativeAppKey: nativeAppKey,
      javaScriptAppKey: javaScriptAppKey,
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MainPageLayout(),
      // home: MyPageLayout(),
    );
  }
}