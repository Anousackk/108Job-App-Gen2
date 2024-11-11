// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_function_declarations_over_variables, prefer_typing_uninitialized_variables, prefer_final_fields, unused_field, avoid_print, file_names

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/boxDecorationIcon.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class ResetNewPassword extends StatefulWidget {
  const ResetNewPassword({Key? key, this.token}) : super(key: key);
  final token;

  @override
  State<ResetNewPassword> createState() => _ResetNewPasswordState();
}

class _ResetNewPasswordState extends State<ResetNewPassword> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  FocusScopeNode _currentFocus = FocusScopeNode();
  FocusNode focusNode = FocusNode();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  String _password = "";
  String _confirmPassword = "";

  resetFormValidation() {
    formkey.currentState!.reset();
    _autoValidateMode = AutovalidateMode.disabled;
  }

  @override
  void initState() {
    super.initState();
    _passwordController.text = _password;
    _confirmPasswordController.text = _confirmPassword;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            textTitle: 'set pass'.tr,
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
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
                                borderSide:
                                    BorderSide(color: AppColors.borderPrimary),
                              ),
                              labelStyle: TextStyle(
                                color: AppColors.fontGreyOpacity,
                              ),
                              labelText: "password".tr,
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
                              labelText: "confirm".tr + " " + "password".tr,
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

                  //
                  //
                  //
                  //
                  //Button Save Password
                  Button(
                    text: "confirm".tr,
                    press: () async {
                      FocusScope.of(context).requestFocus(focusNode);
                      _autoValidateMode = AutovalidateMode.always;

                      if (formkey.currentState!.validate()) {
                        resetNewPassword();
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

  resetNewPassword() async {
    await postData(apiResetNewPasswordSeeker, {
      "changePassToken": widget.token,
      "newPassword": _password,
      "confirmPassword": _confirmPassword,
    }).then((value) async {
      print(value);

      if (value["message"] == "Password has changed") {
        //
        //
        //Show dialog success after save password
        var result = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              insetPadding: EdgeInsets.zero,
              content: Container(
                color: AppColors.backgroundWhite,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BoxDecorationIconFontAwesome(
                      // StrImage: 'shield-halved',
                      faIcon: FontAwesomeIcons.shieldHalved,
                      boxHeight: 140,
                      boxWidth: 140,
                      borderRadiusBox: BorderRadius.circular(100),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "set pass".tr + " " + "successful".tr,
                      style: bodyTextMedium(null, null, FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ButtonDefault(
                      text: 'close'.tr,
                      paddingButton: WidgetStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 40),
                      ),
                      press: () {
                        //Create a Predicate to check if a route has the specified name
                        bool Function(Route<dynamic>) predicate =
                            (Route<dynamic> route) {
                          //Check if the route has the name '/login'
                          if (route.settings.name == Login.routeName) {
                            return true;
                          }
                          return false;
                        };

                        Navigator.pushNamedAndRemoveUntil(
                            context, Login.routeName, (route) => false);
                      },
                    )
                  ],
                ),
              ),
            );
          },
        );
      } else if (value["message"] == "Password does not match") {
        await showDialog(
          context: context,
          builder: (context) {
            return CustAlertDialogWarningWithoutBtn(
              title: "warning".tr,
              contentText: "Password does not match".tr,
            );
          },
        );
      } else if (value["message"] == "User does not exist") {
        await showDialog(
          context: context,
          builder: (context) {
            return CustAlertDialogWarningWithoutBtn(
              title: "warning".tr,
              contentText: "User does not exist".tr,
            );
          },
        );
      }
    });
  }
}
