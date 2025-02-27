import 'package:flutter/material.dart';
import 'package:tugasku/screen/create_task.dart';
import 'package:tugasku/screen/history.dart';
import 'package:tugasku/screen/homepage.dart';
import 'package:tugasku/screen/onboarding.dart';
import 'package:tugasku/screen/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TugasKU APP',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: History(),
    );
  }
}