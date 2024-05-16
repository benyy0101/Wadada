import 'package:flutter/material.dart';
import 'package:watch_app/screens/components/pace.dart';
import 'package:watch_app/screens/homescreen.dart';
import 'package:watch_app/screens/proceedingscreen.dart';
import 'package:watch_app/screens/runstartscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Flutter Way',
      theme: ThemeData.dark(useMaterial3: true),
      // home: const HomeScreen(),
      // home: const RunStartScreen(),
      home: const ProceedingScreen(),
    );
  }
}
