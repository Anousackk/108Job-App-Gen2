// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, prefer_if_null_operators, non_constant_identifier_names, unused_local_variable, unused_field, unnecessary_string_interpolations, prefer_final_fields, unnecessary_null_in_if_null_operators, avoid_print, prefer_adjacent_string_concatenation, unnecessary_this, prefer_interpolation_to_compose_strings, use_build_context_synchronously, deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/provider/profileProvider.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/JobAlert/jobAlert.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/LoginInfo/loginInformation.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/myProfile.dart';
import 'package:app/screen/screenAfterSignIn/myJob/myJob.dart';
import 'package:app/widget/appbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  const Account({Key? key, this.hasInternet}) : super(key: key);

  final hasInternet;

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  dynamic _fileValue;

  File? _image;

  bool _imageLoading = false;

  pickImageGallery(ImageSource source) async {
    final profileProvider = context.read<ProfileProvider>();
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
              await uploadOrUpdateProfileImageSeeker();

              profileProvider.fetchProfileSeeker();

              // setState(() {
              //   profileProvider.imageSrc =
              //       "https://storage.googleapis.com/108-bucket/logos/${_fileValue["name"]}";
              // });
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
      // Android 13+ (API 33+)
      if (sdkInt >= 33) {
        // var statusPhotosAndroid = await Permission.photos.status;

        // print("Platform Android: " + statusPhotosAndroid.toString());

        // if (statusPhotosAndroid.isGranted) {
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
              await uploadOrUpdateProfileImageSeeker();

              profileProvider.fetchProfileSeeker();

              // setState(() {
              //   profileProvider.imageSrc =
              //       "https://storage.googleapis.com/108-bucket/logos/${_fileValue["name"]}";
              // });
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
        // } else if (statusPhotosAndroid.isDenied) {
        //   print("statusPhotosAndroid isDenied");

        //   await Permission.photos.request();
        // } else {
        //   print("statusPhotosAndroid etc...");

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
      //
      //
      // Android < 13 (API ≤ 32)
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
                await uploadOrUpdateProfileImageSeeker();

                profileProvider.fetchProfileSeeker();

                // setState(() {
                //   profileProvider.imageSrc =
                //       "https://storage.googleapis.com/108-bucket/logos/${_fileValue["name"]}";
                // });
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

    print("api uploadOrUpdateProfileImageApiSeeker: " + '${res}');

    if (res != null) {
      // await getProfileSeeker();
      _imageLoading = false;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    context.read<ProfileProvider>().fetchTotalJobSeeker();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBarDefault(
          backgroundColor: AppColors.backgroundWhite,
          textTitle: "account".tr,
          textColor: AppColors.fontDark,
          leadingPress: () {
            Navigator.pop(context);
          },
          leadingIcon: Icon(Icons.arrow_back),
        ),
        body: SafeArea(
          child: Container(
            color: AppColors.dark100.withOpacity(0.7),
            height: double.infinity,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    //
                    //
                    //Section Profile Image
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              SizedBox(height: 70),
                              Container(
                                child: Container(
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

                                      //Profile Name
                                      Text(
                                        "${profileProvider.firstName} ${profileProvider.lastName}",
                                        style: bodyTextMedium(
                                            null, null, FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),

                                      //Currnet Job / Position
                                      Text(
                                        profileProvider.currentJobTitle == ""
                                            ? "- -"
                                            : "${profileProvider.currentJobTitle}",
                                        style: bodyTextNormal(null, null, null),
                                        textAlign: TextAlign.center,
                                      ),

                                      SizedBox(height: 5),
                                      Divider(
                                          color: AppColors.borderGreyOpacity),
                                      SizedBox(height: 5),

                                      //Status employee / percent completed
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
                                                style: bodyTextMaxSmall(null,
                                                    AppColors.dark500, null),
                                              ),
                                              Text(
                                                "${profileProvider.memberLevel}",
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
                                                style: bodyTextMaxSmall(null,
                                                    AppColors.dark500, null),
                                              ),
                                              Text(
                                                "${(profileProvider.percentageUsed * 100).round()}% ",
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
                              ),
                            ],
                          ),
                        ),

                        //Positioned Profile image
                        Positioned(
                          top: 0,
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
                                    pickImageGallery(ImageSource.gallery);
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.center,
                                    children: [
                                      //Profile Image
                                      CircularPercentIndicator(
                                        radius: 70.0,
                                        lineWidth: 4.0,
                                        animation: true,
                                        percent: profileProvider.percentageUsed,
                                        animationDuration: 500,
                                        startAngle: 140.0,
                                        // progressColor: AppColors.primary600,
                                        linearGradient:
                                            AppColors.primaryRingGradient,
                                        backgroundColor: AppColors.primary200,
                                        center: Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            color: AppColors.backgroundWhite,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child:
                                                profileProvider.imageSrc == ""
                                                    ? Image.asset(
                                                        'assets/image/defprofile.jpg',
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(
                                                        "${profileProvider.imageSrc}",
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

                                      //Gallery icon to choose upload image profile
                                      profileProvider.isProfileVerified
                                          ? Positioned(
                                              bottom: 5,
                                              right: 13,
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  "\uf2f7",
                                                  style: fontAwesomeSolid(
                                                      null,
                                                      IconSize.sIcon,
                                                      AppColors.iconPrimary,
                                                      null),
                                                ),
                                              ),
                                            )
                                          : Positioned(
                                              bottom: 5,
                                              right: 8,
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      AppColors.backgroundWhite,
                                                  border: Border.all(
                                                      color:
                                                          AppColors.borderBG),
                                                ),
                                                child: Text(
                                                  "\uf03e",
                                                  style: fontAwesomeRegular(
                                                      null,
                                                      IconSize.xsIcon,
                                                      AppColors.iconPrimary,
                                                      null),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                        )
                      ],
                    ),

                    //Webview Wii Fair
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => WebViewWiiFair(),
                    //       ),
                    //     );
                    //   },
                    //   child: Container(
                    //     width: double.infinity,
                    //     padding: EdgeInsets.all(20),
                    //     decoration: BoxDecoration(
                    //       color: AppColors.teal,
                    //     ),
                    //     child: Text("Wii Fair"),
                    //   ),
                    // ),

                    SizedBox(height: 20),

                    //
                    //
                    //Section Account Setting
                    Column(
                      children: [
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
                            SizedBox(width: 8),
                            Text(
                              "account setting".tr,
                              style: bodyTextMaxNormal("NotoSansLaoLoopedBold",
                                  null, FontWeight.bold),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),

                        //List Account Setting
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.backgroundWhite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
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
                                  );
                                },
                              ),

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

                    SizedBox(height: 20),

                    //
                    //
                    //Section Activity
                    Column(
                      children: [
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

                        SizedBox(height: 10),
                      ],
                    ),

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
                          //Save job / ວຽກທີ່ບັນທຶກໄວ້
                          AccountSetting(
                            prefixIconStr: "\uf004",
                            text: "saved_job".tr,
                            amount: "${profileProvider.savedJobs}",
                            suffixIconStr: "\uf054",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyJobs(
                                    myJobStatus: "SeekerSaveJob",
                                    // hasInternet: true,
                                  ),
                                ),
                              );
                            },
                          ),

                          //Applied job / ວຽກທີ່ສະໝັກ
                          AccountSetting(
                            prefixIconStr: "\uf1d8",
                            text: "applied_job".tr,
                            amount: "${profileProvider.appliedJobs}",
                            suffixIconStr: "\uf054",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyJobs(
                                    myJobStatus: "AppliedJob",
                                    // hasInternet: true,
                                  ),
                                ),
                              );
                            },
                          ),

                          //Submitted CV / ຢື່ນສະໝັກວຽກ
                          AccountSetting(
                            prefixIconStr: "\uf316",
                            text: "submitted_cv".tr,
                            amount: "${profileProvider.submitedCV}",
                            suffixIconStr: "\uf054",
                            press: () {},
                          ),

                          //Company view profile / ບໍລິສັດເບິ່ງໂປຣໄຟສ
                          // AccountSetting(
                          //   prefixIconStr: "\uf1ad",
                          //   text: "company_view_profile".tr,
                          //   amount: "${profileProvider.epmSavedSeeker}",
                          //   suffixIconStr: "\uf054",
                          //   press: () {},
                          // ),

                          //Member Point / ຄະແນນສະສົມ
                          AccountSetting(
                            prefixIconStr: "\uf2e8",
                            text: "member_point".tr,
                            amount: "${profileProvider.totalPoint}",
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
        splashColor: AppColors.white,
        highlightColor: AppColors.primary100,
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
