// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, unused_field, prefer_final_fields, avoid_unnecessary_containers, non_constant_identifier_names, unused_import, avoid_print, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, curly_braces_in_flow_control_structures, prefer_adjacent_string_concatenation

import 'dart:io';

import 'package:app/firebase_options.dart';
import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/auth_service.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/Main/changeLanguage.dart';
import 'package:app/screen/ScreenAfterSignIn/Home/home.dart';
import 'package:app/screen/SecurityVerify/securityVerification.dart';
import 'package:app/screen/Register/register.dart';
import 'package:app/widget/boxDecorationIcon.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:apple_product_name/apple_product_name.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sizer/sizer.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static String routeName = '/Login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusScopeNode _currentFocus = FocusScopeNode();
  FocusNode focusNode = FocusNode();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  dynamic _fcmToken;
  dynamic _phoneNumber = "";
  String _email = "";
  String _password = "";
  String _modelName = "";
  String _modelVersion = "";

  bool _isCheckTelAndEmail = true;
  bool _isObscure = true;
  bool _isLoading = true;

  //error setState() called after dispose(). it can help!!!
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  // checkTokenLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   //
  //   //get token from shared preferences.
  //   var employeeToken = prefs.getString('employeeToken');

  //   if (employeeToken != null) {
  //     Navigator.pushAndRemoveUntil(context,
  //         MaterialPageRoute(builder: (context) => Home()), (route) => false);
  //   }
  //   Future.delayed(Duration(seconds: 1), () {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });

  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  fcm() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _fcmToken = await FirebaseMessaging.instance.getToken();
    print("fcmTokenLogin: " + "${_fcmToken}");

    if (mounted) {
      setState(() {});
    }
  }

  loadInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    setState(() {
      _isLoading = false;
    });

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('iOS-running name: ${iosInfo.name}');
      print('iOS-running systemVersion: '
              '${iosInfo.systemName}' +
          ' ' +
          '${iosInfo.systemVersion}');
      var name = iosInfo.name;
      var systemName = iosInfo.systemName;
      var systemVersion = iosInfo.systemVersion;
      var productName = iosInfo.utsname.productName;

      _modelName = productName.toString();
      _modelVersion = systemName.toString() + ' ' + systemVersion.toString();
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on version.release: ${androidInfo.version.release}');
      print('Running on model: ' "${androidInfo.brand}" +
          ' ' +
          "${androidInfo.model}");

      var brand = androidInfo.brand.toString();
      var model = androidInfo.model.toString();
      var versionRelease = androidInfo.version.release.toString();

      _modelName = brand.toString() + ' ' + model.toString();
      _modelVersion = versionRelease.toString();
    }
  }

  login() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    var res = await postData(apiSigInSeeker, {
      "email": _phoneNumber == "" ? _email : _phoneNumber,
      "password": _password,
    });

    print("login res: " + '${res}');

    // if (res != null) {
    //   Navigator.pop(context);
    // }

    if (res["token"] != null) {
      var employeeToken = res["token"] ?? "";

      //
      //set token use shared preferences.
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('employeeToken', employeeToken);
      await SharedPrefsHelper.setString("employeeToken", employeeToken);

      var resAddToken = await postData(apiAddTokenSeeker, {
        "notifyToken": [
          {
            "appToken": _fcmToken,
            "model": _modelName,
          }
        ]
      });

      print("login number/email add token success: ${resAddToken}");
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Home()), (route) => false);
    } else if (res['message'] == "You are not a Seeker") {
      //
      //close first loading
      Navigator.pop(context);

      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "You are not a Seeker".tr,
          );
        },
      );
    } else if (res['message'] == "Incorrect email or mobile") {
      //
      //close first loading
      Navigator.pop(context);

      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "Incorrect email or mobile".tr,
          );
        },
      );
    } else if (res['message'] == "Incorrect password") {
      //
      //close first loading
      Navigator.pop(context);

      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "Incorrect password".tr,
          );
        },
      );
    } else {
      //
      //close first loading
      Navigator.pop(context);

      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "${res['message']}",
          );
        },
      );
    }
  }

  SiginWith() {
    setState(() {
      resetFormValidation();
      setEmptryFormLoginValue();

      _isCheckTelAndEmail = !_isCheckTelAndEmail;
    });
  }

  resetFormValidation() {
    formkey.currentState!.reset();
    _autoValidateMode = AutovalidateMode.disabled;
  }

  setEmptryFormLoginValue() {
    setState(() {
      _phoneNumber = "";
      _email = "";
      _password = "";

      _phoneNumberController.text = _phoneNumber;
      _emailController.text = _email;
      _passwordController.text = _password;
    });
  }

  @override
  void initState() {
    super.initState();
    // checkTokenLogin();
    fcm();
    loadInfo();

    _phoneNumberController.text = _phoneNumber;
    _emailController.text = _email;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   print("work");
    //   // Reset form validation when the screen is loaded or reloaded
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _currentFocus = FocusScope.of(context);
        if (!_currentFocus.hasPrimaryFocus) {
          _currentFocus.unfocus();
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
          body: _isLoading
              ? Container(
                  color: AppColors.backgroundWhite,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(child: CustomLoadingLogoCircle()),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  color: AppColors.white,
                  child: SafeArea(
                      child: Column(
                    children: [
                      //Change Language Lao-Eng
                      // Expanded(
                      //   flex: 1,
                      //   child: Container(
                      //     child: ChangeLanguage(),
                      //   ),
                      // ),

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
                      //           style: bodyTextMedium(null,null, FontWeight.bold),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      //
                      //
                      //
                      //
                      //
                      //Form Log in account
                      Expanded(
                        // flex: 13,
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Container(
                            // color: AppColors.greyOpacity,
                            child: Form(
                              key: formkey,
                              autovalidateMode: _autoValidateMode,
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
                                  //
                                  //
                                  //Change Language Lao-Eng
                                  Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: ChangeLanguage(
                                        callBackSetLanguage: (val) {
                                      if (val == "Set Language Success") {
                                        print("call back set language");
                                      }
                                    }),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),

                                  //
                                  //
                                  //
                                  //
                                  //Text Log in
                                  Container(
                                    width: double.infinity,
                                    // color: AppColors.green,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          _isCheckTelAndEmail
                                              ? "login with".tr +
                                                  " " +
                                                  "phone".tr
                                              : "login with".tr +
                                                  " " +
                                                  "email".tr,
                                          style: bodyTextMedium(
                                              null, null, FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),

                                  //
                                  //
                                  //
                                  //
                                  //Input Phone Number
                                  if (_isCheckTelAndEmail)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "phone".tr,
                                          style: bodyTextNormal(
                                              null, null, FontWeight.bold),
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
                                          textController:
                                              _phoneNumberController,
                                          hintText: "00000000",
                                          hintTextFontWeight: FontWeight.bold,
                                          suffixIcon: Icon(
                                              Icons.phone_android_outlined),
                                        ),
                                      ],
                                    ),

                                  //
                                  //
                                  //
                                  //
                                  //Input Email
                                  if (!_isCheckTelAndEmail)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "email".tr,
                                          style: bodyTextNormal(
                                              null, null, FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 1.h, //5
                                        ),
                                        TextFieldEmailWithIconRight(
                                          textController: _emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          changed: (value) {
                                            setState(() {
                                              _email = value;
                                            });
                                          },
                                          hintText: "email".tr,
                                          suffixIcon:
                                              Icon(Icons.email_outlined),
                                        )
                                      ],
                                    ),
                                  SizedBox(
                                    height: 2.5.h, //20
                                  ),

                                  //
                                  //
                                  //
                                  //
                                  //Password
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "password".tr,
                                        style: bodyTextNormal(
                                            null, null, FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 2.w, //5
                                      ),
                                      TextFieldPassword(
                                        codeController: _passwordController,
                                        isObscure: _isObscure,
                                        changed: (value) {
                                          setState(() {
                                            _password = value;
                                          });
                                        },
                                        hintText: 'password'.tr,
                                        hintTextFontWeight: FontWeight.bold,
                                        suffixIcon: IconButton(
                                          iconSize: IconSize.sIcon,
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
                                  //
                                  //
                                  //Forgot Password
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        resetFormValidation();

                                        FocusScope.of(context)
                                            .requestFocus(focusNode);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SecurityVerification(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "forgot pass".tr,
                                        style: bodyTextNormal(null,
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
                                  //
                                  //
                                  //Button Log in
                                  SimpleButton(
                                    text: "login".tr,
                                    fontWeight: FontWeight.bold,
                                    press: () {
                                      FocusScope.of(context)
                                          .requestFocus(focusNode);

                                      _autoValidateMode =
                                          AutovalidateMode.always;

                                      if (formkey.currentState!.validate()) {
                                        login();
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 2.5.h, //20
                                  ),

                                  //
                                  //
                                  //
                                  //
                                  //Text Log in with Phone Number or Email
                                  GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(focusNode);
                                      SiginWith();
                                    },
                                    child: Text(
                                      _isCheckTelAndEmail
                                          ? "login with".tr + " " + "email".tr
                                          : "login with".tr + " " + "phone".tr,
                                      style: bodyTextNormal(
                                          null, null, FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.h, //25
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Divider(
                                          height: 1,
                                          color: AppColors.borderGrey,
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Text(
                                          "or".tr + " " + "login with".tr,
                                          style: bodyTextSmall(
                                              null, AppColors.fontGrey, null),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Divider(
                                          height: 1,
                                          color: AppColors.borderGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3.h, //25
                                  ),

                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //Signe in with orther
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //
                                      //
                                      //Google Log in
                                      BoxDecorationIcon(
                                        padding: EdgeInsets.all(13),
                                        StrImage: 'assets/image/google.png',
                                        press: () {
                                          AuthService().loginWithGoogle(
                                              context, _fcmToken, _modelName);
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),

                                      //
                                      //
                                      //Facebook Log in
                                      BoxDecorationIcon(
                                        padding: EdgeInsets.all(13),
                                        StrImage: 'assets/image/facebook.png',
                                        press: () async {
                                          AuthService().loginWithFacebook(
                                              context, _fcmToken, _modelName);
                                        },
                                      ),

                                      if (Platform.isIOS)
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),

                                            //
                                            //
                                            //
                                            //
                                            //Apple Log in
                                            BoxDecorationIcon(
                                              padding: EdgeInsets.all(13),
                                              StrImage:
                                                  'assets/image/apple.png',
                                              press: () async {
                                                AuthService().loginWithApple(
                                                    context,
                                                    _fcmToken,
                                                    _modelName);
                                              },
                                            ),
                                          ],
                                        )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),

                                  //
                                  //
                                  //
                                  //
                                  //Click to Register
                                  Container(
                                    // height: 50,
                                    // color: AppColors.green,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "don't have ac".tr + "? ",
                                          style:
                                              bodyTextNormal(null, null, null),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            resetFormValidation();
                                            setEmptryFormLoginValue();

                                            FocusScope.of(context)
                                                .requestFocus(focusNode);

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
                                            "register".tr,
                                            style: bodyTextNormal(
                                              null,
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
                      //           style: bodyTextNormal(null,null, null),
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
                      //             style: bodyTextNormal(null,
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

  // loginWithGoogle(dynamic str) {
  //   launchInBrowser(Uri.parse(str));
  // }
}
