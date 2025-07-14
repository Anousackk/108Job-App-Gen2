// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_final_fields, unnecessary_brace_in_string_interps, avoid_print, sdk_version_since, avoid_unnecessary_containers, unused_local_variable

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScanner extends StatefulWidget {
  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Key scannerKey = UniqueKey(); // used to force rebuild
  MobileScannerController scannerController = MobileScannerController(
    useNewCameraSelector: true,
    detectionTimeoutMs: 1000,
  );
  bool isScannerActive = true;
  bool isMobileScanner = true;

  applyByJobId(String jobId) async {
    var res = await postData(applyJobIdSeekerApi, {"_id": jobId});
    print("res applyByJobId: " + res.toString());

    if (res["message"] == "Your applied is complete.") {
      // ສະແດງ success dialog
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "successful".tr,
            contentText: "applied_success".tr,
            textButton: "ok".tr,
            press: () async {
              // ປິດ success dialog
              Navigator.of(dialogContext).pop();

              // ຖ້າ success dialog ປີດກ່ອນແລ້ວຈຶ່ງກັບໄປໜ້າ Account
              await Future.delayed(Duration(milliseconds: 200));

              // ກັບໄປໜ້າ Account
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          );
        },
      );

      return true;
    } else {
      // ສະແດງ warning dialog
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) {
          return NewVer5CustAlertDialogWarningBtnConfirm(
            title: "warning".tr,
            contentText: "already_applied".tr,
            textButton: "ok".tr,
            press: () async {
              // ປິດ success dialog
              Navigator.of(dialogContext).pop();

              // ຖ້າ success dialog ປີດກ່ອນແລ້ວຈຶ່ງກັບໄປໜ້າ Account
              await Future.delayed(Duration(milliseconds: 200));

              // ກັບໄປໜ້າ Account
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          );
        },
      );

      return true;
    }
  }

  openLaunchURLBrowser(String url) async {
    print("openLaunchURL: ${url}");

    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      //ສະແດງ AlertDialog Loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomLoadingLogoCircle();
        },
      );

      await launchUrl(uri, mode: LaunchMode.externalApplication);
      Future.delayed(Duration(seconds: 2), () async {
        // ປິດ loading dialog first
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }

        // ຖ້າ loading dialog ປີດກ່ອນແລ້ວຈຶ່ງກັບໄປໜ້າ Account
        await Future.delayed(Duration(milliseconds: 200));

        // ກັບໄປໜ້າ Account
        if (Navigator.canPop(context)) Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('can not open URL: $url')),
      );
    }
  }

  onDetect(BarcodeCapture barcode) async {
    final code = barcode.barcodes.firstOrNull?.rawValue;
    print("Print Code: ${code}");

    if (code != null) {
      // ປິດສະແກນ
      await scannerController.stop();
      setState(() {
        isScannerActive = false;
      });
      print("Scanned code: $code");

      // ຖ້າວ່າ code ມີ "id" ຈະຕັດຄຳອອກ(id)ແລ້ວເອົາແຕ່ຄ່າທີ່ຢູ່ຫຼັງ id
      if (code.contains("id")) {
        String id = code.split("id").last;
        print("job wii/ job fest id: $id");

        applyByJobId(id.toString());
      }
      // ຖ້າວ່າ code ບໍ່ມີ "id" ຈະສະແດງ warning dialog
      else {
        print("no id found.");

        // ສະແດງ warning dialog
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (dialogContext) {
            return NewVer5CustAlertDialogWarningBtnConfirm(
              title: "warning".tr,
              contentText: "incorrect_qr_code".tr + "\n(${code})",
              textButton: "ok".tr,
              press: () async {
                // ປິດ success dialog
                Navigator.of(dialogContext).pop();

                // ຖ້າ success dialog ປີດກ່ອນແລ້ວຈຶ່ງກັບໄປໜ້າ Account
                await Future.delayed(Duration(milliseconds: 200));

                // ກັບໄປໜ້າ Account
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
            );
          },
        );
      }

      // ຖ້າວ່າ code ເປັນແບບ url ຈະເຮັດຟັງຊັ້ນ openLaunchURLBrowser() ເພື່ອເປີດຢູ່ browser
      if (Uri.tryParse(code)?.hasAbsolutePath == true) {
        print("Open LaunchURL working");

        await openLaunchURLBrowser(code);
      }
    }
  }

  checkCameraPermission() async {
    var status = await Permission.camera.status;
    print("camera status: ${status}");

    if (status.isGranted) {
      print("permission camera status isGranted");

      return true;
    } else if (status.isDenied || status.isRestricted) {
      print("permission camera status isDenied or isRestricted");
      var result = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return NewVer2CustAlertDialogWarningBtnConfirmCancel(
              title: "Camera Permission",
              contentText:
                  "'108Jobs' would like to allow your camera request for scan QR code",
              textButtonLeft: "cancel".tr,
              textButtonRight: 'confirm'.tr,
            );
          });
      if (result == 'Ok') {
        var permissionCameraReq = await Permission.camera.request();
        if (permissionCameraReq.isGranted) {
          scannerController.stop();

          setState(() {
            scannerKey = UniqueKey();
          });
          return true; // Return true when permission is granted
        } else {
          checkCameraPermission();
        }
      } else if (result == 'Cancel') {
        // ກັບໄປໜ້າ Account
        if (Navigator.canPop(context)) Navigator.pop(context);
      }

      return false;
    } else if (status.isPermanentlyDenied) {
      print("permission camera status isPermanentlyDenied");

      var result = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return NewVer2CustAlertDialogWarningBtnConfirmCancel(
              title: "Camera Permission",
              contentText:
                  "'108Jobs' would like to allow your camera setting for scan QR code",
              textButtonLeft: "cancel".tr,
              textButtonRight: 'confirm'.tr,
            );
          });
      if (result == 'Ok') {
        await openAppSettings();

        Future.delayed(Duration(seconds: 1), () {
          // ກັບໄປໜ້າ Account
          if (Navigator.canPop(context)) Navigator.pop(context);
        });
      } else if (result == 'Cancel') {
        // ກັບໄປໜ້າ Account
        if (Navigator.canPop(context)) Navigator.pop(context);
      }
      return false;
    } else {
      print("permission camera status etc...");

      var result = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return NewVer2CustAlertDialogWarningBtnConfirmCancel(
              title: "Camera Permission",
              contentText:
                  "'108Jobs' would like to allow your camera setting for scan QR code",
              textButtonLeft: "cancel".tr,
              textButtonRight: 'confirm'.tr,
            );
          });
      if (result == 'Ok') {
        await openAppSettings();

        // ກັບໄປໜ້າ Account
        if (Navigator.canPop(context)) Navigator.pop(context);
      } else if (result == 'Cancel') {
        // ກັບໄປໜ້າ Account
        if (Navigator.canPop(context)) Navigator.pop(context);
      }
      return false;
    }
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        textTitle: "scan_qr".tr,
        leadingPress: () {
          Navigator.pop(context);
        },
        leadingIcon: Icon(Icons.arrow_back),
      ),
      body: MobileScanner(
        key: scannerKey, //force rebuild when key changes
        controller: scannerController,
        onDetect: onDetect,
        overlayBuilder: (context, constraints) {
          return isScannerActive
              ? Center(
                  child: CustomPaint(
                    painter: BorderOverlayPainter(),
                    size: const Size(250, 250),
                  ),
                )
              : Container();
        },
        errorBuilder: (context, error, stackTrace) {
          print("Mobile scanner error: " + "${error.errorCode.message}");
          if (error.errorCode.message.isNotEmpty) {
            checkCameraPermission();
          }
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.backgroundWhite,
          );
        },
      ),
    );
  }
}

class BorderOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary100
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const double cornerLength = 30;

    final path = Path();

    // Top Left Corner
    path.moveTo(0, cornerLength);
    path.lineTo(0, 0);
    path.lineTo(cornerLength, 0);

    // Top Right Corner
    path.moveTo(size.width - cornerLength, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, cornerLength);

    // Bottom Right Corner
    path.moveTo(size.width, size.height - cornerLength);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - cornerLength, size.height);

    // Bottom Left Corner
    path.moveTo(cornerLength, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
