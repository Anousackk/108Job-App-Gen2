// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'package:app/functions/alert_dialog.dart';
import 'package:app/provider/eventAvailableProvider.dart';
import 'package:app/screen/screenAfterSignIn/account/myProfile/myProfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

mixin EventAvailableHelper<T extends StatefulWidget> on State<T> {
  applyEventHelper({VoidCallback? onPressOkay}) async {
    final eventAvailableProvider = context.read<EventAvailableProvider>();
    //
    // Display AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    final res = await eventAvailableProvider.applyEvent(context);

    final statusCode = res?["statusCode"];

    if (!context.mounted) return;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    if (statusCode == 200 || statusCode == 201) {
      showDialog(
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "successfully".tr,
            contentText: "registered_attend".tr,
            textButton: "ok".tr,
            press: onPressOkay ?? () => Navigator.pop(context),
            // press: () {
            //   Navigator.of(context).pop(); // Close dialog
            // },
          );
        },
      );

      await eventAvailableProvider.fetchEventAvailable();
      await eventAvailableProvider.fetchStatisticEvent();
      await eventAvailableProvider.fetchCheckInBoothBySeeker();
    } else if (statusCode == 409) {
      var result = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return NewVer2CustAlertDialogWarningBtnConfirmCancel(
              title: "title_pls_update_profile".tr,
              contentText: "text_pls_update_profile_complete".tr,
              textButtonLeft: "cancel".tr,
              textButtonRight: 'continue'.tr,
            );
          });
      if (result == "Ok") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyProfile(
              status: "Event",
            ),
          ),
        );
      }
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "${res?["body"]?["message"]}",
          );
        },
      );
    }
  }

  checkInBoothCompanyEventHelper(String qrString, String code,
      {VoidCallback? onPressOkay, VoidCallback? onPressOkayWarning}) async {
    final eventAvailableProvider = context.read<EventAvailableProvider>();
    // Display AlertDialog Loading First
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    final res =
        await eventAvailableProvider.checkInBoothCompanyEvent(qrString, code);
    final statusCode = res?["statusCode"];

    if (!context.mounted) return;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    if (statusCode == 200 || statusCode == 201) {
      // Display success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "successfully".tr,
            contentText: "booth_check_in".tr + " " + "successfully".tr,
            textButton: "ok".tr,
            press: onPressOkay ?? () => Navigator.pop(context),
          );
        },
      );
      await eventAvailableProvider.fetchCheckInBoothBySeeker();
    } else {
      // Display dialog warning
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return NewVer5CustAlertDialogWarningBtnConfirm(
            title: "warning".tr,
            contentText: "${res?["body"]?["message"]}",
            textButton: "ok".tr,
            press: onPressOkayWarning ?? () => Navigator.pop(context),
          );
        },
      );
    }
  }

  applyJobCompanyBySeekerHelper(String jobId) async {
    final eventAvailableProvider = context.read<EventAvailableProvider>();

    // Display AlertDialog Loading First
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );
    final res = await eventAvailableProvider.applyJobCompanyBySeeker(jobId);
    final statusCode = res?["statusCode"];

    if (!context.mounted) return;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    if (statusCode == 200 || statusCode == 201) {
      // Display success dialog
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "successfully".tr,
            contentText: "applied_success".tr,
            textButton: "ok".tr,
            press: () async {
              // Close success dialog
              Navigator.of(dialogContext).pop();
            },
          );
        },
      );

      await eventAvailableProvider.fetchCompanyByIdListPosition();
      await eventAvailableProvider.fetchAIMatchingJobAndAppliedJob();
    } else {
      // Display warning dialog
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "already_applied".tr,
          );
        },
      );
    }
  }

  reedeemCodeEventHelper(String redeemCode, {VoidCallback? onPressOkay}) async {
    final eventAvailableProvider = context.read<EventAvailableProvider>();

    // Display AlertDialog Loading First
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );
    final res = await eventAvailableProvider.reedeemCodeEvent(redeemCode);
    final statusCode = res?["statusCode"];

    if (!context.mounted) return;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    if (statusCode == 200 || statusCode == 201) {
      // Display success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "successfully".tr,
            contentText: "redeem_reward".tr + " " + "successfully".tr,
            textButton: "ok".tr,
            press: onPressOkay ?? () => Navigator.pop(context),
          );
        },
      );

      await eventAvailableProvider.fetchCheckInBoothBySeeker();
    } else {
      // Display dialog warning
      showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "${res?["body"]?["message"]}",
          );
        },
      );
    }
  }
}
