// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_final_fields, unused_field, unused_local_variable, avoid_print, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, unnecessary_null_comparison, non_constant_identifier_names, prefer_if_null_operators, prefer_is_empty

import 'dart:async';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/cupertinoDatePicker.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearchDetail.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:app/widget/listJobFuncSelectedAlertDialog.dart';
import 'package:app/widget/listMultiSelectedAlertDialog.dart';
import 'package:app/widget/screenNoData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class JobSearch extends StatefulWidget {
  const JobSearch({Key? key}) : super(key: key);

  @override
  State<JobSearch> createState() => _JobSearchState();
}

class _JobSearchState extends State<JobSearch>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchTitleController = TextEditingController();
  late final slidableController = SlidableController(this);

  //
  //Get list items all
  List _listProvinces = [];
  List _listEducationsLevels = [];
  List _listIndustries = [];
  List _listJobLevels = [];
  List _listJobsSearch = [];
  List _listJobFunctions = [];
  List _ListJobExperiences = [];

  //
  //Selected list item(ສະເພາະເຂົ້າ Database)
  List _selectedProvincesListItem = [];
  List _selectedEducationLeavelListItem = [];
  List _selectedIndustryListItem = [];
  List _selectedJobExperienceListItem = [];
  List _selectedJobLevelListItem = [];
  List _selectedJobFunctionsItems = [];

  //
  //value display(ສະເພາະສະແດງ)
  List _provinceName = [];
  List _educationLevelName = [];
  List _industryName = [];
  List _jobExperienceName = [];
  List _jobLevelName = [];
  List _jobFunctionItemName = [];

  String _jobId = "";
  String _logo = "";
  String _title = "";
  String _companyName = "";
  String _workingLocations = "";
  String _isClick = "";
  String _total = "";
  String _searchTitle = "";
  String _strPostDateLastest = "";
  String _strPostDateOldest = "";

  dynamic _openDate;
  dynamic _closeDate;
  dynamic _postDateLastest;
  dynamic _postDateOldest;

  Timer? _timer;

  bool _statusShowLoading = false;
  bool _isValidateValue = false;
  bool _closeOnScroll = true;
  bool _isLoading = false;
  bool _isCheckFilterColor = false;

  DateTime _dateTimeNow = DateTime.now();

  dynamic slidableAction(String val) {
    print(val);
  }

  String getTimeAgo(DateTime dateTimeNow, DateTime openDateTime) {
    Duration difference = openDateTime.difference(dateTimeNow).abs();
    if (difference.inDays > 365) {
      return '${difference.inDays ~/ 365} year${difference.inDays ~/ 365 == 1 ? '' : 's'} ago';
    } else if (difference.inDays >= 30) {
      return '${difference.inDays ~/ 30} month${difference.inDays ~/ 30 == 1 ? '' : 's'} ago';
    } else if (difference.inDays >= 7) {
      return '${difference.inDays ~/ 7} week${difference.inDays ~/ 7 == 1 ? '' : 's'} ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  clearValueFilterAll() async {
    setState(() {
      _postDateLastest = null;
      _postDateOldest = null;
      _strPostDateLastest = "";
      _strPostDateOldest = "";
      _selectedEducationLeavelListItem = [];
      _selectedJobFunctionsItems = [];
      _selectedProvincesListItem = [];
      _selectedIndustryListItem = [];
      _selectedJobExperienceListItem = [];
      _selectedJobLevelListItem = [];
    });
  }

  filterColor() {
    if (_strPostDateLastest != "" ||
        _strPostDateOldest != "" ||
        _selectedEducationLeavelListItem.length > 0 ||
        _selectedJobFunctionsItems.length > 0 ||
        _selectedProvincesListItem.length > 0 ||
        _selectedIndustryListItem.length > 0 ||
        _selectedJobExperienceListItem.length > 0 ||
        _selectedJobLevelListItem.length > 0) {
      setState(() {
        _isCheckFilterColor = true;
      });
    } else {
      setState(() {
        _isCheckFilterColor = false;
      });
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
    getJobsSearchSeeker();

    getReuseFilterJobSearchSeeker('EN', _listIndustries, "industry");
    getReuseFilterJobSearchSeeker('EN', _listProvinces, "workLocation");
    getReuseFilterJobSearchSeeker('EN', _ListJobExperiences, "jobExperience");
    getReuseFilterJobSearchSeeker(
        'EN', _listEducationsLevels, "educationLevel");
    getReuseFilterJobSearchSeeker('EN', _listJobLevels, "jobLevel");

    getJobFunctionsSeeker();

    _searchTitleController.text = _searchTitle;

    //
    //Start a timer when the widget is initialized
    print('initState called');
  }

  @override
  void dispose() {
    //
    //Cancel the timer when the widget is disposed
    _searchTitleController.dispose();
    _timer?.cancel();
    print('dispose called');
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
          // appBar: AppBar(
          //   toolbarHeight: 0,
          //   systemOverlayStyle: SystemUiOverlayStyle.dark,
          //   backgroundColor: AppColors.background,
          // ),
          body: SafeArea(
            child: _isLoading
                ? Container(
                    color: AppColors.background,
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container(
                    color: AppColors.background,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),

                        //
                        //
                        //Search and Filter
                        Row(
                          children: [
                            //
                            //
                            //Search keywords
                            Expanded(
                              flex: 8,
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
                                    print('Calling API Get JobsSearch');
                                    setState(() {
                                      _statusShowLoading = true;
                                    });
                                    getJobsSearchSeeker();
                                  });
                                },
                                hintText: 'Search keywords',
                                inputColor: AppColors.inputWhite,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),

                            //
                            //
                            //BoxDecoration Filter
                            Expanded(
                              flex: 3,
                              child: Container(
                                child: BoxDecorationInput(
                                  mainAxisAlignmentTextIcon:
                                      MainAxisAlignment.center,
                                  heigth: 45,
                                  boxDecBorderRadius: BorderRadius.circular(8),
                                  colorInput: _isCheckFilterColor
                                      ? AppColors.lightPrimary
                                      : AppColors.greyShimmer,
                                  colorBorder: _isCheckFilterColor
                                      ? AppColors.borderPrimary
                                      : AppColors.borderBG,
                                  widgetFaIcon: FaIcon(
                                    FontAwesomeIcons.barsStaggered,
                                    size: 15,
                                    color: _isCheckFilterColor
                                        ? AppColors.iconPrimary
                                        : AppColors.iconGray,
                                  ),
                                  paddingFaIcon:
                                      EdgeInsets.symmetric(horizontal: 10),

                                  text: "Filter",
                                  // fontWeight: FontWeight.bold,
                                  colorText: _isCheckFilterColor
                                      ? AppColors.fontPrimary
                                      : AppColors.fontGrey,
                                  validateText: Container(),
                                  press: () async {
                                    //
                                    //
                                    //Alert Dialog Filter
                                    var result = await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return AlertDialog(
                                            titlePadding: EdgeInsets.zero,
                                            contentPadding: EdgeInsets.zero,
                                            insetPadding: EdgeInsets.zero,
                                            actionsPadding: EdgeInsets.zero,

                                            //
                                            //
                                            //Title Filter Alert
                                            title: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 15),
                                              decoration: BoxDecoration(
                                                  color:
                                                      AppColors.backgroundWhite,
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: AppColors
                                                          .borderSecondary,
                                                    ),
                                                  )),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      filterColor();
                                                      Navigator.pop(context);
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .arrowLeft,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Center(
                                                      child: Text(
                                                        "Filter",
                                                        style: bodyTextMedium(
                                                            null,
                                                            FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        clearValueFilterAll();
                                                      });
                                                    },
                                                    child: Text(
                                                      "Clear All",
                                                      style: bodyTextNormal(
                                                          AppColors.fontPrimary,
                                                          null),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),

                                            //
                                            //
                                            //Content Filter Alert
                                            content: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                              color: AppColors.backgroundWhite,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: SingleChildScrollView(
                                                physics:
                                                    ClampingScrollPhysics(),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Text("${_postDateLastest}"),
                                                    // Text("${_postDateOldest}"),

                                                    //
                                                    //
                                                    //Sort By
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Sort By",
                                                          style: bodyTextNormal(
                                                              null,
                                                              FontWeight.bold),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            //
                                                            //
                                                            //Post Date Lastest
                                                            Expanded(
                                                              flex: 1,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  //
                                                                  // format date.now() ຈາກ 2022-10-30 19:44:31.180 ເປັນ 2022-10-30 00:00:00.000
                                                                  var formatDateTimeNow = DateFormat(
                                                                          "yyyy-MM-dd")
                                                                      .parse(_dateTimeNow
                                                                          .toString());
                                                                  setState(() {
                                                                    _postDateLastest ==
                                                                            null
                                                                        ? _postDateLastest =
                                                                            formatDateTimeNow
                                                                        : _postDateLastest;
                                                                  });

                                                                  showDialogDateTime(
                                                                    context,
                                                                    Text(
                                                                      "Post Date (Lastest)",
                                                                      style: bodyTextMedium(
                                                                          null,
                                                                          FontWeight
                                                                              .bold),
                                                                    ),
                                                                    CupertinoDatePicker(
                                                                      initialDateTime: _postDateLastest ==
                                                                              null
                                                                          ? formatDateTimeNow
                                                                          : _postDateLastest,
                                                                      mode: CupertinoDatePickerMode
                                                                          .date,
                                                                      dateOrder:
                                                                          DatePickerDateOrder
                                                                              .dmy,
                                                                      use24hFormat:
                                                                          true,
                                                                      onDateTimeChanged:
                                                                          (DateTime
                                                                              newDate) {
                                                                        setState(
                                                                            () {
                                                                          _postDateLastest =
                                                                              newDate;

                                                                          if (_postDateOldest != null &&
                                                                              _postDateOldest.isBefore(_postDateLastest)) {
                                                                            // If toDate is before fromDate, set toDate to null
                                                                            _postDateOldest =
                                                                                null;
                                                                          }
                                                                        });
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          10),
                                                                  decoration:
                                                                      boxDecoration(
                                                                    null,
                                                                    AppColors
                                                                        .light,
                                                                    AppColors
                                                                        .light,
                                                                  ),
                                                                  child: Text(
                                                                    _postDateLastest ==
                                                                            null
                                                                        ? "Post Date (Lastest)"
                                                                        : "${_postDateLastest?.day}-${_postDateLastest?.month}-${_postDateLastest?.year}",
                                                                    style: bodyTextNormal(
                                                                        null,
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),

                                                            //
                                                            //
                                                            //Post date Oldest
                                                            Expanded(
                                                              flex: 1,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _postDateOldest ==
                                                                            null
                                                                        ? _postDateOldest =
                                                                            _postDateLastest
                                                                        : _postDateOldest;
                                                                  });

                                                                  showDialogDateTime(
                                                                      context,
                                                                      Text(
                                                                        "Post Date (Oldest)",
                                                                        style: bodyTextMedium(
                                                                            null,
                                                                            FontWeight.bold),
                                                                      ),
                                                                      CupertinoDatePicker(
                                                                        initialDateTime: _postDateOldest ==
                                                                                null
                                                                            ? _postDateLastest
                                                                            : _postDateOldest,
                                                                        mode: CupertinoDatePickerMode
                                                                            .date,
                                                                        dateOrder:
                                                                            DatePickerDateOrder.dmy,
                                                                        minimumDate:
                                                                            _postDateLastest,
                                                                        use24hFormat:
                                                                            true,
                                                                        onDateTimeChanged:
                                                                            (DateTime
                                                                                newDate) {
                                                                          setState(
                                                                              () {
                                                                            _postDateOldest =
                                                                                newDate;
                                                                          });
                                                                        },
                                                                      ));
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          10),
                                                                  decoration:
                                                                      boxDecoration(
                                                                    null,
                                                                    AppColors
                                                                        .light,
                                                                    AppColors
                                                                        .light,
                                                                  ),
                                                                  child: Text(
                                                                    _postDateOldest ==
                                                                            null
                                                                        ? "Post Date (Oldest)"
                                                                        : "${_postDateOldest?.day}-${_postDateOldest?.month}-${_postDateOldest?.year}",
                                                                    style: bodyTextNormal(
                                                                        null,
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),

                                                    //
                                                    //
                                                    //Education Level
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Education Level",
                                                          style: bodyTextNormal(
                                                              null,
                                                              FontWeight.bold),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Wrap(
                                                          spacing: 10,
                                                          runSpacing: 10,
                                                          children:
                                                              List.generate(
                                                            _listEducationsLevels
                                                                .length,
                                                            (index) {
                                                              dynamic i =
                                                                  _listEducationsLevels[
                                                                      index];

                                                              String
                                                                  educationLevelName =
                                                                  i['name'];

                                                              return GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    //
                                                                    //ຖ້າໂຕທີ່ເລືອກ _id ກົງກັບ _selectedArray(_id) ແມ່ນລົບອອກ
                                                                    if (_selectedEducationLeavelListItem
                                                                        .contains(
                                                                            i['_id'])) {
                                                                      _selectedEducationLeavelListItem.removeWhere((e) =>
                                                                          e ==
                                                                          i['_id']);

                                                                      return;
                                                                    }

                                                                    //
                                                                    //ເອົາຂໍ້ມູນທີ່ເລືອກ Add ເຂົ້າໃນ Array _selectedArray
                                                                    _selectedEducationLeavelListItem
                                                                        .add(i[
                                                                            '_id']);
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          10),
                                                                  decoration: _selectedEducationLeavelListItem
                                                                          .contains(
                                                                              i['_id'])
                                                                      ? boxDecoration(
                                                                          null,
                                                                          AppColors
                                                                              .buttonLightPrimary,
                                                                          AppColors
                                                                              .buttonLightPrimary,
                                                                        )
                                                                      : boxDecoration(
                                                                          null,
                                                                          AppColors
                                                                              .light,
                                                                          AppColors
                                                                              .light,
                                                                        ),
                                                                  child: Text(
                                                                    "${educationLevelName}",
                                                                    style: bodyTextNormal(
                                                                        _selectedEducationLeavelListItem.contains(i['_id'])
                                                                            ? AppColors
                                                                                .fontPrimary
                                                                            : null,
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        )
                                                        // Row(
                                                        //   children: [
                                                        //     //
                                                        //     //High School
                                                        //     Container(
                                                        //       padding: EdgeInsets
                                                        //           .symmetric(
                                                        //               horizontal: 15,
                                                        //               vertical: 10),
                                                        //       decoration:
                                                        //           boxDecoration(
                                                        //         null,
                                                        //         AppColors.light,
                                                        //         AppColors.light,
                                                        //       ),
                                                        //       child: Text(
                                                        //         "High School",
                                                        //         style: bodyTextNormal(
                                                        //             null,
                                                        //             FontWeight.bold),
                                                        //       ),
                                                        //     ),
                                                        //     SizedBox(width: 10),

                                                        //     //
                                                        //     //Higher Diploma
                                                        //     Container(
                                                        //       padding: EdgeInsets
                                                        //           .symmetric(
                                                        //               horizontal: 15,
                                                        //               vertical: 10),
                                                        //       decoration:
                                                        //           boxDecoration(
                                                        //         null,
                                                        //         AppColors.light,
                                                        //         AppColors.light,
                                                        //       ),
                                                        //       child: Text(
                                                        //         "Higher Diploma",
                                                        //         style: bodyTextNormal(
                                                        //             null,
                                                        //             FontWeight.bold),
                                                        //       ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                        // SizedBox(height: 10),
                                                        // Row(
                                                        //   children: [
                                                        //     //
                                                        //     //Bachelor Degree
                                                        //     Container(
                                                        //       padding: EdgeInsets
                                                        //           .symmetric(
                                                        //               horizontal: 15,
                                                        //               vertical: 10),
                                                        //       decoration:
                                                        //           boxDecoration(
                                                        //         null,
                                                        //         AppColors.light,
                                                        //         AppColors.light,
                                                        //       ),
                                                        //       child: Text(
                                                        //         "Bachelor Degree",
                                                        //         style: bodyTextNormal(
                                                        //             null,
                                                        //             FontWeight.bold),
                                                        //       ),
                                                        //     ),
                                                        //     SizedBox(width: 10),

                                                        //     //
                                                        //     //Master Degree
                                                        //     Container(
                                                        //       padding: EdgeInsets
                                                        //           .symmetric(
                                                        //               horizontal: 15,
                                                        //               vertical: 10),
                                                        //       decoration:
                                                        //           boxDecoration(
                                                        //         null,
                                                        //         AppColors.light,
                                                        //         AppColors.light,
                                                        //       ),
                                                        //       child: Text(
                                                        //         "Master Degree",
                                                        //         style: bodyTextNormal(
                                                        //             null,
                                                        //             FontWeight.bold),
                                                        //       ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                        // SizedBox(height: 10),
                                                        // Row(
                                                        //   children: [
                                                        //     //
                                                        //     //Not Specific
                                                        //     Container(
                                                        //       padding: EdgeInsets
                                                        //           .symmetric(
                                                        //               horizontal: 15,
                                                        //               vertical: 10),
                                                        //       decoration:
                                                        //           boxDecoration(
                                                        //         null,
                                                        //         AppColors.light,
                                                        //         AppColors.light,
                                                        //       ),
                                                        //       child: Text(
                                                        //         "Not Specific",
                                                        //         style: bodyTextNormal(
                                                        //             null,
                                                        //             FontWeight.bold),
                                                        //       ),
                                                        //     ),
                                                        //   ],
                                                        // )
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),

                                                    //
                                                    //
                                                    //Job Function
                                                    Text(
                                                      "Job Functions",
                                                      style: bodyTextNormal(
                                                          null,
                                                          FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),

                                                    BoxDecorationInput(
                                                      mainAxisAlignmentTextIcon:
                                                          MainAxisAlignment
                                                              .start,
                                                      colorInput: AppColors
                                                          .backgroundWhite,
                                                      colorBorder:
                                                          _selectedJobFunctionsItems
                                                                      .isEmpty &&
                                                                  _isValidateValue ==
                                                                      true
                                                              ? AppColors
                                                                  .borderDanger
                                                              : AppColors
                                                                  .borderSecondary,
                                                      paddingFaIcon:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  1.7.w),
                                                      fontWeight:
                                                          _selectedJobFunctionsItems
                                                                  .isEmpty
                                                              ? FontWeight.bold
                                                              : null,
                                                      widgetIconActive: FaIcon(
                                                        FontAwesomeIcons
                                                            .caretDown,
                                                        color: AppColors
                                                            .iconGrayOpacity,
                                                        size: IconSize.sIcon,
                                                      ),
                                                      press: () async {
                                                        var result =
                                                            await showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return ListJobFuncSelectedAlertDialog(
                                                                    title:
                                                                        "Job Functions",
                                                                    listItems:
                                                                        _listJobFunctions,
                                                                    selectedListItems:
                                                                        _selectedJobFunctionsItems,
                                                                  );
                                                                }).then(
                                                          (value) {
                                                            print(value);
                                                            _selectedJobFunctionsItems =
                                                                value;
                                                            List pName = [];
                                                            List chName = [];

                                                            //value = [_selectedListItemsChilds]
                                                            //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                                            if (value != null) {
                                                              print(
                                                                  "value != null");
                                                              _selectedJobFunctionsItems =
                                                                  value;
                                                              _jobFunctionItemName =
                                                                  []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                                              for (var pItem
                                                                  in _listJobFunctions) {
                                                                //
                                                                //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedJobFunctionsItems ກົງກັບ _listJobFunctions ບໍ່
                                                                if (_selectedJobFunctionsItems
                                                                    .contains(pItem[
                                                                        "_id"])) {
                                                                  setState(() {
                                                                    _jobFunctionItemName
                                                                        .add(pItem[
                                                                            "name"]);
                                                                  });
                                                                }
                                                                for (var chItem
                                                                    in pItem[
                                                                        "item"]) {
                                                                  if (_selectedJobFunctionsItems
                                                                      .contains(
                                                                          chItem[
                                                                              "_id"])) {
                                                                    setState(
                                                                        () {
                                                                      _jobFunctionItemName.add(
                                                                          chItem[
                                                                              "name"]);
                                                                    });
                                                                  }
                                                                }
                                                              }

                                                              // print(pName);
                                                              // print(chName);
                                                              print(
                                                                  _jobFunctionItemName);
                                                              print(
                                                                  _selectedJobFunctionsItems);
                                                            }
                                                          },
                                                        );
                                                      },
                                                      text: _selectedJobFunctionsItems
                                                              .isNotEmpty
                                                          ? "${_jobFunctionItemName.join(', ')}"
                                                          : "Select Job Function",
                                                      colorText:
                                                          _selectedJobFunctionsItems
                                                                  .isEmpty
                                                              ? AppColors
                                                                  .fontGreyOpacity
                                                              : AppColors
                                                                  .fontDark,
                                                      validateText:
                                                          _isValidateValue ==
                                                                      true &&
                                                                  _selectedJobFunctionsItems
                                                                      .isEmpty
                                                              ? Container(
                                                                  width: double
                                                                      .infinity,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    left: 15,
                                                                    top: 5,
                                                                  ),
                                                                  child: Text(
                                                                    "required",
                                                                    style:
                                                                        bodyTextSmall(
                                                                      AppColors
                                                                          .fontDanger,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(),
                                                    ),
                                                    SizedBox(height: 5),

                                                    //
                                                    //
                                                    //Work Location
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      child: Text(
                                                        "Work Province",
                                                        style: bodyTextNormal(
                                                            null,
                                                            FontWeight.bold),
                                                      ),
                                                    ),
                                                    BoxDecorationInput(
                                                      mainAxisAlignmentTextIcon:
                                                          MainAxisAlignment
                                                              .start,
                                                      colorInput: AppColors
                                                          .backgroundWhite,
                                                      colorBorder: AppColors
                                                          .borderSecondary,
                                                      paddingFaIcon:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      widgetIconActive: FaIcon(
                                                          FontAwesomeIcons
                                                              .caretDown,
                                                          size: IconSize.sIcon,
                                                          color: AppColors
                                                              .iconSecondary),
                                                      press: () async {
                                                        var result =
                                                            await showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return ListMultiSelectedAlertDialog(
                                                                    title:
                                                                        "Work Province",
                                                                    listItems:
                                                                        _listProvinces,
                                                                    selectedListItem:
                                                                        _selectedProvincesListItem,
                                                                  );
                                                                }).then(
                                                          (value) {
                                                            setState(() {
                                                              //value = []
                                                              //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                                              if (value.length >
                                                                  0) {
                                                                _selectedProvincesListItem =
                                                                    value;
                                                                _provinceName =
                                                                    []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                                                for (var item
                                                                    in _listProvinces) {
                                                                  //
                                                                  //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedProvincesListItem ກົງກັບ _listProvinces ບໍ່
                                                                  if (_selectedProvincesListItem
                                                                      .contains(
                                                                          item[
                                                                              '_id'])) {
                                                                    //
                                                                    //add Provinces Name ເຂົ້າໃນ _provinceName
                                                                    setState(
                                                                        () {
                                                                      _provinceName
                                                                          .add(item[
                                                                              'name']);
                                                                    });
                                                                  }
                                                                }
                                                                print(
                                                                    _provinceName);
                                                              }
                                                            });
                                                          },
                                                        );
                                                      },
                                                      text: _selectedProvincesListItem
                                                              .isEmpty
                                                          ? "Select Work Province"
                                                          : "${_provinceName.join(', ')}",
                                                      validateText: Container(),
                                                    ),
                                                    SizedBox(height: 5),

                                                    //
                                                    //
                                                    //Industry
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      child: Text(
                                                        "Industry",
                                                        style: bodyTextNormal(
                                                            null,
                                                            FontWeight.bold),
                                                      ),
                                                    ),
                                                    BoxDecorationInput(
                                                      mainAxisAlignmentTextIcon:
                                                          MainAxisAlignment
                                                              .start,
                                                      colorInput: AppColors
                                                          .backgroundWhite,
                                                      colorBorder: AppColors
                                                          .borderSecondary,
                                                      paddingFaIcon:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      widgetIconActive: FaIcon(
                                                          FontAwesomeIcons
                                                              .caretDown,
                                                          size: 20,
                                                          color: AppColors
                                                              .iconSecondary),
                                                      press: () async {
                                                        var result =
                                                            await showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return ListMultiSelectedAlertDialog(
                                                                    title:
                                                                        "Industry",
                                                                    listItems:
                                                                        _listIndustries,
                                                                    selectedListItem:
                                                                        _selectedIndustryListItem,
                                                                  );
                                                                }).then(
                                                          (value) {
                                                            setState(() {
                                                              //value = []
                                                              //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                                              if (value.length >
                                                                  0) {
                                                                _selectedIndustryListItem =
                                                                    value;
                                                                _industryName =
                                                                    []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                                                for (var item
                                                                    in _listIndustries) {
                                                                  //
                                                                  //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedIndustryListItem ກົງກັບ _listIndustries ບໍ່
                                                                  if (_selectedIndustryListItem
                                                                      .contains(
                                                                          item[
                                                                              '_id'])) {
                                                                    //
                                                                    //add Language Name ເຂົ້າໃນ _industryName
                                                                    setState(
                                                                        () {
                                                                      _industryName
                                                                          .add(item[
                                                                              'name']);
                                                                    });
                                                                  }
                                                                }
                                                                print(
                                                                    _industryName);
                                                              }
                                                            });
                                                          },
                                                        );
                                                      },
                                                      text: _selectedIndustryListItem
                                                              .isEmpty
                                                          ? "Select Industry"
                                                          : "${_industryName.join(', ')}",
                                                      validateText: Container(),
                                                    ),

                                                    //
                                                    //
                                                    //Job Experiences
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      child: Text(
                                                        "Job Experience",
                                                        style: bodyTextNormal(
                                                            null,
                                                            FontWeight.bold),
                                                      ),
                                                    ),
                                                    BoxDecorationInput(
                                                      mainAxisAlignmentTextIcon:
                                                          MainAxisAlignment
                                                              .start,
                                                      colorInput: AppColors
                                                          .backgroundWhite,
                                                      colorBorder: AppColors
                                                          .borderSecondary,
                                                      paddingFaIcon:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      widgetIconActive: FaIcon(
                                                          FontAwesomeIcons
                                                              .caretDown,
                                                          size: 20,
                                                          color: AppColors
                                                              .iconSecondary),
                                                      press: () async {
                                                        var result =
                                                            await showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return ListMultiSelectedAlertDialog(
                                                                    title:
                                                                        "Job Experience",
                                                                    listItems:
                                                                        _ListJobExperiences,
                                                                    selectedListItem:
                                                                        _selectedJobExperienceListItem,
                                                                  );
                                                                }).then(
                                                          (value) {
                                                            setState(() {
                                                              //value = []
                                                              //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                                              if (value.length >
                                                                  0) {
                                                                _selectedJobExperienceListItem =
                                                                    value;
                                                                _jobExperienceName =
                                                                    []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                                                for (var item
                                                                    in _ListJobExperiences) {
                                                                  //
                                                                  //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedJobExperienceListItem ກົງກັບ _listJobExperience ບໍ່
                                                                  if (_selectedJobExperienceListItem
                                                                      .contains(
                                                                          item[
                                                                              '_id'])) {
                                                                    //
                                                                    //add Language Name ເຂົ້າໃນ _jobExperienceName
                                                                    setState(
                                                                        () {
                                                                      _jobExperienceName
                                                                          .add(item[
                                                                              'name']);
                                                                    });
                                                                  }
                                                                }
                                                                print(
                                                                    _jobExperienceName);
                                                              }
                                                            });
                                                          },
                                                        );
                                                      },
                                                      text: _selectedJobExperienceListItem
                                                              .isEmpty
                                                          ? "Select Job Experience"
                                                          : "${_jobExperienceName.join(', ')}",
                                                      validateText: Container(),
                                                    ),

                                                    //
                                                    //
                                                    //Job Level
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      child: Text(
                                                        "Job Level",
                                                        style: bodyTextNormal(
                                                            null,
                                                            FontWeight.bold),
                                                      ),
                                                    ),
                                                    BoxDecorationInput(
                                                      mainAxisAlignmentTextIcon:
                                                          MainAxisAlignment
                                                              .start,
                                                      colorInput: AppColors
                                                          .backgroundWhite,
                                                      colorBorder: AppColors
                                                          .borderSecondary,
                                                      paddingFaIcon:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      widgetIconActive: FaIcon(
                                                          FontAwesomeIcons
                                                              .caretDown,
                                                          size: 20,
                                                          color: AppColors
                                                              .iconSecondary),
                                                      press: () async {
                                                        var result =
                                                            await showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return ListMultiSelectedAlertDialog(
                                                                    title:
                                                                        "Job Level",
                                                                    listItems:
                                                                        _listJobLevels,
                                                                    selectedListItem:
                                                                        _selectedJobLevelListItem,
                                                                  );
                                                                }).then(
                                                          (value) {
                                                            setState(() {
                                                              //value = []
                                                              //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                                              if (value.length >
                                                                  0) {
                                                                _selectedJobLevelListItem =
                                                                    value;
                                                                _jobLevelName =
                                                                    []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                                                for (var item
                                                                    in _listJobLevels) {
                                                                  //
                                                                  //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedJobLevelListItem ກົງກັບ _listJobLevels ບໍ່
                                                                  if (_selectedJobLevelListItem
                                                                      .contains(
                                                                          item[
                                                                              '_id'])) {
                                                                    //
                                                                    //add Language Name ເຂົ້າໃນ _jobLevelName
                                                                    setState(
                                                                        () {
                                                                      _jobLevelName
                                                                          .add(item[
                                                                              'name']);
                                                                    });
                                                                  }
                                                                }
                                                                print(
                                                                    _jobLevelName);
                                                              }
                                                            });
                                                          },
                                                        );
                                                      },
                                                      text: _selectedJobLevelListItem
                                                              .isEmpty
                                                          ? "Select Industry"
                                                          : "${_jobLevelName.join(', ')}",
                                                      validateText: Container(),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 30),
                                                color:
                                                    AppColors.backgroundWhite,
                                                child: Button(
                                                  text: "Apply",
                                                  press: () {
                                                    Navigator.pop(context);

                                                    //API call here after press button apply
                                                    print(
                                                        'Calling API Get JobsSearch After Press Button Apply');
                                                    setState(() {
                                                      _statusShowLoading = true;
                                                    });
                                                    getJobsSearchSeeker();
                                                    filterColor();
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            )
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
                                " Jobs available",
                                style: bodyTextNormal(null, null),
                              ),
                            ],
                          ),
                        ),
                        //
                        //
                        //List Jobs Search
                        Expanded(
                          child: _listJobsSearch.length > 0
                              ? ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  itemCount: _listJobsSearch.length,
                                  itemBuilder: (context, index) {
                                    dynamic i = _listJobsSearch[index];

                                    _title = i['title'];
                                    _logo = i['logo'];
                                    _companyName = i['companyName'];
                                    _workingLocations = i['workingLocations'];
                                    _openDate = i['openingDate'];
                                    _closeDate = i['closingDate'];
                                    _isClick = i['isClick'].toString();

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
                                      child: Slidable(
                                        //check status newJob = true ບໍ່ໃຫ້ສະໄລໄດ້ ຖ້າເປັນ false ສາມາດສະໄລໄດ້
                                        // enabled: !i['newJob'] ? true : false,
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
                                              print(
                                                  "hide dismiss the Slidable");
                                              hideJob(i['jobId'], i['title']);
                                            },
                                          ),
                                          children: [
                                            if (!i['isSaved'])
                                              SlidableAction(
                                                backgroundColor:
                                                    AppColors.buttonPrimary,
                                                foregroundColor:
                                                    AppColors.fontWhite,
                                                icon: FontAwesomeIcons.heart,
                                                label: 'Save',
                                                onPressed: (context) {
                                                  print("press to save");
                                                  saveAndUnSaveJob(
                                                      i['jobId'], i['title']);
                                                  slidableController.close();
                                                },
                                              ),
                                            if (i['isSaved'])
                                              SlidableAction(
                                                backgroundColor:
                                                    AppColors.lightPrimary,
                                                foregroundColor:
                                                    AppColors.primary,
                                                icon:
                                                    FontAwesomeIcons.solidHeart,
                                                label: 'Saved',
                                                onPressed: (context) {
                                                  print("press to unsave");
                                                  saveAndUnSaveJob(
                                                      i['jobId'], i['title']);

                                                  slidableController.close();
                                                },
                                              ),
                                            SlidableAction(
                                              backgroundColor:
                                                  AppColors.buttonDanger,
                                              foregroundColor:
                                                  AppColors.fontWhite,
                                              icon: FontAwesomeIcons.ban,
                                              label: 'Hide',
                                              onPressed: (constext) {
                                                print("press to hide");
                                                hideJob(i['jobId'], i['title']);
                                              },
                                            ),
                                          ],
                                        ),

                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    JobSearchDetail(
                                                        jobId: i['jobId'],
                                                        newJob: i['newJob']),
                                              ),
                                            ).then((value) {
                                              //Success ແມ່ນຄ່າທີ່ໄດ້ຈາກການ Navigator.pop ທີ່ api Save Job or unSave Job ເຮັດວຽກ
                                              if (value == 'Success') {
                                                setState(() {
                                                  _statusShowLoading = true;
                                                });
                                                onGoBack(value);
                                              }
                                            });
                                          },
                                          child: Container(
                                            height: 250,
                                            padding: EdgeInsets.all(15),
                                            // margin: EdgeInsets.only(bottom: 15),
                                            decoration: boxDecoration(
                                              null,
                                              AppColors.backgroundWhite,
                                              null,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                                    Border.all(
                                                                  color: AppColors
                                                                      .borderSecondary,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: AppColors
                                                                    .backgroundWhite,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  child: Center(
                                                                    child: _logo ==
                                                                            ""
                                                                        ? Image
                                                                            .asset(
                                                                            'assets/image/no-image-available.png',
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          )
                                                                        : Image
                                                                            .network(
                                                                            "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${_logo}",
                                                                            fit:
                                                                                BoxFit.contain,
                                                                            errorBuilder: (context,
                                                                                error,
                                                                                stackTrace) {
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
                                                            SizedBox(width: 15),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${getTimeAgo(_dateTimeNow, openDate)}",
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      "${_isClick}",
                                                                      style: bodyTextNormal(
                                                                          AppColors
                                                                              .primary,
                                                                          null),
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
                                                      //Jobs Seach check newJob
                                                      Container(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: !i['newJob'] &&
                                                                  !i['isSaved']
                                                              ? AppColors
                                                                  .greyOpacity
                                                              : AppColors
                                                                  .primary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Text(
                                                          i['newJob'] &&
                                                                  !i['isSaved']
                                                              ? "New"
                                                              : !i['newJob'] &&
                                                                      i['isSaved']
                                                                  ? "Saved"
                                                                  : "Viewed",
                                                          style: bodyTextSmall(
                                                            !i['newJob'] &&
                                                                    !i[
                                                                        'isSaved']
                                                                ? AppColors
                                                                    .fontDark
                                                                : AppColors
                                                                    .fontWhite,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),

                                                //
                                                //Position
                                                Text(
                                                  "${_title}",
                                                  style: bodyTextMedium(
                                                      null, FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),

                                                //
                                                //Company Name
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.building,
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
                                                            bodyTextSmall(null),
                                                        overflow: TextOverflow
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
                                                      CrossAxisAlignment.start,
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
                                                        "${_workingLocations}",
                                                        style:
                                                            bodyTextSmall(null),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                //
                                                //Start Date to End Date
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
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
                                                    Text(
                                                      '${_openDate}',
                                                      style:
                                                          bodyTextSmall(null),
                                                    ),
                                                    Text(' - '),
                                                    Text(
                                                      "${_closeDate}",
                                                      style:
                                                          bodyTextSmall(null),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : ScreenNoData(
                                  faIcon:
                                      FontAwesomeIcons.fileCircleExclamation,
                                  colorIcon: AppColors.primary,
                                  text: "No have data",
                                  colorText: AppColors.primary,
                                ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  onGoBack(dynamic value) async {
    print("onGoBack");
    await getJobsSearchSeeker();
  }

  getReuseFilterJobSearchSeeker(
      String lang, List listValue, String resValue) async {
    var res = await fetchData(getReuseFilterJobSearchSeekerApi + "lang${lang}");

    setState(() {
      listValue.clear(); // Clear the existing list
      listValue.addAll(res[resValue]); // Add elements from the response
    });
  }

  getJobFunctionsSeeker() async {
    var res = await fetchData(getJobFunctionsSeekerApi);
    _listJobFunctions = res['mapper'];
    setState(() {});
  }

  getJobsSearchSeeker() async {
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

    if (_postDateLastest != null) {
      _strPostDateLastest = formatYMD(_postDateLastest);
    }
    if (_postDateOldest != null) {
      _strPostDateOldest = formatYMD(_postDateOldest);
    }

    var res = await postData(getJobsSearchSeekerApi, {
      "title": _searchTitle,
      "postDateLastest": _strPostDateLastest,
      "postDateOldest": _strPostDateOldest,
      "jobFunctionIds": _selectedJobFunctionsItems,
      "industryIds": _selectedIndustryListItem,
      "workingLocationIds": _selectedProvincesListItem,
      "jobExperienceId": _selectedJobExperienceListItem,
      "jobEducationLevelId": _selectedEducationLeavelListItem,
      "jobLevelId": _selectedJobLevelListItem,
      "page": 1,
      "perPage": 1000
    });
    _listJobsSearch = res['jobList'];
    _total = res['totals'].toString();
    if (res['jobList'] != null && _statusShowLoading) {
      _statusShowLoading = false;
      Navigator.pop(context);
    }
    _isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  saveAndUnSaveJob(String jobId, String jobTitle) async {
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
      "JobId": jobId,
    });
    print(res);

    if (res['message'] == "Saved" || res['message'] == "Unsaved") {
      await getJobsSearchSeeker();
      Navigator.pop(context);
    }

    if (res['message'] == "Saved") {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomAlertDialogSuccess(
            title: "Success",
            text: "$jobTitle Save Job Success",
            textButton: "OK",
            press: () {
              Navigator.pop(context);
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
            text: "$jobTitle Unsave Job Success",
            textButton: "OK",
            press: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  hideJob(String jobId, String jobTitle) async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertLoading();
      },
    );
    var res = await postData(hideJobSeekerApi, {
      "_id": "",
      "JobId": jobId,
    });
    print(res);

    //Hide succeed
    //UnHide succeed
    if (res['message'] == "Hide succeed") {
      await getJobsSearchSeeker();
      Navigator.pop(context);
    }

    if (res['message'] == "Hide succeed") {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomAlertDialogSuccess(
            title: "Success",
            text: "$jobTitle Hide Job Success",
            textButton: "OK",
            press: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }
}
