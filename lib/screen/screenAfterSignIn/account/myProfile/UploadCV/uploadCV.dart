// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, unnecessary_null_comparison, unused_local_variable, avoid_print, prefer_final_fields, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unrelated_type_equality_checks, prefer_typing_uninitialized_variables, file_names, prefer_adjacent_string_concatenation, use_build_context_synchronously, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

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
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadCV extends StatefulWidget {
  const UploadCV(
      {Key? key,
      this.id,
      this.cv,
      this.vipoCV,
      this.personalInformationStatus,
      this.workPreferenceStatus,
      this.educationStatus,
      this.workHistoryStatus,
      this.languageStatus,
      this.skillStatus})
      : super(key: key);
  final String? id;
  final cv;
  final vipoCV;
  final bool? personalInformationStatus;
  final bool? workPreferenceStatus;
  final bool? educationStatus;
  final bool? workHistoryStatus;
  final bool? languageStatus;
  final bool? skillStatus;

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

  File? _image;

  bool _isCVStatus = false;

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
              print("file.name: " + "${file}");

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

  pickImageGallery(ImageSource source) async {
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
    // Pick image device IOS
    if (Platform.isIOS) {
      var statusPhotosIOS = await Permission.photos.status;
      print("Platform IOS: " + statusPhotosIOS.toString());

      if (statusPhotosIOS.isGranted) {
        print("statusPhotosIOS isGranted");
        final ImagePicker _picker = ImagePicker();
        final XFile? image = await _picker.pickImage(source: source);

        //
        //ຖ້າບໍ່ເລືອກຮູບໃຫ້ return ອອກເລີຍ
        if (image == null) {
          Navigator.pop(context);
          return;
        }

        // setState(() {
        //   _imageLoading = true;
        // });

        //
        //ກວດຟາຍຮູບຖ້າບໍ່ແມ່ນ 'png', 'jpg', 'jpeg'
        final allowedExtensions = ['png', 'jpg', 'jpeg'];
        final fileExtension = image.path.split('.').last.toLowerCase();

        //
        //ກວດຟາຍຮູບຖ້າບໍ່ແມ່ນ 'png', 'jpg', 'jpeg' ໃຫ້ return ອອກເລີຍ
        if (!allowedExtensions.contains(fileExtension)) {
          // Close loading dialog first
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          print("valUploadFile is null");
          // setState(() {
          //   _imageLoading = false;
          // });
          await showDialog(
            context: context,
            builder: (context) {
              return CustAlertDialogWarningWithoutBtn(
                title: "warning".tr,
                contentText: "profile_image_support".tr,
              );
            },
          );
          return;
        }

        File fileTemp = File(image.path);
        setState(() {
          _image = fileTemp;
        });

        var strImage = image.path;
        _strFileName = image.name;

        print("strImage: " + strImage.toString());

        //
        //ຖ້າມີຟາຍຮູບ _image
        if (_image != null) {
          //
          //api upload profile seeker
          var valUploadFile =
              await upLoadFile(strImage, uploadProfileApiSeeker);

          //
          //ຫຼັງຈາກ api upload ສຳເລັດແລ້ວ
          //valUploadFile != null ເຮັດວຽກ method uploadOrUpdateProfileImageSeeker()
          if (valUploadFile != null) {
            print("if valUploadFile: " + valUploadFile.toString());

            _fileValue = valUploadFile['file'];
            print("fileValue: " + _fileValue.toString());

            if (_fileValue != null || _fileValue != "") {
              //
              //api upload or update profile image seeker
              // uploadOrUpdateProfileImageSeeker();
              Navigator.pop(context);
            }
          }
          //
          //valUploadFile == null ແຈ້ງເຕືອນຟາຍຮູບໃຫ່ຍເກີນໄປ
          else {
            // Close loading dialog first
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            print("else valUploadFile: " + valUploadFile.toString());
            // setState(() {
            //   _imageLoading = false;
            // });
            await showDialog(
              context: context,
              builder: (context) {
                return CustAlertDialogWarningWithoutBtn(
                  title: "warning".tr,
                  contentText: "profile_image_size".tr,
                );
              },
            );
          }
        }
      } else if (statusPhotosIOS.isDenied) {
        print("statusPhotosIOS isDenied");

        // Close loading dialog first
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }

        await Permission.photos.request();
      } else {
        // Close loading dialog first
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
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
    // Pick image device Android
    else if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      print("sdkInt: " + sdkInt.toString());

      //
      //
      // Android 13(API 33+)
      if (sdkInt >= 33) {
        var statusPhotosAndroid = await Permission.photos.status;

        print("Platform Android: " + statusPhotosAndroid.toString());

        if (statusPhotosAndroid.isGranted) {
          print("statusPhotosAndroid isGranted");
          final ImagePicker _picker = ImagePicker();
          final XFile? image = await _picker.pickImage(source: source);

          //
          //ຖ້າບໍ່ເລືອກຮູບໃຫ້ return ອອກເລີຍ
          if (image == null) {
            Navigator.pop(context);
            return;
          }

          // setState(() {
          //   _imageLoading = true;
          // });

          //
          //ກວດຟາຍຮູບຖ້າບໍ່ແມ່ນ 'png', 'jpg', 'jpeg'
          final allowedExtensions = ['png', 'jpg', 'jpeg'];
          final fileExtension = image.path.split('.').last.toLowerCase();

          //
          //ກວດຟາຍຮູບຖ້າບໍ່ແມ່ນ 'png', 'jpg', 'jpeg' ໃຫ້ return ອອກເລີຍ
          if (!allowedExtensions.contains(fileExtension)) {
            // Close loading dialog first
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }

            print("valUploadFile allowedExtensions 'png', 'jpg', 'jpeg'");
            // setState(() {
            //   _imageLoading = false;
            // });
            await showDialog(
              context: context,
              builder: (context) {
                return CustAlertDialogWarningWithoutBtn(
                  title: "warning".tr,
                  contentText: "profile_image_support".tr,
                );
              },
            );
            return;
          }

          File fileTemp = File(image.path);
          setState(() {
            _image = fileTemp;
          });
          var strImage = image.path;
          _strFileName = image.name;

          print("strImage: " + strImage.toString());

          //
          //ຖ້າມີຟາຍຮູບ _image
          if (_image != null) {
            //
            //api upload profile seeker
            var valUploadFile =
                await upLoadFile(strImage, uploadProfileApiSeeker);

            //
            //ຫຼັງຈາກ api upload ສຳເລັດແລ້ວ
            //valUploadFile != null ເຮັດວຽກ method uploadOrUpdateProfileImageSeeker()
            if (valUploadFile != null) {
              print("if valUploadFile: " + valUploadFile.toString());

              _fileValue = valUploadFile['file'];
              print("fileValue: " + _fileValue.toString());

              if (_fileValue != null || _fileValue != "") {
                //
                //api upload or update profile image seeker
                // uploadOrUpdateProfileImageSeeker();

                // Close loading dialog first
                Navigator.pop(context);
              }
            }
            //
            //valUploadFile == null ແຈ້ງເຕືອນຟາຍຮູບໃຫ່ຍເກີນໄປ
            else {
              // Close loading dialog first
              if (Navigator.of(context, rootNavigator: true).canPop()) {
                Navigator.of(context, rootNavigator: true).pop();
              }

              print("else valUploadFile: " + valUploadFile.toString());
              // setState(() {
              //   _imageLoading = false;
              // });
              await showDialog(
                context: context,
                builder: (context) {
                  return CustAlertDialogWarningWithoutBtn(
                    title: "warning".tr,
                    contentText: "profile_image_size".tr,
                  );
                },
              );
            }
          }
        } else if (statusPhotosAndroid.isDenied) {
          print("statusPhotosAndroid isDenied");

          // Close loading dialog first
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          await Permission.photos.request();
        } else {
          print("statusPhotosAndroid etc...");

          // Close loading dialog first
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }

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
      // Below Android 13 (API 33)
      else {
        var statusStorageAndroid = await Permission.storage.status;

        print("Platform Android: " + statusStorageAndroid.toString());

        if (statusStorageAndroid.isGranted) {
          print("statusStorageAndroid isGranted");
          final ImagePicker _picker = ImagePicker();
          final XFile? image = await _picker.pickImage(source: source);

          //
          //ຖ້າບໍ່ເລືອກຮູບໃຫ້ return ອອກເລີຍ
          if (image == null) {
            Navigator.pop(context);
            return;
          }

          // setState(() {
          //   _imageLoading = true;
          // });

          //
          //ກວດຟາຍຮູບຖ້າບໍ່ແມ່ນ 'png', 'jpg', 'jpeg'
          final allowedExtensions = ['png', 'jpg', 'jpeg'];
          final fileExtension = image.path.split('.').last.toLowerCase();

          //
          //ກວດຟາຍຮູບຖ້າບໍ່ແມ່ນ 'png', 'jpg', 'jpeg' ໃຫ້ return ອອກເລີຍ
          if (!allowedExtensions.contains(fileExtension)) {
            // Close loading dialog first
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }

            print("valUploadFile allowedExtensions 'png', 'jpg', 'jpeg'");
            // setState(() {
            //   _imageLoading = false;
            // });
            await showDialog(
              context: context,
              builder: (context) {
                return CustAlertDialogWarningWithoutBtn(
                  title: "warning".tr,
                  contentText: "profile_image_support".tr,
                );
              },
            );
            return;
          }

          File fileTemp = File(image.path);
          setState(() {
            _image = fileTemp;
          });
          _strFileName = image.name;
          var strImage = image.path;
          print("_strFileName: " + _strFileName.toString());

          print("strImage: " + strImage.toString());

          //
          //ຖ້າມີຟາຍຮູບ _image
          if (_image != null) {
            //
            //api upload profile seeker
            var valUploadFile =
                await upLoadFile(strImage, uploadProfileApiSeeker);

            //
            //ຫຼັງຈາກ api upload ສຳເລັດແລ້ວ
            //valUploadFile != null ເຮັດວຽກ method uploadOrUpdateProfileImageSeeker()
            if (valUploadFile != null) {
              print("if valUploadFile: " + valUploadFile.toString());

              _fileValue = valUploadFile['file'];
              print("fileValue: " + _fileValue.toString());

              if (_fileValue != null || _fileValue != "") {
                //
                //api upload or update profile image seeker
                // uploadOrUpdateProfileImageSeeker();
                Navigator.pop(context);
              }
            }
            //
            //valUploadFile == null ແຈ້ງເຕືອນຟາຍຮູບໃຫ່ຍເກີນໄປ
            else {
              // Close loading dialog first
              if (Navigator.of(context, rootNavigator: true).canPop()) {
                Navigator.of(context, rootNavigator: true).pop();
              }

              print("else valUploadFile: " + valUploadFile.toString());
              // setState(() {
              //   _imageLoading = false;
              // });
              await showDialog(
                context: context,
                builder: (context) {
                  return CustAlertDialogWarningWithoutBtn(
                    title: "warning".tr,
                    contentText: "profile_image_size".tr,
                  );
                },
              );
            }
          }
        } else if (statusStorageAndroid.isDenied) {
          print("statusStorageAndroid isDenied");

          // Close loading dialog first
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          await Permission.storage.request();
        } else {
          print("statusStorageAndroid etc...");

          // Close loading dialog first
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          // Display warning dialog
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return NewVer5CustAlertDialogWarningBtnConfirm(
                title: "warning".tr,
                contentText: "want_access_storage".tr,
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
  }

  uploadOrUpdateCV(dynamic paramFileValue, bool paramVipoCVStatus) async {
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
        "cv": paramFileValue,
        "vipoCVStatus": paramVipoCVStatus,
      },
    );

    print("res api uploadOrUpdateCV: " + "${res}");

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

  deleteCV(bool paramVipoCVStatus) async {
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

    var res =
        await postData(deleteCVApiSeeker, {"vipoCVStatus": paramVipoCVStatus});

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

  cvInfomation() async {
    setState(() {
      if (widget.cv != null) {
        _isCVStatus = false;
        pressCvInfomation("CV");
      } else if (widget.cv == null && widget.vipoCV == null) {
        _isCVStatus = false;
        pressCvInfomation("CV");
      } else {
        _isCVStatus = true;
        pressCvInfomation("VIPO CV");
      }
    });
  }

  pressCvInfomation(String status) {
    if (widget.cv != null && status == "CV") {
      setState(() {
        print("cv: " + "${widget.cv}");

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

    if (widget.vipoCV != null && status == "VIPO CV") {
      setState(() {
        print("vipoCV: " + "${widget.vipoCV}");

        _cvName = widget.vipoCV['link'].split('/')[1];
        _cvSrc = widget.vipoCV['src'];
        _cvUploadDate = widget.vipoCV['updatedAt'];
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

  ModalBottomCameraGallery() {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.greyOpacity,
              borderRadius: BorderRadius.all(
                Radius.circular(64.0),
              ),
            ),
            // margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            // height: ,
          ),
          Title(
              color: AppColors.dark,
              child: Text(
                "select_cv_file".tr,
                style: bodyTextMaxNormal(null, null, FontWeight.bold),
              )),
          Container(
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                pickImageGallery(ImageSource.gallery);
              },
              title: Text("image".tr),
              leading: Icon(Icons.image),
              textColor: AppColors.dark,
              iconColor: AppColors.primary600,
            ),
          ),
          Container(
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                pickFile();
              },
              title: Text("file".tr),
              leading: Icon(Icons.file_present_rounded),
              textColor: AppColors.dark,
              iconColor: AppColors.primary600,
            ),
          )
        ],
      ),
    );
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
          child: Column(
            children: [
              // Text("${_isCVStatus}"),
              SizedBox(
                height: 20,
              ),

              //
              //
              //
              //
              //
              //Section1 Header button switch gen CV
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Button(
                        text: "i_have_cv".tr,
                        textColor: !_isCVStatus
                            ? AppColors.fontPrimary
                            : AppColors.dark,
                        textFontWeight: !_isCVStatus ? FontWeight.bold : null,
                        buttonColor: !_isCVStatus
                            ? AppColors.primary300
                            : AppColors.dark100,
                        press: () {
                          setState(() {
                            _isCVStatus = false;
                            pressCvInfomation("CV");
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Button(
                        text: "vipo_gen_cv".tr,
                        textColor: _isCVStatus
                            ? AppColors.fontPrimary
                            : AppColors.dark,
                        textFontWeight: _isCVStatus ? FontWeight.bold : null,
                        buttonColor: _isCVStatus
                            ? AppColors.primary300
                            : AppColors.dark100,
                        press: () {
                          setState(() {
                            _isCVStatus = true;
                            pressCvInfomation("VIPO CV");
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),

              //
              //
              //
              //
              //
              //Section2 Content have CV
              Expanded(
                child: Container(
                  color: AppColors.backgroundWhite,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child:
                      //
                      //CV
                      //ຖ້າວ່າ _isCVStatus  = false
                      !_isCVStatus
                          ? Column(
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
                                      boxDecBorderRadius:
                                          BorderRadius.circular(5),
                                      title: "select_cv_file".tr,
                                      titleColor: AppColors.primary600,
                                      titleFontWeight: FontWeight.bold,
                                      text: _strFileName == "" ||
                                              _strFileName == null
                                          ? "cv_file_support".tr
                                          : "${_strFileName}",
                                      press: () {
                                        showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          )),
                                          context: context,
                                          builder: (builder) =>
                                              ModalBottomCameraGallery(),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),

                                    if (widget.cv != null)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //
                                          //
                                          //Uploaded file
                                          Text(
                                            "uploaded_file".tr,
                                            style: bodyTextMaxNormal(
                                                "NotoSansLaoLoopedBold",
                                                null,
                                                null),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),

                                          //
                                          //
                                          //Box Decoration Resume File
                                          BoxDecorationInputPrefixTextSuffixWidget(
                                            boxColor: AppColors.primary200,
                                            press: () {
                                              launchInBrowser(
                                                  Uri.parse(_cvSrc));
                                            },
                                            prefixIconText: "\uf15b",
                                            prefixFontFamily:
                                                "FontAwesomeSolid",
                                            prefixColor: AppColors.primary600,
                                            text: "${_cvName}",
                                            textColor: AppColors.fontDark,
                                            suffixWidget: Text(
                                              "\uf00d",
                                              style: fontAwesomeRegular(
                                                  null,
                                                  14,
                                                  AppColors.warning600,
                                                  null),
                                            ),
                                            pressSuffixWidget: () async {
                                              var result = await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                                      title:
                                                          "delete_this_info".tr,
                                                      contentText:
                                                          "are_u_delete_cv".tr,
                                                      textButtonLeft:
                                                          'cancel'.tr,
                                                      textButtonRight:
                                                          'confirm'.tr,
                                                      textButtonRightColor:
                                                          AppColors.fontWhite,
                                                    );
                                                  });
                                              if (result == 'Ok') {
                                                print("confirm delete");
                                                deleteCV(false);
                                              }
                                            },
                                            validateText: Container(),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text("ອັບເດດລ່າສຸດ: " +
                                              "${_cvUploadDate}"),
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
                                          "NotoSansLaoLoopedMedium",
                                          null,
                                          null),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "cv_tip_2".tr,
                                      style: bodyTextMinNormal(
                                          "NotoSansLaoLoopedMedium",
                                          null,
                                          null),
                                    ),
                                  ],
                                ),

                                //
                                //
                                //Button Save
                                Button(
                                  text: "save".tr,
                                  press: () async {
                                    if (_fileValue == null ||
                                        _fileValue == "") {
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
                                      uploadOrUpdateCV(_fileValue, false);
                                    }
                                  },
                                )
                              ],
                            )

                          //
                          //VIPO CV
                          //ຖ້າວ່າ _isCVStatus  = true
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (widget.vipoCV != null)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //
                                            //
                                            //Uploaded file
                                            Text(
                                              "download_file_cv".tr,
                                              style: bodyTextMaxNormal(
                                                  "NotoSansLaoLoopedBold",
                                                  null,
                                                  null),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),

                                            //
                                            //
                                            //Box Decoration Resume File
                                            BoxDecorationInputPrefixTextSuffixWidget(
                                              boxColor: AppColors.primary200,
                                              press: () {
                                                launchInBrowser(
                                                    Uri.parse(_cvSrc));
                                              },
                                              prefixIconText: "\uf15b",
                                              prefixFontFamily:
                                                  "FontAwesomeSolid",
                                              prefixColor: AppColors.primary600,
                                              text: "${_cvName}",
                                              textColor: AppColors.fontDark,
                                              suffixWidget: Text(
                                                "\uf00d",
                                                style: fontAwesomeRegular(
                                                    null,
                                                    14,
                                                    AppColors.warning600,
                                                    null),
                                              ),
                                              pressSuffixWidget: () async {
                                                var result = await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                                        title:
                                                            "delete_this_info"
                                                                .tr,
                                                        contentText:
                                                            "are_u_delete_cv"
                                                                .tr,
                                                        textButtonLeft:
                                                            'cancel'.tr,
                                                        textButtonRight:
                                                            'confirm'.tr,
                                                        textButtonRightColor:
                                                            AppColors.fontWhite,
                                                      );
                                                    });
                                                if (result == 'Ok') {
                                                  print("confirm delete");
                                                  deleteCV(true);
                                                }
                                              },
                                              validateText: Container(),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("ອັບເດດລ່າສຸດ: " +
                                                "${_cvUploadDate}"),
                                            SizedBox(
                                              height: 30,
                                            ),
                                          ],
                                        ),

                                      //
                                      //
                                      //Trips Generate CV
                                      Text(
                                        "tips".tr,
                                        style: bodyTextMaxNormal(
                                            "NotoSansLaoLoopedBold",
                                            null,
                                            null),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "1. ຕື່ມຂໍ້ມູນໂປຣໄຟສທັງໝົດໃຫ້ຄົບຖ້ວນ."
                                            .tr,
                                        style: bodyTextMinNormal(
                                            "NotoSansLaoLoopedMedium",
                                            null,
                                            null),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "2. ກົດປຸ່ມ 'ບັນທຶກ' ເພື່ອສ້າງຊີວີ້."
                                            .tr,
                                        style: bodyTextMinNormal(
                                            "NotoSansLaoLoopedMedium",
                                            null,
                                            null),
                                      ),
                                      //ການສ້າງຊີວີ້ອາດໃຊ້ເລລາ 1 - 5 ນາທີ.
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "3. ລະບົບຂອງ vipo.cc ຈະສ້າງຊີວີ້ອັດຕະໂນມັດ."
                                            .tr,
                                        style: bodyTextMinNormal(
                                            "NotoSansLaoLoopedMedium",
                                            null,
                                            null),
                                      ),

                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "4. ການສ້າງຊີວີ້ອາດໃຊ້ເລລາ 1 - 5 ນາທີ."
                                            .tr,
                                        style: bodyTextMinNormal(
                                            "NotoSansLaoLoopedMedium",
                                            null,
                                            null),
                                      ),
                                    ],
                                  ),
                                ),

                                //
                                //
                                //Button VIPO Generate CV
                                Button(
                                  text: "save".tr,
                                  press: () async {
                                    if (widget.personalInformationStatus ==
                                            true &&
                                        widget.workPreferenceStatus == true &&
                                        widget.educationStatus == true &&
                                        widget.workHistoryStatus == true &&
                                        widget.languageStatus == true &&
                                        widget.skillStatus == true) {
                                      uploadOrUpdateCV(null, true);
                                    } else {
                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustAlertDialogWarningWithoutBtn(
                                            title: "warning".tr,
                                            contentText:
                                                "ຂໍ້ມູນໂປຣໄຟສຍັງບໍ່ຄົບ ຫຼື ຍັງບໍ່ໄດ້ຮັບອະນຸມັດຈາກແອັດມິ້ນ"
                                                    .tr,
                                          );
                                        },
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
