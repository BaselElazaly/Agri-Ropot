import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../shared/styles/colors.dart';
import 'login_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _emailController = TextEditingController();
  var formkey = GlobalKey<FormState>();
  var scafoldkey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldkey,
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorManager.whiteColor,
      body: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppForgetPasswordSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: ColorManager.greenColor),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
          if (state is AppForgetPasswordErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          bool isLoading = state is AppForgetPasswordLoadingState;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/login_bg.png',
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                      Positioned(
                        top: 30,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Image.asset(
                            'assets/images/Login_logo.png',
                            height: 180,
                            width: 202,
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 5,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              color: Color(0xFF414042),
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 26,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: SvgPicture.asset(
                            'assets/icons/ep_back.svg',
                            width: 32,
                            height: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'No worries! Enter your email address below and we will send you a password reset link.',
                      style: TextStyle(color: Color(0xFF000113), fontSize: 14, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        defaultFormField(
                          context: context,
                          controller: _emailController,
                          labelText: 'Email',
                          type: TextInputType.emailAddress,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 50),
                        
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : defaultButton(
                                onTap: () {
                                  if (formkey.currentState!.validate()) {
                                    cubit.forgetPassword(email: _emailController.text.trim());
                                  }
                                },
                                colorButton: ColorManager.greenColor,
                                textColorButton: Colors.white,
                                text: const Text(
                                  'Send Password Reset Link',
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}