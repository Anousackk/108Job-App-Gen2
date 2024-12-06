// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, unused_field, avoid_print, unused_local_variable, prefer_typing_uninitialized_variables, prefer_final_fields, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, prefer_is_empty, unused_element, unnecessary_null_in_if_null_operators, prefer_if_null_operators, prefer_adjacent_string_concatenation, unnecessary_null_comparison, avoid_init_to_null, file_names

import 'dart:io';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/botttomModal.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Education/education.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Education/fetchEducation.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Language/fetchLanguage.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Language/language.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Personal_Information/personal_Information.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Skill/fetchSkill.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Skill/skill.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/UploadCV/uploadCV.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Widget/BoxPrefixSuffix.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Widget/avatarImage.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/WorkHistory/fetchWorkHistory.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/WorkHistory/workHistory.dart';
import 'package:app/screen/ScreenAfterSignIn/account/MyProfile/ProfileSetting/profileSetting.dart';
import 'package:app/screen/ScreenAfterSignIn/account/MyProfile/WorkPreference/workPreferences.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/boxDecDottedBorderProfileDetail.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile>
    with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();

  //
  //Upload File
  dynamic _fileValue;
  String _strFilePath = "";

  //
  //Profile Seeker
  String _firstName = "";
  String _lastName = "";
  String _imageSrc = "";

  dynamic _seekerProfile;
  dynamic _reviewStatus;
  dynamic _workPreferences;
  dynamic _cv;
  dynamic _personalInformationStatus;
  dynamic _workPreferenceStatus;
  dynamic _resumeStatus;
  dynamic _educationStatus;
  dynamic _workHistoryStatus;
  dynamic _languageStatus;
  dynamic _skillStatus;
  dynamic _avatarObj;

  List _education = [];
  List _workHistory = [];
  List _languageSkill = [];
  List _skills = [];
  List _avatars = [];

  String _memberLevel = "";
  String _status = "";
  String _currentJobTitle = "";
  String _statusUploadImage = "";
  String _selectedAvatarImage = "";
  String _avatarScr = "";

  File? _image;

  bool _isLoading = true;
  bool _imageLoading = false;
  bool _isSearchable = false;
  bool _isReview = false;

  Future pickImageGallery(ImageSource source) async {
    var statusPhotos = await Permission.photos.status;
    var statusMediaLibrary = await Permission.mediaLibrary.status;

    if (Platform.isIOS) {
      print("Platform isIOS");
      print(statusPhotos);

      if (statusPhotos.isLimited) {
        print("photos isLimited");

        await openAppSettings();
      }
      if (statusPhotos.isGranted) {
        print("photos isGranted");

        final ImagePicker _picker = ImagePicker();
        final XFile? image = await _picker.pickImage(source: source);

        if (image == null) return;
        File fileTemp = File(image.path);
        setState(() {
          _image = fileTemp;
        });

        var strImage = image.path;

        print(strImage);
        _imageLoading = true;

        if (_image != null) {
          //
          //api upload profile seeker
          var value = await upLoadFile(strImage, uploadProfileApiSeeker);
          if (mounted) {
            setState(() {
              _fileValue = value['file'];
              print(_fileValue);

              if (_fileValue != null || _fileValue != "") {
                //
                //api upload or update profile image seeker
                uploadOrUpdateProfileImageSeeker();
                _imageLoading = false;
                _statusUploadImage = "Success";
              }
            });
          }
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
              title: 'Allow Access Photos',
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
    } else if (Platform.isAndroid) {
      print("Platform isAndroid");
      if (statusMediaLibrary.isGranted) {
        print("mediaLibrary isGranted");
        final ImagePicker _picker = ImagePicker();
        final XFile? image = await _picker.pickImage(source: source);

        if (image == null) return;
        File fileTemp = File(image.path);
        setState(() {
          _image = fileTemp;
        });

        var strImage = image.path;

        print(strImage);

        _imageLoading = true;

        if (_image != null) {
          //
          //api upload profile seeker
          var value = await upLoadFile(strImage, uploadProfileApiSeeker);
          setState(() {
            _fileValue = value['file'];
            print(_fileValue);

            if (_fileValue != null || _fileValue != "") {
              //
              //api upload or update profile image seeker
              uploadOrUpdateProfileImageSeeker();
              _imageLoading = false;
              _statusUploadImage = "Success";
            }
          });
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

  uploadOrUpdateProfileImageSeeker() async {
    var res = await postData(
        uploadOrUpdateProfileImageApiSeeker, {"file": _fileValue});
    print(res);

    if (res != null) {
      getProfileSeeker();
    }
  }

  onGoBack(dynamic value) {
    print("onGoBack is working");
    getProfileSeeker();
    if (mounted) {
      setState(() {});
    }
  }

  getProfileSeeker() async {
    var res = await fetchData(getProfileSeekerApi);
    _seekerProfile = await res["profile"];
    _reviewStatus = await res["reviewStatus"];
    _firstName = _seekerProfile["firstName"];
    _lastName = _seekerProfile["lastName"];
    _memberLevel = _seekerProfile["memberLevel"];
    _status = _seekerProfile["status"];
    _isSearchable = _seekerProfile["isSearchable"] as bool;
    _avatarObj = _seekerProfile["avatar"];
    if (_avatarObj != null) {
      _selectedAvatarImage = _avatarObj["_id"];
      _avatarScr = _avatarObj["src"];
    }
    if (_seekerProfile["file"] != "") {
      _imageSrc = !_seekerProfile["file"].containsKey("src") ||
              _seekerProfile["file"]["src"] == null
          ? ""
          : _seekerProfile["file"]["src"];
    }

    _personalInformationStatus =
        _reviewStatus["personalInformationStatus"] == null
            ? null
            : _reviewStatus["personalInformationStatus"] as bool;
    _workPreferenceStatus = _reviewStatus["workPreferenceStatus"] == null
        ? null
        : _reviewStatus["workPreferenceStatus"] as bool;
    _resumeStatus = _reviewStatus["resumeStatus"] == null
        ? null
        : _reviewStatus["resumeStatus"] as bool;
    _educationStatus = _reviewStatus["educationStatus"] == null
        ? null
        : _reviewStatus["educationStatus"] as bool;
    _workHistoryStatus = _reviewStatus["workHistoryStatus"] == null
        ? null
        : _reviewStatus["workHistoryStatus"] as bool;
    _languageStatus = _reviewStatus["languageStatus"] == null
        ? null
        : _reviewStatus["languageStatus"] as bool;
    _skillStatus = _reviewStatus["skillStatus"] == null
        ? null
        : _reviewStatus["skillStatus"] as bool;

    _workPreferences = res["workPreferences"] ?? null;
    _cv = res["cv"] ?? null;
    _education = res["education"] ?? [];
    _workHistory = res["workHistory"] ?? [];
    _languageSkill = res["languageSkill"] ?? [];
    _skills = res["skills"] ?? [];
    _isReview = res["isReview"] as bool;
    if (_workPreferences != null) {
      _currentJobTitle = _workPreferences["currentJobTitle"];
    }
    if (res != null) {
      _isLoading = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  fetchAvatar() async {
    print("Fetch avatar is working");
    var res = await fetchData(getAvatarSeekerApi);
    _avatars = await res["info"];

    if (mounted) {
      setState(() {});
    }
  }

  updateAvatar(String avatarId) async {
    //
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustAlertLoading();
      },
    );

    var res = await postData(updateAvatarSeekerApi, {
      "avatarId": avatarId,
    });

    print(res.toString());

    if (res["message"] == "Update avatar succeed") {
      await getProfileSeeker();

      Navigator.pop(context);
    }

    if (mounted) {
      setState(() {});
    }
  }

  //error setState() called after dispose(). it can help!!!
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    getProfileSeeker();
    fetchAvatar();
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
        body: _isLoading
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              )
            : SafeArea(
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
                      title: Text(
                        'my profile'.tr,
                        style: appbarTextMedium(
                            "NotoSansLaoLoopedBold", AppColors.fontWhite, null),
                      ),

                      //
                      //
                      //Widget Actions
                      //Profile setting
                      actions: _status == "Approved" &&
                              _memberLevel != "Basic Member"
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileSetting(
                                      isSearchable: _isSearchable,
                                    ),
                                  ),
                                ).then((value) => onGoBack(value));
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
                                      "\uf013",
                                      style: fontAwesomeRegular(
                                          null, 20, AppColors.iconLight, null),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 45,
                              width: 45,
                            ),
                    ),

                    //
                    //
                    //
                    //
                    //
                    //Content expanded
                    Expanded(
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            //
                            //
                            //
                            //
                            //Section
                            //Processing profile
                            if (_isReview)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withOpacity(0.2),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "your profile is review".tr,
                                      style: bodyTextNormal(
                                          null,
                                          AppColors.fontWaring,
                                          FontWeight.bold),
                                    ),
                                    Text(
                                      "it takeup to process".tr,
                                      style: bodyTextSmall(
                                        null,
                                        AppColors.fontGreyOpacity,
                                        null,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                            //
                            //
                            //
                            //
                            //Section
                            //Profile Image
                            Container(
                              width: double.infinity,
                              color: AppColors.primary100,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  //
                                  //
                                  //Press alert dialog show avatar image
                                  onTap: () async {
                                    dynamic result = await showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return BoxDecAvatarImage(
                                            listItems: _avatars,
                                            selectedListItem:
                                                _selectedAvatarImage,
                                            title: "avatar_image".tr,
                                          );
                                        });

                                    if (result != null) {
                                      if (result[0] == "Confirm") {
                                        setState(() {
                                          updateAvatar(result[1].toString());
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              //
                                              //
                                              //Avatar image
                                              Stack(
                                                clipBehavior: Clip.none,
                                                alignment: Alignment.center,
                                                children: <Widget>[
                                                  //
                                                  //
                                                  //Image loading
                                                  _imageLoading
                                                      ? Container(
                                                          width: 90,
                                                          height: 90,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: AppColors
                                                                .backgroundWhite,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                                "uploading".tr),
                                                          ),
                                                        )
                                                      //
                                                      //
                                                      //ຫຼັງຈາກ Image loading ແລ້ວ
                                                      : Container(
                                                          width: 90,
                                                          height: 90,
                                                          child: _image != null
                                                              //
                                                              //
                                                              //ຖ້າວ່າມີຮູບ (_image != null)
                                                              ? ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  child: Image
                                                                      .file(
                                                                    _image!,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                )
                                                              //
                                                              //
                                                              //ຖ້າວ່າບໍ່ມີຮູບ (_image == null)
                                                              : ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  child: _avatarObj ==
                                                                          null
                                                                      ? Image
                                                                          .asset(
                                                                          'assets/image/no-image-available.png',
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )
                                                                      : Image
                                                                          .network(
                                                                          "${_avatarScr}",
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            print(error);
                                                                            return Image.asset(
                                                                              'assets/image/no-image-available.png',
                                                                              fit: BoxFit.cover,
                                                                            ); // Display an error message
                                                                          },
                                                                        ),
                                                                ),
                                                        ),

                                                  //
                                                  //
                                                  //Gallery image icon at the bottom right corner
                                                  Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        height: 20,
                                                        width: 20,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              AppColors.dark100,
                                                        ),
                                                        child: Text(
                                                          "\uf021",
                                                          style:
                                                              fontAwesomeRegular(
                                                                  null,
                                                                  10,
                                                                  AppColors
                                                                      .dark500,
                                                                  null),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              //
                                              //
                                              //Column text right avatar image
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "avatar_image".tr,
                                                      style: bodyTextMaxNormal(
                                                          "NotoSansLaoLoopedBold",
                                                          null,
                                                          FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "select_avatar_intro_text"
                                                          .tr,
                                                      style: bodyTextSmall(
                                                          null, null, null),
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
                            //
                            //
                            //Section
                            //Content profile
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),

                                  //
                                  //
                                  //
                                  //
                                  //
                                  //Note text
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text(
                                          "\uf06a",
                                          style: fontAwesomeSolid(
                                              null, 14, null, null),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "upgrade_member_level_intro".tr,
                                          style: bodyTextMinNormal(
                                              null, null, null),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  //
                                  //
                                  //
                                  //
                                  //
                                  //Basic Member
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Basic Member",
                                        style: bodyTextMiniMedium(
                                            "NotoSansLaoLoopedBold",
                                            null,
                                            null),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      //
                                      //
                                      //Current member status
                                      if (_memberLevel == "Basic Member")
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColors.primary600),
                                          child: Text(
                                            "curret_member_level".tr,
                                            style: bodyTextSmall(null,
                                                AppColors.fontWhite, null),
                                          ),
                                        )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  //
                                  //

                                  //
                                  //Box Decoration Personal information
                                  BoxDecorationInputPrefixTextSuffixWidget(
                                    press: () {
                                      _seekerProfile == null ||
                                              _seekerProfile == ""
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PersonalInformation(),
                                              ),
                                            ).then((val) => onGoBack(val))
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PersonalInformation(
                                                  id: _seekerProfile['_id'],
                                                  profile: _seekerProfile,
                                                ),
                                              ),
                                            ).then((val) => onGoBack(val));
                                    },
                                    prefixIconText:
                                        _personalInformationStatus == null
                                            ? "\uf058"
                                            : !_personalInformationStatus
                                                ? "\uf04c"
                                                : "\uf058",
                                    prefixFontFamily:
                                        _personalInformationStatus == null
                                            ? "FontAwesomeRegular"
                                            : "FontAwesomeSolid",
                                    prefixColor:
                                        _personalInformationStatus == null
                                            ? AppColors.dark500
                                            : !_personalInformationStatus
                                                ? AppColors.warning600
                                                : AppColors.primary600,
                                    text: "personal_info".tr,
                                    textColor:
                                        _personalInformationStatus == null
                                            ? AppColors.dark500
                                            : !_personalInformationStatus
                                                ? null
                                                : null,
                                    statusReview:
                                        _personalInformationStatus == null
                                            ? ""
                                            : !_personalInformationStatus
                                                ? "profile_inreview".tr
                                                : "",
                                    suffixWidget: Text(
                                      "\uf054",
                                      style: fontAwesomeSolid(
                                          null, 14, null, null),
                                    ),
                                    validateText: Container(),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),

                                  //
                                  //
                                  //
                                  //
                                  //
                                  //Basic Job Seeker
                                  Row(
                                    children: [
                                      Text(
                                        "Basic Job Seeker",
                                        style: bodyTextMiniMedium(
                                            "NotoSansLaoLoopedBold",
                                            null,
                                            null),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      //
                                      //
                                      //Current member status
                                      if (_memberLevel == "Basic Job Seeker")
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColors.primary600),
                                          child: Text(
                                            "Current",
                                            style: bodyTextSmall(null,
                                                AppColors.fontWhite, null),
                                          ),
                                        )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  //
                                  //
                                  //Box Decoration Work Preferences
                                  BoxDecorationInputPrefixTextSuffixWidget(
                                    press: () {
                                      _workPreferences == null ||
                                              _workPreferences == ""
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    WorkPreferences(),
                                              ),
                                            ).then((val) => onGoBack(val))
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    WorkPreferences(),
                                              ),
                                            ).then((val) => onGoBack(val));
                                    },
                                    prefixIconText:
                                        _workPreferenceStatus == null
                                            ? "\uf058"
                                            : !_workPreferenceStatus
                                                ? "\uf04c"
                                                : "\uf058",
                                    prefixFontFamily:
                                        _workPreferenceStatus == null
                                            ? "FontAwesomeRegular"
                                            : "FontAwesomeSolid",
                                    prefixColor: _workPreferenceStatus == null
                                        ? AppColors.dark500
                                        : !_workPreferenceStatus
                                            ? AppColors.warning600
                                            : AppColors.primary600,
                                    text: "work_preference".tr,
                                    textColor: _workPreferenceStatus == null
                                        ? AppColors.dark500
                                        : !_workPreferenceStatus
                                            ? null
                                            : null,
                                    statusReview: _workPreferenceStatus == null
                                        ? ""
                                        : !_workPreferenceStatus
                                            ? "profile_inreview".tr
                                            : "",
                                    suffixWidget: Text(
                                      "\uf054",
                                      style: fontAwesomeSolid(
                                          null, 14, null, null),
                                    ),
                                    validateText: Container(),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  //
                                  //
                                  //Box Decoration Resume File
                                  BoxDecorationInputPrefixTextSuffixWidget(
                                    press: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UploadCV(
                                            cv: _cv,
                                          ),
                                        ),
                                      ).then((val) => onGoBack(val));
                                    },
                                    prefixIconText: _resumeStatus == null
                                        ? "\uf058"
                                        : !_resumeStatus
                                            ? "\uf04c"
                                            : "\uf058",
                                    prefixFontFamily: _resumeStatus == null
                                        ? "FontAwesomeRegular"
                                        : "FontAwesomeSolid",
                                    prefixColor: _resumeStatus == null
                                        ? AppColors.dark500
                                        : !_resumeStatus
                                            ? AppColors.warning600
                                            : AppColors.primary600,
                                    text: "cv_file".tr,
                                    textColor: _resumeStatus == null
                                        ? AppColors.dark500
                                        : !_resumeStatus
                                            ? null
                                            : null,
                                    statusReview: _resumeStatus == null
                                        ? ""
                                        : !_resumeStatus
                                            ? "profile_inreview".tr
                                            : "",
                                    suffixWidget: Text(
                                      "\uf054",
                                      style: fontAwesomeSolid(
                                          null, 14, null, null),
                                    ),
                                    validateText: Container(),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),

                                  //
                                  //
                                  //
                                  //
                                  //
                                  //Expert Job Seeker
                                  Row(
                                    children: [
                                      Text(
                                        "Expert Job Seeker",
                                        style: bodyTextMiniMedium(
                                            "NotoSansLaoLoopedBold",
                                            null,
                                            null),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      //
                                      //
                                      //Current member status
                                      if (_memberLevel == "Expert Job Seeker")
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColors.primary600),
                                          child: Text(
                                            "Current",
                                            style: bodyTextSmall(null,
                                                AppColors.fontWhite, null),
                                          ),
                                        )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  //
                                  //
                                  //Box Decoration Work History
                                  BoxDecorationInputPrefixTextSuffixWidget(
                                    press: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FetchWorkHistory(),
                                        ),
                                      ).then((val) => onGoBack(val));
                                    },
                                    prefixIconText: _workHistoryStatus == null
                                        ? "\uf058"
                                        : !_workHistoryStatus
                                            ? "\uf04c"
                                            : "\uf058",
                                    prefixFontFamily: _workHistoryStatus == null
                                        ? "FontAwesomeRegular"
                                        : "FontAwesomeSolid",
                                    prefixColor: _workHistoryStatus == null
                                        ? AppColors.dark500
                                        : !_workHistoryStatus
                                            ? AppColors.warning600
                                            : AppColors.primary600,
                                    text: "work_history".tr,
                                    textColor: _workHistoryStatus == null
                                        ? AppColors.dark500
                                        : !_workHistoryStatus
                                            ? null
                                            : null,
                                    statusReview: _workHistoryStatus == null
                                        ? ""
                                        : !_workHistoryStatus
                                            ? "profile_inreview".tr
                                            : "",
                                    suffixWidget: Text(
                                      "\uf054",
                                      style: fontAwesomeSolid(
                                          null, 14, null, null),
                                    ),
                                    validateText: Container(),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  //
                                  //
                                  //Box Decoration Education
                                  BoxDecorationInputPrefixTextSuffixWidget(
                                    press: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FetchEducation(),
                                        ),
                                      ).then((val) => onGoBack(val));
                                    },
                                    prefixIconText: _educationStatus == null
                                        ? "\uf058"
                                        : !_educationStatus
                                            ? "\uf04c"
                                            : "\uf058",
                                    prefixFontFamily: _educationStatus == null
                                        ? "FontAwesomeRegular"
                                        : "FontAwesomeSolid",
                                    prefixColor: _educationStatus == null
                                        ? AppColors.dark500
                                        : !_educationStatus
                                            ? AppColors.warning600
                                            : AppColors.primary600,
                                    text: "education".tr,
                                    textColor: _educationStatus == null
                                        ? AppColors.dark500
                                        : !_educationStatus
                                            ? null
                                            : null,
                                    statusReview: _educationStatus == null
                                        ? ""
                                        : !_educationStatus
                                            ? "profile_inreview".tr
                                            : "",
                                    suffixWidget: Text(
                                      "\uf054",
                                      style: fontAwesomeSolid(
                                          null, 14, null, null),
                                    ),
                                    validateText: Container(),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  //
                                  //
                                  //Box Decoration Language
                                  BoxDecorationInputPrefixTextSuffixWidget(
                                    press: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FetchLanguage(),
                                        ),
                                      ).then((val) => onGoBack(val));
                                    },
                                    prefixIconText: _languageStatus == null
                                        ? "\uf058"
                                        : !_languageStatus
                                            ? "\uf04c"
                                            : "\uf058",
                                    prefixFontFamily: _languageStatus == null
                                        ? "FontAwesomeRegular"
                                        : "FontAwesomeSolid",
                                    prefixColor: _languageStatus == null
                                        ? AppColors.dark500
                                        : !_languageStatus
                                            ? AppColors.warning600
                                            : AppColors.primary600,
                                    text: "language_skill".tr,
                                    textColor: _languageStatus == null
                                        ? AppColors.dark500
                                        : !_languageStatus
                                            ? null
                                            : null,
                                    statusReview: _languageStatus == null
                                        ? ""
                                        : !_languageStatus
                                            ? "profile_inreview".tr
                                            : "",
                                    suffixWidget: Text(
                                      "\uf054",
                                      style: fontAwesomeSolid(
                                          null, 14, null, null),
                                    ),
                                    validateText: Container(),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  //
                                  //
                                  //Box Decoration Skill
                                  BoxDecorationInputPrefixTextSuffixWidget(
                                    press: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FetchSkill(),
                                        ),
                                      ).then((val) => onGoBack(val));
                                    },
                                    prefixIconText: _skillStatus == null
                                        ? "\uf058"
                                        : !_skillStatus
                                            ? "\uf04c"
                                            : "\uf058",
                                    prefixFontFamily: _skillStatus == null
                                        ? "FontAwesomeRegular"
                                        : "FontAwesomeSolid",
                                    prefixColor: _skillStatus == null
                                        ? AppColors.dark500
                                        : !_skillStatus
                                            ? AppColors.warning600
                                            : AppColors.primary600,
                                    text: "skills".tr,
                                    textColor: _skillStatus == null
                                        ? AppColors.dark500
                                        : !_skillStatus
                                            ? null
                                            : null,
                                    statusReview: _skillStatus == null
                                        ? ""
                                        : !_skillStatus
                                            ? "profile_inreview".tr
                                            : "",
                                    suffixWidget: Text(
                                      "\uf054",
                                      style: fontAwesomeSolid(
                                          null, 14, null, null),
                                    ),
                                    validateText: Container(),
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
                            //ProfileDetail
                            // Container(
                            //   child: ProfileDetail(
                            //     profile: _seekerProfile,
                            //     workPreferences: _workPreferences,
                            //     cv: _cv,
                            //     educations: _education,
                            //     workHistories: _workHistory,
                            //     languageSkills: _languageSkill,
                            //     skills: _skills,
                            //     onGoBack: onGoBack,
                            //   ),
                            // )
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

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//Profile Detail
class ProfileDetail extends StatefulWidget {
  const ProfileDetail({
    Key? key,
    this.profile,
    this.workPreferences,
    this.cv,
    required this.educations,
    required this.workHistories,
    required this.languageSkills,
    required this.skills,
    this.onGoBack,
  }) : super(key: key);

  final dynamic profile;
  final dynamic workPreferences;
  final dynamic cv;
  final List educations;
  final List workHistories;
  final List languageSkills;
  final List skills;
  final onGoBack;

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  //
  //Profile Seekr
  String _address = "";
  String _dateOfBirth = "";
  String _genDerName = "";
  String _maritalStatusName = "";
  String _mobile = "";
  String _email = "";

  //
  //Work Preference
  String _salary = "";
  String _currentJobTitle = "";
  String _jobLevel = "";
  List _listJobFunctions = [];
  String _jobFunctions = "";
  List _listWorkProvinces = [];
  String _workProvinces = "";
  List _listBenefits = [];
  String _benefits = "";

  //
  //CV
  dynamic _cvName;
  dynamic _cvUploadDate;
  String _cvSrc = "";
  String _mimeType = "";

  //
  //Work History
  dynamic _startYearWorkHistory = null;
  dynamic _endYearWorkHistory = null;
  String _company = "";
  String _position = "";

  //
  //Education
  dynamic _startYearEducation;
  dynamic _endYearWorkEducation;
  String _qualificationName = "";
  String _collage = "";
  String _subject = "";

  //
  //Language
  String _languageName = "";
  String _languageLevelName = "";

  //
  //Skill
  String _skillName = "";
  String _skillLevelName = "";

  Future<Directory?>? _tempDirectory;
  late String _localPath;
  late bool _permissionReady;
  late TargetPlatform? platform;
  String _memberLevel = "";

  // void _requestDownloadsDirectory() {
  //   setState(() {
  //     _tempDirectory = getDownloadsDirectory();
  //     print(_tempDirectory);
  //   });
  // }
  // Future<bool> _checkPermission() async {
  //   if (platform == TargetPlatform.android) {
  //     final status = await Permission.storage.status;
  //     if (status != PermissionStatus.granted) {
  //       final result = await Permission.storage.request();
  //       if (result == PermissionStatus.granted) {
  //         return true;
  //       }
  //     } else {
  //       return true;
  //     }
  //   } else {
  //     return true;
  //   }
  //   return false;
  // }

  // Future<void> _prepareSaveDir() async {
  //   _localPath = (await _findLocalPath())!;
  //   print(_localPath);
  //   final savedDir = Directory(_localPath);
  //   bool hasExisted = await savedDir.exists();
  //   if (!hasExisted) {
  //     savedDir.create();
  //   }
  // }

  // Future<String?> _findLocalPath() async {
  //   if (platform == TargetPlatform.android) {
  //     return "/sdcard/download/";
  //   } else {
  //     var directory = await getApplicationDocumentsDirectory();
  //     return directory.path + Platform.pathSeparator + 'Download';
  //   }
  // }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.profile != null) {
      _address = widget.profile["address"];
      _dateOfBirth = !widget.profile.containsKey('dateOfBirth')
          ? ""
          : widget.profile['dateOfBirth'];

      if (_dateOfBirth != "") {
        //pars ISO to Flutter DateTime
        parsDateTime(value: '', currentFormat: '', desiredFormat: '');
        DateTime parsDateOfBirth = parsDateTime(
          value: _dateOfBirth,
          currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
          desiredFormat: "yyyy-MM-dd HH:mm:ss",
        );
        _dateOfBirth = formatDate(parsDateOfBirth);
      }

      _genDerName = widget.profile['genderId'] != null
          ? widget.profile['genderId']['name']
          : "";
      _maritalStatusName = widget.profile['maritalStatusId'] != null
          ? widget.profile['maritalStatusId']['name']
          : "";
      _email = widget.profile['email'];
      _mobile = widget.profile['mobile'];
    }
    if (widget.cv != null) {
      _cvName = widget.cv['link'].split('/')[1];
      _cvUploadDate = widget.cv['updatedAt'];
      parsDateTime(value: '', currentFormat: '', desiredFormat: '');
      DateTime cvUploadDate = parsDateTime(
        value: _cvUploadDate,
        currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
        desiredFormat: "yyyy-MM-dd HH:mm:ss",
      );
      _cvUploadDate = formatDate(cvUploadDate);
      _cvSrc = widget.cv['src'];
      _mimeType = widget.cv['mimeType'];
      _mimeType = _mimeType.split("/")[1].toString();
    }
    if (widget.workPreferences != null) {
      _currentJobTitle = widget.workPreferences['currentJobTitle'];

      _salary = widget.workPreferences['salary'].toString();
      int parseIntSalary = int.parse(_salary);
      _salary = NumberFormat('#,##0').format(parseIntSalary);

      _jobLevel = widget.workPreferences['jobLevelId']['name'];

      _listJobFunctions = widget.workPreferences['jobFunctionId'];
      _jobFunctions = _listJobFunctions.map((jf) => jf['name']).join(', ');

      _listWorkProvinces = widget.workPreferences['workLocation'];
      _workProvinces = _listWorkProvinces.map((p) => p['name']).join(', ');

      _listBenefits = widget.workPreferences['benefitsId'];
      _benefits = _listBenefits.map((b) => b['name']).join(', ');
    }

    // var splitHttps = _cvSrc.split(":");
    // var splitHost = _cvSrc.split("/");
    // var splitPath = _cvSrc.split(".com");

    // final Uri toLaunch = Uri(
    //     scheme: splitHttps[0].toString(),
    //     host: splitHost[2].toString(),
    //     path: splitPath[1].toString());

    // print(splitPath);

    return Container(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            //
            //
            //
            //Job Seeker Area
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Basic Job Seeker",
                    style: bodyTextMaxNormal(null, null, FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "complete section your profile".tr,
                    style: bodyTextNormal(null, null, null),
                    overflow: TextOverflow.fade,
                  ),
                  Row(
                    children: [
                      Text(
                        "to the next level".tr + ": ",
                        style: bodyTextNormal(null, null, null),
                      ),
                      Text(
                        _memberLevel == "Basic Member" || _memberLevel == ""
                            ? "Basic Job Seeker"
                            : _memberLevel == "Basic Job Seeker"
                                ? "Expert Job Seeker"
                                : "Expert Job Seeker",
                        style: bodyTextNormal(
                            null, AppColors.fontSuccess, FontWeight.bold),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  //
                  //
                  //BoxDecoration DottedBorder Personal Information
                  widget.profile == null || widget.profile == ""
                      ? BoxDecDottedBorderProfileDetail(
                          boxDecColor: AppColors.lightPrimary,
                          title: "personal_info".tr,
                          titleFontWeight: FontWeight.bold,
                          text: "let us know".tr,
                          buttonText: "add".tr,
                          pressButton: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PersonalInformation(),
                              ),
                            ).then(widget.onGoBack);
                          },
                        )
                      : BoxDecProfileDetailHaveValue(
                          title: "personal_info".tr,
                          titleFontWeight: FontWeight.bold,
                          text: "let us know".tr,
                          widgetColumn: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "address".tr + ":",
                                style: bodyTextNormal(null, null, null),
                              ),
                              Text(
                                _address,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "birth".tr +
                                    ", " +
                                    "gender".tr +
                                    ", " +
                                    "marital status".tr +
                                    ":",
                                style: bodyTextNormal(null, null, null),
                              ),
                              Text(
                                "$_dateOfBirth " +
                                    "$_genDerName " +
                                    "$_maritalStatusName ",
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "email".tr + ":",
                                style: bodyTextNormal(null, null, null),
                              ),
                              Text(
                                _email,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "phone".tr + ":",
                                style: bodyTextNormal(null, null, null),
                              ),
                              Text(
                                _mobile,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                            ],
                          ),

                          //
                          //
                          //Button Left For Update
                          statusLeft: "have",
                          pressLeft: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PersonalInformation(
                                  id: widget.profile['_id'],
                                  profile: widget.profile,
                                ),
                              ),
                            ).then(widget.onGoBack);
                          },
                        ),

                  SizedBox(
                    height: 20,
                  ),

                  //
                  //
                  //BoxDecoration DottedBorder Work Preferences
                  widget.workPreferences == null || widget.workPreferences == ""
                      ? BoxDecDottedBorderProfileDetail(
                          boxDecColor: AppColors.lightPrimary,
                          title: "work_preference".tr,
                          titleFontWeight: FontWeight.bold,
                          text: "add".tr + " " + "work_preference".tr,
                          buttonText: "add".tr,
                          pressButton: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkPreferences(),
                              ),
                            ).then(widget.onGoBack);
                          },
                        )
                      : BoxDecProfileDetailHaveValue(
                          title: "work_preference".tr,
                          titleFontWeight: FontWeight.bold,
                          text: "add".tr + " " + "work_preference".tr,
                          widgetColumn: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "salary".tr + ":",
                                style: bodyTextNormal(null, null, null),
                              ),
                              Text(
                                _salary,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "job title".tr + ":",
                                style: bodyTextNormal(null, null, null),
                              ),
                              Text(
                                _currentJobTitle,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "job function".tr + ":",
                                style: bodyTextNormal(null, null, null),
                              ),
                              Text(
                                _jobFunctions,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "work province".tr,
                                style: bodyTextNormal(null, null, null),
                              ),
                              Text(
                                _workProvinces,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "job level".tr + ":",
                                style: bodyTextNormal(null, null, null),
                              ),
                              Text(
                                _jobLevel,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "benefit".tr + ":",
                                style: bodyTextNormal(null, null, null),
                              ),
                              Text(
                                _benefits,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                            ],
                          ),

                          //
                          //
                          //Status Left For Update
                          statusLeft: "have",
                          pressLeft: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkPreferences(
                                  id: "workPreferenceId",
                                  workPreference: widget.workPreferences,
                                ),
                              ),
                            ).then(widget.onGoBack);
                          },
                        ),
                  SizedBox(
                    height: 20,
                  ),

                  //
                  //
                  //BoxDecoration DottedBorder Upload CV
                  widget.cv == null
                      ? BoxDecDottedBorderProfileDetail(
                          boxDecColor: AppColors.lightPrimary,
                          title: "upload cv".tr,
                          titleFontWeight: FontWeight.bold,
                          text: "cv_file_support".tr,
                          buttonText: "add".tr,
                          pressButton: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadCV(),
                              ),
                            ).then(widget.onGoBack);
                          },
                        )
                      : BoxDecProfileDetailHaveValue(
                          title: "upload cv".tr,
                          titleFontWeight: FontWeight.bold,
                          text: "cv_file_support".tr,
                          widgetFaIcon: Expanded(
                            flex: 2,
                            child: Container(
                              child: FaIcon(
                                _mimeType == "pdf"
                                    ? FontAwesomeIcons.filePdf
                                    : FontAwesomeIcons.fileWord,
                                size: IconSize.lIcon,
                                color: AppColors.iconPrimary,
                              ),
                            ),
                          ),
                          widgetColumn: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_cvName}",
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "uploaded".tr + " ${_cvUploadDate}",
                                style: bodyTextNormal(null, null, null),
                              ),
                            ],
                          ),

                          //
                          //
                          //Button Right ellipsis function(Upload, Preview, Download)
                          widgetFaIconRight: FaIcon(
                            FontAwesomeIcons.ellipsis,
                            size: IconSize.xsIcon,
                          ),
                          statusRight: "have",
                          pressRight: () {
                            //
                            //
                            //show modal bottom upload new cv, preview, download
                            showModalBottomSheet(
                              context: context,
                              builder: (builder) {
                                return ModalBottomUploadCV(
                                  //
                                  //
                                  //button upload new resume
                                  () {
                                    Navigator.pop(context);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UploadCV(),
                                      ),
                                    ).then(widget.onGoBack);
                                  },
                                  null,
                                  "upload new CV".tr,

                                  //
                                  //
                                  //button preview cv
                                  () {
                                    launchInWebView(Uri.parse(_cvSrc));
                                  },
                                  null,
                                  "view".tr,

                                  //
                                  //
                                  //button download cv
                                  () {
                                    launchInBrowser(Uri.parse(_cvSrc));
                                  },
                                  null,
                                  "download".tr,
                                );
                              },
                            );
                          },
                        ),
                  SizedBox(
                    height: 30,
                  ),

                  // Button(
                  //   text: "Request for review",
                  //   fontWeight: FontWeight.bold,
                  //   colorButton: AppColors.buttonSecondary,
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child:
                  //       Text("Complete all sections above to request for review"),
                  // ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                ],
              ),
            ),
            Divider(
              height: 3,
              color: AppColors.borderBG,
            ),

            //
            //
            //
            //
            //
            //Expert Job Seeker Area
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Expert Job Seeker",
                    style: bodyTextMaxNormal(null, null, FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "complete section your profile".tr,
                    style: bodyTextNormal(null, null, null),
                    overflow: TextOverflow.fade,
                  ),
                  Row(
                    children: [
                      Text(
                        "to the next level".tr + ": ",
                        style: bodyTextNormal(null, null, null),
                      ),
                      Text(
                        "Expert Job Seeker",
                        style: bodyTextNormal(
                            null, AppColors.fontSuccess, FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //
                  //
                  //BoxDecoration DottedBorder Work History
                  widget.workHistories.length > 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "work_history".tr,
                              style: bodyTextMedium(
                                  null, AppColors.fontPrimary, FontWeight.bold),
                            ),
                            Text(
                              "details employment history".tr,
                              style: bodyTextSmall(
                                null,
                                AppColors.fontGreyOpacity,
                                null,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.workHistories.length,
                              itemBuilder: (context, index) {
                                dynamic i = widget.workHistories[index];

                                _startYearWorkHistory = i['startYear'];
                                //pars ISO to Flutter DateTime
                                parsDateTime(
                                    value: '',
                                    currentFormat: '',
                                    desiredFormat: '');
                                DateTime startYear = parsDateTime(
                                  value: _startYearWorkHistory,
                                  currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                                  desiredFormat: "yyyy-MM-dd HH:mm:ss",
                                );
                                _startYearWorkHistory =
                                    formatMonthYear(startYear);

                                _endYearWorkHistory = i['endYear'];
                                if (_endYearWorkHistory != null) {
                                  //pars ISO to Flutter DateTime
                                  parsDateTime(
                                      value: '',
                                      currentFormat: '',
                                      desiredFormat: '');
                                  DateTime endYear = parsDateTime(
                                    value: _endYearWorkHistory,
                                    currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                                    desiredFormat: "yyyy-MM-dd HH:mm:ss",
                                  );
                                  _endYearWorkHistory =
                                      formatMonthYear(endYear);
                                }
                                _company = i['company'];
                                _position = i['position'];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child:
                                      BoxDecProfileDetailHaveValueWithoutTitleText(
                                    widgetColumn: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${_startYearWorkHistory}",
                                              style: bodyTextNormal(
                                                  null, null, null),
                                            ),
                                            Text(" - "),
                                            Text(
                                              "${_endYearWorkHistory ?? 'Now'}",
                                              style: bodyTextNormal(
                                                  null, null, null),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _position,
                                          style: bodyTextNormal(
                                              null, null, FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _company,
                                          style:
                                              bodyTextNormal(null, null, null),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),

                                    //
                                    //
                                    //Button Left For Update
                                    statusLeft: "have",
                                    pressLeft: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WorkHistory(
                                            id: i["_id"],
                                            workHistory: i,
                                          ),
                                        ),
                                      ).then(widget.onGoBack);
                                    },

                                    //
                                    //
                                    //Button Right For Delete
                                    statusRight: "have",
                                    pressRight: () async {
                                      var result = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                              title: "delete_this_info".tr,
                                              contentText: "work_history".tr +
                                                  ": ${i['position']}",
                                              textButtonLeft: 'cancel'.tr,
                                              textButtonRight: 'confirm'.tr,
                                              textButtonRightColor:
                                                  AppColors.fontWhite,
                                            );
                                          });
                                      if (result == 'Ok') {
                                        print("confirm delete");
                                        deleteWorkHistory(i['_id']);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                            CustomButtonIconText(
                              colorButton: AppColors.lightPrimary,
                              widgetFaIcon: FaIcon(
                                FontAwesomeIcons.plus,
                                color: AppColors.fontPrimary,
                              ),
                              text: "add".tr + " " + 'work history'.tr,
                              colorText: AppColors.fontPrimary,
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkHistory(),
                                  ),
                                ).then(widget.onGoBack);
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Divider(
                              height: 2,
                              color: AppColors.borderBG,
                            )
                          ],
                        )
                      : BoxDecDottedBorderProfileDetail(
                          boxDecColor: AppColors.lightPrimary,
                          title: "work_history".tr,
                          titleFontWeight: FontWeight.bold,
                          text: "details employment history".tr,
                          buttonText: "add".tr,
                          pressButton: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkHistory(),
                              ),
                            ).then(widget.onGoBack);
                          },
                        ),

                  SizedBox(
                    height: 20,
                  ),

                  //
                  //
                  //BoxDecoration DottedBorder Education
                  widget.educations.length > 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "education".tr,
                              style: bodyTextMedium(
                                  null, AppColors.fontPrimary, FontWeight.bold),
                            ),
                            Text(
                              "details education".tr,
                              style: bodyTextSmall(
                                null,
                                AppColors.fontGreyOpacity,
                                null,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.educations.length,
                              itemBuilder: (context, index) {
                                dynamic i = widget.educations[index];
                                DateTime dateTimeNow = DateTime.now();
                                DateTime utcNow = dateTimeNow.toUtc();
                                dynamic formattedStartDateUtc =
                                    DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                                        .format(utcNow);
                                dynamic formattedEndDateUtc =
                                    DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                                        .format(utcNow);

                                _startYearEducation = i['startYear'] == null
                                    ? formattedStartDateUtc
                                    : i['startYear'];
                                //pars ISO to Flutter DateTime
                                parsDateTime(
                                    value: '',
                                    currentFormat: '',
                                    desiredFormat: '');
                                DateTime startYear = parsDateTime(
                                  value: _startYearEducation,
                                  currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                                  desiredFormat: "yyyy-MM-dd HH:mm:ss",
                                );
                                _startYearEducation = formatYear(startYear);

                                _endYearWorkEducation = i['endYear'] == null
                                    ? formattedEndDateUtc
                                    : i['endYear'];
                                //pars ISO to Flutter DateTime
                                parsDateTime(
                                    value: '',
                                    currentFormat: '',
                                    desiredFormat: '');
                                DateTime endYear = parsDateTime(
                                  value: _endYearWorkEducation,
                                  currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                                  desiredFormat: "yyyy-MM-dd HH:mm:ss",
                                );
                                _endYearWorkEducation = formatYear(endYear);
                                _collage = i['school'];
                                _subject = i['subject'];
                                _qualificationName =
                                    i['qualifications']['name'];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child:
                                      BoxDecProfileDetailHaveValueWithoutTitleText(
                                    widgetColumn: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _startYearEducation +
                                              " - " +
                                              _endYearWorkEducation,
                                          style:
                                              bodyTextNormal(null, null, null),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _qualificationName,
                                          style: bodyTextNormal(
                                              null, null, FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _subject,
                                          style:
                                              bodyTextNormal(null, null, null),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _collage,
                                          style:
                                              bodyTextNormal(null, null, null),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),

                                    //
                                    //
                                    //Button Left For Update
                                    statusLeft: "have",
                                    pressLeft: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Education(
                                            id: i["_id"],
                                            education: i,
                                          ),
                                        ),
                                      ).then(widget.onGoBack);
                                    },

                                    //
                                    //
                                    //Button Right For Delete
                                    statusRight: "have",
                                    pressRight: () async {
                                      var result = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                              title: "delete_this_info".tr,
                                              contentText: "education".tr +
                                                  ": ${i['qualifications']['name']}",
                                              textButtonLeft: 'cancel'.tr,
                                              textButtonRight: 'confirm'.tr,
                                              textButtonRightColor:
                                                  AppColors.fontWhite,
                                            );
                                          });
                                      if (result == 'Ok') {
                                        print("confirm delete");
                                        deleteEducation(i['_id']);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                            CustomButtonIconText(
                              colorButton: AppColors.lightPrimary,
                              widgetFaIcon: FaIcon(
                                FontAwesomeIcons.plus,
                                color: AppColors.fontPrimary,
                              ),
                              text: "add".tr + " " + "education".tr,
                              colorText: AppColors.fontPrimary,
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Education(),
                                  ),
                                ).then(widget.onGoBack);
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Divider(
                              height: 2,
                              color: AppColors.borderBG,
                            )
                          ],
                        )
                      : BoxDecDottedBorderProfileDetail(
                          boxDecColor: AppColors.lightPrimary,
                          title: "education".tr,
                          titleFontWeight: FontWeight.bold,
                          text: "details education".tr,
                          buttonText: "add".tr,
                          pressButton: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Education(),
                              ),
                            ).then(widget.onGoBack);
                          },
                        ),

                  SizedBox(
                    height: 20,
                  ),

                  //
                  //
                  //BoxDecoration DottedBorder Language
                  widget.languageSkills.length > 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "language_skill".tr,
                              style: bodyTextMedium(
                                  null, AppColors.fontPrimary, FontWeight.bold),
                            ),
                            Text(
                              "add all languages".tr,
                              style: bodyTextSmall(
                                null,
                                AppColors.fontGreyOpacity,
                                null,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.languageSkills.length,
                              itemBuilder: (context, index) {
                                dynamic i = widget.languageSkills[index];

                                _languageName = i['LanguageId']['name'];
                                _languageLevelName =
                                    i['LanguageLevelId']['name'];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child:
                                      BoxDecProfileDetailHaveValueWithoutTitleText(
                                    widgetColumn: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _languageName,
                                          style: bodyTextNormal(
                                              null, null, FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _languageLevelName,
                                          style:
                                              bodyTextNormal(null, null, null),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),

                                    //
                                    //Button Left For Update
                                    statusLeft: "have",
                                    pressLeft: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Language(
                                            id: i['_id'],
                                            language: i,
                                          ),
                                        ),
                                      ).then(widget.onGoBack);
                                    },
                                    //
                                    //Button Right For Delete
                                    statusRight: "have",
                                    pressRight: () async {
                                      var result = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                              title: "delete_this_info".tr,
                                              contentText: "language_skill".tr +
                                                  ': ${i['LanguageId']['name']}',
                                              textButtonLeft: 'cancel'.tr,
                                              textButtonRight: 'confirm'.tr,
                                              textButtonRightColor:
                                                  AppColors.fontWhite,
                                            );
                                          });
                                      if (result == 'Ok') {
                                        print("confirm delete");
                                        deleteLanguage(i['_id']);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                            CustomButtonIconText(
                              colorButton: AppColors.lightPrimary,
                              widgetFaIcon: FaIcon(
                                FontAwesomeIcons.plus,
                                color: AppColors.fontPrimary,
                              ),
                              text: "add".tr + " " + "language_skill".tr,
                              colorText: AppColors.fontPrimary,
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Language(),
                                  ),
                                ).then(widget.onGoBack);
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Divider(
                              height: 2,
                              color: AppColors.borderBG,
                            )
                          ],
                        )
                      : BoxDecDottedBorderProfileDetail(
                          boxDecColor: AppColors.lightPrimary,
                          title: "language_skill".tr,
                          titleFontWeight: FontWeight.bold,
                          text: "add all languages".tr,
                          buttonText: "add".tr,
                          pressButton: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Language(),
                              ),
                            ).then(widget.onGoBack);
                          },
                        ),
                  SizedBox(
                    height: 20,
                  ),

                  //
                  //
                  //BoxDecoration DottedBorder Skill
                  widget.skills.length > 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "skills".tr,
                              style: bodyTextMedium(
                                  null, AppColors.fontPrimary, FontWeight.bold),
                            ),
                            Text(
                              "you should list skills".tr,
                              style: bodyTextSmall(
                                null,
                                AppColors.fontGreyOpacity,
                                null,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.skills.length,
                              itemBuilder: (context, index) {
                                dynamic i = widget.skills[index];
                                _skillName = i['keySkillId']['name'];
                                _skillLevelName = i['skillLevelId']['name'];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child:
                                      BoxDecProfileDetailHaveValueWithoutTitleText(
                                    widgetColumn: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _skillName,
                                          style: bodyTextNormal(
                                              null, null, FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _skillLevelName,
                                          style:
                                              bodyTextNormal(null, null, null),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    //
                                    //Button Left For Update
                                    statusLeft: "have",
                                    pressLeft: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Skill(
                                            id: i['_id'],
                                            skill: i,
                                          ),
                                        ),
                                      ).then(widget.onGoBack);
                                    },
                                    //
                                    //Button Right For Delete
                                    statusRight: "have",
                                    pressRight: () async {
                                      var result = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                              title: "delete_this_info".tr,
                                              contentText: "skills".tr +
                                                  ": ${i['keySkillId']['name']}",
                                              textButtonLeft: 'cancel'.tr,
                                              textButtonRight: 'confirm'.tr,
                                              textButtonRightColor:
                                                  AppColors.fontWhite,
                                            );
                                          });
                                      if (result == 'Ok') {
                                        print("confirm delete");
                                        deleteSkill(i['_id']);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                            CustomButtonIconText(
                              colorButton: AppColors.lightPrimary,
                              widgetFaIcon: FaIcon(
                                FontAwesomeIcons.plus,
                                color: AppColors.fontPrimary,
                              ),
                              text: "add".tr + " " + 'skill'.tr,
                              colorText: AppColors.fontPrimary,
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Skill(),
                                  ),
                                ).then(widget.onGoBack);
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Divider(
                              height: 2,
                              color: AppColors.borderBG,
                            )
                          ],
                        )
                      : BoxDecDottedBorderProfileDetail(
                          boxDecColor: AppColors.lightPrimary,
                          title: "skills".tr,
                          titleFontWeight: FontWeight.bold,
                          text: "you should list skills".tr,
                          buttonText: "add".tr,
                          pressButton: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Skill(),
                              ),
                            ).then(widget.onGoBack);
                          },
                        ),
                  SizedBox(
                    height: 20,
                  ),

                  // Button(
                  //   text: "Request for review",
                  //   fontWeight: FontWeight.bold,
                  // ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                ],
              ),
            ),

            // SizedBox(
            //   height: 10,
            // ),
          ],
        ),
      ),
    );
  }

  deleteEducation(String id) async {
    await deleteData(deleteEducationSeekerApi + id).then((value) {
      print(value);
      if (value['message'] == 'Delete succeed') {
        setState(() {
          widget.onGoBack(id); // Corrected: invoke the callback function
        });
      }
    });
  }

  deleteWorkHistory(String id) async {
    await deleteData(deleteWorkHistorySeekerApi + id).then((value) {
      print(value);
      if (value['message'] == 'Delete succeed') {
        setState(() {
          widget.onGoBack(id); // Corrected: invoke the callback function
        });
      }
    });
  }

  deleteLanguage(String id) async {
    await deleteData(deleteLanguageSeekerApi + id).then((value) {
      print(value);
      if (value['message'] == 'Delete succeed') {
        setState(() {
          widget.onGoBack(id); // Corrected: invoke the callback function
        });
      }
    });
  }

  deleteSkill(String id) async {
    await deleteData(deleteSkillSeekerApi + id).then((value) {
      print(value);
      if (value['message'] == 'Delete succeed') {
        setState(() {
          widget.onGoBack(id); // Corrected: invoke the callback function
        });
      }
    });
  }
}
