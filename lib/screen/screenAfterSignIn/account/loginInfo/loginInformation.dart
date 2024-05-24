// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_adjacent_string_concatenation, non_constant_identifier_names, unnecessary_string_interpolations, prefer_final_fields, unused_field, prefer_if_null_operators, unnecessary_brace_in_string_interps, unused_local_variable, avoid_print

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/auth_service.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/screen/screenAfterSignIn/account/loginInfo/changePassword.dart';
import 'package:app/screen/securityVerify/addPhoneNumOrMail.dart';
import 'package:app/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginInformation extends StatefulWidget {
  const LoginInformation({Key? key}) : super(key: key);

  @override
  State<LoginInformation> createState() => _LoginInformationState();
}

class _LoginInformationState extends State<LoginInformation> {
  String _phoneNumber = "";
  String _email = "";
  String _memberLevel = "";
  String _googleId = "";
  String _googleEmail = "";
  String _facebookId = "";
  String _facebookEmail = "";
  bool _passwordStatus = false;
  bool _isloading = true;

  checkSeekerInfo() async {
    var res = await fetchData(informationApiSeeker);
    _phoneNumber =
        !res["info"].containsKey("mobile") ? "" : res["info"]["mobile"];
    _email = !res["info"].containsKey("email") ? "" : res["info"]["email"];
    _passwordStatus = res["info"]["passwordStatus"];
    _memberLevel = res["info"][
        'memberLevel']; //['Basic Member', 'Basic Job Seeker', 'Expert Job Seeker']
    _googleId = res["info"]['googleId'] ?? "";
    _googleEmail = res["info"]["googleEmail"] ?? "";
    _facebookId = res['info']['facebookId'] ?? "";
    _facebookEmail = res['info']['facebookEmail'] ?? "";
    _isloading = false;

    // print(_googleId);
    // print(_facebookId);

    setState(() {});
  }

  removeSharedPreToken() async {
    final prefs = await SharedPreferences.getInstance();
    var removeEmployeeToken = await prefs.remove('employeeToken');
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  @override
  void initState() {
    super.initState();
    checkSeekerInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBarDefault(
          textTitle: "Login Information",
          leadingPress: () {
            Navigator.pop(context);
          },
          leadingIcon: Icon(Icons.arrow_back),
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
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 30),

                        //
                        //
                        //Content Login Information
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //
                              //
                              //General Infomation
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Text(
                                  "General Infomation",
                                  style: bodyTextNormal(null, FontWeight.bold),
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: AppColors.borderBG,
                              ),

                              //
                              //
                              //Phone Number
                              //Phone Number ຖ້າບໍ່ທັນມີ
                              _phoneNumber == ""
                                  ? AddGeneralInformation(
                                      title: "Phone Number",
                                      text: "Add mobile phone",
                                      iconLeft: FaIcon(
                                        FontAwesomeIcons.chevronRight,
                                        size: 13,
                                        color: AppColors.iconGray,
                                      ),
                                      press: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddPhoneNumberOrEmail(
                                                    addPhoneNumOrEmail:
                                                        'phoneNumber'),
                                          ),
                                        );
                                      },
                                    )
                                  : AddGeneralInformation(
                                      title: "Phone Number",
                                      text: "020 ${_phoneNumber}",
                                      textColor: AppColors.fontDark,
                                    ),

                              //
                              //
                              //Email
                              //Email ຖ້າບໍ່ທັນມີ
                              _email == ""
                                  ? AddGeneralInformation(
                                      title: "Email",
                                      text: "Add email",
                                      iconLeft: FaIcon(
                                        FontAwesomeIcons.chevronRight,
                                        size: 13,
                                        color: AppColors.iconGray,
                                      ),
                                      press: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddPhoneNumberOrEmail(
                                                    addPhoneNumOrEmail:
                                                        'email'),
                                          ),
                                        );
                                      },
                                    )
                                  : AddGeneralInformation(
                                      title: "Email",
                                      text: _email,
                                      textColor: AppColors.fontDark,
                                    ),

                              //
                              //
                              //Password
                              if (_phoneNumber != "" || _email != "")
                                AddGeneralInformation(
                                  title: "Password",
                                  text: "Change Password",
                                  iconLeft: FaIcon(
                                    FontAwesomeIcons.chevronRight,
                                    size: 13,
                                    color: AppColors.iconGray,
                                  ),
                                  press: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChangePassword(),
                                      ),
                                    );
                                  },
                                ),
                              SizedBox(
                                height: 30,
                              ),

                              //
                              //
                              //Connect other Platforms
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Text(
                                  "Connect other Platforms",
                                  style: bodyTextNormal(null, FontWeight.bold),
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: AppColors.borderBG,
                              ),

                              //
                              //
                              //Gmail
                              GestureDetector(
                                onTap: () async {
                                  if (_googleId == "") {
                                    AuthService().loginSyncGoogleFacebook(
                                        context, "google", (bool success) {
                                      if (success) {
                                        print("Google API callback success");
                                        checkSeekerInfo();
                                      } else {
                                        print("Google API callback failed");
                                      }
                                    });
                                  }
                                },
                                child: ConnectOtherPlatform(
                                  title: "Google",
                                  strImage: 'assets/image/google.png',
                                  text: _googleId != "" ? _googleEmail : "Link",
                                ),
                              ),

                              //
                              //
                              //Facebook
                              GestureDetector(
                                onTap: () {
                                  if (_facebookId == "") {
                                    AuthService().loginSyncGoogleFacebook(
                                        context, "facebook", (bool success) {
                                      if (success) {
                                        print("Facebook API callback success");
                                        checkSeekerInfo();
                                      } else {
                                        print("Facebook API callback failed");
                                      }
                                    });
                                  }
                                },
                                child: ConnectOtherPlatform(
                                  title: "Facebook",
                                  strImage: 'assets/image/facebook.png',
                                  text: _facebookId != ""
                                      ? _facebookEmail
                                      : "Link",
                                ),
                              ),
                            ],
                          ),
                        ),

                        //
                        //
                        //Log Out
                        GestureDetector(
                          onTap: () async {
                            var result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleAlertDialog(
                                    title: "Log Out",
                                    contentText: "Are you sure to log out?",
                                    textLeft: "Cancel",
                                    textRight: 'Confirm',
                                  );
                                });
                            if (result == 'Ok') {
                              removeSharedPreToken();
                            }
                          },
                          child: Container(
                            // color: AppColors.primary,
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.arrowRightFromBracket),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Log Out",
                                  style: bodyTextNormal(null, FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
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

class AddGeneralInformation extends StatefulWidget {
  const AddGeneralInformation(
      {Key? key,
      this.title,
      this.text,
      this.press,
      this.iconLeft,
      this.textColor})
      : super(key: key);
  final String? title, text;
  final Widget? iconLeft;
  final Color? textColor;
  final Function()? press;

  @override
  State<AddGeneralInformation> createState() => _AddGeneralInformationState();
}

class _AddGeneralInformationState extends State<AddGeneralInformation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.title}",
                style: bodyTextNormal(null, null),
              ),
              GestureDetector(
                onTap: widget.press,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Text(
                        "${widget.text}",
                        style: bodyTextNormal(
                            widget.textColor == null
                                ? AppColors.fontGrey
                                : widget.textColor,
                            null),
                      ),
                    ),
                    Container(
                      child: widget.iconLeft,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: AppColors.borderBG,
        ),
      ],
    );
  }
}

class ConnectOtherPlatform extends StatefulWidget {
  const ConnectOtherPlatform(
      {Key? key, this.title, this.text, required this.strImage})
      : super(key: key);
  final String? title, text;
  final String strImage;

  @override
  State<ConnectOtherPlatform> createState() => _ConnectOtherPlatformState();
}

class _ConnectOtherPlatformState extends State<ConnectOtherPlatform> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image(
                    image: AssetImage("${widget.strImage}"),
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${widget.title}",
                    style: bodyTextNormal(null, null),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: AppColors.opacityBlue,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "${widget.text}",
                  style: bodyTextNormal(AppColors.fontGrey, null),
                ),
              )
            ],
          ),
        ),
        Divider(
          height: 1,
          color: AppColors.borderBG,
        ),
      ],
    );
  }
}
