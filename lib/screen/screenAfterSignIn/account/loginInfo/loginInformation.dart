// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_adjacent_string_concatenation, non_constant_identifier_names, unnecessary_string_interpolations, prefer_final_fields, unused_field, prefer_if_null_operators, unnecessary_brace_in_string_interps, unused_local_variable, avoid_print, file_names

import 'dart:io';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/auth_service.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/screen/screenAfterSignIn/account/loginInfo/changePassword.dart';
import 'package:app/screen/screenAfterSignIn/account/loginInfo/deleteAccount.dart';
import 'package:app/screen/screenAfterSignIn/account/loginInfo/setPassPlatforms.dart';
import 'package:app/screen/securityVerify/addPhoneNumOrMail.dart';
import 'package:app/widget/appbar.dart';
import 'package:apple_product_name/apple_product_name.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
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
  String _appleId = "";
  String _appleEmail = "";
  String _modelName = "";

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
    _appleId = res['info']['appleId'] ?? "";
    _appleEmail = res['info']['appleEmail'] ?? "";
    _isloading = false;

    // print(_googleId);
    // print(_facebookId);

    setState(() {});
  }

  loadInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('iOS-running name: ${iosInfo.name}');
      print('iOS-running systemVersion: '
              '${iosInfo.systemName}' +
          ' ' +
          '${iosInfo.systemVersion}');
      var name = iosInfo.name;
      var systemName = iosInfo.systemName;
      var systemVersion = iosInfo.systemVersion;
      var productName = iosInfo.utsname.productName;
      setState(() {
        _modelName = productName.toString();
      });
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on version.release: ${androidInfo.version.release}');
      print('Running on model: ' "${androidInfo.brand}" +
          ' ' +
          "${androidInfo.model}");

      var brand = androidInfo.brand.toString();
      var model = androidInfo.model.toString();
      var versionRelease = androidInfo.version.release.toString();
      setState(() {
        _modelName = brand.toString() + ' ' + model.toString();
      });
    }
  }

  logOut() async {
    await loadInfo();
    var res = await postData(apiLogoutSeeker, {
      "notifyToken": [
        {"model": _modelName}
      ]
    });

    print("logout: " + res);
  }

  removeSharedPreTokenAndLogOut() async {
    final prefs = await SharedPreferences.getInstance();
    await logOut();

    var removeEmployeeToken = await prefs.remove('employeeToken');
    AuthService().facebookSignOut();
    AuthService().googleSignOut();

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
          textTitle: "login info".tr,
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

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //General Infomation
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Text(
                                  "general info".tr,
                                  style: bodyTextNormal(null, FontWeight.bold),
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: AppColors.borderBG,
                              ),

                              //
                              //
                              //
                              //
                              //Phone Number
                              //Phone Number ຖ້າບໍ່ທັນມີ
                              _phoneNumber == ""
                                  ? AddGeneralInformation(
                                      title: "phone".tr,
                                      text: "add".tr + "phone".tr,
                                      iconLeft: FaIcon(
                                        FontAwesomeIcons.chevronRight,
                                        size: 13,
                                        color: AppColors.iconDark,
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
                                      title: "phone".tr,
                                      text: "020 ${_phoneNumber}",
                                      textColor: AppColors.fontDark,
                                    ),

                              //
                              //
                              //
                              //
                              //Email
                              //Email ຖ້າບໍ່ທັນມີ
                              _email == ""
                                  ? AddGeneralInformation(
                                      title: "email".tr,
                                      text: "add".tr + "email".tr,
                                      iconLeft: FaIcon(
                                        FontAwesomeIcons.chevronRight,
                                        size: 13,
                                        color: AppColors.iconDark,
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
                                      title: "email".tr,
                                      text: _email,
                                      textColor: AppColors.fontDark,
                                    ),

                              //
                              //
                              //
                              //
                              //Password
                              if (_phoneNumber != "" || _email != "")
                                _passwordStatus
                                    ? AddGeneralInformation(
                                        title: "password".tr,
                                        text: "change password".tr,
                                        iconLeft: FaIcon(
                                          FontAwesomeIcons.chevronRight,
                                          size: 13,
                                          color: AppColors.iconDark,
                                        ),
                                        press: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangePassword(),
                                            ),
                                          );
                                        },
                                      )
                                    : AddGeneralInformation(
                                        title: "password".tr,
                                        text: "set pass".tr,
                                        iconLeft: FaIcon(
                                          FontAwesomeIcons.chevronRight,
                                          size: 13,
                                          color: AppColors.iconDark,
                                        ),
                                        press: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SetPasswordPlatforms(),
                                            ),
                                          ).then((value) {
                                            print(value);
                                            if (value ==
                                                "set password platform successful") {
                                              checkSeekerInfo();
                                            }
                                          });
                                          ;
                                        },
                                      ),

                              //
                              //
                              //
                              //
                              //Delete account
                              AddGeneralInformation(
                                title: "delete account".tr,
                                text: "",
                                iconLeft: FaIcon(
                                  FontAwesomeIcons.chevronRight,
                                  size: 13,
                                  color: AppColors.iconDark,
                                ),
                                press: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DeleteAccount(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),

                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //Connect other Platforms
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Text(
                                  "connect platforms".tr,
                                  style: bodyTextNormal(null, FontWeight.bold),
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: AppColors.borderBG,
                              ),

                              //
                              //
                              //
                              //
                              //Google connect
                              GestureDetector(
                                onTap: () async {
                                  if (_googleId == "" && _googleEmail == "") {
                                    AuthService().loginSyncGoogleFacebook(
                                        context, "google", (val) {
                                      print(val);
                                      if (val == "Sync successful") {
                                        checkSeekerInfo();
                                      }
                                    });
                                  } else if (_googleId != "" &&
                                          _googleEmail != "" &&
                                          _passwordStatus != "" &&
                                          _email != "" ||
                                      _phoneNumber != "") {
                                    var result = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return SimpleAlertDialog(
                                            title: "disconnect".tr,
                                            contentText:
                                                "are u sure disconnect".tr,
                                            textLeft: "cancel".tr,
                                            textRight: 'confirm'.tr,
                                          );
                                        });
                                    if (result == 'Ok') {
                                      var res = await postData(
                                          apiDisconnectGoogleFacebookAip, {
                                        "id": _googleId,
                                        "email": _googleEmail,
                                        "type": "google",
                                      });
                                      if (res["message"] != null) {
                                        await checkSeekerInfo();
                                        await showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return CustomAlertDialogSuccessButtonConfirm(
                                              title: "Disconnect Google",
                                              text: "Disconnect google success",
                                              textButton: "ok".tr,
                                              press: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        );
                                      }
                                    }
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DeleteAccount(),
                                      ),
                                    );
                                  }
                                },
                                child: ConnectOtherPlatform(
                                  title: "Google",
                                  strImage: 'assets/image/google.png',
                                  text: _googleId != ""
                                      ? _googleEmail
                                      : "link".tr,
                                ),
                              ),

                              //
                              //
                              //
                              //
                              //Facebook connect
                              GestureDetector(
                                onTap: () async {
                                  if (_facebookId == "" &&
                                      _facebookEmail == "") {
                                    AuthService().loginSyncGoogleFacebook(
                                        context, "facebook", (val) {
                                      print(val);
                                      if (val == "Sync successful") {
                                        checkSeekerInfo();
                                      }
                                    });
                                  } else if (_facebookId != "" &&
                                          _facebookEmail != "" &&
                                          _passwordStatus != "" &&
                                          _email != "" ||
                                      _phoneNumber != "") {
                                    var result = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return SimpleAlertDialog(
                                            title: "disconnect".tr,
                                            contentText:
                                                "are u sure disconnect".tr,
                                            textLeft: "cancel".tr,
                                            textRight: 'confirm'.tr,
                                          );
                                        });
                                    if (result == 'Ok') {
                                      var res = await postData(
                                          apiDisconnectGoogleFacebookAip, {
                                        "id": _facebookId,
                                        "email": _facebookEmail,
                                        "type": "facebook",
                                      });
                                      if (res["message"] != null) {
                                        await checkSeekerInfo();
                                        await showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return CustomAlertDialogSuccessButtonConfirm(
                                              title: "Disconnect Facebook",
                                              text:
                                                  "Disconnect facebook success",
                                              textButton: "ok".tr,
                                              press: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        );
                                      }
                                    }
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DeleteAccount(),
                                      ),
                                    );
                                  }
                                },
                                child: ConnectOtherPlatform(
                                  title: "Facebook",
                                  strImage: 'assets/image/facebook.png',
                                  text: _facebookId != ""
                                      ? _facebookEmail
                                      : "link".tr,
                                ),
                              ),

                              //
                              //
                              //
                              //
                              //Apple connect
                              if (Platform.isIOS)
                                GestureDetector(
                                  onTap: () async {
                                    if (_appleId == "" && _appleEmail == "") {
                                      AuthService().loginSyncGoogleFacebook(
                                          context, "apple", (val) {
                                        print(val);
                                        if (val == "Sync successful") {
                                          checkSeekerInfo();
                                        }
                                      });
                                    } else if (_appleEmail != "" &&
                                            _appleId != "" &&
                                            _passwordStatus != "" &&
                                            _email != "" ||
                                        _phoneNumber != "") {
                                      var result = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleAlertDialog(
                                              title: "disconnect".tr,
                                              contentText:
                                                  "are u sure disconnect".tr,
                                              textLeft: "cancel".tr,
                                              textRight: 'confirm'.tr,
                                            );
                                          });
                                      if (result == 'Ok') {
                                        var res = await postData(
                                            apiDisconnectGoogleFacebookAip, {
                                          "id": _appleId,
                                          "email": _appleEmail,
                                          "type": "apple",
                                        });
                                        if (res["message"] != null) {
                                          await checkSeekerInfo();
                                          await showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return CustomAlertDialogSuccessButtonConfirm(
                                                title: "Disconnect Apple",
                                                text:
                                                    "Disconnect apple success",
                                                textButton: "ok".tr,
                                                press: () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                            },
                                          );
                                        }
                                      }
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DeleteAccount(),
                                        ),
                                      );
                                    }
                                  },
                                  child: ConnectOtherPlatform(
                                    title: "Apple",
                                    strImage: 'assets/image/apple.png',
                                    text: _appleId != ""
                                        ? _appleEmail
                                        : "link".tr,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        //
                        //
                        //
                        //
                        //
                        //
                        //
                        //
                        //
                        //Log Out
                        GestureDetector(
                          onTap: () async {
                            var result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleAlertDialog(
                                    title: "logout".tr,
                                    contentText: "are u sure logout".tr,
                                    textLeft: "cancel".tr,
                                    textRight: 'confirm'.tr,
                                  );
                                });
                            if (result == 'Ok') {
                              removeSharedPreTokenAndLogOut();
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
                                  "logout".tr,
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
          child: GestureDetector(
            onTap: widget.press,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.title}",
                  style: bodyTextNormal(null, null),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Text(
                        "${widget.text}",
                        style: bodyTextNormal(
                            widget.textColor == null
                                ? AppColors.fontDark
                                : widget.textColor,
                            null),
                      ),
                    ),
                    Container(
                      child: widget.iconLeft,
                    )
                  ],
                ),
              ],
            ),
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
      {Key? key, this.title, this.text, required this.strImage, this.press})
      : super(key: key);
  final String? title, text;
  final String strImage;
  final Function()? press;

  @override
  State<ConnectOtherPlatform> createState() => _ConnectOtherPlatformState();
}

class _ConnectOtherPlatformState extends State<ConnectOtherPlatform> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.press,
          child: Container(
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
        ),
        Divider(
          height: 1,
          color: AppColors.borderBG,
        ),
      ],
    );
  }
}
