// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_typing_uninitialized_variables, file_names

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/screen/setPassword.dart/setPassword.dart';
import 'package:app/widget/boxDecorationIcon.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class VerificationSuccess extends StatefulWidget {
  const VerificationSuccess(
      {Key? key, this.verifySuccess, this.checkFromRegister, this.token})
      : super(key: key);
  final verifySuccess;
  final checkFromRegister;
  final token;

  @override
  State<VerificationSuccess> createState() => _VerificationSuccessState();
}

class _VerificationSuccessState extends State<VerificationSuccess> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: AppColors.backgroundWhite,
        ),
        body: SafeArea(
            child: Container(
          color: AppColors.backgroundWhite,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BoxDecorationIconFontAwesome(
                faIcon: widget.verifySuccess == 'verifyPhoneNum'
                    ? FontAwesomeIcons.mobileButton
                    : FontAwesomeIcons.solidEnvelope,
                boxHeight: 140,
                boxWidth: 140,
                borderRadiusBox: BorderRadius.circular(100),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.verifySuccess == 'verifyPhoneNum'
                    ? "phone".tr
                    : "email".tr,
                style: bodyTextMedium(null, FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "verify".tr + " " + "successful".tr,
                style: bodyTextMedium(null, FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              ButtonDefault(
                text: widget.checkFromRegister == "fromRegister"
                    ? "close".tr
                    : "set pass".tr,
                fontWeight: FontWeight.bold,
                press: () {
                  if (widget.checkFromRegister == "fromRegister") {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Login.routeName,
                      (route) => false,
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetPassword(
                          token: widget.token,
                        ),
                      ),
                    );
                  }

                  // if (widget.checkFromRegister == 'fromSignUp') {
                  //   Navigator.pushNamedAndRemoveUntil(
                  //     context,
                  //     Login.routeName,
                  //     (route) => false,
                  //   );
                  // } else {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => SetPassword(
                  //         token: widget.token,
                  //       ),
                  //     ),
                  //   );
                  // }
                },
              )
            ],
          ),
        )),
      ),
    );
  }
}
