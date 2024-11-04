import 'package:flutter/material.dart';
import 'package:todo_app/view/home.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 3초 후에 홈화면으로 이동
    Timer(const Duration(seconds: 3), () {
      _navigateToHome(); // 홈화면으로 애니메이션 전환
    });
  }

  _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            Home(),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'images/Animation - 1726623279241.json',
          width: MediaQuery.of(context).size.width,
          height: 400,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
