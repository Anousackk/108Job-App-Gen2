// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_final_fields, unused_field, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/main/changeLanguage.dart';
import 'package:app/widget/boxDecorationIcon.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  dynamic _phoneNumber;
  late String _password;

  bool _isCheckTelAndEmail = true;
  bool _isFocusIconColorTelAndEmail = false;
  bool _isFocusIconColorFullname = false;
  bool _isObscure = true;

  SiginWith() {
    setState(() {
      _isCheckTelAndEmail = !_isCheckTelAndEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScopeNode();
    return GestureDetector(
      onTap: () {
        currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
          // setState(() {
          //   _isFocusIconColorTelAndEmail = false;
          //   _isFocusIconColorFullname = false;
          // });
        }
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: AppColors.white,
          ),
          body: SafeArea(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                color: AppColors.white,
                child: Column(
                  children: [
                    //
                    //
                    //Change Language Lao-Eng
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                height: 60,
                                width: 60,
                                child: Image(
                                  image: AssetImage('assets/image/Logo108.png'),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: ChangeLanguage(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //
                    //
                    //Text Sign up with Phone Number
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        // color: AppColors.blue,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NotoSansLaoMedium',
                            ),
                          ),
                        ),
                      ),
                    ),

                    //
                    //
                    //Form Sign up account
                    Expanded(
                      flex: 13,
                      child: Container(
                        // color: AppColors.info,
                        child: Form(
                          key: formkey,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //
                              //
                              //Full Name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "First name and Last name",
                                    style:
                                        bodyTextNormal(null, FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 2.w, //5
                                  ),
                                  SimpleTextFieldWithIconRight(
                                    press: () {
                                      // setState(() {
                                      //   _isFocusIconColorFullname = true;
                                      // });
                                    },
                                    isObscure: _isFocusIconColorFullname,
                                    hintText: "Enter your name",
                                    hintTextFontWeight: FontWeight.bold,
                                    suffixIcon: Icon(Icons.keyboard),
                                    // suffixIconColor: _isFocusIconColorFullname
                                    //     ? AppColors.iconPrimary
                                    //     : AppColors.iconGrayOpacity,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.w, //20
                              ),

                              //
                              //
                              //Input Phone Number
                              if (_isCheckTelAndEmail)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Phone number",
                                      style:
                                          bodyTextNormal(null, FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 2.w, //5
                                    ),
                                    TextFieldPhoneNumber(
                                      // press: () {
                                      //   setState(() {
                                      //     _isFocusIconColorTelAndEmail = true;
                                      //   });
                                      // },
                                      changed: (value) {
                                        setState(() {
                                          _phoneNumber = value;
                                        });
                                      },
                                      preFix: '020',
                                      preFixColor: AppColors.fontPrimary,
                                      preFixFontWeight: FontWeight.bold,
                                      textController: _phoneNumberController,
                                      hintText: "00000000",
                                      hintTextFontWeight: FontWeight.bold,
                                      fontIcon: 'FontAwesomePro-Regular',
                                      keyboardType: TextInputType.phone,
                                      isObscure: _isFocusIconColorTelAndEmail,
                                      suffixIcon:
                                          Icon(Icons.phone_android_outlined),
                                      // suffixIconColor:
                                      //     _isFocusIconColorTelAndEmail
                                      //         ? AppColors.iconPrimary
                                      //         : AppColors.iconGrayOpacity,
                                    ),
                                  ],
                                ),
                              //
                              //
                              //Input Email
                              if (!_isCheckTelAndEmail)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email",
                                      style:
                                          bodyTextNormal(null, FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 2.w, //5
                                    ),
                                    SimpleTextFieldWithIconRight(
                                      // press: () {
                                      //   setState(() {
                                      //     _isFocusIconColorTelAndEmail = true;
                                      //   });
                                      // },
                                      isObscure: _isFocusIconColorTelAndEmail,
                                      hintText: "Email",
                                      suffixIcon: Icon(Icons.email_outlined),
                                      // suffixIconColor:
                                      //     _isFocusIconColorTelAndEmail
                                      //         ? AppColors.iconPrimary
                                      //         : AppColors.iconGrayOpacity,
                                    )
                                  ],
                                ),
                              SizedBox(
                                height: 5.w, //20
                              ),

                              //
                              //
                              //Password
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Password",
                                    style:
                                        bodyTextNormal(null, FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 2.w, //5
                                  ),
                                  TextFieldPassword(
                                    isObscure: _isObscure,
                                    changed: (value) {
                                      setState(() {
                                        _password = value;
                                      });
                                    },
                                    hintText: 'Password',
                                    hintTextFontWeight: FontWeight.bold,
                                    suffixIcon: IconButton(
                                      iconSize: 20,
                                      icon: Icon(
                                        _isObscure
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      },
                                    ),
                                    // prefixIcon: IconButton(
                                    //   onPressed: () => {},
                                    //   icon: Icon(null),
                                    // ),
                                  ),
                                ],
                              ),

                              //
                              //
                              //Forgot Password
                              // Container(
                              //   width: double.infinity,
                              //   child: Text(
                              //     "Forgot Password",
                              //     style: bodyTextNormal(
                              //         AppColors.fontGreyOpacity, null),
                              //     textAlign: TextAlign.end,
                              //   ),
                              // ),
                              SizedBox(
                                height: 10.w, //40
                              ),

                              //
                              //
                              //Button Sign up
                              SimpleButton(
                                text: "Sign up",
                                fontWeight: FontWeight.bold,
                                press: () {},
                              ),
                              SizedBox(
                                height: 5.w, //20
                              ),

                              //
                              //
                              //Text Sign up with Phone Number or Email
                              GestureDetector(
                                onTap: () {
                                  SiginWith();
                                },
                                child: Text(
                                  _isCheckTelAndEmail
                                      ? "Sign up with Email"
                                      : "Sign up with Phone Number",
                                  style: bodyTextNormal(null, FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 5.w, //20
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Divider(
                                      height: 1,
                                      color: AppColors.borderSecondary,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                      "Or Sign up with",
                                      style: bodyTextSmall(AppColors.fontGrey),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Divider(
                                      height: 1,
                                      color: AppColors.borderSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.w, //20
                              ),

                              //
                              //
                              //Signe up with orther
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BoxDecorationIcon(
                                    padding: EdgeInsets.all(13),
                                    StrImage: 'assets/image/google.png',
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  BoxDecorationIcon(
                                    padding: EdgeInsets.all(13),
                                    StrImage: 'assets/image/facebook.png',
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //
                    //
                    //Signe up with orther
                    Expanded(
                      flex: 1,
                      child: Container(
                        // color: AppColors.green,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: bodyTextNormal(null, null),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Sign in",
                                style: bodyTextNormal(
                                    AppColors.fontPrimary, FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
