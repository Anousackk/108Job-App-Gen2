// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_local_variable, prefer_final_fields, unused_field, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, avoid_print, prefer_is_empty, prefer_if_null_operators, prefer_typing_uninitialized_variables, unused_element, file_names, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings, unnecessary_null_in_if_null_operators, use_build_context_synchronously

import 'dart:async';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/internetDisconnected.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearchDetail.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/input.dart';
import 'package:app/widget/screenNoData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyJobs extends StatefulWidget {
  const MyJobs({Key? key, this.myJobStatus, this.hasInternet})
      : super(key: key);
  final myJobStatus;
  final hasInternet;

  @override
  State<MyJobs> createState() => _MyJobsState();
}

class _MyJobsState extends State<MyJobs> {
  TextEditingController _searchTitleController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  FocusScopeNode _currentFocus = FocusScopeNode();
  FocusNode focusNode = FocusNode();

  List _listMyJobs = [];
  List _listRecommendJobs = [];

  String _searchTitle = "";
  String _typeMyJob = "SeekerSaveJob";
  String _textTotal = "job".tr + " " + "have saved".tr;
  String _textAlert = "unsave job".tr + " " + "successfully".tr;
  String _textTab = "saved_job".tr;
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

  int _totalSavedJobs = 0;
  int _totalAppliedJobs = 0;
  int _totalPurchasedCV = 0;
  int _totalHiddenJobs = 0;
  int _totalJobAlerts = 0;
  int _countJobTotals = 0;
  int _totalRecommendJobs = 0;

  // dynamic _disablePeople;

  DateTime _dateTimeNow = DateTime.now();

  dynamic tabs = [
    "SeekerSaveJob",
    "AppliedJob",
    "JobAlert",
    "SeekerHideJob",
    "SeekerSaveJob",
    "AppliedJob",
  ];

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

    List fetchMyJobs = res['info'] ?? [];
    // _listMyJobs = res['info'];
    totals = res['totals'] ?? 0;

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

  fetchProfileDashboardStatus() async {
    var res = await fetchData(getProfileDashboardStatus);

    _totalSavedJobs = res["totalSavedJobs"] == null
        ? 0
        : int.parse("${res["totalSavedJobs"]}");
    _totalAppliedJobs = res["totalAppliedJobs"] == null
        ? 0
        : int.parse("${res["totalAppliedJobs"]}");
    _totalHiddenJobs = res["totalHiddenJobs"] == null
        ? 0
        : int.parse("${res["totalHiddenJobs"]}");
    _totalJobAlerts = res["totalJobAlerts"] == null
        ? 0
        : int.parse("${res["totalJobAlerts"]}");

    if (mounted) {
      setState(() {});
    }
  }

  // fetchRecommendJobAI() async {
  //   var res = await postData(getRecommendJobByAIApi, {});

  //   if (mounted) {
  //     setState(() {
  //       _listRecommendJobs = res["jobs"];
  //       _totalRecommendJobs = _listRecommendJobs.length;
  //     });
  //   }
  // }

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
        _textTab = "saved_job".tr;
        _textTotal = "job".tr + " " + "have saved".tr;
        _textAlert = "unsave job".tr + " " + "successfully".tr;
      } else if (_typeMyJob == "AppliedJob") {
        _isLoading = true;
        _textTab = "applied_job".tr;
        _textTotal = "job".tr + " " + "have applied".tr;
      } else if (_typeMyJob == "JobAlert") {
        _isLoading = true;
        _textTab = "my job alert".tr;
        _textTotal = "job".tr + " " + "have alert".tr;
      } else if (_typeMyJob == "SeekerHideJob") {
        _isLoading = true;
        _textTab = "hidded".tr;
        _textTotal = "job".tr + " " + "you have hidded".tr;
        _textAlert = "unhide job".tr + " " + "successfully".tr;
      } else if (_typeMyJob == "SeekerRecommendJob") {
        _isLoading = true;
        _textTab = "recommend_job".tr;

        // fetchRecommendJobAI();
      }

      _listMyJobs.clear();
      _hasMoreData = true;
      page = 1;
    });
    fetchMyJob(_typeMyJob);
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
        _textTotal = "job".tr + " " + "have applied".tr;

        fetchMyJob("AppliedJob");
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

    print("widget hasInternet myjob: " + "${widget.hasInternet}");

    fetchProfileDashboardStatus();
    // fetchRecommendJobAI();

    if (widget.hasInternet == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showInternetDisconnected(context);
      });
    } else {
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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchTitleController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double itemWidth = (screenWidth - 16 * 2 - 12) / 2;

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
          // appBar: AppBar(
          //   toolbarHeight: 0,
          // ),
          appBar: AppBarDefault(
            backgroundColor: AppColors.backgroundWhite,
            textTitle: 'my job'.tr,
            textColor: AppColors.fontDark,
            leadingIcon: Icon(Icons.arrow_back, color: AppColors.fontDark),
            leadingPress: () {
              Navigator.pop(context);
            },
          ),
          body: SafeArea(
            child: _isLoading
                ? Container(
                    color: AppColors.dark100,
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(child: CustomLoadingLogoCircle()),
                  )
                : Container(
                    color: AppColors.background,
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      children: [
                        //
                        //
                        //Section search my job
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundWhite,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 20),

                              //
                              //
                              //Search keywords
                              Row(
                                children: [
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
                                        _timer = Timer(
                                            Duration(milliseconds: 500), () {
                                          //
                                          // Perform API call here
                                          print('Calling API fetchMyJob');

                                          fetchMyJobTypingSearch(_typeMyJob);
                                        });
                                      },
                                      hintText: "search".tr,
                                      inputColor: AppColors.inputBackground,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),

                        //
                        //
                        //Section list tab and card job
                        Expanded(
                          child: CustomScrollView(
                            controller: _scrollController,
                            physics: ClampingScrollPhysics(),
                            slivers: [
                              // SliverToBoxAdapter(
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(horizontal: 20),
                              //     decoration: BoxDecoration(
                              //       color: AppColors.backgroundWhite,
                              //       border: Border(
                              //         bottom: BorderSide(color: AppColors.borderBG),
                              //       ),
                              //     ),
                              //     child: Column(
                              //       children: [
                              //         Row(
                              //           children: [
                              //             Expanded(
                              //               child: TabMenu(
                              //                 text: "saved_job".tr,
                              //                 borderColor:
                              //                     _typeMyJob == "SeekerSaveJob"
                              //                         ? AppColors.borderPrimary
                              //                         : null,
                              //                 count: totals == null
                              //                     ? 0
                              //                     : int.parse("${totals}"),
                              //                 boxColor: _typeMyJob == "SeekerSaveJob"
                              //                     ? AppColors.primary600
                              //                     : null,
                              //                 textColor: _typeMyJob == "SeekerSaveJob"
                              //                     ? AppColors.fontWhite
                              //                     : null,
                              //                 countColor:
                              //                     _typeMyJob == "SeekerSaveJob"
                              //                         ? AppColors.fontWhite
                              //                         : null,
                              //                 press: () {
                              //                   pressTapMyJobType('SeekerSaveJob');
                              //                 },
                              //               ),
                              //             ),
                              //             SizedBox(width: 5),
                              //             Expanded(
                              //               child: TabMenu(
                              //                 text: "applied_job".tr,
                              //                 borderColor: _typeMyJob == "AppliedJob"
                              //                     ? AppColors.borderPrimary
                              //                     : null,
                              //                 count: totals == null
                              //                     ? 0
                              //                     : int.parse("${totals}"),
                              //                 boxColor: _typeMyJob == "AppliedJob"
                              //                     ? AppColors.primary600
                              //                     : null,
                              //                 textColor: _typeMyJob == "AppliedJob"
                              //                     ? AppColors.fontWhite
                              //                     : null,
                              //                 countColor: _typeMyJob == "AppliedJob"
                              //                     ? AppColors.fontWhite
                              //                     : null,
                              //                 press: () {
                              //                   pressTapMyJobType('AppliedJob');
                              //                 },
                              //               ),
                              //             ),
                              //             SizedBox(width: 5),
                              //             Expanded(
                              //               child: TabMenu(
                              //                 text: "my job alert".tr,
                              //                 borderColor: _typeMyJob == "JobAlert"
                              //                     ? AppColors.borderPrimary
                              //                     : null,
                              //                 count: totals == null
                              //                     ? 0
                              //                     : int.parse("${totals}"),
                              //                 boxColor: _typeMyJob == "JobAlert"
                              //                     ? AppColors.primary600
                              //                     : null,
                              //                 textColor: _typeMyJob == "JobAlert"
                              //                     ? AppColors.fontWhite
                              //                     : null,
                              //                 countColor: _typeMyJob == "JobAlert"
                              //                     ? AppColors.fontWhite
                              //                     : null,
                              //                 press: () {
                              //                   pressTapMyJobType('JobAlert');
                              //                 },
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //         SizedBox(
                              //           height: 5,
                              //         ),
                              //         Row(
                              //           children: [
                              //             Expanded(
                              //               child: TabMenu(
                              //                 text: "hidded".tr,
                              //                 borderColor:
                              //                     _typeMyJob == "SeekerHideJob"
                              //                         ? AppColors.borderPrimary
                              //                         : null,
                              //                 count: totals == null
                              //                     ? 0
                              //                     : int.parse("${totals}"),
                              //                 boxColor: _typeMyJob == "SeekerHideJob"
                              //                     ? AppColors.primary600
                              //                     : null,
                              //                 textColor: _typeMyJob == "SeekerHideJob"
                              //                     ? AppColors.fontWhite
                              //                     : null,
                              //                 countColor:
                              //                     _typeMyJob == "SeekerHideJob"
                              //                         ? AppColors.fontWhite
                              //                         : null,
                              //                 press: () {
                              //                   pressTapMyJobType('SeekerHideJob');
                              //                 },
                              //               ),
                              //             ),
                              //             SizedBox(width: 5),
                              //             Expanded(
                              //               child: TabMenu(
                              //                 text: "applied_job".tr,
                              //                 count: totals == null
                              //                     ? 0
                              //                     : int.parse("${totals}"),
                              //               ),
                              //             ),
                              //             SizedBox(width: 5),
                              //             Expanded(
                              //               child: TabMenu(
                              //                 text: "my job alert".tr,
                              //                 count: totals == null
                              //                     ? 0
                              //                     : int.parse("${totals}"),
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //         SizedBox(height: 20),
                              //       ],
                              //     ),
                              //   ),
                              // ),

                              //
                              //
                              // List tab menu
                              SliverPersistentHeader(
                                pinned: true,
                                delegate: _SliverAppBarDelegate(
                                  minHeight: 60,
                                  maxHeight: 120,

                                  //
                                  //
                                  // Original tab menu
                                  expandedChild: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundWhite,
                                      border: Border(
                                        bottom: BorderSide(
                                            color: AppColors.borderBG),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TabMenu(
                                                text: "saved_job".tr,
                                                borderColor: _typeMyJob ==
                                                        "SeekerSaveJob"
                                                    ? AppColors.borderPrimary
                                                    : null,
                                                count: _totalSavedJobs,
                                                boxColor: _typeMyJob ==
                                                        "SeekerSaveJob"
                                                    ? AppColors.primary600
                                                    : null,
                                                textColor: _typeMyJob ==
                                                        "SeekerSaveJob"
                                                    ? AppColors.fontWhite
                                                    : null,
                                                countColor: _typeMyJob ==
                                                        "SeekerSaveJob"
                                                    ? AppColors.fontWhite
                                                    : null,
                                                press: () {
                                                  pressTapMyJobType(
                                                      'SeekerSaveJob');
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: TabMenu(
                                                text: "applied_job".tr,
                                                borderColor: _typeMyJob ==
                                                        "AppliedJob"
                                                    ? AppColors.borderPrimary
                                                    : null,
                                                count: _totalAppliedJobs,
                                                boxColor:
                                                    _typeMyJob == "AppliedJob"
                                                        ? AppColors.primary600
                                                        : null,
                                                textColor:
                                                    _typeMyJob == "AppliedJob"
                                                        ? AppColors.fontWhite
                                                        : null,
                                                countColor:
                                                    _typeMyJob == "AppliedJob"
                                                        ? AppColors.fontWhite
                                                        : null,
                                                press: () {
                                                  pressTapMyJobType(
                                                      'AppliedJob');
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TabMenu(
                                                text: "hidded".tr,
                                                borderColor: _typeMyJob ==
                                                        "SeekerHideJob"
                                                    ? AppColors.borderPrimary
                                                    : null,
                                                count: _totalHiddenJobs,
                                                boxColor: _typeMyJob ==
                                                        "SeekerHideJob"
                                                    ? AppColors.primary600
                                                    : null,
                                                textColor: _typeMyJob ==
                                                        "SeekerHideJob"
                                                    ? AppColors.fontWhite
                                                    : null,
                                                countColor: _typeMyJob ==
                                                        "SeekerHideJob"
                                                    ? AppColors.fontWhite
                                                    : null,
                                                press: () {
                                                  pressTapMyJobType(
                                                      'SeekerHideJob');
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: TabMenu(
                                                text: "my job alert".tr,
                                                borderColor: _typeMyJob ==
                                                        "JobAlert"
                                                    ? AppColors.borderPrimary
                                                    : null,
                                                count: _totalJobAlerts,
                                                boxColor:
                                                    _typeMyJob == "JobAlert"
                                                        ? AppColors.primary600
                                                        : null,
                                                textColor:
                                                    _typeMyJob == "JobAlert"
                                                        ? AppColors.fontWhite
                                                        : null,
                                                countColor:
                                                    _typeMyJob == "JobAlert"
                                                        ? AppColors.fontWhite
                                                        : null,
                                                press: () {
                                                  pressTapMyJobType('JobAlert');
                                                },
                                              ),
                                            )
                                            // SizedBox(width: 5),
                                            // Expanded(
                                            //   child: TabMenu(
                                            //     text: "recommend_job".tr,
                                            //     borderColor: _typeMyJob ==
                                            //             "SeekerRecommendJob"
                                            //         ? AppColors.borderPrimary
                                            //         : null,
                                            //     count: _totalRecommendJobs,
                                            //     boxColor: _typeMyJob ==
                                            //             "SeekerRecommendJob"
                                            //         ? AppColors.primary600
                                            //         : null,
                                            //     textColor: _typeMyJob ==
                                            //             "SeekerRecommendJob"
                                            //         ? AppColors.fontWhite
                                            //         : null,
                                            //     countColor: _typeMyJob ==
                                            //             "SeekerRecommendJob"
                                            //         ? AppColors.fontWhite
                                            //         : null,
                                            //     press: () {
                                            //       pressTapMyJobType(
                                            //           'SeekerRecommendJob');
                                            //     },
                                            //   ),
                                            // ),

                                            // SizedBox(width: 5),
                                            // Expanded(
                                            //   child: Container(),
                                            // ),
                                            // SizedBox(width: 5),
                                            // Expanded(
                                            //   child: Container(),
                                            // )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  //
                                  //
                                  // Single tab for selected
                                  collapsedChild: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundWhite,
                                      border: Border(
                                        bottom: BorderSide(
                                            color: AppColors.borderBG),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TabMenu(
                                                text: "${_textTab}",
                                                borderColor:
                                                    AppColors.borderPrimary,
                                                count: _typeMyJob ==
                                                        "SeekerRecommendJob"
                                                    ? int.parse(
                                                        "${_totalRecommendJobs}")
                                                    : totals == null
                                                        ? 0
                                                        : int.parse(
                                                            "${totals}"),
                                                boxColor: AppColors.primary600,
                                                textColor: AppColors.fontWhite,
                                                countColor: AppColors.fontWhite,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              SliverToBoxAdapter(
                                child: SizedBox(
                                  height: 20,
                                ),
                              ),

                              //
                              //
                              //Section list my job
                              if (_typeMyJob != "SeekerRecommendJob")
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (index == _listMyJobs.length) {
                                        return _hasMoreData
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0,
                                                        vertical: 10),
                                                child: Container(),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: Text(
                                                        'no have data'.tr)),
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
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
                                                    fetchProfileDashboardStatus();
                                                  }
                                                });
                                              },
                                            ),
                                            children: [
                                              if (_typeMyJob == "SeekerSaveJob")
                                                SlidableAction(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                  backgroundColor:
                                                      AppColors.lightPrimary,
                                                  foregroundColor:
                                                      AppColors.primary,
                                                  icon: FontAwesomeIcons
                                                      .solidHeart,
                                                  label: 'unsave'.tr,
                                                  onPressed: (context) {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            focusNode);
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
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                  backgroundColor:
                                                      AppColors.buttonWarning,
                                                  foregroundColor:
                                                      AppColors.fontWhite,
                                                  icon: FontAwesomeIcons
                                                      .rotateLeft,
                                                  label: 'unhide'.tr,
                                                  onPressed: (constext) async {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            focusNode);
                                                    print("press hidded");
                                                    var result =
                                                        await showDialog(
                                                            context: context,
                                                            builder: (context) {
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
                                                                    'cancel'.tr,
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
                                                        .requestFocus(
                                                            focusNode);
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
                                                                child:
                                                                    Container(
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
                                                                        width:
                                                                            60,
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
                                                                          color:
                                                                              AppColors.backgroundWhite,
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
                                                                              style: bodyTextMinNormal(null, null, null),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            Text(
                                                                              "${getTimeAgo(_dateTimeNow, openDate)}",
                                                                              style: bodyTextSmall(null, null, null),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
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
                                                  color: AppColors
                                                      .borderGreyOpacity,
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
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () async {
                                                            FocusScope.of(
                                                                    context)
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
                                                                        title: "unhide job"
                                                                            .tr,
                                                                        smallText:
                                                                            "unhide_job_explain".tr,
                                                                        contentText:
                                                                            "${i['jobTitle']}",
                                                                        textButtonLeft:
                                                                            'cancel'.tr,
                                                                        textButtonRight:
                                                                            'confirm'.tr,
                                                                      );
                                                                    });
                                                            if (result ==
                                                                'Ok') {
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
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
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
                                    },
                                    childCount: _listMyJobs.length + 1,
                                  ),
                                ),

                              if (_typeMyJob == "SeekerRecommendJob")
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int indexRecommend) {
                                      if (indexRecommend ==
                                          _listRecommendJobs.length) {
                                        return _hasMoreData
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0,
                                                        vertical: 10),
                                                child: Container(),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: Text(
                                                        'no have data'.tr)),
                                              );
                                      }
                                      dynamic i =
                                          _listRecommendJobs[indexRecommend];

                                      _logo = i['employerId']['logo'];
                                      _jobTitle = i['title'];
                                      _companyName =
                                          i['employerId']['companyName'];
                                      _workLocation =
                                          i['workingLocationId'][0]['name'];
                                      _openDate = i['openingDate'];
                                      _closeDate = i['closingDate'];
                                      // _isClick = i['isClick'].toString();
                                      // _tag = i['tag'];
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
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
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                  backgroundColor:
                                                      AppColors.lightPrimary,
                                                  foregroundColor:
                                                      AppColors.primary,
                                                  icon: FontAwesomeIcons
                                                      .solidHeart,
                                                  label: 'unsave'.tr,
                                                  onPressed: (context) {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            focusNode);
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
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                  backgroundColor:
                                                      AppColors.buttonWarning,
                                                  foregroundColor:
                                                      AppColors.fontWhite,
                                                  icon: FontAwesomeIcons
                                                      .rotateLeft,
                                                  label: 'unhide'.tr,
                                                  onPressed: (constext) async {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            focusNode);
                                                    print("press hidded");
                                                    var result =
                                                        await showDialog(
                                                            context: context,
                                                            builder: (context) {
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
                                                                    'cancel'.tr,
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
                                                        .requestFocus(
                                                            focusNode);
                                                    if (_typeMyJob !=
                                                        "SeekerHideJob") {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              JobSearchDetail(
                                                            jobId: i['_id'],
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
                                                                child:
                                                                    Container(
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
                                                                        width:
                                                                            60,
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
                                                                          color:
                                                                              AppColors.backgroundWhite,
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
                                                                              style: bodyTextMinNormal(null, null, null),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            Text(
                                                                              "${getTimeAgo(_dateTimeNow, openDate)}",
                                                                              style: bodyTextSmall(null, null, null),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
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

                                                // Divider(
                                                //   height: 1,
                                                //   color: AppColors.borderGreyOpacity,
                                                // ),

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
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () async {
                                                            FocusScope.of(
                                                                    context)
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
                                                                        title: "unhide job"
                                                                            .tr,
                                                                        smallText:
                                                                            "unhide_job_explain".tr,
                                                                        contentText:
                                                                            "${i['jobTitle']}",
                                                                        textButtonLeft:
                                                                            'cancel'.tr,
                                                                        textButtonRight:
                                                                            'confirm'.tr,
                                                                      );
                                                                    });
                                                            if (result ==
                                                                'Ok') {
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
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
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
                                    },
                                    childCount: _listRecommendJobs.length + 1,
                                  ),
                                ),

                              // if (_isLoadingMoreData)
                              //   Padding(
                              //     padding: const EdgeInsets.all(0),
                              //     child: Center(child: CircularProgressIndicator()),
                              //   ),
                            ],
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

class TabMenu extends StatefulWidget {
  const TabMenu({
    Key? key,
    required this.text,
    required this.count,
    this.boxColor,
    this.textColor,
    this.countColor,
    this.borderColor,
    this.press,
  }) : super(key: key);

  final Color? boxColor, borderColor, textColor, countColor;
  final String text;
  final int count;
  final Function()? press;

  @override
  State<TabMenu> createState() => _TabMenuState();
}

class _TabMenuState extends State<TabMenu> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            color: widget.boxColor == null
                ? AppColors.background
                : widget.boxColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: widget.borderColor ?? AppColors.borderGreyOpacity)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${widget.text}",
              style: bodyTextSmall(
                  null, widget.textColor ?? null, FontWeight.bold),
            ),
            if (widget.count > 0)
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  "${widget.count}",
                  style: bodyTextSmall(
                      null, widget.countColor ?? null, FontWeight.bold),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.expandedChild,
    required this.collapsedChild,
  });

  final double minHeight;
  final double maxHeight;
  final Widget expandedChild;
  final Widget collapsedChild;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // This calculates how much we have collapsed (0.0 to 1.0)
    // We add a small clamp to prevent division by zero
    double percent = shrinkOffset / (maxExtent - minExtent + 0.001);

    return Container(
      width: double.infinity,
      height: maxHeight,
      color: AppColors.backgroundWhite,
      // We use ClipRect to prevent the content from bleeding outside the header
      child: ClipRect(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // 1. THE GRID (Expanded View)
            // Wrap in a SingleChildScrollView so it doesn't overflow when shrinking
            Opacity(
              opacity: (1 - percent * 1.5).clamp(0.0, 1.0),
              child: percent < 0.9
                  ? SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: SizedBox(
                        height: maxHeight,
                        child: expandedChild,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // 2. THE SINGLE TAB (Collapsed View)
            Opacity(
              opacity: (percent * 1.5 - 0.5).clamp(0.0, 1.0),
              child: percent > 0.1
                  ? Container(
                      height: minHeight,
                      alignment: Alignment.center,
                      child: collapsedChild,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => true;
}
