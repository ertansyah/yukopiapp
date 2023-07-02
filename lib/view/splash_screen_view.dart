import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    startSplashScreen();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void startSplashScreen() {
    const splashDuration = Duration(seconds: 7);

    _timer = Timer(splashDuration, () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: SizedBox(
            width: 400,
            height: 400,
            child: Lottie.asset('assets/splash2.json'),
          ),
        ),
      ),
    );
  }
}
