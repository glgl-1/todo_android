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
  ThemeMode _themMode = ThemeMode.system; // 초기값

  _chageThemMode(ThemeMode themeMode) {
    _themMode = themeMode;   // _theMode에다가 내가 만든themeMode를 넣음
    setState(() {});
  }

  static const seedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      themeMode: _themMode, // 기본값은 _themMode가 가지고 있음
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
      home: SplashScreen(onChangeTheme: _chageThemMode)
      // SplashScreen(onChangeTheme: _chageThemMode), // 초기 화면을 SplashScreen으로 설정
    );
  }
}

