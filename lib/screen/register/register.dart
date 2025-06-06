// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_final_fields, unused_field, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, curly_braces_in_flow_control_structures, unused_local_variable, avoid_print, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, prefer_if_null_operators

import 'dart:io';

import 'package:app/firebase_options.dart';
import 'package:app/functions/auth_service.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/Main/changeLanguage.dart';
import 'package:app/screen/securityVerify/verificationCode.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/widget/boxDecorationIcon.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:apple_product_name/apple_product_name.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class Register extends StatefulWidget {
  const Register({Key? key, this.statusButotn}) : super(key: key);
  final statusButotn;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusScopeNode _currentFocus = FocusScopeNode();
  FocusNode focusNode = FocusNode();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  dynamic _fcmToken;

  String _name = "";
  String _email = "";
  String _phoneNumber = "";
  String _password = "";
  String _modelName = "";
  String _modelVersion = "";

  bool _isCheckTelAndEmail = true;
  bool _isObscure = true;

  fcm() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _fcmToken = await FirebaseMessaging.instance.getToken();
    print("fcmToken: " + "${_fcmToken}");

    if (mounted) {
      setState(() {});
    }
  }

  loadInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

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

  SiginWith() {
    setState(() {
      //
      //_isCheckTelAndEmail = true / Phone Number
      //_isCheckTelAndEmail = false / Email
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

  //error setState() called after dispose(). it can help!!!
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    // fcm();
    loadInfo();

    _fullNameController.text = _name;
    _phoneNumberController.text = _phoneNumber;
    _emailController.text = _email;
    _passwordController.text = _password;
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
                  // Expanded(
                  //   flex: 2,
                  //   child: Container(
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Flexible(
                  //           flex: 1,
                  //           child: Container(
                  //             height: 65,
                  //             width: 65,
                  //             child: Image(
                  //               image: AssetImage('assets/image/Logo108.png'),
                  //             ),
                  //           ),
                  //         ),
                  //         Flexible(
                  //           flex: 1,
                  //           child: ChangeLanguage(),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  //
                  //
                  //Text Register with Phone Number
                  // Expanded(
                  //   flex: 2,
                  //   child: Container(
                  //     width: double.infinity,
                  //     child: Align(
                  //       alignment: Alignment.centerLeft,
                  //       child: Text(
                  //         "Register",
                  //         style: TextStyle(
                  //           fontSize: 30,
                  //           fontWeight: FontWeight.bold,
                  //           fontFamily: 'NotoSansLaoMedium',
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  //
                  //
                  //Form Register account
                  Expanded(
                    // flex: 15,
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Container(
                        // color: AppColors.info,
                        child: Form(
                          key: formkey,
                          autovalidateMode: _autoValidateMode,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5,
                              ),

                              //
                              //
                              //
                              //
                              //
                              //
                              //Change Language Lao-Eng
                              Container(
                                // color: AppColors.blue,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        height: 65,
                                        width: 65,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/image/Logo108.png'),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: ChangeLanguage(
                                          callBackSetLanguage: (val) {
                                        if (val == "Set Language Success") {
                                          print("call back set language");
                                        }
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 35,
                              ),

                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //Text Register
                              Container(
                                width: double.infinity,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "register".tr,
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'NotoSansLaoMedium',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.5.h,
                              ),

                              //
                              //
                              //Name
                              // Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Text(
                              //       "fullname".tr,
                              //       style:
                              //           bodyTextNormal(null,null, FontWeight.bold),
                              //     ),
                              //     SizedBox(
                              //       height: 2.w, //5
                              //     ),
                              //     SimpleTextFieldWithIconRight(
                              //       textController: _fullNameController,
                              //       changed: (value) {
                              //         setState(() {
                              //           _name = value;
                              //         });
                              //       },
                              //       hintText: "fullname".tr,
                              //       hintTextFontWeight: FontWeight.bold,
                              //       suffixIcon: Icon(
                              //         Icons.keyboard,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(
                              //   height: 5.w, //20
                              // ),

                              // Text("${_phoneNumber}"),

                              //
                              //
                              //
                              //
                              //
                              //
                              //Phone Number
                              if (_isCheckTelAndEmail)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "phone".tr,
                                      style: bodyTextNormal(
                                          null, null, FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 2.w, //5
                                    ),
                                    TextFieldPhoneNumber(
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
                                      suffixIcon:
                                          Icon(Icons.phone_android_outlined),
                                    ),
                                  ],
                                ),

                              //
                              //
                              //
                              //
                              //
                              //
                              //Email
                              if (!_isCheckTelAndEmail)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "email".tr,
                                      style: bodyTextNormal(
                                          null, null, FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 2.w, //5
                                    ),
                                    TextFieldEmailWithIconRight(
                                      textController: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      changed: (value) {
                                        setState(() {
                                          _email = value;
                                        });
                                      },
                                      hintText: "email".tr,
                                      suffixIcon: Icon(Icons.email_outlined),
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
                              //
                              //Password
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                              //     style: bodyTextNormal(null,
                              //         AppColors.fontGreyOpacity, null),
                              //     textAlign: TextAlign.end,
                              //   ),
                              // ),
                              SizedBox(
                                height: 5.h, //40
                              ),

                              //
                              //
                              //
                              //
                              //
                              //Button Register
                              SimpleButton(
                                text: "register".tr,
                                fontWeight: FontWeight.bold,
                                press: () {
                                  FocusScope.of(context)
                                      .requestFocus(focusNode);

                                  _autoValidateMode = AutovalidateMode.always;

                                  if (formkey.currentState!.validate()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VerificationCode(
                                          verifyCode: _isCheckTelAndEmail
                                              ? 'verifyPhoneNum'
                                              : 'verifyEmail',
                                          checkStatusFromScreen: 'fromRegister',
                                          // name: _name,
                                          phoneNumber: _phoneNumber,
                                          email: _email,
                                          password: _password,
                                        ),
                                      ),
                                    );
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
                              //
                              //
                              //Text Register with Phone Number or Email
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(focusNode);
                                  SiginWith();
                                },
                                child: Text(
                                  _isCheckTelAndEmail
                                      ? "register with".tr + " " + "email".tr
                                      : "register with".tr + " " + "phone".tr,
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
                                      "or".tr + " " + "register with".tr,
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
                              //Sign up with orther
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //Google
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
                                  //
                                  //
                                  //
                                  //Facebook
                                  BoxDecorationIcon(
                                    padding: EdgeInsets.all(13),
                                    StrImage: 'assets/image/facebook.png',
                                    press: () {
                                      AuthService().loginWithFacebook(
                                          context, _fcmToken, _modelName);
                                    },
                                  ),

                                  //
                                  //
                                  //
                                  //
                                  //
                                  //Apple
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
                                          StrImage: 'assets/image/apple.png',
                                          press: () async {
                                            AuthService().loginWithApple(
                                                context, _fcmToken, _modelName);
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
                              //click to log in screen
                              Container(
                                // color: AppColors.green,
                                // height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "already have ac".tr + "? ",
                                      style: bodyTextNormal(null, null, null),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        resetFormValidation();
                                        setEmptryFormLoginValue();

                                        FocusScope.of(context)
                                            .requestFocus(focusNode);

                                        if (widget.statusButotn ==
                                            "fromLogin") {
                                          Navigator.pop(context);
                                        } else if (widget.statusButotn ==
                                            "fromMain") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Login(),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        "login".tr,
                                        style: bodyTextNormal(
                                            null,
                                            AppColors.fontPrimary,
                                            FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: 3.h,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  //
                  //
                  //Click to Log in

                  // Container(
                  //   height: 50,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         "Already have an account? ",
                  //         style: bodyTextNormal(null,null, null),
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           if (widget.statusButotn == "fromLogin") {
                  //             Navigator.pop(context);
                  //           } else if (widget.statusButotn == "fromMain") {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (context) => Login(),
                  //               ),
                  //             );
                  //           }
                  //         },
                  //         child: Text(
                  //           "Log in",
                  //           style: bodyTextNormal(null,
                  //               AppColors.fontPrimary, FontWeight.bold),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // register() async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return CustomLoadingLogoCircle();
  //     },
  //   );
  //   await postData(apiRegisterSeeker, {
  //     "name": _name,
  //     "email": _email,
  //     "mobile": _phoneNumber.toString(),
  //     "password": _password
  //   }).then((value) async {
  //     print(value);
  //     Navigator.pop(context);

  //     if (value['token'] != null) {
  //       String token = value['token'].toString();
  //       print("register token " + value['token'].toString());

  //       await Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => VerificationCode(
  //             verifyCode:
  //                 _isCheckTelAndEmail ? 'verifyPhoneNum' : 'verifyEmail',
  //             fromRegister: 'fromRegister',
  //             token: token,
  //             phoneNumber: _phoneNumber,
  //             email: _email,
  //           ),
  //         ),
  //       );
  //     } else {
  //       print("message: ${value['message']}");

  //       await showDialog(
  //         context: context,
  //         builder: (context) {
  //           return CustomAlertDialogWarning(
  //             title: "Warning",
  //             text: value['message'] == null ? "Invalid" : value['message'],
  //             press: () {
  //               Navigator.pop(context);
  //             },
  //           );
  //         },
  //       );
  //     }
  //   });
  // }
}
