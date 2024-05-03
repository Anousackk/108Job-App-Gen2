// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_typing_uninitialized_variables, unused_field, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unused_local_variable, avoid_print

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/screenAfterSignIn/company/companyDetail.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class JobSearchDetail extends StatefulWidget {
  const JobSearchDetail({Key? key, this.jobId, this.newJob}) : super(key: key);
  final jobId;
  final newJob;

  @override
  State<JobSearchDetail> createState() => _JobSearchDetailState();
}

class _JobSearchDetailState extends State<JobSearchDetail> {
  String _id = "";
  String _companyID = "";
  String _companyName = "";
  String _logo = "";
  String _industry = "";
  String _title = "";
  String _workLocation = "";
  dynamic _openDate;
  dynamic _closeDate;
  String _salary = "";
  String _education = "";
  String _experience = "";
  String _description = "";
  List _allOnlineJob = [];
  bool _isSaved = false;
  bool _isLoading = false;

  String _checkNewJobFunctioin = "eiei";

  fetchJobSearchDetail(dynamic jobId) async {
    var res = await fetchData(getJobSearchDetailSeekerApi + jobId);
    dynamic _jobDetail = res['jobDetail'];

    _id = _jobDetail['jobId'];
    _companyID = _jobDetail['companyID'];
    _companyName = _jobDetail['companyName'];
    _logo = _jobDetail['logo'];
    _industry = _jobDetail['industry'];

    _title = _jobDetail['title'];
    _salary = _jobDetail['salaryRange'];
    _workLocation = _jobDetail['workingLocations'];
    _education = _jobDetail['jobEductionLevel'];
    _experience = _jobDetail['jobExperience'];
    _openDate = _jobDetail['openingDate'];
    _closeDate = _jobDetail['closingDate'];

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
    _allOnlineJob = res['allOnlineJob'];
    _isLoading = false;

    if (widget.newJob == true) {
      _checkNewJobFunctioin = "Success";
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
            title: "Success",
            text: "$_title Save Job Success",
            textButton: "OK",
            press: () {
              Navigator.pop(context);
              Navigator.of(context).pop('Success');
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
            title: "Success",
            text: "$_title Unsave Job Success",
            textButton: "OK",
            press: () {
              Navigator.pop(context);
              Navigator.of(context).pop('Success');
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
        appBar: AppBarDefault(
          textTitle: "Job Detail",
          // fontWeight: FontWeight.bold,
          leadingIcon: Icon(Icons.arrow_back),
          leadingPress: () {
            Navigator.of(context).pop(_checkNewJobFunctioin);
          },
        ),
        body: SafeArea(
          child: _isLoading
              ? Container(
                  color: AppColors.background,
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
                      Expanded(
                        flex: 15,
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),

                              //
                              //
                              //Section1
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
                                child: Container(
                                  color: AppColors.backgroundWhite,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
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
                                        ),
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
                                        width: 15,
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
                                                style: bodyTextMaxNormal(
                                                    null, FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              //
                                              //Industry
                                              Text("${_industry}"),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              //
                                              //Job Opening
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Job Opening: "),
                                                  Text(
                                                    "${_allOnlineJob.length}",
                                                    style: bodyTextNormal(
                                                        AppColors.fontPrimary,
                                                        null),
                                                  )
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
                                      Container(
                                        child: FaIcon(
                                          FontAwesomeIcons.chevronRight,
                                          size: IconSize.sIcon,
                                          color: AppColors.iconPrimary,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Divider(
                                color: AppColors.borderSecondary,
                              ),
                              SizedBox(
                                height: 15,
                              ),

                              //
                              //
                              //Section2
                              //Job Title, Working Location, Date, Salary, Education Level, Working Experince
                              Container(
                                // color: AppColors.lightBlue,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //
                                    //Job Title
                                    Text(
                                      "${_title}",
                                      style: bodyTextMaxNormal(
                                          null, FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    //
                                    //Working Location
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Working Location:  "),
                                        Expanded(
                                          child: Text(
                                            "${_workLocation}",
                                            style: bodyTextNormal(
                                                AppColors.fontPrimary, null),
                                            overflow: TextOverflow.fade,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    //
                                    //Open date to Close date
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Date:  "),
                                        Text(
                                          "${_openDate}",
                                          style: bodyTextNormal(
                                              AppColors.fontPrimary, null),
                                        ),
                                        Text(" to "),
                                        Text(
                                          "${_closeDate}",
                                          style: bodyTextNormal(
                                              AppColors.fontPrimary, null),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    //
                                    //Salart
                                    Row(
                                      children: [
                                        Text("Salary:  "),
                                        Expanded(
                                          child: Text(
                                            "${_salary}",
                                            style: bodyTextNormal(
                                                AppColors.fontPrimary, null),
                                            overflow: TextOverflow.fade,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    //
                                    //Education Level
                                    Row(
                                      children: [
                                        Text("Education Level:  "),
                                        Expanded(
                                          child: Text(
                                            "${_education}",
                                            style: bodyTextNormal(
                                                AppColors.fontPrimary, null),
                                            overflow: TextOverflow.fade,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    //
                                    //Working Experince
                                    Row(
                                      children: [
                                        Text("Working Experience:  "),
                                        Expanded(
                                          child: Text(
                                            "${_experience}",
                                            style: bodyTextNormal(
                                                AppColors.fontPrimary, null),
                                            overflow: TextOverflow.fade,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Divider(
                                color: AppColors.borderSecondary,
                              ),
                              SizedBox(
                                height: 15,
                              ),

                              //
                              //
                              //Section 3
                              //Job Description
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Job Description: ",
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
                              SizedBox(
                                height: 30,
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
                      //Button Save job and Apply job
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: !_isSaved
                                  ? ButtonWithIconLeft(
                                      paddingButton:
                                          MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.symmetric(vertical: 15),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(1.5.w),
                                      buttonBorderColor:
                                          AppColors.borderPrimary,
                                      colorButton: AppColors.buttonPrimary,
                                      widgetIcon: FaIcon(
                                        FontAwesomeIcons.heart,
                                        color: AppColors.iconLight,
                                      ),
                                      colorText: AppColors.fontWhite,
                                      fontWeight: FontWeight.bold,
                                      text: "Save job",
                                      press: () {
                                        saveAndUnSaveJob();
                                      },
                                    )
                                  : ButtonWithIconLeft(
                                      paddingButton:
                                          MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.symmetric(vertical: 15),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(1.5.w),
                                      buttonBorderColor:
                                          AppColors.borderPrimary,
                                      colorButton: AppColors.lightPrimary,
                                      widgetIcon: FaIcon(
                                        FontAwesomeIcons.solidHeart,
                                        color: AppColors.iconPrimary,
                                      ),
                                      colorText: AppColors.fontPrimary,
                                      fontWeight: FontWeight.bold,
                                      text: "Saved",
                                      press: () {
                                        saveAndUnSaveJob();
                                      },
                                    ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: ButtonWithIconLeft(
                                paddingButton:
                                    MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.symmetric(vertical: 15),
                                ),
                                borderRadius: BorderRadius.circular(1.5.w),
                                colorButton: AppColors.buttonWarning,
                                widgetIcon: FaIcon(
                                  FontAwesomeIcons.locationArrow,
                                  color: AppColors.iconLight,
                                ),
                                colorText: AppColors.fontWhite,
                                fontWeight: FontWeight.bold,
                                text: "Apply job",
                                press: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
