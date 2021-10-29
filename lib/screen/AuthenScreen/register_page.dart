import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/animationfade.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/constant/registerdata.dart';
import 'package:app/constant/userdata.dart';
import 'package:app/function/pluginfunction.dart';
import 'package:app/function/sized.dart';
import 'package:app/screen/AuthenScreen/register_widget_input.dart';
import 'package:app/screen/AuthenScreen/verify_register_page.dart';
import 'package:app/screen/widget/alertdialog.dart';
import 'package:app/screen/widget/avatar.dart';
import 'package:app/screen/widget/button.dart';
import 'package:app/screen/widget/dotted_container.dart';
import 'package:app/screen/widget/input_text_field.dart';
import 'package:app/screen/widget/resume_tab.dart';
import 'package:validators/validators.dart';

import '../my_profile.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.isOlduser, this.userID})
      : super(key: key);
  final bool isOlduser;
  final String? userID;
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late ScrollController scroll;
  List<Widget>? genderActions = [];
  List<Widget>? mStatusActions = [];
  Register register = Register();
  bool? isLoading = false;
  bool? alertprofile = false,
      alertemail = false,
      alertnumber = false,
      alertpassword = false,
      alertfullname = false,
      alertdob = false,
      alertgender = false,
      alertmarital = false,
      // alertlicense = false,
      alertprovince = false,
      alertdistrict = false,
      alertsalary = false,
      alertLatestJob = false,
      alertPrejob = false,
      alertPreEm = false,
      alertPreIn = false,
      alertTotalExp = false,
      alertprofsum = false,
      alertcv = false,
      alertWorkExp = false,
      alertEdu = false,
      alertField = false,
      alertLang = false,
      alertKey = false;
  dynamic image, resume;
  double? imagePercent = 0;
  double? resumePercent = 0;
  bool? obscurePassword = true;
  bool? addWorkEXP = false, addEdu = false;
  bool? noHaveWorkExp = false;
  bool? provinceSelected = false;
  String? imageUrl;
  List<dynamic>? showFieldStudy = [];
  List<dynamic>? showLang = [];
  String? stringdob = '';
  String? filename = '';
  List<dynamic>? dialogError = [];
  File? resumeFile, picture;
  bool? onKeyboard;
  dynamic decodedImage;

  QueryInfo queryInfo = QueryInfo();

  TextEditingController emailControl = TextEditingController();
  TextEditingController numberControl = TextEditingController();
  TextEditingController passwordControl = TextEditingController();
  ImagePicker picker = ImagePicker();
  ////// Function
  ///

  // Future upLoadImage(String filename, String url) async {
  //   var request = http.MultipartRequest('POST', Uri.parse(url));
  //   request.files.add(await http.MultipartFile.fromPath('picture', filename));
  //   var res = await request.send();
  //   return res;
  // }

  Future selectImage(ImageSource imageSource) async {
    final img = await picker.pickImage(source: imageSource);
    if (img != null) {
      int sizeInBytes = File(img.path).lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      if (sizeInMb > 15) {
        showDialog<String>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertPlainDialog(
                title: l.cannotUpload,
                actions: [
                  AlertAction(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: l.ok,
                  )
                ],
                content: l.thisImageSizelarge,
              );
            });
      } else {
        setState(() {
          picture = File(img.path);
          alertprofile = picture == null;
        });
      }
    }
  }

  Future getPictureDevice() async {
    File? past = picture;

    var result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'docx']);
    if (result != null) {
      picture = File(result.files.single.path!);
    } else {}

    if (picture != null) {
      int sizeInBytes = picture!.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      if (sizeInMb > 15) {
        picture = past;
        showDialog<String>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertPlainDialog(
                title: l.cannotUpload,
                actions: [
                  AlertAction(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: l.ok,
                  )
                ],
                content: l.thisImageSizelarge,
              );
            });
        setState(() {});
      } else {
        setState(() {});
      }
    } else {
      picture = past;
      setState(() {});
    }
  }

  Future getResume() async {
    var result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'docx']);
    if (result != null) {
      resumeFile = File(result.files.single.path!);
    } else {}

    if (resumeFile != null) {
      int sizeInBytes = resumeFile!.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      if (sizeInMb > 5) {
        resumeFile = null;
        showDialog<String>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertPlainDialog(
                title: l.cannotUpload,
                actions: [
                  AlertAction(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: l.ok,
                  )
                ],
                content: l.thisFileSizeLarge,
              );
            });
      } else {
        filename = resumeFile?.path.split('/').last;
      }
    }
  }

  Future selectDOB() async {
    DateTime? onSelect;
    DateTime? past = register.dob;
    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(l.dob,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'PoppinsSemiBold')),
            cancelButton: CupertinoActionSheetAction(
              child: Text(l.cancel,
                  style: const TextStyle(
                    // fontSize: 20,
                    color: Colors.red,
                    // fontFamily: 'PoppinsSemiBold'
                  )),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            ),
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () {
                    if (onSelect == null) {
                      register.dob = DateTime(1999);
                      register.setDOB();
                    } else {
                      register.dob = onSelect;
                      register.setDOB();
                    }

                    Navigator.pop(context);
                  },
                  child: Text(l.save,
                      style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.blue,
                          fontFamily: 'PoppinsMedium'))),
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                // color: AppColors.white,
                child: CupertinoDatePicker(
                  maximumYear: 2020,
                  minimumYear: 1940,
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime(1999),
                  onDateTimeChanged: (value) {
                    onSelect = value;
                  },
                ),
              )
            ],
          );
        });

    register.dob ??= past;
    if (register.dob != null) {
      stringdob = DateFormat('dd-MM-yyyy').format(register.dob!);
    }
    setState(() {
      if (register.dob == null) {
        alertdob = true;
      } else {
        alertdob = false;
      }
    });
  }

  Future alertRunning() async {
    setState(() {
      alertpassword =
          register.password == null || register.password!.length < 8;
      alertnumber = register.number == null || register.number!.length != 8;
      alertemail = register.email == null || !(isEmail(register.email ?? ''));
      alertprofile = picture == null;
      alertKey = register.keySkill == null ||
          register.keySkill!.contains(null) ||
          register.keySkill!.isEmpty;
      alertLang = register.langNameID == null ||
          register.langNameID!.contains(null) ||
          register.langNameID!.isEmpty;
      alertField = register.degreeID == null ||
          register.degreeID!.contains(null) ||
          register.degreeID!.isEmpty;
      alertTotalExp = register.totalWorkEXP == null ||
          register.totalWorkEXP!.trim().isEmpty;
      alertPreIn = register.previousIndustry == null ||
          register.previousIndustry!.contains(null) ||
          register.previousIndustry!.isEmpty;
      alertPreEm = register.previousEmployer == null ||
          register.previousEmployer!.contains(null) ||
          register.previousEmployer!.isEmpty;
      alertPrejob = register.previousJobTitle == null ||
          register.previousJobTitle!.contains(null) ||
          register.previousJobTitle!.isEmpty;
      alertLatestJob = register.latestJobTitle == null ||
          register.latestJobTitle!.trim().isEmpty;

      alertsalary = register.salary == null;
      alertEdu = !addEdu!;
      alertWorkExp = !addWorkEXP!;
      alertcv = register.cv == null;
      alertprofsum =
          register.profSummary == null || register.profSummary!.trim().isEmpty;
      alertdistrict = register.districtOrCityID == null;

      alertprovince = register.provinceOrStateID == null;
      // alertlicense =
      //     register.drivingLicense == null || register.drivingLicense == [];
      alertfullname = register.firstname == null ||
          register.firstname!.trim().isEmpty ||
          register.lastname == null ||
          register.lastname!.trim().isEmpty;
      alertgender = register.genderID == null;
      alertdob = register.dob == null;
      alertmarital = register.maritalStatusID == null;
    });
  }

  Future alertRunningOldUser() async {
    setState(() {
      alertnumber = register.number == null || register.number!.length != 8;

      alertprofile = picture == null;
      alertKey = register.keySkill == null ||
          register.keySkill!.contains(null) ||
          register.keySkill!.isEmpty;
      alertLang = register.langNameID == null ||
          register.langNameID!.contains(null) ||
          register.langNameID!.isEmpty;
      alertField = register.degreeID == null ||
          register.degreeID!.contains(null) ||
          register.degreeID!.isEmpty;
      alertTotalExp = register.totalWorkEXP == null ||
          register.totalWorkEXP!.trim().isEmpty;
      alertPreIn = register.previousIndustry == null ||
          register.previousIndustry!.contains(null) ||
          register.previousIndustry!.isEmpty;
      alertPreEm = register.previousEmployer == null ||
          register.previousEmployer!.contains(null) ||
          register.previousEmployer!.isEmpty;
      alertPrejob = register.previousJobTitle == null ||
          register.previousJobTitle!.contains(null) ||
          register.previousJobTitle!.isEmpty;
      alertLatestJob = register.latestJobTitle == null ||
          register.latestJobTitle!.trim().isEmpty;

      alertsalary = register.salary == null;
      alertEdu = !addEdu!;
      alertWorkExp = !addWorkEXP!;
      alertcv = register.cv == null;
      alertprofsum =
          register.profSummary == null || register.profSummary!.trim().isEmpty;
      alertdistrict = register.districtOrCityID == null;

      alertprovince = register.provinceOrStateID == null;
      // alertlicense =
      //     register.drivingLicense == null || register.drivingLicense == [];
      alertfullname = register.firstname == null ||
          register.firstname!.trim().isEmpty ||
          register.lastname == null ||
          register.lastname!.trim().isEmpty;
      alertgender = register.genderID == null;
      alertdob = register.dob == null;
      alertmarital = register.maritalStatusID == null;
    });
  }

  readingData() async {
    await register.getAll().then((value) {
      String? maritalStatus, gender, province, district;
      maritalStatus = register.maritalStatus;
      gender = register.gender;
      province = register.provinceOrState;
      district = register.districtOrCity;
      register.gender = null;
      register.maritalStatus = null;
      register.provinceOrState = null;
      register.districtOrCity = null;
      if (register.havedata) {
        WidgetsBinding.instance?.addPostFrameCallback((_) async {
          await showDialog<String>(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                    onWillPop: () async {
                      setState(() {
                        register.maritalStatus = maritalStatus;
                        register.gender = gender;
                        register.provinceOrState = province;
                        register.districtOrCity = district;
                        emailControl.text = register.email ?? '';
                        numberControl.text = register.number ?? '';

                        try {
                          if (register.dob != null) {
                            stringdob =
                                DateFormat('dd-MM-yyyy').format(register.dob!);
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                        if (register.latestJobTitle != null ||
                            register.previousJobTitle != null ||
                            register.previousIndustry != null ||
                            register.previousEmployer != null ||
                            register.totalWorkEXP != null) {
                          addWorkEXP = true;
                        }
                        if (register.fieldstudyDegree != null ||
                            register.fieldstudyName != null ||
                            register.degreeID != null) {
                          addEdu = true;
                        }
                        showFieldStudy = setShowFieldStudy(
                            register.fieldstudyName, register.fieldstudyDegree);
                        showLang =
                            setShowLang(register.langName, register.langLevel);
                      });
                      Navigator.pop(context);

                      return true;
                    },
                    child: AlertPlainDialog(
                      title: l.recoveryAlert,
                      content: l.youalrealfilled,
                      actions: [
                        AlertAction(
                          title: l.continues,
                          onTap: () {
                            setState(() {
                              register.maritalStatus = maritalStatus;
                              register.gender = gender;
                              register.provinceOrState = province;
                              register.districtOrCity = district;
                              emailControl.text = register.email ?? '';
                              numberControl.text = register.number ?? '';

                              try {
                                if (register.dob != null) {
                                  stringdob = DateFormat('dd-MM-yyyy')
                                      .format(register.dob!);
                                }
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                              if (register.latestJobTitle != null ||
                                  register.previousJobTitle != null ||
                                  register.previousIndustry != null ||
                                  register.previousEmployer != null ||
                                  register.totalWorkEXP != null ||
                                  register.salary != null) {
                                addWorkEXP = true;
                              }
                              if (register.fieldstudyDegree != null ||
                                  register.fieldstudyName != null ||
                                  register.degreeID != null) {
                                addEdu = true;
                              }
                              showFieldStudy = setShowFieldStudy(
                                  register.fieldstudyName,
                                  register.fieldstudyDegree);
                              showLang = setShowLang(
                                  register.langName, register.langLevel);
                            });
                            Navigator.pop(context);
                          },
                        ),
                        AlertAction(
                          onTap: () {
                            setState(() {
                              register.removeAll().then((value) {
                                register.getAll();
                              });
                            });
                            Navigator.pop(context);
                          },
                          title: l.cancel,
                        )
                      ],
                    ));
              });
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    scroll = ScrollController();

    if (widget.isOlduser) {
    } else {
      readingData();
    }
  }

  FocusScopeNode currentFocus = FocusScopeNode();
////// end function
  @override
  Widget build(BuildContext context) {
    // LoadingDialog loading = LoadingDialog(
    //     barrierDismissible: false,
    //     loadingView: Container(
    //       height: mediaWidthSized(context, 8),
    //       width: mediaWidthSized(context, 8),
    //       child: CircularProgressIndicator(
    //         strokeWidth: mediaWidthSized(context, 80),
    //         valueColor: AlwaysStoppedAnimation(AppColors.Blue),
    //       ),
    //     ),
    //     elevation: 5,
    //     radius: 15,
    //     loadingMessage: '\n\n${l.uploadingInfo}',
    //     buildContext: context,
    //     height: mediaWidthSized(context, 3),
    //     width: mediaWidthSized(context, 2));

    return WillPopScope(
      onWillPop: () async {
        if (isLoading == true) {
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.white,
                appBar: PreferredSize(
                    child: AppBar(
                      backgroundColor: AppColors.white,
                      iconTheme: const IconThemeData(
                        color: AppColors.grey,
                      ),
                      elevation: 0,
                    ),
                    preferredSize: Size.fromHeight(appbarsize(context))),
                body: SingleChildScrollView(
                  controller: scroll,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width),
                      const SizedBox(
                        height: 20,
                      ),
                      Avatar(
                        ontap: () {
                          currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          selectpicturefrom(
                            context,
                            onPress1: () {
                              selectImage(ImageSource.camera);

                              Navigator.pop(context);
                            },
                            onPress2: () {
                              selectImage(ImageSource.gallery);
                              Navigator.pop(context, 'Cancel');
                            },
                          ).then((value) {
                            setState(() {});
                          });
                        },
                        picture: picture,
                      ),
                      Visibility(
                        visible: alertprofile!,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(l.enterProfile,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: mediaWidthSized(context, 40),
                                      color: Colors.red,
                                      fontFamily: 'PoppinsRegular')),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: !widget.isOlduser,
                        child: Column(
                          children: [
                            TextTitle(
                              title: l.loginConfidential,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            NormalTextField(
                              autofocus: false,
                              onChanged: (value) {
                                register.email = value;
                                alertemail = register.email == null ||
                                    !(isEmail(register.email!));

                                register.setEmail();
                                setState(() {});
                              },
                              obscure: false,
                              controller: emailControl,
                              hintIcon: 'envelope',
                              hintText: l.emailAdd,
                              title: l.email,
                            ),
                            Visibility(
                              visible: alertemail!,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Text(l.entervalidEmail,
                                      style: TextStyle(
                                          fontSize:
                                              mediaWidthSized(context, 40),
                                          color: Colors.red,
                                          fontFamily: 'PoppinsRegular')),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            PhoneTextField(
                              title: l.mobileNumber,
                              hintText: l.number,
                              onChanged: (value) {
                                register.number = value;
                                alertnumber = register.number == null ||
                                    register.number!.length != 8;

                                register.setNumber();
                                setState(() {});
                              },
                              controller: numberControl,
                            ),
                            Visibility(
                              visible: alertnumber!,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Text(l.numberMust,
                                      style: TextStyle(
                                          fontSize:
                                              mediaWidthSized(context, 40),
                                          color: Colors.red,
                                          fontFamily: 'PoppinsRegular')),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            NormalTextField(
                              autofocus: false,
                              title: l.password,
                              obscure: obscurePassword,
                              onTap: () {
                                setState(() {
                                  if (obscurePassword!) {
                                    obscurePassword = false;
                                  } else {
                                    obscurePassword = true;
                                  }
                                });
                              },
                              hintIcon: 'eye',
                              hintText: l.password,
                              onChanged: (value) {
                                register.password = value;
                                alertpassword = register.password == null ||
                                    value.length < 8;
                                setState(() {});
                              },
                              controller: passwordControl,
                            ),
                            Visibility(
                              visible: alertpassword!,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Text(l.passwordMust,
                                      style: TextStyle(
                                          fontSize:
                                              mediaWidthSized(context, 40),
                                          color: Colors.red,
                                          fontFamily: 'PoppinsRegular')),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.isOlduser,
                        child: Column(
                          children: [
                            TextTitle(
                              title: l.loginConfidential,
                            ),
                            PhoneTextField(
                              title: l.mobileNumber,
                              hintText: l.number,
                              onChanged: (value) {
                                register.number = value;
                                alertnumber = register.number == null ||
                                    register.number!.length != 8;

                                register.setNumber();
                                setState(() {});
                              },
                              controller: numberControl,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      TextTitle(
                        title: l.personalinfo,
                      ),
                      WidgetTabInfo(
                        alertvisible: alertfullname,
                        alertText: l.enterValidfulname,
                        onTap: () {
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const InputFullName(true)),
                          ).then((value) {
                            register.getFirstName();
                            register.getLastName().then((value) {
                              alertfullname =
                                  isEmptyString(register.firstname) ||
                                      isEmptyString(register.lastname);
                              setState(() {});
                            });
                          });
                        },
                        icon: 'chevron-right ',
                        header: l.fullname,
                        showField: (!isEmptyString(register.firstname) &&
                                !isEmptyString(register.firstname))
                            ? '${register.firstname} ${register.lastname}'
                            : !isEmptyString(register.firstname)
                                ? '${register.firstname}'
                                : !isEmptyString(register.lastname)
                                    ? '${register.lastname}'
                                    : null,
                      ),
                      WidgetTabInfo(
                        alertvisible: alertdob,
                        alertText: l.enterdob,
                        onTap: () {
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          selectDOB();
                        },
                        icon: 'chevron-right ',
                        header: l.dob,
                        showField:
                            stringdob!.trim().isEmpty ? null : '$stringdob',
                      ),
                      Query(
                        options: QueryOptions(
                            document: gql(queryInfo.getReuse),
                            variables: <String, dynamic>{
                              "types": "Gender",
                              "lanOption": indexL == 0 ? "EN" : "LA"
                            }),
                        builder: (QueryResult result, {refetch, fetchMore}) {
                          if (result.hasException) {
                            return Text(result.exception.toString());
                          }
                          if (result.isLoading) {
                            return WidgetTabInfo(
                              alertvisible: alertgender,
                              alertText: l.enterGender,
                              icon: 'chevron-right ',
                              header: l.gender,
                              showField: isEmptyString(register.gender)
                                  ? null
                                  : '${register.gender}',
                            );
                          }
                          List repositories = result.data?['getReuseList'];
                          genderActions = [];
                          for (var element in repositories) {
                            genderActions?.add(
                              CupertinoActionSheetAction(
                                  onPressed: () {
                                    register.genderID = '${element['_id']}';
                                    register.gender = '${element['name']}';
                                    register.setGender();
                                    register.setGenderID();
                                    alertgender = register.genderID == null;
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: Text('${element['name']}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: AppColors.blue,
                                          fontFamily: 'PoppinsMedium'))),
                            );
                          }

                          return WidgetTabInfo(
                            alertvisible: alertgender,
                            alertText: l.enterGender,
                            onTap: () {
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              showDialogPickerText(
                                      genderActions!, context, l.gender)
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            icon: 'chevron-right ',
                            header: l.gender,
                            showField: isEmptyString(register.gender)
                                ? null
                                : '${register.gender}',
                          );
                        },
                      ),
                      Query(
                        options: QueryOptions(
                            document: gql(queryInfo.getReuse),
                            variables: <String, dynamic>{
                              "types": "MaritalStatus",
                              "lanOption": indexL == 0 ? "EN" : "LA"
                            }),
                        builder: (QueryResult result, {refetch, fetchMore}) {
                          if (result.hasException) {
                            return Text(result.exception.toString());
                          }
                          if (result.isLoading) {
                            return WidgetTabInfo(
                              alertvisible: alertmarital,
                              alertText: l.enterMarital,
                              icon: 'chevron-right ',
                              header: l.maritalstt,
                              showField: isEmptyString(register.maritalStatus)
                                  ? null
                                  : '${register.maritalStatus}',
                            );
                          }
                          List? repositories = result.data?['getReuseList'];
                          mStatusActions = [];
                          repositories?.forEach((element) {
                            mStatusActions?.add(
                              CupertinoActionSheetAction(
                                  onPressed: () {
                                    register.maritalStatusID =
                                        '${element['_id']}';
                                    register.maritalStatus =
                                        '${element['name']}';
                                    register.setMaritalStatusID();
                                    register.setMaritalStatus();
                                    alertmarital =
                                        register.maritalStatusID == null;
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: Text('${element['name']}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: AppColors.blue,
                                          fontFamily: 'PoppinsMedium'))),
                            );
                          });

                          return WidgetTabInfo(
                            alertvisible: alertmarital,
                            alertText: l.enterMarital,
                            onTap: () {
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              showDialogPickerText(
                                  mStatusActions!, context, l.maritalstt);
                            },
                            icon: 'chevron-right ',
                            header: l.maritalstt,
                            showField: isEmptyString(register.maritalStatus)
                                ? null
                                : '${register.maritalStatus}',
                          );
                        },
                      ),
                      WidgetTabInfo(
                        alertText: l.enterDriving,
                        alertvisible: false,
                        onTap: () {
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const InputDrivingLicense(true)),
                          ).then((context) {
                            setState(() {
                              register.getDrivingLicense().then((value) {
                                // f = register.drivingLicense == null ||
                                //     register.drivingLicense == [];
                              });
                            });
                          });
                        },
                        icon: 'chevron-right ',
                        header: l.drivinglic,
                        showField: register.drivingLicense == null
                            ? null
                            : '${register.drivingLicense?.join(', ')}',
                      ),
                      Query(
                        options: QueryOptions(
                            document: gql(queryInfo.getProvinceDistrict),
                            variables: <String, dynamic>{}),
                        builder: (QueryResult result, {refetch, fetchMore}) {
                          if (result.hasException) {
                            return Text(result.exception.toString());
                          }
                          if (result.isLoading) {
                            return WidgetTabInfo(
                                alertvisible: alertprovince,
                                alertText: l.enterProvince,
                                icon: 'chevron-right ',
                                header: l.province,
                                showField: isEmptyString(
                                        register.provinceOrState)
                                    ? null
                                    : '${TranslateQuery.translateProvince(register.provinceOrState!)}');
                          }

                          return WidgetTabInfo(
                              alertvisible: alertprovince,
                              alertText: l.enterProvince,
                              onTap: () async {
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          InputProvinceState(result, true)),
                                ).then((context) {
                                  register.getDistrictRepoindex();
                                  register.getProvinceOrStateID();
                                  register.getProvinceOrState().then((value) {
                                    setState(() {
                                      alertprovince =
                                          register.provinceOrStateID == null;
                                    });
                                  });
                                });
                              },
                              icon: 'chevron-right ',
                              header: l.province,
                              showField: isEmptyString(register.provinceOrState)
                                  ? null
                                  : '${TranslateQuery.translateProvince(register.provinceOrState!)}');
                        },
                      ),
                      Visibility(
                        visible: register.districtRepoindex != null,
                        child: Query(
                          options: QueryOptions(
                              document: gql(queryInfo.getProvinceDistrict),
                              variables: <String, dynamic>{}),
                          builder: (QueryResult result, {refetch, fetchMore}) {
                            if (result.hasException) {
                              return Text(result.exception.toString());
                            }
                            if (result.isLoading) {
                              return WidgetTabInfo(
                                  alertvisible: alertdistrict,
                                  alertText: l.enterDistrict,
                                  icon: 'chevron-right ',
                                  header: l.district,
                                  showField:
                                      isEmptyString(register.districtOrCity)
                                          ? null
                                          : '${register.districtOrCity}');
                            }
                            final repoDistrict = result.data?['getProvinces']
                                [register.districtRepoindex];

                            return WidgetTabInfo(
                                alertvisible: alertdistrict,
                                alertText: l.enterDistrict,
                                onTap: () async {
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InputDistrictCity(
                                            repoDistrict, true)),
                                  ).then((context) {
                                    setState(() {
                                      register.getDistrictOrCity();
                                      register
                                          .getDistrictOrCityID()
                                          .then((value) {
                                        setState(() {
                                          alertdistrict =
                                              register.districtOrCityID == null;
                                        });
                                      });
                                    });
                                  });
                                },
                                icon: 'chevron-right ',
                                header: l.district,
                                showField:
                                    isEmptyString(register.districtOrCity)
                                        ? null
                                        : '${register.districtOrCity}');
                          },
                        ),
                      ),
                      Visibility(
                        visible: !(register.districtRepoindex != null),
                        child: WidgetTabInfo(
                            alertvisible: alertdistrict,
                            alertText: l.enterDistrict,
                            color: isEmptyString(register.districtOrCity)
                                ? AppColors.greyOpacity
                                : Colors.black,
                            icon: 'chevron-right ',
                            header: l.district,
                            showField: null),
                      ),
                      WidgetTabInfo(
                          alertvisible: alertprofsum,
                          alertText: l.enterProfesum,
                          onTap: () {
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const InputPrfSummary(true)),
                            ).then((value) {
                              setState(() {
                                register.getProfSummary().then((value) {
                                  alertprofsum = register.profSummary == null ||
                                      register.profSummary!.trim().isEmpty;
                                });
                              });
                            });
                          },
                          icon: 'chevron-right ',
                          header: l.profesSum,
                          showField: isEmptyString(register.profSummary)
                              ? null
                              : '${register.profSummary}'),
                      const SizedBox(
                        height: 40,
                      ),
                      Fade(
                          duration: const Duration(milliseconds: 300),
                          visible: resumeFile != null,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                TextTitle(
                                  title: l.uploadCv,
                                  margin: 0,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            '   File-pdf ',
                                            style: TextStyle(
                                              fontFamily: 'FontAwesomeProSolid',
                                              fontSize:
                                                  mediaWidthSized(context, 26),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '$filename',
                                              style: TextStyle(
                                                fontFamily: 'PoppinsSemiBold',
                                                fontSize: mediaWidthSized(
                                                    context, 26),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Text('trash',
                                          style: TextStyle(
                                            fontFamily: 'FontAwesomeProRegular',
                                            color: AppColors.yellow,
                                            fontSize:
                                                mediaWidthSized(context, 26),
                                          )),
                                      onPressed: () {
                                        resumeFile = null;
                                        register.cv = null;
                                        filename = '';
                                        setState(() {});
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                      Fade(
                        duration: const Duration(milliseconds: 300),
                        visible: resumeFile == null,
                        child: DottedContainer(
                          alert: alertcv,
                          onTap: () {
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            getResume().then((value) {
                              register.cv = resumeFile;
                              alertcv = register.cv == null;

                              setState(() {});
                            });
                          },
                          addCaption: l.selectfile,
                          title: l.uploadCv,
                          description: l.supportfileCV,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Fade(
                        duration: const Duration(milliseconds: 300),
                        visible: addWorkEXP!,
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            TextTitle(
                              title: l.workingexp,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 40,
                                  // color: Colors.red,
                                  child: Checkbox(
                                    value: noHaveWorkExp,
                                    onChanged: (newValue) {
                                      setState(() {
                                        noHaveWorkExp = newValue;
                                      });
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    if (noHaveWorkExp == false) {
                                      noHaveWorkExp = true;
                                    } else {
                                      noHaveWorkExp = false;
                                    }
                                    setState(() {});
                                  },
                                  child: Text(
                                    l.idontworkingexp,
                                    style: TextStyle(
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: mediaWidthSized(context, 30),
                                        color: AppColors.grey),
                                  ),
                                ),
                              ],
                            ),
                            Fade(
                              duration: const Duration(milliseconds: 300),
                              visible: !noHaveWorkExp!,
                              child: ListBody(
                                children: [
                                  WidgetTabInfo(
                                    alertvisible: alertLatestJob,
                                    alertText: l.enterLatest,
                                    showField:
                                        isEmptyString(register.latestJobTitle)
                                            ? null
                                            : '${register.latestJobTitle}',
                                    onTap: () {
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const InputLatestJobTitle(
                                                    true)),
                                      ).then((context) {
                                        setState(() {
                                          register
                                              .getLatestJobTitle()
                                              .then((value) {
                                            setState(() {
                                              alertLatestJob =
                                                  register.latestJobTitle ==
                                                          null ||
                                                      register.latestJobTitle!
                                                          .trim()
                                                          .isEmpty;
                                            });
                                          });
                                        });
                                      });
                                    },
                                    icon: 'plus ',
                                    header: l.latestjob,
                                  ),
                                  Query(
                                    options: QueryOptions(
                                        document: gql(queryInfo.getReuse),
                                        variables: <String, dynamic>{
                                          "types": "SalaryRange",
                                          "lanOption": indexL == 0 ? "EN" : "LA"
                                        }),
                                    builder: (QueryResult result,
                                        {refetch, fetchMore}) {
                                      if (result.hasException) {
                                        return Text(
                                            result.exception.toString());
                                      }
                                      if (result.isLoading) {
                                        return WidgetTabInfo(
                                          alertText: l.enterSalary,
                                          alertvisible: alertsalary,
                                          icon: 'plus',
                                          header: l.salaryRange,
                                          showField: register.salary,
                                        );
                                      }
                                      List repositories =
                                          result.data?["getReuseList"];
                                      return WidgetTabInfo(
                                        alertText: l.enterSalary,
                                        alertvisible: alertsalary,
                                        icon: 'plus',
                                        header: l.salaryRange,
                                        showField: register.salary,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    InputSalaryRange(
                                                        repositories, true)),
                                          ).then((context) {
                                            setState(() {
                                              register.getSalary();
                                              register
                                                  .getSalaryID()
                                                  .then((value) {
                                                setState(() {
                                                  alertsalary =
                                                      register.salaryID == null;
                                                });
                                              });
                                            });
                                          });
                                        },
                                      );
                                    },
                                  ),
                                  WidgetTabInfo(
                                      alertvisible: alertPrejob,
                                      alertText: l.enterPreJob,
                                      onTap: () {
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const InputPreviousJob(true)),
                                        ).then((context) {
                                          setState(() {
                                            register
                                                .getPreviousJobTitle()
                                                .then((value) {
                                              setState(() {
                                                alertPrejob = register
                                                            .previousJobTitle ==
                                                        null ||
                                                    register.previousJobTitle!
                                                        .contains(null) ||
                                                    register.previousJobTitle!
                                                        .isEmpty;
                                              });
                                            });
                                          });
                                        });
                                      },
                                      showField: register.previousJobTitle ==
                                              null
                                          ? null
                                          : '${register.previousJobTitle?.join('\n')}',
                                      icon: 'plus ',
                                      header: l.previousJobTitle),
                                  WidgetTabInfo(
                                      alertvisible: alertPreEm,
                                      alertText: l.enterPreEmp,
                                      onTap: () {
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const InputPreviousEMP(true)),
                                        ).then((context) {
                                          register
                                              .getPreviousEmployer()
                                              .then((value) {
                                            setState(() {
                                              alertPreEm =
                                                  register.previousEmployer ==
                                                          null ||
                                                      register.previousEmployer!
                                                          .contains(null) ||
                                                      register.previousEmployer!
                                                          .isEmpty;
                                            });
                                          });
                                        });
                                      },
                                      showField: register.previousEmployer ==
                                              null
                                          ? null
                                          : '${register.previousEmployer?.join('\n')}',
                                      icon: 'plus ',
                                      header: l.previousEmployer),
                                  Query(
                                    options: QueryOptions(
                                        document: gql(queryInfo.getReuse),
                                        variables: <String, dynamic>{
                                          "types": "Industry",
                                          "lanOption": indexL == 0 ? "EN" : "LA"
                                        }),
                                    builder: (QueryResult result,
                                        {refetch, fetchMore}) {
                                      if (result.hasException) {
                                        return Text(
                                            result.exception.toString());
                                      }
                                      if (result.isLoading) {
                                        return WidgetTabInfo(
                                            alertvisible: alertPreIn,
                                            alertText: l.enterPreEmpInd,
                                            showField: register
                                                        .previousIndustry ==
                                                    null
                                                ? null
                                                : '${register.previousIndustry?.join('\n')}',
                                            icon: 'plus ',
                                            header: l.previousIndustry);
                                      }
                                      List repositories =
                                          result.data?["getReuseList"];
                                      return WidgetTabInfo(
                                        alertvisible: alertPreIn,
                                        alertText: l.enterPreEmpInd,
                                        onTap: () {
                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    InputPreEmpIndustry(
                                                        repositories, true)),
                                          ).then((context) {
                                            register.getPreviousIndID();
                                            register
                                                .getPreviousIndustry()
                                                .then((value) {
                                              setState(() {
                                                alertPreIn = register
                                                            .previousIndustry ==
                                                        null ||
                                                    register.previousIndustry!
                                                        .contains(null) ||
                                                    register.previousIndustry!
                                                        .isEmpty;
                                              });
                                            });
                                          });
                                        },
                                        showField: register.previousIndustry ==
                                                null
                                            ? null
                                            : '${register.previousIndustry?.join('\n')}',
                                        icon: 'plus ',
                                        header: l.previousIndustry,
                                      );
                                    },
                                  ),
                                  WidgetTabInfo(
                                      alertvisible: alertTotalExp,
                                      alertText: l.enterTotalEXP,
                                      onTap: () {
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const InputTotalWorkEXP(
                                                      true)),
                                        ).then((context) {
                                          register
                                              .getTotalWorkEXP()
                                              .then((value) {
                                            setState(() {
                                              alertTotalExp =
                                                  register.totalWorkEXP ==
                                                          null ||
                                                      register.totalWorkEXP!
                                                          .trim()
                                                          .isEmpty;
                                            });
                                          });
                                        });
                                      },
                                      showField:
                                          isEmptyString(register.totalWorkEXP)
                                              ? null
                                              : '${register.totalWorkEXP}',
                                      icon: 'plus ',
                                      header: l.totalWorkingExperience),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !addWorkEXP!,
                        child: DottedContainer(
                          alert: alertWorkExp,
                          onTap: () {
                            setState(() {
                              addWorkEXP = true;
                            });
                          },
                          addCaption: l.addEXP,
                          title: l.workingexp,
                          description: l.addworkingEXP,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Fade(
                        duration: const Duration(milliseconds: 300),
                        visible: addEdu!,
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            TextTitle(
                              title: l.education,
                            ),
                            Query(
                              options: QueryOptions(
                                  document: gql(queryInfo.getReuse),
                                  variables: <String, dynamic>{
                                    "types": "Degree",
                                    "lanOption": indexL == 0 ? "EN" : "LA"
                                  }),
                              builder: (QueryResult result,
                                  {refetch, fetchMore}) {
                                if (result.hasException) {
                                  return Text(result.exception.toString());
                                }
                                if (result.isLoading) {
                                  return WidgetTabInfo(
                                      alertvisible: alertField,
                                      alertText: l.enterfieldofStudy,
                                      showField: showFieldStudy != null
                                          ? '${showFieldStudy?.join('\n')}'
                                          : null,
                                      icon: 'plus ',
                                      header: l.fieldofStudy);
                                }
                                List repositories =
                                    result.data?["getReuseList"];
                                return WidgetTabInfo(
                                    alertvisible: alertField,
                                    alertText: l.enterfieldofStudy,
                                    onTap: () {
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                InputFieldStudy(
                                                    repositories, true)),
                                      ).then((context) {
                                        setState(() {
                                          register.getdegreeID();
                                          register.getFieldstudyName();
                                          register
                                              .getFieldstudyDegree()
                                              .then((value) {
                                            showFieldStudy = setShowFieldStudy(
                                                register.fieldstudyName,
                                                register.fieldstudyDegree);
                                            alertField =
                                                register.degreeID == null ||
                                                    register.degreeID!
                                                        .contains(null) ||
                                                    register.degreeID!.isEmpty;
                                          });
                                        });
                                      });
                                    },
                                    showField: showFieldStudy != null
                                        ? '${showFieldStudy?.join('\n')}'
                                        : null,
                                    icon: 'plus ',
                                    header: l.fieldofStudy);
                              },
                            ),
                            Query(
                              options: QueryOptions(
                                  document: gql(queryInfo.getReuse),
                                  variables: <String, dynamic>{
                                    "types": "Language",
                                    "lanOption": indexL == 0 ? "EN" : "LA"
                                  }),
                              builder: (QueryResult result,
                                  {refetch, fetchMore}) {
                                if (result.hasException) {
                                  return Text(result.exception.toString());
                                }
                                if (result.isLoading) {
                                  return WidgetTabInfo(
                                      alertvisible: alertLang,
                                      alertText: l.enterLanguage,
                                      showField: showLang != null
                                          ? '${showLang?.join('\n')}'
                                          : null,
                                      icon: 'plus ',
                                      header: l.language);
                                }
                                List repositoriesLanguage =
                                    result.data?["getReuseList"];
                                return Query(
                                  options: QueryOptions(
                                      document: gql(queryInfo.getReuse),
                                      variables: <String, dynamic>{
                                        "types": "LanguageLevel",
                                        "lanOption": indexL == 0 ? "EN" : "LA"
                                      }),
                                  builder: (QueryResult result2,
                                      {refetch, fetchMore}) {
                                    if (result2.hasException) {
                                      return Text(result2.exception.toString());
                                    }
                                    if (result2.isLoading) {
                                      return WidgetTabInfo(
                                          alertvisible: alertLang,
                                          alertText: l.enterLanguage,
                                          showField: showLang != null
                                              ? '${showLang?.join('\n')}'
                                              : null,
                                          icon: 'plus ',
                                          header: l.language);
                                    }
                                    List repositoriesLangLevel =
                                        result2.data?["getReuseList"];
                                    return WidgetTabInfo(
                                        alertvisible: alertLang,
                                        alertText: l.enterLanguage,
                                        onTap: () {
                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    InputLanguage(
                                                      repositoriesLang:
                                                          repositoriesLanguage,
                                                      repositoriesLangLevel:
                                                          repositoriesLangLevel,
                                                      fromRegister: true,
                                                    )),
                                          ).then((context) {
                                            setState(() {
                                              register.getLangName();
                                              register.getLangNameID();
                                              register.getLangLevel();
                                              register
                                                  .getLangLevelID()
                                                  .then((value) {
                                                alertLang =
                                                    register.langNameID ==
                                                            null ||
                                                        register.langNameID!
                                                            .contains(null) ||
                                                        register.langNameID!
                                                            .isEmpty;
                                                showLang = setShowLang(
                                                    register.langName,
                                                    register.langLevel);
                                              });
                                            });
                                          });
                                        },
                                        showField: showLang != null
                                            ? '${showLang?.join('\n')}'
                                            : null,
                                        icon: 'plus ',
                                        header: l.language);
                                  },
                                );
                              },
                            ),
                            WidgetTabInfo(
                                alertvisible: alertKey,
                                alertText: l.enterkeySkill,
                                onTap: () {
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const InputKeySkill(true)),
                                  ).then((context) {
                                    register.getkeySkill().then((value) {
                                      setState(() {
                                        alertKey = register.keySkill == null ||
                                            register.keySkill!.contains(null) ||
                                            register.keySkill!.isEmpty;
                                      });
                                    });
                                  });
                                },
                                showField: register.keySkill == null
                                    ? null
                                    : '${register.keySkill?.join('\n')}',
                                icon: 'plus ',
                                header: l.keySkill),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !addEdu!,
                        child: DottedContainer(
                          alert: alertEdu,
                          onTap: () {
                            setState(() {
                              addEdu = true;
                            });
                          },
                          title: l.education,
                          description: l.tellusEdu,
                          addCaption: l.addedu,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Visibility(
                        visible: widget.isOlduser,
                        child: Mutation(
                          options: MutationOptions(
                            update: (cache, result) {
                              debugPrint(cache.toString());
                            },
                            document: gql(queryInfo.updateOldUser),
                            onCompleted: (resultData) async {
                              Future.delayed(const Duration(seconds: 1))
                                  .then((value) {
                                isLoading = false;
                                setState(() {});
                              });
                              if (resultData.toString() != 'null') {
                                register.removeAll();
                                register.getAll().then((value) {
                                  reloadprofilePage = true;
                                  resume = null;
                                  resumeFile = null;
                                  picture = null;
                                  image = null;
                                  noHaveWorkExp = false;
                                  setState(() {});
                                });
                                showDialog<String>(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertPlainDialog(
                                          title: l.alert,
                                          actions: [
                                            AlertAction(
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              title: l.ok,
                                            )
                                          ],
                                          content: indexL == 0
                                              ? 'Success'
                                              : 'ສຳເລັດ');
                                    });
                              }
                            },
                            onError: (error) {
                              Future.delayed(const Duration(seconds: 1))
                                  .then((value) {
                                Navigator.pop(context);
                              });
                              debugPrint('error' + error.toString());
                            },
                          ),
                          builder: (RunMutation runMutation, result) {
                            return BlueButton(
                              onPressed: () {
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                alertRunningOldUser().then((value) async {
                                  // var image, resume;
                                  if (!alertnumber! &&
                                      !alertfullname! &&
                                      !alertdob! &&
                                      !alertgender! &&
                                      !alertmarital! &&
                                      // !alertlicense &&
                                      !alertprovince! &&
                                      !alertdistrict! &&
                                      !alertprofile! &&
                                      !alertprofsum! &&
                                      !alertcv! &&
                                      !alertWorkExp! &&
                                      (noHaveWorkExp! ||
                                          (!alertLatestJob! &&
                                                  !alertPreEm! &&
                                                  !alertsalary! &&
                                                  !alertPreIn! &&
                                                  !alertPrejob! &&
                                                  !alertTotalExp!) &&
                                              !alertEdu! &&
                                              !alertField! &&
                                              !alertLang! &&
                                              !alertKey!)) {
                                    isLoading = true;
                                    setState(() {});
                                    try {
                                      FormData formData = FormData.fromMap({
                                        "image": await MultipartFile.fromFile(
                                            picture!.path,
                                            filename:
                                                picture!.path.split("/").last,
                                            contentType:
                                                MediaType('image', 'jpg')),
                                      });
                                      dynamic responseImage = await Dio().post(
                                        queryInfo.apiUpLoadImage,
                                        data: formData,
                                        onSendProgress: (count, total) {
                                          imagePercent = count / total * 100;
                                          setState(() {});
                                          debugPrint(imagePercent.toString());
                                        },
                                      );

                                      image = responseImage.data;
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
                                    try {
                                      FormData formData = FormData.fromMap({
                                        "file": await MultipartFile.fromFile(
                                          resumeFile!.path,
                                          filename:
                                              resumeFile!.path.split("/").last,
                                        ),
                                      });

                                      dynamic response = await Dio().post(
                                        queryInfo.apiUpLoadResume,
                                        data: formData,
                                        onSendProgress: (count, total) {
                                          resumePercent = count / total * 100;
                                          debugPrint(resumePercent.toString());
                                          setState(() {});
                                        },
                                      );

                                      resume = response.data['myFile'];

                                      setState(() {});
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
                                    // await upLoadDioImage(picture.path,
                                    //         queryInfo.apiUpLoadImage)
                                    //     .then((value) {
                                    //   print(value);
                                    //   image = value;
                                    // });

                                    // resume = value['myFile'];

                                    if (noHaveWorkExp == false) {
                                      runMutation(
                                        queryInfo.updateResumeMutationOldUser(
                                            userID: widget.userID,
                                            degreeID: register.degreeID,
                                            districtID:
                                                register.districtOrCityID,
                                            dob: stringdob,
                                            salaryRangID: register.salaryID,
                                            drivinglicense: register
                                                            .drivingLicense ==
                                                        null ||
                                                    register.drivingLicense ==
                                                        []
                                                ? []
                                                : register.drivingLicense,
                                            fieldstudyname:
                                                register.fieldstudyName,
                                            firstname: register.firstname,
                                            lastname: register.lastname,
                                            file: resume,
                                            keySkill: register.keySkill,
                                            langLevelID: register.langLevelID,
                                            langID: register.langNameID,
                                            latestjob: register.latestJobTitle,
                                            maritalID: register.maritalStatusID,
                                            number: register.number,
                                            logo: image['file'],
                                            previousEmp:
                                                register.previousEmployer,
                                            previousIndID:
                                                register.previousIndID,
                                            previousJob:
                                                register.previousJobTitle,
                                            profsum: register.profSummary,
                                            totalWorkingExp:
                                                register.totalWorkEXP,
                                            genderID: register.genderID),
                                      );
                                    } else {
                                      runMutation(
                                        queryInfo.updateNoExpResumeMutationOldUser(
                                            userID: widget.userID,
                                            degreeID: register.degreeID,
                                            districtID:
                                                register.districtOrCityID,
                                            dob: stringdob,
                                            drivinglicense: register
                                                            .drivingLicense ==
                                                        null ||
                                                    register.drivingLicense ==
                                                        []
                                                ? []
                                                : register.drivingLicense,
                                            fieldstudyname:
                                                register.fieldstudyName,
                                            firstname: register.firstname,
                                            lastname: register.lastname,
                                            file: resume,
                                            keySkill: register.keySkill,
                                            langLevelID: register.langLevelID,
                                            langID: register.langNameID,
                                            maritalID: register.maritalStatusID,
                                            number: register.number,
                                            logo: image['file'],
                                            profsum: register.profSummary,
                                            genderID: register.genderID),
                                      );
                                    }
                                  } else {
                                    showDialog<String>(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertPlainDialog(
                                              title: l.alert,
                                              actions: [
                                                AlertAction(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  title: l.ok,
                                                )
                                              ],
                                              content: l.yourfromnotfinish);
                                        }).then((value) {
                                      scroll.animateTo(
                                          scroll.position.minScrollExtent,
                                          duration: const Duration(
                                              milliseconds: 3000),
                                          curve: Curves.elasticOut);
                                      // scroll.jumpTo(scroll.position.minScrollExtent);
                                    });
                                  }
                                });
                              },
                              title: l.save,
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: !widget.isOlduser,
                        child: Mutation(
                          options: MutationOptions(
                            update: (cache, result) {
                              debugPrint(cache.toString());
                            },
                            document: gql(queryInfo.register),
                            onCompleted: (resultData) async {
                              debugPrint(resultData.toString());
                              Future.delayed(const Duration(seconds: 1))
                                  .then((value) {
                                isLoading = false;
                                setState(() {});
                              });

                              Map<String, dynamic> result = resultData;
                              User user = User();

                              if (resultData != null) {
                                switch (result['addRegisterseekers']) {
                                  case 'This email already registed':
                                    showDialog<String>(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertPlainDialog(
                                              title: l.alert,
                                              actions: [
                                                AlertAction(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    title: l.ok)
                                              ],
                                              content: l.thisEmailAlready);
                                        });
                                    break;
                                  case 'This mobile already registed':
                                    showDialog<String>(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertPlainDialog(
                                              title: l.alert,
                                              actions: [
                                                AlertAction(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    title: l.ok)
                                              ],
                                              content: l.thisNumberAlready);
                                        });
                                    break;

                                  default:
                                    String? number;
                                    number = register.number;
                                    register.removeAll();
                                    register.getAll().then((value) {
                                      resume = null;
                                      resumeFile = null;
                                      picture = null;
                                      image = null;
                                      noHaveWorkExp = false;
                                      setState(() {});
                                    });
                                    user.token = result['addRegisterseekers'];
                                    user.setToken();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VerifyRegisterPage(
                                                number: number!,
                                                justverify: true,
                                                email: emailControl.text,
                                                password: passwordControl.text,
                                              )),
                                    ).then((value) {});
                                }
                              }
                            },
                            onError: (error) {
                              debugPrint(error.toString());
                            },
                          ),
                          builder: (RunMutation runMutation, result) {
                            return BlueButton(
                              onPressed: () {
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                alertRunning().then((value) async {
                                  // var image, resume;

                                  if (!alertemail! &&
                                      !alertnumber! &&
                                      !alertpassword! &&
                                      !alertfullname! &&
                                      !alertdob! &&
                                      !alertgender! &&
                                      !alertmarital! &&
                                      // !alertlicense &&
                                      !alertprovince! &&
                                      !alertdistrict! &&
                                      !alertprofile! &&
                                      !alertprofsum! &&
                                      !alertcv! &&
                                      !alertWorkExp! &&
                                      (noHaveWorkExp! ||
                                          (!alertLatestJob! &&
                                                  !alertPreEm! &&
                                                  !alertsalary! &&
                                                  !alertPreIn! &&
                                                  !alertPrejob! &&
                                                  !alertTotalExp!) &&
                                              !alertEdu! &&
                                              !alertField! &&
                                              !alertLang! &&
                                              !alertKey!)) {
                                    isLoading = true;
                                    setState(() {});
                                    try {
                                      FormData formData = FormData.fromMap({
                                        "image": await MultipartFile.fromFile(
                                            picture!.path,
                                            filename:
                                                picture!.path.split("/").last,
                                            contentType:
                                                MediaType('image', 'jpg')),
                                      });
                                      dynamic responseImage = await Dio().post(
                                        queryInfo.apiUpLoadImage,
                                        data: formData,
                                        onSendProgress: (count, total) {
                                          imagePercent = count / total * 100;
                                          setState(() {});
                                          debugPrint(imagePercent.toString());
                                        },
                                      );

                                      image = responseImage.data;
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
                                    try {
                                      FormData formData = FormData.fromMap({
                                        "file": await MultipartFile.fromFile(
                                          resumeFile!.path,
                                          filename:
                                              resumeFile!.path.split("/").last,
                                        ),
                                      });

                                      dynamic response = await Dio().post(
                                        queryInfo.apiUpLoadResume,
                                        data: formData,
                                        onSendProgress: (count, total) {
                                          resumePercent = count / total * 100;
                                          debugPrint(resumePercent.toString());
                                          setState(() {});
                                        },
                                      );

                                      resume = response?.data['myFile'];

                                      setState(() {});
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }

                                    if (noHaveWorkExp == false) {
                                      runMutation(
                                        queryInfo.registerMutationRun(
                                            degreeID: register.degreeID,
                                            districtcityID:
                                                register.districtOrCityID,
                                            dob: stringdob,
                                            salaryID: register.salaryID,
                                            drivinglicense: register
                                                            .drivingLicense ==
                                                        null ||
                                                    register.drivingLicense ==
                                                        []
                                                ? []
                                                : register.drivingLicense,
                                            email: register.email,
                                            fieldofstudy:
                                                register.fieldstudyName,
                                            firstname: register.firstname,
                                            lastname: register.lastname,
                                            cv: resume,
                                            keyskill: register.keySkill,
                                            langLevelID: register.langLevelID,
                                            languageID: register.langNameID,
                                            latestjob: register.latestJobTitle,
                                            maritalstatusID:
                                                register.maritalStatusID,
                                            mobile: register.number,
                                            password: register.password,
                                            picture: image['file'],
                                            previousEmp:
                                                register.previousEmployer,
                                            previousIndusID:
                                                register.previousIndID,
                                            previousjob:
                                                register.previousJobTitle,
                                            profsum: register.profSummary,
                                            totalWorkExp: register.totalWorkEXP,
                                            genderID: register.genderID),
                                      );
                                    } else {
                                      runMutation(
                                        queryInfo.registerNoExpMutationRun(
                                            degreeID: register.degreeID,
                                            districtcityID:
                                                register.districtOrCityID,
                                            dob: stringdob,
                                            drivinglicense: register
                                                            .drivingLicense ==
                                                        null ||
                                                    register.drivingLicense ==
                                                        []
                                                ? []
                                                : register.drivingLicense,
                                            email: register.email,
                                            fieldofstudy:
                                                register.fieldstudyName,
                                            firstname: register.firstname,
                                            lastname: register.lastname,
                                            cv: resume,
                                            keyskill: register.keySkill,
                                            langLevelID: register.langLevelID,
                                            languageID: register.langNameID,
                                            maritalstatusID:
                                                register.maritalStatusID,
                                            mobile: register.number,
                                            password: register.password,
                                            picture: image['file'],
                                            profsum: register.profSummary,
                                            genderID: register.genderID),
                                      );
                                    }
                                  } else {
                                    showDialog<String>(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertPlainDialog(
                                              title: l.alert,
                                              actions: [
                                                AlertAction(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  title: l.ok,
                                                )
                                              ],
                                              content: l.yourfromnotfinish);
                                        }).then((value) {
                                      scroll.animateTo(
                                          scroll.position.minScrollExtent,
                                          duration: const Duration(
                                              milliseconds: 3000),
                                          curve: Curves.elasticOut);
                                      // scroll.jumpTo(scroll.position.minScrollExtent);
                                    });
                                  }
                                });
                              },
                              title: l.save,
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isLoading!,
                child: Scaffold(
                  backgroundColor: Colors.black54,
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: mediaWidthSized(context, 1.2),
                            height: mediaWidthSized(context, 2),
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(7)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // SizedBox(height: mediaWidthSized(context, 13),),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: mediaWidthSized(context, 20)),
                                    child: Text(
                                      indexL == 0
                                          ? 'Loading...'
                                          : 'ກำລັງໂຫລດ...',
                                      style: TextStyle(
                                          fontSize:
                                              mediaWidthSized(context, 22),
                                          color: Colors.black,
                                          fontFamily: 'PoppinsSemiBold'),
                                    )),

                                const CircularProgressIndicator(
                                    // value: resumePercent / 100,
                                    ),

                                Container(
                                    margin: EdgeInsets.only(
                                        bottom: mediaWidthSized(context, 20)),
                                    child: Text(
                                      image == null && picture != null
                                          ? "Upload image: ${imagePercent?.toInt().toString()} %"
                                          : resume == null && resumeFile != null
                                              ? "Upload CV: ${resumePercent?.toInt().toString()} %"
                                              : indexL == 0
                                                  ? 'Saving...'
                                                  : 'ກຳລັງບັນທຶກ',
                                      style: TextStyle(
                                          fontSize:
                                              mediaWidthSized(context, 29),
                                          color: Colors.black,
                                          fontFamily: 'PoppinsSemiBold'),
                                    )),
                                // SizedBox(height: mediaWidthSized(context, 13),)
                              ],
                            ),
                            alignment: Alignment.center,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
