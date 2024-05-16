import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wadada/screens/components/heartbeat.dart';
import 'package:wadada/screens/components/pace.dart';
import 'package:wadada/screens/components/pageindicator.dart';
import 'package:wadada/screens/components/time.dart';
import 'package:watch_connectivity/watch_connectivity.dart';


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

  final _log = <String>[];

  String _formattedPace = '';
  final String _splitHours = '';
  final String _splitMinutes = '';
  final String _splitSeconds = '';
  final _watch = WatchConnectivity();

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 4, vsync: this);
    _initWear();
  }

  void _initWear() {
    _watch.messageStream.listen(
      (message) => setState(
        () {
          if (message.containsKey('formattedPace')) {
            _formattedPace = message['formattedPace'].toString();
          }
          // if (message.containsKey('splitHours')) {
          //   _splitHours = message['splitHours'];
          // }
          // if (message.containsKey('splitMinutes')) {
          //   _splitMinutes = message['splitMinutes'];
          // }
          // if (message.containsKey('splitSeconds')) {
          //   _splitSeconds = message['splitSeconds'].toString();
          // }
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

  // void sendContext(formattedPace) {
  //   final context = {'formattedPace': formattedPace};
  //   _watch.updateApplicationContext(context);
  //   setState(() => _log.add('보내진 context: $context'));
  // }

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
          children: <Widget>[
            const Center(
              child: runPace(),
            ),
            const Center(
              child: runTime(),
            ),
            const Center(
              child: runHeart(),
            ),
            Center(
              child: Text('지도띄울예정', style: textTheme.titleLarge),
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
