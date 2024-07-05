// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, prefer_function_declarations_over_variables, unused_local_variable, prefer_const_literals_to_create_immutables, file_names, empty_statements

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/securityVerify/securityVerification.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  String _currentPassword = "";
  String _password = "";
  String _confirmPassword = "";

  @override
  void initState() {
    super.initState();

    _currentPasswordController.text = _currentPassword;
    _passwordController.text = _password;
    _confirmPasswordController.text = _confirmPassword;
  }

  @override
  void dispose() {
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
            textTitle: 'change password'.tr,
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
                    child: Form(
                      key: formkey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //Current Password
                            TextFormField(
                              controller: _currentPasswordController,
                              onChanged: (value) {
                                setState(() {
                                  _currentPassword = value;
                                });
                              },
                              enabled: true,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.borderSecondary),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.borderPrimary),
                                ),
                                labelStyle: TextStyle(
                                  color: AppColors.fontGreyOpacity,
                                  fontWeight: FontWeight.bold,
                                ),
                                alignLabelWithHint: true, // set label to bottom
                                labelText: "current password".tr,
                                suffixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
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
                                        "reset pass".tr,
                                        style: bodyTextNormal(
                                          AppColors.fontWaring,
                                          null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "required".tr;
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //Password
                            TextFormField(
                              controller: _passwordController,
                              onChanged: (value) {
                                setState(() {
                                  _password = value;
                                });
                              },
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.borderSecondary),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.borderPrimary),
                                ),
                                labelStyle: TextStyle(
                                  color: AppColors.fontGreyOpacity,
                                  fontWeight: FontWeight.bold,
                                ),
                                alignLabelWithHint: true, // set label to bottom

                                labelText: "password".tr,
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "required".tr;
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //Confirm password
                            TextFormField(
                              controller: _confirmPasswordController,
                              onChanged: (value) {
                                setState(() {
                                  _confirmPassword = value;
                                });
                              },
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.borderSecondary,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.borderPrimary,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: AppColors.fontGreyOpacity,
                                  fontWeight: FontWeight.bold,
                                ),
                                alignLabelWithHint: true, // set label to bottom

                                labelText: "confirm password".tr,
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "required".tr;
                                }
                                return null;
                              },
                            ),

                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //
                  //
                  //Button Save Password
                  Button(
                    text: "change password".tr,
                    fontWeight: FontWeight.bold,
                    press: () async {
                      if (formkey.currentState!.validate()) {
                        changePassword();
                      }
                      //
                      //
                      //Show dialog success after save password
                      // var result = await showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return AlertDialog(
                      //         titlePadding: EdgeInsets.zero,
                      //         contentPadding: EdgeInsets.zero,
                      //         insetPadding: EdgeInsets.zero,
                      //         content: Container(
                      //           color: AppColors.backgroundWhite,
                      //           height: MediaQuery.of(context).size.height,
                      //           width: MediaQuery.of(context).size.width,
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               BoxDecorationIconFontAwesome(
                      //                 // StrImage: 'shield-halved',
                      //                 faIcon: FontAwesomeIcons.shieldHalved,
                      //                 boxHeight: 140,
                      //                 boxWidth: 140,
                      //                 borderRadiusBox:
                      //                     BorderRadius.circular(100),
                      //               ),
                      //               SizedBox(
                      //                 height: 20,
                      //               ),
                      //               Text(
                      //                 "Change Passwod Successful",
                      //                 style:
                      //                     bodyTextMedium(null, FontWeight.bold),
                      //               ),
                      //               SizedBox(
                      //                 height: 30,
                      //               ),
                      //               ButtonDefault(
                      //                 text: 'Close',
                      //                 fontWeight: FontWeight.bold,
                      //                 press: () {},
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       );
                      //     });
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

  changePassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertLoading();
      },
    );

    var res = await postData(changePasswordApiSeeker, {
      "currentPass": _currentPassword,
      "newPassword": _password,
      "confirmPassword": _confirmPassword
    });

    if (res != null) {
      Navigator.pop(context);
    }

    if (res["message"] == "Password has changed") {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialogSuccess(
            title: "successful".tr,
            text: res['message'],
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
            },
          );
        },
      );
      Navigator.pop(context);
    } else {
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
    ;
  }
}
