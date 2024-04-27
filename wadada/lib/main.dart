import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:wadada/common/component/myRecords.dart';
import 'package:wadada/screens/mainpage/layout.dart';
import 'package:wadada/screens/mypage/layout.dart';
import 'package:wadada/screens/mainpage/layout.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
      nativeAppKey: '9430c9bd5cf24477bf3ccb0cde068f16',
      javaScriptAppKey: '671973e2cb29da502bdead673817f346',
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
    );
  }
}