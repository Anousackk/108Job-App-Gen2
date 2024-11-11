// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, prefer_function_declarations_over_variables, unused_local_variable, prefer_const_literals_to_create_immutables, file_names, empty_statements

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/securityVerify/securityVerification.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
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
  FocusScopeNode _currentFocus = FocusScopeNode();
  FocusNode focusNode = FocusNode();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  String _currentPassword = "";
  String _password = "";
  String _confirmPassword = "";

  changePassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustAlertLoading();
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
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "successful".tr,
            contentText: "Password has changed".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
            },
          );
        },
      );
      Navigator.pop(context);
    } else if (res["message"] == "Current password doesn't match in database") {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "Current password doesn't match in database".tr,
          );
        },
      );
    } else if (res["message"] == "Password does not match") {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "Password does not match".tr,
          );
        },
      );
    }
  }

  resetFormValidation() {
    formkey.currentState!.reset();
    _autoValidateMode = AutovalidateMode.disabled;
  }

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
          _currentFocus = FocusScope.of(context);
          if (!_currentFocus.hasPrimaryFocus) {
            _currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBarDefault(
            textTitle: 'change password'.tr,
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
                      autovalidateMode: _autoValidateMode,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
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
                                ),
                                alignLabelWithHint: true, // set label to bottom
                                labelText: "current password".tr,
                                suffixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
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
                                        "reset pass".tr,
                                        style: bodyTextNormal(
                                          null,
                                          AppColors.fontWaring,
                                          null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'required'.tr),
                                MinLengthValidator(8,
                                    errorText: "enter8password".tr),
                              ]),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
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
                                ),
                                alignLabelWithHint: true, // set label to bottom

                                labelText: "password".tr,
                              ),
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'required'.tr),
                                MinLengthValidator(8,
                                    errorText: "enter8password".tr),
                              ]),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
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
                                ),
                                alignLabelWithHint: true, // set label to bottom

                                labelText: "confirm password".tr,
                              ),
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'required'.tr),
                                MinLengthValidator(8,
                                    errorText: "enter8password".tr),
                              ]),
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
                    press: () async {
                      FocusScope.of(context).requestFocus(focusNode);

                      _autoValidateMode = AutovalidateMode.always;

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
                      //                     bodyTextMedium(null,null, FontWeight.bold),
                      //               ),
                      //               SizedBox(
                      //                 height: 30,
                      //               ),
                      //               ButtonDefault(
                      //                 text: 'Close',
                      //
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
}
