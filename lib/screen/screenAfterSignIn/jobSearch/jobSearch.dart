// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_final_fields, unused_field, unused_local_variable, avoid_print, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, unnecessary_null_comparison, non_constant_identifier_names, prefer_if_null_operators, prefer_is_empty, prefer_typing_uninitialized_variables, unnecessary_null_in_if_null_operators, sized_box_for_whitespace, body_might_complete_normally_nullable, unused_element, file_names, prefer_adjacent_string_concatenation, deprecated_member_use, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/internetDisconnected.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/ScreenAfterSignIn/JobSearch/jobSearchDetail_renew.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:app/widget/listJobFuncSelectedAlertDialog.dart';
import 'package:app/widget/listMultiSelectedAlertDialog.dart';
import 'package:app/widget/screenNoData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';

class JobSearch extends StatefulWidget {
  const JobSearch(
      {Key? key,
      this.topWorkLocation,
      this.topIndustry,
      this.type,
      this.selectedListItem,
      this.hasInternet})
      : super(key: key);
  final topWorkLocation;
  final topIndustry;
  final type;
  final selectedListItem;
  final hasInternet;

  @override
  State<JobSearch> createState() => _JobSearchState();
}

class _JobSearchState extends State<JobSearch>
    with SingleTickerProviderStateMixin {
  late final StreamSubscription<InternetStatus> _subscription;
  late final AppLifecycleListener _listener;
  TextEditingController _searchTitleController = TextEditingController();
  late final slidableController = SlidableController(this);
  ScrollController _scrollController = ScrollController();
  FocusScopeNode _currentFocus = FocusScopeNode();
  FocusNode focusNode = FocusNode();

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
  String _searchTitle = "";
  String _tag = "Highlight";
  String _localeLanguageApi = "";

  dynamic _openDate;
  dynamic _closeDate;
  int _postDateLastest = -1;

  Timer? _timer;

  bool _statusShowLoading = false;
  bool _isValidateValue = false;
  bool _closeOnScroll = true;
  bool _isCheckFilterColor = false;
  bool _isSaved = false;
  bool _isLoadingForm = true;
  bool _isLoadingMoreData = false;
  bool _hasMoreData = true;

  dynamic page = 1;
  dynamic perPage = 10;
  dynamic totals;
  dynamic _disablePeople;

  DateTime _dateTimeNow = DateTime.now();

  dynamic slidableAction(String val) {
    print(val);
  }

  // String getTimeAgo(DateTime dateTimeNow, DateTime openDateTime) {
  //   Duration difference = openDateTime.difference(dateTimeNow).abs();
  //   if (difference.inDays > 365) {
  //     return '${difference.inDays ~/ 365} year${difference.inDays ~/ 365 == 1 ? '' : 's'} ago';
  //   } else
  //   if (difference.inDays >= 30) {
  //     return '${difference.inDays ~/ 30} month${difference.inDays ~/ 30 == 1 ? '' : 's'} ago';
  //   } else if (difference.inDays >= 7) {
  //     return '${difference.inDays ~/ 7} week${difference.inDays ~/ 7 == 1 ? '' : 's'} ago';
  //   } else if (difference.inDays >= 1) {
  //     return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  //   } else if (difference.inHours >= 1) {
  //     return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  //   } else if (difference.inMinutes >= 1) {
  //     return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  //   } else {
  //     return "just now".tr;
  //   }
  // }

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

  clearValueFilterAll() async {
    setState(() {
      _postDateLastest = -1;
      _selectedEducationLeavelListItem = [];
      _selectedJobFunctionsItems = [];
      _selectedProvincesListItem = [];
      _selectedIndustryListItem = [];
      _selectedJobExperienceListItem = [];
      _selectedJobLevelListItem = [];
    });
  }

  filterColor() {
    if (_postDateLastest != -1 ||
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

  pressPostDate(val) {
    if (val == 1) {
      setState(() {
        _postDateLastest = -1;
      });
    } else if (val == -1) {
      setState(() {
        _postDateLastest = 1;
      });
    }
  }

  checkProvinceFromHomePage() {
    dynamic i = widget.topWorkLocation;
    if (i != null) {
      setState(() {
        _selectedProvincesListItem.add(i['_id']);

        _provinceName = [];
        _provinceName.add(i['name']);

        filterColor();
      });
    }
  }

  checkTopIndustryFromHomePage() {
    dynamic i = widget.topIndustry;
    if (i != null) {
      setState(() {
        _selectedIndustryListItem.add(i['_id']);

        _industryName = [];
        _industryName.add(i['name']);

        filterColor();
      });
    }
  }

  checkSelectedListItemFromHomePage() {
    dynamic i = widget.selectedListItem;
    String str = widget.type;

    if (i != null) {
      if (str == "Industry") {
        setState(() {
          _selectedIndustryListItem = i;
          _industryName =
              []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

          for (var item in _listIndustries) {
            //
            //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedIndustryListItem ກົງກັບ _listIndustries ບໍ່
            if (_selectedIndustryListItem.contains(item['_id'])) {
              //
              //add Industry Name ເຂົ້າໃນ _industryName

              _industryName.add(item['name']);
            }
          }

          getJobsSearchSeeker();
          filterColor();
        });
      } else if (str == "Province") {
        _selectedProvincesListItem = i;
        _provinceName =
            []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

        for (var item in _listProvinces) {
          //
          //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedProvincesListItem ກົງກັບ _listProvinces ບໍ່
          if (_selectedProvincesListItem.contains(item['_id'])) {
            //
            //add Provinces Name ເຂົ້າໃນ _provinceName

            _provinceName.add(item['name']);
          }
        }
        getJobsSearchSeeker();
        filterColor();
      }
    }
  }

  //error setState() called after dispose(). it can help!!!
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  getSharedPreferences() async {
    // final prefs = await SharedPreferences.getInstance();
    // var getLanguageSharePref = prefs.getString('setLanguage');
    // var getLanguageApiSharePref = prefs.getString('setLanguageApi');
    // print("local " + getLanguageSharePref.toString());
    // print("api " + getLanguageApiSharePref.toString());

    var getLanguageSharePref = await SharedPrefsHelper.getString("setLanguage");
    var getLanguageApiSharePref =
        await SharedPrefsHelper.getString("setLanguageApi");

    setState(() {
      _localeLanguageApi = getLanguageApiSharePref.toString();
    });

    getReuseFilterJobSearchSeeker(
        _localeLanguageApi, _listIndustries, "industry");
    getReuseFilterJobSearchSeeker(
        _localeLanguageApi, _listProvinces, "workLocation");
    getReuseFilterJobSearchSeeker(
        _localeLanguageApi, _ListJobExperiences, "jobExperience");
    getReuseFilterJobSearchSeeker(
        _localeLanguageApi, _listEducationsLevels, "educationLevel");
    getReuseFilterJobSearchSeeker(
        _localeLanguageApi, _listJobLevels, "jobLevel");
  }

  @override
  void initState() {
    super.initState();

    print("widget hasInternet jobsearch: " + "${widget.hasInternet}");

    if (widget.hasInternet == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showInternetDisconnected(context);
      });
    } else {
      // _isLoadingForm = true;
      getSharedPreferences();

      getJobFunctionsSeeker();

      if (widget.topWorkLocation != null) {
        checkProvinceFromHomePage();
      }
      if (widget.topIndustry != null) {
        checkTopIndustryFromHomePage();
      }
      if (widget.selectedListItem == null) {
        getJobsSearchSeeker();
      }

      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            _isLoadingMoreData = true;
          });

          getJobsSearchSeeker();
        }
      });

      _searchTitleController.text = _searchTitle;

      //
      //Start a timer when the widget is initialized
      print('initState called');
    }
  }

  @override
  void dispose() {
    //
    //Cancel the timer when the widget is disposed
    _scrollController.dispose();
    _searchTitleController.dispose();
    _timer?.cancel();
    // _subscription.cancel();
    // _listener.dispose();

    print('dispose called');
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
          // appBar: AppBar(
          //   toolbarHeight: 0,
          //   systemOverlayStyle: SystemUiOverlayStyle.dark,
          //   backgroundColor: AppColors.background,

          body: SafeArea(
            child: _isLoadingForm
                ? Container(
                    color: AppColors.dark100,
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(child: CustomLoadingLogoCircle()),
                  )
                : Container(
                    color: AppColors.background,
                    // padding: EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),

                        //
                        //
                        //
                        //
                        //
                        //Box job search and box filter
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              //
                              //
                              //Search keywords
                              Expanded(
                                flex: 8,
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
                                      print(
                                          'Calling API get JobsSearch after typing search');

                                      getJobsSearchByTypingSearchSeeker();
                                    });
                                  },
                                  hintText: 'search'.tr,
                                  inputColor: AppColors.inputWhite,
                                ),
                              ),

                              SizedBox(
                                width: 10,
                              ),

                              //
                              //
                              //Box filter
                              GestureDetector(
                                onTap: () async {
                                  //
                                  //
                                  //Alert Dialog Filter
                                  FocusScope.of(context)
                                      .requestFocus(focusNode);
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
                                                Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      filterColor();
                                                      Navigator.pop(context);
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 20),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                      child: FaIcon(
                                                        FontAwesomeIcons
                                                            .arrowLeft,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "filter".tr,
                                                      style: bodyTextMedium(
                                                          null,
                                                          null,
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        clearValueFilterAll();
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 20),
                                                      child: Text(
                                                        "clear all".tr,
                                                        style: bodyTextNormal(
                                                            null,
                                                            AppColors
                                                                .fontPrimary,
                                                            null),
                                                      ),
                                                    ),
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
                                              physics: ClampingScrollPhysics(),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Text(
                                                  //     "${_postDateLastest.toString()}"),
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
                                                        "sort by".tr,
                                                        style: bodyTextNormal(
                                                            null,
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
                                                          //Post Date Lastest/Oldest
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                pressPostDate(
                                                                    _postDateLastest);
                                                              });
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          10),
                                                              decoration: _postDateLastest ==
                                                                      -1
                                                                  ? boxDecoration(
                                                                      null,
                                                                      AppColors
                                                                          .light,
                                                                      AppColors
                                                                          .light,
                                                                      null)
                                                                  : boxDecoration(
                                                                      null,
                                                                      AppColors
                                                                          .lightPrimary,
                                                                      AppColors
                                                                          .lightPrimary,
                                                                      null),
                                                              child: Text(
                                                                _postDateLastest == -1
                                                                    ? "post date latest"
                                                                        .tr
                                                                    : "post date oldest"
                                                                        .tr,
                                                                style: bodyTextNormal(
                                                                    null,
                                                                    _postDateLastest ==
                                                                            -1
                                                                        ? null
                                                                        : AppColors
                                                                            .fontPrimary,
                                                                    null),
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
                                                        "education level".tr,
                                                        style: bodyTextNormal(
                                                            null,
                                                            null,
                                                            FontWeight.bold),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Wrap(
                                                        spacing: 10,
                                                        runSpacing: 10,
                                                        children: List.generate(
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
                                                                    _selectedEducationLeavelListItem
                                                                        .removeWhere((e) =>
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
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            15,
                                                                        vertical:
                                                                            10),
                                                                decoration: _selectedEducationLeavelListItem
                                                                        .contains(i[
                                                                            '_id'])
                                                                    ? boxDecoration(
                                                                        null,
                                                                        AppColors
                                                                            .buttonLightPrimary,
                                                                        AppColors
                                                                            .buttonLightPrimary,
                                                                        null)
                                                                    : boxDecoration(
                                                                        null,
                                                                        AppColors
                                                                            .light,
                                                                        AppColors
                                                                            .light,
                                                                        null),
                                                                child: Text(
                                                                  "${educationLevelName}",
                                                                  style:
                                                                      bodyTextNormal(
                                                                    null,
                                                                    _selectedEducationLeavelListItem.contains(i[
                                                                            '_id'])
                                                                        ? AppColors
                                                                            .fontPrimary
                                                                        : null,
                                                                    null,
                                                                  ),
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
                                                      //         style: bodyTextNormal(null,
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
                                                      //         style: bodyTextNormal(null,
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
                                                      //         style: bodyTextNormal(null,
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
                                                      //         style: bodyTextNormal(null,
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
                                                      //         style: bodyTextNormal(null,
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
                                                    "job function".tr,
                                                    style: bodyTextNormal(null,
                                                        null, FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),

                                                  BoxDecorationInput(
                                                    mainAxisAlignmentTextIcon:
                                                        MainAxisAlignment.start,
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
                                                            horizontal: 10),
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
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return ListJobFuncSelectedAlertDialog(
                                                                  title:
                                                                      "job function"
                                                                          .tr,
                                                                  listItems:
                                                                      _listJobFunctions,
                                                                  selectedListItems:
                                                                      _selectedJobFunctionsItems,
                                                                );
                                                              }).then(
                                                        (value) {
                                                          print(value);
                                                          setState(() {
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
                                                          });
                                                        },
                                                      );
                                                    },
                                                    text: _selectedJobFunctionsItems
                                                            .isNotEmpty
                                                        ? "${_jobFunctionItemName.join(', ')}"
                                                        : "select".tr +
                                                            "job function".tr,
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
                                                                  "required".tr,
                                                                  style: bodyTextSmall(
                                                                      null,
                                                                      AppColors
                                                                          .fontDanger,
                                                                      null),
                                                                ),
                                                              )
                                                            : Container(),
                                                  ),
                                                  SizedBox(height: 10),

                                                  //
                                                  //
                                                  //Work Location
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    child: Text(
                                                      "work province".tr,
                                                      style: bodyTextNormal(
                                                          null,
                                                          null,
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                  BoxDecorationInput(
                                                    mainAxisAlignmentTextIcon:
                                                        MainAxisAlignment.start,
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
                                                            .iconGrayOpacity),
                                                    press: () async {
                                                      var result =
                                                          await showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return ListMultiSelectedAlertDialog(
                                                                  title:
                                                                      "work province"
                                                                          .tr,
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
                                                                    .contains(item[
                                                                        '_id'])) {
                                                                  //
                                                                  //add Provinces Name ເຂົ້າໃນ _provinceName
                                                                  setState(() {
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
                                                        ? "select".tr +
                                                            "work province".tr
                                                        : "${_provinceName.join(', ')}",
                                                    validateText: Container(),
                                                  ),
                                                  SizedBox(height: 10),

                                                  //
                                                  //
                                                  //Industry
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    child: Text(
                                                      "industry".tr,
                                                      style: bodyTextNormal(
                                                          null,
                                                          null,
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                  BoxDecorationInput(
                                                    mainAxisAlignmentTextIcon:
                                                        MainAxisAlignment.start,
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
                                                            .iconGrayOpacity),
                                                    press: () async {
                                                      var result =
                                                          await showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return ListMultiSelectedAlertDialog(
                                                                  title:
                                                                      "industry"
                                                                          .tr,
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
                                                                    .contains(item[
                                                                        '_id'])) {
                                                                  //
                                                                  //add Language Name ເຂົ້າໃນ _industryName
                                                                  setState(() {
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
                                                        ? "select".tr +
                                                            "industry".tr
                                                        : "${_industryName.join(', ')}",
                                                    validateText: Container(),
                                                  ),
                                                  SizedBox(height: 10),

                                                  //
                                                  //
                                                  //Job Experiences
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    child: Text(
                                                      "job experience".tr,
                                                      style: bodyTextNormal(
                                                          null,
                                                          null,
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                  BoxDecorationInput(
                                                    mainAxisAlignmentTextIcon:
                                                        MainAxisAlignment.start,
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
                                                            .iconGrayOpacity),
                                                    press: () async {
                                                      var result =
                                                          await showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return ListMultiSelectedAlertDialog(
                                                                  title:
                                                                      "job experience"
                                                                          .tr,
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
                                                                    .contains(item[
                                                                        '_id'])) {
                                                                  //
                                                                  //add Language Name ເຂົ້າໃນ _jobExperienceName
                                                                  setState(() {
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
                                                        ? "select".tr +
                                                            "job experience".tr
                                                        : "${_jobExperienceName.join(', ')}",
                                                    validateText: Container(),
                                                  ),
                                                  SizedBox(height: 10),

                                                  //
                                                  //
                                                  //Job Level
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    child: Text(
                                                      "job level".tr,
                                                      style: bodyTextNormal(
                                                          null,
                                                          null,
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                  BoxDecorationInput(
                                                    mainAxisAlignmentTextIcon:
                                                        MainAxisAlignment.start,
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
                                                            .iconGrayOpacity),
                                                    press: () async {
                                                      var result =
                                                          await showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return ListMultiSelectedAlertDialog(
                                                                  title:
                                                                      "job level"
                                                                          .tr,
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
                                                                    .contains(item[
                                                                        '_id'])) {
                                                                  //
                                                                  //add Language Name ເຂົ້າໃນ _jobLevelName
                                                                  setState(() {
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
                                                        ? "select".tr +
                                                            "job level".tr
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
                                                  top: 10,
                                                  bottom: 30),
                                              color: AppColors.backgroundWhite,
                                              child: Button(
                                                text: "confirm".tr,
                                                press: () {
                                                  Navigator.pop(context);

                                                  //API call here after press button apply
                                                  print(
                                                      'Calling API Get JobsSearch After Press Button Apply');
                                                  setState(() {
                                                    _statusShowLoading = true;
                                                    _listJobsSearch.clear();
                                                    _hasMoreData = true;
                                                    page = 1;
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
                                child: Container(
                                  height: 45,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: AppColors.backgroundWhite,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: _isCheckFilterColor
                                              ? AppColors.borderPrimary
                                              : AppColors.borderWhite)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: FaIcon(
                                      FontAwesomeIcons.barsStaggered,
                                      size: 15,
                                      color: _isCheckFilterColor
                                          ? AppColors.iconPrimary
                                          : AppColors.iconGray,
                                    ),
                                  ),
                                ),
                              ),

                              //BoxDecoration Filter
                              // Expanded(
                              //   flex: 2,
                              //   child: Container(
                              //     child: BoxDecorationInput(
                              //         mainAxisAlignmentTextIcon:
                              //             MainAxisAlignment.center,
                              //         heigth: 45,
                              //         boxDecBorderRadius:
                              //             BorderRadius.circular(8),
                              //         colorInput: _isCheckFilterColor
                              //             ? AppColors.lightPrimary
                              //             : AppColors.greyShimmer,
                              //         colorBorder: _isCheckFilterColor
                              //             ? AppColors.borderPrimary
                              //             : AppColors.borderBG,
                              //         widgetFaIcon: FaIcon(
                              //           FontAwesomeIcons.barsStaggered,
                              //           size: 15,
                              //           color: _isCheckFilterColor
                              //               ? AppColors.iconPrimary
                              //               : AppColors.iconGray,
                              //         ),
                              //         paddingFaIcon:
                              //             EdgeInsets.symmetric(horizontal: 10),
                              //         // text: "",
                              //         // fontWeight: FontWeight.bold,
                              //         colorText: _isCheckFilterColor
                              //             ? AppColors.fontPrimary
                              //             : AppColors.fontGrey,
                              //         validateText: Container(),
                              //         press: () {}),
                              //   ),
                              // )
                            ],
                          ),
                        ),

                        //
                        //
                        //
                        //
                        //
                        //Count Jobs available
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          child: Row(
                            children: [
                              Text(
                                "${totals} ",
                                style: bodyTextNormal(null,
                                    AppColors.fontPrimary, FontWeight.bold),
                              ),
                              Text(
                                "job_opening".tr,
                                style: bodyTextNormal(null, null, null),
                              ),
                            ],
                          ),
                        ),

                        //
                        //
                        //
                        //
                        //
                        //List Jobs Search
                        Expanded(
                          child: _listJobsSearch.length > 0
                              ? ListView.builder(
                                  controller:
                                      _scrollController, // Use the scroll controller
                                  physics: ClampingScrollPhysics(),
                                  itemCount: _listJobsSearch.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == _listJobsSearch.length) {
                                      return _hasMoreData
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 10),
                                              child: Container(
                                                  // child: Text("Loading"),
                                                  ),
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
                                          //           _isLoadingMoreData = true;
                                          //         }),
                                          //         getJobsSearchSeeker(),
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
                                                child: Text('no have data'.tr),
                                              ),
                                            );
                                    }

                                    var indexJobsSearch =
                                        _listJobsSearch[index];
                                    _title = indexJobsSearch['title'];
                                    _logo = indexJobsSearch['logo'];
                                    _companyName =
                                        indexJobsSearch['companyName'];
                                    _workingLocations =
                                        indexJobsSearch['workingLocations'];
                                    _openDate = indexJobsSearch['openingDate'];
                                    _closeDate = indexJobsSearch['closingDate'];
                                    _isClick =
                                        indexJobsSearch['isClick'].toString();
                                    _tag = indexJobsSearch['tag'];
                                    _disablePeople =
                                        indexJobsSearch['disabledPeople'];
                                    _isSaved = indexJobsSearch['isSaved'];

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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
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
                                              FocusScope.of(context)
                                                  .requestFocus(focusNode);
                                              print(
                                                  "hide dismiss the Slidable");
                                              _removeJobsSearchSeekerLocal(
                                                  indexJobsSearch['jobId']);
                                              hideJob(indexJobsSearch['jobId'],
                                                  indexJobsSearch['title']);
                                            },
                                          ),
                                          children: [
                                            if (!_isSaved)
                                              SlidableAction(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                backgroundColor:
                                                    AppColors.buttonPrimary,
                                                foregroundColor:
                                                    AppColors.fontWhite,
                                                icon: FontAwesomeIcons.heart,
                                                label: 'save'.tr,
                                                onPressed: (context) {
                                                  print(
                                                      "press SlidableAction save");
                                                  setState(() {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            focusNode);
                                                    indexJobsSearch['isSaved'] =
                                                        !indexJobsSearch[
                                                            'isSaved'];
                                                  });
                                                  saveAndUnSaveJob(
                                                      indexJobsSearch['jobId'],
                                                      indexJobsSearch['title']);
                                                  slidableController.close();
                                                },
                                              ),
                                            if (_isSaved)
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
                                                label: 'saved'.tr,
                                                onPressed: (context) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focusNode);
                                                  print(
                                                      "press SlidableAction  unsave");
                                                  setState(() {
                                                    indexJobsSearch['isSaved'] =
                                                        !indexJobsSearch[
                                                            'isSaved'];
                                                  });
                                                  saveAndUnSaveJob(
                                                    indexJobsSearch['jobId'],
                                                    indexJobsSearch['title'],
                                                  );

                                                  slidableController.close();
                                                },
                                              ),
                                            SlidableAction(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                              backgroundColor:
                                                  AppColors.buttonWarning,
                                              foregroundColor:
                                                  AppColors.fontWhite,
                                              icon: FontAwesomeIcons.ban,
                                              label: 'hide'.tr,
                                              onPressed: (constext) async {
                                                FocusScope.of(context)
                                                    .requestFocus(focusNode);
                                                print(
                                                    "press SlidableAction hide job");
                                                var result = await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return NewVer4CustAlertDialogWarning3TxtBtnConfirmCancel(
                                                        title:
                                                            "hide_job_post".tr,
                                                        smallText:
                                                            "hide_job_explain"
                                                                .tr,
                                                        contentText:
                                                            "${indexJobsSearch['title']}",
                                                        textButtonLeft:
                                                            'cancel'.tr,
                                                        textButtonRight:
                                                            'confirm'.tr,
                                                      );
                                                    });
                                                if (result == 'Ok') {
                                                  print("press ok");
                                                  _removeJobsSearchSeekerLocal(
                                                      indexJobsSearch['jobId']);
                                                  hideJob(
                                                      indexJobsSearch['jobId'],
                                                      indexJobsSearch['title']);
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
                                        //Card Job Search
                                        child: Container(
                                          decoration: boxDecoration(
                                              null,
                                              _tag == "Highlight"
                                                  ? AppColors.lightOrange
                                                  : AppColors.backgroundWhite,
                                              _tag == "Highlight"
                                                  ? AppColors.borderWaring
                                                  : null,
                                              3),
                                          child: Column(
                                            children: [
                                              //
                                              //
                                              //
                                              //
                                              //
                                              //Content card jobs search
                                              GestureDetector(
                                                //
                                                //
                                                //press to JobSearchDetail
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .requestFocus(focusNode);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          JobSearchDetailRenew(
                                                        jobId: indexJobsSearch[
                                                            'jobId'],
                                                        newJob: indexJobsSearch[
                                                            'newJob'],
                                                      ),
                                                    ),
                                                  ).then((value) {
                                                    print("${value}");
                                                    //
                                                    //
                                                    //ຖ້າມີ job id and status save/unsave job ຄ່າທີ່ໄດ້ຈາກການ Navigator.pop JobSearchDetail
                                                    if (value[1] != "" &&
                                                        value[2] != null) {
                                                      setState(() {
                                                        dynamic job =
                                                            _listJobsSearch
                                                                .firstWhere((e) =>
                                                                    e['jobId'] ==
                                                                    value[1]);
                                                        // print(
                                                        //     "working save job: " +
                                                        //         job.toString());
                                                        job["isSaved"] =
                                                            value[2];
                                                      });
                                                    }
                                                    //
                                                    //
                                                    //ຖ້າມີ job id and new job ຄ່າທີ່ໄດ້ຈາກການ Navigator.pop JobSearchDetail
                                                    if (value[1] != "" &&
                                                        value[3] != null) {
                                                      setState(() {
                                                        dynamic job =
                                                            _listJobsSearch
                                                                .firstWhere((e) =>
                                                                    e['jobId'] ==
                                                                    value[1]);
                                                        // print(
                                                        //     "working new job: " +
                                                        //         job.toString());
                                                        job["newJob"] =
                                                            value[3];
                                                      });
                                                    }
                                                  });
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
                                                            //Jobs Seach check status
                                                            Column(
                                                              children: [
                                                                //Check status HOT
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
                                                                // Check status disable people
                                                                // if (_disablePeople)
                                                                //   Padding(
                                                                //     padding: const EdgeInsets
                                                                //         .only(
                                                                //         right:
                                                                //             15,
                                                                //         bottom:
                                                                //             15),
                                                                //     child:
                                                                //         Container(
                                                                //       padding:
                                                                //           EdgeInsets.all(
                                                                //               10),
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
                                                                //         color: AppColors
                                                                //             .warning,
                                                                //         borderRadius:
                                                                //             BorderRadius.circular(5),
                                                                //       ),
                                                                //       child:
                                                                //           FaIcon(
                                                                //         FontAwesomeIcons
                                                                //             .wheelchair,
                                                                //         color: AppColors
                                                                //             .iconLight,
                                                                //       ),
                                                                //     ),
                                                                //   ),

                                                                //
                                                                //
                                                                //Status new job/Saved
                                                                if (indexJobsSearch[
                                                                    'newJob'])
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topCenter,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          4,
                                                                    ),
                                                                    margin:
                                                                        EdgeInsets
                                                                            .only(
                                                                      right: 15,
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: AppColors
                                                                          .primary,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    child: Text(
                                                                      // i['newJob'] &&
                                                                      //         !i['isSaved']
                                                                      //     ? "New"
                                                                      //     : !i['newJob'] && i['isSaved']
                                                                      //         ? "Saved"
                                                                      //         : "Viewed",
                                                                      "job_card_new_job"
                                                                          .tr,
                                                                      style:
                                                                          bodyTextMiniSmall(
                                                                        null,
                                                                        AppColors
                                                                            .fontWhite,
                                                                        null,
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      SizedBox(height: 15),

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
                                                                "${_title}",
                                                                style: bodyTextSuperMaxNormal(
                                                                    null,
                                                                    _tag == "Highlight"
                                                                        ? AppColors
                                                                            .fontWaring
                                                                        : null,
                                                                    FontWeight
                                                                        .bold),
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
                                                          // crossAxisAlignment:
                                                          //     CrossAxisAlignment
                                                          //         .start,
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
                                                                "${_workingLocations}",
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
                                                          // crossAxisAlignment:
                                                          //     CrossAxisAlignment
                                                          //         .start,
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
                                              //Section footer card jobs search/ button hide job and save job
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  //
                                                  //
                                                  //button hide job
                                                  Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                focusNode);
                                                        var result =
                                                            await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return NewVer4CustAlertDialogWarning3TxtBtnConfirmCancel(
                                                                    title:
                                                                        "hide_job_post"
                                                                            .tr,
                                                                    smallText:
                                                                        "hide_job_explain"
                                                                            .tr,
                                                                    contentText:
                                                                        "${indexJobsSearch['title']}",
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
                                                              indexJobsSearch[
                                                                  'jobId']);
                                                          hideJob(
                                                              indexJobsSearch[
                                                                  'jobId'],
                                                              indexJobsSearch[
                                                                  'title']);
                                                        }
                                                      },
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(8),
                                                      ),
                                                      child: Container(
                                                        color: AppColors
                                                            .backgroundWhite
                                                            .withOpacity(0.1),
                                                        padding:
                                                            EdgeInsets.all(15),
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
                                                              "hide".tr,
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

                                                  //
                                                  //
                                                  //button save job
                                                  Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                focusNode);
                                                        setState(() {
                                                          indexJobsSearch[
                                                                  'isSaved'] =
                                                              !indexJobsSearch[
                                                                  'isSaved'];
                                                        });
                                                        saveAndUnSaveJob(
                                                            indexJobsSearch[
                                                                'jobId'],
                                                            indexJobsSearch[
                                                                'title']);
                                                      },
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomRight:
                                                            Radius.circular(8),
                                                      ),
                                                      child: Container(
                                                        color: AppColors
                                                            .backgroundWhite
                                                            .withOpacity(0.1),
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        child: Row(
                                                          children: [
                                                            _isSaved
                                                                ? FaIcon(
                                                                    FontAwesomeIcons
                                                                        .solidHeart,
                                                                    size: IconSize
                                                                        .xsIcon,
                                                                    color: AppColors
                                                                        .iconPrimary,
                                                                  )
                                                                : FaIcon(
                                                                    FontAwesomeIcons
                                                                        .heart,
                                                                    size: IconSize
                                                                        .xsIcon,
                                                                  ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              _isSaved
                                                                  ? "saved".tr
                                                                  : "save".tr,
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
                                )
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

  onGoBack(dynamic value) async {
    print("onGoBack");
    await getJobsSearchSeeker();
  }

  _removeJobsSearchSeekerLocal(String jobId) {
    setState(() {
      _listJobsSearch.removeWhere((id) => id['jobId'] == jobId);
    });
  }

  getReuseFilterJobSearchSeeker(
      String lang, List listValue, String resValue) async {
    var res =
        await fetchData(getReuseFilterJobSearchSeekerApi + "lang=${lang}");

    if (widget.selectedListItem != null) {
      checkSelectedListItemFromHomePage();
    }

    setState(() {
      Iterable<dynamic> iterableRes = res[resValue.toString()] ?? [];
      listValue.clear(); // Clear the existing list
      listValue.addAll(iterableRes); // Add elements from the response
    });
  }

  getJobFunctionsSeeker() async {
    var res = await fetchData(getJobFunctionsSeekerApi);
    _listJobFunctions = res['mapper'];
    setState(() {});
  }

  getJobsSearchSeeker() async {
    // if (_isLoadingMoreData || !_hasMoreData) return;
    if (!_hasMoreData) {
      _isLoadingMoreData = false;
      return;
    }

    print("working");

    // setState(() {
    //   _isLoadingMoreData = true;
    // });

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

    // Fetch data from API
    var res = await postData(getJobsSearchSeekerApi, {
      "title": _searchTitle,
      "postDateLastest": _postDateLastest,
      "jobFunctionIds": _selectedJobFunctionsItems,
      "industryIds": _selectedIndustryListItem,
      "workingLocationIds": _selectedProvincesListItem,
      "jobExperienceId": _selectedJobExperienceListItem,
      "jobEducationLevelId": _selectedEducationLeavelListItem,
      "jobLevelId": _selectedJobLevelListItem,
      "page": page,
      "perPage": perPage
    });

    List fetchedData = res['jobList'];
    // _listJobsSearch = res['jobList'];
    totals = res['totals'];

    page++;
    _listJobsSearch.addAll(List<Map<String, dynamic>>.from(fetchedData));
    if (_listJobsSearch.length >= totals || fetchedData.length < perPage) {
      _hasMoreData = false;
    }
    _isLoadingMoreData = false;
    _isLoadingForm = false;

    if (res['jobList'] != null && _statusShowLoading) {
      _statusShowLoading = false;
      Navigator.pop(context);
    }

    if (mounted) {
      setState(() {});
    }
  }

  getJobsSearchByTypingSearchSeeker() async {
    setState(() {
      _hasMoreData = true;
      page = 1;
    });
    if (!_hasMoreData) {
      _isLoadingMoreData = false;
      return;
    }

    //
    //
    //Fetch data from API
    var res = await postData(getJobsSearchSeekerApi, {
      "title": _searchTitle,
      "postDateLastest": _postDateLastest,
      "jobFunctionIds": _selectedJobFunctionsItems,
      "industryIds": _selectedIndustryListItem,
      "workingLocationIds": _selectedProvincesListItem,
      "jobExperienceId": _selectedJobExperienceListItem,
      "jobEducationLevelId": _selectedEducationLeavelListItem,
      "jobLevelId": _selectedJobLevelListItem,
      "page": page,
      "perPage": perPage
    });
    List fetchedData = res['jobList'];
    totals = res['totals'];

    page++;
    _listJobsSearch.clear();
    _listJobsSearch.addAll(List<Map<String, dynamic>>.from(fetchedData));
    if (_listJobsSearch.length >= totals || fetchedData.length < perPage) {
      _hasMoreData = false;
    }
    _isLoadingMoreData = false;
    // _isLoading = false;
    // if (res['jobList'] != null && _statusShowLoading) {
    //   _statusShowLoading = false;
    //   Navigator.pop(context);
    // }

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
        return CustomLoadingLogoCircle();
      },
    );

    var res = await postData(saveJobSeekerApi, {
      "_id": "",
      "JobId": jobId,
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
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            strIcon: "\uf004",
            title: "save job".tr + " " + "successful".tr,
            contentText: "$jobTitle",
            textButton: "ok".tr,
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
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            strIcon: "\uf7a9",
            boxCircleColor: AppColors.warning200,
            iconColor: AppColors.warning600,
            title: "unsave job".tr + " " + "successful".tr,
            contentText: "$jobTitle ",
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

  hideJob(String jobId, String jobTitle) async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
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
      Navigator.pop(context);
    }

    if (res['message'] == "Hide succeed") {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "hide job".tr + " " + "successful".tr,
            contentText: "$jobTitle ",
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }
}
