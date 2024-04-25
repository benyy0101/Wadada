import 'package:flutter/material.dart';
import 'package:wadada/common/component/myRecords.dart';
import 'package:wadada/screens/mypage/layout.dart';
import 'package:wadada/screens/mainpage/layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyRecords(),
    );
  }
}
