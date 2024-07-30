// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, prefer_final_fields, sized_box_for_whitespace, avoid_unnecessary_containers, unused_field, avoid_print, unnecessary_brace_in_string_interps, unnecessary_null_in_if_null_operators, unused_local_variable, unnecessary_string_interpolations, file_names

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/securityVerify/verificationSuccess.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationCode extends StatefulWidget {
  const VerificationCode(
      {Key? key,
      this.verifyCode,
      this.fromRegister,
      this.token,
      this.phoneNumber,
      this.email,
      this.name,
      this.password})
      : super(key: key);
  final verifyCode;
  final fromRegister;
  final token;
  final name;
  final password;
  final phoneNumber;
  final email;

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  dynamic _otpCode;
  String _token = "";

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
    } else if (res['message'] != null) {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialogWarning(
            title: "warning".tr,
            text: res['message'],
          );
        },
      );
      Navigator.pop(context);
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialogWarning(
            title: "warning".tr,
            text: "invalid".tr,
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.fromRegister == null || widget.fromRegister == "") {
      _token = widget.token;
    }
    if (widget.fromRegister == 'fromRegister') {
      requestOTPRegister();
    }
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
                        // Text("${widget.name}"),
                        // Text("${widget.email}"),
                        // Text("${widget.phoneNumber}"),
                        // Text("${widget.password}"),

                        Text(
                          widget.verifyCode == 'verifyPhoneNum'
                              ? "verify your phone".tr
                              : "verify your email".tr,
                          style: bodyTextMedium(null, FontWeight.bold),
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
                          height: 10,
                        ),

                        SimpleTextFieldWithIconRight(
                          keyboardType: TextInputType.number,
                          press: () {
                            // setState(() {
                            //   _isFocusIconColorFullname = true;
                            // });
                          },
                          changed: (value) {
                            setState(() {
                              _otpCode = value;
                            });
                          },
                          isObscure: false,
                          hintText: widget.verifyCode == "verifyPhoneNum"
                              ? "enter".tr + " " + "otp code".tr
                              : "enter".tr + " " + "verify code".tr,
                          hintTextFontWeight: FontWeight.bold,
                          suffixIcon: Icon(Icons.keyboard),
                        ),

                        //
                        //
                        //
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: 55, vertical: 20),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: List.generate(
                        //       4,
                        //       (index) => SizedBox(
                        //         width: 50, // Set the width of each box
                        //         height: 60, // Set the height of each box
                        //         child: TextFormField(
                        //           controller: _controllers[index],
                        //           // keyboardType: TextInputType.number,
                        //           keyboardType: TextInputType.phone,
                        //           textAlign: TextAlign.center,
                        //           textAlignVertical: TextAlignVertical.top,
                        //           maxLength: 1,
                        //           decoration: InputDecoration(
                        //             counter: Offstage(),
                        //             enabledBorder: enableOutlineBorder(
                        //                 AppColors.borderSecondary),
                        //             focusedBorder: focusOutlineBorder(
                        //                 AppColors.borderPrimary),
                        //           ),
                        //           onChanged: (value) {
                        //             // print(_otpCode);
                        //             // Verify OTP when the code is complete (length is 4)

                        //             if (value.length == 1 &&
                        //                 index < _controllers.length - 1) {
                        //               FocusScope.of(context).nextFocus();
                        //             }
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        SizedBox(
                          height: 10,
                        ),

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
                                if (widget.fromRegister == "fromRegister") {
                                  print("fromRegister can resend");
                                  newResendOTPCodeFromRegister();
                                } else {
                                  resendOTPCode();
                                }
                              },
                              child: Text(
                                "resend".tr,
                                style: bodyTextNormal(AppColors.primary, null),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Button(
                    text: 'verify'.tr,
                    fontWeight: FontWeight.bold,
                    press: () {
                      if (widget.fromRegister == 'fromRegister') {
                        print("from register can register");
                        newVerifyCodeFromRegister();
                      } else {
                        verifyCode();
                      }
                    },
                  ),
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
        return CustomAlertLoading();
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
        return CustomAlertLoading();
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

  verifyCode() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertLoading();
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
            checkFromRegister: widget.fromRegister,
            token: token,
          ),
        ),
      );
    } else if (res['message'] != null) {
      print(res['message']);
      await showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialogError(
            title: "invalid".tr,
            text: res['message'],
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialogWarning(
            title: "warning".tr,
            text: "invalid".tr,
          );
        },
      );
    }

    // .then((value) {
    // dynamic message = value["message"];
    // dynamic token = value["token"];

    // Navigator.pop(context);

    // print(value["message"]);

    // if (value["message"] == value["message"]) {
    //   print("message: ${value["message"]}");
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return CustomAlertDialogError(
    //         title: "Error",
    //         text: value['message'],
    //       );
    //     },
    //   );
    // } else {
    //   print("token: ${value["token"]}");
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => VerificationSuccess(
    //         verifySuccess: widget.verifyCode,
    //         checkFromSignUp: widget.fromSignUp,
    //         token: widget.tokenSignUp,
    //       ),
    //     ),
    //   );
    // }
    // });
  }

  newVerifyCodeFromRegister() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertLoading();
      },
    );

    var res = await postData(apiNewVerifyCodeSeeker, {
      "verifyToken": _token,
      "verifyCode": _otpCode.toString(),
    });

    if (res != null) {
      Navigator.pop(context);
    }

    if (res["token"] != null) {
      print("VerifyCode: " + '${res}');

      await postData(apiRegisterSeeker, {
        // "name": widget.name.toString(),
        "email": widget.email.toString(),
        "mobile": widget.phoneNumber.toString(),
        "password": widget.password.toString()
      }).then((value) async {
        print("in apiRegisterSeeker " + "${value}");
        if (value['token'] != null) {
          print("in apiNewVerifyCodeSeeker ${value['token']}");

          String token = value['token'].toString();
          print("register token " + value['token'].toString());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationSuccess(
                verifySuccess: widget.verifyCode,
                checkFromRegister: widget.fromRegister,
                token: token,
              ),
            ),
          );
        } else {
          print(
              "in apiNewVerifyCodeSeeker warning message: ${value['message']}");

          await showDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialogWarning(
                title: "Warning",
                text: value['message'] == null ? "Invalid" : value['message'],
                press: () {
                  Navigator.pop(context);
                },
              );
            },
          );
        }
      });
    } else if (res['message'] != null) {
      print(res['message']);
      await showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialogError(
            title: "invalid".tr,
            text: res['message'],
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialogWarning(
            title: "warning".tr,
            text: res['message'],
          );
        },
      );
    }
  }
}
