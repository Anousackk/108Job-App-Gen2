// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_local_variable, prefer_final_fields, unused_field, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, avoid_print, prefer_is_empty, prefer_if_null_operators

import 'dart:async';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearchDetail.dart';
import 'package:app/widget/input.dart';
import 'package:app/widget/screenNoData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class MyJobs extends StatefulWidget {
  const MyJobs({Key? key}) : super(key: key);

  @override
  State<MyJobs> createState() => _MyJobsState();
}

class _MyJobsState extends State<MyJobs> {
  TextEditingController _searchTitleController = TextEditingController();

  List _listMyJobs = [];
  String _total = "";
  String _searchTitle = "";
  String _typeMyJob = "SeekerSaveJob";
  String _textTotal = " Job you have saved";
  String _textAlert = "Unsave Job Success";

  String _logo = "";
  String _jobTitle = "";
  String _companyName = "";
  String _workLocation = "";
  String _views = "";

  dynamic _openDate;
  dynamic _closeDate;

  Timer? _timer;

  bool _statusShowLoading = false;
  bool _isLoading = false;

  fetchMyJob(String type) async {
    //
    //ສະແດງ AlertDialog Loading
    if (_statusShowLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomAlertLoading();
        },
      );
    }

    var res = await postData(getMyJobSeekerApi, {
      "type": type,
      "search": _searchTitle,
      "page": 1,
      "perPage": 1000,
    });

    _listMyJobs = res['info'];
    _total = res['totals'].toString();

    if (res['info'] != null && _statusShowLoading) {
      _statusShowLoading = false;
      Navigator.pop(context);
    }

    _isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  onGoBack(dynamic value) async {
    print("onGoBack");
    await fetchMyJob(_typeMyJob);
  }

  pressTapMyJobType(String val) async {
    setState(() {
      _typeMyJob = val;

      if (_typeMyJob == "SeekerSaveJob") {
        _isLoading = true;
        _textTotal = " Job you have saved";
        _textAlert = "Unsave Job Success";
      } else if (_typeMyJob == "AppliedJob") {
        _isLoading = true;
        _textTotal = " Job you have applied";
      } else if (_typeMyJob == "JobAlert") {
        _isLoading = true;
        _textTotal = " Job you have alert";
      } else if (_typeMyJob == "SeekerHideJob") {
        _isLoading = true;
        _textTotal = " Job you have hidded";
        _textAlert = "UnHide Job Success";
      }
    });
    fetchMyJob(val);
  }

  deleteMyJob(String id, String type, String title) async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertLoading();
      },
    );

    var res = await postData(deleteMyJobSeekerApi, {
      "_id": id,
      "type": type,
    });
    print(res);

    if (res['message'] == "Delete succeed") {
      await fetchMyJob(_typeMyJob);
      Navigator.pop(context);
    }

    if (res['message'] == "Delete succeed") {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomAlertDialogSuccess(
            title: "Success",
            text: "$title $_textAlert",
            textButton: "OK",
            press: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    fetchMyJob(_typeMyJob);

    _searchTitleController.text = _searchTitle;
  }

  @override
  void dispose() {
    _searchTitleController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScopeNode();
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: GestureDetector(
        onTap: () {
          currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            // setState(() {
            //   _isFocusIconColorTelAndEmail = false;
            // });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
          ),
          body: SafeArea(
            child: Container(
              color: AppColors.background,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.borderSecondary),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              pressTapMyJobType('SeekerSaveJob');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 17, vertical: 10),
                              decoration: BoxDecoration(
                                color: _typeMyJob == "SeekerSaveJob"
                                    ? AppColors.buttonPrimary
                                    : AppColors.buttonGrey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Saved Job",
                                style: bodyTextNormal(
                                    _typeMyJob == "SeekerSaveJob"
                                        ? AppColors.fontWhite
                                        : AppColors.fontGreyOpacity,
                                    null),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              pressTapMyJobType('AppliedJob');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 17, vertical: 10),
                              decoration: BoxDecoration(
                                  color: _typeMyJob == "AppliedJob"
                                      ? AppColors.buttonPrimary
                                      : AppColors.buttonGrey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Applied Job",
                                style: bodyTextNormal(
                                    _typeMyJob == "AppliedJob"
                                        ? AppColors.fontWhite
                                        : AppColors.fontGreyOpacity,
                                    null),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              pressTapMyJobType('JobAlert');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 17, vertical: 10),
                              decoration: BoxDecoration(
                                  color: _typeMyJob == "JobAlert"
                                      ? AppColors.buttonPrimary
                                      : AppColors.buttonGrey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Job Alert",
                                style: bodyTextNormal(
                                    _typeMyJob == "JobAlert"
                                        ? AppColors.fontWhite
                                        : AppColors.fontGreyOpacity,
                                    null),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              pressTapMyJobType('SeekerHideJob');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 17, vertical: 10),
                              decoration: BoxDecoration(
                                  color: _typeMyJob == "SeekerHideJob"
                                      ? AppColors.buttonPrimary
                                      : AppColors.buttonGrey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Hidded Job",
                                style: bodyTextNormal(
                                    _typeMyJob == "SeekerHideJob"
                                        ? AppColors.fontWhite
                                        : AppColors.fontGreyOpacity,
                                    null),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    // color: AppColors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        //
                        //
                        //Search and Filter
                        Row(
                          children: [
                            //
                            //
                            //Search keywords
                            Expanded(
                              child: SimpleTextFieldSingleValidate(
                                codeController: _searchTitleController,
                                contenPadding: EdgeInsets.symmetric(
                                    vertical: 2.5.w, horizontal: 3.5.w),
                                enabledBorder: enableOutlineBorder(
                                  AppColors.borderBG,
                                ),
                                changed: (value) {
                                  setState(() {
                                    _searchTitle = value;
                                  });

                                  // Cancel previous timer if it exists
                                  _timer?.cancel();

                                  // Start a new timer
                                  _timer = Timer(Duration(seconds: 1), () {
                                    //
                                    // Perform API call here
                                    print('Calling API fetchMyJob');
                                    setState(() {
                                      _statusShowLoading = true;
                                    });
                                    fetchMyJob(_typeMyJob);
                                  });
                                },
                                hintText: 'Search keywords',
                                inputColor: AppColors.inputWhite,
                              ),
                            ),
                          ],
                        ),

                        //
                        //
                        //Count Jobs available
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              Text(
                                "${_total}",
                                style: bodyTextNormal(
                                    AppColors.fontPrimary, FontWeight.bold),
                              ),
                              Text(
                                " ${_textTotal}",
                                style: bodyTextNormal(null, FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //
                  //
                  //All Jobs available
                  _isLoading
                      ? Expanded(
                          child: Container(
                            color: AppColors.background,
                            width: double.infinity,
                            height: double.infinity,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      : Expanded(
                          child: _listMyJobs.length > 0
                              ? Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: ListView.builder(
                                      physics: ClampingScrollPhysics(),
                                      itemCount: _listMyJobs.length,
                                      itemBuilder: (context, index) {
                                        dynamic i = _listMyJobs[index];

                                        _logo = i['logo'];
                                        _jobTitle = i['jobTitle'];
                                        _companyName = i['companyName'];
                                        _workLocation = i['workingLocation'];
                                        _openDate = i['openingDate'];
                                        _closeDate = i['closingDate'];
                                        _views = i['isClick'].toString();

                                        //
                                        //Open Date
                                        //pars ISO to Flutter DateTime
                                        parsDateTime(
                                            value: '',
                                            currentFormat: '',
                                            desiredFormat: '');
                                        DateTime openDate = parsDateTime(
                                            value: _openDate,
                                            currentFormat:
                                                "yyyy-MM-ddTHH:mm:ssZ",
                                            desiredFormat:
                                                "yyyy-MM-dd HH:mm:ss");
                                        //
                                        //Format to string 13 Feb 2024
                                        _openDate = DateFormat('dd MMM yyyy')
                                            .format(openDate);

                                        //
                                        //Close Date
                                        //pars ISO to Flutter DateTime
                                        parsDateTime(
                                            value: '',
                                            currentFormat: '',
                                            desiredFormat: '');
                                        DateTime closeDate = parsDateTime(
                                            value: _closeDate,
                                            currentFormat:
                                                "yyyy-MM-ddTHH:mm:ssZ",
                                            desiredFormat:
                                                "yyyy-MM-dd HH:mm:ss");
                                        //
                                        //Format to string 13 Feb 2024
                                        _closeDate = DateFormat("dd MMM yyyy")
                                            .format(closeDate);
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 15),
                                          child: Slidable(
                                            //
                                            //Specify a key if the Slidable  is dismissible.
                                            key: UniqueKey(),
                                            //
                                            //The end action pane is the one at the right or the bottom side.
                                            endActionPane: ActionPane(
                                              motion: ScrollMotion(),
                                              //
                                              //A pane can dismiss the Slidable.
                                              dismissible: DismissiblePane(
                                                onDismissed: () {
                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 300),
                                                      () {
                                                    if (_typeMyJob ==
                                                        "SeekerSaveJob") {
                                                      print(
                                                          "unSave the Slidable");
                                                      deleteMyJob(
                                                          i['_id'],
                                                          _typeMyJob,
                                                          i['jobTitle']);
                                                    } else if (_typeMyJob ==
                                                        'SeekerHideJob') {
                                                      print(
                                                          "unHide the Slidable");
                                                      deleteMyJob(
                                                          i['_id'],
                                                          _typeMyJob,
                                                          i['jobTitle']);
                                                    }
                                                  });
                                                },
                                              ),
                                              children: [
                                                if (_typeMyJob ==
                                                    "SeekerSaveJob")
                                                  SlidableAction(
                                                    backgroundColor:
                                                        AppColors.lightPrimary,
                                                    foregroundColor:
                                                        AppColors.primary,
                                                    icon: FontAwesomeIcons
                                                        .solidHeart,
                                                    label: 'Saved',
                                                    onPressed: (context) {
                                                      print("press unsave");
                                                      deleteMyJob(
                                                          i['_id'],
                                                          _typeMyJob,
                                                          i['jobTitle']);
                                                    },
                                                  ),
                                                if (_typeMyJob ==
                                                    "SeekerHideJob")
                                                  SlidableAction(
                                                    backgroundColor:
                                                        AppColors.buttonDanger,
                                                    foregroundColor:
                                                        AppColors.fontWhite,
                                                    icon: FontAwesomeIcons
                                                        .rotateLeft,
                                                    label: 'Unhide',
                                                    onPressed: (constext) {
                                                      print("press hidded");
                                                      deleteMyJob(
                                                          i['_id'],
                                                          _typeMyJob,
                                                          i['jobTitle']);
                                                    },
                                                  ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (_typeMyJob !=
                                                      "SeekerHideJob") {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            JobSearchDetail(
                                                          jobId: i['jobId'],
                                                        ),
                                                      ),
                                                    ).then((value) {
                                                      //Success ແມ່ນຄ່າທີ່ໄດ້ຈາກການ Navigator.pop ທີ່ api Save Job or unSave Job ເຮັດວຽກ
                                                      if (value == 'Success') {
                                                        setState(() {
                                                          _statusShowLoading =
                                                              true;
                                                        });
                                                        onGoBack(value);
                                                      }
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  height: 250,
                                                  padding: EdgeInsets.all(15),
                                                  // margin: EdgeInsets.only(bottom: 15),
                                                  decoration: boxDecoration(
                                                      null,
                                                      AppColors.backgroundWhite,
                                                      null),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      //
                                                      //
                                                      //Logo Company and Status
                                                      Container(
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            //
                                                            //Logo Company
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: 75,
                                                                    height: 75,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: AppColors
                                                                            .borderSecondary,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: AppColors
                                                                          .backgroundWhite,
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        child:
                                                                            Center(
                                                                          child: _logo == ""
                                                                              ? Image.asset(
                                                                                  'assets/image/no-image-available.png',
                                                                                  fit: BoxFit.contain,
                                                                                )
                                                                              : Image.network(
                                                                                  "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${_logo}",
                                                                                  fit: BoxFit.contain,
                                                                                  errorBuilder: (context, error, stackTrace) {
                                                                                    return Image.asset(
                                                                                      'assets/image/no-image-available.png',
                                                                                      fit: BoxFit.contain,
                                                                                    ); // Display an error message
                                                                                  },
                                                                                ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          25),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          "10 Days ago"),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "${_views}",
                                                                            style:
                                                                                bodyTextNormal(AppColors.primary, null),
                                                                          ),
                                                                          Text(
                                                                              " Views")
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),

                                                            //
                                                            //Status
                                                            if (_typeMyJob ==
                                                                "SeekerHideJob")
                                                              GestureDetector(
                                                                onTap: () {
                                                                  showModalBottomSheet(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (builder) {
                                                                      return Container(
                                                                        padding:
                                                                            EdgeInsets.symmetric(
                                                                          vertical:
                                                                              20,
                                                                        ),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                AppColors.background,
                                                                            borderRadius: BorderRadius.circular(20)),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            //
                                                                            //Line on modal bottom
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                color: AppColors.grey,
                                                                                borderRadius: BorderRadius.all(Radius.circular(64.0)),
                                                                              ),
                                                                              margin: EdgeInsets.only(
                                                                                left: 40.w,
                                                                                right: 40.w,
                                                                              ),
                                                                              height: 1.w,
                                                                            ),
                                                                            //
                                                                            //Button
                                                                            Container(
                                                                              margin: EdgeInsets.all(20),
                                                                              padding: EdgeInsets.all(10),
                                                                              // decoration: BoxDecoration(
                                                                              //   color: AppColors.backgroundWhite,
                                                                              //   borderRadius: BorderRadius.circular(20),
                                                                              // ),
                                                                              child: Column(
                                                                                children: [
                                                                                  Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: AppColors.buttonDanger,
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                    ),
                                                                                    child: ListTile(
                                                                                      onTap: () {
                                                                                        print("press hidded");
                                                                                        Navigator.pop(context);
                                                                                        deleteMyJob(i['_id'], _typeMyJob, i['jobTitle']);
                                                                                      },
                                                                                      title: Container(
                                                                                        child: Text("Unhide My Job"),
                                                                                      ),
                                                                                      leading: Container(
                                                                                          // padding: EdgeInsets.all(10),
                                                                                          decoration: BoxDecoration(
                                                                                              // borderRadius: BorderRadius.circular(10),
                                                                                              // color: AppColors.greyWhite,
                                                                                              ),
                                                                                          child: FaIcon(
                                                                                            FontAwesomeIcons.rotateLeft,
                                                                                            size: IconSize.sIcon,
                                                                                            color: AppColors.iconLight,
                                                                                          )),
                                                                                      textColor: AppColors.fontWhite,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 30,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(
                                                                                8),
                                                                    child: FaIcon(
                                                                        FontAwesomeIcons
                                                                            .ellipsis)),
                                                              )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),

                                                      //
                                                      //Position
                                                      Text(
                                                        "${_jobTitle}",
                                                        style: bodyTextMedium(
                                                            null,
                                                            FontWeight.bold),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),

                                                      //
                                                      //Company Name
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .building,
                                                            size: 15,
                                                            color: AppColors
                                                                .iconGrayOpacity,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              "${_companyName}",
                                                              style:
                                                                  bodyTextSmall(
                                                                      null),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 2,
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      //
                                                      //Work Location
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .locationDot,
                                                            size: 15,
                                                            color: AppColors
                                                                .iconGrayOpacity,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              "${_workLocation}",
                                                              style:
                                                                  bodyTextSmall(
                                                                      null),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      //
                                                      //Start Date to End Date
                                                      Row(children: [
                                                        FaIcon(
                                                          FontAwesomeIcons
                                                              .calendarWeek,
                                                          size: 15,
                                                          color: AppColors
                                                              .iconGrayOpacity,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text('${_openDate}',
                                                            style:
                                                                bodyTextSmall(
                                                                    null)),
                                                        Text(' - '),
                                                        Text("${_closeDate}",
                                                            style:
                                                                bodyTextSmall(
                                                                    null))
                                                      ])
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              : ScreenNoData(
                                  faIcon:
                                      FontAwesomeIcons.fileCircleExclamation,
                                  colorIcon: AppColors.primary,
                                  text: "No have data",
                                  colorText: AppColors.primary,
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
