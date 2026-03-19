// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/colors.dart';
import 'package:app/provider/jobSearchProvider.dart';
import 'package:app/provider/profileDashboardStatus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

mixin JobSearchHelper<T extends StatefulWidget> on State<T> {
  saveAndUnSaveJobHelper(
    String jobId,
    String jobTitle, {
    VoidCallback? onPressOkay,
  }) async {
    final jobSearchProvider = context.read<JobSearchProvider>();

    //
    // Display AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    final res = await jobSearchProvider.saveAndUnSaveJob(jobId);
    final statusCode = res?["statusCode"];
    if (!context.mounted) return null;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    if (statusCode == 200 || statusCode == 201) {
      if (res?["body"]["message"] == "Saved") {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => NewVer2CustAlertDialogSuccessBtnConfirm(
            strIcon: "\uf004",
            title: "save job".tr + " " + "successfully".tr,
            contentText: jobTitle,
            textButton: "ok".tr,
            press: onPressOkay ?? () => Navigator.pop(context), //default
          ),
        );
      } else if (res?["body"]["message"] == "Unsaved") {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => NewVer2CustAlertDialogSuccessBtnConfirm(
            strIcon: "\uf7a9",
            boxCircleColor: AppColors.warning200,
            iconColor: AppColors.warning600,
            title: "unsave job".tr + " " + "successfully".tr,
            contentText: jobTitle,
            textButton: "ok".tr,
            buttonColor: AppColors.warning200,
            textButtonColor: AppColors.warning600,
            widgetBottomColor: AppColors.warning200,
            press: onPressOkay ?? () => Navigator.pop(context), //default
          ),
        );
      }

      context
          .read<ProfileDashboardStatusProvider>()
          .fetchProfileDashboardStatus();
    } else {
      await showDialog(
        context: context,
        builder: (context) => CustAlertDialogWarningWithoutBtn(
          title: "warning".tr,
          contentText: "${res?["body"]?["message"]}",
        ),
      );
    }
  }

  hideJobHelper(
    String jobId,
    String jobTitle, {
    VoidCallback? onPressOkay,
  }) async {
    final jobSearchProvider = context.read<JobSearchProvider>();

    //
    // Display AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    final res = await jobSearchProvider.hideJob(jobId);
    final statusCode = res?["statusCode"];
    if (!context.mounted) return null;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    if (statusCode == 200 || statusCode == 201) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "hide job".tr + " " + "successfully".tr,
            contentText: "$jobTitle ",
            textButton: "ok".tr,
            press: onPressOkay ?? () => Navigator.pop(context), //default
          );
        },
      );

      context
          .read<ProfileDashboardStatusProvider>()
          .fetchProfileDashboardStatus();
    } else {
      await showDialog(
        context: context,
        builder: (context) => CustAlertDialogWarningWithoutBtn(
          title: "warning".tr,
          contentText: "${res?["body"]?["message"]}",
        ),
      );
    }
  }
}
