import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:wadada/common/component/tabbars.dart';
import 'package:wadada/controller/marathonController.dart';
import 'package:wadada/controller/stompController.dart';
import 'package:wadada/models/marathon.dart';
import 'package:wadada/screens/firststartpage/firststartpage.dart';
import 'package:wadada/screens/mainpage/layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wadada/screens/marathonrunpage/marathonRun.dart';
//import 'package:wadada/common/pages/mainpage.dart';
import 'package:wadada/screens/mypage/layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wadada/screens/newprofilepage/layout.dart';
import 'package:wadada/screens/multimainpage/multi_main.dart';
import 'package:wadada/screens/newprofilepage/profileReady.dart';
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

  print(await KakaoSdk.origin);

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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Pretendard"),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Widget _homeWidget = Container();

  @override
  void initState() {
    super.initState();
    _initAsyncData();
  }

  Future<void> _initAsyncData() async {
    // print("HERE");
    String? accessToken = await FlutterSecureStorage().read(key: 'accessToken');
    String? nickName = await FlutterSecureStorage().read(key: 'kakaoNickname');
    // print(nickName == '임시');
    if (accessToken != null && nickName != "임시") {
      setState(() {
        //print('WHERE');
        _homeWidget = MainLayout();
      });
    } else if (nickName == "임시") {
      setState(() {
        _homeWidget = ProfileReady();
        print("HIT");
      });
    } else {
      setState(() {
        // print("WHAT");
        _homeWidget = MainPageLayout();
      });
    }
    // setState(() {
    //   MarathonController marathonController = Get.put(MarathonController());
    //   StompController stompController = Get.put(StompController(roomIdx: 100));
    //   _homeWidget = MarathonRun(
    //     time: -1,
    //     dist: 10,
    //     appKey: '',
    //     controller: stompController,
    //     marathonController: marathonController,
    //     roomInfo: SimpleMarathon(
    //         marathonSeq: -1,
    //         marathonRound: -1,
    //         marathonDist: 20,
    //         marathonParzoqticipate: 20,
    //         marathonStart: DateTime.now(),
    //         marathonEnd: DateTime.now(),
    //         isDeleted: false),
    //   );
    // });
    print(_homeWidget);
  }

  @override
  Widget build(BuildContext context) {
    return _homeWidget;
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
