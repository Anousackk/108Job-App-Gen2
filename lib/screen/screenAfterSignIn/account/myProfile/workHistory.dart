// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, unused_local_variable, prefer_if_null_operators, avoid_print, unnecessary_brace_in_string_interps, unnecessary_string_interpolations

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

  dynamic _fromMonth;
  dynamic _toMonth;
  bool _isValidateValue = false;
  bool _isCurrentJob = false;

  DateTime _dateTimeNow = DateTime.now();

  setValueGetById() {
    setState(() {
      dynamic i = widget.workHistory;
      _company = i['company'];
      _jobTitle = i['position'];
      _responsibility = i['responsibility'];
      _isCurrentJob = i['isCurrentJob'] as bool;

      _fromMonth = i['startYear'];
      //
      //pars ISO to Flutter DateTime
      parsDateTime(value: '', currentFormat: '', desiredFormat: '');
      DateTime fromMonth = parsDateTime(
          value: _fromMonth,
          currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
          desiredFormat: "yyyy-MM-dd HH:mm:ss");
      //
      //Convert String to DateTime
      _fromMonth = DateFormat("yyyy-MM-dd").parse(fromMonth.toString());

      _toMonth = i['endYear'];
      //pars ISO to Flutter DateTime
      parsDateTime(value: '', currentFormat: '', desiredFormat: '');
      DateTime toMonth = parsDateTime(
          value: _toMonth,
          currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
          desiredFormat: "yyyy-MM-dd HH:mm:ss");
      //
      //Convert String to DateTime
      _toMonth = DateFormat("yyyy-MM-dd").parse(toMonth.toString());

      _companyController.text = _company;
      _jobTitleController.text = _jobTitle;
      _responsibilityController.text = _responsibility;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
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
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      return !_isCurrentJob ? AppColors.white : AppColors.primary;
    }

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
            textTitle: "Work History",
            fontWeight: FontWeight.bold,
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
                              "Company",
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
                              hintText: "Enter company name",
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
                              "Job Title",
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
                              hintText: "Enter job title",
                              hintTextFontWeight: FontWeight.bold,
                              suffixIcon: Icon(
                                Icons.work,
                              ),
                              suffixIconColor: AppColors.iconGrayOpacity,
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //From DateTime(Month)
                            Text(
                              "From Month",
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxDecorationInput(
                              mainAxisAlignmentTextIcon:
                                  MainAxisAlignment.start,
                              colorInput: AppColors.backgroundWhite,
                              colorBorder:
                                  _isValidateValue == true && _fromMonth == null
                                      ? AppColors.borderDanger
                                      : AppColors.borderSecondary,
                              paddingFaIcon:
                                  EdgeInsets.symmetric(horizontal: 1.7.w),
                              fontWeight:
                                  _fromMonth == null ? FontWeight.bold : null,
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
                                  _fromMonth == null
                                      ? _fromMonth = formatDateTimeNow
                                      : _fromMonth;
                                });

                                showDialogDateTime(
                                    context,
                                    Text(
                                      "From Month",
                                      style:
                                          bodyTextNormal(null, FontWeight.bold),
                                    ),
                                    CupertinoDatePicker(
                                      initialDateTime: _fromMonth == null
                                          ? formatDateTimeNow
                                          : _fromMonth,
                                      mode: CupertinoDatePickerMode.monthYear,
                                      // dateOrder: DatePickerDateOrder.dmy,
                                      use24hFormat: true,
                                      onDateTimeChanged: (DateTime newDate) {
                                        setState(() {
                                          _fromMonth = newDate;

                                          if (_toMonth != null &&
                                              _toMonth.isBefore(_fromMonth)) {
                                            // If toDate is before fromDate, set toDate to null
                                            _toMonth = null;
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
                              text: _fromMonth == null
                                  ? 'From month'
                                  : "${_fromMonth?.month}-${_fromMonth?.year}",
                              colorText: _fromMonth == null
                                  ? AppColors.fontGreyOpacity
                                  : AppColors.fontDark,
                              validateText:
                                  _isValidateValue == true && _fromMonth == null
                                      ? Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                            left: 15,
                                            top: 5,
                                          ),
                                          child: Text(
                                            "required",
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
                            Text(
                              "To month",
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            _fromMonth != null
                                ? BoxDecorationInput(
                                    mainAxisAlignmentTextIcon:
                                        MainAxisAlignment.start,
                                    colorInput: AppColors.backgroundWhite,
                                    colorBorder: _isValidateValue == true &&
                                            _toMonth == null
                                        ? AppColors.borderDanger
                                        : AppColors.borderSecondary,
                                    paddingFaIcon:
                                        EdgeInsets.symmetric(horizontal: 1.7.w),
                                    fontWeight: _toMonth == null
                                        ? FontWeight.bold
                                        : null,
                                    widgetIconActive: FaIcon(
                                      FontAwesomeIcons.calendar,
                                      color: AppColors.iconGrayOpacity,
                                      size: IconSize.sIcon,
                                    ),
                                    press: () {
                                      setState(() {
                                        _toMonth == null
                                            ? _toMonth = _fromMonth
                                            : _toMonth;
                                      });

                                      showDialogDateTime(
                                          context,
                                          Text(
                                            "To Month",
                                            style: bodyTextNormal(
                                                null, FontWeight.bold),
                                          ),
                                          CupertinoDatePicker(
                                            initialDateTime: _toMonth == null
                                                ? _fromMonth
                                                : _toMonth,
                                            mode: CupertinoDatePickerMode
                                                .monthYear,
                                            // dateOrder: DatePickerDateOrder.dmy,
                                            minimumDate: _fromMonth,
                                            use24hFormat: true,
                                            onDateTimeChanged:
                                                (DateTime newDate) {
                                              setState(() {
                                                _toMonth = newDate;
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
                                    text: _toMonth == null
                                        ? 'To Month'
                                        : "${_toMonth?.month}-${_toMonth?.year}",
                                    colorText: _toMonth == null
                                        ? AppColors.fontGreyOpacity
                                        : AppColors.fontDark,
                                    validateText: _isValidateValue == true &&
                                            _toMonth == null
                                        ? Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.only(
                                              left: 10,
                                              top: 5,
                                            ),
                                            child: Text(
                                              "required",
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
                                    colorBorder: _isValidateValue == true &&
                                            _toMonth == null
                                        ? AppColors.borderDanger
                                        : AppColors.borderSecondary,
                                    paddingFaIcon:
                                        EdgeInsets.symmetric(horizontal: 1.7.w),
                                    fontWeight: FontWeight.bold,
                                    colorText: AppColors.fontGreyOpacity,
                                    widgetIconActive: FaIcon(
                                      FontAwesomeIcons.calendar,
                                      color: AppColors.iconGrayOpacity,
                                      size: IconSize.sIcon,
                                    ),
                                    text: "To Month",
                                    validateText: _isValidateValue == true &&
                                            _toMonth == null
                                        ? Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.only(
                                              left: 10,
                                              top: 5,
                                            ),
                                            child: Text(
                                              "required",
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

                            // Responsibility
                            Text(
                              "Responsibility",
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
                                  return "required";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.resolveWith(
                                      getColor),
                                  value: _isCurrentJob,
                                  onChanged: (bool? value) {
                                    if (mounted) {
                                      setState(() {
                                        _isCurrentJob = value!;

                                        print(_isCurrentJob);
                                      });
                                    }
                                  },
                                ),
                                Text("This is my current job"),
                              ],
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
                      text: "Save",
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
      "startYear": _fromMonth.toString(),
      "endYear": _toMonth.toString(),
      "position": _jobTitle,
      "responsibility": _responsibility.toString(),
      "isCurrentJob": _isCurrentJob
    });
    if (res['workHistory'] != null) {
      Navigator.pop(context);
    }

    if (res['workHistory'] != null) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomAlertDialogSuccess(
            title: "Success",
            text: "Save Work History Success",
            textButton: "OK",
            press: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        },
      );
    }
    print(res);
  }
}
