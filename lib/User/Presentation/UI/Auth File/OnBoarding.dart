import 'package:amity_university/ServiceProvider/Presentation/UI/auth/Preloginscreen.dart';
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:amity_university/User/Presentation/UI/Auth%20File/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});
  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: 'Login',

      // onFinish: () {
      //   Navigator.push(
      //     context,
      //     CupertinoPageRoute(
      //       builder: (context) => const Loginscreen(),
      //     ),
      //   );
      // },
      onFinish: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => PreLoginScreen()),
            );
          }
        });
      },

      finishButtonStyle: FinishButtonStyle(
        backgroundColor: ColorPicker.blueColor,
      ),
      skipTextButton: Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          color: ColorPicker.blueColor,
          fontWeight: FontWeight.w600,
        ),
      ),

      trailing: Text(
        '',
        style: TextStyle(
          fontSize: 16,
          color: ColorPicker.blueColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => const Loginscreen()),
        );
      },
      controllerColor: ColorPicker.blueColor,
      totalPage: 3,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      background: [
        Center(child: Image.asset('assets/logo.png', height: 400)),
        Center(child: Image.asset('assets/logo.png', height: 400)),
        Center(child: Image.asset('assets/logo.png', height: 400)),
      ],
      speed: 1.8,
      pageBodies: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 410),
              Text(
                'File Complaints in Just a Few Taps',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorPicker.blueColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pick a category, explain the issue, and submit — fast, simple, and paper-free.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 410),
              Text(
                'Track Every Update',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorPicker.blueColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Track your complaint in real time — from submission to resolution, no follow-ups needed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 410),
              Text(
                'Start now!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorPicker.blueColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Ready to speak up? File anonymously or with your name — your data stays secure and seen only by the right people.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
