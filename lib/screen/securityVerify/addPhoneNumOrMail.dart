// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, unused_local_variable, unused_import, prefer_final_fields, unused_field, avoid_print, avoid_unnecessary_containers, file_names, unnecessary_brace_in_string_interps

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/securityVerify/verificationCode.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPhoneNumberOrEmail extends StatefulWidget {
  const AddPhoneNumberOrEmail({Key? key, this.addPhoneNumOrEmail})
      : super(key: key);
  final addPhoneNumOrEmail;

  @override
  State<AddPhoneNumberOrEmail> createState() => _AddPhoneNumberOrEmailState();
}

class _AddPhoneNumberOrEmailState extends State<AddPhoneNumberOrEmail> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  dynamic _phoneNumber = "";
  String _email = "";
  String _password = "";
  String _isToken = "";
  bool _passwordStatus = false;
  bool _isloading = true;

  checkTokenLogin() async {
    final prefs = await SharedPreferences.getInstance();
    //
    //get token from shared preferences.
    var employeeToken = prefs.getString('employeeToken');

    if (employeeToken != null) {
      _isToken = employeeToken;
      checkPassword();
    }

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isloading = false;
      });
    });

    setState(() {});
  }

  checkPassword() async {
    var res = await fetchData(informationApiSeeker);
    _passwordStatus = res["info"]["passwordStatus"];
    print(_passwordStatus);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkTokenLogin();

    _phoneNumberController.text = _phoneNumber;
    _emailController.text = _email;
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
            textTitle: widget.addPhoneNumOrEmail == 'phoneNumber'
                ? "add".tr + " " + "phone".tr
                : "add".tr + " " + "email".tr,
            // fontWeight: FontWeight.bold,
            leadingIcon: Icon(Icons.arrow_back),
            leadingPress: () {
              Navigator.pop(context);
            },
          ),
          body: _isloading
              ? Container(
                  color: AppColors.backgroundWhite,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SafeArea(
                  child: Container(
                    color: AppColors.backgroundWhite,

                    // width: double.infinity,
                    // color: AppColors.green,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  widget.addPhoneNumOrEmail == 'phoneNumber'
                                      ? "enter your".tr + " " + "phone".tr
                                      : "enter your".tr + " " + "email".tr,
                                  style: bodyTextNormal(null, FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20,
                                ),

                                //
                                //
                                //Form Input TextFormField
                                Form(
                                  key: formkey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      widget.addPhoneNumOrEmail == 'phoneNumber'
                                          ?
                                          //
                                          //
                                          //Set Mobile Phone
                                          TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  _phoneNumberController,
                                              onChanged: (value) {
                                                setState(() {
                                                  _phoneNumber = value;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                alignLabelWithHint:
                                                    true, // set label to bottom
                                                prefix: Text("020 "),
                                                labelText:
                                                    "phone".tr + " 12345678",
                                              ),
                                              validator: (String? value) {
                                                if (value == null ||
                                                    value.isEmpty ||
                                                    value.length != 8) {
                                                  return "enter8number".tr;
                                                }
                                                return null;
                                              },
                                            )
                                          :
                                          //
                                          //
                                          //Set Email
                                          TextFormField(
                                              controller: _emailController,
                                              onChanged: (value) {
                                                setState(() {
                                                  _email = value;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                alignLabelWithHint:
                                                    true, // set label to bottom
                                                labelText: "email".tr,
                                              ),
                                              validator: (String? value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "required".tr;
                                                }
                                                return null;
                                              },
                                            ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        widget.addPhoneNumOrEmail ==
                                                'phoneNumber'
                                            ? "excludePhone".tr
                                            : "enter your".tr +
                                                " " +
                                                "email".tr,
                                        style: bodyTextNormal(null, null),
                                      ),

                                      //
                                      //
                                      //Set Password
                                      if (_isToken != "" &&
                                          _passwordStatus == false)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              controller: _passwordController,
                                              onChanged: (value) {
                                                setState(() {
                                                  _password = value;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                alignLabelWithHint:
                                                    true, // set label to bottom

                                                labelText: "password".tr,
                                              ),
                                              validator: (String? value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "required".tr;
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "enter your".tr +
                                                  " " +
                                                  "password".tr,
                                              style: bodyTextNormal(null, null),
                                            ),
                                          ],
                                        ),
                                      //
                                      //
                                      //Display Text if addPhoneNumOrEmail == email
                                      if (widget.addPhoneNumOrEmail == 'email')
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 70,
                                            ),
                                            Text("textAddEmail".tr),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("- " + "firstTextAddEmail".tr),
                                            Text("- " + "secondTextAddEmail".tr)
                                          ],
                                        ),
                                      SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Button(
                          text: "next".tr,
                          fontWeight: FontWeight.bold,
                          press: () {
                            if (formkey.currentState!.validate()) {
                              if (_isToken != "") {
                                print("have token");
                                addPhoneNumEmailPass();
                              } else {
                                print("no have token");
                                requestOTPCode();
                              }
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

  requestOTPCode() async {
    var res = await postData(requestOTPCodeApiSeeker, {
      "email": _email,
      "mobile": _phoneNumber,
    });

    if (res["token"] != null) {
      var token = res["token"];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationCode(
            verifyCode: widget.addPhoneNumOrEmail == 'phoneNumber'
                ? 'verifyPhoneNum'
                : 'verifyEmail',
            token: token,
            phoneNumber: _phoneNumber,
            email: _email,
          ),
        ),
      );
    } else if (res['message'] != null) {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialogErrorWithoutButton(
            title: "invalid".tr,
            text: res['message'],
          );
        },
      );
    }
  }

  addPhoneNumEmailPass() async {
    var res = await postData(addPhoneNumEmailPassApiSeeker, {
      "email": _email,
      "mobile": _phoneNumber,
      "password": _password,
    });

    print("${res}");

    if (res["token"] != null) {
      var token = res["token"];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationCode(
            verifyCode: widget.addPhoneNumOrEmail == 'phoneNumber'
                ? 'verifyPhoneNum'
                : 'verifyEmail',
            token: token,
            phoneNumber: _phoneNumber,
            email: _email,
          ),
        ),
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialogErrorWithoutButton(
            title: "invalid".tr,
            text: "${res["message"]}",
          );
        },
      );
    }
  }
}
