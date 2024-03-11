// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, unused_field, prefer_final_fields, avoid_unnecessary_containers, non_constant_identifier_names, unused_import, avoid_print, unnecessary_brace_in_string_interps, unnecessary_string_interpolations

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/auth_service.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/screenAfterSignIn/home/home.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearch.dart';
import 'package:app/screen/main/changeLanguage.dart';
import 'package:app/screen/securityVerify/securityVerification.dart';
import 'package:app/screen/register/register.dart';
import 'package:app/widget/boxDecorationIcon.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static String routeName = '/login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  dynamic _phoneNumber = "";
  String _email = "";
  String _password = "";

  bool _isCheckTelAndEmail = true;
  bool _isObscure = true;
  bool _isLoading = true;

  checkTokenLogin() async {
    final prefs = await SharedPreferences.getInstance();
    //
    //get token from shared preferences.
    var employeeToken = prefs.getString('employeeToken');

    if (employeeToken != null) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Home()), (route) => false);
    }
    Future.delayed(Duration(seconds: 1), () {
      _isLoading = false;
    });

    setState(() {});
  }

  SiginWith() {
    setState(() {
      _isCheckTelAndEmail = !_isCheckTelAndEmail;
      _phoneNumber = "";
      _email = "";

      _phoneNumberController.text = _phoneNumber;
      _emailController.text = _email;
    });
  }

  @override
  void initState() {
    super.initState();
    checkTokenLogin();

    _phoneNumberController.text = _phoneNumber;
    _emailController.text = _email;
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScopeNode();
    return GestureDetector(
      onTap: () {
        currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MediaQuery(
        data:
            MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
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
                // Expanded(
                //   flex: 1,
                //   child: Container(
                //     child: ChangeLanguage(),
                //   ),
                // ),

                //
                //
                //Text Log in with Phone Number
                // Expanded(
                //   flex: 4,
                //   child: Container(
                //     width: double.infinity,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Container(
                //           height: 85,
                //           width: 85,
                //           child: Image(
                //             image: AssetImage('assets/image/Logo108.png'),
                //           ),
                //         ),
                //         Text(
                //           "Log in to your account\nwith Phone Number",
                //           style: bodyTextMedium(null, FontWeight.bold),
                //         )
                //       ],
                //     ),
                //   ),
                // ),

                //
                //
                //Form Log in account
                Expanded(
                  // flex: 13,
                  child: SingleChildScrollView(
                    child: Container(
                      // color: AppColors.greyOpacity,
                      child: Form(
                        key: formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Text("${_email}"),
                            // Text("${_phoneNumber}"),
                            // Text("${_password}"),

                            SizedBox(
                              height: 5,
                            ),
                            //
                            //
                            //Change Language Lao-Eng
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              // color: AppColors.blue,
                              child: ChangeLanguage(),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),

                            //
                            //
                            //Text Log in
                            Container(
                              width: double.infinity,
                              // color: AppColors.green,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 85,
                                    width: 85,
                                    child: Image(
                                      image: AssetImage(
                                          'assets/image/Logo108.png'),
                                    ),
                                  ),
                                  Text(
                                    "Log in to your account\nwith Phone Number",
                                    style:
                                        bodyTextMedium(null, FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
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
                                    height: 1.h, //5
                                  ),
                                  TextFieldPhoneNumber(
                                    keyboardType: TextInputType.phone,
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
                                    suffixIcon:
                                        Icon(Icons.phone_android_outlined),
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
                                    height: 1.h, //5
                                  ),
                                  SimpleTextFieldWithIconRight(
                                    keyboardType: TextInputType.emailAddress,
                                    changed: (value) {
                                      setState(() {
                                        _email = value;
                                      });
                                    },
                                    textController: _emailController,
                                    hintText: "Email",
                                    suffixIcon: Icon(Icons.email_outlined),
                                  )
                                ],
                              ),
                            SizedBox(
                              height: 2.5.h, //20
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
                            SizedBox(
                              height: 1.h, //20
                            ),

                            //
                            //
                            //Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SecurityVerification(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Forgot Password",
                                  style: bodyTextNormal(
                                      AppColors.fontGreyOpacity, null),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.5.h, //20
                            ),

                            //
                            //
                            //Button Log in
                            SimpleButton(
                              text: "Log in",
                              fontWeight: FontWeight.bold,
                              press: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => Home(),
                                //   ),
                                // );
                                if (formkey.currentState!.validate()) {
                                  login();
                                  // print("success");
                                } else {
                                  // print("false");
                                }
                              },
                            ),
                            SizedBox(
                              height: 2.5.h, //20
                            ),

                            //
                            //
                            //Text Log in with Phone Number or Email
                            GestureDetector(
                              onTap: () {
                                SiginWith();
                              },
                              child: Text(
                                _isCheckTelAndEmail
                                    ? "Log in with Email"
                                    : "Log in with Phone Number",
                                style: bodyTextNormal(null, FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 3.h, //25
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
                                    "Or Log in with",
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
                              height: 3.h, //25
                            ),

                            //
                            //
                            //Signe in with orther
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //
                                //Google Log in
                                BoxDecorationIcon(
                                  padding: EdgeInsets.all(13),
                                  StrImage: 'assets/image/google.png',
                                  press: () {
                                    AuthService().loginWithGoogle(context);
                                  },
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                //
                                //Facebook Log in
                                BoxDecorationIcon(
                                  padding: EdgeInsets.all(13),
                                  StrImage: 'assets/image/facebook.png',
                                  press: () {
                                    GoogleSignIn().signOut();
                                  },
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),

                            //
                            //
                            //Click to Register
                            Container(
                              // height: 50,
                              // color: AppColors.green,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          builder: (context) => Register(
                                            statusButotn: "fromLogin",
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Register",
                                      style: bodyTextNormal(
                                        AppColors.fontPrimary,
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Expanded(
                //   flex: 1,
                //   child: Container(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           "Don't have account? ",
                //           style: bodyTextNormal(null, null),
                //         ),
                //         GestureDetector(
                //           onTap: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (context) => SignUp(
                //                   statusButotn: "fromLogin",
                //                 ),
                //               ),
                //             );
                //           },
                //           child: Text(
                //             "Register",
                //             style: bodyTextNormal(
                //                 AppColors.fontPrimary, FontWeight.bold),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // )
              ],
            )),
          ),
        ),
      ),
    );
  }

  login() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertLoading();
      },
    );

    var res = await postData(apiSigInSeeker, {
      "email": _phoneNumber == "" ? _email : _phoneNumber,
      "password": _password,
    });

    if (res != null) {
      Navigator.pop(context);
    }

    if (res["token"] != null) {
      var employeeToken = res["token"] ?? "";

      //
      //set token use shared preferences.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('employeeToken', employeeToken);

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Home()), (route) => false);
    } else if (res['message'] != null) {
      print(res['message']);
      await showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialogError(
            title: "Invalid",
            text: res['message'],
          );
        },
      );
    }
  }

  // loginWithGoogle(dynamic str) {
  //   launchInBrowser(Uri.parse(str));
  // }
}
