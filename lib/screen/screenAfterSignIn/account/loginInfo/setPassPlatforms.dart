// ignore_for_file: unused_field, unused_local_variable, prefer_const_constructors, prefer_final_fields, avoid_print

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class SetPasswordPlatforms extends StatefulWidget {
  const SetPasswordPlatforms({Key? key}) : super(key: key);

  @override
  State<SetPasswordPlatforms> createState() => _SetPasswordPlatformsState();
}

class _SetPasswordPlatformsState extends State<SetPasswordPlatforms> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  FocusScopeNode _currentFocus = FocusScopeNode();
  FocusNode focusNode = FocusNode();

  String _password = "";

  setPassword() async {
    var res = await postData(apiSetPasswordSeeker, {"password": _password});

    print(res);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return NewVer2CustAlertDialogSuccessBtnConfirm(
          title: "successful".tr,
          contentText: "${res['message']}",
          textButton: "ok".tr,
          press: () {
            Navigator.of(context).pop("set password platform successful");
            Navigator.of(context).pop("set password platform successful");
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _passwordController.text = _password;
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
                              // MaxLengthValidator(30,
                              //     errorText: "Password should not be greater than 30 characters")
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
                    textFontWeight: FontWeight.bold,
                    press: () async {
                      FocusScope.of(context).requestFocus(focusNode);
                      if (formkey.currentState!.validate()) {
                        setPassword();
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
}
