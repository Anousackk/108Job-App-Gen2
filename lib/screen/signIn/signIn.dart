// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, unused_field, prefer_final_fields, avoid_unnecessary_containers, non_constant_identifier_names

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/main/changeLanguage.dart';
import 'package:app/screen/signUp/singUp.dart';
import 'package:app/widget/boxDecorationIcon.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  dynamic _phoneNumber;
  late String _password;

  bool _isCheckTelAndEmail = true;
  bool _isFocusIconColorTelAndEmail = false;
  bool _isObscure = true;

  SiginWith() {
    setState(() {
      _isCheckTelAndEmail = !_isCheckTelAndEmail;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            color: AppColors.white,
            child: SafeArea(
                child: Column(
              children: [
                //
                //
                //Change Language Lao-Eng
                Expanded(
                  flex: 1,
                  child: ChangeLanguage(),
                ),

                //
                //
                //Text Sign In with Phone Number
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    // color: AppColors.blue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          child: Image(
                            image: AssetImage('assets/image/Logo108.png'),
                          ),
                        ),
                        Text(
                          "Sign In to your account\nwith Phone Number",
                          style: bodyTextMedium(null, FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),

                //
                //
                //Form Sign in account
                Expanded(
                  flex: 13,
                  child: Container(
                    // color: AppColors.greyOpacity,
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //
                          //
                          //Input Phone Number
                          if (_isCheckTelAndEmail)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone number",
                                  style: bodyTextNormal(null, FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2.w,
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
                                  // suffixIconColor: _isFocusIconColorTelAndEmail
                                  //     ? AppColors.iconPrimary
                                  //     : AppColors.iconGrayOpacity,
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
                                  style: bodyTextNormal(null, FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2.w, //5
                                ),
                                SimpleTextFieldWithIconRight(
                                  keyboardType: TextInputType.emailAddress,
                                  // press: () {
                                  //   setState(() {
                                  //     _isFocusIconColorTelAndEmail = true;
                                  //   });
                                  // },
                                  isObscure: _isFocusIconColorTelAndEmail,
                                  hintText: "Email",
                                  suffixIcon: Icon(Icons.email_outlined),
                                  // suffixIconColor: _isFocusIconColorTelAndEmail
                                  //     ? AppColors.iconPrimary
                                  //     : AppColors.iconGrayOpacity,
                                )
                              ],
                            ),
                          SizedBox(
                            height: 20,
                          ),

                          //
                          //
                          //Password
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Password",
                                style: bodyTextNormal(null, FontWeight.bold),
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
                          Container(
                            width: double.infinity,
                            child: Text(
                              "Forgot Password",
                              style: bodyTextNormal(
                                  AppColors.fontGreyOpacity, null),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          SizedBox(
                            height: 5.w, //20
                          ),

                          //
                          //
                          //Button Sign in
                          SimpleButton(
                            text: "Sign in",
                            fontWeight: FontWeight.bold,
                            press: () {},
                          ),
                          SizedBox(
                            height: 5.w, //20
                          ),

                          //
                          //
                          //Text Sign in with Phone Number or Email
                          GestureDetector(
                            onTap: () {
                              SiginWith();
                            },
                            child: Text(
                              _isCheckTelAndEmail
                                  ? "Sign in with Email"
                                  : "Sign in with Phone Number",
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 5.w, //20
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  "Or Sign in with",
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
                          //Signe in with orther
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
                //Sign up
                Expanded(
                  flex: 1,
                  child: Container(
                    // color: AppColors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account? ",
                          style: bodyTextNormal(null, null),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign up",
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
