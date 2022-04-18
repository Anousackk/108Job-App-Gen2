// import 'package:fade/fade.dart';
// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:app/api/auth.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/calculated.dart';
import 'package:app/function/pluginfunction.dart';
import 'package:app/function/sized.dart';
import 'package:share/share.dart';

// import 'Widget/BlueButton.dart';
import 'AuthenScreen/login_page.dart';
import 'Shimmer/jobdetailshimmer.dart';
import 'Widget/alertdialog.dart';
import 'company_detail.dart';
import 'my_jobs_page.dart';
import 'widget/company_list_widget.dart';

class JobDetailPage extends StatefulWidget {
  final String jobID;

  const JobDetailPage({Key? key, required this.jobID}) : super(key: key);
  @override
  _JobDetailPageState createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  // bool saveLoad = false;
  CutDateString convertDate = CutDateString();
  late String jobID = widget.jobID;

  QueryInfo queryInfo = QueryInfo();
  bool? visible = false;
  bool? loadapplie = false;
  var data;
  bool? saved = false;
  bool? readoneTime = true;
  bool? firstread = true;
  late ScrollController scroll;
  bool? isApproveCV = false;
  bool? isCoverLetter = false;
  bool? isApplied = false;
  // bool blockAppliedfetch = false;
  bool? isPressApply = false;
  double? isNothiddenUploadTask = 1;
  File? coverLetterFile;
  String? coverLetterFileName;
  double? coverletterpercent = 0;
  bool? isUploading = false;
  var coverLetter;
  var findE1, findE2;
  Future getCoverletter() async {
    var result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'docx']);
    double? sizeInMb;
    if (result != null) {
      coverLetterFile = File(result.files.single.path!);
      int sizeInBytes = coverLetterFile!.lengthSync();
      sizeInMb = sizeInBytes / (1024 * 1024);
    } else {}

    if (coverLetterFile != null) {
      if (sizeInMb! > 5) {
        coverLetterFile = null;
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
        coverLetterFileName = coverLetterFile?.path.split('/').last;
      }
    }
  }

  Future dialogSignin() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertPlainDialog(
          color: AppColors.blue,
          title: l.youareNotSignIn,
          content: l.doyouwanttoSignin,
          actions: [
            AlertAction(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      settings: const RouteSettings(name: "/login"),
                      builder: (context) => const LoginPage()),
                );
              },
              title: l.yes,
            ),
            AlertAction(
              onTap: () {
                Navigator.pop(context);
              },
              title: l.no,
            ),
          ],
        );
      },
    );
  }

  _scrollListener() {
    if (scroll.offset > 250.00) {
      setState(() {
        visible = true;
      });
    }
    if (scroll.offset <= 250.00) {
      setState(() {
        visible = false;
      });
    }
  }

  @override
  void dispose() {
    scroll.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    debugPrint(jobID);
    scroll = ScrollController();
    scroll.addListener(_scrollListener);
    super.initState();
    readoneTime = true;
    loadapplie = false;
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: gql(queryInfo.jobDetail),
            variables: <String, dynamic>{
              "Jobid": jobID,
              "verifyToken": currentToken ?? ''
            }),
        builder: (QueryResult result, {refetch, fetchMore}) {
          if (result.hasException) {
            debugPrint(result.exception.toString());
            return const Scaffold();
          }
          if (result.isLoading && data == null) {
            return const JobDetailLoad();
          }

          try {
            data = result.data?['getJobByJobId'];
          } catch (e) {
            // debugPrint('eiei');
          }

          // List<String> locateList = [];
          // data['findJ']['workingLocationId'].forEach((element) {
          //   locateList.add(element['name']);
          // });

          if (firstread == true) {
            saved = data['findJ']['isSaved'];

            isApplied = data['findJ']['isApplied'];
            firstread = false;
          }

          try {
            isApproveCV = data['findJ']['isApprovedCV'];
            isCoverLetter = data['findJ']['isCoverLetter'];
            debugPrint("approvedCV: " + isApproveCV.toString());
            debugPrint("Coverletter: " + isCoverLetter.toString());
          } catch (e) {
            debugPrint(' ');
          }
          try {
            findE1 = data['findE'].length.toString();
          } catch (e) {
            debugPrint(' ');
          }
          try {
            findE2 = data['findE'][0]['openingDate'].toString();
          } catch (e) {
            debugPrint(' ');
          }
          saved = saved ?? false;

          // List industry = [];
          // data['findJ']['employerId']['industryId'].forEach((element) {
          //   industry.add(element['name']);
          // });
          // List laoProvince = seperateTranslate(locateList);
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: PreferredSize(
                child: AppBar(
                  backgroundColor: AppColors.blue,

                  centerTitle: true,
                  title: Text(
                    l.jobdetail,
                    style: TextStyle(
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: appbarTextSize(context)),
                  ),
                  // Text('Recipes',style: TextStyle(),),
                  elevation: 0.0,
                  bottomOpacity: 0.0,
                  actions: [
                    IconButton(
                        onPressed: () {
                          Share.share(
                            'https://108.jobs/job_detail/$jobID',
                          );
                        },
                        icon: Text(
                          'share',
                          style: solidIconFreeSizedColor(
                              context: context,
                              color: AppColors.white,
                              mediasSize: 23),
                        ))
                  ],
                ),
                preferredSize: Size.fromHeight(appbarsize(context))),

/////// SAVE BOTTOM BAR /////////////////

            bottomNavigationBar: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: visible!
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.0),
                      spreadRadius: visible! ? 2 : 0,
                      blurRadius: visible! ? 2 : 0,
                      offset: visible!
                          ? const Offset(0, -2)
                          : const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Container(
                  // margin: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset:
                            const Offset(0, -3), // changes position of shadow
                      ),
                    ],
                  ),
                  height: mediaWidthSized(context, 8),
                  padding: EdgeInsets.only(
                    top: mediaWidthSized(context, 98),
                    bottom: mediaWidthSized(context, 40),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Mutation(
                        options: MutationOptions(
                          document: gql(queryInfo.seekerunSave),
                          onCompleted: (data) {
                            debugPrint('save completed: ' + data.toString());
                            myJobsave = true;
                            try {
                              refetch!();
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          },
                          onError: (error) {
                            // debugPrint(data);
                            if (error != null) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertPlainDialog(
                                    title: 'Problem',
                                    actions: [
                                      AlertAction(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        title: 'Ok',
                                      )
                                    ],
                                    content: error.graphqlErrors[0].message
                                        .toString(),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        builder: (runMutationunSave, result) {
                          return Mutation(
                            options: MutationOptions(
                              document: gql(queryInfo.seekerSavejob),
                              onCompleted: (data) {
                                debugPrint(
                                    'save completed: ' + data.toString());
                                // refetch();
                              },
                              onError: (error) {
                                // debugPrint(data);
                                if (error != null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertPlainDialog(
                                        title: 'Problem',
                                        actions: [
                                          AlertAction(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            title: 'Ok',
                                          )
                                        ],
                                        content: error.graphqlErrors[0].message
                                            .toString(),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                            builder: (runMutation, result) {
                              return Container(
                                margin: const EdgeInsets.only(
                                    // left: mediaWidthSized(context, 28),
                                    ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      // debugPrint('clickkkk');

                                      if (currentToken != null) {
                                        debugPrint(jobID);
                                        // setState(() {
                                        // saveLoad = false;
                                        // });
                                        if (saved == true) {
                                          runMutationunSave({"JobId": jobID});
                                        } else {
                                          runMutation({"JobId": jobID});
                                        }

                                        saved = !saved!;
                                      } else {
                                        dialogSignin();
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(3)),
                                      border: Border.all(
                                        color: AppColors.orange,
                                        width: 2.5,
                                      ),
                                      color: saved!
                                          ? AppColors.white
                                          : AppColors.orange,
                                    ),
                                    height: mediaWidthSized(context, 11),
                                    width: MediaQuery.of(context).size.width *
                                        2 /
                                        5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('download  ',
                                            style: regularIconFreeSizedColor(
                                                context: context,
                                                color: saved!
                                                    ? AppColors.orange
                                                    : AppColors.white,
                                                mediasSize: 28)),
                                        Text(
                                          saved! ? l.saved : l.savejob,
                                          style: TextStyle(
                                            color: saved!
                                                ? AppColors.orange
                                                : AppColors.white,
                                            fontFamily: 'PoppinsRegular',
                                            fontSize:
                                                mediaWidthSized(context, 28),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(
                        width: mediaWidthSized(context, 70),
                      ),
                      Visibility(
                        visible: isApplied != null && isApplied == false,
                        child: Mutation(
                            options: MutationOptions(
                              document: gql(QueryInfo().applied),
                              onCompleted: (data) {
                                try {
                                  refetch!();
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                                debugPrint(data.toString());
                                if (data.toString() ==
                                    "{__typename: Mutation, appliedJob: Applied succeed}") {
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertPlainDialog(
                                        title:
                                            indexL == 0 ? 'Succeed' : 'ສຳເລັດ',
                                        color: AppColors.blue,
                                        content: indexL == 0
                                            ? 'You already applied this job'
                                            : 'ທ່ານໄດ້ສະໝັກວຽກນີ້ແລ້ວ',
                                        actions: [
                                          AlertAction(
                                            title: l.ok,
                                            onTap: () {
                                              isApplied = true;
                                              setState(() {});

                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              onError: (error) {
                                debugPrint(error.toString());
                                if (error != null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertPlainDialog(
                                        title: 'Problem',
                                        actions: [
                                          AlertAction(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            title: 'Ok',
                                          )
                                        ],
                                        content: error.graphqlErrors[0].message
                                            .toString(),
                                      );
                                    },
                                  );
                                }
                                // showDialog(
                                //   context: context,
                                //   builder: (context) {
                                //     return AlertPlainDialog(
                                //       title: indexL == 0
                                //           ? 'Failed'
                                //           : 'ເກີດຂໍ້ຜິດພາດ',
                                //       color: AppColors.blue,
                                //       content: indexL == 0
                                //           ? 'Please try again'
                                //           : 'ກະລຸນາລອງໃຫມ່ອີກຄັ້ງ',
                                //       actions: [
                                //         AlertAction(
                                //           title: l.ok,
                                //           onTap: () {
                                //             isPressApply = false;
                                //             setState(() {});
                                //             Navigator.pop(context);
                                //             Navigator.pop(context);
                                //           },
                                //         )
                                //       ],
                                //     );
                                //   },
                                // );
                              },
                            ),
                            builder: (runMutationApplied, result) {
                              return Container(
                                margin: const EdgeInsets.only(
                                    // left: mediaWidthSized(context, 28),
                                    ),
                                child: InkWell(
                                  onTap: isApproveCV == true
                                      ? () {
                                          showGeneralDialog(
                                            context: context,
                                            transitionBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              var begin =
                                                  const Offset(0.0, 1.0);
                                              var end = Offset.zero;
                                              var curve = Curves.ease;

                                              var tween = Tween(
                                                      begin: begin, end: end)
                                                  .chain(
                                                      CurveTween(curve: curve));

                                              return SlideTransition(
                                                position:
                                                    animation.drive(tween),
                                                child: child,
                                              );
                                            },
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          color: Colors.black
                                                              .withOpacity(0),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height:
                                                              mediaHeightSized(
                                                                  context, 1),
                                                        ),
                                                      ),
                                                      RotationTransition(
                                                        turns:
                                                            const AlwaysStoppedAnimation(
                                                                355 / 360),
                                                        child: Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  20),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  20),
                                                          color: AppColors.blue,
                                                        ),
                                                      ),
                                                      Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                20),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                20),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                AppColors.white,
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .blue,
                                                                width: 3)),
                                                        child: Scaffold(
                                                          body: Container(
                                                            color:
                                                                AppColors.white,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width -
                                                                          (MediaQuery.of(context).size.width /
                                                                              20),
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal: mediaWidthSized(
                                                                              context,
                                                                              10)),
                                                                      height: mediaWidthSized(
                                                                          context,
                                                                          5),
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Text(
                                                                        indexL ==
                                                                                0
                                                                            ? "You're going to apply for a job    "
                                                                            : "ທ່ານກຳລັງຈະສະໝັກວຽກນີ້   ",
                                                                        style: textStyleBold(
                                                                            context:
                                                                                context,
                                                                            color:
                                                                                Colors.black,
                                                                            size: 17),
                                                                      ),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                              border: Border(bottom: BorderSide(color: AppColors.grey, width: 0.5))),
                                                                    ),
                                                                    SizedBox(
                                                                      height: mediaWidthSized(
                                                                          context,
                                                                          30),
                                                                    ),
                                                                    Container(
                                                                      height: mediaWidthSized(
                                                                          context,
                                                                          3.8),
                                                                      // color: AppColors.greyOpacity,
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal: mediaWidthSized(
                                                                              context,
                                                                              10)),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Flexible(
                                                                                  child: Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        '${indexL == 0 ? 'Position' : 'ຕຳແໜ່ງ'} : ',
                                                                                        style: TextStyle(
                                                                                          color: AppColors.blue,
                                                                                          fontFamily: 'PoppinsRegular',
                                                                                          fontSize: mediaWidthSized(context, 26),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          '${data['findJ']['title']}',
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontFamily: 'PoppinsRegular',
                                                                                            fontSize: mediaWidthSized(context, 26),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                Flexible(
                                                                                  child: Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        '${indexL == 0 ? 'Company' : 'ບໍລິສັດ'} : ',
                                                                                        style: TextStyle(
                                                                                          color: AppColors.blue,
                                                                                          fontFamily: 'PoppinsRegular',
                                                                                          fontSize: mediaWidthSized(context, 26),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          '${data['findJ']['companyName']}',
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontFamily: 'PoppinsRegular',
                                                                                            fontSize: mediaWidthSized(context, 26),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                Flexible(
                                                                                  child: Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        '${indexL == 0 ? 'Salary' : 'ເງິນເດືອນ'} : ',
                                                                                        style: TextStyle(
                                                                                          color: AppColors.blue,
                                                                                          fontFamily: 'PoppinsRegular',
                                                                                          fontSize: mediaWidthSized(context, 26),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          '${data['findJ']['salaryRange']}',
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontFamily: 'PoppinsRegular',
                                                                                            fontSize: mediaWidthSized(context, 26),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: mediaWidthSized(context, 30),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width -
                                                                          (MediaQuery.of(context).size.width /
                                                                              20),
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal: mediaWidthSized(
                                                                              context,
                                                                              10)),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                              border: Border(bottom: BorderSide(color: AppColors.grey, width: 0.5))),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal: mediaWidthSized(
                                                                              context,
                                                                              10)),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                mediaWidthSized(context, 40),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Visibility(
                                                                                visible: coverLetterFile == null,
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                        margin: EdgeInsets.only(
                                                                                          top: mediaWidthSized(context, 40),
                                                                                        ),
                                                                                        child: GestureDetector(
                                                                                          onTap: () {
                                                                                            getCoverletter().then((value) async {
                                                                                              setState(() {});
                                                                                              if (coverLetterFile != null) {
                                                                                                isUploading = true;
                                                                                                try {
                                                                                                  FormData formData = FormData.fromMap({
                                                                                                    "file": await MultipartFile.fromFile(
                                                                                                      coverLetterFile!.path,
                                                                                                      filename: coverLetterFile!.path.split("/").last,
                                                                                                    ),
                                                                                                  });

                                                                                                  final response = await Dio().post(
                                                                                                    queryInfo.apiUpLoadResume,
                                                                                                    data: formData,
                                                                                                    onSendProgress: (count, total) {
                                                                                                      coverletterpercent = count / total * 100;
                                                                                                      // if (count ==
                                                                                                      //     total) {

                                                                                                      // }

                                                                                                      setState(() {});
                                                                                                      debugPrint(coverletterpercent.toString());
                                                                                                    },
                                                                                                  );
                                                                                                  coverLetter = response.data['myFile'];
                                                                                                  isNothiddenUploadTask = 0;
                                                                                                  isUploading = false;
                                                                                                  setState(() {});
                                                                                                } catch (e) {
                                                                                                  debugPrint(e.toString());
                                                                                                }
                                                                                                // await upLoadDioResume(resumeFile.path, queryInfo.apiUpLoadResume)
                                                                                                //     .then((value) {
                                                                                                //   debugPrint(value);
                                                                                                //   resume = value;
                                                                                                // });
                                                                                              }
                                                                                            });
                                                                                          },
                                                                                          child: Container(
                                                                                            color: AppColors.greyShimmer,
                                                                                            height: mediaWidthSized(context, 10),
                                                                                            width: mediaWidthSized(context, 2),
                                                                                            alignment: Alignment.center,
                                                                                            child: Text(
                                                                                              indexL == 0 ? '+ Upload cover letter' : '+ ອັບໂຫຼດຈົດໝາຍສະໝັກວຽກ',
                                                                                              style: textStyleMedium(context: context, color: Colors.black, size: 28),
                                                                                            ),
                                                                                          ),
                                                                                        )),
                                                                                    isCoverLetter == true
                                                                                        ? Container(
                                                                                            margin: EdgeInsets.only(bottom: mediaWidthSized(context, 55)),
                                                                                            child: Text(
                                                                                              indexL == 0 ? '  "Required your Cover letter"' : '  "ຕ້ອງການຈົດໝາຍສະໝັກວຽກ"',
                                                                                              style: textStyleRegular(context: context, color: AppColors.red, size: 30),
                                                                                            ),
                                                                                          )
                                                                                        : Container(
                                                                                            margin: EdgeInsets.only(bottom: mediaWidthSized(context, 40)),
                                                                                          )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Visibility(
                                                                                  visible: coverLetterFile != null,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      AnimatedOpacity(
                                                                                        onEnd: () {
                                                                                          isNothiddenUploadTask = 1;
                                                                                          coverletterpercent = 0;
                                                                                        },
                                                                                        opacity: 0,
                                                                                        duration: const Duration(milliseconds: 1500),
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Row(
                                                                                              children: [
                                                                                                SizedBox(
                                                                                                  width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width / 3.73),
                                                                                                  child: LinearProgressIndicator(
                                                                                                    backgroundColor: AppColors.white,
                                                                                                    value: coverletterpercent! / 100,
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              height: 5,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),

                                                                                      Text(
                                                                                        coverLetter != null ? '$coverLetterFileName' : '(${indexL == 0 ? 'Uploading' : 'ກຳລັງອັບໂຫຼດ'}) $coverLetterFileName',
                                                                                        style: textStyleMedium(context: context, color: coverLetter != null ? Colors.black : Colors.black38, size: 25),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 5,
                                                                                      ),
                                                                                      AnimatedOpacity(
                                                                                        onEnd: () {
                                                                                          isNothiddenUploadTask = 1;
                                                                                          coverletterpercent = 0;
                                                                                        },
                                                                                        opacity: isNothiddenUploadTask!,
                                                                                        duration: const Duration(milliseconds: 1500),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            SizedBox(
                                                                                              width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width / 3.73),
                                                                                              child: LinearProgressIndicator(
                                                                                                backgroundColor: AppColors.white,
                                                                                                value: coverletterpercent! / 100,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      // Text(
                                                                                      //   'Uploading... ',
                                                                                      //   style: textStyleRegular(
                                                                                      //       color: Colors.black,
                                                                                      //       context: context,
                                                                                      //       size: 34),
                                                                                      // ),
                                                                                    ],
                                                                                  ))
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                mediaWidthSized(context, 40),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width -
                                                                          (MediaQuery.of(context).size.width /
                                                                              20),
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal: mediaWidthSized(
                                                                              context,
                                                                              10)),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                              border: Border(bottom: BorderSide(color: AppColors.grey, width: 0.5))),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets.only(
                                                                      left: mediaWidthSized(
                                                                          context,
                                                                          15),
                                                                      bottom: mediaWidthSized(
                                                                          context,
                                                                          20)),
                                                                  child: Row(
                                                                    children: [
                                                                      isPressApply ==
                                                                              false
                                                                          ? MaterialButton(
                                                                              onPressed: () {
                                                                                if (isUploading == true) {
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (context) {
                                                                                      return AlertPlainDialog(
                                                                                        color: AppColors.red,
                                                                                        actions: [
                                                                                          AlertAction(
                                                                                            title: l.ok,
                                                                                            onTap: () {
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                          )
                                                                                        ],
                                                                                        title: indexL == 0 ? 'File upload incomplete' : 'ໄຟລ໌ກຳລັງອັບໂຫຼດ',
                                                                                        content: indexL == 0 ? 'Please wait until your upload finish' : 'ກະລຸນາຖ້າຈົນກວ່າການອັບໂຫຼດຈະສົມບູນ',
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                } else {
                                                                                  if (isCoverLetter == true) {
                                                                                    if (coverLetter != null) {
                                                                                      debugPrint(coverLetter);
                                                                                      runMutationApplied({
                                                                                        "JobId": jobID,
                                                                                        "isCoverLetter": coverLetter
                                                                                      });
                                                                                      isPressApply = true;
                                                                                      setState(() {});
                                                                                    } else {
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (context) {
                                                                                          return AlertDialog(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(15.0),
                                                                                            ),
                                                                                            title: Text(
                                                                                              l.alert,
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(
                                                                                                color: Colors.red,
                                                                                                fontFamily: 'PoppinsSemiBold',
                                                                                                fontSize: mediaWidthSized(context, 22),
                                                                                              ),
                                                                                            ),
                                                                                            content: Text(
                                                                                              indexL == 0 ? 'Coverletter is required' : 'ຕ້ອງມີຈົດໝາຍສະໝັກວຽກ',
                                                                                              style: TextStyle(
                                                                                                // color: Colors.red,
                                                                                                fontFamily: 'PoppinsMedium',
                                                                                                fontSize: mediaWidthSized(context, 28),
                                                                                              ),
                                                                                            ),
                                                                                            actions: [
                                                                                              GestureDetector(
                                                                                                  onTap: () {
                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                  child: Container(
                                                                                                      padding: const EdgeInsets.all(20),
                                                                                                      child: Text(
                                                                                                        l.ok,
                                                                                                        style: TextStyle(
                                                                                                          color: AppColors.blue,
                                                                                                          fontFamily: 'PoppinsSemiBold',
                                                                                                          fontSize: mediaWidthSized(context, 29),
                                                                                                        ),
                                                                                                      )))
                                                                                            ],
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    }
                                                                                  } else {
                                                                                    if (coverLetter == null) {
                                                                                      runMutationApplied({
                                                                                        "JobId": jobID,
                                                                                      });
                                                                                      isPressApply = true;
                                                                                      setState(() {});
                                                                                    } else {
                                                                                      runMutationApplied({
                                                                                        "JobId": jobID,
                                                                                        "isCoverLetter": coverLetter
                                                                                      });
                                                                                      isPressApply = true;
                                                                                      setState(() {});
                                                                                    }
                                                                                  }
                                                                                }
                                                                              },
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                      decoration: const BoxDecoration(
                                                                                        // borderRadius: BorderRadius.circular(5),
                                                                                        color: AppColors.blue,
                                                                                      ),
                                                                                      child: Container(
                                                                                        height: mediaWidthSized(context, 10),
                                                                                        alignment: Alignment.center,
                                                                                        width: mediaWidthSized(context, 3),
                                                                                        child: Text(
                                                                                          indexL == 0 ? 'Yes, Apply now' : 'ສະໝັກຕອນນີ້',
                                                                                          style: TextStyle(
                                                                                            color: AppColors.white,
                                                                                            fontFamily: 'PoppinsRegular',
                                                                                            fontSize: mediaWidthSized(context, 25),
                                                                                          ),
                                                                                        ),
                                                                                      )),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          : Container(
                                                                              margin: EdgeInsets.symmetric(horizontal: mediaWidthSized(context, 5.5)),
                                                                              height: mediaWidthSized(context, 20),
                                                                              width: mediaWidthSized(context, 20),
                                                                              child: const CircularProgressIndicator(),
                                                                            ),
                                                                      MaterialButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                                decoration: const BoxDecoration(
                                                                                  // borderRadius: BorderRadius.circular(5),
                                                                                  color: AppColors.greyShimmer,
                                                                                ),
                                                                                child: Container(
                                                                                  height: mediaWidthSized(context, 10),
                                                                                  alignment: Alignment.center,
                                                                                  width: mediaWidthSized(context, 4),
                                                                                  child: Text(
                                                                                    indexL == 0 ? 'Cancel' : 'ຍົກເລີກ',
                                                                                    style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontFamily: 'PoppinsRegular',
                                                                                      fontSize: mediaWidthSized(context, 25),
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          );
                                          // if (isCoverLetter == true) {
                                          // } else {}
                                        }
                                      : null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(3)),
                                      border: Border.all(
                                        color: isApproveCV == false
                                            ? AppColors.greyOpacity
                                            : AppColors.blue,
                                        width: 2.5,
                                      ),
                                      color: isApproveCV == false
                                          ? AppColors.greyOpacity
                                          : AppColors.blue,
                                    ),
                                    height: mediaWidthSized(context, 11),
                                    width: MediaQuery.of(context).size.width *
                                        2.8 /
                                        5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'share  ',
                                          style: solidIconFreeSizedColor(
                                              color: AppColors.white,
                                              context: context,
                                              mediasSize: 28),
                                        ),
                                        Text(
                                          l.applyjob,
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontFamily: 'PoppinsRegular',
                                            fontSize:
                                                mediaWidthSized(context, 28),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Visibility(
                        visible: isApplied != null && isApplied == true,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(3)),
                              border: Border.all(
                                color: AppColors.greyWhite,
                                width: 2.5,
                              ),
                              color: AppColors.white),
                          height: mediaWidthSized(context, 11),
                          width: MediaQuery.of(context).size.width * 2.8 / 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'check-circle  ',
                                style: regularIconFreeSizedColor(
                                    context: context,
                                    color: AppColors.green,
                                    mediasSize: 25),
                              ),
                              Text(
                                l.appliedjob,
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: mediaWidthSized(context, 28),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: currentToken == null,
                        child: GestureDetector(
                          onTap: () {
                            dialogSignin();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(3)),
                              border: Border.all(
                                color: AppColors.blue,
                                width: 2.5,
                              ),
                              color: AppColors.blue,
                            ),
                            height: mediaWidthSized(context, 11),
                            width: MediaQuery.of(context).size.width * 2.8 / 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'share  ',
                                  style: solidIconFreeSizedColor(
                                      color: AppColors.white,
                                      context: context,
                                      mediasSize: 28),
                                ),
                                Text(
                                  l.applyjob,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontFamily: 'PoppinsRegular',
                                    fontSize: mediaWidthSized(context, 28),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            /////// SAVE BOTTOM BAR /////////////////
            ///
            ///
            ///
            ///

            body: ListView(
              controller: scroll,
              children: [
                // SizedBox(
                //   height: 17,
                // ),
                WidgetCompanyListView(
                  picture: '${data?['findJ']['logo']}',
                  onTap: () {
                    debugPrint(data['findJ']['companyID']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompanyDetailPage(
                                data['findJ']['companyID'],
                              )),
                    );
                  },
                  companyName: '${data['findJ']['companyName']}',
                  // bio: '${industry.join('/')}',
                  location: indexL == 0 ? ' ' : ' ',
                  //${data['findJ']['employerId']['districtId']['name']}
                  openingAmount: findE1.toString(),
                  bio: '${data['findJ']['industry']}',
                ),
                Container(
                  // margin: EdgeInsets.only(
                  //     left: 17,
                  //     right: 17,

                  padding: const EdgeInsets.only(
                      top: 10, right: 20, left: 20, bottom: 12),
                  decoration: const BoxDecoration(
                      // borderRadius: BorderRadius.all(Radius.circular(3)),
                      border: Border(
                          bottom: BorderSide(
                              width: 0.5, color: AppColors.greyOpacity))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data['findJ']['title']}',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'PoppinsSemiBold',
                              fontSize: mediaWidthSized(context, 26),
                            ),
                          ),
                          SizedBox(
                            height: mediaWidthSized(context, 180),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${l.workinglocation}: ',
                                style: TextStyle(
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: mediaWidthSized(context, 30),
                                ),
                              ),
                              SizedBox(
                                height: mediaWidthSized(context, 180),
                              ),
                              Expanded(
                                child: Text(
                                  '${data['findJ']['workingLocation']}',
                                  // indexL == 0
                                  //     ? locateList.join(', ')
                                  //     : '${laoProvince.join(', ')}',
                                  style: TextStyle(
                                    color: AppColors.blue,
                                    fontFamily: 'PoppinsRegular',
                                    fontSize: mediaWidthSized(context, 30),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: mediaWidthSized(context, 180),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${l.date}: ',
                                style: TextStyle(
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: mediaWidthSized(context, 30),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      '${data['findJ']['openingDate']} ',
                                      style: TextStyle(
                                        color: AppColors.blue,
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: mediaWidthSized(context, 30),
                                      ),
                                    ),
                                    Text(
                                      ' ${l.to} ',
                                      style: TextStyle(
                                        // color: Colors.black,
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: mediaWidthSized(context, 30),
                                      ),
                                    ),
                                    Text(
                                      '${data['findJ']['closingDate']} ',
                                      style: TextStyle(
                                        color: AppColors.blue,
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: mediaWidthSized(context, 30),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: mediaWidthSized(context, 180),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${l.salary}: ',
                            style: TextStyle(
                              fontFamily: 'PoppinsRegular',
                              fontSize: mediaWidthSized(context, 30),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${data['findJ']['salaryRange']}',
                              style: TextStyle(
                                color: AppColors.blue,
                                fontFamily: 'PoppinsRegular',
                                fontSize: mediaWidthSized(context, 30),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: mediaWidthSized(context, 180),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${l.eduLevel}: ',
                            style: TextStyle(
                              fontFamily: 'PoppinsRegular',
                              fontSize: mediaWidthSized(context, 30),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${data['findJ']['jobEductionLevel']}',
                              style: TextStyle(
                                color: AppColors.blue,
                                fontFamily: 'PoppinsRegular',
                                fontSize: mediaWidthSized(context, 30),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 180,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${l.workingexpe}: ',
                            style: TextStyle(
                              fontFamily: 'PoppinsRegular',
                              fontSize: mediaWidthSized(context, 30),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${data['findJ']['jobExperience']}',
                              style: TextStyle(
                                color: AppColors.blue,
                                fontFamily: 'PoppinsRegular',
                                fontSize: mediaWidthSized(context, 30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(left: 17, right: 17, bottom: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                      // borderRadius: BorderRadius.all(Radius.circular(3)),
                      border: Border(
                          bottom: BorderSide(
                              color: AppColors.greyOpacity, width: 0.5))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${l.jobDescript}:',
                        style: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          color: Colors.black,
                          fontSize: mediaWidthSized(context, 26),
                        ),
                      ),
                      HtmlWidget(
                        '''${data['findJ']['description']}''',
                        onTapUrl: (url) {
                          launchURL(url);
                          return true;
                        },
                        // customWidgetBuilder: (element) {
                        //   if (element.children.toString() == '[<html img>]') {
                        //     String str = element.children.toString();
                        //     String start = '"';
                        //     String end = 'g"';

                        //     int startIndex = str.indexOf(start);
                        //     int endIndex =
                        //         str.indexOf(end, startIndex + start.length);
                        //     debugPrint(startIndex.toString() +
                        //         ' and ' +
                        //         endIndex.toString());
                        //     // debugPrint(str.substring(
                        //     //     startIndex + start.length, endIndex));
                        //   }

                        //   return Container();
                        // },
                        // onTapImage: (link) {

                        // },
                        textStyle: TextStyle(
                          fontFamily: 'PoppinsRegular',
                          fontSize: mediaWidthSized(context, 30),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
