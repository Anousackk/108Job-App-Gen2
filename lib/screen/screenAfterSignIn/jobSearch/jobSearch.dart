// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_final_fields, unused_field, unused_local_variable, avoid_print, unnecessary_brace_in_string_interps, unnecessary_string_interpolations

import 'dart:async';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearchDetail.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:app/widget/listMultiSelectedAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class JobSearch extends StatefulWidget {
  const JobSearch({Key? key}) : super(key: key);

  @override
  State<JobSearch> createState() => _JobSearchState();
}

class _JobSearchState extends State<JobSearch>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchTitleController = TextEditingController();

  //
  //Get list items all
  List _listProvinces = [];
  List _listLanguages = [];
  List _listIndustries = [];
  List _listJobsSearch = [];

  //
  //Selected list item(ສະເພາະເຂົ້າ Database)
  List _selectedProvincesListItem = [];
  List _selectedLanguageListItem = [];
  List _selectedIndustryListItem = [];

  //
  //value display(ສະເພາະສະແດງ)
  List _provinceName = [];
  List _languageName = [];
  List _industryName = [];

  String _logo = "";
  String _title = "";
  String _companyName = "";
  String _workingLocations = "";
  String _isClick = "";
  String _total = "";
  dynamic _openDate;
  dynamic _closeDate;

  String _searchTitle = "";
  Timer? _timer;
  bool _statusShowLoading = false;

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
    getJobsSearchSeeker();
    getReuseTypeSeeker('EN', 'Province', _listProvinces);
    getReuseTypeSeeker('EN', 'Language', _listLanguages);
    getReuseTypeSeeker('EN', 'Industry', _listIndustries);

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
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: AppColors.white,
          ),
          body: SafeArea(
            child: Container(
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
                          changed: (value) {
                            setState(() {
                              _searchTitle = value;
                            });

                            // Cancel previous timer if it exists
                            _timer?.cancel();

                            // Start a new timer
                            _timer = Timer(Duration(seconds: 2), () {
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
                            boxDecBorderRadius: BorderRadius.circular(10),
                            colorInput: AppColors.inputGrey,
                            widgetFaIcon: FaIcon(
                              FontAwesomeIcons.barsStaggered,
                              size: 20,
                              color: AppColors.iconGray,
                            ),
                            paddingFaIcon: EdgeInsets.symmetric(horizontal: 10),
                            mainAxisAlignmentTextIcon: MainAxisAlignment.center,
                            text: "Filter",
                            colorText: AppColors.fontGrey,
                            validateText: Container(),
                            press: () async {
                              //
                              //
                              //Alert Dialog Filter
                              var result = await showDialog(
                                context: context,
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
                                            color: AppColors.backgroundWhite,
                                            border: Border(
                                              bottom: BorderSide(
                                                color:
                                                    AppColors.borderSecondary,
                                              ),
                                            )),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: FaIcon(
                                                FontAwesomeIcons.arrowLeft,
                                                size: 20,
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15),
                                                  child: Text(
                                                    "Filter",
                                                    style: bodyTextMedium(
                                                        null, FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
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
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //
                                              //
                                              //Sort By
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    child: Text(
                                                      "Sort By",
                                                      style: bodyTextNormal(
                                                          null,
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      //
                                                      //Post Date Lastest
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 10),
                                                        decoration:
                                                            boxDecoration(
                                                          null,
                                                          AppColors.light,
                                                          AppColors.light,
                                                        ),
                                                        child: Text(
                                                          "Post Date (Lastest)",
                                                          style: bodyTextNormal(
                                                              null,
                                                              FontWeight.bold),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      //
                                                      //Post date Oldest
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 10),
                                                        decoration:
                                                            boxDecoration(
                                                          null,
                                                          AppColors.light,
                                                          AppColors.light,
                                                        ),
                                                        child: Text(
                                                          "Post Date (Oldest)",
                                                          style: bodyTextNormal(
                                                              null,
                                                              FontWeight.bold),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 5),

                                              //
                                              //
                                              //Education Level
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    child: Text(
                                                      "Education Level",
                                                      style: bodyTextNormal(
                                                          null,
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      //
                                                      //High School
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 10),
                                                        decoration:
                                                            boxDecoration(
                                                          null,
                                                          AppColors.light,
                                                          AppColors.light,
                                                        ),
                                                        child: Text(
                                                          "High School",
                                                          style: bodyTextNormal(
                                                              null,
                                                              FontWeight.bold),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),

                                                      //
                                                      //Higher Diploma
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 10),
                                                        decoration:
                                                            boxDecoration(
                                                          null,
                                                          AppColors.light,
                                                          AppColors.light,
                                                        ),
                                                        child: Text(
                                                          "Higher Diploma",
                                                          style: bodyTextNormal(
                                                              null,
                                                              FontWeight.bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      //
                                                      //Bachelor Degree
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 10),
                                                        decoration:
                                                            boxDecoration(
                                                          null,
                                                          AppColors.light,
                                                          AppColors.light,
                                                        ),
                                                        child: Text(
                                                          "Bachelor Degree",
                                                          style: bodyTextNormal(
                                                              null,
                                                              FontWeight.bold),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),

                                                      //
                                                      //Master Degree
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 10),
                                                        decoration:
                                                            boxDecoration(
                                                          null,
                                                          AppColors.light,
                                                          AppColors.light,
                                                        ),
                                                        child: Text(
                                                          "Master Degree",
                                                          style: bodyTextNormal(
                                                              null,
                                                              FontWeight.bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      //
                                                      //Not Specific
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 10),
                                                        decoration:
                                                            boxDecoration(
                                                          null,
                                                          AppColors.light,
                                                          AppColors.light,
                                                        ),
                                                        child: Text(
                                                          "Not Specific",
                                                          style: bodyTextNormal(
                                                              null,
                                                              FontWeight.bold),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 5),

                                              //
                                              //
                                              //Job Function
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: Text(
                                                  "Job Function",
                                                  style: bodyTextNormal(
                                                      null, FontWeight.bold),
                                                ),
                                              ),
                                              BoxDecorationInput(
                                                colorInput:
                                                    AppColors.backgroundWhite,
                                                colorBorder:
                                                    AppColors.borderSecondary,
                                                text: "Select Job Function",
                                                widgetIconActive: FaIcon(
                                                  FontAwesomeIcons.caretDown,
                                                  size: 20,
                                                  color:
                                                      AppColors.iconSecondary,
                                                ),
                                                paddingFaIcon:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                mainAxisAlignmentTextIcon:
                                                    MainAxisAlignment.start,
                                                press: () {},
                                                validateText: Container(),
                                              ),
                                              SizedBox(height: 5),

                                              //
                                              //
                                              //Work Location
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: Text(
                                                  "Work Province",
                                                  style: bodyTextNormal(
                                                      null, FontWeight.bold),
                                                ),
                                              ),
                                              BoxDecorationInput(
                                                mainAxisAlignmentTextIcon:
                                                    MainAxisAlignment.start,
                                                colorInput:
                                                    AppColors.backgroundWhite,
                                                colorBorder:
                                                    AppColors.borderSecondary,
                                                paddingFaIcon:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                widgetIconActive: FaIcon(
                                                    FontAwesomeIcons.caretDown,
                                                    size: IconSize.sIcon,
                                                    color: AppColors
                                                        .iconSecondary),
                                                press: () async {
                                                  var result = await showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
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
                                                        if (value.length > 0) {
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
                                                          print(_provinceName);
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
                                              //Language
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: Text(
                                                  "Language",
                                                  style: bodyTextNormal(
                                                      null, FontWeight.bold),
                                                ),
                                              ),
                                              BoxDecorationInput(
                                                mainAxisAlignmentTextIcon:
                                                    MainAxisAlignment.start,
                                                colorInput:
                                                    AppColors.backgroundWhite,
                                                colorBorder:
                                                    AppColors.borderSecondary,
                                                paddingFaIcon:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                widgetIconActive: FaIcon(
                                                    FontAwesomeIcons.caretDown,
                                                    size: IconSize.sIcon,
                                                    color: AppColors
                                                        .iconSecondary),
                                                press: () async {
                                                  var result = await showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return ListMultiSelectedAlertDialog(
                                                          title: "Language",
                                                          listItems:
                                                              _listLanguages,
                                                          selectedListItem:
                                                              _selectedLanguageListItem,
                                                        );
                                                      }).then(
                                                    (value) {
                                                      setState(() {
                                                        //value = []
                                                        //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                                        if (value.length > 0) {
                                                          _selectedLanguageListItem =
                                                              value;
                                                          _languageName =
                                                              []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                                          for (var item
                                                              in _listLanguages) {
                                                            //
                                                            //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedLanguageListItem ກົງກັບ _listLanguages ບໍ່
                                                            if (_selectedLanguageListItem
                                                                .contains(item[
                                                                    '_id'])) {
                                                              //
                                                              //add Language Name ເຂົ້າໃນ _languageName
                                                              setState(() {
                                                                _languageName
                                                                    .add(item[
                                                                        'name']);
                                                              });
                                                            }
                                                          }
                                                          print(_languageName);
                                                        }
                                                      });
                                                    },
                                                  );
                                                },
                                                text: _selectedLanguageListItem
                                                        .isEmpty
                                                    ? "Select Language"
                                                    : "${_languageName.join(', ')}",
                                                validateText: Container(),
                                              ),
                                              SizedBox(height: 5),

                                              //
                                              //
                                              //Industry
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: Text(
                                                  "Industry",
                                                  style: bodyTextNormal(
                                                      null, FontWeight.bold),
                                                ),
                                              ),
                                              BoxDecorationInput(
                                                mainAxisAlignmentTextIcon:
                                                    MainAxisAlignment.start,
                                                colorInput:
                                                    AppColors.backgroundWhite,
                                                colorBorder:
                                                    AppColors.borderSecondary,
                                                paddingFaIcon:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                widgetIconActive: FaIcon(
                                                    FontAwesomeIcons.caretDown,
                                                    size: 20,
                                                    color: AppColors
                                                        .iconSecondary),
                                                press: () async {
                                                  var result = await showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return ListMultiSelectedAlertDialog(
                                                          title: "Industry",
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
                                                        if (value.length > 0) {
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
                                                          print(_industryName);
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
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 20),
                                          color: AppColors.backgroundWhite,
                                          child: Button(
                                            text: "Apply",
                                            press: () {
                                              Navigator.pop(context);
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
                          style: bodyTextNormal(null, FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  //
                  //
                  //List Jobs Search
                  Expanded(
                    child: ListView.builder(
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
                            value: '', currentFormat: '', desiredFormat: '');
                        DateTime openDate = parsDateTime(
                            value: _openDate,
                            currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                            desiredFormat: "yyyy-MM-dd HH:mm:ss");
                        //
                        //Format to string 13 Feb 2024
                        _openDate = DateFormat('dd MMM yyyy').format(openDate);

                        //
                        //Close Date
                        //pars ISO to Flutter DateTime
                        parsDateTime(
                            value: '', currentFormat: '', desiredFormat: '');
                        DateTime closeDate = parsDateTime(
                            value: _closeDate,
                            currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                            desiredFormat: "yyyy-MM-dd HH:mm:ss");
                        //
                        //Format to string 13 Feb 2024
                        _closeDate =
                            DateFormat("dd MMM yyyy").format(closeDate);

                        return Slidable(
                          //
                          //Specify a key if the Slidable  is dismissible.
                          key: ValueKey(0),
                          //
                          //The end action pane is the one at the right or the bottom side.
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            //
                            //A pane can dismiss the Slidable.
                            dismissible: DismissiblePane(onDismissed: () {
                              print("hide dismiss the Slidable");
                            }),
                            children: [
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    slidableAction("Click Save");
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    color: AppColors.buttonPrimary,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FaIcon(FontAwesomeIcons.floppyDisk,
                                            color: AppColors.iconLight),
                                        SizedBox(height: 5),
                                        Text("Save",
                                            style: bodyTextNormal(
                                                AppColors.fontWhite, null))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    slidableAction("Click Hide");
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    color: AppColors.buttonDanger,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FaIcon(FontAwesomeIcons.ban,
                                            color: AppColors.iconLight),
                                        SizedBox(height: 5),
                                        Text("Hide",
                                            style: bodyTextNormal(
                                                AppColors.fontWhite, null)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // SlidableAction(
                              //   onPressed: slidableAction("Click Save"),
                              //   backgroundColor: AppColors.buttonPrimary,
                              //   foregroundColor: AppColors.fontWhite,
                              //   icon: Icons.save,
                              //   label: 'Save',
                              // ),
                              // SlidableAction(
                              //   onPressed: slidableAction("Click Delete"),
                              //   backgroundColor: AppColors.buttonDanger,
                              //   foregroundColor: AppColors.fontWhite,
                              //   icon: Icons.delete,
                              //   label: 'Delete',
                              // ),
                            ],
                          ),

                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobSearchDetail(),
                                ),
                              );
                            },
                            child: Container(
                              height: 250,
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.only(bottom: 15),
                              decoration: boxDecoration(
                                null,
                                AppColors.backgroundWhite,
                                null,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //
                                  //
                                  //Logo Company and Status
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //
                                        //Logo Company
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 75,
                                                height: 75,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: AppColors
                                                        .borderSecondary,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: _logo == ""
                                                      ? AppColors.greyWhite
                                                      : AppColors
                                                          .backgroundWhite,
                                                ),
                                                child: _logo == ""
                                                    ? Container()
                                                    : Image.network(
                                                        "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${_logo}",
                                                        width: 75,
                                                        height: 75,
                                                        fit: BoxFit.contain,
                                                      ),
                                              ),
                                              SizedBox(width: 25),
                                              Column(
                                                children: [
                                                  Text(
                                                      "${getTimeAgo(_dateTimeNow, openDate)}"),
                                                  Text("${_isClick} Views"),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),

                                        //
                                        //Jobs Status
                                        Container(
                                          alignment: Alignment.topCenter,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            "New",
                                            style: bodyTextSmall(
                                                AppColors.fontWhite),
                                          ),
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
                                    "${_title}",
                                    style:
                                        bodyTextMedium(null, FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
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
                                        color: AppColors.iconGrayOpacity,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${_companyName}",
                                        style: bodyTextSmall(null),
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
                                        FontAwesomeIcons.locationDot,
                                        size: 15,
                                        color: AppColors.iconGrayOpacity,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${_workingLocations}",
                                          style: bodyTextSmall(null),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
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
                                        FontAwesomeIcons.calendarWeek,
                                        size: 15,
                                        color: AppColors.iconGrayOpacity,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${_openDate}',
                                        style: bodyTextSmall(null),
                                      ),
                                      Text(' - '),
                                      Text(
                                        "${_closeDate}",
                                        style: bodyTextSmall(null),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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

  getReuseTypeSeeker(String lang, String type, List listValue) async {
    var res =
        await fetchData(getReuseTypeApiSeeker + "lang=${lang}&type=${type}");
    setState(() {
      listValue.clear(); // Clear the existing list
      listValue.addAll(res['seekerReuse']); // Add elements from the response
    });
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

    var res = await postData(getJobsSearchSeekerApi, {
      "title": _searchTitle,
      "postDateLastest": "",
      "postDateOldest": "",
      "jobFunctionIds": [],
      "industryIds": [],
      "workingLocationIds": [],
      "jobExperienceId": [],
      "jobEducationLevelId": [],
      "jobLevelId": [],
      "page": 1,
      "perPage": 1000
    });
    _listJobsSearch = res['jobList'];
    _total = res['totals'].toString();
    if (res['jobList'] != null && _statusShowLoading) {
      Navigator.pop(context);
    }
    setState(() {});
  }
}
