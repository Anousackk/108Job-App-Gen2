// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_typing_uninitialized_variables, unused_field, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unused_local_variable, avoid_print, file_names, use_full_hex_values_for_flutter_colors

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/screenAfterSignIn/company/companyDetail.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class JobSearchDetail extends StatefulWidget {
  const JobSearchDetail({Key? key, this.jobId, this.newJob, this.status})
      : super(key: key);
  static String routeName = '/JobSearchDetail';
  final jobId;
  final newJob;
  final status;

  @override
  State<JobSearchDetail> createState() => _JobSearchDetailState();
}

class _JobSearchDetailState extends State<JobSearchDetail> {
  String _id = "";
  String _companyID = "";
  String _companyName = "";
  String _logo = "";
  String _industry = "";
  String _address = "";
  String _title = "";
  String _jobFunction = "";
  String _workLocation = "";
  dynamic _openDate;
  dynamic _closeDate;
  String _salary = "";
  String _education = "";
  String _experience = "";
  String _description = "";
  List _allOnlineJob = [];
  bool _isShowSalary = false;
  bool _isSaved = false;
  bool _isApplied = false;
  bool _isLoading = false;
  bool _isFollow = false;

  String _callBackJobSearchId = "";
  dynamic _callBackIsSave;

  // String _checkNewJobFunctioin = "";
  String _checkStatusCallBack = "";

  fetchJobSearchDetail(dynamic jobId) async {
    print("2" + jobId.toString());

    var res = await fetchData(getJobSearchDetailSeekerApi + jobId);
    // print("${res}");
    dynamic _jobDetail = res['jobDetail'];

    _id = _jobDetail['jobId'];
    _companyID = _jobDetail['companyID'];
    _companyName = _jobDetail['companyName'];
    _logo = _jobDetail['logo'];
    _industry = _jobDetail['industry'];
    _address = _jobDetail['address'];

    _title = _jobDetail['title'];
    _jobFunction = _jobDetail['jobFunction'];
    _salary = _jobDetail['salaryRange'];
    _isShowSalary = _jobDetail['isShowSalary'];
    _workLocation = _jobDetail['workingLocations'];
    _education = _jobDetail['jobEductionLevel'];
    _experience = _jobDetail['jobExperience'];
    _openDate = _jobDetail['openingDate'];
    _closeDate = _jobDetail['closingDate'];
    _isFollow = _jobDetail["follow"];

    if (widget.status == true) {
      setState(() {
        _callBackJobSearchId = widget.jobId;
      });
    }

    //
    //Open Date
    //pars ISO to Flutter DateTime
    parsDateTime(value: '', currentFormat: '', desiredFormat: '');
    DateTime openDate = parsDateTime(
        value: _openDate,
        currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
        desiredFormat: "yyyy-MM-dd HH:mm:ss");
    //
    //Format to string 13-03-2024
    _openDate = DateFormat('dd-MM-yyyy').format(openDate);

    //
    //Close Date
    //pars ISO to Flutter DateTime
    parsDateTime(value: '', currentFormat: '', desiredFormat: '');
    DateTime closeDate = parsDateTime(
        value: _closeDate,
        currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
        desiredFormat: "yyyy-MM-dd HH:mm:ss");
    //
    //Format to string 13 Feb 2024
    _closeDate = DateFormat("dd-MM-yyyy").format(closeDate);

    _description = _jobDetail['description'];
    _isSaved = _jobDetail['isSaved'];
    _isApplied = _jobDetail['isApplied'];
    _allOnlineJob = res['allOnlineJob'];
    _isLoading = false;

    if (widget.newJob == true) {
      // _checkStatusCallBack = "Success";
    }

    if (mounted) {
      setState(() {});
    }
  }

  saveAndUnSaveJob() async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertLoading();
      },
    );

    var res = await postData(saveJobSeekerApi, {
      "_id": "",
      "JobId": _id,
    });
    print(res);

    if (res['message'] == "Saved" || res['message'] == "Unsaved") {
      Navigator.pop(context);
    }

    if (res['message'] == "Saved") {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomAlertDialogSuccess(
            title: "successful".tr,
            text: "$_title " + "save job".tr + "successful".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
              // Navigator.of(context).pop('Success');
              setState(() {
                _checkStatusCallBack = "Success";
              });
            },
          );
        },
      );
    } else if (res['message'] == "Unsaved") {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomAlertDialogSuccess(
            title: "successful".tr,
            text: "$_title " + "unsave job".tr + "successful".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
              // Navigator.of(context).pop('Success');
              setState(() {
                _checkStatusCallBack = "Success";
              });
            },
          );
        },
      );
    }
  }

  applyJob() async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertLoading();
      },
    );

    var res = await postData(applyJobSeekerApi, {
      "JobId": _id,
      "isCoverLetter": null,
    });
    var message = res['message'];

    print(res);
    if (message == "Applied succeed") {
      Navigator.pop(context);
      setState(() {
        _isApplied = !_isApplied;
      });

      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomAlertDialogSuccess(
            title: "successful".tr,
            text: "$_title ".tr + "apply".tr + "successful".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
              // Navigator.of(context).pop('Success');
              setState(() {
                _checkStatusCallBack = "Success";
              });
            },
          );
        },
      );
    } else {
      Navigator.pop(context);

      await showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialogWarning(
            title: "warning".tr,
            text: "$message",
          );
        },
      );
    }
  }

  followCompany(String companyName, String companyId) async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertLoading();
      },
    );

    var res = await postData(addFollowCompanySeekerApi + '${companyId}', {});
    var message = res['message'];
    print(message);

    if (message == "Followed") {
      Navigator.pop(context);

      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomAlertDialogSuccess(
            title: "successful".tr,
            text: "$companyName " + "followed".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
            },
          );
        },
      );
    } else if (message == "Unfollow") {
      Navigator.pop(context);

      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomAlertDialogSuccess(
            title: "successful".tr,
            text: "$companyName " + "unfollowed".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  //
  //api ໃຊ້ກວດ isNew(status of new jobsearch) ຖ້າເປັນຄ່າ true ໃຫ້ເຊັດເປັນ false
  // fetchCheckNewJobSearch(id) async {
  //   var res = await postData("${checkNewJobSearchSeekerApi}/${id}", {});
  //   _checkNewJobFunctioin = res['message'];
  //   print(_checkNewJobFunctioin);
  //   setState(() {});
  // }

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
    print("1" + widget.jobId.toString());
    fetchJobSearchDetail(widget.jobId);
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
        // appBar: AppBarDefault(
        //   backgroundColor: AppColors.background,
        //   textTitle: "",
        //   // fontWeight: FontWeight.bold,
        //   leadingIcon: Icon(
        //     Icons.arrow_back,
        //     color: AppColors.iconDark,
        //   ),
        //   leadingPress: () {
        //     Navigator.of(context).pop(_checkStatusCallBack);
        //   },
        // ),
        body: SafeArea(
          child: _isLoading
              ? Container(
                  color: AppColors.backgroundWhite,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: AppColors.backgroundWhite,
                  child: Column(
                    children: [
                      //
                      //
                      //
                      //
                      //
                      //Button back
                      Container(
                        // padding: EdgeInsets.symmetric(
                        //   horizontal: 20,
                        // ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop([
                                  _checkStatusCallBack,
                                  _callBackJobSearchId,
                                  _callBackIsSave
                                ]);
                              },
                              child: Container(
                                color: AppColors.backgroundWhite,
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "\uf060",
                                  style: fontAwesomeRegular(
                                      null, 20, AppColors.iconDark, null),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text("valid_until".tr + ": ${_closeDate}"),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 15,
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Column(
                            children: [
                              //
                              //
                              //
                              //
                              //
                              //
                              //Section1
                              //Job Title,
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Column(
                                      children: [
                                        Text(
                                          "${_title}",
                                          style: bodyTextMedium(
                                              null, FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        //
                                        //Job Title
                                        Text(
                                          "${_jobFunction}",
                                          style: bodyTextNormal(
                                              AppColors.fontGreyOpacity, null),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),

                                  //
                                  //
                                  //
                                  //SingleChildScrollView
                                  //WorkLocation, Education, Experience, Salary, Opening, Close
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: ClampingScrollPhysics(),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.greyWhite,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 8),
                                              child: Text(
                                                "${_workLocation}",
                                                style: bodyTextSmall(null),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.greyWhite,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 8),
                                              child: Text(
                                                "${_education}",
                                                style: bodyTextSmall(null),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.greyWhite,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 8),
                                              child: Text(
                                                "${_experience}",
                                                style: bodyTextSmall(null),
                                              ),
                                            ),
                                          ),
                                          if (!_isShowSalary)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.greyWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8),
                                                child: Text(
                                                  "${_salary}",
                                                  style: bodyTextSmall(null),
                                                ),
                                              ),
                                            ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.greyWhite,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 8),
                                            child: Text(
                                              "${_openDate} - ${_closeDate}",
                                              style: bodyTextSmall(null),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              //
                              //
                              //
                              //
                              //Section 2
                              //Job Description
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundWhite,
                                    // borderRadius: BorderRadius.circular(10),
                                    border: Border.symmetric(
                                      horizontal:
                                          BorderSide(color: AppColors.borderBG),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "job description".tr,
                                        style: bodyTextMaxNormal(
                                            null, FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //
                                      //HtmlWidget
                                      HtmlWidget(
                                        '''
                                    $_description
                                  ''',
                                        onTapUrl: (url) {
                                          launchInBrowser(Uri.parse(url));
                                          return true;
                                        },
                                        textStyle: bodyTextNormal(null, null),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              //
                              //
                              //Section3
                              //Profile Image, Company, Industry, Job Opening
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CompanyDetail(
                                        companyId: _companyID,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.backgroundWhite,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: AppColors.borderBG)),
                                    padding: EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        //
                                        //Profile Image
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: AppColors.backgroundWhite,
                                              border: Border.all(
                                                  color: AppColors.borderBG)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Center(
                                              child: _logo == ""
                                                  ? Image.asset(
                                                      'assets/image/no-image-available.png',
                                                      fit: BoxFit.contain,
                                                    )
                                                  : Image.network(
                                                      "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${_logo}",
                                                      fit: BoxFit.contain,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Image.asset(
                                                          'assets/image/no-image-available.png',
                                                          fit: BoxFit.contain,
                                                        ); // Display an error message
                                                      },
                                                    ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                //
                                                //Company Name
                                                Text(
                                                  "${_companyName}",
                                                  style: bodyTextNormal(
                                                      null, null),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),

                                                //
                                                //Industry
                                                Text(
                                                  "${_industry}",
                                                  style: bodyTextSmall(null),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),

                                                //
                                                //Address
                                                Text(
                                                  "${_address}",
                                                  style: bodyTextSmall(null),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),

                                                //
                                                //Job Opening
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${_allOnlineJob.length} ",
                                                      style:
                                                          bodyTextSmall(null),
                                                    ),
                                                    Text(
                                                      "follower".tr,
                                                      style:
                                                          bodyTextSmall(null),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        //
                                        //Icon chevronRight

                                        //
                                        //
                                        //Bottom follower / following
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     followCompany(
                                        //       _companyName,
                                        //       _companyID,
                                        //     );
                                        //     setState(() {
                                        //       _isFollow = !_isFollow;
                                        //     });
                                        //   },
                                        //   child: _isFollow
                                        //       ? Container(
                                        //           padding: EdgeInsets.all(8),
                                        //           decoration: BoxDecoration(
                                        //             color:
                                        //                 AppColors.buttonPrimary,
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     8),
                                        //             border: Border.all(
                                        //                 color: AppColors
                                        //                     .borderGreyOpacity),
                                        //           ),
                                        //           child: Row(
                                        //             children: [
                                        //               FaIcon(
                                        //                 FontAwesomeIcons.heart,
                                        //                 size: 13,
                                        //                 color:
                                        //                     AppColors.iconLight,
                                        //               ),
                                        //               SizedBox(
                                        //                 width: 8,
                                        //               ),
                                        //               Text(
                                        //                 "following".tr,
                                        //                 style: bodyTextSmall(
                                        //                     AppColors
                                        //                         .fontWhite),
                                        //               ),
                                        //             ],
                                        //           ),
                                        //         )
                                        //       : Container(
                                        //           padding: EdgeInsets.all(8),
                                        //           decoration: BoxDecoration(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     8),
                                        //             border: Border.all(
                                        //               color: AppColors
                                        //                   .borderGreyOpacity,
                                        //             ),
                                        //           ),
                                        //           child: Row(
                                        //             children: [
                                        //               FaIcon(
                                        //                 FontAwesomeIcons.heart,
                                        //                 size: 13,
                                        //               ),
                                        //               SizedBox(
                                        //                 width: 8,
                                        //               ),
                                        //               Text(
                                        //                 "follow".tr,
                                        //                 style:
                                        //                     bodyTextSmall(null),
                                        //               ),
                                        //             ],
                                        //           ),
                                        //         ),
                                        // )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
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
                      //
                      //
                      //
                      //
                      //Button Save job and Apply job
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundWhite,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x000000).withOpacity(0.05),
                              offset: Offset(0, -6),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
                          // border: Border(
                          //   top: BorderSide(color: AppColors.borderGreyOpacity),
                          // ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: !_isSaved
                                  ? ButtonWithIconLeft(
                                      paddingButton:
                                          WidgetStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(10),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(1.5.w),
                                      buttonBorderColor:
                                          AppColors.backgroundWhite,
                                      colorButton: AppColors.buttonWhite,
                                      widgetIcon: FaIcon(
                                        FontAwesomeIcons.heart,
                                        color: AppColors.iconDark,
                                        size: IconSize.xsIcon,
                                      ),
                                      colorText: AppColors.fontDark,
                                      // fontWeight: FontWeight.bold,
                                      text: "save job".tr,
                                      press: () {
                                        setState(() {
                                          _isSaved = !_isSaved;
                                          _callBackJobSearchId = _id;
                                          _callBackIsSave = _isSaved;
                                        });
                                        saveAndUnSaveJob();
                                      },
                                    )
                                  : ButtonWithIconLeft(
                                      paddingButton:
                                          WidgetStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(10),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(1.5.w),
                                      buttonBorderColor:
                                          AppColors.backgroundWhite,
                                      colorButton: AppColors.backgroundWhite,
                                      widgetIcon: FaIcon(
                                        FontAwesomeIcons.solidHeart,
                                        color: AppColors.iconPrimary,
                                        size: IconSize.xsIcon,
                                      ),
                                      colorText: AppColors.fontPrimary,
                                      // fontWeight: FontWeight.bold,
                                      text: "saved".tr,
                                      press: () {
                                        saveAndUnSaveJob();
                                        setState(() {
                                          _isSaved = !_isSaved;
                                          _callBackJobSearchId = _id;
                                          _callBackIsSave = _isSaved;
                                        });
                                      },
                                    ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: !_isApplied
                                  ? ButtonWithIconLeft(
                                      paddingButton:
                                          WidgetStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(10),
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                      colorButton: AppColors.buttonPrimary,
                                      widgetIcon: FaIcon(
                                        FontAwesomeIcons.paperPlane,
                                        color: AppColors.iconLight,
                                        size: IconSize.xsIcon,
                                      ),
                                      colorText: AppColors.fontWhite,
                                      // fontWeight: FontWeight.bold,
                                      text: "apply".tr,
                                      press: () {
                                        applyJob();
                                      },
                                    )
                                  : ButtonWithIconLeft(
                                      paddingButton:
                                          WidgetStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(10),
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                      buttonBorderColor: AppColors.borderWaring,
                                      colorButton: AppColors.lightOrange,
                                      widgetIcon: FaIcon(
                                        FontAwesomeIcons.paperPlane,
                                        color: AppColors.iconWarning,
                                      ),
                                      colorText: AppColors.fontWaring,
                                      // fontWeight: FontWeight.bold,
                                      text: "applied".tr,
                                      press: () {
                                        applyJob();
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 30,
                      // ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
