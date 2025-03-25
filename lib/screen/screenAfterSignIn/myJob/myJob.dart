// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_local_variable, prefer_final_fields, unused_field, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, avoid_print, prefer_is_empty, prefer_if_null_operators, prefer_typing_uninitialized_variables, unused_element, file_names

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
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyJobs extends StatefulWidget {
  const MyJobs({Key? key, this.myJobStatus}) : super(key: key);
  final myJobStatus;

  @override
  State<MyJobs> createState() => _MyJobsState();
}

class _MyJobsState extends State<MyJobs> {
  TextEditingController _searchTitleController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  FocusScopeNode _currentFocus = FocusScopeNode();
  FocusNode focusNode = FocusNode();

  List _listMyJobs = [];
  String _searchTitle = "";
  String _typeMyJob = "SeekerSaveJob";
  String _textTotal = "job".tr + " " + "have saved".tr;
  String _textAlert = "unsave job".tr + " " + "successful".tr;
  String _logo = "";
  String _jobTitle = "";
  String _companyName = "";
  String _workLocation = "";
  String _views = "";
  String _isClick = "";
  String _tag = "Highlight";

  dynamic _openDate;
  dynamic _closeDate;

  Timer? _timer;

  // bool _isSaved = false;
  bool _statusShowLoading = false;
  bool _isLoading = true;
  bool _isLoadingMoreData = false;
  bool _hasMoreData = true;

  dynamic page = 1;
  dynamic perPage = 10;
  dynamic totals;
  // dynamic _disablePeople;

  DateTime _dateTimeNow = DateTime.now();

  fetchMyJob(String type) async {
    if (!_hasMoreData) {
      _isLoadingMoreData = false;
      return;
    }

    //
    //ສະແດງ AlertDialog Loading
    if (_statusShowLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomLoadingLogoCircle();
        },
      );
    }

    var res = await postData(getMyJobSeekerApi, {
      "type": type,
      "search": _searchTitle,
      "page": page,
      "perPage": perPage,
    });

    List fetchMyJobs = res['info'];
    // _listMyJobs = res['info'];
    totals = res['totals'];

    page++;
    _listMyJobs.addAll(List<Map<String, dynamic>>.from(fetchMyJobs));
    if (_listMyJobs.length >= totals || fetchMyJobs.length < perPage) {
      _hasMoreData = false;
    }
    _isLoadingMoreData = false;
    _isLoading = false;

    if (res['info'] != null && _statusShowLoading) {
      _statusShowLoading = false;
      Navigator.pop(context);
    }

    if (mounted) {
      setState(() {});
    }
  }

  fetchMyJobTypingSearch(String type) async {
    setState(() {
      _hasMoreData = true;
      page = 1;
    });
    if (!_hasMoreData) {
      _isLoadingMoreData = false;
      return;
    }

    var res = await postData(getMyJobSeekerApi, {
      "type": type,
      "search": _searchTitle,
      "page": page,
      "perPage": perPage,
    });

    List fetchMyJobs = res['info'];
    totals = res['totals'];

    page++;
    _listMyJobs.clear();
    _listMyJobs.addAll(List<Map<String, dynamic>>.from(fetchMyJobs));
    if (_listMyJobs.length >= totals || fetchMyJobs.length < perPage) {
      _hasMoreData = false;
    }
    _isLoadingMoreData = false;

    if (mounted) {
      setState(() {});
    }
  }

  onGoBack(dynamic value) async {
    print("onGoBack");
    await fetchMyJob(_typeMyJob);
  }

  pressTapMyJobType(String val) async {
    FocusScope.of(context).requestFocus(focusNode);
    setState(() {
      _typeMyJob = val;

      if (_typeMyJob == "SeekerSaveJob") {
        _isLoading = true;
        _textTotal = "job".tr + " " + "have saved".tr;
        _textAlert = "unsave job".tr + " " + "successful".tr;
      } else if (_typeMyJob == "AppliedJob") {
        _isLoading = true;
        _textTotal = "job".tr + " " + "have applied".tr;
      } else if (_typeMyJob == "JobAlert") {
        _isLoading = true;
        _textTotal = "job".tr + " " + "have alert".tr;
      } else if (_typeMyJob == "SeekerHideJob") {
        _isLoading = true;
        _textTotal = "job".tr + " " + "you have hidded".tr;
        _textAlert = "unhide job".tr + " " + "successful".tr;
      }

      _listMyJobs.clear();
      _hasMoreData = true;
      page = 1;
    });
    fetchMyJob(val);
  }

  unSaveUnHideMyJob(String id, String type, String title) async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    var res = await postData(deleteMyJobSeekerApi, {
      "_id": id,
      "type": type,
    });
    print(res);

    if (res['message'] == "Delete succeed") {
      Navigator.pop(context);
    }

    if (res['message'] == "Delete succeed") {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            strIcon: _typeMyJob == "SeekerSaveJob" ? "\uf7a9" : null,
            boxCircleColor: AppColors.warning200,
            iconColor: AppColors.warning600,
            title: "${_textAlert}",
            contentText: "${title}",
            textButton: "ok".tr,
            buttonColor: AppColors.warning200,
            textButtonColor: AppColors.warning600,
            widgetBottomColor: AppColors.warning200,
            press: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  checkTypeMyJobFromHomePage() {
    if (widget.myJobStatus == "AppliedJob") {
      setState(() {
        _typeMyJob = widget.myJobStatus;
        _textTotal = "job".tr + " " + "have applied".tr;

        fetchMyJob(_typeMyJob);
      });
    }
  }

  _removeJobsSearchSeekerLocal(String jobId) {
    setState(() {
      _listMyJobs.removeWhere((id) => id['_id'] == jobId);
      totals = totals - 1;
    });
  }

  String getTimeAgo(DateTime dateTimeNow, DateTime openDateTime) {
    Duration difference = openDateTime.difference(dateTimeNow).abs();
    // if (difference.inDays > 365) {
    //   return '${difference.inDays ~/ 365} year${difference.inDays ~/ 365 == 1 ? '' : 's'} ago';
    // } else
    if (difference.inDays >= 30) {
      return '${difference.inDays ~/ 30} ${difference.inDays ~/ 30 == 1 ? 'month'.tr : 'months'.tr}';
    } else if (difference.inDays >= 7) {
      return '${difference.inDays ~/ 7} ${difference.inDays ~/ 7 == 1 ? 'week ago'.tr : 'weeks ago'.tr}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day ago'.tr : 'days ago'.tr}';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour ago'.tr : 'hours ago'.tr}';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute ago'.tr : 'minutes ago'.tr}';
    } else {
      return "just now".tr;
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.myJobStatus == "AppliedJob") {
      checkTypeMyJobFromHomePage();
    } else {
      fetchMyJob(_typeMyJob);
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _isLoadingMoreData = true;
        });
        fetchMyJob(_typeMyJob);
      }
    });

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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: GestureDetector(
        onTap: () {
          _currentFocus = FocusScope.of(context);
          if (!_currentFocus.hasPrimaryFocus) {
            _currentFocus.unfocus();
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
                  //Tap list horizontal
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      // color: AppColors.backgroundWhite,
                      border: Border(
                        bottom: BorderSide(color: AppColors.borderSecondary),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: ClampingScrollPhysics(),
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
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "saved job".tr,
                                style: bodyTextNormal(
                                    null,
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
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                "applied job".tr,
                                style: bodyTextNormal(
                                    null,
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
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                "my job alert".tr,
                                style: bodyTextNormal(
                                    null,
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
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                "hidded".tr,
                                style: bodyTextNormal(
                                    null,
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
                  //Search keywords && Count Jobs available
                  Container(
                    // color: AppColors.blue,
                    // padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              //
                              //
                              //Search keywords
                              Expanded(
                                child: SimpleTextFieldSingleValidate(
                                  codeController: _searchTitleController,
                                  // contenPadding: EdgeInsets.symmetric(
                                  //     vertical: 2.5.w, horizontal: 3.5.w),
                                  contenPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
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
                                    _timer =
                                        Timer(Duration(milliseconds: 500), () {
                                      //
                                      // Perform API call here
                                      print('Calling API fetchMyJob');

                                      fetchMyJobTypingSearch(_typeMyJob);
                                    });
                                  },
                                  hintText:
                                      "search".tr + " " + "company name".tr,
                                  inputColor: AppColors.inputWhite,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //
                        //
                        //Count Jobs available
                        if (!_isLoading)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            child: Row(
                              children: [
                                Text(
                                  "${totals}",
                                  style: bodyTextNormal(null,
                                      AppColors.fontPrimary, FontWeight.bold),
                                ),
                                Text(
                                  " ${_textTotal}",
                                  style: bodyTextNormal(
                                      null, null, FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  _isLoading
                      ? Expanded(
                          child: Container(
                            color: AppColors.background,
                            width: double.infinity,
                            height: double.infinity,
                            child: Center(
                              child: CustomLoadingLogoCircle(),
                            ),
                          ),
                        )
                      : Expanded(
                          child: _listMyJobs.length > 0
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
                              //List My Jobs
                              ? ListView.builder(
                                  controller: _scrollController,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: _listMyJobs.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == _listMyJobs.length) {
                                      return _hasMoreData
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 10),
                                              child: Container(),
                                            )
                                          // Padding(
                                          //     padding:
                                          //         const EdgeInsets.all(8.0),
                                          //     child: ElevatedButton(
                                          //       style: ButtonStyle(
                                          //           backgroundColor:
                                          //               MaterialStatePropertyAll(
                                          //                   AppColors
                                          //                       .lightPrimary)),
                                          //       onPressed: () => {
                                          //         setState(() {
                                          //           _isLoadingMoreData =
                                          //               true;
                                          //         }),
                                          //         fetchMyJob(_typeMyJob),
                                          //       },
                                          //       child: Text(
                                          //         'view more'.tr,
                                          //         style: TextStyle(
                                          //             color: AppColors
                                          //                 .fontPrimary),
                                          //       ),
                                          //     ),
                                          //   )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                  child:
                                                      Text('no have data'.tr)),
                                            );
                                    }
                                    dynamic i = _listMyJobs[index];

                                    _logo = i['logo'];
                                    _jobTitle = i['jobTitle'];
                                    _companyName = i['companyName'];
                                    _workLocation = i['workingLocation'];
                                    _openDate = i['openingDate'];
                                    _closeDate = i['closingDate'];
                                    _isClick = i['isClick'].toString();
                                    _tag = i['tag'];
                                    // _disablePeople = i['disabledPeople'];
                                    // _isSaved = i['isSaved'];
                                    // _views = i['isClick'].toString();

                                    //
                                    //Open Date
                                    //pars ISO to Flutter DateTime
                                    parsDateTime(
                                        value: '',
                                        currentFormat: '',
                                        desiredFormat: '');
                                    DateTime openDate = parsDateTime(
                                        value: _openDate,
                                        currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                                        desiredFormat: "yyyy-MM-dd HH:mm:ss");
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
                                        currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                                        desiredFormat: "yyyy-MM-dd HH:mm:ss");
                                    //
                                    //Format to string 13 Feb 2024
                                    _closeDate = DateFormat("dd MMM yyyy")
                                        .format(closeDate);
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 15),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
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
                                              FocusScope.of(context)
                                                  .requestFocus(focusNode);
                                              Future.delayed(
                                                  Duration(milliseconds: 300),
                                                  () {
                                                _removeJobsSearchSeekerLocal(
                                                    i['_id']);
                                                if (_typeMyJob ==
                                                    "SeekerSaveJob") {
                                                  print("Slidable to unSave");
                                                  unSaveUnHideMyJob(
                                                      i['_id'],
                                                      _typeMyJob,
                                                      i['jobTitle']);
                                                } else if (_typeMyJob ==
                                                    'SeekerHideJob') {
                                                  print("Slidable to unHide");
                                                  unSaveUnHideMyJob(
                                                      i['_id'],
                                                      _typeMyJob,
                                                      i['jobTitle']);
                                                }
                                              });
                                            },
                                          ),
                                          children: [
                                            if (_typeMyJob == "SeekerSaveJob")
                                              SlidableAction(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                backgroundColor:
                                                    AppColors.lightPrimary,
                                                foregroundColor:
                                                    AppColors.primary,
                                                icon:
                                                    FontAwesomeIcons.solidHeart,
                                                label: 'unsave'.tr,
                                                onPressed: (context) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focusNode);
                                                  print("press unsave");
                                                  _removeJobsSearchSeekerLocal(
                                                      i['_id']);
                                                  unSaveUnHideMyJob(
                                                      i['_id'],
                                                      _typeMyJob,
                                                      i['jobTitle']);
                                                },
                                              ),
                                            if (_typeMyJob == "SeekerHideJob")
                                              SlidableAction(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                backgroundColor:
                                                    AppColors.buttonWarning,
                                                foregroundColor:
                                                    AppColors.fontWhite,
                                                icon:
                                                    FontAwesomeIcons.rotateLeft,
                                                label: 'unhide'.tr,
                                                onPressed: (constext) async {
                                                  FocusScope.of(context)
                                                      .requestFocus(focusNode);
                                                  print("press hidded");
                                                  var result = await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return NewVer4CustAlertDialogWarning3TxtBtnConfirmCancel(
                                                          title:
                                                              "unhide job".tr,
                                                          smallText:
                                                              "unhide_job_explain"
                                                                  .tr,
                                                          contentText:
                                                              "${i['jobTitle']}",
                                                          textButtonLeft:
                                                              'cancel'.tr,
                                                          textButtonRight:
                                                              'confirm'.tr,
                                                        );
                                                      });
                                                  if (result == 'Ok') {
                                                    print("press ok");
                                                    _removeJobsSearchSeekerLocal(
                                                        i['_id']);
                                                    unSaveUnHideMyJob(
                                                      i['_id'],
                                                      _typeMyJob,
                                                      i['jobTitle'],
                                                    );
                                                  }
                                                },
                                              ),
                                          ],
                                        ),

                                        //
                                        //
                                        //
                                        //
                                        //
                                        //Card my job
                                        child: Container(
                                          decoration: boxDecoration(
                                              null,
                                              _tag == "Highlight"
                                                  ? AppColors.lightOrange
                                                  : AppColors.backgroundWhite,
                                              _tag == "Highlight"
                                                  ? AppColors.borderWaring
                                                  : null,
                                              // AppColors.backgroundWhite,
                                              // null,
                                              3),
                                          child: Column(
                                            children: [
                                              //
                                              //
                                              //Content card jobs
                                              GestureDetector(
                                                //
                                                //
                                                //press to MyJobDetail
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .requestFocus(focusNode);
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
                                                      if (value[0] ==
                                                          'Success') {
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
                                                  color: Colors.transparent,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      //
                                                      //
                                                      //Logo Company and Status
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            //
                                                            //
                                                            //Company Logo/Name
                                                            Expanded(
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: 15,
                                                                  left: 15,
                                                                  right: 15,
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      width: 60,
                                                                      height:
                                                                          60,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              AppColors.borderSecondary,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        color: AppColors
                                                                            .backgroundWhite,
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
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
                                                                                    "https://storage.googleapis.com/108-bucket/${_logo}",
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
                                                                            15),

                                                                    //
                                                                    //
                                                                    //Company Name
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "${_companyName}",
                                                                            style: bodyTextMinNormal(
                                                                                null,
                                                                                null,
                                                                                null),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                          Text(
                                                                            "${getTimeAgo(_dateTimeNow, openDate)}",
                                                                            style: bodyTextSmall(
                                                                                null,
                                                                                null,
                                                                                null),
                                                                          ),

                                                                          // Row(
                                                                          //   children: [
                                                                          //     Text(
                                                                          //       "${_isClick}",
                                                                          //       style: bodyTextNormal(null,
                                                                          //           AppColors
                                                                          //               .primary,
                                                                          //           null),
                                                                          //     ),
                                                                          //     Text(
                                                                          //         " Views")
                                                                          //   ],
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),

                                                            //
                                                            //
                                                            //Jobs Seach check newJob
                                                            Column(
                                                              children: [
                                                                //
                                                                //
                                                                //Status HOT
                                                                // if (_tag ==
                                                                //     "Highlight")
                                                                //   Align(
                                                                //     alignment:
                                                                //         Alignment
                                                                //             .centerRight,
                                                                //     child:
                                                                //         Container(
                                                                //       decoration:
                                                                //           BoxDecoration(
                                                                //         color: AppColors
                                                                //             .danger,
                                                                //         borderRadius:
                                                                //             BorderRadius.only(
                                                                //           topRight:
                                                                //               Radius.circular(5),
                                                                //           bottomLeft:
                                                                //               Radius.circular(10),
                                                                //         ),
                                                                //       ),
                                                                //       padding: EdgeInsets.symmetric(
                                                                //           horizontal:
                                                                //               10,
                                                                //           vertical:
                                                                //               5),
                                                                //       child:
                                                                //           Text(
                                                                //         "HOT",
                                                                //         style: bodyTextNormal(null,
                                                                //             AppColors.fontWhite,
                                                                //             null),
                                                                //       ),
                                                                //     ),
                                                                //   ),

                                                                //
                                                                //
                                                                //Disable People
                                                                // if (_disablePeople)
                                                                //   Padding(
                                                                //     padding: const EdgeInsets
                                                                //         .only(
                                                                //         right: 15,
                                                                //         bottom: 15),
                                                                //     child:
                                                                //         Container(
                                                                //       padding:
                                                                //           EdgeInsets.all(10),
                                                                //       // margin: EdgeInsets
                                                                //       //     .only(
                                                                //       //   top: _tag ==
                                                                //       //           "Highlight"
                                                                //       //       ? 5
                                                                //       //       : 15,
                                                                //       //   right:
                                                                //       //       15,
                                                                //       // ),
                                                                //       decoration:
                                                                //           BoxDecoration(
                                                                //         color: AppColors.warning,
                                                                //         borderRadius: BorderRadius.circular(5),
                                                                //       ),
                                                                //       child:
                                                                //           FaIcon(
                                                                //         FontAwesomeIcons.wheelchair,
                                                                //         color: AppColors.iconLight,
                                                                //       ),
                                                                //     ),
                                                                //   ),

                                                                //
                                                                //
                                                                //Status Job New/Saved
                                                                // if (i['newJob'] ||
                                                                //     i['isSaved'])
                                                                //   Container(
                                                                //     alignment:
                                                                //         Alignment
                                                                //             .topCenter,
                                                                //     padding:
                                                                //         EdgeInsets
                                                                //             .symmetric(
                                                                //       horizontal:
                                                                //           10,
                                                                //       vertical:
                                                                //           5,
                                                                //     ),
                                                                //     margin:
                                                                //         EdgeInsets
                                                                //             .only(
                                                                //       top: _tag ==
                                                                //               "hot"
                                                                //           ? 5
                                                                //           : 15,
                                                                //       right: 15,
                                                                //     ),
                                                                //     decoration:
                                                                //         BoxDecoration(
                                                                //       // color: !i['newJob'] &&
                                                                //       //         !i[
                                                                //       //             'isSaved']
                                                                //       //     ? AppColors
                                                                //       //         .greyOpacity
                                                                //       //     : AppColors
                                                                //       //         .primary,
                                                                //       color: AppColors
                                                                //           .primary,

                                                                //       borderRadius:
                                                                //           BorderRadius.circular(
                                                                //               5),
                                                                //     ),
                                                                //     child: Text(
                                                                //       // i['newJob'] &&
                                                                //       //         !i['isSaved']
                                                                //       //     ? "New"
                                                                //       //     : !i['newJob'] && i['isSaved']
                                                                //       //         ? "Saved"
                                                                //       //         : "Viewed",
                                                                //       i['newJob'] &&
                                                                //               !i['isSaved']
                                                                //           ? "New"
                                                                //           : !i['newJob'] && i['isSaved']
                                                                //               ? "Saved"
                                                                //               : "",
                                                                //       style:
                                                                //           bodyTextSmall(null,null,
                                                                //         !i['newJob'] &&
                                                                //                 !i['isSaved']
                                                                //             ? AppColors.fontDark
                                                                //             : AppColors.fontWhite,
                                                                //       ),
                                                                //     ),
                                                                //   ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),

                                                      //
                                                      //
                                                      //Check _tag == Highlight
                                                      //Position
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 15,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                "${_jobTitle}",
                                                                style:
                                                                    bodyTextSuperMaxNormal(
                                                                  null,
                                                                  _tag == "Highlight"
                                                                      ? AppColors
                                                                          .fontWaring
                                                                      : null,
                                                                  FontWeight
                                                                      .bold,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),

                                                      //
                                                      //
                                                      //Work Location
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 15,
                                                          right: 15,
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "\uf5a0",
                                                              style: fontAwesomeLight(
                                                                  null,
                                                                  12,
                                                                  AppColors
                                                                      .iconGrayOpacity,
                                                                  null),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                "${_workLocation}",
                                                                style:
                                                                    bodyTextSmall(
                                                                        null,
                                                                        null,
                                                                        null),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),

                                                      //
                                                      //
                                                      //Start Date to End Date
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 15,
                                                          right: 15,
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "\uf073",
                                                              style: fontAwesomeLight(
                                                                  null,
                                                                  12,
                                                                  AppColors
                                                                      .iconGrayOpacity,
                                                                  null),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              '${_openDate}',
                                                              style:
                                                                  bodyTextSmall(
                                                                      null,
                                                                      null,
                                                                      null),
                                                            ),
                                                            Text(' - '),
                                                            Text(
                                                              "${_closeDate}",
                                                              style:
                                                                  bodyTextSmall(
                                                                      null,
                                                                      null,
                                                                      null),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              Divider(
                                                height: 1,
                                                color:
                                                    AppColors.borderGreyOpacity,
                                              ),

                                              //
                                              //
                                              //Bottom card jobs button unsave/unhide
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  if (_typeMyJob ==
                                                      "SeekerHideJob")
                                                    Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  focusNode);
                                                          print(
                                                              "press button unhide");
                                                          var result =
                                                              await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return NewVer4CustAlertDialogWarning3TxtBtnConfirmCancel(
                                                                      title:
                                                                          "unhide job"
                                                                              .tr,
                                                                      smallText:
                                                                          "unhide_job_explain"
                                                                              .tr,
                                                                      contentText:
                                                                          "${i['jobTitle']}",
                                                                      textButtonLeft:
                                                                          'cancel'
                                                                              .tr,
                                                                      textButtonRight:
                                                                          'confirm'
                                                                              .tr,
                                                                    );
                                                                  });
                                                          if (result == 'Ok') {
                                                            print("press ok");
                                                            _removeJobsSearchSeekerLocal(
                                                                i['_id']);
                                                            unSaveUnHideMyJob(
                                                              i['_id'],
                                                              _typeMyJob,
                                                              i['jobTitle'],
                                                            );
                                                          }
                                                        },
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15),
                                                          child: Row(
                                                            children: [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .ban,
                                                                size: IconSize
                                                                    .xsIcon,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "hidded".tr,
                                                                style:
                                                                    bodyTextMinNormal(
                                                                        null,
                                                                        null,
                                                                        null),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  if (_typeMyJob ==
                                                      "SeekerSaveJob")
                                                    Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  focusNode);
                                                          print(
                                                              "press button unsave");
                                                          setState(() {
                                                            i['isSaved'] =
                                                                !i['isSaved'];
                                                          });
                                                          _removeJobsSearchSeekerLocal(
                                                              i['_id']);
                                                          unSaveUnHideMyJob(
                                                            i['_id'],
                                                            _typeMyJob,
                                                            i['jobTitle'],
                                                          );
                                                        },
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15),
                                                          child: Row(
                                                            children: [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .solidHeart,
                                                                size: IconSize
                                                                    .xsIcon,
                                                                color: AppColors
                                                                    .iconPrimary,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "saved".tr,
                                                                style:
                                                                    bodyTextMinNormal(
                                                                        null,
                                                                        null,
                                                                        null),
                                                              ),
                                                            ],
                                                          ),
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
                                  })
                              : ScreenNoData(
                                  faIcon:
                                      FontAwesomeIcons.fileCircleExclamation,
                                  colorIcon: AppColors.primary,
                                  text: "no have data".tr,
                                  colorText: AppColors.primary,
                                ),
                        ),
                  if (_isLoadingMoreData)
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
