// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, unused_local_variable, prefer_if_null_operators, avoid_print, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, unnecessary_null_in_if_null_operators, avoid_init_to_null, file_names

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/cupertinoDatePicker.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class WorkHistory extends StatefulWidget {
  const WorkHistory({
    Key? key,
    this.id,
    this.workHistory,
  }) : super(key: key);
  final String? id;
  final dynamic workHistory;

  @override
  State<WorkHistory> createState() => _WorkHistoryState();
}

class _WorkHistoryState extends State<WorkHistory> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _jobTitleController = TextEditingController();
  TextEditingController _responsibilityController = TextEditingController();

  String? _id;
  String _company = "";
  String _jobTitle = "";
  String _responsibility = "";

  dynamic _fromMonthYear = null;
  dynamic _toMonthYear = null;

  bool _isValidateValue = false;
  bool _isCurrentJob = false;

  DateTime _dateTimeNow = DateTime.now();
  //

  setValueGetById() {
    setState(() {
      dynamic i = widget.workHistory;

      DateTime utcNow = _dateTimeNow.toUtc();
      dynamic formattedStartMonthYearUtc =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(utcNow);
      dynamic formattedToMonthYearUtc =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(utcNow);

      _company = i['company'];
      _jobTitle = i['position'];
      _responsibility = i['responsibility'];
      _isCurrentJob = i['isCurrentJob'] as bool;

      _fromMonthYear =
          i['startYear'] == null ? formattedStartMonthYearUtc : i['startYear'];
      //
      //pars ISO to Flutter DateTime
      parsDateTime(value: '', currentFormat: '', desiredFormat: '');
      DateTime fromMonthYear = parsDateTime(
          value: _fromMonthYear,
          currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
          desiredFormat: "yyyy-MM-dd HH:mm:ss");
      //
      //Convert String to DateTime
      _fromMonthYear = DateFormat("yyyy-MM-dd").parse(fromMonthYear.toString());

      _toMonthYear =
          i['endYear'] == null ? formattedToMonthYearUtc : i['endYear'];
      //pars ISO to Flutter DateTime
      parsDateTime(value: '', currentFormat: '', desiredFormat: '');
      DateTime toMonthYear = parsDateTime(
          value: _toMonthYear,
          currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
          desiredFormat: "yyyy-MM-dd HH:mm:ss");
      //
      //Convert String to DateTime
      _toMonthYear = DateFormat("yyyy-MM-dd").parse(toMonthYear.toString());

      _companyController.text = _company;
      _jobTitleController.text = _jobTitle;
      _responsibilityController.text = _responsibility;
    });
  }

  pressCheckBox() {
    setState(() {
      _isCurrentJob = !_isCurrentJob;
      _toMonthYear = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _companyController.text = _company;
    _jobTitleController.text = _jobTitle;
    _responsibilityController.text = _responsibility;

    _id = widget.id ?? "";
    if (_id != null && _id != "") {
      print("id != null");
      print("${_id}");

      setValueGetById();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Color getColor(Set<MaterialState> states) {
    //   const Set<MaterialState> interactiveStates = <MaterialState>{
    //     MaterialState.pressed,
    //     MaterialState.hovered,
    //     MaterialState.focused,
    //   };
    //   return !_isCurrentJob ? AppColors.white : AppColors.primary;
    // }

    FocusScopeNode currentFocus = FocusScopeNode();

    return GestureDetector(
      onTap: () {
        currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MediaQuery(
        data:
            MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
        child: Scaffold(
          appBar: AppBarDefault(
            textTitle: "work history".tr,
            // fontWeight: FontWeight.bold,
            leadingIcon: Icon(Icons.arrow_back),
            leadingPress: () {
              Navigator.pop(context);
            },
          ),
          body: SafeArea(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: AppColors.backgroundWhite,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    Expanded(
                      flex: 15,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text("${_language}"),
                            // Text("${_proficiencyLanguage}"),
                            SizedBox(
                              height: 30,
                            ),

                            //
                            //
                            //Company
                            Text(
                              "company".tr,
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SimpleTextFieldWithIconRight(
                              textController: _companyController,
                              changed: (value) {
                                setState(() {
                                  _company = value;
                                });
                              },
                              inputColor: AppColors.inputWhite,
                              hintText: "enter".tr + " " + "company name".tr,
                              hintTextFontWeight: FontWeight.bold,
                              suffixIcon: Icon(
                                Icons.business,
                              ),
                              suffixIconColor: AppColors.iconGrayOpacity,
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //Job Title
                            Text(
                              "job title".tr,
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SimpleTextFieldWithIconRight(
                              textController: _jobTitleController,
                              changed: (value) {
                                setState(() {
                                  _jobTitle = value;
                                });
                              },
                              inputColor: AppColors.inputWhite,
                              hintText: "enter".tr + " " + "job title".tr,
                              hintTextFontWeight: FontWeight.bold,
                              suffixIcon: Icon(
                                Icons.work,
                              ),
                              suffixIconColor: AppColors.iconGrayOpacity,
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Checkbox(
                                //   checkColor: Colors.white,
                                //   fillColor: MaterialStateProperty.resolveWith(
                                //       getColor),
                                //   value: _isCurrentJob,
                                //   onChanged: (bool? value) {
                                //     if (mounted) {
                                //       setState(() {
                                //         _isCurrentJob = value!;

                                //         print(_isCurrentJob);
                                //       });
                                //     }
                                //   },
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    pressCheckBox();
                                  },
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: _isCurrentJob
                                          ? AppColors.iconPrimary
                                          : AppColors.iconLight,
                                      border: Border.all(
                                          color: AppColors.borderDark),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: _isCurrentJob
                                        ? Align(
                                            alignment: Alignment.center,
                                            child: FaIcon(
                                              FontAwesomeIcons.check,
                                              size: 15,
                                              color: AppColors.iconLight,
                                            ),
                                          )
                                        : Container(),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("my current job".tr),
                              ],
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //From DateTime(Month)
                            Text(
                              "from".tr + " " + "month".tr + "/" + "year".tr,
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxDecorationInput(
                              mainAxisAlignmentTextIcon:
                                  MainAxisAlignment.start,
                              colorInput: AppColors.backgroundWhite,
                              colorBorder: _isValidateValue == true &&
                                      _fromMonthYear == null
                                  ? AppColors.borderDanger
                                  : AppColors.borderSecondary,
                              paddingFaIcon:
                                  EdgeInsets.symmetric(horizontal: 1.7.w),
                              fontWeight: _fromMonthYear == null
                                  ? FontWeight.bold
                                  : null,
                              widgetIconActive: FaIcon(
                                FontAwesomeIcons.calendar,
                                color: AppColors.iconGrayOpacity,
                                size: IconSize.sIcon,
                              ),
                              press: () {
                                //
                                // format date.now() ຈາກ 2022-10-30 19:44:31.180 ເປັນ 2022-10-30 00:00:00.000
                                var formatDateTimeNow = DateFormat("yyyy-MM-dd")
                                    .parse(_dateTimeNow.toString());
                                setState(() {
                                  _fromMonthYear == null
                                      ? _fromMonthYear = formatDateTimeNow
                                      : _fromMonthYear;
                                });

                                showDialogDateTime(
                                    context,
                                    Text(
                                      "from".tr +
                                          " " +
                                          "month".tr +
                                          "/" +
                                          "year".tr,
                                      style:
                                          bodyTextMedium(null, FontWeight.bold),
                                    ),
                                    CupertinoDatePicker(
                                      initialDateTime: _fromMonthYear == null
                                          ? formatDateTimeNow
                                          : _fromMonthYear,
                                      mode: CupertinoDatePickerMode.monthYear,
                                      // dateOrder: DatePickerDateOrder.dmy,
                                      maximumDate: formatDateTimeNow,
                                      use24hFormat: true,
                                      onDateTimeChanged: (DateTime newDate) {
                                        setState(() {
                                          _fromMonthYear = newDate;

                                          if (_toMonthYear != null &&
                                              _toMonthYear
                                                  .isBefore(_fromMonthYear)) {
                                            // If toDate is before fromDate, set toDate to null
                                            _toMonthYear = null;
                                          }
                                        });
                                      },
                                    )
                                    // SimpleButton(
                                    //   text: 'Cancel',
                                    //   colorButton: AppColors.buttonSecondary,
                                    //   colorText: AppColors.fontWhite,
                                    //   press: () {
                                    //     Navigator.of(context).pop();
                                    //   },
                                    // ),
                                    // SimpleButton(
                                    //   text: 'Confirm',
                                    //   press: () {
                                    //     Navigator.of(context).pop();
                                    //   },
                                    // ),
                                    );
                              },
                              text: _fromMonthYear == null
                                  ? "from".tr +
                                      " " +
                                      "month".tr +
                                      "/" +
                                      "year".tr
                                  : "${_fromMonthYear?.month}-${_fromMonthYear?.year}",
                              colorText: _fromMonthYear == null
                                  ? AppColors.fontGreyOpacity
                                  : AppColors.fontDark,
                              validateText: _isValidateValue == true &&
                                      _fromMonthYear == null
                                  ? Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        top: 5,
                                      ),
                                      child: Text(
                                        "required".tr,
                                        style: bodyTextSmall(
                                          AppColors.fontDanger,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //To DateTime(Month)
                            if (!_isCurrentJob)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "to".tr +
                                        " " +
                                        "month".tr +
                                        "/" +
                                        "year".tr,
                                    style:
                                        bodyTextNormal(null, FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  _fromMonthYear != null
                                      ? BoxDecorationInput(
                                          mainAxisAlignmentTextIcon:
                                              MainAxisAlignment.start,
                                          colorInput: AppColors.backgroundWhite,
                                          colorBorder:
                                              _isValidateValue == true &&
                                                      _toMonthYear == null
                                                  ? AppColors.borderDanger
                                                  : AppColors.borderSecondary,
                                          paddingFaIcon: EdgeInsets.symmetric(
                                              horizontal: 1.7.w),
                                          fontWeight: _toMonthYear == null
                                              ? FontWeight.bold
                                              : null,
                                          widgetIconActive: FaIcon(
                                            FontAwesomeIcons.calendar,
                                            color: AppColors.iconGrayOpacity,
                                            size: IconSize.sIcon,
                                          ),
                                          press: () {
                                            setState(() {
                                              _toMonthYear == null
                                                  ? _toMonthYear =
                                                      _fromMonthYear
                                                  : _toMonthYear;
                                            });

                                            showDialogDateTime(
                                                context,
                                                Text(
                                                  "to".tr +
                                                      " " +
                                                      "month".tr +
                                                      "/" +
                                                      "year".tr,
                                                  style: bodyTextMedium(
                                                      null, FontWeight.bold),
                                                ),
                                                CupertinoDatePicker(
                                                  initialDateTime:
                                                      _toMonthYear == null
                                                          ? _fromMonthYear
                                                          : _toMonthYear,
                                                  mode: CupertinoDatePickerMode
                                                      .monthYear,
                                                  // dateOrder: DatePickerDateOrder.dmy,
                                                  minimumDate: _fromMonthYear,
                                                  use24hFormat: true,
                                                  onDateTimeChanged:
                                                      (DateTime newDate) {
                                                    setState(() {
                                                      _toMonthYear = newDate;
                                                    });
                                                  },
                                                )
                                                // SimpleButton(
                                                //   text: 'Cancel',
                                                //   colorButton: AppColors.buttonSecondary,
                                                //   colorText: AppColors.fontWhite,
                                                //   press: () {
                                                //     Navigator.of(context).pop();
                                                //   },
                                                // ),
                                                // SimpleButton(
                                                //   text: 'Confirm',
                                                //   press: () {
                                                //     Navigator.of(context).pop();
                                                //   },
                                                // ),
                                                );
                                          },
                                          text: _toMonthYear == null
                                              ? "to".tr +
                                                  " " +
                                                  "month".tr +
                                                  "/" +
                                                  "year".tr
                                              : "${_toMonthYear?.month}-${_toMonthYear?.year}",
                                          colorText: _toMonthYear == null
                                              ? AppColors.fontGreyOpacity
                                              : AppColors.fontDark,
                                          validateText:
                                              _isValidateValue == true &&
                                                      _toMonthYear == null
                                                  ? Container(
                                                      width: double.infinity,
                                                      padding: EdgeInsets.only(
                                                        left: 10,
                                                        top: 5,
                                                      ),
                                                      child: Text(
                                                        "required".tr,
                                                        style: bodyTextSmall(
                                                          AppColors.fontDanger,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                        )
                                      : BoxDecorationInput(
                                          mainAxisAlignmentTextIcon:
                                              MainAxisAlignment.start,
                                          colorBorder:
                                              _isValidateValue == true &&
                                                      _toMonthYear == null
                                                  ? AppColors.borderDanger
                                                  : AppColors.borderSecondary,
                                          paddingFaIcon: EdgeInsets.symmetric(
                                              horizontal: 1.7.w),
                                          fontWeight: FontWeight.bold,
                                          colorText: AppColors.fontGreyOpacity,
                                          widgetIconActive: FaIcon(
                                            FontAwesomeIcons.calendar,
                                            color: AppColors.iconGrayOpacity,
                                            size: IconSize.sIcon,
                                          ),
                                          text: "to".tr +
                                              " " +
                                              "month".tr +
                                              "/" +
                                              "year".tr,
                                          validateText:
                                              _isValidateValue == true &&
                                                      _toMonthYear == null
                                                  ? Container(
                                                      width: double.infinity,
                                                      padding: EdgeInsets.only(
                                                        left: 10,
                                                        top: 5,
                                                      ),
                                                      child: Text(
                                                        "required".tr,
                                                        style: bodyTextSmall(
                                                          AppColors.fontDanger,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                        ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),

                            // Responsibility
                            Text(
                              "responsibility".tr,
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SimpleTextFieldSingleValidate(
                              heightCon: 150,
                              maxLines: 20,
                              inputColor: AppColors.backgroundWhite,
                              codeController: _responsibilityController,
                              changed: (value) {
                                setState(() {
                                  _responsibility = value;
                                });
                              },
                              hintText: "",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "required".tr;
                                }
                                return null;
                              },
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
                    Button(
                      text: "save".tr,
                      fontWeight: FontWeight.bold,
                      press: () {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            _isValidateValue = false;
                            addWorkHistorySeeker();
                          });
                        } else {
                          setState(() {
                            _isValidateValue = true;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  addWorkHistorySeeker() async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertLoading();
      },
    );

    var res = await postData(addWorkHistorySeekerApi, {
      "_id": _id,
      "company": _company,
      "startYear":
          _fromMonthYear != null ? _fromMonthYear.toString() : _fromMonthYear,
      "endYear": _toMonthYear != null ? _toMonthYear.toString() : _toMonthYear,
      "position": _jobTitle,
      "responsibility": _responsibility,
      "isCurrentJob": _isCurrentJob
    });
    print(res);

    if (res['workHistory'] != null) {
      Navigator.pop(context);
    }

    if (res['workHistory'] != null) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomAlertDialogSuccess(
            title: "successful".tr,
            text: "save".tr + "work history".tr + "successful".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }
}
