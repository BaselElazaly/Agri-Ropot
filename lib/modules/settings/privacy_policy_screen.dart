
import 'package:agre_lens_app/shared/cubit/privacy_policy_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrivacyPolicyCubit()..loadPrivacyPolicy(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            'Privacy Policy',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              height: 1.0,
              letterSpacing: 0,
              color: Colors.black,
            ),
          ),
        ),
        body: BlocBuilder<PrivacyPolicyCubit, PrivacyPolicyState>(
          builder: (context, state) {
            var cubit = PrivacyPolicyCubit.get(context);
            return state is PrivacyPolicyLoaded
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '1. Types data we collect',
                          style: TextStyle(
                            color: Color(0xFF00C569),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cubit.section1,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 1.5,
                            letterSpacing: 0.1,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          '2. Use of your personal data',
                          style: TextStyle(
                            color: Color(0xFF00C569),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cubit.section2,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 1.5,
                            letterSpacing: 0.1,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          '3. Disclosure of your personal data',
                          style: TextStyle(
                            color: Color(0xFF00C569),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cubit.section3,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 1.5,
                            letterSpacing: 0.1,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
