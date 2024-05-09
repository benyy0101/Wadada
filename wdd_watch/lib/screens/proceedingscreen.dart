import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:watch_app/screens/components/heartbeat.dart';
import 'package:watch_app/screens/components/pace.dart';
import 'package:watch_app/screens/components/pageindicator.dart';
import 'package:watch_app/screens/components/time.dart';

// 진행 중 화면

class ProceedingScreen extends StatefulWidget {
  const ProceedingScreen({super.key});

  @override
  State<ProceedingScreen> createState() => _ProceedingScreenState();
}

class _ProceedingScreenState extends State<ProceedingScreen>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 4, vsync: this);
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
          children: <Widget>[
            const Center(
              child: runTime(),
            ),
            const Center(
              child: runPace(),
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
