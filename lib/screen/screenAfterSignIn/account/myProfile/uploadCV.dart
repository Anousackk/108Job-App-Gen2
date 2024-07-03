// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, unnecessary_null_comparison, unused_local_variable, avoid_print, prefer_final_fields, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unrelated_type_equality_checks, prefer_typing_uninitialized_variables, file_names

import 'dart:io';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/boxDecDottedBorderProfileDetail.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  void pickFile() async {
    var statusStorage = await Permission.storage.status;
    if (statusStorage.isGranted) {
      //
      //ສະແດງ AlertDialog Loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomAlertLoading();
        },
      );

      print("storage isGranted");
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc'],
      );
      print(result);
      if (result != null && result.files.single.path != null) {
        PlatformFile file = result.files.first;

        File _file = File(result.files.single.path!);
        setState(() {
          var listFile = file.name.split(".")[1];

          _strFilePath = _file.path;
          _strFileType = listFile.toString();
          _strFileName = file.name;
        });
        print(_strFilePath);

        if (_strFilePath != null) {
          //
          //Api upload file CV
          var value = await upLoadFile(_strFilePath, uploadFileCVApiSeeker);
          print(value);

          setState(() {
            _fileValue = value['myFile'];
            //
            //ປິດ AlertDialog Loading ຫຼັງຈາກ _fileValue ມີຄ່າ
            if (_fileValue != null) {
              Navigator.pop(context);
            }
            print(_fileValue);
          });
        }
      } else if (result == null) {
        print("result == null");
        Navigator.pop(context);
      }
    }
    if (statusStorage.isDenied) {
      print("storage isDenied");
      await Permission.storage.request();
    }
    if (statusStorage.isPermanentlyDenied) {
      print("storage isPermanentlyDenied");
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBarDefault(
          textTitle: "Upload CV",
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
                      boxDecColor: AppColors.lightPrimary,
                      boxDecBorderRadius: BorderRadius.circular(5),
                      widgetFaIcon: FaIcon(
                        _strFileType == "pdf"
                            ? FontAwesomeIcons.filePdf
                            : (_strFileType == "docx" || _strFileType == "doc"
                                ? FontAwesomeIcons.fileWord
                                : FontAwesomeIcons.fileArrowUp),
                        size: 55,
                        color: AppColors.iconGray,
                      ),
                      title: "Select file to upload",
                      titleFontWeight: FontWeight.bold,
                      text: _strFileName == "" || _strFileName == null
                          ? "Supported file format: .PDF, .DOC, .DOCX with maximum file size 5MB"
                          : "${_strFileName}",
                      buttonText: "Select File",
                      buttonColor: AppColors.lightPrimary,
                      buttonBorderColor: AppColors.borderPrimary,
                      buttonTextColor: AppColors.fontPrimary,
                      pressButton: () {
                        pickFile();
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    //
                    //
                    //Trips
                    Text(
                      "Tips",
                      style: bodyTextNormal(null, FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("1. Upload only CV file(exclude other document)"),
                    Text("2. PDF file format is recommended"),
                    SizedBox(
                      height: 30,
                    ),

                    //
                    //
                    //Question ask?
                    Text(
                      "Question you my ask",
                      style: bodyTextNormal(null, FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    //
                    //
                    //1. BoxDecoration Question ask
                    BoxDecorationInput(
                      boxDecBorderRadius: BorderRadius.circular(10),
                      colorInput: AppColors.greyWhite,
                      paddingFaIcon: EdgeInsets.only(left: 15),
                      mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                      text: "1. What is CV?",
                      colorText: AppColors.fontPrimary,
                      widgetIconActive: FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: AppColors.iconPrimary,
                        size: IconSize.sIcon,
                      ),
                      press: () {},
                      validateText: Container(),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    //
                    //
                    //2. BoxDecoration Question ask
                    BoxDecorationInput(
                      boxDecBorderRadius: BorderRadius.circular(10),
                      colorInput: AppColors.greyWhite,
                      paddingFaIcon: EdgeInsets.only(left: 15),
                      mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                      text: "2. I don't have CV?",
                      colorText: AppColors.fontPrimary,
                      widgetIconActive: FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: AppColors.iconPrimary,
                        size: IconSize.sIcon,
                      ),
                      press: () {},
                      validateText: Container(),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    //
                    //
                    //3. BoxDecoration Question ask
                    BoxDecorationInput(
                      boxDecBorderRadius: BorderRadius.circular(10),
                      colorInput: AppColors.greyWhite,
                      paddingFaIcon: EdgeInsets.only(left: 15),
                      mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                      text: "3. Why should i upload CV?",
                      colorText: AppColors.fontPrimary,
                      widgetIconActive: FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: AppColors.iconPrimary,
                        size: IconSize.sIcon,
                      ),
                      press: () {},
                      validateText: Container(),
                    ),
                  ],
                ),

                //
                //
                //Button Save
                Button(
                  text: "Save",
                  press: () async {
                    if (_fileValue == null || _fileValue == "") {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return CustomAlertDialogWarning(
                            title: "Warning",
                            text: "Please select file to upload",
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

  uploadOrUpdateCV() async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertLoading();
      },
    );

    var res = await postData(
      uploadOrUpdateCVApiSeeker,
      {
        "cv": _fileValue,
      },
    );
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
          return CustomAlertDialogSuccess(
            title: "Success",
            text: res['message'],
            textButton: "OK",
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
          return CustomAlertDialogError(
            title: "Invalid",
            text: res['message'],
          );
        },
      );
    }
  }
}
