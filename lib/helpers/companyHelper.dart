// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/colors.dart';
import 'package:app/provider/companyProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

mixin CompanyHelper<T extends StatefulWidget> on State<T> {
  followAndUnFollowCompanyHelper(
    String companyId,
    String companyName, {
    VoidCallback? onPressOkay,
  }) async {
    final companyProvider = context.read<CompanyProvider>();

    //
    // Display AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    final res = await companyProvider.followAndUnFollowComapny(companyId);
    final statusCode = res?["statusCode"];
    if (!context.mounted) return null;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    if (statusCode == 200 || statusCode == 201) {
      if (res?["body"]["message"] == "Followed") {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return NewVer2CustAlertDialogSuccessBtnConfirm(
              strIcon: "\uf004",
              title: "follow".tr + " " + "successfully".tr,
              contentText: "$companyName ",
              textButton: "ok".tr,
              press: onPressOkay ?? () => Navigator.pop(context),
            );
          },
        );
      } else if (res?["body"]["message"] == "Unfollow") {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return NewVer2CustAlertDialogSuccessBtnConfirm(
              strIcon: "\uf7a9",
              boxCircleColor: AppColors.warning200,
              iconColor: AppColors.warning600,
              title: "unfollow".tr + " " + "successfully".tr,
              contentText: "$companyName",
              textButton: "ok".tr,
              buttonColor: AppColors.warning200,
              textButtonColor: AppColors.warning600,
              widgetBottomColor: AppColors.warning200,
              press: onPressOkay ?? () => Navigator.pop(context),
            );
          },
        );
      }
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
