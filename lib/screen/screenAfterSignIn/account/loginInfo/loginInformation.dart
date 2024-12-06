// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_adjacent_string_concatenation, non_constant_identifier_names, unnecessary_string_interpolations, prefer_final_fields, unused_field, prefer_if_null_operators, unnecessary_brace_in_string_interps, unused_local_variable, avoid_print, file_names, unrelated_type_equality_checks

import 'dart:io';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/auth_service.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/screen/screenAfterSignIn/account/loginInfo/add_updatePhoneEmail.dart';
import 'package:app/screen/screenAfterSignIn/account/loginInfo/changePassword.dart';
import 'package:app/screen/screenAfterSignIn/account/loginInfo/deleteAccount.dart';
import 'package:app/screen/screenAfterSignIn/account/loginInfo/setPassPlatforms.dart';
import 'package:app/widget/appbar.dart';
import 'package:apple_product_name/apple_product_name.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

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
    if (Platform.isIOS) {
      AuthService().appleSignOut();
    }

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
                                  style: bodyTextNormal(
                                      null, null, FontWeight.bold),
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
                              AddGeneralInformation(
                                title: "phone".tr,
                                text: _phoneNumber == ""
                                    ? "add".tr + "phone".tr
                                    : "020 ${_phoneNumber}",
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
                                          AddUpdatePhoneNumberEmail(
                                        phoneNumber: _phoneNumber,
                                        addPhoneNumOrEmail: 'phoneNumber',
                                      ),
                                    ),
                                  );
                                },
                              ),

                              //
                              //
                              //
                              //
                              //Email
                              AddGeneralInformation(
                                title: "email".tr,
                                text: _email == ""
                                    ? "add".tr + "email".tr
                                    : "${_email}",
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
                                          AddUpdatePhoneNumberEmail(
                                        email: _email,
                                        addPhoneNumOrEmail: 'email',
                                      ),
                                    ),
                                  );
                                },
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
                                  style: bodyTextNormal(
                                      null, null, FontWeight.bold),
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
                              ConnectOtherPlatform(
                                title: "Google",
                                strImage: 'assets/image/google.png',
                                text:
                                    _googleId != "" ? _googleEmail : "link".tr,
                                press: () async {
                                  //
                                  //
                                  //ເລືອກອີເມວເຊື່ອມຕໍ່ແພັດຟອມ google
                                  if (_googleId == "" && _googleEmail == "") {
                                    AuthService().loginSyncGoogleFacebook(
                                        context, "google", (val) {
                                      print(val);
                                      if (val == "Sync successfully") {
                                        checkSeekerInfo();
                                      }
                                    });
                                  }
                                  //
                                  //
                                  //ຍົກເລີກເຊື່ອມຕໍ່ແພັດຟອມ google
                                  else if (_googleId != "" &&
                                          _googleEmail != "" &&
                                          _passwordStatus != "" &&
                                          _email != "" ||
                                      _phoneNumber != "") {
                                    var result = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                            title: "disconnect".tr +
                                                " " +
                                                "Google",
                                            contentText: _googleEmail,
                                            textButtonLeft: "cancel".tr,
                                            textButtonRight: 'confirm'.tr,
                                          );
                                        });
                                    if (result == 'Ok') {
                                      //
                                      //
                                      //Alert dialog loading
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return CustAlertLoading();
                                        },
                                      );

                                      var res = await postData(
                                          apiDisconnectGoogleFacebookAip, {
                                        "id": _googleId,
                                        "email": _googleEmail,
                                        "type": "google",
                                      });
                                      AuthService().googleSignOut();

                                      if (res["message"] != null) {
                                        Navigator.pop(context);
                                      }

                                      if (res["message"] == "disConnected") {
                                        await checkSeekerInfo();
                                        await showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return NewVer2CustAlertDialogSuccessBtnConfirm(
                                              boxCircleColor:
                                                  AppColors.warning200,
                                              iconColor: AppColors.warning600,
                                              title: "Google",
                                              contentText: "disConnected".tr,
                                              textButton: "ok".tr,
                                              buttonColor: AppColors.warning200,
                                              textButtonColor:
                                                  AppColors.warning600,
                                              widgetBottomColor:
                                                  AppColors.warning200,
                                              press: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        );
                                      } else if (res["message"] ==
                                          "Can not disConnect") {
                                        await checkSeekerInfo();
                                        await showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return CustAlertDialogWarningWithoutBtn(
                                              title: "warning".tr,
                                              contentText:
                                                  "Can not disConnect".tr,
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
                              ),

                              //
                              //
                              //
                              //
                              //Facebook connect
                              ConnectOtherPlatform(
                                title: "Facebook",
                                strImage: 'assets/image/facebook.png',
                                text: _facebookId != ""
                                    ? _facebookEmail
                                    : "link".tr,
                                press: () async {
                                  //
                                  //
                                  //ເລືອກອີເມວເຊື່ອມຕໍ່ແພັດຟອມ facebook
                                  if (_facebookId == "" &&
                                      _facebookEmail == "") {
                                    AuthService().loginSyncGoogleFacebook(
                                        context, "facebook", (val) async {
                                      print(val);
                                      if (val == "Sync successfully") {
                                        await checkSeekerInfo();
                                      }
                                    });
                                  }
                                  //
                                  //
                                  //ຍົກເລີກເຊື່ອມຕໍ່ແພັດຟອມ facebook
                                  else if (_facebookId != "" &&
                                          _facebookEmail != "" &&
                                          _passwordStatus != "" &&
                                          _email != "" ||
                                      _phoneNumber != "") {
                                    var result = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                            title: "disconnect".tr +
                                                " " +
                                                "Facebook",
                                            contentText: _facebookEmail,
                                            textButtonLeft: "cancel".tr,
                                            textButtonRight: 'confirm'.tr,
                                          );
                                        });
                                    if (result == 'Ok') {
                                      //
                                      //
                                      //Alert dialog loading
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return CustAlertLoading();
                                        },
                                      );

                                      var res = await postData(
                                          apiDisconnectGoogleFacebookAip, {
                                        "id": _facebookId,
                                        "email": _facebookEmail,
                                        "type": "facebook",
                                      });

                                      AuthService().facebookSignOut();

                                      if (res["message"] != null) {
                                        Navigator.pop(context);
                                      }
                                      if (res["message"] == "disConnected") {
                                        await checkSeekerInfo();
                                        await showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return NewVer2CustAlertDialogSuccessBtnConfirm(
                                              boxCircleColor:
                                                  AppColors.warning200,
                                              iconColor: AppColors.warning600,
                                              title: "Facebook",
                                              contentText: "disConnected".tr,
                                              textButton: "ok".tr,
                                              buttonColor: AppColors.warning200,
                                              textButtonColor:
                                                  AppColors.warning600,
                                              widgetBottomColor:
                                                  AppColors.warning200,
                                              press: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        );
                                      } else if (res["message"] ==
                                          "Can not disConnect") {
                                        await checkSeekerInfo();
                                        await showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return CustAlertDialogWarningWithoutBtn(
                                              title: "warning".tr,
                                              contentText:
                                                  "Can not disConnect".tr,
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
                              ),

                              //
                              //
                              //
                              //
                              //Apple connect
                              if (Platform.isIOS)
                                ConnectOtherPlatform(
                                  title: "Apple",
                                  strImage: 'assets/image/apple.png',
                                  text:
                                      _appleId != "" ? _appleEmail : "link".tr,
                                  press: () async {
                                    //
                                    //
                                    //ເລືອກອີເມວເຊື່ອມຕໍ່ແພັດຟອມ apple
                                    if (_appleId == "" && _appleEmail == "") {
                                      AuthService().loginSyncGoogleFacebook(
                                          context, "apple", (val) async {
                                        print(val);
                                        if (val == "Sync successfully") {
                                          await checkSeekerInfo();
                                        }
                                      });
                                    }
                                    //
                                    //
                                    //ຍົກເລີກເຊື່ອມຕໍ່ແພັດຟອມ apple
                                    else if (_appleEmail != "" &&
                                            _appleId != "" &&
                                            _passwordStatus != "" &&
                                            _email != "" ||
                                        _phoneNumber != "") {
                                      var result = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                              title: "disconnect".tr +
                                                  " " +
                                                  "Apple",
                                              contentText: _appleEmail,
                                              textButtonLeft: "cancel".tr,
                                              textButtonRight: 'confirm'.tr,
                                            );
                                          });
                                      if (result == 'Ok') {
                                        //
                                        //
                                        //Alert dialog loading
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return CustAlertLoading();
                                          },
                                        );

                                        var res = await postData(
                                            apiDisconnectGoogleFacebookAip, {
                                          "id": _appleId,
                                          "email": _appleEmail,
                                          "type": "apple",
                                        });
                                        AuthService().facebookSignOut();

                                        if (res["message"] != null) {
                                          Navigator.pop(context);
                                        }

                                        if (res["message"] == "disConnected") {
                                          await checkSeekerInfo();
                                          await showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return NewVer2CustAlertDialogSuccessBtnConfirm(
                                                boxCircleColor:
                                                    AppColors.warning200,
                                                iconColor: AppColors.warning600,
                                                title: "Apple",
                                                contentText: "disConnected".tr,
                                                textButton: "ok".tr,
                                                buttonColor:
                                                    AppColors.warning200,
                                                textButtonColor:
                                                    AppColors.warning600,
                                                widgetBottomColor:
                                                    AppColors.warning200,
                                                press: () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                            },
                                          );
                                        } else if (res["message"] ==
                                            "Can not disConnect") {
                                          await checkSeekerInfo();
                                          await showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return CustAlertDialogWarningWithoutBtn(
                                                title: "warning".tr,
                                                contentText:
                                                    "Can not disConnect".tr,
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
                        //Button Log Out
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              var result = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                      title: "logout".tr,
                                      contentText: "are u sure logout".tr,
                                      textButtonLeft: "cancel".tr,
                                      textButtonRight: 'confirm'.tr,
                                    );
                                  });
                              if (result == 'Ok') {
                                removeSharedPreTokenAndLogOut();
                              }
                            },
                            child: Container(
                              width: 50.w,
                              padding: EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                      FontAwesomeIcons.arrowRightFromBracket),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "logout".tr,
                                    style: bodyTextNormal(
                                        null, null, FontWeight.bold),
                                  ),
                                ],
                              ),
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
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.press,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.title}",
                    style: bodyTextNormal(null, null, null),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Text(
                          "${widget.text}",
                          style: bodyTextNormal(
                              null,
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
        Material(
          color: Colors.transparent,
          child: InkWell(
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
                        style: bodyTextNormal(null, null, null),
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
                      style: bodyTextNormal(null, AppColors.fontGrey, null),
                    ),
                  )
                ],
              ),
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
