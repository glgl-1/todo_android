import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/view/splashScrrenPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static const seedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true, // 머터리얼3 디자인 사용
        colorSchemeSeed: seedColor,  // 내가 정한 시드칼라를 씀
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorSchemeSeed: seedColor,
      ),
      home: const SplashScreen()
    );
  }
}

