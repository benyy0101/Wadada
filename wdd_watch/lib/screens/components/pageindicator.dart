// 현재 페이지 나타냄
import 'package:flutter/material.dart';
import 'package:wadada/commons/const/colors.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.isOnDesktopAndWeb,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10, bottom: 20,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TabPageSelector(
            indicatorSize: 8,
            controller: tabController,
            color: Colors.white,
            selectedColor: GREEN_COLOR,
          ),
        ],
      ),
    );
  }
}