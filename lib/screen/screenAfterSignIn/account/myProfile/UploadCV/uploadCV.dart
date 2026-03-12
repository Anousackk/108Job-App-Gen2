// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, unnecessary_null_comparison, unused_local_variable, avoid_print, prefer_final_fields, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unrelated_type_equality_checks, prefer_typing_uninitialized_variables, file_names, prefer_adjacent_string_concatenation, use_build_context_synchronously, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/provider/profileProvider.dart';
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
import 'package:provider/provider.dart';

class UploadCV extends StatefulWidget {
  const UploadCV({
    Key? key,
    this.onSaveSuccess,
  }) : super(key: key);
  final Function()? onSaveSuccess;

  @override
  State<UploadCV> createState() => _UploadCVState();
}

class _UploadCVState extends State<UploadCV> {
  dynamic _fileValue;
  String _strFilePath = "";
  String _strFileName = "";
  String _strFileType = "";
  String _cvSrc = "";
  String _cvSystemGenerateSrc = "";

  File? _image;

  bool _isSystemGenCVStatus = false;

  pickFile() async {
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

            //ປິດ AlertDialog Loading ຫຼັງຈາກ _fileValue ມີຄ່າ
            if (_fileValue != null) {
              // Api upload or update CV
              uploadOrUpdateCV(_fileValue, false);

              Navigator.pop(context);
            }

            setState(() {});
          }
        }

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

      // Android 13+ (API 33+)
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
                // Api upload or update CV
                uploadOrUpdateCV(_fileValue, false);

                Navigator.pop(context);
              }

              setState(() {});
            }
          }

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

      // Android < 13 (API ≤ 32)
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
              //Api upload file CV
              var value = await upLoadFile(_strFilePath, uploadFileCVApiSeeker);
              print("value: " + value.toString());

              _fileValue = await value['myFile'];
              print("_fileValue" + _fileValue.toString());

              //ປິດ AlertDialog Loading ຫຼັງຈາກ _fileValue ມີຄ່າ
              if (_fileValue != null) {
                // Api upload or update CV
                uploadOrUpdateCV(_fileValue, false);

                Navigator.pop(context);
              }

              setState(() {});
            }
          }

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

        //ຖ້າມີຟາຍຮູບ _image
        if (_image != null) {
          //api upload profile seeker
          var valUploadFile =
              await upLoadFile(strImage, uploadProfileApiSeeker);

          //ຫຼັງຈາກ api upload ສຳເລັດແລ້ວ
          //valUploadFile != null ເຮັດວຽກ method uploadOrUpdateProfileImageSeeker()
          if (valUploadFile != null) {
            print("if valUploadFile: " + valUploadFile.toString());

            _fileValue = valUploadFile['file'];
            print("fileValue: " + _fileValue.toString());

            if (_fileValue != null || _fileValue != "") {
              // Api upload or update CV
              uploadOrUpdateCV(_fileValue, false);

              Navigator.pop(context);
            }
          }

          //valUploadFile == null ແຈ້ງເຕືອນຟາຍຮູບໃຫ່ຍເກີນໄປ
          else {
            // Close loading dialog first
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            print("else valUploadFile: " + valUploadFile.toString());

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

      // Android 13+ (API 33+)
      if (sdkInt >= 33) {
        // var statusPhotosAndroid = await Permission.photos.status;

        // print("Platform Android: " + statusPhotosAndroid.toString());

        // if (statusPhotosAndroid.isGranted) {
        print("statusPhotosAndroid isGranted");
        final ImagePicker _picker = ImagePicker();
        final XFile? image = await _picker.pickImage(source: source);

        //ຖ້າບໍ່ເລືອກຮູບໃຫ້ return ອອກເລີຍ
        if (image == null) {
          Navigator.pop(context);
          return;
        }

        // setState(() {
        //   _imageLoading = true;
        // });

        //ກວດຟາຍຮູບຖ້າບໍ່ແມ່ນ 'png', 'jpg', 'jpeg'
        final allowedExtensions = ['png', 'jpg', 'jpeg'];
        final fileExtension = image.path.split('.').last.toLowerCase();

        //ກວດຟາຍຮູບຖ້າບໍ່ແມ່ນ 'png', 'jpg', 'jpeg' ໃຫ້ return ອອກເລີຍ
        if (!allowedExtensions.contains(fileExtension)) {
          // Close loading dialog first
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          print("valUploadFile allowedExtensions 'png', 'jpg', 'jpeg'");

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

        //ຖ້າມີຟາຍຮູບ _image
        if (_image != null) {
          //api upload profile seeker
          var valUploadFile =
              await upLoadFile(strImage, uploadProfileApiSeeker);

          //ຫຼັງຈາກ api upload ສຳເລັດແລ້ວ
          //valUploadFile != null ເຮັດວຽກ method uploadOrUpdateProfileImageSeeker()
          if (valUploadFile != null) {
            print("if valUploadFile: " + valUploadFile.toString());

            _fileValue = valUploadFile['file'];
            print("fileValue: " + _fileValue.toString());

            if (_fileValue != null || _fileValue != "") {
              // Api upload or update CV
              uploadOrUpdateCV(_fileValue, false);

              // Close loading dialog first
              Navigator.pop(context);
            }
          }

          //valUploadFile == null ແຈ້ງເຕືອນຟາຍຮູບໃຫ່ຍເກີນໄປ
          else {
            // Close loading dialog first
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }

            print("else valUploadFile: " + valUploadFile.toString());

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
        // } else if (statusPhotosAndroid.isDenied) {
        //   print("statusPhotosAndroid isDenied");

        //   // Close loading dialog first
        //   if (Navigator.of(context, rootNavigator: true).canPop()) {
        //     Navigator.of(context, rootNavigator: true).pop();
        //   }

        //   await Permission.photos.request();
        // } else {
        //   print("statusPhotosAndroid etc...");

        //   // Close loading dialog first
        //   if (Navigator.of(context, rootNavigator: true).canPop()) {
        //     Navigator.of(context, rootNavigator: true).pop();
        //   }

        //   // Display warning dialog
        //   await showDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     builder: (context) {
        //       return NewVer5CustAlertDialogWarningBtnConfirm(
        //         title: "warning".tr,
        //         contentText: "want_access_photos".tr,
        //         textButton: "ok".tr,
        //         press: () async {
        //           await openAppSettings();

        //           Future.delayed(Duration(seconds: 1), () {
        //             // Close warning dialog
        //             if (Navigator.canPop(context)) Navigator.pop(context);
        //           });
        //         },
        //       );
        //     },
        //   );
        // }
      }

      // Android < 13 (API ≤ 32)
      else {
        var statusStorageAndroid = await Permission.storage.status;

        print("Platform Android: " + statusStorageAndroid.toString());

        if (statusStorageAndroid.isGranted) {
          print("statusStorageAndroid isGranted");
          final ImagePicker _picker = ImagePicker();
          final XFile? image = await _picker.pickImage(source: source);

          //ຖ້າບໍ່ເລືອກຮູບໃຫ້ return ອອກເລີຍ
          if (image == null) {
            Navigator.pop(context);
            return;
          }

          //ກວດຟາຍຮູບຖ້າບໍ່ແມ່ນ 'png', 'jpg', 'jpeg'
          final allowedExtensions = ['png', 'jpg', 'jpeg'];
          final fileExtension = image.path.split('.').last.toLowerCase();

          //ກວດຟາຍຮູບຖ້າບໍ່ແມ່ນ 'png', 'jpg', 'jpeg' ໃຫ້ return ອອກເລີຍ
          if (!allowedExtensions.contains(fileExtension)) {
            // Close loading dialog first
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }

            print("valUploadFile allowedExtensions 'png', 'jpg', 'jpeg'");

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

          //ຖ້າມີຟາຍຮູບ _image
          if (_image != null) {
            //api upload profile seeker
            var valUploadFile =
                await upLoadFile(strImage, uploadProfileApiSeeker);

            //ຫຼັງຈາກ api upload ສຳເລັດແລ້ວ
            //valUploadFile != null ເຮັດວຽກ method uploadOrUpdateProfileImageSeeker()
            if (valUploadFile != null) {
              print("if valUploadFile: " + valUploadFile.toString());

              _fileValue = valUploadFile['file'];
              print("fileValue: " + _fileValue.toString());

              if (_fileValue != null || _fileValue != "") {
                // Api upload or update CV
                uploadOrUpdateCV(_fileValue, false);

                Navigator.pop(context);
              }
            }

            //valUploadFile == null ແຈ້ງເຕືອນຟາຍຮູບໃຫ່ຍເກີນໄປ
            else {
              // Close loading dialog first
              if (Navigator.of(context, rootNavigator: true).canPop()) {
                Navigator.of(context, rootNavigator: true).pop();
              }

              print("else valUploadFile: " + valUploadFile.toString());

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

  uploadOrUpdateCV(dynamic paramFileValue, bool systemGenCVStatus) async {
    final profileProvider = context.read<ProfileProvider>();

    // Display AlertDialog Loading First
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    final res = await profileProvider.uploadOrUpdateCV(
      paramFileValue,
      systemGenCVStatus,
      profileProvider.statusEventUpdateProfile,
    );

    final statusCode = res?["statusCode"];

    if (!context.mounted) return;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    print("api uploadOrUpdateCV: " + "${res}");

    if (statusCode == 200 || statusCode == 201) {
      //After sucess work api fetchProfileSeeker
      await profileProvider.fetchProfileSeeker();

      // checkCvStatusDisplayForm();

      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "successfully".tr,
            contentText: "cv_uploaded".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);

              // Call parent callback
              if (widget.onSaveSuccess != null) {
                widget.onSaveSuccess!();
              }
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

  pressDeleteCV(bool systemGenCVStatus) async {
    final profileProvider = context.read<ProfileProvider>();

    // Display AlertDialog Loading First
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    final res = await profileProvider.deleteCV(systemGenCVStatus);

    final statusCode = res?["statusCode"];

    if (!context.mounted) return;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    if (statusCode == 200 || statusCode == 201) {
      await profileProvider.fetchProfileSeeker();

      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "successfully".tr,
            contentText: "delete_cv_success".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  checkCvStatusDisplayForm() async {
    final profileProvider = context.read<ProfileProvider>();

    if (profileProvider.statusFormProfile == "Event") {
      if (profileProvider.haveCVFile == "No") {
        setState(() {
          _isSystemGenCVStatus = true;
        });
      } else if (profileProvider.haveCVFile == "Yes") {
        setState(() {
          _isSystemGenCVStatus = false;
        });
      }
    } else {
      if (profileProvider.cv == null && profileProvider.vipoCV == null) {
        setState(() {
          _isSystemGenCVStatus = false;
        });
      } else if (profileProvider.cv != null) {
        setState(() {
          _isSystemGenCVStatus = false;
        });
        // _cvSrc = profileProvider.cv?['src'] ?? "";
      } else {
        setState(() {
          _isSystemGenCVStatus = true;
        });
        // _cvSystemGenerateSrc = profileProvider.vipoCV?['src'] ?? "";
      }
    }
  }

  ModalBottomCameraGallery() {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 40),
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
    checkCvStatusDisplayForm();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    return Container(
      color: AppColors.backgroundWhite,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          //
          //
          //Section1 Header button switch CV and System Gen CV
          if (profileProvider.statusFormProfile == "")
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  //Button Upload CV
                  Expanded(
                    child: Button(
                      text: "i_have_cv".tr,
                      textColor: !_isSystemGenCVStatus
                          ? AppColors.fontWhite
                          : AppColors.fontDark,
                      textFontWeight:
                          !_isSystemGenCVStatus ? FontWeight.bold : null,
                      buttonColor: !_isSystemGenCVStatus
                          ? AppColors.primary
                          : AppColors.dark100,
                      press: () {
                        setState(() {
                          _isSystemGenCVStatus = false;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 5),

                  //Button System Generate CV
                  Expanded(
                    child: Button(
                      text: "system_gen_cv".tr,
                      textColor: _isSystemGenCVStatus
                          ? AppColors.fontWhite
                          : AppColors.fontDark,
                      textFontWeight:
                          _isSystemGenCVStatus ? FontWeight.bold : null,
                      buttonColor: _isSystemGenCVStatus
                          ? AppColors.primary
                          : AppColors.dark100,
                      press: () {
                        setState(() {
                          _isSystemGenCVStatus = true;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),

          Container(
            color: AppColors.backgroundWhite,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: !_isSystemGenCVStatus
                //
                //CV
                //ຖ້າວ່າ _isSystemGenCVStatus  = false
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //BoxDecoration Upload CV
                          BoxDecDottedBorderUploadCV(
                            boxDecColor: AppColors.primary100,
                            boxDecBorderRadius: BorderRadius.circular(5),
                            title: "select_cv_file".tr,
                            titleColor: AppColors.primary600,
                            titleFontWeight: FontWeight.bold,
                            text: _strFileName == "" || _strFileName == null
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
                          SizedBox(height: 20),
                        ],
                      ),

                      // Button(
                      //   text: "deletet cv",
                      //   press: () {
                      //     pressDeleteCV(false);
                      //   },
                      // ),

                      //
                      //
                      //Button Download CV
                      if (profileProvider.cv != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primary100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "You have already uploaded CV file.",
                                  style: bodyTextMaxNormal(
                                      null, AppColors.primary, FontWeight.bold),
                                ),
                                SizedBox(height: 15),
                                ButtonDefault(
                                  text: "download_cv_file".tr,
                                  press: () async {
                                    launchInBrowser(
                                        Uri.parse(profileProvider.cvSrc));
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  )

                //
                //System Generate CV
                //ຖ້າວ່າ _isSystemGenCVStatus  = true
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!profileProvider.personalInformationStatus)
                              SystemBuildCVStatus(
                                boxColor: AppColors.danger100,
                                icon: "\uf057",
                                text: "Please Update Personal Information",
                                textColor: AppColors.fontDanger,
                              ),
                            if (!profileProvider.workPreferenceStatus)
                              SystemBuildCVStatus(
                                boxColor: AppColors.danger100,
                                icon: "\uf057",
                                text: "Please Update Work Preference",
                                textColor: AppColors.fontDanger,
                              ),
                            if (!profileProvider.educationStatus)
                              SystemBuildCVStatus(
                                boxColor: AppColors.danger100,
                                icon: "\uf057",
                                text: "Please Add Education",
                                textColor: AppColors.fontDanger,
                              ),
                            if (!profileProvider.workHistoryStatus)
                              SystemBuildCVStatus(
                                boxColor: AppColors.danger100,
                                icon: "\uf057",
                                text: "Please Add Work History",
                                textColor: AppColors.fontDanger,
                              ),
                            if (!profileProvider.languageStatus)
                              SystemBuildCVStatus(
                                boxColor: AppColors.danger100,
                                icon: "\uf057",
                                text: "Please Add Language Skill",
                                textColor: AppColors.fontDanger,
                              ),
                            if (!profileProvider.skillStatus)
                              SystemBuildCVStatus(
                                boxColor: AppColors.danger100,
                                icon: "\uf057",
                                text: "Please Add Skill",
                                textColor: AppColors.fontDanger,
                              ),
                            if (profileProvider.educationStatus &&
                                profileProvider.workHistoryStatus &&
                                profileProvider.languageStatus &&
                                profileProvider.skillStatus)
                              SystemBuildCVStatus(
                                boxColor: AppColors.success100,
                                icon: "\uf058",
                                text:
                                    "Your profile is complete, you can create CV now.",
                                textColor: AppColors.fontSuccess,
                              ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),

                      if (profileProvider.vipoCV != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primary100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "CV generated by the system.",
                                  style: bodyTextMaxNormal(
                                      null, AppColors.primary, FontWeight.bold),
                                ),
                                SizedBox(height: 15),
                                ButtonDefault(
                                  text: "download_cv_file".tr,
                                  press: () async {
                                    launchInBrowser(Uri.parse(
                                        profileProvider.cvSystemGenerateSrc));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                      Divider(
                        color: AppColors.borderBG,
                        thickness: 2,
                      ),

                      SizedBox(height: 10),

                      //
                      //
                      //Button System Generate CV
                      if (profileProvider.personalInformationStatus &&
                          profileProvider.workPreferenceStatus &&
                          profileProvider.educationStatus &&
                          profileProvider.workHistoryStatus &&
                          profileProvider.languageStatus &&
                          profileProvider.skillStatus)
                        Button(
                          text: "create_cv".tr,
                          press: () async {
                            uploadOrUpdateCV(null, true);
                          },
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class SystemBuildCVStatus extends StatefulWidget {
  const SystemBuildCVStatus({
    Key? key,
    this.boxColor,
    this.textColor,
    this.icon,
    this.text,
  }) : super(key: key);

  final Color? boxColor, textColor;
  final String? icon, text;

  @override
  State<SystemBuildCVStatus> createState() => _SystemBuildCVStatusState();
}

class _SystemBuildCVStatusState extends State<SystemBuildCVStatus> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.boxColor ?? AppColors.dark100,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                "${widget.icon}",
                style: fontAwesomeSolid(
                    null, null, widget.textColor ?? AppColors.dark, null),
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                "${widget.text}",
                style: bodyTextNormal(
                    null, widget.textColor ?? AppColors.dark, null),
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
