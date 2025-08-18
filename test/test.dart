//SHA-1: BE:65:EC:EC:5B:A8:99:8A:23:2C:94:1E:BF:68:9C:91:24:D9:49:C2 / vmXs7FuomYojLJQev2ickSTZScI=
//SHA-256: EA:43:D2:80:D7:C3:5D:DC:E6:56:1A:CC:F5:81:E6:43:87:64:4A:0D:09:11:AC:A1:F2:F4:63:B3:65:BB:09:0A / 6kPSgNfDXdzmVhrM9YHmQ4dkSg0JEayh8vRjs2W7CQo=

//SHA-1: 59:F0:34:D2:40:BE:B9:C8:75:43:75:84:FA:6A:79:78:26:FB:91:1E / WfA00kC+uch1Q3WE+mp5eCb7kR4=
//SHA-256: 7E:4C:1F:E5:46:50:E2:CD:D5:29:E1:DE:DD:15:B6:A4:21:95:FC:06:5E:6B:CE:59:1C:B7:8F:92:33:56:36:DD / fkwf5UZQ4s3VKeHe3RW2pCGV/AZea85ZHLePkjNWNt0=
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, prefer_if_null_operators, non_constant_identifier_names, unused_local_variable, unused_field, unnecessary_string_interpolations, prefer_final_fields, unnecessary_null_in_if_null_operators, avoid_print, prefer_adjacent_string_concatenation, unnecessary_this, prefer_interpolation_to_compose_strings, use_build_context_synchronously, deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/internetDisconnected.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/Events/registerEvent.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/JobAlert/jobAlert.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/LoginInfo/loginInformation.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/myProfile.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

class AccountRenew extends StatefulWidget {
  const AccountRenew(
      {Key? key,
      this.callBackToMyJobsSavedJob,
      this.callBackToMyJobsAppliedJob,
      this.hasInternet})
      : super(key: key);
  final VoidCallback? callBackToMyJobsSavedJob;
  final Function(dynamic)? callBackToMyJobsAppliedJob;
  final hasInternet;

  @override
  State<AccountRenew> createState() => _AccountRenewState();
}

class _AccountRenewState extends State<AccountRenew> {
  dynamic _seekerProfile;
  dynamic _eventInfo;
  dynamic _objEventAvailable;

  String _eventInfoId = "";
  String _eventInfoName = "";
  String _eventInfoAddress = "";
  String _eventInfoOpeningTime = "";
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
  int _percentage = 0;
  double _percentageUsed = 0.0;
  double _scale = 1.0;

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
        _eventInfoAddress = _eventInfo["address"];
        _eventInfoOpeningTime = _eventInfo["openingTime"];
      }
      print("_isApplied: " + _isApplied.toString());

      setState(() {});
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

    _percentage =
        res["percentage"] == null ? 0 : int.parse(res["percentage"].toString());

    _percentageUsed = _percentage / 7;

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

  onTapDownBoxEvent(TapDownDetails details) {
    setState(() => _scale = 0.98); // slightly shrink
  }

  onTapUpBoxEvent(TapUpDetails details) {
    setState(() => _scale = 1.0); // return to normal
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
          child: Container(
            color: AppColors.dark100,
            height: double.infinity,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 70),
                    Container(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.backgroundWhite,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 60),
                                Text(
                                  "${_firstName} ${_lastName}",
                                  style: bodyTextMedium(
                                      null, null, FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  _currentJobTitle == ""
                                      ? "- -"
                                      : "${_currentJobTitle}",
                                  style: bodyTextNormal(null, null, null),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 5),
                                Divider(color: AppColors.borderGreyOpacity),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "status".tr,
                                          style: bodyTextMaxSmall(
                                              null, AppColors.dark500, null),
                                        ),
                                        Text(
                                          "${_memberLevel}",
                                          style: bodyTextMaxSmall(
                                              null,
                                              AppColors.primary600,
                                              FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "complete_your_profile".tr,
                                          style: bodyTextMaxSmall(
                                              null, AppColors.dark500, null),
                                        ),
                                        Text(
                                          "${(_percentageUsed * 100).round()}% ",
                                          style: bodyTextMaxSmall(
                                              null,
                                              AppColors.primary600,
                                              FontWeight.bold),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            top: -70,
                            child: _imageLoading
                                ? Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.backgroundWhite
                                          .withOpacity(0.5),
                                    ),
                                    child: Center(
                                      child: Text("uploading".tr),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      print("eiei");
                                      // pickImageGallery(ImageSource.gallery);
                                    },
                                    behavior: HitTestBehavior.translucent,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.center,
                                      children: [
                                        CircularPercentIndicator(
                                          radius: 70.0,
                                          lineWidth: 3.0,
                                          animation: true,
                                          percent: _percentageUsed,
                                          animationDuration: 500,
                                          startAngle: 150.0,
                                          progressColor: AppColors.primary600,
                                          backgroundColor: AppColors.primary200,
                                          center: Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                                color:
                                                    AppColors.backgroundWhite,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
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
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 5,
                                          right: 10,
                                          child: Container(
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    AppColors.backgroundWhite,
                                                border: Border.all(
                                                    color: AppColors.borderBG),
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
                          )
                        ],
                      ),
                    ),

                    //
                    //
                    //ກວດສະຖານະງານຈັດຂຶ້ນ eventInfo ຕ້ອງມີຄ່າ
                    if (_eventInfo != null)
                      GestureDetector(
                        onTap: () {
                          // if (!_isApplied) {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterEvent(
                                imageSrc: _imageSrc,
                                firstName: _firstName,
                                lastName: _lastName,
                                objEventAvailable: _objEventAvailable,
                                eventInfo: _eventInfo,
                                eventInfoId: _eventInfoId,
                                eventInfoName: _eventInfoName,
                                eventInfoAddress: _eventInfoAddress,
                                eventInfoOpeningTime: _eventInfoOpeningTime,
                                isApplied: _isApplied,
                                memberLevel: _memberLevel,
                              ),
                            ),
                          ).then((value) {
                            if (value == "Applied Succeed") {
                              getProfileSeeker();
                              getEvnetAvailable();
                            }
                          });
                        },
                        onTapDown: onTapDownBoxEvent,
                        onTapUp: onTapUpBoxEvent,
                        child: AnimatedScale(
                          scale: _scale,
                          duration: Duration(milliseconds: 100),
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: AppColors.teal,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          // color: AppColors.red,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (!_isApplied)
                                                Text(
                                                  "ລົງທະບຽນເພື່ອເຂົ້າຮ່ວມງານ!",
                                                  style: bodyTextMedium(
                                                      null,
                                                      AppColors.fontWhite,
                                                      FontWeight.bold),
                                                ),
                                              Text(
                                                "${_eventInfoName}",
                                                style: bodyTextMedium(
                                                    null,
                                                    AppColors.fontWhite,
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 70,
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: -20,
                                  right: 15,
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundWhite,
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: AppColors.teal,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.asset(
                                          'assets/image/logo_wiifair_10.jpg'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    SizedBox(
                      height: 20,
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
                    //Section Account Setting
                    Column(
                      children: [
                        //
                        //
                        //
                        //
                        //Account Setting
                        Row(
                          children: [
                            Container(
                              width: 5,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.primary600,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "account setting".tr,
                              style: bodyTextMaxNormal("NotoSansLaoLoopedBold",
                                  null, FontWeight.bold),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        //
                        //
                        //
                        //
                        //List Account Setting
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.backgroundWhite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              //
                              //
                              //My Profile / ໂປຣໄຟສ
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

                                      getProfileSeeker();
                                      getTotalJobSeeker();
                                      getEvnetAvailable();
                                      setState(() {
                                        _imageSrc = value;
                                      });
                                    }
                                  });
                                },
                              ),

                              //
                              //
                              //Login Information / ຂໍ້ມູນການເຂົ້າລະບົບ
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
                              //Job Alert / ແຈ້ງເຕືອນວຽກ
                              AccountSetting(
                                prefixIconStr: "\uf8fa",
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
                            ],
                          ),
                        ),

                        //Box Account Setting
                        // Row(
                        //   children: [
                        //     //
                        //     //
                        //     //My Profile / ໂປຣໄຟສ
                        //     Expanded(
                        //       flex: 1,
                        //       child: BoxAccountSetting(
                        //         boxColor: AppColors.backgroundWhite,
                        //         iconString: "\uf007",
                        //         text: "my_profile".tr,
                        //         press: () {
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) => MyProfile(),
                        //             ),
                        //           ).then((value) {
                        //             // fetchNotifierProvider();
                        //             if (value != "") {
                        //               print(
                        //                   "navigator.pop imageSrc from MyProfile scree :" +
                        //                       "${value}");
                        //               setState(() {
                        //                 _imageSrc = value;
                        //               });
                        //             }
                        //           });
                        //         },
                        //       ),
                        //     ),
                        //     SizedBox(width: 10),
                        //     //
                        //     //
                        //     //Login Information / ຂໍ້ມູນການເຂົ້າລະບົບ
                        //     Expanded(
                        //       flex: 1,
                        //       child: BoxAccountSetting(
                        //         boxColor: AppColors.backgroundWhite,
                        //         iconString: "\uf023",
                        //         text: "login_info".tr,
                        //         press: () {
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) =>
                        //                   LoginInformation(),
                        //             ),
                        //           );
                        //         },
                        //       ),
                        //     ),
                        //     SizedBox(width: 10),
                        //     //
                        //     //
                        //     //Job Alert / ແຈ້ງເຕືອນວຽກ
                        //     Expanded(
                        //       flex: 1,
                        //       child: BoxAccountSetting(
                        //         boxColor: AppColors.backgroundWhite,
                        //         iconString: "\uf8fa",
                        //         text: "job_alert".tr,
                        //         press: () {
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) => JobAlert(),
                        //             ),
                        //           );
                        //         },
                        //       ),
                        //     )
                        //   ],
                        // ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
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
                    //Section Activity
                    Column(
                      children: [
                        //
                        //
                        //
                        //
                        //Account Setting
                        Row(
                          children: [
                            Container(
                              width: 5,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.primary600,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "activity".tr,
                              style: bodyTextMaxNormal("NotoSansLaoLoopedBold",
                                  null, FontWeight.bold),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),

                    //
                    //
                    //
                    //
                    //List Activity
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          //
                          //
                          //Save job / ວຽກທີ່ບັນທຶກໄວ້
                          AccountSetting(
                            prefixIconStr: "\uf004",
                            text: "saved_job".tr,
                            amount: "${_savedJobs}",
                            suffixIconStr: "\uf054",
                            press: widget.callBackToMyJobsSavedJob,
                          ),
                          //
                          //
                          //Applied job / ວຽກທີ່ສະໝັກ
                          AccountSetting(
                            prefixIconStr: "\uf1d8",
                            text: "applied_job".tr,
                            amount: "${_appliedJobs}",
                            suffixIconStr: "\uf054",
                            press: () {
                              setState(() {
                                widget
                                    .callBackToMyJobsAppliedJob!("AppliedJob");
                              });
                            },
                          ),
                          //
                          //
                          //Submitted CV / ຢື່ນສະໝັກວຽກ
                          AccountSetting(
                            prefixIconStr: "\uf316",
                            text: "submitted_cv".tr,
                            amount: "${_submitedCV}",
                            suffixIconStr: "\uf054",
                            press: () {},
                          ),
                          //
                          //
                          //Company view profile / ບໍລິສັດເບິ່ງໂປຣໄຟສ
                          AccountSetting(
                            prefixIconStr: "\uf1ad",
                            text: "company_view_profile".tr,
                            amount: "${_epmSavedSeeker}",
                            suffixIconStr: "\uf054",
                            press: () {},
                          ),
                          //
                          //
                          //Member Point / ຄະແນນສະສົມ
                          AccountSetting(
                            prefixIconStr: "\uf2e8",
                            text: "member_point".tr,
                            amount: "${_totalPoint}",
                            suffixIconStr: "\uf054",
                            press: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BoxAccountSetting extends StatefulWidget {
  const BoxAccountSetting({
    Key? key,
    this.iconString,
    this.text,
    this.boxColor,
    this.press,
    this.fontFamilyIcon,
    this.iconColor,
  }) : super(key: key);
  final String? iconString, text, fontFamilyIcon;
  final Color? boxColor, iconColor;
  final Function()? press;

  @override
  State<BoxAccountSetting> createState() => _BoxAccountSettingState();
}

class _BoxAccountSettingState extends State<BoxAccountSetting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: boxDecoration(BorderRadius.circular(10),
          widget.boxColor ?? AppColors.primary200, AppColors.borderBG, null),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.press,
          borderRadius: BorderRadius.circular(10),
          // splashColor: AppColors.backgroundWhite,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(
                //   height: 3,
                // ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "${widget.iconString}",
                      style: fontAwesomeRegular(widget.fontFamilyIcon,
                          IconSize.lIcon, widget.iconColor, null),
                    ),
                    // child: Text(
                    //   "${widget.amount}",
                    //   style: bodyTextMaxMedium(
                    //       "NotoSansLaoLoopedBold", AppColors.primary600, null),
                    // ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Text(
                    "${widget.text}",
                    style: bodyTextMaxSmall(null, null, FontWeight.bold),
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
      this.prefixIconColor,
      this.amount})
      : super(key: key);
  final String? prefixIconStr,
      fontFamilyPrefixIcon,
      text,
      amount,
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.press,
        borderRadius: BorderRadius.circular(10),
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
                      style: fontAwesomeRegular(widget.fontFamilyPrefixIcon,
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
              if (widget.amount != null)
                Text(
                  "${widget.amount}",
                  style: bodyTextMaxNormal(
                      "SatoshiBold", AppColors.iconPrimary, null),
                ),
              SizedBox(
                width: 5,
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
    );
  }
}
