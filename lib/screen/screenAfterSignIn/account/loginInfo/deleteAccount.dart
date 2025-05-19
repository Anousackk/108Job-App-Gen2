// ignore_for_file: unused_local_variable, prefer_const_constructors, use_full_hex_values_for_flutter_colors

import 'dart:io';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/auth_service.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:apple_product_name/apple_product_name.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  String _modelName = "";

  deleteAccount() async {
    var res = await postData(apiDeleteAccountSeeker, {});
    print("delete accoutn: " + res.toString());
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

    print("logout: " + res.toString());
  }

  deleteAccoutnRemoveSharedPreTokenLogOut() async {
    final prefs = await SharedPreferences.getInstance();
    await logOut();
    await deleteAccount();

    var removeEmployeeToken = await prefs.remove('employeeToken');
    AuthService().facebookSignOut();
    AuthService().googleSignOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBarDefault(
          textTitle: "delete account".tr,
          leadingPress: () {
            Navigator.pop(context);
          },
          leadingIcon: Icon(Icons.arrow_back),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundWhite,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text("account_delete_title".tr),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundWhite,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "\uf65c",
                                  style:
                                      fontAwesomeRegular(null, 20, null, null),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Flexible(
                                  child: Text(
                                    "account_delete_1".tr,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Text(
                                  "\uf056",
                                  style:
                                      fontAwesomeRegular(null, 20, null, null),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Flexible(
                                  child: Text(
                                    "account_delete_2".tr,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Text(
                                  "\uf0f3",
                                  style:
                                      fontAwesomeRegular(null, 20, null, null),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Flexible(
                                  child: Text(
                                    "account_delete_3".tr,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Text(
                                  "\uf05e",
                                  style:
                                      fontAwesomeRegular(null, 20, null, null),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Flexible(
                                  child: Text(
                                    "account_delete_4".tr,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Text(
                                  "\uf2ea",
                                  style:
                                      fontAwesomeRegular(null, 20, null, null),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Flexible(
                                  child: Text(
                                    "account_delete_5".tr,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //
              //
              //
              //
              //
              //Button Save job and Apply job
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x000000).withOpacity(0.05),
                      offset: Offset(0, -6),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                  // border: Border(
                  //   top: BorderSide(color: AppColors.borderGreyOpacity),
                  // ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SimpleButton(
                        colorButton: AppColors.background,
                        colorText: AppColors.fontDark,
                        text: "cancel".tr,
                        press: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: SimpleButton(
                        colorButton: AppColors.warning,
                        colorText: AppColors.fontWhite,
                        text: "continue".tr,
                        press: () async {
                          var result = await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                  title: "delete account".tr,
                                  contentText: "are u sure delete account".tr,
                                  textButtonLeft: "cancel".tr,
                                  textButtonRight: 'confirm'.tr,
                                );
                              });
                          if (result == 'Ok') {
                            deleteAccoutnRemoveSharedPreTokenLogOut();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
