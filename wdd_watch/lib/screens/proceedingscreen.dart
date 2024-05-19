import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wadada/screens/components/AndroidCommunication.dart';
import 'package:wadada/screens/components/heartbeat.dart';
import 'package:wadada/screens/components/pace.dart';
import 'package:wadada/screens/components/pageindicator.dart';
import 'package:wadada/screens/components/time.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:permission_handler/permission_handler.dart';


// 진행 중 화면

class ProceedingScreen extends StatefulWidget {
  // final bool connected;
  const ProceedingScreen({
    // required this.connected,
    super.key
  });

  @override
  State<ProceedingScreen> createState() => _ProceedingScreenState();
}

class _ProceedingScreenState extends State<ProceedingScreen>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;
  static const MethodChannel _channel = MethodChannel('com.ssafy.wadada/heart_rate');

  String _heartRate = '??';
  // 컨트롤러 슛
  final StreamController<String> _streamController = StreamController<String>();

  // 워치앱에서 플러터앱으로 보낼 심박수 값
  final _watch = WatchConnectivity();

  final _log = <String>[];

  String _formattedPace = '';
  final String _splitHours = '';
  final String _splitMinutes = '';
  final String _splitSeconds = '';

  void requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.location,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
    ].request();

    if (statuses[Permission.bluetooth]?.isGranted == true &&
        statuses[Permission.location]?.isGranted == true &&
        statuses[Permission.bluetoothScan]?.isGranted == true &&
        statuses[Permission.bluetoothConnect]?.isGranted == true &&
        statuses[Permission.bluetoothAdvertise]?.isGranted == true) {
    } else {
      print("Permissions not granted.");
    }
  }

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 3, vsync: this);
    requestPermissions();
    _channel.setMethodCallHandler(_handleMethod);
    _streamController.stream.listen((heartRate) {
      setState(() {
        _heartRate = heartRate;
        AndroidCommunication.sendMessageToMobile(heartRate.toString());
      });
    });
    _initWear();
  }

  void _initWear() {
    _watch.messageStream.listen(
      (message) => setState(
        () {
          if (message.containsKey('formattedPace')) {
            _formattedPace = message['formattedPace'].toString();
          }
        },
      ),
    );
  }

  void sendMessage(formattedPace) {
    final message = {
      'formattedPace': formattedPace,
    };
    _watch.sendMessage(message);
    setState(() => _log.add('메세지: $message'));

  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "updateHeartRate":
      // 심박수 값을 double로 파싱해
        final double heartRateDouble = double.parse(call.arguments.toString());
        final int heartRateInt = heartRateDouble.toInt(); // 67.0 이런식으로 나오는거 거슬려서 수정
        _streamController.add(heartRateInt.toString());
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        PageView(
          controller: _pageViewController,
          onPageChanged: _handlePageViewChanged,
          children: const <Widget>[
            Center(
              child: runPace(),
            ),
            Center(
              child: runTime(),
            ),
            Center(
              child: runHeart(),
            ),
          ],
        ),
        PageIndicator(
          tabController: _tabController,
          currentPageIndex: _currentPageIndex,
          onUpdateCurrentPageIndex: _updateCurrentPageIndex,
          isOnDesktopAndWeb: _isOnDesktopAndWeb,
        ),
      ],
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  bool get _isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }
}
