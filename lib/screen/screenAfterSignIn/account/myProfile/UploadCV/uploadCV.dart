// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, unnecessary_null_comparison, unused_local_variable, avoid_print, prefer_final_fields, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unrelated_type_equality_checks, prefer_typing_uninitialized_variables, file_names, prefer_adjacent_string_concatenation

import 'dart:io';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/UploadCV/Widget/boxPrefixSuffix.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/boxDecDottedBorderProfileDetail.dart';
import 'package:app/widget/button.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadCV extends StatefulWidget {
  const UploadCV({Key? key, this.id, this.cv}) : super(key: key);
  final String? id;
  final cv;

  @override
  State<UploadCV> createState() => _UploadCVState();
}

class _UploadCVState extends State<UploadCV> {
  dynamic _fileValue;
  String _strFilePath = "";
  String _strFileName = "";
  String _strFileType = "";
  String _cvSrc = "";
  String _cvName = "";

  dynamic _cvUploadDate;

  pickFile() async {
    //
    //
    // Display loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    //
    //
    //Pick file device IOS
    if (Platform.isIOS) {
      //
      //
      //Status storage IOS access to folders like Documents or Downloads. Implicitly granted.
      var statusStorageIOS = await Permission.storage.status;
      print("Platform IOS: " + "${statusStorageIOS}");

      if (statusStorageIOS.isGranted) {
        print("statusStorageIOS isGranted");

        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'docx', 'doc'],
        );
        print("result: " + result.toString());

        //
        //ຖ້າເລືອກຟາຍຮູບ ເຮັດເງືອນໄຂໄປ
        if (result != null && result.files.single.path != null) {
          PlatformFile file = result.files.first;

          File _file = File(result.files.single.path!);
          setState(() {
            var listFile = file.name.split(".")[1];

            _strFilePath = _file.path;
            _strFileType = listFile.toString();
            _strFileName = file.name;
          });
          print("_strFilePath: " + _strFilePath.toString());

          if (_strFilePath != null) {
            //
            //
            //Api upload file CV
            var value = await upLoadFile(_strFilePath, uploadFileCVApiSeeker);
            print("value: " + value.toString());

            _fileValue = await value['myFile'];
            print("_fileValue" + _fileValue.toString());

            //
            //
            //ປິດ AlertDialog Loading ຫຼັງຈາກ _fileValue ມີຄ່າ
            if (_fileValue != null) {
              Navigator.pop(context);
            }

            setState(() {});
          }
        }
        //
        //ບໍ່ເລືອກຟາຍຮູບແລ້ວປິດ loading dialog
        else if (result == null) {
          print("result == null");

          Navigator.pop(context);
        }
      } else {
        print("statusStorageIOS is etc...");
        // Close loading dialog first
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }

        // Display warning dialog
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (dialogContext) {
            return NewVer5CustAlertDialogWarningBtnConfirm(
              title: "warning".tr,
              contentText: "cv_file_permission_guide".tr,
              textButton: "ok".tr,
              press: () async {
                await openAppSettings();

                // Close warning dialog
                Navigator.of(dialogContext).pop();

                Future.delayed(Duration(seconds: 1), () {
                  // ກັບໄປໜ້າ Personal Information
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
    //Pick file device Android
    else if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      print("sdkInt: " + sdkInt.toString());

      //
      //
      // Android 13(API 33+)
      if (sdkInt >= 33) {
        var statusAudio = await Permission.audio.status;
        print("Platform Android: " + statusAudio.toString());

        if (statusAudio.isGranted) {
          print("statusAudio isGranted");
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'docx', 'doc'],
          );
          print("result: " + result.toString());

          //
          //ຖ້າເລືອກຟາຍຮູບ ເຮັດເງືອນໄຂໄປ
          if (result != null && result.files.single.path != null) {
            PlatformFile file = result.files.first;

            File _file = File(result.files.single.path!);
            setState(() {
              var listFile = file.name.split(".")[1];

              _strFilePath = _file.path;
              _strFileType = listFile.toString();
              _strFileName = file.name;
            });
            print("_strFilePath: " + _strFilePath.toString());

            if (_strFilePath != null) {
              //Api upload file CV
              var value = await upLoadFile(_strFilePath, uploadFileCVApiSeeker);
              print("value: " + value.toString());

              _fileValue = await value['myFile'];
              print("_fileValue" + _fileValue.toString());

              //ປິດ loading dialog ຫຼັງຈາກ _fileValue ມີຄ່າ
              if (_fileValue != null) {
                Navigator.pop(context);
              }

              setState(() {});
            }
          }

          //
          //ບໍ່ເລືອກຟາຍຮູບແລ້ວປິດ loading dialog
          else if (result == null) {
            print("result == null");
            Navigator.pop(context);
          }
        } else if (statusAudio.isDenied) {
          print("statusAudio isDenied");

          // Close loading dialog first
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          await Permission.audio.request();
        } else {
          print("statusAudio etc...");

          // ປິດ loading dialog first
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          // Display warning dialog
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (dialogContext) {
              return NewVer5CustAlertDialogWarningBtnConfirm(
                title: "warning".tr,
                contentText: "cv_file_permission_audio".tr,
                textButton: "ok".tr,
                press: () async {
                  await openAppSettings();

                  // Close warning dialog
                  Navigator.of(dialogContext).pop();

                  Future.delayed(Duration(seconds: 1), () {
                    // ກັບໄປໜ້າ Personal Information
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
      // Below Android 13 (API 33)
      else {
        var statusStorageAndroid = await Permission.storage.status;
        print("Platform Android: " + "${statusStorageAndroid}");

        if (statusStorageAndroid.isGranted) {
          print("statusStorageAndroid isGranted");

          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'docx', 'doc'],
          );
          print("result: " + result.toString());

          //
          //ຖ້າເລືອກຟາຍຮູບ ເຮັດເງືອນໄຂໄປ
          if (result != null && result.files.single.path != null) {
            PlatformFile file = result.files.first;

            File _file = File(result.files.single.path!);
            setState(() {
              var listFile = file.name.split(".")[1];

              _strFilePath = _file.path;
              _strFileType = listFile.toString();
              _strFileName = file.name;
            });
            print("_strFilePath: " + _strFilePath.toString());

            if (_strFilePath != null) {
              //
              //
              //Api upload file CV
              var value = await upLoadFile(_strFilePath, uploadFileCVApiSeeker);
              print("value: " + value.toString());

              _fileValue = await value['myFile'];
              print("_fileValue" + _fileValue.toString());

              //
              //
              //ປິດ AlertDialog Loading ຫຼັງຈາກ _fileValue ມີຄ່າ
              if (_fileValue != null) {
                Navigator.pop(context);
              }

              setState(() {});
            }
          }

          //
          //ບໍ່ເລືອກຟາຍຮູບແລ້ວປິດ loading dialog
          else if (result == null) {
            print("result == null");

            Navigator.pop(context);
          }
        } else if (statusStorageAndroid.isDenied) {
          print("statusStorageAndroid isDenied");

          // Close loading dialog first
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          await Permission.storage.request();
        } else {
          print("statusStorageAndroid is etc...");

          // Close loading dialog first
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          // Display warning dialog
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (dialogContext) {
              return NewVer5CustAlertDialogWarningBtnConfirm(
                title: "warning".tr,
                contentText: "cv_file_permission_guide".tr,
                textButton: "ok".tr,
                press: () async {
                  await openAppSettings();

                  // Close warning dialog
                  Navigator.of(dialogContext).pop();

                  Future.delayed(Duration(seconds: 1), () {
                    // ກັບໄປໜ້າ Personal Information
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  });
                },
              );
            },
          );
        }
      }
    }
  }

  uploadOrUpdateCV() async {
    //
    //
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    var res = await postData(
      uploadOrUpdateCVApiSeeker,
      {
        "cv": _fileValue,
      },
    );

    //
    //
    //ປິດ AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    if (res != null) {
      Navigator.pop(context);
    }

    if (res['message'] == 'CV uploaded') {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "successful".tr,
            contentText: "upload cv".tr + " " + "successful".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "try_again".tr,
          );
        },
      );
    }
  }

  deleteCV() async {
    //
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    var res = await postData(deleteCVApiSeeker, {});

    //
    //
    //ປິດ AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    if (res != null) {
      Navigator.pop(context);
    }

    if (res['message'] == "CV deleted") {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "successful".tr,
            contentText: "delete_cv_success".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  cvInfomation() {
    if (widget.cv != null) {
      setState(() {
        print("${widget.cv}");

        _cvName = widget.cv['link'].split('/')[1];
        _cvSrc = widget.cv['src'];
        _cvUploadDate = widget.cv['updatedAt'];
        //pars ISO to Flutter DateTime
        parsDateTime(value: '', currentFormat: '', desiredFormat: '');
        DateTime cvUploadDate = parsDateTime(
          value: _cvUploadDate,
          currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
          desiredFormat: "yyyy-MM-dd HH:mm:ss",
        );
        _cvUploadDate = formatDate(cvUploadDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    cvInfomation();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBarDefault(
          textTitle: "cv_file".tr,
          // fontWeight: FontWeight.bold,
          leadingIcon: Icon(Icons.arrow_back),
          leadingPress: () {
            Navigator.pop(context);
          },
        ),
        body: SafeArea(
          child: Container(
            color: AppColors.backgroundWhite,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    //
                    //BoxDecoration Upload CV
                    BoxDecDottedBorderUploadCV(
                      boxDecColor: AppColors.primary100,
                      boxDecBorderRadius: BorderRadius.circular(5),
                      // widgetFaIcon: FaIcon(
                      //   _strFileType == "pdf"
                      //       ? FontAwesomeIcons.filePdf
                      //       : (_strFileType == "docx" || _strFileType == "doc"
                      //           ? FontAwesomeIcons.fileWord
                      //           : FontAwesomeIcons.fileArrowUp),
                      //   size: 55,
                      //   color: AppColors.iconGray,
                      // ),
                      title: "select_cv_file".tr,
                      titleColor: AppColors.primary600,
                      titleFontWeight: FontWeight.bold,
                      text: _strFileName == "" || _strFileName == null
                          ? "cv_file_support".tr
                          : "${_strFileName}",
                      // buttonText: "select_cv_file".tr,
                      // buttonColor: AppColors.lightPrimary,
                      // buttonBorderColor: AppColors.borderPrimary,
                      // buttonTextColor: AppColors.fontPrimary,
                      press: () {
                        pickFile();
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    if (widget.cv != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //
                          //
                          //Uploaded file
                          Text(
                            "uploaded_file".tr,
                            style: bodyTextMaxNormal(
                                "NotoSansLaoLoopedBold", null, null),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          //
                          //
                          //Box Decoration Resume File
                          BoxDecorationInputPrefixTextSuffixWidget(
                            press: () {
                              launchInBrowser(Uri.parse(_cvSrc));
                            },
                            prefixIconText: "\uf15b",
                            prefixFontFamily: "FontAwesomeSolid",
                            prefixColor: AppColors.primary600,
                            text: "${_cvName}",
                            textColor: AppColors.fontDark,
                            suffixWidget: Text(
                              "\uf00d",
                              style: fontAwesomeRegular(
                                  null, 14, AppColors.warning600, null),
                            ),
                            pressSuffixWidget: () async {
                              var result = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                      title: "delete_this_info".tr,
                                      contentText: "are_u_delete_cv".tr,
                                      textButtonLeft: 'cancel'.tr,
                                      textButtonRight: 'confirm'.tr,
                                      textButtonRightColor: AppColors.fontWhite,
                                    );
                                  });
                              if (result == 'Ok') {
                                print("confirm delete");
                                deleteCV();
                              }
                            },
                            validateText: Container(),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),

                    //
                    //
                    //Trips
                    Text(
                      "tips".tr,
                      style: bodyTextMaxNormal(
                          "NotoSansLaoLoopedBold", null, null),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "cv_tip_1".tr,
                      style: bodyTextMinNormal(
                          "NotoSansLaoLoopedMedium", null, null),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "cv_tip_2".tr,
                      style: bodyTextMinNormal(
                          "NotoSansLaoLoopedMedium", null, null),
                    ),

                    //Question ask?
                    // Text(
                    //   "question you my ask".tr,
                    //   style: bodyTextNormal(null,null, FontWeight.bold),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),

                    //1. BoxDecoration Question ask
                    // BoxDecorationInput(
                    //   boxDecBorderRadius: BorderRadius.circular(10),
                    //   colorInput: AppColors.greyWhite,
                    //   paddingFaIcon: EdgeInsets.only(left: 15),
                    //   mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                    //   text: "1. " + "what is cv".tr,
                    //   colorText: AppColors.fontPrimary,
                    //   widgetIconActive: FaIcon(
                    //     FontAwesomeIcons.chevronRight,
                    //     color: AppColors.iconPrimary,
                    //     size: IconSize.sIcon,
                    //   ),
                    //   press: () {},
                    //   validateText: Container(),
                    // ),
                    // SizedBox(
                    //   height: 5,
                    // ),

                    //2. BoxDecoration Question ask
                    // BoxDecorationInput(
                    //   boxDecBorderRadius: BorderRadius.circular(10),
                    //   colorInput: AppColors.greyWhite,
                    //   paddingFaIcon: EdgeInsets.only(left: 15),
                    //   mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                    //   text: "2. " + "i don't have cv".tr,
                    //   colorText: AppColors.fontPrimary,
                    //   widgetIconActive: FaIcon(
                    //     FontAwesomeIcons.chevronRight,
                    //     color: AppColors.iconPrimary,
                    //     size: IconSize.sIcon,
                    //   ),
                    //   press: () {},
                    //   validateText: Container(),
                    // ),
                    // SizedBox(
                    //   height: 5,
                    // ),

                    //3. BoxDecoration Question ask
                    // BoxDecorationInput(
                    //   boxDecBorderRadius: BorderRadius.circular(10),
                    //   colorInput: AppColors.greyWhite,
                    //   paddingFaIcon: EdgeInsets.only(left: 15),
                    //   mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                    //   text: "3. " + "why should upload cv".tr,
                    //   colorText: AppColors.fontPrimary,
                    //   widgetIconActive: FaIcon(
                    //     FontAwesomeIcons.chevronRight,
                    //     color: AppColors.iconPrimary,
                    //     size: IconSize.sIcon,
                    //   ),
                    //   press: () {},
                    //   validateText: Container(),
                    // ),
                  ],
                ),

                //
                //
                //Button Save
                Button(
                  text: "save".tr,
                  press: () async {
                    if (_fileValue == null || _fileValue == "") {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return CustAlertDialogWarningWithoutBtn(
                            title: "warning".tr,
                            contentText: "plz select".tr,
                          );
                        },
                      );
                    } else {
                      uploadOrUpdateCV();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
