// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_final_fields, unused_field, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, curly_braces_in_flow_control_structures, unused_local_variable, avoid_print, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, prefer_if_null_operators

import 'dart:io';

import 'package:app/functions/auth_service.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/main/changeLanguage.dart';
import 'package:app/screen/securityVerify/verificationCode.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/widget/boxDecorationIcon.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
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

  String _name = "";
  String _email = "";
  String _phoneNumber = "";
  String _password = "";

  bool _isCheckTelAndEmail = true;
  bool _isObscure = true;

  SiginWith() {
    setState(() {
      //
      //_isCheckTelAndEmail = true / Phone Number
      //_isCheckTelAndEmail = false / Email
      _isCheckTelAndEmail = !_isCheckTelAndEmail;
      _email = "";
      _phoneNumber = "";
      _password = "";

      _phoneNumberController.text = _phoneNumber;
      _emailController.text = _email;
      _passwordController.text = _password;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fullNameController.text = _name;
    _phoneNumberController.text = _phoneNumber;
    _emailController.text = _email;
    _passwordController.text = _password;
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
                                      child: ChangeLanguage(),
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
                              //           bodyTextNormal(null, FontWeight.bold),
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
                                      style:
                                          bodyTextNormal(null, FontWeight.bold),
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
                                      style:
                                          bodyTextNormal(null, FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 2.w, //5
                                    ),
                                    SimpleTextFieldWithIconRight(
                                      textController: _emailController,
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
                                    style:
                                        bodyTextNormal(null, FontWeight.bold),
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
                              //     style: bodyTextNormal(
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
                                  if (formkey.currentState!.validate()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VerificationCode(
                                          verifyCode: _isCheckTelAndEmail
                                              ? 'verifyPhoneNum'
                                              : 'verifyEmail',
                                          fromRegister: 'fromRegister',
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
                                  SiginWith();
                                },
                                child: Text(
                                  _isCheckTelAndEmail
                                      ? "register with".tr + " " + "email".tr
                                      : "register with".tr + " " + "phone".tr,
                                  style: bodyTextNormal(null, FontWeight.bold),
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
                                      color: AppColors.borderSecondary,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                      "or".tr + " " + "register with".tr,
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
                                      AuthService().loginWithGoogle(context);
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
                                      AuthService().loginWithFacebook(context);
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
                                            AuthService()
                                                .loginWithApple(context);
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
                              //Click to Log in
                              Container(
                                // color: AppColors.green,
                                // height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "already have ac".tr + "? ",
                                      style: bodyTextNormal(null, null),
                                    ),
                                    GestureDetector(
                                      onTap: () {
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
                  //         style: bodyTextNormal(null, null),
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
                  //           style: bodyTextNormal(
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
  //       return CustomAlertLoading();
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
