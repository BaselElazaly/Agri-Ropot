import 'package:agre_lens_app/modules/login/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';

class VerifyAccount extends StatefulWidget {
  final String emailText;
  const VerifyAccount({Key? key, required this.emailText}) : super(key: key);

  @override
  State<VerifyAccount> createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  var codeController = TextEditingController();
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
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Verify Account',
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
                child: Text.rich(
                  TextSpan(
                    text: 'Code has been sent to ',
                    style: TextStyle(
                      color: Color(0xFF000113),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: widget.emailText,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: '\nEnter the code to verify your account.',
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                )

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
                        controller: codeController,
                        labelText: 'Code',
                        type: TextInputType.number,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter received code';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 50,),
                      defaultButton(
                          onTap: (){
                            if (formkey.currentState!.validate()){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=> ResetPassword())
                              );
                            }
                          },
                          colorButton: ColorManager.greenColor,
                          textColorButton: Colors.white,
                          text: Text(
                            'Verify Account',
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
