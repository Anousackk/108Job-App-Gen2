// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, prefer_final_fields, sized_box_for_whitespace, avoid_unnecessary_containers, unused_field, avoid_print, unnecessary_brace_in_string_interps, unnecessary_null_in_if_null_operators, unused_local_variable

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/securityVerify/verificationSuccess.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:flutter/material.dart';

class VerificationCode extends StatefulWidget {
  const VerificationCode(
      {Key? key,
      this.verifyCode,
      this.fromRegister,
      this.token,
      this.phoneNumber,
      this.email})
      : super(key: key);
  final verifyCode;
  final fromRegister;
  final token;
  final phoneNumber;
  final email;

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  dynamic _otpCode;

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
                ? 'Phone Number Verification'
                : 'Email Verification',
            fontWeight: FontWeight.bold,
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
                        // Text("${widget.tokenSignUp}"),
                        Text(
                          widget.verifyCode == 'verifyPhoneNum'
                              ? "Verify your Phone Number"
                              : "Verify your Email Address",
                          style: bodyTextMedium(null, FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (widget.verifyCode == 'verifyEmail')
                          Column(
                            children: [
                              Text("Enter the Verification Code sent to"),
                              Text("${widget.email}"),
                            ],
                          ),
                        if (widget.verifyCode == 'verifyPhoneNum')
                          Text(
                              "Enter the OTP Code sent to ${widget.phoneNumber}"),
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
                          hintText: "Enter OTP",
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
                            Text(widget.verifyCode == 'verifyPhoneNum'
                                ? "Don't receive OTP?"
                                : "Don't receive Verification? "),
                            Text(
                              "Resend",
                              style: bodyTextNormal(AppColors.primary, null),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Button(
                    text: 'Verify',
                    fontWeight: FontWeight.bold,
                    press: () {
                      verifyCode();
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
    var res = await postData(resendOTPCodeApiSeeker, {
      "verifyToken": widget.token,
    });
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
      "verifyToken": widget.token,
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
            title: "Invalid",
            text: res['message'],
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialogWarning(
            title: "Warning",
            text: "Invalid!",
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
}
