// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_field, avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/appbar.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WiiFairTicket extends StatefulWidget {
  const WiiFairTicket(
      {Key? key,
      required this.imageSrc,
      required this.firstName,
      required this.lastName})
      : super(key: key);
  final String imageSrc;
  final String firstName;
  final String lastName;

  @override
  State<WiiFairTicket> createState() => _WiiFairTicketState();
}

class _WiiFairTicketState extends State<WiiFairTicket> {
  final GlobalKey _globalKey = GlobalKey();

  saveLocalImage() async {
    //
    //
    //Request photos permission
    var statusPhotos = await Permission.photos.status; //IOS
    var statusMediaLibrary = await Permission.mediaLibrary.status; //Android

    //
    //
    //Device IOS
    if (Platform.isIOS) {
      print("Platform isIOS");
      print(statusPhotos);

      if (statusPhotos.isLimited) {
        print("photos isLimited");

        await openAppSettings();
      }
      if (statusPhotos.isGranted) {
        //display loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return CustomLoadingLogoCircle();
          },
        );

        // Find the boundary and capture image
        RenderRepaintBoundary boundary = _globalKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;

        // Convert to image
        //pixelRatio: 3.0 ຄວາມລະອຽດຂອງຮູບພາບ
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);

        // Save to gallery
        if (byteData != null) {
          //close loading dialog
          Navigator.pop(context);

          final result = await ImageGallerySaverPlus.saveImage(
              byteData.buffer.asUint8List());

          await showDialog(
            context: context,
            builder: (context) {
              return CustAlertDialogSuccessWithoutBtn(
                title: "successful".tr,
                contentText: "ບັນທຶກຮູບພາບສຳເລັດ",
              );
            },
          );

          print("IOS saved to photos: $result");
        }
      }
      if (statusPhotos.isDenied) {
        print("photos isDenied");
        // await Permission.photos.request();
        var result = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CupertinoAlertDialogOk(
              title: '“108 Jobs” Would like to Access Your Photos',
              contentText:
                  "'108Jobs' would like to access your Photos Access to your photo library is required to attach photos to change profile images.",
              text: 'Continue',
            );
          },
        );
        if (result == 'Ok') {
          await Permission.photos.request();
        }
      }
      if (statusPhotos.isPermanentlyDenied) {
        print("photos isPermanentlyDenied");
        var result = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CupertinoAlertDialogOk(
              title: '“108 Jobs” Would like to Access Your Photos',
              contentText:
                  "'108Jobs' would like to access your Photos Access to your photo library is required to attach photos to change profile images.",
              text: 'Continue',
            );
          },
        );
        if (result == 'Ok') {
          await openAppSettings();
        }
      }
    }

    //
    //
    //Device Android
    else if (Platform.isAndroid) {
      print("Platform isAndroid");
      print(statusMediaLibrary);

      if (statusMediaLibrary.isLimited) {
        print("mediaLibrary isLimited");
        await openAppSettings();
      }
      if (statusMediaLibrary.isGranted) {
        //display loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return CustomLoadingLogoCircle();
          },
        );
        // Find the boundary and capture image
        RenderRepaintBoundary boundary = _globalKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;

        // Convert to image
        //pixelRatio: 3.0 ຄວາມລະອຽດຂອງຮູບພາບ
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);

        // Save to gallery
        if (byteData != null) {
          //close loading dialog
          Navigator.pop(context);

          final result = await ImageGallerySaverPlus.saveImage(
              byteData.buffer.asUint8List());

          print("Android saved to gallery: $result");

          await showDialog(
            context: context,
            builder: (context) {
              return CustAlertDialogSuccessWithoutBtn(
                title: "successful".tr,
                contentText: "ບັນທຶກຮູບພາບສຳເລັດ",
              );
            },
          );
        } else {
          Navigator.pop(context);

          print("byteData == null andriod can not save image");

          await showDialog(
            context: context,
            builder: (context) {
              return CustAlertDialogWarningWithoutBtn(
                title: "warning".tr,
                contentText: "ບໍ່ສາມາດບັນທຶກຮູບພາບໄດ້".tr,
              );
            },
          );
        }
      }
      if (statusMediaLibrary.isDenied) {
        print("mediaLibrary isDenied");
        await Permission.photos.request();
      }
      if (statusMediaLibrary.isPermanentlyDenied) {
        print("mediaLibrary isPermanentlyDenied");
        await openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: AppColors.primary600,
        ),
        body: Container(
          height: double.infinity,
          color: AppColors.primary600,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                //
                //
                //
                //
                //
                //Appbar custom
                AppBarThreeWidgt(
                  //
                  //
                  //Widget Leading
                  //Navigator.pop
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 45,
                        width: 45,
                        color: AppColors.iconLight.withOpacity(0.1),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "\uf060",
                            style: fontAwesomeRegular(
                                null, 20, AppColors.iconLight, null),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //
                  //
                  //Widget Title
                  //Text title
                  title: Container(),

                  //
                  //
                  //Widget Actions
                  //Download ticket to be image
                  actions: GestureDetector(
                    onTap: () {
                      saveLocalImage();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 45,
                        width: 45,
                        color: AppColors.iconLight.withOpacity(0.1),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "\uf019",
                            style: fontAwesomeRegular(
                                null, 20, AppColors.iconLight, null),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //
                //
                //
                //
                //
                //Capture Widget Image
                RepaintBoundary(
                  key: _globalKey,
                  child: Container(
                    color: AppColors.primary600,
                    child: Column(
                      children: [
                        //
                        //
                        //
                        //
                        //
                        //Profile image and name
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              //
                              //
                              //Profile image
                              Container(
                                width: 110,
                                height: 110,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: widget.imageSrc == ""
                                      ? Image.asset(
                                          'assets/image/defprofile.jpg',
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          widget.imageSrc,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/image/defprofile.jpg',
                                              fit: BoxFit.cover,
                                            ); // Display an error message
                                          },
                                        ),
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),

                              //
                              //
                              //Profile firstName lastName
                              Text(
                                "${widget.firstName} ${widget.lastName}",
                                style: bodyTextMaxNormal(
                                    null, AppColors.fontWhite, FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),

                        //
                        //
                        //
                        //
                        //
                        //Box card ticket
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundWhite,
                            borderRadius: BorderRadius.circular(20),
                            // boxShadow: [
                            //   BoxShadow(
                            //     offset: Offset(3, 3),
                            //     blurRadius: 6,
                            //     color: AppColors.dark600.withOpacity(0.3),
                            //   )
                            // ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //
                              //
                              //QR coed
                              Container(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    QrImageView(
                                      padding: EdgeInsets.zero,
                                      data: 'WF-41X1D',
                                      size: 150,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'WF-41X1D',
                                      style: bodyTextMaxNormal(
                                          "NotoSansLaoLoopedSemiBold",
                                          null,
                                          null),
                                    ),
                                  ],
                                ),
                              ),

                              //
                              //
                              //Dotted line
                              Container(
                                height: 30,
                                color: AppColors.backgroundWhite,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    DottedLine(
                                      dashLength: 5,
                                      dashGapLength: 4,
                                      lineThickness: 2,
                                      dashColor: Colors.grey.shade400,
                                    ),

                                    //
                                    //
                                    //Left Half Circle
                                    Positioned(
                                      left: 0,
                                      child: Container(
                                        width: 20,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary600,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                          border: Border.all(
                                            color: AppColors.primary600,
                                            width: 0,
                                          ),
                                        ),
                                      ),
                                    ),

                                    //
                                    //
                                    //Right Half Circle
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        width: 20,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary600,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                          ),
                                          border: Border.all(
                                            color: AppColors.primary600,
                                            width: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 20,
                              ),

                              //
                              //
                              //Info ticket
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TicketWiiFairInfo(
                                      title: "ລາຍລະອຽດ:",
                                      text:
                                          "ງານຍ່າງເຂົ້າມາສຳພາດວຽກ WIIFAIR ຄັ້ງທີ່ 10",
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    TicketWiiFairInfo(
                                      title: "ສະຖານທີ່:",
                                      text: "ຫໍປະຊຸມແຫ່ງຊາດ",
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    TicketWiiFairInfo(
                                      title: "ແຜນທີ່:",
                                      text: "ກົດເບິ່ງແຜນທີ່",
                                      statusMap: "GoogleMap",
                                      link:
                                          "https://maps.app.goo.gl/uZwTyzZvtbbF1zRq8",
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    TicketWiiFairInfo(
                                      title: "ວັນທີ່ຈັດງານ:",
                                      text: "26 Aug 2025 ເວລາ 08:00 - 17:00",
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    TicketWiiFairInfo(
                                      title: "ລະຫັດຜູ້ເຂົ້າຮ່ວມງານ:",
                                      text: "WF-41X1D",
                                    ),
                                    //
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TicketWiiFairInfo extends StatefulWidget {
  final String title;
  final String text;
  final statusMap;
  final link;

  const TicketWiiFairInfo(
      {required this.title,
      required this.text,
      Key? key,
      this.statusMap,
      this.link})
      : super(key: key);

  @override
  State<TicketWiiFairInfo> createState() => _TicketWiiFairInfoState();
}

class _TicketWiiFairInfoState extends State<TicketWiiFairInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: bodyTextMaxSmall(null, AppColors.fontGrey, null),
        ),
        widget.statusMap == "GoogleMap"
            ? GestureDetector(
                onTap: () {
                  print("go to google map");
                  launchInBrowser(Uri.parse("${widget.link}"));
                },
                child: Text(
                  widget.text,
                  style: bodyTextMaxNormal("NotoSansLaoLoopedBold", null, null),
                ),
              )
            : Text(
                widget.text,
                style: bodyTextMaxNormal("NotoSansLaoLoopedBold", null, null),
              ),
      ],
    );
  }
}
