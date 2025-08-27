// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, prefer_if_null_operators, non_constant_identifier_names, unused_local_variable, unused_field, unnecessary_string_interpolations, prefer_final_fields, unnecessary_null_in_if_null_operators, avoid_print, prefer_adjacent_string_concatenation, unnecessary_this, use_build_context_synchronously, prefer_interpolation_to_compose_strings, deprecated_member_use

import 'dart:io';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/internetDisconnected.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/Events/scannerQRCode.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/Events/eventTicket.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/JobAlert/jobAlert.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/LoginInfo/loginInformation.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/myProfile.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Account extends StatefulWidget {
  const Account(
      {Key? key,
      this.callBackToMyJobsSavedJob,
      this.callBackToMyJobsAppliedJob,
      this.hasInternet})
      : super(key: key);
  final VoidCallback? callBackToMyJobsSavedJob;
  final Function(dynamic)? callBackToMyJobsAppliedJob;
  final hasInternet;

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  dynamic _seekerProfile;
  dynamic _eventInfo;
  dynamic _objEventAvailable;

  String _eventInfoId = "";
  String _eventInfoName = "";
  String _firstName = "";
  String _lastName = "";
  String _imageSrc = "";
  String _memberLevel = "";
  String _currentJobTitle = "";
  String? qrData;

  int _savedJobs = 0;
  int _appliedJobs = 0;
  int _epmSavedSeeker = 0;
  int _submitedCV = 0;
  int _totalPoint = 0;

  dynamic _workPreferences;
  dynamic _fileValue;

  File? _image;

  bool _isLoading = true;
  bool _imageLoading = false;
  bool _isApplied = false;

  getEvnetAvailable() async {
    var res = await fetchData(getEventAvailableSeekerApi);
    print("api get event available: " + res.toString());

    if (res.containsKey("message")) {
      print("res containsKey message: " + res["message"]);

      return;
    } else {
      _objEventAvailable = res;
      _eventInfo = res["eventInfo"];
      _isApplied = res["isApplied"] as bool? ?? false;
      // _eventInfo = null;
      // _isApplied = false;

      // ຖ້າວ່າ _eventInfo == null ຈະລົບຄ່າຂອງ qrString ອອກ
      if (_eventInfo == null || !_isApplied) {
        await SharedPrefsHelper.remove("qrString");
        print("removed qrString");
      }

      if (_eventInfo != null) {
        _eventInfoId = _eventInfo["_id"];
        _eventInfoName = _eventInfo["name"];
      }
      print("_isApplied: " + _isApplied.toString());

      setState(() {});
    }
  }

  applyEvent() async {
    var res = await postData(applyEventSeekerApi, {"eventId": _eventInfoId});
    print("res apply event: " + res.toString());

    if (res["message"] == "Applied succeed") {
      await getEvnetAvailable();

      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "successful".tr,
            contentText: "registered_attend".tr,
            textButton: "ok".tr,
            press: () {
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
            title: "warning".tr,
            contentText: "already_registered_attend".tr,
            textButton: "ok".tr,
          );
        },
      );
    }
  }

  getProfileSeeker() async {
    print("api get profile working account screen");
    var res = await fetchData(getProfileSeekerApi);
    _seekerProfile = res['profile'];
    _firstName = _seekerProfile['firstName'];
    _lastName = _seekerProfile['lastName'];
    _memberLevel = _seekerProfile['memberLevel'];
    if (_seekerProfile['file'] != "") {
      _imageSrc = !_seekerProfile['file'].containsKey("src") ||
              _seekerProfile['file']["src"] == null
          ? ""
          : _seekerProfile['file']["src"];
    }

    _workPreferences = res['workPreferences'] ?? null;
    if (_workPreferences != null) {
      _currentJobTitle = _workPreferences['currentJobTitle'];
    }

    _isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  getTotalJobSeeker() async {
    var res = await fetchData(getTotalMyJobSeekerApi);
    print("${res}");

    _savedJobs = int.parse(res['saveJobTotals'].toString());
    _appliedJobs = int.parse(res['appliedJobTotals'].toString());
    _submitedCV = int.parse(res['submittedTotals'].toString());
    _epmSavedSeeker = int.parse(res['empViewTotals'].toString());
    _totalPoint = int.parse(res['totalPoint'].toString());

    if (mounted) {
      setState(() {});
    }
  }

  pickImageGallery(ImageSource source) async {
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
        if (image == null) return;

        setState(() {
          _imageLoading = true;
        });

        //
        //ກວດຟາຍຮູບຖ້າບໍ່ແມ່ນ 'png', 'jpg', 'jpeg'
        final allowedExtensions = ['png', 'jpg', 'jpeg'];
        final fileExtension = image.path.split('.').last.toLowerCase();

        //
        //ກວດຟາຍຮູບຖ້າບໍ່ແມ່ນ 'png', 'jpg', 'jpeg' ໃຫ້ return ອອກເລີຍ
        if (!allowedExtensions.contains(fileExtension)) {
          print("valUploadFile is null");
          setState(() {
            _imageLoading = false;
          });
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
              uploadOrUpdateProfileImageSeeker();
            }
          }
          //
          //valUploadFile == null ແຈ້ງເຕືອນຟາຍຮູບໃຫ່ຍເກີນໄປ
          else {
            print("else valUploadFile: " + valUploadFile.toString());
            setState(() {
              _imageLoading = false;
            });
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
          if (image == null) return;

          setState(() {
            _imageLoading = true;
          });

          //
          //ກວດຟາຍຮູບຖ້າບໍ່ແມ່ນ 'png', 'jpg', 'jpeg'
          final allowedExtensions = ['png', 'jpg', 'jpeg'];
          final fileExtension = image.path.split('.').last.toLowerCase();

          //
          //ກວດຟາຍຮູບຖ້າບໍ່ແມ່ນ 'png', 'jpg', 'jpeg' ໃຫ້ return ອອກເລີຍ
          if (!allowedExtensions.contains(fileExtension)) {
            print("valUploadFile allowedExtensions 'png', 'jpg', 'jpeg'");
            setState(() {
              _imageLoading = false;
            });
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
                uploadOrUpdateProfileImageSeeker();
              }
            }
            //
            //valUploadFile == null ແຈ້ງເຕືອນຟາຍຮູບໃຫ່ຍເກີນໄປ
            else {
              print("else valUploadFile: " + valUploadFile.toString());
              setState(() {
                _imageLoading = false;
              });
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

          await Permission.photos.request();
        } else {
          print("statusPhotosAndroid etc...");

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
          if (image == null) return;

          setState(() {
            _imageLoading = true;
          });

          //
          //ກວດຟາຍຮູບຖ້າບໍ່ແມ່ນ 'png', 'jpg', 'jpeg'
          final allowedExtensions = ['png', 'jpg', 'jpeg'];
          final fileExtension = image.path.split('.').last.toLowerCase();

          //
          //ກວດຟາຍຮູບຖ້າບໍ່ແມ່ນ 'png', 'jpg', 'jpeg' ໃຫ້ return ອອກເລີຍ
          if (!allowedExtensions.contains(fileExtension)) {
            print("valUploadFile allowedExtensions 'png', 'jpg', 'jpeg'");
            setState(() {
              _imageLoading = false;
            });
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
                uploadOrUpdateProfileImageSeeker();
              }
            }
            //
            //valUploadFile == null ແຈ້ງເຕືອນຟາຍຮູບໃຫ່ຍເກີນໄປ
            else {
              print("else valUploadFile: " + valUploadFile.toString());
              setState(() {
                _imageLoading = false;
              });
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

          await Permission.storage.request();
        } else {
          print("statusStorageAndroid etc...");

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

  uploadOrUpdateProfileImageSeeker() async {
    print("api upload profile image working account screen");
    var res = await postData(
        uploadOrUpdateProfileImageApiSeeker, {"file": _fileValue});

    if (res != null) {
      await getProfileSeeker();
      _imageLoading = false;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    print("widget hasInternet account: " + "${widget.hasInternet}");

    if (widget.hasInternet == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showInternetDisconnected(context);
      });
    } else {
      getProfileSeeker();
      getTotalJobSeeker();
      getEvnetAvailable();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        // appBar: AppBar(
        //   toolbarHeight: 0,
        //   systemOverlayStyle: SystemUiOverlayStyle.light,
        //   backgroundColor: AppColors.backgroundAppBar,
        // ),

        body: SafeArea(
          child: _isLoading
              ? Container(
                  color: AppColors.backgroundWhite,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: CustomLoadingLogoCircle(),
                  ),
                )
              : SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      //
                      //
                      //
                      //
                      //
                      //
                      //
                      //
                      //Section Profile Image
                      Container(
                        color: AppColors.primary,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 40,
                                ),
                                _imageLoading
                                    ? Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.backgroundWhite
                                              .withOpacity(0.5),
                                        ),
                                        child: Center(
                                          child: Text("uploading".tr),
                                        ),
                                      )
                                    : Container(
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          alignment: Alignment.center,
                                          children: [
                                            //
                                            //
                                            //Placeholder circle for profile picture
                                            // DottedBorder(
                                            // dashPattern: [6, 7],
                                            // strokeWidth: 2,
                                            // borderType: BorderType.Circle,
                                            // color: AppColors.borderWhite,
                                            // borderPadding: EdgeInsets.all(1),

                                            //
                                            //
                                            //Profile Image
                                            Container(
                                              width: 150,
                                              height: 150,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: _imageSrc == ""
                                                    ? Image.asset(
                                                        'assets/image/defprofile.jpg',
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(
                                                        "${_imageSrc}",
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Image.asset(
                                                            'assets/image/defprofile.jpg',
                                                            fit: BoxFit.cover,
                                                          ); // Display an error message
                                                        },
                                                      ),
                                              ),

                                              // decoration: BoxDecoration(
                                              //   shape: BoxShape.circle,
                                              //   color: AppColors.greyOpacity,
                                              //   image: _imageSrc == ""
                                              //       ? DecorationImage(
                                              //           image: AssetImage(
                                              //               'assets/image/def-profile.png'),
                                              //           fit: BoxFit.cover,
                                              //         )
                                              //       : DecorationImage(
                                              //           image: NetworkImage(_imageSrc),
                                              //           fit: BoxFit.cover,
                                              //         ),
                                              // ),
                                              // child: CircleAvatar(
                                              //   radius: 90,
                                              //   backgroundImage:
                                              //       AssetImage('assets/image/def-profile.png'),
                                              // ),
                                            ),
                                            // ),

                                            //
                                            //
                                            //Status Seeker on top profile image
                                            Positioned(
                                              top: -20,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: AppColors.success600,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: Text(
                                                  _memberLevel,
                                                  style: bodyTextSmall(
                                                      null,
                                                      AppColors.fontWhite,
                                                      null),
                                                ),
                                              ),
                                            ),

                                            //
                                            //
                                            //Gallery icon to choose upload image profile
                                            Positioned(
                                              bottom: 0,
                                              right: 5,
                                              child: GestureDetector(
                                                onTap: () {
                                                  pickImageGallery(
                                                      ImageSource.gallery);
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors
                                                        .backgroundWhite,
                                                    border: Border.all(
                                                        color: AppColors
                                                            .borderWhite),
                                                  ),
                                                  child: Text(
                                                    "\uf03e",
                                                    style: fontAwesomeRegular(
                                                        null,
                                                        15,
                                                        AppColors.iconPrimary,
                                                        null),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                SizedBox(
                                  height: 10,
                                ),

                                //
                                //
                                //Profile Name
                                Text(
                                  "${_firstName} ${_lastName}",
                                  style: bodyTextMedium(null,
                                      AppColors.fontWhite, FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),

                                //
                                //
                                //Currnet Job / Position
                                Text(
                                  _currentJobTitle == ""
                                      ? "- -"
                                      : "${_currentJobTitle}",
                                  style: bodyTextNormal(
                                      null, AppColors.fontWhite, null),
                                  textAlign: TextAlign.center,
                                ),
                                // Container(),

                                //
                                //
                                //ກວດສະຖານະເປັນ Expert Job Seeker ແລະ ສະຖານະງານຈັດຂຶ້ນ
                                if (_memberLevel == "Expert Job Seeker" &&
                                    _eventInfo != null)

                                  //
                                  //
                                  //Button register Events
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (!_isApplied) {
                                              await applyEvent();
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventTicket(
                                                    imageSrc: _imageSrc,
                                                    firstName: _firstName,
                                                    lastName: _lastName,
                                                    objEventAvailable:
                                                        _objEventAvailable,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: AppColors.warning600,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Text(
                                              _isApplied
                                                  ? "${_eventInfoName}"
                                                  : "attend_event".tr +
                                                      " ${_eventInfoName}",
                                              style: bodyTextNormal(
                                                  null, null, FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),

                            //
                            //
                            //ກວດສະຖານະເປັນ Expert Job Seeker ແລະ ສະຖານະງານຈັດຂຶ້ນ
                            if (_memberLevel == "Expert Job Seeker" &&
                                _eventInfo != null)
                              Positioned(
                                top: 0,
                                right: 0,

                                //
                                //
                                //Button scan QR code
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QRScanner(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.dark100,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Icon(
                                      Icons.qr_code_scanner_outlined,
                                      color: AppColors.primary,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      //
                      //
                      //
                      //
                      //
                      //
                      //
                      //
                      //
                      //Section profile content
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //
                            //
                            //Box profile
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Column(
                                children: [
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //Profile Statisics
                                  //First row 3 box(save job, applied job, submitted cv)
                                  Row(
                                    children: [
                                      //
                                      //
                                      //Save job / ວຽກທີ່ບັນທຶກໄວ້
                                      Expanded(
                                        flex: 1,
                                        child: StatisicBox(
                                          // boxColor: AppColors.lightPrimary,
                                          amount: "${_savedJobs}",
                                          text: "saved_job".tr,
                                          press:
                                              widget.callBackToMyJobsSavedJob,
                                        ),
                                      ),
                                      SizedBox(width: 10),

                                      //
                                      //
                                      //Applied job / ວຽກທີ່ສະໝັກ
                                      Expanded(
                                        flex: 1,
                                        child: StatisicBox(
                                          // boxColor: AppColors.lightOrange,
                                          amount: "${_appliedJobs}",
                                          text: "applied_job".tr,
                                          press: () {
                                            setState(() {
                                              widget.callBackToMyJobsAppliedJob!(
                                                  "AppliedJob");
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),

                                      //
                                      //
                                      //Submitted CV / ຢື່ນສະໝັກວຽກ
                                      Expanded(
                                        flex: 1,
                                        child: StatisicBox(
                                          // boxColor: AppColors.lightGreen,
                                          amount: "${_submitedCV}",
                                          text: "submitted_cv".tr,
                                          press: () {},
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  //
                                  //
                                  //Second row 2 box(company view profile, member point)
                                  Row(
                                    children: [
                                      //
                                      //
                                      //Company view profile / ບໍລິສັດເບິ່ງໂປຣໄຟສ
                                      Expanded(
                                        flex: 1,
                                        child: StatisicBox(
                                          // boxColor: AppColors.lightGrayishCyan,
                                          amount: "${_epmSavedSeeker}",
                                          text: "company_view_profile".tr,
                                          press: () {},
                                        ),
                                      ),
                                      SizedBox(width: 10),

                                      //
                                      //
                                      //Member Point / ຄະແນນສະສົມ
                                      Expanded(
                                        flex: 1,
                                        child: StatisicBox(
                                          // boxColor: AppColors.lightYellow,
                                          amount: "${_totalPoint}",
                                          text: "member_point".tr,
                                          press: () {},
                                        ),
                                      ),
                                      SizedBox(width: 10),

                                      //
                                      //
                                      //
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 110,
                                          width: double.infinity,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            //
                            //
                            //Account Setting
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                "account setting".tr,
                                style: bodyTextMaxNormal(
                                    "NotoSansLaoLoopedBold",
                                    null,
                                    FontWeight.bold),
                              ),
                            ),
                            Divider(
                              thickness: 2,
                              color: AppColors.borderGrey.withOpacity(0.3),
                            ),

                            //
                            //
                            //Login Information
                            AccountSetting(
                              prefixIconStr: "\uf023",
                              text: "login_info".tr,
                              suffixIconStr: "\uf054",
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginInformation(),
                                  ),
                                );
                              },
                            ),

                            //
                            //
                            //My Profile
                            AccountSetting(
                              prefixIconStr: "\uf007",
                              text: "my_profile".tr,
                              suffixIconStr: "\uf054",
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyProfile(),
                                  ),
                                ).then((value) {
                                  // fetchNotifierProvider();
                                  if (value != "") {
                                    print(
                                        "navigator.pop imageSrc from MyProfile scree :" +
                                            "${value}");
                                    setState(() {
                                      _imageSrc = value;
                                    });
                                  }
                                });
                              },
                            ),

                            //
                            //
                            //Job Alert
                            AccountSetting(
                              prefixIconStr: "\uf0f3",
                              text: "job_alert".tr,
                              suffixIconStr: "\uf054",
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobAlert(),
                                  ),
                                );
                              },
                            ),

                            SizedBox(
                              height: 30,
                            ),
                            //
                            //
                            //
                            //
                            //

                            // ElevatedButton(
                            //   onPressed: () {
                            //     setState(() {
                            //       qrData = 'WF-104';
                            //     });
                            //   },
                            //   child: Text('Generate QR Code'),
                            // ),
                            // const SizedBox(height: 20),
                            // if (qrData != null)
                            //   QrImageView(
                            //     data: qrData!,
                            //     version: QrVersions.auto,
                            //     size: 200.0,
                            //   ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class StatisicBox extends StatefulWidget {
  const StatisicBox({
    Key? key,
    this.amount,
    this.text,
    this.boxColor,
    this.press,
  }) : super(key: key);
  final String? amount, text;
  final Color? boxColor;
  final Function()? press;

  @override
  State<StatisicBox> createState() => _StatisicBoxState();
}

class _StatisicBoxState extends State<StatisicBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: boxDecoration(BorderRadius.circular(5),
          widget.boxColor ?? AppColors.primary200, AppColors.borderWhite, null),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.press,
          borderRadius: BorderRadius.circular(5),
          // splashColor: AppColors.backgroundWhite,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "${widget.amount}",
                      style: bodyTextMaxMedium(
                          "NotoSansLaoLoopedBold", AppColors.primary600, null),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${widget.text}",
                    style: bodyTextSmall(null, null, FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
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

class AccountSetting extends StatefulWidget {
  const AccountSetting(
      {Key? key,
      this.text,
      this.press,
      this.textColor,
      this.suffixIconStr,
      this.prefixIconStr,
      this.fontFamilySuffixIcon,
      this.suffixIconColor,
      this.fontFamilyPrefixIcon,
      this.prefixIconColor})
      : super(key: key);
  final String? prefixIconStr,
      fontFamilyPrefixIcon,
      text,
      suffixIconStr,
      fontFamilySuffixIcon;

  final Color? textColor, prefixIconColor, suffixIconColor;
  final Function()? press;

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.press,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "${widget.prefixIconStr}",
                          style: fontAwesomeSolid(widget.fontFamilyPrefixIcon,
                              IconSize.xsIcon, widget.prefixIconColor, null),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${widget.text}",
                          style: bodyTextNormal(
                              "NotoSansLaoLoopedSemiBold", null, null),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${widget.suffixIconStr}",
                    style: fontAwesomeSolid(widget.fontFamilySuffixIcon,
                        IconSize.xsIcon, widget.suffixIconColor, null),
                  )
                ],
              ),
            ),
          ),
        ),
        Divider(
          thickness: 1,
          height: 1,
          color: AppColors.borderGrey.withOpacity(0.3),
        ),
      ],
    );
  }
}
