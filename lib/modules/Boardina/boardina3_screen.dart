import 'package:agre_lens_app/layout/app_layout.dart';
import 'package:agre_lens_app/modules/Boardina/boardina1_screen.dart';
import 'package:agre_lens_app/modules/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/styles/colors.dart';

class Boardina3Screen extends StatelessWidget {
  Future<void> _completeOnboarding(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("onboardingCompleted", true);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/boardina3_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 120,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Know the season your plants love.",
                  style: GoogleFonts.reemKufi(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.blackColor,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Set up reminders and keep your plant healthy and strong!",
                  style: GoogleFonts.reemKufi(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.blackColor),
                ),
              ],
            ),
          ),
          Positioned(
            right: 40,
            top: 430,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 160,
                  height: 172,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.5),
                    borderRadius: BorderRadius.all(Radius.elliptical(80, 86)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.elliptical(80, 86)),
                    child: Image.asset(
                      'assets/images/Clear View.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  child: Container(
                    width: 24,
                    height: 25,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/Clear View.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 170,
            top: 430,
            child: Container(
              width: 150,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Clear  View',
                  style: GoogleFonts.reemKufi(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () => _completeOnboarding(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: ColorManager.greenColor,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                "Next",
                style: GoogleFonts.reemKufi(
                    fontSize: 18, color: ColorManager.blackColor),
              ),
            ),
          ),
          Positioned(
            right: 20,
            left: 20,
            bottom: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 30),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 30),
                Container(
                  width: 46,
                  height: 8.63,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [ColorManager.greenColor, Color(0xFF0AE0A0)],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
