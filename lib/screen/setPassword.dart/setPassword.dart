// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_function_declarations_over_variables, prefer_typing_uninitialized_variables, prefer_final_fields, unused_field, avoid_print

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

class SetPassword extends StatefulWidget {
  const SetPassword({Key? key, this.token}) : super(key: key);
  final token;

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  String _password = "";
  String _confirmPassword = "";
  @override
  void initState() {
    // TODO: implement initState
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
            textTitle: 'Set Password',
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
                                fontWeight: FontWeight.bold,
                              ),
                              labelText: "Password",
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "required";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
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
                              labelText: "Confirm password",
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "required";
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

                  //
                  //
                  //Button Save Password
                  Button(
                    text: "Change Password",
                    fontWeight: FontWeight.bold,
                    press: () async {
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

  setPassword() async {
    await postData(setPasswordSeeker, {
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
                      "Set Passwod Successful",
                      style: bodyTextMedium(null, FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ButtonDefault(
                      text: 'Close',
                      fontWeight: FontWeight.bold,
                      press: () {
                        // Create a Predicate to check if a route has the specified name
                        bool Function(Route<dynamic>) predicate =
                            (Route<dynamic> route) {
                          // Check if the route has the name '/login'
                          if (route.settings.name == Login.routeName) {
                            return true;
                          }
                          return false;
                        };

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Login.routeName,
                          (route) => false,
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          },
        );
      } else {
        await showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialogError(
              title: "Invalid",
              text: value['message'],
            );
          },
        );
      }
    });
  }
}
