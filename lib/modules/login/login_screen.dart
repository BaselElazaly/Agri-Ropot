import 'package:agre_lens_app/layout/app_layout.dart';
import 'package:agre_lens_app/modules/login/sign_up_screen.dart';
import 'package:agre_lens_app/shared/network/local/cash_helper.dart';
import 'package:agre_lens_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../shared/components/components.dart'; 
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import 'forget_password_screen.dart';

class LoginPage extends StatefulWidget {
  final String? message;
  const LoginPage({Key? key, this.message}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isPasswordVisible = false;
  var formkey = GlobalKey<FormState>();
  var scafoldkey = GlobalKey<ScaffoldState>();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: '302000130836-sgnguqgrc9lfcen5s12maov0mjctc3qi.apps.googleusercontent.com',
  );

  Future<void> signInWithGoogle(AppCubit cubit) async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    
    if (googleUser == null) return; 

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    
    String? idToken = googleAuth.idToken;

    if (idToken != null) {
      debugPrint("Google ID Token: $idToken");
      cubit.loginWithGoogle(idToken);
    }
  } catch (error) {
  print("🚨 GOOGLE ERROR DETAILS: $error");
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Failed: $error"), backgroundColor: Colors.red),
  );
}
}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.message!),
            backgroundColor: ColorManager.greenColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldkey,
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorManager.whiteColor,
      body: BlocConsumer<AppCubit, AppStates>(
        listenWhen: (previous, current) {
      return current is AppLoginSuccessState || current is AppLoginErrorState;
       },
        listener: (context, state) {
          if (state is AppLoginSuccessState) {
            CacheHelper.saveData(key: 'token', value: state.token).then((value) {
            if (value) {
              debugPrint("Token Saved Successfully!");
              ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login Successfully"), backgroundColor: Colors.green),
            );
            AppCubit.get(context).getUserInfo();
            AppCubit.get(context).getSensorReadings();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AppLayout()),
              );
            }
          }); 
          }

          if (state is AppLoginErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          bool isLoading = state is AppLoginLoadingState;

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
                        bottom: 60,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0xFF414042),
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        defaultFormField(
                          context: context,
                          controller: emailController,
                          labelText: 'Email',
                          type: TextInputType.emailAddress,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        
                        defaultFormField(
                          context: context,
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          isPassword: !isPasswordVisible,
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              !isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgetPassword()));
                            },
                            child: const Text(
                              'Forgot?',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        isLoading
                            ? Center(child: CircularProgressIndicator(color: ColorManager.greenColor))
                            : defaultButton(
                                onTap: () {
                                  if (formkey.currentState!.validate()) {
                                    cubit.userLogin(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                },
                                colorButton: ColorManager.greenColor,
                                textColorButton: Colors.white,
                                text: const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                        
                        const SizedBox(height: 15),
                        const Center(
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(height: 10),
                        
                        defaultButton(
                          onTap: () {
                            signInWithGoogle(cubit);
                          },
                          colorButton: const Color(0xFFF1F5F9),
                          textColorButton: const Color(0xFF475569),
                          text: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/icons/google icon.svg'),
                              const SizedBox(width: 5),
                              const Text('Google', style: TextStyle(color: Color(0xFF475569), fontSize: 14, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(color: ColorManager.greenColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
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

