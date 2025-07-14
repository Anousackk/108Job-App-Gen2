// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_field, avoid_print, unnecessary_brace_in_string_interps, prefer_adjacent_string_concatenation, unused_local_variable, prefer_final_fields, prefer_if_null_operators

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EventTicket extends StatefulWidget {
  const EventTicket(
      {Key? key,
      required this.imageSrc,
      required this.firstName,
      required this.lastName,
      this.objEventAvailable})
      : super(key: key);
  final String imageSrc;
  final String firstName;
  final String lastName;
  final objEventAvailable;

  @override
  State<EventTicket> createState() => _EventTicketState();
}

class _EventTicketState extends State<EventTicket> {
  final GlobalKey _globalKey = GlobalKey();

  dynamic _myAppliedInfo;
  dynamic _eventInfo;

  String _qrString = "";
  String _userId = "";
  String _name = "";
  String _address = "";
  String _openingTime = "";

  double _latitude = 0;
  double _longtitude = 0;

  saveLocalImage() async {
    //
    //
    //Save device IOS
    if (Platform.isIOS) {
      var statusPhotosIOS = await Permission.photos.status; //IOS
      print("Platform IOS: " + statusPhotosIOS.toString());

      if (statusPhotosIOS.isGranted) {
        print("statusPhotosIOS isGranted");

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

        // Save to photo
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
                contentText: "photo_saved".tr,
              );
            },
          );

          print("IOS saved to photos: $result");
        } else {
          Navigator.pop(context);

          print("byteData == null andriod can not save image");

          await showDialog(
            context: context,
            builder: (context) {
              return CustAlertDialogWarningWithoutBtn(
                title: "warning".tr,
                contentText: "can_not_save_photo".tr,
              );
            },
          );
        }
      } else if (statusPhotosIOS.isDenied) {
        print("statusPhotosIOS isDenied");

        await Permission.photos.request();
      } else {
        print("statusPhotosIOS etc...");

        // Display warning dialog
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return NewVer5CustAlertDialogWarningBtnConfirm(
              title: "warning".tr,
              contentText: "want_access_photos".tr,
              textButton: "ok".tr,
              press: () async {
                await openAppSettings();

                Future.delayed(Duration(seconds: 1), () {
                  // Close warning dialog
                  if (Navigator.canPop(context)) Navigator.pop(context);
                });
              },
            );
          },
        );
      }
    }

    //
    //
    //Save device Android
    else if (Platform.isAndroid) {
      var statusMediaLibraryAndroid =
          await Permission.mediaLibrary.status; //Android
      print("Platform Android: " + "${statusMediaLibraryAndroid}");

      if (statusMediaLibraryAndroid.isGranted) {
        print("statusMediaLibraryAndroid isGranted");

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
                contentText: "photo_saved".tr,
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
                contentText: "can_not_save_photo".tr,
              );
            },
          );
        }
      } else if (statusMediaLibraryAndroid.isDenied) {
        print("statusMediaLibraryAndroid isDenied");

        await Permission.photos.request();
      } else {
        print("statusMediaLibraryAndroid etc...");

        // Display warning dialog
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return NewVer5CustAlertDialogWarningBtnConfirm(
              title: "warning".tr,
              contentText: "want_access_photos".tr,
              textButton: "ok".tr,
              press: () async {
                await openAppSettings();

                Future.delayed(Duration(seconds: 1), () {
                  // Close warning dialog
                  if (Navigator.canPop(context)) Navigator.pop(context);
                });
              },
            );
          },
        );
      }
    }
  }

  getEventAvailable() async {
    var qrStringSharePrefs =
        await SharedPrefsHelper.getString("qrString") ?? "";

    setState(() {
      var i = widget.objEventAvailable;
      _myAppliedInfo = i["myAppliedInfo"];
      _eventInfo = i["eventInfo"];

      _latitude = double.parse(_eventInfo["map"]["coordinates"][1].toString());
      _longtitude =
          double.parse(_eventInfo["map"]["coordinates"][0].toString());

      _name = _eventInfo["name"];
      _address = _eventInfo["address"];
      _qrString = qrStringSharePrefs;

      if (_myAppliedInfo != null) {
        _userId = _myAppliedInfo["id"];
      }

      if (_eventInfo.containsKey("openingTime")) {
        print("have openingTime");
        _openingTime =
            _eventInfo["openingTime"] == null ? "" : _eventInfo["openingTime"];
      }
    });

    print("_qrString: " + _qrString.toString());
  }

  genQrStringSetPreference(String valQrString) async {
    setState(() {
      _qrString = valQrString;
    });

    await SharedPrefsHelper.setString("qrString", _qrString.toString());
  }

  @override
  void initState() {
    super.initState();

    getEventAvailable();
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
                                height: 5,
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
                                height: 10,
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
                                    _qrString == ""
                                        ? ButtonDefault(
                                            text: "create_qr_code".tr,
                                            press: () async {
                                              genQrStringSetPreference(
                                                  _myAppliedInfo["qrString"]);
                                            },
                                          )
                                        : QrImageView(
                                            padding: EdgeInsets.zero,
                                            data: _qrString.toString(),
                                            size: 150,
                                          ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${_userId}",
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
                                    EventTicketInfo(
                                      title: "event_name".tr + ":",
                                      text: "${_name}",
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    EventTicketInfo(
                                      title: "event_address".tr + ":",
                                      text: "${_address}",
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    EventTicketInfo(
                                      title: "event_map".tr + ":",
                                      text: "event_click_map".tr,
                                      statusMap: "GoogleMap",
                                      link:
                                          //17.976837621717973, 102.6365003105264
                                          "https://www.google.com/maps?q=$_latitude,$_longtitude",
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    EventTicketInfo(
                                      title: "event_date_time".tr + ":",
                                      text: "${_openingTime}",
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    EventTicketInfo(
                                      title: "event_attendee_code".tr + ":",
                                      text: "${_userId}",
                                    ),
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

class EventTicketInfo extends StatefulWidget {
  final String title;
  final String text;
  final statusMap;
  final link;

  const EventTicketInfo(
      {required this.title,
      required this.text,
      Key? key,
      this.statusMap,
      this.link})
      : super(key: key);

  @override
  State<EventTicketInfo> createState() => _EventTicketInfoState();
}

class _EventTicketInfoState extends State<EventTicketInfo> {
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
