// ignore_for_file: avoid_print

import 'package:app/functions/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showInternetDisconnected(BuildContext context) async {
  print("show alert internet disconnected");
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return NewVer5CustAlertDialogWarningBtnConfirm(
        title: "warning".tr,
        contentText: "check_internet_again".tr,
        textButton: "ok".tr,
        press: () async {
          Navigator.pop(context);
        },
      );
    },
  );
}
