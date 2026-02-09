import 'package:agre_lens_app/modules/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var passwordController = TextEditingController();
  var secondpasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isPasswordVisibleSecond = false;
  var formkey = GlobalKey<FormState>();
  var scafoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: scafoldkey,
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorManager.whiteColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
                  Positioned(
                    bottom: 5,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'New Password',
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
                      child: Transform.scale(
                        scale: 1,
                        child: SvgPicture.asset(
                          'assets/icons/ep_back.svg',
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Please enter and confirm your new password.\nYou will need to login after you reset.',
                  style: TextStyle(
                      color: Color(0xFF000113),
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            return 'Please enter new password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                            return 'Password must contain at least one uppercase letter';
                          }
                          if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                            return 'Password must contain at least one lowercase letter';
                          }
                          if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
                            return 'Password must contain at least one number';
                          }
                          if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) {
                            return 'Password must contain at least one special character (@, #, !, *, etc.)';
                          }
                          return null;
                        },
                      ),
                      defaultFormField(
                        context: context,
                        controller: secondpasswordController,
                        type: TextInputType.visiblePassword,
                        isPassword: !isPasswordVisibleSecond,
                        labelText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            !isPasswordVisibleSecond ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisibleSecond = !isPasswordVisibleSecond;
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
                      SizedBox(height: 50,),
                      defaultButton(
                          onTap: () {
                            if (formkey.currentState!.validate()) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(message: "Password changed successfully!"),
                                ),
                              );
                            }
                          },

                          colorButton: ColorManager.greenColor,
                          textColorButton: Colors.white,
                          text: Text(
                            'Reset Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
