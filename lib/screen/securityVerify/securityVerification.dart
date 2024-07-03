// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, prefer_final_fields, unused_field, unused_local_variable, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, file_names

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/securityVerify/addPhoneNumOrMail.dart';
import 'package:app/screen/securityVerify/verificationCode.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/boxDecorationIcon.dart';
import 'package:app/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SecurityVerification extends StatefulWidget {
  const SecurityVerification({Key? key}) : super(key: key);

  @override
  State<SecurityVerification> createState() => _SecurityVerificationState();
}

class _SecurityVerificationState extends State<SecurityVerification> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBarDefault(
          textTitle: 'security verification'.tr,
          // fontWeight: FontWeight.bold,
          leadingIcon: Icon(Icons.arrow_back),
          leadingPress: () {
            Navigator.pop(context);
          },
        ),
        body: BodySecurityVerification(),
      ),
    );
  }
}

class BodySecurityVerification extends StatefulWidget {
  const BodySecurityVerification({
    Key? key,
  }) : super(key: key);

  @override
  State<BodySecurityVerification> createState() =>
      _BodySecurityVerificationState();
}

class _BodySecurityVerificationState extends State<BodySecurityVerification> {
  String _isToken = "";
  String _phoneNumber = "";
  String _email = "";
  bool _isloading = true;

  checkTokenLogin() async {
    final prefs = await SharedPreferences.getInstance();
    //
    //get token from shared preferences.
    var employeeToken = prefs.getString('employeeToken');
    // print("eiei" + "$employeeToken");

    if (employeeToken != null) {
      _isToken = employeeToken;
      checkSeekerInfo();
    }

    _isloading = false;

    setState(() {});
  }

  checkSeekerInfo() async {
    var res = await fetchData(informationApiSeeker);
    _phoneNumber =
        !res["info"].containsKey("mobile") ? "" : res["info"]["mobile"];
    _email = !res["info"].containsKey("email") ? "" : res["info"]["email"];

    _isloading = false;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkTokenLogin();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return _isloading
        ? Container(
            color: AppColors.backgroundWhite,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SafeArea(
            child: Container(
            color: AppColors.backgroundWhite,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),

                //
                //
                //Icon
                BoxDecorationIconFontAwesome(
                  faIcon: FontAwesomeIcons.shieldHalved,
                  iconColor: AppColors.iconPrimary,
                  iconSize: 55,
                  boxHeight: 140,
                  boxWidth: 140,
                  borderRadiusBox: BorderRadius.circular(100),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "account protection".tr,
                  style: bodyTextMedium(null, FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "textSecurityVerify".tr,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),

                //
                //ເອົາ Token ມາກວດ
                //ຖ້າວ່າຍັງບໍ່ທັນ Login ໃຫ້ສະແດງໂຕນີ້ກ່ອນ
                _isToken == ""
                    ? Column(
                        children: [
                          //
                          //
                          //Email Boxdecoration
                          BoxDecorationInput(
                            boxDecBorderRadius: BorderRadius.circular(25),
                            widgetFaIcon: FaIcon(
                              FontAwesomeIcons.solidEnvelope,
                              size: 20,
                              color: AppColors.iconGray,
                            ),
                            paddingFaIcon: EdgeInsets.only(left: 20, right: 10),
                            mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddPhoneNumberOrEmail(
                                      addPhoneNumOrEmail: 'email'),
                                ),
                              );
                            },
                            text: "email".tr,
                            validateText: Container(),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          //
                          //
                          //Mobile Number Boxdecoration
                          BoxDecorationInput(
                            boxDecBorderRadius: BorderRadius.circular(25),
                            widgetFaIcon: FaIcon(
                              FontAwesomeIcons.mobileButton,
                              size: 20,
                              color: AppColors.iconGray,
                            ),
                            paddingFaIcon: EdgeInsets.only(left: 20, right: 10),
                            mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddPhoneNumberOrEmail(
                                      addPhoneNumOrEmail: 'phoneNumber'),
                                ),
                              );
                            },
                            text: "phone".tr,
                            validateText: Container(),
                          ),
                        ],
                      )
                    :
                    //
                    //ເອົາ Token ມາກວດ
                    //ຖ້າວ່າ Login ແລ້ວໃຫ້ສະແດງໂຕນີ້ກ່ອນ
                    Column(
                        children: [
                          //
                          //
                          //Email Boxdecoration
                          BoxDecorationInput(
                            boxDecBorderRadius: BorderRadius.circular(25),
                            widgetFaIcon: FaIcon(
                              FontAwesomeIcons.solidEnvelope,
                              size: 20,
                              color: AppColors.iconGray,
                            ),
                            paddingFaIcon: EdgeInsets.only(left: 20, right: 10),
                            mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                            press: () {
                              requestOTPCode(
                                "",
                                _email,
                                "verifyEmail",
                              );
                            },
                            text: "email".tr,
                            widgetIconActive: Text("${_email}"),
                            validateText: Container(),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          //
                          //
                          //Mobile Number Boxdecoration
                          BoxDecorationInput(
                            boxDecBorderRadius: BorderRadius.circular(25),
                            widgetFaIcon: FaIcon(
                              FontAwesomeIcons.mobileButton,
                              size: 20,
                              color: AppColors.iconGray,
                            ),
                            paddingFaIcon: EdgeInsets.only(left: 20, right: 10),
                            mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                            press: () {
                              requestOTPCode(
                                _phoneNumber,
                                "",
                                "verifyPhoneNum",
                              );
                            },
                            text: "phone".tr,
                            widgetIconActive: Text("020 ${_phoneNumber}"),
                            validateText: Container(),
                          ),
                        ],
                      )
              ],
            ),
          ));
  }

  requestOTPCode(
    phoneNumber,
    email,
    verifyCodeBy,
  ) async {
    var res = await postData(requestOTPCodeApiSeeker, {
      "email": email,
      "mobile": phoneNumber,
    });

    if (res["token"] != null) {
      var token = res["token"];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationCode(
            verifyCode: verifyCodeBy,
            token: token,
            phoneNumber: phoneNumber,
            email: email,
          ),
        ),
      );
    } else if (res['message'] != null) {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialogError(
            title: "invalid".tr,
            text: res['message'],
          );
        },
      );
    }
  }
}
