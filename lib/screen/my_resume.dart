import 'dart:io';

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
import 'package:app/function/calculated.dart';
import 'package:app/function/pluginfunction.dart';
import 'package:app/function/sized.dart';
import 'package:app/screen/widget/alertdialog.dart';
import 'package:app/screen/widget/apploading.dart';

import 'AuthenScreen/register_widget_input.dart';
import 'my_profile.dart';
import 'widget/avatar.dart';
import 'widget/button.dart';
import 'widget/input_text_field.dart';
import 'widget/resume_tab.dart';

class MyResumePage extends StatefulWidget {
  const MyResumePage({Key? key}) : super(key: key);

  @override
  _MyResumePageState createState() => _MyResumePageState();
}

bool? reloadmyResume;

class _MyResumePageState extends State<MyResumePage> {
  List<Widget> genderActions = [];
  List<Widget> mStatusActions = [];
  bool edited = false;

  QueryInfo queryInfo = QueryInfo();
  bool? readData = false;
  bool? checkbox = false;
  bool? firstRead = false,
      alertsalary = false,
      alertLatestJob = false,
      alertPrejob = false,
      alertPreEm = false,
      alertPreIn = false,
      alertTotalExp = false;
  bool? alertdistrict;
  List<dynamic>? eduID = [];
  List<dynamic>? langskillID = [];
  List<dynamic>? showStudyField = [];
  List<dynamic>? showLang = [];
  double? uploadProgressPicture = 1;
  double? uploadProgressResume = 1;
  File? picture;
  File? resumeFile;
  String? workEXPID;
  String? registerseekerID;
  String? imageUrl;
  String? pastresumename;
  String? resumename;
  ImagePicker picker = ImagePicker();
  bool? pastbox;
  bool isLoading = false;

  int? uploadPercent;
  double? imagePercent = 0;
  double? resumePercent = 0;
  bool? uploadingFile = false;
  bool? uploadingPicture = false;
  bool? whenfinishFile = false;
  bool? whenfinishPicture = false;
  bool? dialogCheckuploadUp = false;
  dynamic image, resume;
  @override
  void initState() {
    image = null;
    resume = null;
    picture = null;
    resumeFile = null;
    myResume = Register();
    myResume.langNameID = [];
    myResume.langName = [];
    myResume.langLevelID = [];
    myResume.langLevel = [];
    myResume.fieldstudyName = [];
    myResume.degreeID = [];
    myResume.fieldstudyDegree = [];
    myResume.keySkill = [];
    myResume.previousJobTitle = [];
    myResume.previousEmployer = [];
    myResume.previousIndustry = [];
    myResume.previousIndID = [];
    firstRead = false;
    super.initState();
  }

  Future upLoad() async {}

  Future alertRunning() async {
    setState(() {
      alertdistrict = myResume.districtOrCity == null;
      alertTotalExp = myResume.totalWorkEXP == null ||
          myResume.totalWorkEXP!.trim().isEmpty;
      alertPreIn = myResume.previousIndustry == null ||
          myResume.previousIndustry!.contains(null) ||
          myResume.previousIndustry!.isEmpty;
      alertPreEm = myResume.previousEmployer == null ||
          myResume.previousEmployer!.contains(null) ||
          myResume.previousEmployer!.isEmpty;
      alertPrejob = myResume.previousJobTitle == null ||
          myResume.previousJobTitle!.contains(null) ||
          myResume.previousJobTitle!.isEmpty;
      alertLatestJob = myResume.latestJobTitle == null ||
          myResume.latestJobTitle!.trim().isEmpty;

      alertsalary = myResume.salary == null;
    });
  }

  Future selectImage(ImageSource imageSource) async {
    Navigator.pop(context);
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
                          Navigator.of(context).pop();
                        },
                        title: l.ok)
                  ],
                  content: l.thisImageSizelarge);
            });
      } else {
        setState(() {
          picture = File(img.path);
          // edited = true;
        });
      }
    }
  }

  Future getResume() async {
    var result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'docx']);
    double? sizeInMb;
    if (result != null) {
      resumeFile = File(result.files.single.path!);
      int sizeInBytes = resumeFile!.lengthSync();
      sizeInMb = sizeInBytes / (1024 * 1024);
    } else {}

    if (resumeFile != null) {
      if (sizeInMb! > 5) {
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
                        Navigator.of(context).pop();
                      },
                      title: l.ok,
                    )
                  ],
                  content: l.thisFileSizeLarge);
            });
      } else {
        resumename = resumeFile!.path.split('/').last;
        edited = true;
      }
    }
  }

  Future getPictureDevice() async {
    File? past = picture;

    var result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'docx']);
    double? sizeInMb;
    if (result != null) {
      picture = File(result.files.single.path!);
      int sizeInBytes = picture!.lengthSync();
      sizeInMb = sizeInBytes / (1024 * 1024);
    } else {}

    if (picture != null) {
      if (sizeInMb! > 15) {
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
                      Navigator.of(context).pop();
                    },
                    title: l.ok,
                  )
                ],
                content: l.thisImageSizelarge,
              );
            });
        setState(() {});
      } else {
        setState(() {
          edited = true;
        });
      }
    } else {
      picture = past;
      setState(() {});
    }
  }

  Future selectDOB() async {
    DateTime? onSelect;
    String? past = myResume.myResumeDOB;
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
                      myResume.myResumeDOB =
                          DateFormat('dd-MM-yyyy').format(DateTime(1999));
                    } else {
                      myResume.myResumeDOB =
                          DateFormat('dd-MM-yyyy').format(onSelect!);
                    }

                    Navigator.of(context).pop();
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

    myResume.myResumeDOB ??= past;
  }

  // @override
  // void dispose() {
  //
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // LoadingDialog loading = LoadingDialog(
    //   barrierDismissible: false,
    //   loadingView: Container(
    //     height: mediaWidthSized(context, 8),
    //     width: mediaWidthSized(context, 8),
    //     child: CircularProgressIndicator(
    //       strokeWidth: mediaWidthSized(context, 80),
    //       valueColor: AlwaysStoppedAnimation(AppColors.blue),
    //     ),
    //   ),
    //   elevation: 5,
    //   radius: 15,
    //   loadingMessage: '\n\n${l.uploadingInfo}',
    //   buildContext: context,
    //   height: mediaWidthSized(context, 3),
    //   width: mediaWidthSized(context, 2),
    // );Z
    return Query(
      options: QueryOptions(
        document: gql(queryInfo.qeuryResume),
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) {
          return const Loading(
            internet: false,
          );
        }
        if (reloadmyResume == true) {
          try {
            refetch!();
          } catch (e) {
            debugPrint(e.toString());
          }
          reloadmyResume = false;
        }
        var data = result.data?['findSeeker'];
        if (firstRead == false) {
          registerseekerID = data['registerSeeker']['_id'];
          imageUrl = data['registerSeeker']['fileId']['src'];
          resumename = data['resume']['fileId']['link'].split('/').last;
          pastresumename = data['resume']['fileId']['link'].split('/').last;

          myResume.firstname = data['registerSeeker']['firstName'];
          myResume.lastname = data['registerSeeker']['lastName'];
          myResume.myResumeDOB = data['registerSeeker']['dateOfBirth'];
          myResume.myResumeDOB =
              CutDateString().cutDateString(myResume.myResumeDOB);
          myResume.gender = data['registerSeeker']['genderId']['name'];
          myResume.genderID = data['registerSeeker']['genderId']['_id'];
          myResume.maritalStatusID =
              data['registerSeeker']['maritalStatusId']['_id'];

          myResume.maritalStatus =
              data['registerSeeker']['maritalStatusId']['name'];
          myResume.drivingLicense = data['registerSeeker']['drivingLicenses'];
          myResume.districtOrCityID =
              data['registerSeeker']['districtId']['_id'];
          myResume.districtOrCity =
              data['registerSeeker']['districtId']['name'];
          myResume.provinceOrState =
              data['registerSeeker']['districtId']['provinceId']['name'];
          myResume.provinceOrStateID =
              data['registerSeeker']['districtId']['provinceId']['_id'];
          myResume.profSummary = data['registerSeeker']['professionalSummary'];

          try {
            workEXPID = data['resume']['workingExperience']['_id'];
            myResume.latestJobTitle =
                data['resume']['workingExperience']['LatestJobTitle'];
            myResume.salary =
                data['resume']['workingExperience']['SalayRangeId']['name'];
            myResume.salaryID =
                data['resume']['workingExperience']['SalayRangeId']['_id'];
            List? previousJobTitlesId =
                data['resume']['workingExperience']['previousJobTitlesId'];
            previousJobTitlesId?.forEach((element) {
              myResume.previousJobTitle?.add(element['name']);
            });
            List? previousEmployersId =
                data['resume']['workingExperience']['previousEmployersId'];
            previousEmployersId?.forEach((element) {
              myResume.previousEmployer?.add(element['name']);
            });

            List? industry = data['resume']['workingExperience']
                ['previousEmployerIndustryId'];
            industry?.forEach((element) {
              myResume.previousIndustry?.add(element['name']);
              myResume.previousIndID?.add(element['_id']);
            });
            myResume.totalWorkEXP = data['resume']['workingExperience']
                    ['totalWorkingExperience']
                .toString();
            if (readData == false) {
              checkbox = false;
            }
            readData = true;
          } catch (e) {
            if (readData == false) {
              checkbox = true;
            }

            readData = true;
          }

          List? education = data['resume']['education'];

          education?.forEach((element) {
            eduID?.add(element['_id']);
            myResume.fieldstudyName?.add(element['department']);
            myResume.degreeID?.add(element['degreeId']['_id']);
            myResume.fieldstudyDegree?.add(element['degreeId']['name']);
          });
          List? langskill = data['resume']['languageSkill'];
          langskill?.forEach((element) {
            langskillID?.add(element['_id']);
            myResume.langNameID?.add(element['LanguageId']['_id']);
            myResume.langName?.add(element['LanguageId']['name']);
            myResume.langLevelID?.add(element['LanguageLevelId']['_id']);
            myResume.langLevel?.add(element['LanguageLevelId']['name']);
          });
          showStudyField = setShowFieldStudy(
              myResume.fieldstudyName, myResume.fieldstudyDegree);
          showLang = setShowLang(myResume.langName, myResume.langLevel);
          List? keySkill = data['resume']['keySkillIds'];
          keySkill?.forEach((element) {
            myResume.keySkill?.add(element['name']);
          });

          firstRead = true;
        }

        return Mutation(
            options: MutationOptions(
              update: (cache, result) {},
              document: gql(queryInfo.updateInformation),
              onCompleted: (resultData) {
                debugPrint(resultData.toString());
                try {
                  refetch!();
                } catch (e) {
                  debugPrint(e.toString());
                }
                setState(() {});
                isLoading = true;
                Future.delayed(const Duration(milliseconds: 500)).then((value) {
                  reloadprofilePage = true;
                  reloadmyResume = true;

                  Navigator.of(context).pop();
                });
                // Navigator.of(context).pop();
              },
              onError: (error) {
                setState(() {});
                isLoading = false;
                debugPrint(error.toString());
                Navigator.of(context).pop();
              },
            ),
            builder: (RunMutation runMutation, result) {
              Future toSave() async {
                alertRunning().then((value) async {
                  if (!alertdistrict! &&
                      (checkbox! ||
                          (!alertLatestJob! &&
                              !alertPreEm! &&
                              !alertPreIn! &&
                              !alertPrejob! &&
                              !alertTotalExp!))) {
                    // loading.show();
                    upLoad().then((value) {
                      if (checkbox == false) {
                        setState(() {});
                        isLoading = true;
                        runMutation(
                          queryInfo.updateResumeMutation(
                              degreeID: myResume.degreeID,
                              districtID: myResume.districtOrCityID,
                              dob: myResume.myResumeDOB,
                              drivinglicense: myResume.drivingLicense,
                              fieldstudyname: myResume.fieldstudyName,
                              firstname: myResume.firstname,
                              lastname: myResume.lastname,
                              genderID: myResume.genderID,
                              keySkill: myResume.keySkill,
                              langID: myResume.langNameID,
                              langLevelID: myResume.langLevelID,
                              latestjob: myResume.latestJobTitle,
                              maritalID: myResume.maritalStatusID,
                              previousEmp: myResume.previousEmployer,
                              previousIndID: myResume.previousIndID,
                              previousJob: myResume.previousJobTitle,
                              profsum: myResume.profSummary,
                              registerseekerID: data['registerSeeker']['_id'],
                              salaryRangID: myResume.salaryID,
                              seekerID: data['_id'],
                              totalWorkingExp: myResume.totalWorkEXP),
                        );
                      } else {
                        setState(() {});
                        isLoading = true;
                        runMutation(
                          queryInfo.updateNoExpResumeMutation(
                            degreeID: myResume.degreeID,
                            districtID: myResume.districtOrCityID,
                            dob: myResume.myResumeDOB,
                            drivinglicense: myResume.drivingLicense,
                            fieldstudyname: myResume.fieldstudyName,
                            firstname: myResume.firstname,
                            lastname: myResume.lastname,
                            genderID: myResume.genderID,
                            keySkill: myResume.keySkill,
                            langID: myResume.langNameID,
                            langLevelID: myResume.langLevelID,
                            maritalID: myResume.maritalStatusID,
                            profsum: myResume.profSummary,
                            registerseekerID: data['registerSeeker']['_id'],
                            resumeID: data['resume']['_id'],
                            seekerID: data['_id'],
                          ),
                        );
                      }
                    });
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
                                  Navigator.of(context).pop();
                                },
                                title: l.ok,
                              )
                            ],
                            content: l.yourfromnotfinish,
                          );
                        }).then((value) {});
                  }
                });
              }

              return WillPopScope(
                onWillPop: () async {
                  if (isLoading == true) {
                    return false;
                  }
                  if (uploadingFile == true || uploadingPicture == true) {
                    if (uploadingFile == true) {
                      whenfinishFile = true;
                    }
                    if (uploadingFile == true) {
                      whenfinishPicture = true;
                    }
                    dialogCheckuploadUp = true;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertPlainDialog(
                          title: 'ມີໄຟລກຳລັງອັບໂຫຼດ',
                          content:
                              'ຖ້າທ່ານກົດອອກການອັບໂຫຼດຈະຖືກຍົກເລີກ/nທ່ານຢາກອອກຈາກໜ້ານີ້ຫຼືບໍ່',
                          actions: [
                            AlertAction(
                              title: l.yes,
                              onTap: () {
                                dialogCheckuploadUp = false;
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                            AlertAction(
                              title: l.no,
                              onTap: () {
                                setState(() {});
                                dialogCheckuploadUp = false;
                                if (uploadingFile == false ||
                                    uploadingPicture == false) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                } else {
                                  isLoading = true;
                                  Navigator.of(context).pop();
                                }
                              },
                            )
                          ],
                        );
                      },
                    );
                    return false;
                  }
                  if (edited) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertPlainDialog(
                          title: l.infonotsave,
                          content: l.saveOrnot,
                          actions: [
                            AlertAction(
                              title: l.yes,
                              onTap: () {
                                Navigator.of(context).pop();
                                toSave().then((value) {
                                  setState(() {
                                    edited = false;
                                  });
                                });
                              },
                            ),
                            AlertAction(
                              title: l.no,
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      },
                    );
                    return false;
                  } else {
                    return true;
                  }
                },
                child: Stack(
                  children: [
                    Scaffold(
                      backgroundColor: AppColors.white,
                      appBar: PreferredSize(
                          child: AppBar(
                            actions: [
                              InkWell(
                                onTap: () {
                                  if (edited) {
                                    toSave().then((value) {
                                      setState(() {
                                        edited = false;
                                      });
                                    });
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(
                                    mediaWidthSized(context, 34),
                                  ),
                                  child: Text(
                                    l.save,
                                    style: TextStyle(
                                        fontSize: mediaWidthSized(context, 26),
                                        fontFamily: 'PoppinsMedium',
                                        color: AppColors.white),
                                  ),
                                ),
                              )
                            ],
                            backgroundColor: AppColors.blue,
                            centerTitle: true,
                            title: Text(
                              l.myResume,
                              style: TextStyle(
                                  fontFamily: 'PoppinsSemiBold',
                                  fontSize: appbarTextSize(context)),
                            ),
                            // Text('Recipes',style: TextStyle(),),
                            elevation: 0.0,
                            bottomOpacity: 0.0,
                          ),
                          preferredSize: Size.fromHeight(appbarsize(context))),
                      body: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width),
                            SizedBox(
                              height: mediaWidthSized(context, 15),
                            ),
                            Stack(
                              // alignment: Alignment.center,
                              children: [
                                AnimatedOpacity(
                                  opacity: uploadProgressPicture!,
                                  curve: Curves.easeInOut,
                                  onEnd: () {
                                    debugPrint('animate opacity end');
                                    setState(() {
                                      imagePercent = 0;
                                      uploadProgressPicture = 1;
                                    });
                                  },
                                  duration: const Duration(milliseconds: 1000),
                                  child: SizedBox(
                                    // duration: Duration(seconds: 5),
                                    // curve: Curves.easeInOut,
                                    // decoration: BoxDecoration(
                                    //     border: Border.all(
                                    //         // color: (imagePercent / 100) != 1
                                    //         //     ? AppColors.blue
                                    //         //     : AppColors.white,
                                    //         width: 5)),
                                    height: mediaWidthSized(context, 3.3),
                                    width: mediaWidthSized(context, 3.3),
                                    child: CircularProgressIndicator(
                                      // valueColor: ,
                                      color: AppColors.blue.withOpacity(1),

                                      strokeWidth: mediaWidthSized(context, 50),
                                      value: imagePercent! / 100,
                                    ),
                                  ),
                                ),
                                Mutation(
                                  options: MutationOptions(
                                    document:
                                        gql(QueryInfo().updateProfileLogo),
                                    onCompleted: (data) {
                                      uploadingPicture = false;
                                      reloadprofilePage = true;
                                      if (isLoading == true) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                      debugPrint(data.toString());
                                      try {
                                        refetch!();
                                      } catch (e) {
                                        debugPrint(e.toString());
                                      }

                                      setState(() {
                                        uploadProgressPicture = 0;
                                        image = null;
                                      });
                                      if (whenfinishPicture == true &&
                                          uploadingFile == false &&
                                          dialogCheckuploadUp == true) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                      if (whenfinishPicture == true &&
                                          uploadingFile == false &&
                                          dialogCheckuploadUp == false) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    onError: (error) {
                                      debugPrint(error.toString());
                                    },
                                  ),
                                  builder: (runMutationLogo, result) {
                                    return Avatar(
                                      ontap: () {
                                        selectpicturefrom(
                                          context,
                                          onPress1: () async {
                                            selectImage(ImageSource.camera)
                                                .then((value) async {
                                              if (picture != null) {
                                                uploadingPicture = true;
                                                FormData formData =
                                                    FormData.fromMap({
                                                  "image": await MultipartFile
                                                      .fromFile(picture!.path,
                                                          filename: picture!
                                                              .path
                                                              .split("/")
                                                              .last,
                                                          contentType:
                                                              MediaType('image',
                                                                  'jpg')),
                                                });
                                                dynamic responseImage =
                                                    await Dio().post(
                                                  queryInfo.apiUpLoadImage,
                                                  data: formData,
                                                  onSendProgress:
                                                      (count, total) {
                                                    imagePercent =
                                                        count / total * 100;
                                                    setState(() {});
                                                    debugPrint(imagePercent
                                                        .toString());
                                                  },
                                                );

                                                image = responseImage.data;
                                                runMutationLogo({
                                                  "seekerId": data['_id'],
                                                  "logo": image['file']
                                                });
                                                // await upLoadDioImage(picture.path, queryInfo.apiUpLoadImage)
                                                //     .then((value) {
                                                //   image = value;
                                                // });
                                              }
                                            });

                                            // Navigator.of(context).pop();
                                          },
                                          onPress2: () {
                                            selectImage(ImageSource.gallery)
                                                .then((value) async {
                                              // Navigator.pop(context);
                                              if (picture != null) {
                                                uploadingPicture = true;
                                                FormData formData =
                                                    FormData.fromMap({
                                                  "image": await MultipartFile
                                                      .fromFile(picture!.path,
                                                          filename: picture!
                                                              .path
                                                              .split("/")
                                                              .last,
                                                          contentType:
                                                              MediaType('image',
                                                                  'jpg')),
                                                });
                                                dynamic responseImage =
                                                    await Dio().post(
                                                  queryInfo.apiUpLoadImage,
                                                  data: formData,
                                                  onSendProgress:
                                                      (count, total) {
                                                    imagePercent =
                                                        count / total * 100;
                                                    setState(() {});
                                                    debugPrint(imagePercent
                                                        .toString());
                                                  },
                                                );

                                                image = responseImage.data;
                                                runMutationLogo({
                                                  "seekerId": data['_id'],
                                                  "logo": image['file']
                                                });
                                                // await upLoadDioImage(picture.path, queryInfo.apiUpLoadImage)
                                                //     .then((value) {
                                                //   image = value;
                                                // });
                                              }
                                            });

                                            // getPictureDevice();
                                            // Navigator.pop(context, 'Cancel');
                                          },
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      networkPicture: imageUrl,
                                      picture: picture,
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: mediaWidthSized(context, 10),
                            ),
                            TextTitle(title: l.personalinfo),
                            ListBody(
                              children: [
                                // SizedBox(
                                //   height: 5,
                                // ),
                                WidgetTabInfo(
                                  onTap: () {
                                    var past = myResume.firstname;
                                    var past2 = myResume.lastname;
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const InputFullName(false)))
                                        .then((value) {
                                      setState(() {
                                        if (past != myResume.firstname ||
                                            past2 != myResume.lastname) {
                                          edited = true;
                                        }
                                      });
                                    });
                                  },
                                  icon: 'chevron-right ',
                                  header: l.fullname,
                                  showField:
                                      '${myResume.firstname} ${myResume.lastname}',
                                ),
                                WidgetTabInfo(
                                  onTap: () {
                                    var past = myResume.myResumeDOB;
                                    selectDOB().then((value) {
                                      setState(() {
                                        if (past != myResume.myResumeDOB) {
                                          edited = true;
                                        }
                                      });
                                    });
                                  },
                                  icon: 'chevron-right ',
                                  header: l.dob,
                                  showField: '${myResume.myResumeDOB}',
                                ),
                                Query(
                                  options: QueryOptions(
                                      document: gql(queryInfo.getReuse),
                                      variables: <String, dynamic>{
                                        "types": "Gender",
                                        "lanOption": indexL == 0 ? "EN" : "LA"
                                      }),
                                  builder: (QueryResult result,
                                      {refetch, fetchMore}) {
                                    if (result.hasException) {
                                      return Text(result.exception.toString());
                                    }
                                    if (result.isLoading) {
                                      return WidgetTabInfo(
                                        icon: 'chevron-right ',
                                        header: l.gender,
                                        showField: '${myResume.gender}',
                                      );
                                    }
                                    List? repositories =
                                        result.data?['getReuseList'];
                                    genderActions = [];
                                    repositories?.forEach((element) {
                                      genderActions.add(
                                        CupertinoActionSheetAction(
                                            onPressed: () {
                                              myResume.genderID =
                                                  '${element['_id']}';
                                              myResume.gender =
                                                  '${element['name']}';

                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('${element['name']}',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: AppColors.blue,
                                                    fontFamily:
                                                        'PoppinsMedium'))),
                                      );
                                    });

                                    return WidgetTabInfo(
                                      onTap: () {
                                        var past = myResume.genderID;
                                        showDialogPickerText(genderActions,
                                                context, l.gender)
                                            .then((value) {
                                          setState(() {
                                            if (myResume.genderID != past) {
                                              edited = true;
                                            }
                                          });
                                        });
                                      },
                                      icon: 'chevron-right ',
                                      header: l.gender,
                                      showField: '${myResume.gender}',
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
                                  builder: (QueryResult result,
                                      {refetch, fetchMore}) {
                                    if (result.hasException) {
                                      return Text(result.exception.toString());
                                    }
                                    if (result.isLoading) {
                                      return WidgetTabInfo(
                                        icon: 'chevron-right ',
                                        header: l.maritalstt,
                                        showField: '${myResume.maritalStatus}',
                                      );
                                    }
                                    List? repositories =
                                        result.data?['getReuseList'];
                                    mStatusActions = [];
                                    repositories?.forEach((element) {
                                      mStatusActions.add(
                                        CupertinoActionSheetAction(
                                            onPressed: () {
                                              myResume.maritalStatusID =
                                                  '${element['_id']}';
                                              myResume.maritalStatus =
                                                  '${element['name']}';

                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('${element['name']}',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: AppColors.blue,
                                                    fontFamily:
                                                        'PoppinsMedium'))),
                                      );
                                    });

                                    return WidgetTabInfo(
                                      onTap: () {
                                        var past = myResume.maritalStatusID;
                                        showDialogPickerText(mStatusActions,
                                                context, l.maritalstt)
                                            .then((value) {
                                          if (past !=
                                              myResume.maritalStatusID) {
                                            edited = true;
                                          }
                                        });
                                      },
                                      icon: 'chevron-right ',
                                      header: l.maritalstt,
                                      showField: '${myResume.maritalStatus}',
                                    );
                                  },
                                ),
                                WidgetTabInfo(
                                  onTap: () {
                                    var past = myResume.drivingLicense;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const InputDrivingLicense(false)),
                                    ).then((value) {
                                      setState(() {
                                        if (past != myResume.drivingLicense) {
                                          edited = true;
                                        }
                                      });
                                    });
                                  },
                                  icon: 'chevron-right ',
                                  header: l.drivinglic,
                                  showField:
                                      myResume.drivingLicense?.join(', '),
                                ),
                                Query(
                                  options: QueryOptions(
                                      document:
                                          gql(queryInfo.getProvinceDistrict),
                                      variables: <String, dynamic>{}),
                                  builder: (QueryResult result,
                                      {refetch, fetchMore}) {
                                    if (result.hasException) {
                                      return Text(result.exception.toString());
                                    }
                                    if (result.isLoading) {
                                      return Column(
                                        children: [
                                          WidgetTabInfo(
                                            icon: 'chevron-right ',
                                            header: l.province,
                                            showField:
                                                '${TranslateQuery.translateProvince(myResume.provinceOrState!)}',
                                          ),
                                          WidgetTabInfo(
                                            icon: 'chevron-right ',
                                            header: l.district,
                                            showField: myResume.districtOrCity,
                                          ),
                                        ],
                                      );
                                    }
                                    List? data = result.data?['getProvinces'];
                                    int i = 0;
                                    dynamic repoDistrict;
                                    data?.forEach((element) {
                                      if (element['name'] ==
                                          myResume.provinceOrState) {
                                        myResume.districtRepoindex = i;
                                        repoDistrict =
                                            result.data?['getProvinces']
                                                [myResume.districtRepoindex];
                                      }
                                      i = i + 1;
                                      if (element['name'] ==
                                          myResume.provinceOrState) {
                                        i = 0;
                                      }
                                    });
                                    return Column(
                                      children: [
                                        WidgetTabInfo(
                                          onTap: () async {
                                            var past =
                                                myResume.provinceOrStateID;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      InputProvinceState(
                                                          result, false)),
                                            ).then((value) {
                                              setState(() {
                                                if (past !=
                                                    myResume
                                                        .provinceOrStateID) {
                                                  edited = true;
                                                }
                                                alertdistrict =
                                                    myResume.districtOrCity ==
                                                        null;
                                              });
                                            });
                                          },
                                          icon: 'chevron-right ',
                                          header: l.province,
                                          showField: myResume.provinceOrState,
                                        ),
                                        WidgetTabInfo(
                                          alertvisible: alertdistrict,
                                          alertText: l.enterDistrict,
                                          onTap: () async {
                                            var past =
                                                myResume.districtOrCityID;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      InputDistrictCity(
                                                          repoDistrict, false)),
                                            ).then((value) {
                                              if (past !=
                                                  myResume.districtOrCityID) {
                                                edited = true;
                                              }
                                              setState(() {
                                                alertdistrict =
                                                    myResume.districtOrCity ==
                                                        null;
                                              });
                                            });
                                          },
                                          icon: 'chevron-right ',
                                          header: l.district,
                                          showField: myResume.districtOrCity,
                                        ),
                                      ],
                                    );
                                  },
                                ),

                                WidgetTabInfo(
                                  onTap: () {
                                    var past = myResume.profSummary;

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const InputPrfSummary(
                                                    false))).then((value) {
                                      setState(() {
                                        if (past != myResume.profSummary) {
                                          edited = true;
                                        }
                                      });
                                    });
                                  },
                                  icon: 'chevron-right ',
                                  header: l.profesSum,
                                  showField: '${myResume.profSummary}',
                                ),
                                const SizedBox(
                                  height: 30,
                                ),

                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextTitle(
                                    title: l.uploadCv,
                                    margin: 0,
                                  ),
                                ),

                                Mutation(
                                  options: MutationOptions(
                                    document: gql(QueryInfo().updateResumeFile),
                                    onCompleted: (data) {
                                      if (isLoading == true) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                      reloadprofilePage = true;
                                      debugPrint(data.toString());
                                      try {
                                        refetch!();
                                      } catch (e) {
                                        debugPrint(e.toString());
                                      }
                                      uploadingFile = false;
                                      setState(() {
                                        uploadProgressResume = 0;
                                        resume = null;
                                      });
                                      if (whenfinishFile == true &&
                                          uploadingPicture == false &&
                                          dialogCheckuploadUp == true) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                      if (whenfinishFile == true &&
                                          uploadingPicture == false &&
                                          dialogCheckuploadUp == false) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    onError: (error) {
                                      debugPrint(error.toString());
                                    },
                                  ),
                                  builder: (runMutationResume, result) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  '   File-pdf ',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'FontAwesomeProSolid',
                                                    fontSize: mediaWidthSized(
                                                        context, 26),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '$resumename',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'PoppinsSemiBold',
                                                      fontSize: mediaWidthSized(
                                                          context, 26),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: Text('external-link-alt',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'FontAwesomeProRegular',
                                                  color: AppColors.yellow,
                                                  fontSize: mediaWidthSized(
                                                      context, 26),
                                                )),
                                            onPressed: () {
                                              setState(() {
                                                getResume().then((value) async {
                                                  // setState(() {
                                                  //   isLoading = true;
                                                  // });

                                                  if (resumeFile != null) {
                                                    try {
                                                      uploadingFile = true;
                                                      FormData formData =
                                                          FormData.fromMap({
                                                        "file":
                                                            await MultipartFile
                                                                .fromFile(
                                                          resumeFile!.path,
                                                          filename: resumeFile!
                                                              .path
                                                              .split("/")
                                                              .last,
                                                        ),
                                                      });

                                                      dynamic response =
                                                          await Dio().post(
                                                        queryInfo
                                                            .apiUpLoadResume,
                                                        data: formData,
                                                        onSendProgress:
                                                            (count, total) {
                                                          resumePercent =
                                                              count /
                                                                  total *
                                                                  100;
                                                          debugPrint(
                                                              resumePercent
                                                                  .toString());
                                                          setState(() {});
                                                        },
                                                      );

                                                      resume = response.data;
                                                      runMutationResume({
                                                        "resumeId":
                                                            data['resume']
                                                                ['_id'],
                                                        "file": resume['myFile']
                                                      });
                                                      setState(() {});
                                                    } catch (e) {
                                                      uploadingFile = false;
                                                    }
                                                    // await upLoadDioResume(resumeFile.path, queryInfo.apiUpLoadResume)
                                                    //     .then((value) {
                                                    //  debugPrint(value);
                                                    //   resume = value;
                                                    // });
                                                  }
                                                  // setState(() {
                                                  //   if (resumeFile != null) {
                                                  //     edited = true;
                                                  //   }
                                                  // });
                                                });
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                AnimatedOpacity(
                                  onEnd: () {
                                    debugPrint('animate opacity end');
                                    setState(() {
                                      resumePercent = 0;
                                      uploadProgressResume = 1;
                                    });
                                  },
                                  opacity: uploadProgressResume!,
                                  duration: const Duration(milliseconds: 1500),
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: LinearProgressIndicator(
                                        backgroundColor: AppColors.white,
                                        value: resumePercent! / 100,
                                      )),
                                ),

                                const SizedBox(
                                  height: 30,
                                ),
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
                                        value: checkbox,
                                        onChanged: (newValue) {
                                          setState(() {
                                            if (pastbox != checkbox) {
                                              edited = true;
                                            }
                                            checkbox = newValue;
                                          });
                                        },
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (checkbox == false) {
                                          checkbox = true;
                                        } else {
                                          checkbox = false;
                                        }
                                        edited = true;
                                        setState(() {});
                                      },
                                      child: Text(
                                        l.idontworkingexp,
                                        style: TextStyle(
                                            fontFamily: 'PoppinsRegular',
                                            fontSize:
                                                mediaWidthSized(context, 30),
                                            color: AppColors.grey),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 10,
                                ),
                                Fade(
                                  duration: const Duration(milliseconds: 300),
                                  visible: !checkbox!,
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      WidgetTabInfo(
                                        alertText: l.enterLatest,
                                        alertvisible: alertLatestJob,
                                        onTap: () {
                                          var past = myResume.latestJobTitle;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const InputLatestJobTitle(
                                                          false))).then(
                                              (value) {
                                            setState(() {
                                              if (past !=
                                                  myResume.latestJobTitle) {
                                                edited = true;
                                              }
                                              alertLatestJob =
                                                  myResume.latestJobTitle ==
                                                      null;
                                            });
                                          });
                                        },
                                        showField: myResume.latestJobTitle,
                                        icon: 'plus ',
                                        header: l.latestjob,
                                      ),
                                      Query(
                                        options: QueryOptions(
                                            document: gql(queryInfo.getReuse),
                                            variables: <String, dynamic>{
                                              "types": "SalaryRange",
                                              "lanOption":
                                                  indexL == 0 ? "EN" : "LA"
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
                                              icon: 'plus ',
                                              header: l.salaryRange,
                                              showField: myResume.salary,
                                            );
                                          }
                                          List? repositories =
                                              result.data?["getReuseList"];
                                          return WidgetTabInfo(
                                            alertText: l.enterSalary,
                                            alertvisible: alertsalary,
                                            icon: 'plus ',
                                            header: l.salaryRange,
                                            showField: myResume.salary,
                                            onTap: () {
                                              var past = myResume.salaryID;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        InputSalaryRange(
                                                            repositories,
                                                            false)),
                                              ).then((context) {
                                                setState(() {
                                                  if (past !=
                                                      myResume.salaryID) {
                                                    edited = true;
                                                  }
                                                  alertsalary =
                                                      myResume.salaryID == null;
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
                                          var past = myResume.previousJobTitle;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const InputPreviousJob(
                                                          false))).then(
                                              (value) {
                                            setState(() {
                                              if (past !=
                                                  myResume.previousJobTitle) {
                                                edited = true;
                                              }
                                              alertPrejob =
                                                  myResume.previousJobTitle ==
                                                          null ||
                                                      myResume.previousJobTitle!
                                                          .contains(null) ||
                                                      myResume.previousJobTitle!
                                                          .isEmpty;
                                            });
                                          });
                                        },
                                        showField: myResume.previousJobTitle
                                            ?.join('\n'),
                                        icon: 'plus ',
                                        header: l.previousJobTitle,
                                      ),
                                      WidgetTabInfo(
                                          alertvisible: alertPreEm,
                                          alertText: l.previousEmployer,
                                          onTap: () {
                                            var past =
                                                myResume.previousEmployer;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const InputPreviousEMP(
                                                            false))).then(
                                                (value) {
                                              setState(() {
                                                if (past ==
                                                    myResume.previousEmployer) {
                                                  edited = true;
                                                }
                                                alertPreEm = myResume
                                                            .previousEmployer ==
                                                        null ||
                                                    myResume.previousEmployer!
                                                        .contains(null) ||
                                                    myResume.previousEmployer!
                                                        .isEmpty;
                                              });
                                            });
                                          },
                                          showField:
                                              "${myResume.previousEmployer?.join('\n')}",
                                          icon: 'plus ',
                                          header: l.previousEmployer),
                                      Query(
                                        options: QueryOptions(
                                            document: gql(queryInfo.getReuse),
                                            variables: <String, dynamic>{
                                              "types": "Industry",
                                              "lanOption":
                                                  indexL == 0 ? "EN" : "LA"
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
                                              showField:
                                                  "${myResume.previousIndustry?.join('\n')}",
                                              icon: 'plus ',
                                              header: l.previousIndustry,
                                            );
                                          }
                                          List? repositories =
                                              result.data?["getReuseList"];
                                          return WidgetTabInfo(
                                              alertvisible: alertPreIn,
                                              alertText: l.enterPreEmpInd,
                                              onTap: () {
                                                var past =
                                                    myResume.previousIndID;
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            InputPreEmpIndustry(
                                                                repositories!,
                                                                false))).then(
                                                    (value) {
                                                  setState(() {
                                                    if (past !=
                                                        myResume
                                                            .previousIndID) {
                                                      edited = true;
                                                    }
                                                    alertPreIn = myResume
                                                                .previousIndustry ==
                                                            null ||
                                                        myResume
                                                            .previousIndustry!
                                                            .contains(null) ||
                                                        myResume
                                                            .previousIndustry!
                                                            .isEmpty;
                                                  });
                                                });
                                              },
                                              showField:
                                                  "${myResume.previousIndustry?.join('\n')}",
                                              icon: 'plus ',
                                              header: l.previousIndustry);
                                        },
                                      ),
                                      WidgetTabInfo(
                                        alertvisible: alertTotalExp,
                                        alertText: l.enterTotalEXP,
                                        onTap: () {
                                          String? past = myResume.totalWorkEXP;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const InputTotalWorkEXP(
                                                          false))).then(
                                              (value) {
                                            setState(() {
                                              if (past !=
                                                  myResume.totalWorkEXP) {
                                                edited = true;
                                              }
                                              alertTotalExp =
                                                  myResume.totalWorkEXP ==
                                                          null ||
                                                      myResume.totalWorkEXP!
                                                          .trim()
                                                          .isEmpty;
                                            });
                                          });
                                        },
                                        showField: myResume.totalWorkEXP,
                                        icon: 'plus ',
                                        header: l.totalWorkingExperience,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextTitle(title: l.education),
                                // SizedBox(
                                //   height: 10,
                                // ),
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
                                          showField:
                                              "${showStudyField?.join('\n')}",
                                          icon: 'plus ',
                                          header: l.fieldofStudy);
                                    }
                                    List repositories =
                                        result.data?["getReuseList"];
                                    return WidgetTabInfo(
                                      onTap: () {
                                        var past = showStudyField;

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  InputFieldStudy(
                                                      repositories, false)),
                                        ).then((context) {
                                          setState(() {
                                            showStudyField = setShowFieldStudy(
                                                myResume.fieldstudyName,
                                                myResume.fieldstudyDegree);
                                            if (past != showStudyField) {
                                              edited = true;
                                            }
                                          });
                                        });
                                      },
                                      showField:
                                          "${showStudyField?.join('\n')}",
                                      icon: 'plus ',
                                      header: l.fieldofStudy,
                                    );
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
                                        showField: "${showLang?.join('\n')}",
                                        icon: 'plus ',
                                        header: l.language,
                                      );
                                    }
                                    List? repositoriesLanguage =
                                        result.data?["getReuseList"];
                                    return Query(
                                      options: QueryOptions(
                                          document: gql(queryInfo.getReuse),
                                          variables: <String, dynamic>{
                                            "types": "LanguageLevel",
                                            "lanOption":
                                                indexL == 0 ? "EN" : "LA"
                                          }),
                                      builder: (QueryResult result2,
                                          {refetch, fetchMore}) {
                                        if (result2.hasException) {
                                          return Text(
                                              result2.exception.toString());
                                        }
                                        if (result2.isLoading) {
                                          return WidgetTabInfo(
                                            showField:
                                                "${showLang?.join('\n')}",
                                            icon: 'plus ',
                                            header: l.language,
                                          );
                                        }
                                        List? repositoriesLangLevel =
                                            result2.data?["getReuseList"];
                                        return WidgetTabInfo(
                                          onTap: () {
                                            var past = showLang;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      InputLanguage(
                                                        repositoriesLang:
                                                            repositoriesLanguage,
                                                        repositoriesLangLevel:
                                                            repositoriesLangLevel,
                                                        fromRegister: false,
                                                      )),
                                            ).then((context) {
                                              setState(() {
                                                showLang = setShowLang(
                                                    myResume.langName,
                                                    myResume.langLevel);
                                                if (past != showLang) {
                                                  edited = true;
                                                }
                                              });
                                            });
                                          },
                                          showField: "${showLang?.join('\n')}",
                                          icon: 'plus ',
                                          header: l.language,
                                        );
                                      },
                                    );
                                  },
                                ),

                                WidgetTabInfo(
                                  onTap: () {
                                    var past = myResume.keySkill;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const InputKeySkill(false)),
                                    ).then((value) {
                                      setState(() {
                                        if (past != myResume.keySkill) {
                                          edited = true;
                                        }
                                      });
                                    });
                                  },
                                  showField: "${myResume.keySkill?.join('\n')}",
                                  icon: 'plus ',
                                  header: l.keySkill,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                )
                              ],
                            ),
                            BlueButton(
                              onPressed: () {
                                if (edited) {
                                  toSave().then((value) {
                                    setState(() {
                                      edited = false;
                                    });
                                  });
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                              title: l.save,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isLoading,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      // SizedBox(height: mediaWidthSized(context, 13),),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top:
                                                  mediaWidthSized(context, 20)),
                                          child: Text(
                                            indexL == 0
                                                ? 'Loading...'
                                                : 'ກำລັງໂຫລດ...',
                                            style: TextStyle(
                                                fontSize: mediaWidthSized(
                                                    context, 22),
                                                color: Colors.black,
                                                fontFamily: 'PoppinsSemiBold'),
                                          )),

                                      const CircularProgressIndicator(
                                          // value: resumePercent / 100,
                                          ),

                                      Container(
                                          margin: EdgeInsets.only(
                                              bottom:
                                                  mediaWidthSized(context, 20)),
                                          child: Text(
                                            image == null && picture != null
                                                ? "Upload image: ${imagePercent?.toInt().toString()} %"
                                                : resume == null &&
                                                        resumeFile != null
                                                    ? "Upload CV: ${resumePercent?.toInt().toString()} %"
                                                    : indexL == 0
                                                        ? 'Saving...'
                                                        : 'ກຳລັງບັນທຶກ',
                                            style: TextStyle(
                                                fontSize: mediaWidthSized(
                                                    context, 29),
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
              );
            });
      },
    );
  }
}
