import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const OnboardingScreen()));
    });

    return const Scaffold(
      backgroundColor: Color(0xFF438883),
      body: Center(
        child: Text(
          'Сайн уу?',
          style: TextStyle(
            color: Colors.white, 
            fontSize: 40, 
            fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
