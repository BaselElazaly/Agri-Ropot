import 'package:agre_lens_app/models/settings/settings_card.dart';
import 'package:agre_lens_app/models/settings/settings_data.dart';
import 'package:agre_lens_app/models/settings/settings_item.dart';
import 'package:agre_lens_app/modules/profile/profile_screen.dart';
import 'package:agre_lens_app/modules/settings/app_info_screen.dart';
import 'package:agre_lens_app/modules/settings/notifications_screen.dart';
import 'package:agre_lens_app/modules/settings/privacy_policy_screen.dart';
import 'package:agre_lens_app/modules/settings/termes_of_use_screen.dart';
import 'package:agre_lens_app/modules/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});


  Future<void> signOutUser() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signOut();
      await googleSignIn.signOut();
      print('تم تسجيل الخروج بنجاح');
    } catch (e) {
      print('حدث خطأ أثناء تسجيل الخروج: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: Colors.grey.shade100,
            elevation: 0,
            centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: InkWell(
                  onTap: (){
                    cubit.changeNavBarIndex(0);
                  },
                  child: Transform.scale(
                    scale: 0.8,
                    child: SvgPicture.asset(
                      'assets/icons/ep_back.svg',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
              ),
            title: Text(
              'Settings',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SettingsCard(items: settingsItems),
                        const SizedBox(height: 30),
                        SettingsCard(items: otherSettingsItems),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async{
                    await signOutUser();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(), //login screen
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Log Out',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class SettingsCard extends StatelessWidget {
  final List<SettingsItem> items;
  const SettingsCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: items.map((item) {
          return Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          item.title,
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  item.screen,
                            ),
                          );
                        },
                      ),
                      if (item != items.last)
                        Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                            right: constraints.maxWidth * 0.07,
                          ),
                          child: const Divider(
                            thickness: 1,
                            height: 0,
                            color: Color(0xFFAAAAAA),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

/*
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Center(
        child: Text(
          'Profile Screen',
          style: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Login Screen',
          style: GoogleFonts.openSans(fontSize: 18),
        ),
      ),
    );
  }
}*/
