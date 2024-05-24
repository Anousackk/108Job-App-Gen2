// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, unused_field, avoid_print, unused_local_variable, prefer_typing_uninitialized_variables, prefer_final_fields, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, prefer_is_empty, unused_element, unnecessary_null_in_if_null_operators, prefer_if_null_operators, prefer_adjacent_string_concatenation, unnecessary_null_comparison, avoid_init_to_null

import 'dart:io';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/botttomModal.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/screenAfterSignIn/account/myProfile/education.dart';
import 'package:app/screen/screenAfterSignIn/account/myProfile/language.dart';
import 'package:app/screen/screenAfterSignIn/account/myProfile/personal_Information.dart';
import 'package:app/screen/screenAfterSignIn/account/myProfile/photoView.dart';
import 'package:app/screen/screenAfterSignIn/account/myProfile/profileSetting.dart';
import 'package:app/screen/screenAfterSignIn/account/myProfile/skill.dart';
import 'package:app/screen/screenAfterSignIn/account/myProfile/uploadCV.dart';
import 'package:app/screen/screenAfterSignIn/account/myProfile/workHistory.dart';
import 'package:app/screen/screenAfterSignIn/account/myProfile/workPreferences.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/boxDecDottedBorderProfileDetail.dart';
import 'package:app/widget/button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  dynamic _workPreferences;
  dynamic _cv;
  List _education = [];
  List _workHistory = [];
  List _languageSkill = [];
  List _skills = [];
  String _memberLevel = "";
  String _currentJobTitle = "";
  File? _image;

  bool _isLoading = true;
  bool _imageLoading = false;

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
                  "Allow “108 Jobs” to access your photos to send image to your manager, to detect your face.",
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
                  "“108 Jobs” needs to access your photos to send image to your manager, to detect your face. \n Please go to Setting and turn on the permission.",
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
    print("5");

    if (res != null) {
      getProfileSeeker();
    }
  }

  onGoBack(dynamic value) {
    getProfileSeeker();
    if (mounted) {
      setState(() {});
    }
  }

  getProfileSeeker() async {
    print("get api profile seeker");
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
    _cv = res['cv'] ?? null;
    _education = res['education'] ?? [];
    _workHistory = res['workHistory'] ?? [];
    _languageSkill = res['languageSkill'] ?? [];
    _skills = res['skills'] ?? [];

    if (_workPreferences != null) {
      _currentJobTitle = _workPreferences['currentJobTitle'];
    }

    if (res != null) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
      });
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

    _isLoading = true;
    getProfileSeeker();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBarAddAction(
          textTitle: 'My Profile',
          // fontWeight: FontWeight.bold,
          leadingIcon: Icon(Icons.arrow_back),
          leadingPress: () {
            Navigator.pop(context);
          },
          action: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileSetting(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: FaIcon(
                  FontAwesomeIcons.gear,
                  color: AppColors.iconLight,
                ),
              ),
            ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              )
            : SafeArea(
                child: Container(
                  color: AppColors.backgroundWhite,
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.2),
                          ),
                          child: Column(children: [
                            Text(
                              "Your profile is being review",
                              style: bodyTextNormal(
                                  AppColors.fontWaring, FontWeight.bold),
                            ),
                            Text(
                              "it may take up to 48Hrs in this proces",
                              style: bodyTextSmall(AppColors.fontGreyOpacity),
                            )
                          ]),
                        ),
                        //
                        //
                        //Profile Image
                        Container(
                          // color: AppColors.primary,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 40,
                              ),

                              //
                              //Press show modal bottom to view or upload image profile
                              GestureDetector(
                                onTap: () {
                                  //
                                  //show modal bottom view profile image, upload image profile
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (builder) {
                                        return ModalBottomCameraGallery(
                                          () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PhotViewDetail(
                                                  image: _imageSrc,
                                                ),
                                              ),
                                            ).then((value) =>
                                                Navigator.pop(context));
                                          },
                                          FaIcon(
                                            FontAwesomeIcons.solidEye,
                                            size: IconSize.sIcon,
                                            color: AppColors.iconPrimary,
                                          ),
                                          "View",
                                          () {
                                            pickImageGallery(
                                                ImageSource.gallery);
                                            Navigator.pop(context);
                                          },
                                          FaIcon(
                                            FontAwesomeIcons.solidImage,
                                            size: IconSize.sIcon,
                                            color: AppColors.iconPrimary,
                                          ),
                                          "Gallery",
                                        );
                                      });
                                },
                                child: Container(
                                  child: Stack(
                                    // textDirection: TextDirection.rtl,
                                    // fit: StackFit.loose,
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      //
                                      //
                                      //Placeholder circle for profile picture
                                      DottedBorder(
                                        dashPattern: [6, 7],
                                        strokeWidth: 2,
                                        borderType: BorderType.Circle,
                                        color: AppColors.borderPrimary,
                                        borderPadding: EdgeInsets.all(1),
                                        child: _imageLoading
                                            ? Container(
                                                width: 150,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColors.greyOpacity,
                                                ),
                                                child: Center(
                                                  child: Text("Uploading..."),
                                                ),
                                              )
                                            : Container(
                                                width: 150,
                                                height: 150,
                                                decoration: _image != null
                                                    ? BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColors
                                                            .greyOpacity,
                                                        image: DecorationImage(
                                                          image: FileImage(
                                                              _image!),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                    : BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColors
                                                            .greyOpacity,
                                                        image: _imageSrc == ""
                                                            ? DecorationImage(
                                                                image: AssetImage(
                                                                    'assets/image/def-profile.png'),
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : DecorationImage(
                                                                image: NetworkImage(
                                                                    _imageSrc),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                      ),
                                              ),
                                      ),
                                      //
                                      //
                                      //Status Seeker on top profile image
                                      Positioned(
                                        top: -20,
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.success,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            _memberLevel,
                                            style: bodyTextSmall(
                                                AppColors.fontWhite),
                                          ),
                                        ),
                                      ),

                                      //
                                      //
                                      //Camera icon at the bottom right corner
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            pickImageGallery(
                                                ImageSource.gallery);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.grey,
                                              border: Border.all(
                                                  color: AppColors.borderWhite),
                                            ),
                                            child: FaIcon(
                                              FontAwesomeIcons.camera,
                                              color: AppColors.iconLight,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              //
                              //
                              //Profile Name
                              Text(
                                "${_firstName}  ${_lastName}",
                                style: bodyTextMedium(null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                _currentJobTitle == ""
                                    ? "- -"
                                    : "${_currentJobTitle}",
                                style: bodyTextNormal(null, null),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),

                        //
                        //
                        //ProfileDetail
                        Container(
                          child: ProfileDetail(
                            profile: _seekerProfile,
                            workPreferences: _workPreferences,
                            cv: _cv,
                            educations: _education,
                            workHistories: _workHistory,
                            languageSkills: _languageSkill,
                            skills: _skills,
                            onGoBack: onGoBack,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

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
      _dateOfBirth = widget.profile['dateOfBirth'] ?? "";
      //pars ISO to Flutter DateTime
      parsDateTime(value: '', currentFormat: '', desiredFormat: '');
      DateTime parsDateOfBirth = parsDateTime(
        value: _dateOfBirth,
        currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
        desiredFormat: "yyyy-MM-dd HH:mm:ss",
      );
      _dateOfBirth = formatDate(parsDateOfBirth);

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
      //pars ISO to Flutter DateTime
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
            // Job Seeker Area
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Job Seeker Area",
                    style: bodyTextMaxNormal(null, FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Complete the sections below to take your profile",
                    style: bodyTextNormal(null, null),
                    overflow: TextOverflow.fade,
                  ),
                  Row(
                    children: [
                      Text(
                        "to the next level: ",
                        style: bodyTextNormal(null, null),
                      ),
                      Text(
                        _memberLevel == "Basic Member" || _memberLevel == ""
                            ? "Basic Job Seeker"
                            : _memberLevel == "Basic Job Seeker"
                                ? "Expert Job Seeker"
                                : "Expert Job Seeker",
                        style: bodyTextNormal(
                            AppColors.fontSuccess, FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "what is profile level ",
                        style: bodyTextSmall(null),
                      ),
                      Text(
                        "Learn more",
                        style: bodyTextSmall(AppColors.fontPrimary),
                      )
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
                          title: "Personal Information",
                          titleFontWeight: FontWeight.bold,
                          text: "Let us know more about you",
                          buttonText: "Add",
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
                          title: "Personal Information",
                          titleFontWeight: FontWeight.bold,
                          text: "Let us know more about you",
                          widgetColumn: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Address:",
                                style: bodyTextNormal(null, null),
                              ),
                              Text(
                                _address,
                                style: bodyTextNormal(null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Birth, Gender, Marital Status:",
                                style: bodyTextNormal(null, null),
                              ),
                              Text(
                                "$_dateOfBirth " +
                                    "$_genDerName " +
                                    "$_maritalStatusName ",
                                style: bodyTextNormal(null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Email:",
                                style: bodyTextNormal(null, null),
                              ),
                              Text(
                                _email,
                                style: bodyTextNormal(null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Mobile:",
                                style: bodyTextNormal(null, null),
                              ),
                              Text(
                                _mobile,
                                style: bodyTextNormal(null, FontWeight.bold),
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
                          title: "Work Preferences",
                          titleFontWeight: FontWeight.bold,
                          text: "Add you work preferences",
                          buttonText: "Add",
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
                          title: "Work Preferences",
                          titleFontWeight: FontWeight.bold,
                          text: "Add you work preferences",
                          widgetColumn: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Expected Salary:",
                                style: bodyTextNormal(null, null),
                              ),
                              Text(
                                _salary,
                                style: bodyTextNormal(null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Current Job Title:",
                                style: bodyTextNormal(null, null),
                              ),
                              Text(
                                _currentJobTitle,
                                style: bodyTextNormal(null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Expected Job Function:",
                                style: bodyTextNormal(null, null),
                              ),
                              Text(
                                _jobFunctions,
                                style: bodyTextNormal(null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Expected Work Location:",
                                style: bodyTextNormal(null, null),
                              ),
                              Text(
                                _workProvinces,
                                style: bodyTextNormal(null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Expected Job Level:",
                                style: bodyTextNormal(null, null),
                              ),
                              Text(
                                _jobLevel,
                                style: bodyTextNormal(null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Expected Benefit:",
                                style: bodyTextNormal(null, null),
                              ),
                              Text(
                                _benefits,
                                style: bodyTextNormal(null, FontWeight.bold),
                              ),
                            ],
                          ),

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
                          title: "Upload CV",
                          titleFontWeight: FontWeight.bold,
                          text:
                              "Supported file type .docx .pdf\nwith maximum size 5mb",
                          buttonText: "Add",
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
                          title: "Upload CV",
                          titleFontWeight: FontWeight.bold,
                          text:
                              "Supported file type .pdf .doc .docx \nwith maximum size 5mb",
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
                                style: bodyTextNormal(null, FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Uploaded: ${_cvUploadDate}",
                                style: bodyTextNormal(null, null),
                              ),
                            ],
                          ),

                          //
                          //Button Right ellipsis function(Upload, Preview, Download)
                          widgetFaIconRight: FaIcon(
                            FontAwesomeIcons.ellipsis,
                            size: IconSize.xsIcon,
                          ),
                          statusRight: "have",
                          pressRight: () {
                            //
                            //show modal bottom upload new cv, preview, download
                            showModalBottomSheet(
                              context: context,
                              builder: (builder) {
                                return ModalBottomUploadCV(
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
                                  "Upload a new resume",

                                  //
                                  //button preview cv
                                  () {
                                    launchInWebView(Uri.parse(_cvSrc));
                                  },
                                  null,
                                  "Preview",

                                  //
                                  //button download cv
                                  () {
                                    launchInBrowser(Uri.parse(_cvSrc));
                                  },
                                  null,
                                  "Download",
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
                    "Expert Job Seeker Area",
                    style: bodyTextMaxNormal(null, FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Complete the sections below to take your profile",
                    style: bodyTextNormal(null, null),
                    overflow: TextOverflow.fade,
                  ),
                  Row(
                    children: [
                      Text(
                        "to the next level: ",
                        style: bodyTextNormal(null, null),
                      ),
                      Text(
                        "Expert Job Seeker",
                        style: bodyTextNormal(
                            AppColors.fontSuccess, FontWeight.bold),
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
                              "Work History",
                              style: bodyTextNormal(
                                  AppColors.fontPrimary, FontWeight.bold),
                            ),
                            Text(
                              "Input details of your employment history",
                              style: bodyTextSmall(
                                AppColors.fontGreyOpacity,
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
                                  padding: const EdgeInsets.only(bottom: 10),
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
                                              style: bodyTextNormal(null, null),
                                            ),
                                            Text(" - "),
                                            Text(
                                              "${_endYearWorkHistory ?? 'Now'}",
                                              style: bodyTextNormal(null, null),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _position,
                                          style: bodyTextNormal(
                                              null, FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _company,
                                          style: bodyTextNormal(null, null),
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
                                          builder: (context) => WorkHistory(
                                            id: i["_id"],
                                            workHistory: i,
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
                                            return AlertDialogButtonConfirmCancelBetween(
                                              title: 'Delete Work History',
                                              contentText:
                                                  'Delete work history: ${i['position']} / ${i['company']}',
                                              textLeft: 'Cancel',
                                              textRight: 'Delete',
                                              colorTextRight:
                                                  AppColors.fontDanger,
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
                              text: 'Add Work History',
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
                          title: "Work History",
                          titleFontWeight: FontWeight.bold,
                          text: "Input details of your employment history",
                          buttonText: "Add",
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
                              "Education",
                              style: bodyTextNormal(
                                  AppColors.fontPrimary, FontWeight.bold),
                            ),
                            Text(
                              "Input details of your education",
                              style: bodyTextSmall(
                                AppColors.fontGreyOpacity,
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
                                  padding: const EdgeInsets.only(bottom: 10),
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
                                          style: bodyTextNormal(null, null),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _qualificationName,
                                          style: bodyTextNormal(
                                              null, FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _subject,
                                          style: bodyTextNormal(null, null),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _collage,
                                          style: bodyTextNormal(null, null),
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
                                          builder: (context) => Education(
                                            id: i["_id"],
                                            education: i,
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
                                            return AlertDialogButtonConfirmCancelBetween(
                                              title: 'Delete Education',
                                              contentText:
                                                  'Delete education: ${i['subject']} / ${i['qualifications']['name']} / ${i['school']}',
                                              textLeft: 'Cancel',
                                              textRight: 'Delete',
                                              colorTextRight:
                                                  AppColors.fontDanger,
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
                              text: 'Add Education',
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
                          title: "Education",
                          titleFontWeight: FontWeight.bold,
                          text: "Input details of your education",
                          buttonText: "Add",
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
                              "Language",
                              style: bodyTextNormal(
                                  AppColors.fontPrimary, FontWeight.bold),
                            ),
                            Text(
                              "Add all the languages you can speak to increase your job prospects",
                              style: bodyTextSmall(
                                AppColors.fontGreyOpacity,
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
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child:
                                      BoxDecProfileDetailHaveValueWithoutTitleText(
                                    widgetColumn: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _languageName,
                                          style: bodyTextNormal(
                                              null, FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _languageLevelName,
                                          style: bodyTextNormal(null, null),
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
                                            return AlertDialogButtonConfirmCancelBetween(
                                              title: 'Delete Language',
                                              contentText:
                                                  'Delete language: ${i['LanguageId']['name']}',
                                              textLeft: 'Cancel',
                                              textRight: 'Delete',
                                              colorTextRight:
                                                  AppColors.fontDanger,
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
                              text: 'Add Language',
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
                          title: "Language",
                          titleFontWeight: FontWeight.bold,
                          text:
                              "Add all the languages you can speak to increase your job prospects",
                          buttonText: "Add",
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
                              "Skill",
                              style: bodyTextNormal(
                                  AppColors.fontPrimary, FontWeight.bold),
                            ),
                            Text(
                              "In this section, you should list skills that are relevant to the position or career area you are interested in",
                              style: bodyTextSmall(
                                AppColors.fontGreyOpacity,
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
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child:
                                      BoxDecProfileDetailHaveValueWithoutTitleText(
                                    widgetColumn: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _skillName,
                                          style: bodyTextNormal(
                                              null, FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _skillLevelName,
                                          style: bodyTextNormal(null, null),
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
                                            return AlertDialogButtonConfirmCancelBetween(
                                              title: 'Delete Skill',
                                              contentText:
                                                  'Delete skill: ${i['keySkillId']['name']}',
                                              textLeft: 'Cancel',
                                              textRight: 'Delete',
                                              colorTextRight:
                                                  AppColors.fontDanger,
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
                              text: 'Add Skill',
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
                          title: "Skill",
                          titleFontWeight: FontWeight.bold,
                          text:
                              "In this section, you should list skills that are relevant to the position or career area you are interested in",
                          buttonText: "Add",
                          pressButton: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Skill(),
                              ),
                            ).then(widget.onGoBack);
                          },
                        ),
                  // SizedBox(
                  //   height: 20,
                  // ),

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
