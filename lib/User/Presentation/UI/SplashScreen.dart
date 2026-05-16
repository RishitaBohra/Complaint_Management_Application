import 'dart:async';
import 'package:amity_university/User/Presentation/UI/Auth%20File/OnBoarding.dart';
import 'package:amity_university/User/Presentation/UI/Home/Home.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget nextScreen = const OnBordingScreen();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedInMobile = prefs.getString('loggedInMobile');

    if (mounted) {
      setState(() {
        if (loggedInMobile != null) {
          nextScreen = const HomeScreen(); // if logged in, go to HomeScreen
        } else {
          nextScreen = const OnBordingScreen(); // else go to OnBoarding
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1000,
      splash: Image.asset('assets/logo.png', height: 400),
      nextScreen: nextScreen,
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: const Color(0xff264c65),
    );
  }
}
