// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, prefer_final_fields, sized_box_for_whitespace, avoid_unnecessary_containers, unused_field, avoid_print, unnecessary_brace_in_string_interps, unnecessary_null_in_if_null_operators, unused_local_variable, unnecessary_string_interpolations, file_names, prefer_if_null_operators, prefer_adjacent_string_concatenation

import 'dart:async';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/securityVerify/verificationSuccess.dart';
import 'package:app/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

class VerificationCode extends StatefulWidget {
  const VerificationCode(
      {Key? key,
      this.verifyCode,
      this.checkStatusFromScreen,
      this.token,
      this.phoneNumber,
      this.email,
      this.name,
      this.password})
      : super(key: key);
  final verifyCode;
  final checkStatusFromScreen;
  final token;
  final name;
  final password;
  final phoneNumber;
  final email;

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  TextEditingController _otpCodeController = TextEditingController();
  late StreamController<ErrorAnimationType> errorController;

  dynamic _otpCode;
  String _token = "";
  // String currentText = "";

  requestOTPRegister() async {
    var res = await postData(apirequestOTPRegisterSeeker, {
      "email": widget.email ?? "",
      "mobile": widget.phoneNumber ?? "",
    });

    print("function requestOTPRegister working in verificationcode screen " +
        "${res}");

    if (res['token'] != null) {
      setState(() {
        _token = res['token'].toString();
      });
    } else if (res['message'] == "This email has register already...!") {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "This email has register already...!".tr,
          );
        },
      );
      Navigator.pop(context);
    } else if (res['message'] == "This mobile has register already...!") {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "This mobile has register already...!".tr,
          );
        },
      );
      Navigator.pop(context);
    }
  }

  otpCodeClearValue() {
    setState(() {
      _otpCode = "";
      _otpCodeController.clear();
    });
  }

  @override
  void initState() {
    super.initState();

    errorController = StreamController<ErrorAnimationType>();

    if (widget.checkStatusFromScreen == null ||
        widget.checkStatusFromScreen == "" ||
        widget.checkStatusFromScreen == 'fromLoginInfo') {
      _token = widget.token;
    }
    if (widget.checkStatusFromScreen == 'fromRegister') {
      requestOTPRegister();
    }
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScopeNode();
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: GestureDetector(
        onTap: () {
          currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBarDefault(
            textTitle: widget.verifyCode == 'verifyPhoneNum'
                ? 'phoneVerification'.tr
                : 'emailVerification'.tr,
            // fontWeight: FontWeight.bold,
            leadingIcon: Icon(Icons.arrow_back),
            leadingPress: () {
              Navigator.pop(context);
            },
          ),
          body: SafeArea(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // widget.name.toString(),
                        // widget.email.toString(),
                        // widget.phoneNumber.toString(),
                        // widget.password.toString()

                        // Text("${widget.token}"),
                        // Text("${widget.email}"),
                        // Text("${widget.phoneNumber}"),
                        // Text("${_otpCode}"),

                        Text(
                          widget.verifyCode == 'verifyPhoneNum'
                              ? "verify your phone".tr
                              : "verify your email".tr,
                          style: bodyTextMedium(null, null, FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (widget.verifyCode == 'verifyEmail')
                          Column(
                            children: [
                              Text("code sent to".tr),
                              Text(" ${widget.email}"),
                            ],
                          ),
                        if (widget.verifyCode == 'verifyPhoneNum')
                          Text("otp sent to".tr + " ${widget.phoneNumber}"),
                        SizedBox(
                          height: 20,
                        ),

                        // SimpleTextFieldWithIconRight(
                        //   keyboardType: TextInputType.number,
                        //   press: () {
                        //     // setState(() {
                        //     //   _isFocusIconColorFullname = true;
                        //     // });
                        //   },
                        //   changed: (value) {
                        //     setState(() {
                        //       _otpCode = value;
                        //     });
                        //   },
                        //   isObscure: false,
                        //   hintText: widget.verifyCode == "verifyPhoneNum"
                        //       ? "enter".tr + " " + "otp code".tr
                        //       : "enter".tr + " " + "verify code".tr,
                        //   hintTextFontWeight: FontWeight.bold,
                        //   suffixIcon: Icon(Icons.keyboard),
                        // ),

                        //
                        //
                        //
                        //
                        //
                        //PIN code textfield
                        Container(
                          width: 60.w,
                          child: PinCodeTextField(
                            length: 4,
                            obscureText: false,
                            animationType: AnimationType.fade,
                            keyboardType: TextInputType.number,
                            pinTheme: PinTheme(
                              inactiveFillColor: AppColors.backgroundWhite,
                              inactiveColor: AppColors.grey,
                              activeColor: AppColors.primary,
                              activeFillColor: AppColors.fontWhite,
                              selectedFillColor: AppColors.lightPrimary,
                              shape: PinCodeFieldShape.underline,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 50,
                              fieldWidth: 50,
                            ),
                            animationDuration: Duration(milliseconds: 300),
                            backgroundColor: AppColors.backgroundWhite,
                            enableActiveFill: true,
                            errorAnimationController: errorController,
                            controller: _otpCodeController,
                            onCompleted: (v) {
                              print("Completed");
                              if (widget.checkStatusFromScreen ==
                                  'fromRegister') {
                                print("work api verify code from register");
                                newVerifyCodeFromRegister();
                              } else if (widget.checkStatusFromScreen ==
                                  'fromLoginInfo') {
                                print("work api verify code from login info");
                                newVerifyCodeFromLoginInfo();
                              } else {
                                print(
                                    "work api verify code from login forgot password or from reset password");

                                verifyCode();
                              }
                            },
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                _otpCode = value;
                              });
                            },
                            beforeTextPaste: (text) {
                              print("Allowing to paste $text");
                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                              return true;
                            },
                            appContext: context,
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        //
                        //
                        //
                        //
                        //
                        //Resent OTP Code
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.verifyCode == 'verifyPhoneNum'
                                  ? "don't receive otp".tr + "? "
                                  : "don't receive code".tr + "? ",
                            ),
                            GestureDetector(
                              onTap: () {
                                if (widget.checkStatusFromScreen ==
                                    "fromRegister") {
                                  print("fromRegister can resend");
                                  newResendOTPCodeFromRegister();
                                } else if (widget.checkStatusFromScreen ==
                                    "fromLoginInfo") {
                                  print("fromLoginInfo can resend");
                                  newResendOTPCodeFromLoginInfo();
                                } else {
                                  print(
                                      "fromForgot or fromResetPass can resend");
                                  resendOTPCode();
                                }
                              },
                              child: Text(
                                "resend".tr,
                                style: bodyTextNormal(
                                    null, AppColors.primary, null),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  //
                  //
                  //
                  //
                  //
                  //button press verify OTP
                  // Button(
                  //   text: 'verify'.tr,
                  //   fontWeight: FontWeight.bold,
                  //   press: () {
                  //     if (widget.checkStatusFromScreen == 'fromRegister') {
                  //       print("work api verify code from register");
                  //       newVerifyCodeFromRegister();
                  //     } else if (widget.checkStatusFromScreen ==
                  //         'fromLoginInfo') {
                  //       print("work api verify code from login info");
                  //       newVerifyCodeFromLoginInfo();
                  //     } else {
                  //       verifyCode();
                  //     }
                  //   },
                  // ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  resendOTPCode() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustAlertLoading();
      },
    );

    var res = await postData(resendOTPCodeApiSeeker, {
      "verifyToken": _token,
    });
    print(res);

    if (res["token"] != null || res['token'] != "") {
      Navigator.pop(context);

      if (mounted) {
        setState(() {
          _token = res['token'];
        });
      }
    }
  }

  newResendOTPCodeFromRegister() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustAlertLoading();
      },
    );

    var res = await postData(apiNewResendOTPCodeApiSeeker, {
      "verifyToken": _token,
    });
    print(res);

    if (res["token"] != null || res['token'] != "") {
      Navigator.pop(context);

      if (mounted) {
        setState(() {
          _token = res['token'].toString();
        });
      }
    }
  }

  newResendOTPCodeFromLoginInfo() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustAlertLoading();
      },
    );

    var res = await postData(resendOTPLoginInfoSeekerApi, {
      "verifyToken": widget.token,
    });
    print(res);

    if (res["token"] != null || res['token'] != "") {
      Navigator.pop(context);

      if (mounted) {
        setState(() {
          _token = res['token'].toString();
        });
      }
    }
  }

  verifyCode() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustAlertLoading();
      },
    );

    var res = await postData(apiVerifyCodeSeeker, {
      "verifyToken": _token,
      "verifyCode": _otpCode.toString(),
    });

    if (res != null) {
      Navigator.pop(context);
    }

    if (res["token"] != null) {
      print(res);
      var token = res["token"];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationSuccess(
            verifySuccess: widget.verifyCode,
            checkStatusFromScreen: widget.checkStatusFromScreen,
            token: token,
          ),
        ),
      );
    } else if (res['message'] == "Invalid code") {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "Invalid code".tr,
          );
        },
      );
      otpCodeClearValue();
    } else if (res['message'] == "User does not exist") {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "User does not exist".tr,
          );
        },
      );
      otpCodeClearValue();
    }
  }

  newVerifyCodeFromRegister() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustAlertLoading();
      },
    );

    var res = await postData(apiNewVerifyCodeSeeker, {
      "verifyToken": _token,
      "verifyCode": _otpCode.toString(),
    });
    print(res.toString());

    if (res != null) {
      Navigator.pop(context);
    }

    if (res["token"] != null) {
      await postData(apiRegisterSeeker, {
        // "name": widget.name.toString(),
        "email": widget.email.toString(),
        "mobile": widget.phoneNumber.toString(),
        "password": widget.password.toString()
      }).then((value) async {
        if (value['token'] != null) {
          String token = value['token'].toString();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationSuccess(
                verifySuccess: widget.verifyCode,
                checkStatusFromScreen: widget.checkStatusFromScreen,
                token: token,
              ),
            ),
          );
        }
      });
    } else if (res['message'] == "Invalid code") {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "Invalid code".tr,
          );
        },
      );
      otpCodeClearValue();
    }
  }

  newVerifyCodeFromLoginInfo() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustAlertLoading();
      },
    );

    var res = await postData(verifyCodeLoginInfoSeekerApi, {
      "verifyToken": _token,
      "email": widget.email ?? "",
      "mobile": widget.phoneNumber ?? "",
      "verifyCode": _otpCode.toString(),
    });

    if (res != null) {
      Navigator.pop(context);
    }
    print(res.toString());

    if (res["message"] == "Your verify succeed") {
      var res = await postData(changePhoneEmailLoginInfoSeekerApi, {
        "email": widget.email,
        "mobile": widget.phoneNumber,
      });

      if (res['message'] == "Changed") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationSuccess(
              verifySuccess: widget.verifyCode,
              checkStatusFromScreen: widget.checkStatusFromScreen,
            ),
          ),
        );
      } else if (res['message'] == "This email has register already...!") {
        await showDialog(
          context: context,
          builder: (context) {
            return CustAlertDialogWarningWithoutBtn(
              title: "warning".tr,
              contentText: "This email has register already...!".tr,
            );
          },
        );
        otpCodeClearValue();
      } else if (res['message'] == "This mobile has register already...!") {
        await showDialog(
          context: context,
          builder: (context) {
            return CustAlertDialogWarningWithoutBtn(
              title: "warning".tr,
              contentText: "This mobile has register already...!".tr,
            );
          },
        );
        otpCodeClearValue();
      }
    } else if (res["message"] == "Invalid code") {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "Invalid code".tr,
          );
        },
      );
      otpCodeClearValue();
    } else if (res["message"] == "Mobile does not match") {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "Mobile does not match".tr,
          );
        },
      );
      otpCodeClearValue();
    } else if (res["message"] == "Email does not match") {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "Email does not match".tr,
          );
        },
      );
      otpCodeClearValue();
    }
  }
}
