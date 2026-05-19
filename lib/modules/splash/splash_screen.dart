import 'dart:async';
import 'package:agre_lens_app/layout/app_layout.dart';
import 'package:agre_lens_app/modules/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Boardina/boardina1_screen.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), 
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack, 
    );

    _controller.forward();

    navigateToNextScreen();
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  Future<void> navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboardingCompleted = prefs.getBool("onboardingCompleted") ?? false;
    
    // ⬇️ قراءة التوكن من الـ SharedPreferences ⬇️
    String? token = prefs.getString("token");

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Widget nextScreen;

      // بناءً على البيانات، نحدد الشاشة القادمة
      if (onboardingCompleted) {
        if (token != null && token.isNotEmpty) {
          // التوكن موجود -> المستخدم مسجل دخول مسبقاً
          nextScreen = const AppLayout(); // 🔴 استبدل HomeScreen باسم الشاشة الرئيسية لتطبيقك
        } else {
          // لا يوجد توكن -> يجب تسجيل الدخول
          nextScreen = LoginPage();
        }
      } else {
        // لم ينهي شاشات البداية
        nextScreen = Boardina1Screen();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => nextScreen,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.black,
      body: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          Image.asset('assets/images/splash_bg.png', fit: BoxFit.cover, width: double.infinity, height: double.infinity,),
          Center(
            child: FadeTransition(
              opacity: _controller,
              child: ScaleTransition(
                scale: _animation, 
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 220,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}