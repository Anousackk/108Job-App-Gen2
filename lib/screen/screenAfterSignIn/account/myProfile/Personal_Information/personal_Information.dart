// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, unused_local_variable, prefer_if_null_operators, avoid_print, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_typing_uninitialized_variables, unnecessary_new, prefer_is_empty, file_names, prefer_adjacent_string_concatenation, use_build_context_synchronously, prefer_interpolation_to_compose_strings, deprecated_member_use

import 'dart:io';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/cupertinoDatePicker.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/provider/localSharePrefsProvider.dart';
import 'package:app/provider/profileProvider.dart';
import 'package:app/provider/reuseTypeProvider.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:app/widget/listSingleSelectedAlertDialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation(
      {Key? key,
      this.id,
      this.profile,
      this.pressButtonLeft,
      this.onSaveSuccess})
      : super(key: key);
  final String? id;
  final profile;
  final Function()? pressButtonLeft, onSaveSuccess;

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _porfessionalSummaryController =
      TextEditingController();
  FocusScopeNode _currentFocus = FocusScopeNode();
  FocusNode focusNode = FocusNode();

  //
  //Get list items all
  // List _listProvince = [];
  // List _listDistrict = [];

  // List _listNationality = [];
  // List _listCountry = [];
  // List _listGender = [];
  // List _listMaritalStatus = [];

  //
  //Selected list item(ສະເພາະເຂົ້າ Database)
  String? _id;
  String _name = "";
  String _lastName = "";
  dynamic _dateOfBirth;
  String _selectedGender = "";
  String _selectedMaritalStatus = "";
  // String _selectedNationality = "";
  // String _selectedCountry = "";
  String _selectedProvince = "";
  String _selectedDistrict = "";
  String _imageSrc = "";
  String _memberLevel = "";
  String _professionalSummary = "";

  //
  //value display(ສະເພາະສະແດງ)
  // String _nationalityName = "";
  // String _countryName = "";
  String _provinceName = "";
  String _districtName = "";
  String _genderName = "";
  String _maritalStatusName = "";
  String _localeLanguageApi = "";

  dynamic _fileValue;

  File? _image;

  bool _isValidateValue = false;
  bool _imageLoading = false;
  DateTime _dateTimeNow = DateTime.now();

  setValueGetById() {
    final profileProvider = context.read<ProfileProvider>();

    setState(() {
      dynamic i = widget.profile;
      _porfessionalSummaryController.text = _professionalSummary;

      _name = i['firstName'];
      _lastName = i['lastName'];
      _dateOfBirth = i['dateOfBirth'];
      _memberLevel = i['memberLevel'];
      _professionalSummary = i['professionalSummary'];

      if (_dateOfBirth != null) {
        //
        //Convert String to DateTime ປ່ຽນຈາກ "Jan-13-1999" ເພື່ອເຊັດເປັນ 1999-01-13 00:00:00.000
        // DateTime tempDate = new DateFormat("MMM-dd-yyyy").parse(_dateOfBirth);
        // _dateOfBirth = tempDate;

        //pars ISO to Flutter DateTime
        parsDateTime(value: '', currentFormat: '', desiredFormat: '');
        DateTime parsDateOfBirth = parsDateTime(
          value: _dateOfBirth,
          currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
          desiredFormat: "yyyy-MM-dd HH:mm:ss",
        );

        _dateOfBirth = parsDateOfBirth;
      }
      // if (i["file"] != "") {
      //   _imageSrc = !i["file"].containsKey("src") || i["file"]["src"] == null
      //       ? ""
      //       : i["file"]["src"];
      // }

      _imageSrc = (i!['file'] is Map && i!['file']["src"] != null)
          ? i!['file']["src"]
          : "";

      _selectedGender = i['genderId'] != null ? i['genderId']['_id'] : "";
      _genderName = i['genderId'] != null ? i['genderId']['name'] : "";
      _selectedMaritalStatus =
          i['maritalStatusId'] != null ? i['maritalStatusId']['_id'] : "";
      _maritalStatusName =
          i['maritalStatusId'] != null ? i['maritalStatusId']['name'] : "";
      // _selectedNationality =
      //     i['nationalityId'] != null ? i['nationalityId']['_id'] : "";
      // _nationalityName =
      //     i['nationalityId'] != null ? i['nationalityId']['name'] : "";
      // _selectedCountry =
      //     i['currentResidenceId'] != null ? i['currentResidenceId']['_id'] : "";
      // _countryName = i['currentResidenceId'] != null
      //     ? i['currentResidenceId']['name']
      //     : "";
      _selectedDistrict = i['districtId'] != null ? i['districtId']['_id'] : "";
      _districtName = i['districtId'] != null ? i['districtId']['name'] : "";
      _selectedProvince =
          i['districtId'] == null || !i['districtId'].containsKey('provinceId')
              ? ""
              : i['districtId']['provinceId']['_id'];
      _provinceName =
          i['districtId'] == null || !i['districtId'].containsKey('provinceId')
              ? ""
              : i['districtId']['provinceId']['name'];

      _nameController.text = _name;
      _lastNameController.text = _lastName;
    });

    //
    // ຖ້າມີ ProvinceId and DistrictId ແລ້ວ map ເອົາ ProvincsAndDistricts ວ່າ _province(_id) ກົງກັບ _provinces
    if (_selectedDistrict != "" &&
        _selectedProvince != "" &&
        profileProvider.listProvince.isNotEmpty) {
      var mapDistrict = profileProvider.listProvince
          .firstWhere((d) => d['_id'] == _selectedProvince);

      profileProvider.listDistrict = mapDistrict['districts'];
    }
  }

  checkByIdDisplayFormUpdate() {
    //Check by _id ເພື່ອເອົາຂໍ້ມູນມາອັບເດດ
    _id = widget.id ?? "";
    if (_id != null && _id != "") {
      print("seekerId + ${_id}");

      setValueGetById();
    }

    _porfessionalSummaryController.text = _professionalSummary;
  }

  pickImageGallery(ImageSource source) async {
    // var statusPhotos = await Permission.photos.status;
    // var statusMediaLibrary = await Permission.mediaLibrary.status;
    //
    //
    // Pick image device IOS
    if (Platform.isIOS) {
      var statusPhotosIOS = await Permission.photos.status;
      print("Platform IOS: " + statusPhotosIOS.toString());

      if (statusPhotosIOS.isGranted) {
        print("photos isGranted");
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

              setState(() {
                _imageSrc =
                    "https://storage.googleapis.com/108-bucket/logos/${_fileValue["name"]}";
              });
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
                await uploadOrUpdateProfileImageSeeker();

                setState(() {
                  _imageSrc =
                      "https://storage.googleapis.com/108-bucket/logos/${_fileValue["name"]}";
                });
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
                await uploadOrUpdateProfileImageSeeker();

                setState(() {
                  _imageSrc =
                      "https://storage.googleapis.com/108-bucket/logos/${_fileValue["name"]}";
                });
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

      // if (statusMediaLibrary.isDenied) {
      //   print("mediaLibrary isDenied");
      //   await Permission.photos.request();
      // }
      // if (statusMediaLibrary.isPermanentlyDenied) {
      //   print("mediaLibrary isPermanentlyDenied");

      //   await openAppSettings();
      // }
    }
  }

  uploadOrUpdateProfileImageSeeker() async {
    print("api upload profile image working personal infomation");
    var res = await postData(
        uploadOrUpdateProfileImageApiSeeker, {"file": _fileValue});
    print("api uploadOrUpdateProfileImageApiSeeker: " + '${res}');

    if (res != null) {
      // await getProfileSeeker();
      _imageLoading = false;
    }

    setState(() {});
  }

  pressAddPersonalInformation() async {
    final profileProvider = context.read<ProfileProvider>();

    // Display AlertDialog Loading First
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    final res = await profileProvider.addPersonalInformation(
      _name,
      _lastName,
      _dateOfBirth.toString(),
      _selectedGender,
      _selectedMaritalStatus,
      //  _selectedNationality,
      //  _selectedCountry,
      _selectedDistrict,
      _professionalSummary,
      profileProvider.statusEventUpdateProfile,
    );

    final statusCode = res?["statusCode"];

    if (!context.mounted) return;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    print("personal information: " + "${res}");

    if (statusCode == 200 || statusCode == 201) {
      //After sucess work api fetchProfileSeeker
      await profileProvider.fetchProfileSeeker();
      // Call parent callback
      if (widget.onSaveSuccess != null) {
        widget.onSaveSuccess!();
      }
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogErrorWithoutBtn(
            title: "incorrect".tr,
            text: "incorrect".tr,
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // Should use setState() or markNeedsBuild() called during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkByIdDisplayFormUpdate(); // After build done. Then work this function
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final reuseTypeProvider = context.watch<ReuseTypeProvider>();

    return GestureDetector(
      onTap: () {
        _currentFocus = FocusScope.of(context);
        if (!_currentFocus.hasPrimaryFocus) {
          _currentFocus.unfocus();
        }
      },
      child: Container(
        // height: double.infinity,
        // width: double.infinity,
        color: AppColors.backgroundWhite,
        padding: EdgeInsets.symmetric(horizontal: 20),

        //
        //
        //Form Personal Information
        child: Form(
          key: formkey,
          child: Column(
            children: [
              //
              //
              //Section
              //Profile Image
              Container(
                width: double.infinity,
                color: _imageSrc == "" && _isValidateValue == true
                    ? AppColors.danger200
                    : AppColors.backgroundWhite,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: AppColors.white,
                    highlightColor: AppColors.primary100,
                    //Press choose image upload profile image
                    onTap: () async {
                      pickImageGallery(ImageSource.gallery);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                //Avatar image
                                Column(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        //Image loading
                                        _imageLoading
                                            ? Container(
                                                width: 90,
                                                height: 90,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      AppColors.backgroundWhite,
                                                ),
                                                child: Center(
                                                  child: Text("uploading".tr),
                                                ),
                                              )

                                            //ຫຼັງຈາກ Image loading ແລ້ວ
                                            : Container(
                                                width: 90,
                                                height: 90,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: _imageSrc == ""
                                                      ? Image.asset(
                                                          'assets/image/defprofile.jpg',
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.network(
                                                          "${_imageSrc}",
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Image.asset(
                                                              'assets/image/defprofile.jpg',
                                                              fit: BoxFit.cover,
                                                            ); // Display an error message
                                                          },
                                                        ),
                                                ),
                                              ),
                                        //Gallery image icon at the bottom right corner
                                        Positioned(
                                          bottom: 0,
                                          right: -5,
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              height: 25,
                                              width: 25,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    AppColors.backgroundWhite,
                                              ),
                                              child: Text(
                                                "\uf021",
                                                style: fontAwesomeRegular(
                                                    null,
                                                    10,
                                                    AppColors.dark500,
                                                    null),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_imageSrc == "" &&
                                        _isValidateValue == true)
                                      Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                          "required".tr,
                                          style: bodyTextSmall(
                                              null, AppColors.fontDanger, null),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(width: 10),

                                //Column text right avatar image
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "profile_image".tr,
                                        style: bodyTextMaxNormal(
                                            "NotoSansLaoLoopedBold",
                                            null,
                                            FontWeight.bold),
                                      ),
                                      Text(
                                        "profile_image_size".tr,
                                        style: bodyTextSmall(null, null, null),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              //
              //
              //Section
              //Content Personal Information
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      "first name".tr,
                      style: bodyTextNormal(null, null, FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                    // TextField Name
                    SimpleTextFieldWithIconRight(
                      textController: _nameController,
                      changed: (value) {
                        setState(() {
                          _name = value;
                        });
                      },
                      inputColor: AppColors.inputWhite,
                      hintText: "enter your".tr + " " + "first name".tr,
                      hintTextFontWeight: FontWeight.bold,
                      suffixIcon: Icon(
                        Icons.keyboard,
                      ),
                      suffixIconColor: AppColors.iconGrayOpacity,
                    ),
                    SizedBox(height: 20),

                    // LastName
                    Text(
                      "last name".tr,
                      style: bodyTextNormal(null, null, FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                    // TextField Last name
                    SimpleTextFieldWithIconRight(
                      textController: _lastNameController,
                      changed: (value) {
                        setState(() {
                          _lastName = value;
                        });
                      },
                      inputColor: AppColors.inputWhite,
                      hintText: "enter your".tr + " " + "last name".tr,
                      hintTextFontWeight: FontWeight.bold,
                      suffixIcon: Icon(
                        Icons.keyboard,
                      ),
                      suffixIconColor: AppColors.iconGrayOpacity,
                    ),
                    SizedBox(height: 20),

                    //Date of birth
                    Text(
                      "date of birth".tr,
                      style: bodyTextNormal(null, null, FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                    //Date of birth select date
                    BoxDecorationInput(
                      mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                      colorInput: AppColors.backgroundWhite,
                      colorBorder:
                          _isValidateValue == true && _dateOfBirth == null
                              ? AppColors.borderDanger
                              : AppColors.borderSecondary,
                      paddingFaIcon: EdgeInsets.symmetric(horizontal: 8),
                      fontWeight: null,
                      widgetIconActive: FaIcon(
                        FontAwesomeIcons.calendar,
                        color: AppColors.iconGrayOpacity,
                        size: IconSize.sIcon,
                      ),
                      press: () {
                        FocusScope.of(context).requestFocus(focusNode);

                        // format date.now() ຈາກ 2022-10-30 19:44:31.180 ເປັນ 2022-10-30 00:00:00.000
                        var formatDateTimeNow = DateFormat("yyyy-MM-dd")
                            .parse(_dateTimeNow.toString());
                        setState(() {
                          _dateOfBirth == null
                              ? _dateOfBirth = formatDateTimeNow
                              : _dateOfBirth;

                          print(_dateOfBirth);
                        });

                        showDialogDateTime(
                          context,
                          Text(
                            "date of birth".tr,
                            style: bodyTextNormal(null, null, FontWeight.bold),
                          ),
                          CupertinoDatePicker(
                            initialDateTime: _dateOfBirth == null
                                ? formatDateTimeNow
                                : _dateOfBirth,
                            maximumDate: formatDateTimeNow,
                            mode: CupertinoDatePickerMode.date,
                            dateOrder: DatePickerDateOrder.dmy,
                            use24hFormat: true,
                            onDateTimeChanged: (DateTime newDate) {
                              setState(
                                () => _dateOfBirth = newDate,
                              );
                            },
                          ),
                        );
                      },
                      text: _dateOfBirth == null
                          ? "date of birth".tr
                          : "${_dateOfBirth?.day}-${_dateOfBirth?.month}-${_dateOfBirth?.year}",
                      colorText: _dateOfBirth == null
                          ? AppColors.fontGreyOpacity
                          : AppColors.fontDark,
                      validateText:
                          _isValidateValue == true && _dateOfBirth == null
                              ? Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                    left: 15,
                                    top: 5,
                                  ),
                                  child: Text(
                                    "required",
                                    style: bodyTextSmall(
                                        null, AppColors.fontDanger, null),
                                  ),
                                )
                              : Container(),
                    ),
                    SizedBox(height: 20),

                    //Gender
                    Text(
                      "gender".tr,
                      style: bodyTextNormal(null, null, FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                    //Gender box decoration select
                    BoxDecorationInput(
                      mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                      colorInput: AppColors.backgroundWhite,
                      colorBorder:
                          _selectedGender == "" && _isValidateValue == true
                              ? AppColors.borderDanger
                              : AppColors.borderSecondary,
                      paddingFaIcon: EdgeInsets.symmetric(horizontal: 8),
                      fontWeight: null,
                      widgetIconActive: FaIcon(
                        FontAwesomeIcons.caretDown,
                        color: AppColors.iconGrayOpacity,
                        size: IconSize.sIcon,
                      ),
                      press: () async {
                        FocusScope.of(context).requestFocus(focusNode);

                        var result = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return ListSingleSelectedAlertDialog(
                                title: "gender".tr,
                                listItems: reuseTypeProvider.listGender,
                                selectedListItem: _selectedGender,
                              );
                            }).then(
                          (value) {
                            // print(_currentFocus);
                            //value = "_id"
                            //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                            if (value != "") {
                              //
                              //ເອົາ _listGender ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                              dynamic findValue = reuseTypeProvider.listGender
                                  .firstWhere((i) => i["_id"] == value);

                              setState(() {
                                _selectedGender = findValue['_id'];
                                _genderName = findValue['name'];
                              });

                              print(_genderName);
                            }
                          },
                        );
                      },
                      text: _selectedGender != ""
                          ? "${_genderName}"
                          : "select".tr + " " + "gender".tr,
                      colorText: _selectedGender == ""
                          ? AppColors.fontGreyOpacity
                          : AppColors.fontDark,
                      validateText:
                          _isValidateValue == true && _selectedGender == ""
                              ? Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                    left: 15,
                                    top: 5,
                                  ),
                                  child: Text(
                                    "required".tr,
                                    style: bodyTextSmall(
                                        null, AppColors.fontDanger, null),
                                  ),
                                )
                              : Container(),
                    ),
                    SizedBox(height: 20),

                    //Marital Status
                    Text(
                      "marital status".tr,
                      style: bodyTextNormal(null, null, FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                    //Marital Status box decoration select
                    BoxDecorationInput(
                      mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                      colorInput: AppColors.backgroundWhite,
                      colorBorder: _selectedMaritalStatus == "" &&
                              _isValidateValue == true
                          ? AppColors.borderDanger
                          : AppColors.borderSecondary,
                      paddingFaIcon: EdgeInsets.symmetric(horizontal: 8),
                      fontWeight: null,
                      widgetIconActive: FaIcon(
                        FontAwesomeIcons.caretDown,
                        color: AppColors.iconGrayOpacity,
                        size: IconSize.sIcon,
                      ),
                      press: () async {
                        FocusScope.of(context).requestFocus(focusNode);

                        var result = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return ListSingleSelectedAlertDialog(
                                title: "marital status".tr,
                                listItems: reuseTypeProvider.listMaritalStatus,
                                selectedListItem: _selectedMaritalStatus,
                              );
                            }).then(
                          (value) {
                            //value = "_id"
                            //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                            if (value != "") {
                              //
                              //ເອົາ _listMaritalStatus ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                              dynamic findValue = reuseTypeProvider
                                  .listMaritalStatus
                                  .firstWhere((i) => i["_id"] == value);

                              setState(() {
                                _selectedMaritalStatus = findValue['_id'];
                                _maritalStatusName = findValue['name'];
                              });

                              print(_maritalStatusName);
                            }
                          },
                        );
                      },
                      text: _selectedMaritalStatus != ""
                          ? "${_maritalStatusName}"
                          : "select".tr + " " + "marital status".tr,
                      colorText: _selectedMaritalStatus == ""
                          ? AppColors.fontGreyOpacity
                          : AppColors.fontDark,
                      validateText: _isValidateValue == true &&
                              _selectedMaritalStatus == ""
                          ? Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                left: 15,
                                top: 5,
                              ),
                              child: Text(
                                "required".tr,
                                style: bodyTextSmall(
                                    null, AppColors.fontDanger, null),
                              ),
                            )
                          : Container(),
                    ),
                    SizedBox(height: 20),

                    // //Nationality
                    // Text(
                    //   "nationality".tr,
                    //   style: bodyTextNormal(null, null, FontWeight.bold),
                    // ),
                    // SizedBox(height: 5),
                    // //Nationality box decoration select
                    // BoxDecorationInput(
                    //   mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                    //   colorInput: AppColors.backgroundWhite,
                    //   colorBorder:
                    //       _selectedNationality == "" && _isValidateValue == true
                    //           ? AppColors.borderDanger
                    //           : AppColors.borderSecondary,
                    //   paddingFaIcon: EdgeInsets.symmetric(horizontal: 8),
                    //   fontWeight: null,
                    //   widgetIconActive: FaIcon(
                    //     FontAwesomeIcons.caretDown,
                    //     color: AppColors.iconGrayOpacity,
                    //     size: IconSize.sIcon,
                    //   ),
                    //   press: () async {
                    //     FocusScope.of(context).requestFocus(focusNode);
                    //     var result = await showDialog(
                    //         barrierDismissible: false,
                    //         context: context,
                    //         builder: (context) {
                    //           return ListSingleSelectedAlertDialog(
                    //             title: "nationality".tr,
                    //             listItems: reuseTypeProvider.listNationality,
                    //             selectedListItem: _selectedNationality,
                    //           );
                    //         }).then(
                    //       (value) {
                    //         //value = "_id"
                    //         //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                    //         if (value != "") {
                    //           //
                    //           //ເອົາ _listNationality ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                    //           dynamic findValue = reuseTypeProvider
                    //               .listNationality
                    //               .firstWhere((i) => i["_id"] == value);
                    //           setState(() {
                    //             _selectedNationality = findValue['_id'];
                    //             _nationalityName = findValue['name'];
                    //           });
                    //           print(_nationalityName);
                    //         }
                    //       },
                    //     );
                    //   },
                    //   text: _selectedNationality != ""
                    //       ? "${_nationalityName}"
                    //       : "select".tr + " " + "nationality".tr,
                    //   colorText: _selectedNationality == ""
                    //       ? AppColors.fontGreyOpacity
                    //       : AppColors.fontDark,
                    //   validateText:
                    //       _isValidateValue == true && _selectedNationality == ""
                    //           ? Container(
                    //               width: double.infinity,
                    //               padding: EdgeInsets.only(
                    //                 left: 15,
                    //                 top: 5,
                    //               ),
                    //               child: Text(
                    //                 "required".tr,
                    //                 style: bodyTextSmall(
                    //                     null, AppColors.fontDanger, null),
                    //               ),
                    //             )
                    //           : Container(),
                    // ),
                    // SizedBox(height: 20),

                    // //Country
                    // Text(
                    //   "country".tr,
                    //   style: bodyTextNormal(null, null, FontWeight.bold),
                    // ),
                    // SizedBox(height: 5),
                    // //Country box decoration select
                    // BoxDecorationInput(
                    //   mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                    //   colorInput: AppColors.backgroundWhite,
                    //   colorBorder:
                    //       _selectedCountry == "" && _isValidateValue == true
                    //           ? AppColors.borderDanger
                    //           : AppColors.borderSecondary,
                    //   paddingFaIcon: EdgeInsets.symmetric(horizontal: 8),
                    //   fontWeight: null,
                    //   widgetIconActive: FaIcon(
                    //     FontAwesomeIcons.caretDown,
                    //     color: AppColors.iconGrayOpacity,
                    //     size: IconSize.sIcon,
                    //   ),
                    //   press: () async {
                    //     FocusScope.of(context).requestFocus(focusNode);
                    //     var result = await showDialog(
                    //         barrierDismissible: false,
                    //         context: context,
                    //         builder: (context) {
                    //           return ListSingleSelectedAlertDialog(
                    //             title: "country".tr,
                    //             listItems: reuseTypeProvider.listCountry,
                    //             selectedListItem: _selectedCountry,
                    //           );
                    //         }).then(
                    //       (value) {
                    //         //value = "_id"
                    //         //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                    //         if (value != "") {
                    //           //
                    //           //ເອົາ _listCountry ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                    //           dynamic findValue = reuseTypeProvider.listCountry
                    //               .firstWhere((i) => i["_id"] == value);
                    //           setState(() {
                    //             _selectedCountry = findValue['_id'];
                    //             _countryName = findValue['name'];
                    //           });
                    //           print(_countryName);
                    //         }
                    //       },
                    //     );
                    //   },
                    //   text: _selectedCountry != ""
                    //       ? "${_countryName}"
                    //       : "select".tr + " " + "country".tr,
                    //   colorText: _selectedCountry == ""
                    //       ? AppColors.fontGreyOpacity
                    //       : AppColors.fontDark,
                    //   validateText:
                    //       _isValidateValue == true && _selectedCountry == ""
                    //           ? Container(
                    //               width: double.infinity,
                    //               padding: EdgeInsets.only(
                    //                 left: 15,
                    //                 top: 5,
                    //               ),
                    //               child: Text(
                    //                 "required".tr,
                    //                 style: bodyTextSmall(
                    //                     null, AppColors.fontDanger, null),
                    //               ),
                    //             )
                    //           : Container(),
                    // ),
                    // SizedBox(height: 20),

                    //Province
                    Text(
                      "province".tr,
                      style: bodyTextNormal(null, null, FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                    //Province box decoration select
                    BoxDecorationInput(
                      mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                      colorInput: AppColors.backgroundWhite,
                      colorBorder:
                          _selectedProvince == "" && _isValidateValue == true
                              ? AppColors.borderDanger
                              : AppColors.borderSecondary,
                      paddingFaIcon: EdgeInsets.symmetric(horizontal: 8),
                      fontWeight: null,
                      widgetIconActive: FaIcon(
                        FontAwesomeIcons.caretDown,
                        color: AppColors.iconGrayOpacity,
                        size: IconSize.sIcon,
                      ),
                      press: () async {
                        FocusScope.of(context).requestFocus(focusNode);

                        var result = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return ListSingleSelectedAlertDialog(
                                title: "province".tr,
                                listItems: profileProvider.listProvince,
                                selectedListItem: _selectedProvince,
                              );
                            }).then(
                          (value) {
                            //value = "_id"
                            //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                            if (value != "") {
                              //
                              //ເອົາ _listProvince ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                              dynamic findValue = profileProvider.listProvince
                                  .firstWhere((i) => i["_id"] == value);

                              setState(() {
                                _selectedProvince = findValue['_id'];
                                _provinceName = findValue['name'];
                              });
                              print(_provinceName);

                              //
                              //map ເອົາ Provincs And Districts ທີ່ເຮົາເລືອກ _province(_id) ກົງກັບ _provinces
                              //add ໂຕທີ່ເຮົາ map ໃສ່ _districts
                              var mapDistrict = profileProvider.listProvince
                                  .firstWhere(
                                      (d) => d['_id'] == _selectedProvince);

                              //
                              //add ໂຕທີ່ເຮົາ map ໃສ່ _districts
                              profileProvider.listDistrict =
                                  mapDistrict['districts'];

                              if (_selectedDistrict != "" &&
                                  _selectedProvince != "") {
                                profileProvider.listDistrict = [];
                                _selectedDistrict = "";
                                var mapDistrict = profileProvider.listProvince
                                    .firstWhere(
                                        (d) => d['_id'] == _selectedProvince);
                                profileProvider.listDistrict =
                                    mapDistrict['districts'];
                              }
                            }
                          },
                        );
                      },
                      text: _selectedProvince != ""
                          ? "${_provinceName}"
                          : "select".tr + " " + "province".tr,
                      colorText: _selectedProvince == ""
                          ? AppColors.fontGreyOpacity
                          : AppColors.fontDark,
                      validateText:
                          _isValidateValue == true && _selectedProvince == ""
                              ? Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                    left: 15,
                                    top: 5,
                                  ),
                                  child: Text(
                                    "required".tr,
                                    style: bodyTextSmall(
                                        null, AppColors.fontDanger, null),
                                  ),
                                )
                              : Container(),
                    ),
                    SizedBox(height: 20),

                    //District
                    Text(
                      "district".tr,
                      style: bodyTextNormal(null, null, FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                    //District box decoration select
                    BoxDecorationInput(
                      mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                      colorInput: AppColors.backgroundWhite,
                      colorBorder:
                          _selectedDistrict == "" && _isValidateValue == true
                              ? AppColors.borderDanger
                              : AppColors.borderSecondary,
                      paddingFaIcon: EdgeInsets.symmetric(horizontal: 8),
                      fontWeight: null,
                      widgetIconActive: FaIcon(
                        FontAwesomeIcons.caretDown,
                        color: AppColors.iconGrayOpacity,
                        size: IconSize.sIcon,
                      ),
                      press: () async {
                        FocusScope.of(context).requestFocus(focusNode);

                        var result = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return ListSingleSelectedAlertDialog(
                                title: "district".tr,
                                listItems: profileProvider.listDistrict,
                                selectedListItem: _selectedDistrict,
                              );
                            }).then(
                          (value) {
                            //value = "_id"
                            //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                            if (value != "") {
                              //
                              //ເອົາ _listDistrict ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                              dynamic findValue = profileProvider.listDistrict
                                  .firstWhere((i) => i["_id"] == value);

                              setState(() {
                                _selectedDistrict = findValue['_id'];
                                _districtName = findValue['name'];
                              });

                              print(_districtName);
                            }
                          },
                        );
                      },
                      text: _selectedDistrict != ""
                          ? "${_districtName}"
                          : "select".tr + " " + "district".tr,
                      colorText: _selectedDistrict == ""
                          ? AppColors.fontGreyOpacity
                          : AppColors.fontDark,
                      validateText:
                          _isValidateValue == true && _selectedDistrict == ""
                              ? Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                    left: 15,
                                    top: 5,
                                  ),
                                  child: Text(
                                    "required".tr,
                                    style: bodyTextSmall(
                                        null, AppColors.fontDanger, null),
                                  ),
                                )
                              : Container(),
                    ),
                    SizedBox(height: 20),

                    // Professional Summary
                    Text(
                      "professional_summary".tr,
                      style: bodyTextNormal(null, null, FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                    //Professional Summary
                    SizedBox(
                      // height: 300,
                      child: TextFormField(
                        controller: _porfessionalSummaryController,
                        onChanged: (value) {
                          setState(() {
                            _professionalSummary = value;
                          });
                        },
                        style: TextStyle(color: AppColors.fontDark),
                        maxLines: 15,
                        minLines: null,
                        // expands: true,
                        toolbarOptions: ToolbarOptions(
                          paste: true,
                          cut: true,
                          copy: true,
                          selectAll: true,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          hintText: "professional_summary".tr,
                          fillColor: AppColors.inputLight,
                          enabledBorder: enableOutlineBorder(
                            AppColors.borderSecondary,
                          ),
                          focusedBorder: focusOutlineBorder(
                            AppColors.borderPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(color: AppColors.borderGreyOpacity, thickness: 1),

              //
              //
              //Section Button Save And Next
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.pressButtonLeft,
                    child: Container(
                      color: AppColors.backgroundWhite,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Skip for now",
                        style: bodyTextNormal(
                            null, AppColors.fontGreyOpacity, null),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Button(
                        text: "save_and_next".tr,
                        textFontWeight: FontWeight.bold,
                        press: () {
                          FocusScope.of(context).requestFocus(focusNode);
                          if (formkey.currentState!.validate()) {
                            print("for check formkey.currentState!.validate()");

                            if (_dateOfBirth == null ||
                                _selectedProvince == "" ||
                                _selectedDistrict == "" ||
                                _selectedGender == "" ||
                                _selectedMaritalStatus == "" ||
                                _imageSrc == "") {
                              setState(() {
                                _isValidateValue = true;
                              });
                            } else {
                              pressAddPersonalInformation();
                            }
                          } else {
                            print("invalid validate form");
                            setState(() {
                              _isValidateValue = true;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
