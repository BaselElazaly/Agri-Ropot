import 'package:agre_lens_app/layout/app_layout.dart';
import 'package:agre_lens_app/modules/login/login_screen.dart';
import 'package:agre_lens_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  var formkey = GlobalKey<FormState>();
  var scafoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldkey,
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorManager.whiteColor,
      body: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppRegisterSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
          
          if (state is AppRegisterErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          
          bool isLoading = state is AppRegisterLoadingState;

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
                        child: Image.asset(
                          'assets/images/Login_logo.png',
                          height: 150,
                          width: 180,
                        ),
                      ),
                      const Positioned(
                        bottom: 40,
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            color: Color(0xFF414042),
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Column(
                      children: [
                        defaultFormField(
                          context: context,
                          controller: nameController,
                          labelText: 'Full Name',
                          type: TextInputType.name,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        defaultFormField(
                          context: context,
                          controller: emailController,
                          labelText: 'Email',
                          type: TextInputType.emailAddress,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        defaultFormField(
                          context: context,
                          controller: phoneController,
                          labelText: 'Phone Number (Optional)',
                          type: TextInputType.phone,
                          validator: (String? value) => null, // Optional
                        ),
                        const SizedBox(height: 15),

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
                          
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }

                          if (!RegExp(r'[0-9]').hasMatch(value)) {
                            return 'Must contain at least one digit (0-9)';
                          }

                          if (!RegExp(r'[A-Z]').hasMatch(value)) {
                            return 'Must contain at least one uppercase letter';
                          }

                          if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                            return 'Must contain at least one special character (@#!)';
                          }

                          return null; 
                        },
                        ),
                        const SizedBox(height: 15),

                        defaultFormField(
                          context: context,
                          controller: confirmPasswordController,
                          type: TextInputType.visiblePassword,
                          isPassword: !isConfirmPasswordVisible,
                          labelText: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              !isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                isConfirmPasswordVisible = !isConfirmPasswordVisible;
                              });
                            },
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 30),

                        isLoading
                            ? Center(child: CircularProgressIndicator(color: ColorManager.greenColor))
                            : defaultButton(
                                onTap: () {
                                  if (formkey.currentState!.validate()) {
                                    cubit.userRegister(
                                      fullName: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      confirmPassword: confirmPasswordController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                },
                                colorButton: ColorManager.greenColor,
                                textColorButton: Colors.white,
                                text: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                        
                        const SizedBox(height: 20),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? "),
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: ColorManager.greenColor,
                                  fontWeight: FontWeight.bold,
                                ),
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