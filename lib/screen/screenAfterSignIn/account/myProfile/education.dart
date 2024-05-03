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
import 'package:app/widget/listSingleSelectedAlertDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class Education extends StatefulWidget {
  const Education({Key? key, this.id, this.education}) : super(key: key);
  final String? id;
  final dynamic education;

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _collageController = TextEditingController();

  //
  //Get list items all
  List _listDegrees = [];

  //
  //Selected list item(ສະເພາະເຂົ້າ Database)
  String? _id;
  String _subject = "";
  String _collage = "";
  String _selectedDegree = "";
  dynamic _fromYear;
  dynamic _toYear;
  bool _isValidateValue = false;

  //
  //value display(ສະເພາະສະແດງ)
  String _degreeName = "";

  DateTime _dateTimeNow = DateTime.now();

  setValueGetById() {
    setState(() {
      dynamic i = widget.education;

      _subject = i['subject'];
      _collage = i['school'];
      _selectedDegree = i['qualifications']['_id'];
      _degreeName = i['qualifications']['name'];

      _fromYear = i['startYear'];
      //
      //pars ISO to Flutter DateTime
      parsDateTime(value: '', currentFormat: '', desiredFormat: '');
      DateTime fromYear = parsDateTime(
          value: _fromYear,
          currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
          desiredFormat: "yyyy-MM-dd HH:mm:ss");
      print(_fromYear);
      print(fromYear);
      //
      //Convert String to be DateTime
      _fromYear = DateFormat("yyyy-MM-dd").parse(fromYear.toString());

      _toYear = i['endYear'];
      //pars ISO to Flutter DateTime
      parsDateTime(value: '', currentFormat: '', desiredFormat: '');
      DateTime toYear = parsDateTime(
          value: _toYear,
          currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
          desiredFormat: "yyyy-MM-dd HH:mm:ss");
      //
      //Convert String to be DateTime
      _toYear = DateFormat("yyyy-MM-dd").parse(toYear.toString());

      _subjectController.text = _subject;
      _collageController.text = _collage;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getReuseTypeSeeker('EN', 'Degree');

    _subjectController.text = _subject;
    _collageController.text = _collage;

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
            textTitle: "Education",
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
                            //Subject
                            Text(
                              "Subject",
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SimpleTextFieldWithIconRight(
                              textController: _subjectController,
                              changed: (value) {
                                setState(() {
                                  _subject = value;
                                });
                              },
                              inputColor: AppColors.inputWhite,
                              hintText: "Enter subject",
                              hintTextFontWeight: FontWeight.bold,
                              suffixIcon: Icon(
                                Icons.keyboard,
                              ),
                              suffixIconColor: AppColors.iconGrayOpacity,
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //School/Collage
                            Text(
                              "School/Collage",
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SimpleTextFieldWithIconRight(
                              textController: _collageController,
                              changed: (value) {
                                setState(() {
                                  _collage = value;
                                });
                              },
                              inputColor: AppColors.inputWhite,
                              hintText: "Enter School/Collage",
                              hintTextFontWeight: FontWeight.bold,
                              suffixIcon: Icon(
                                Icons.school,
                              ),
                              suffixIconColor: AppColors.iconGrayOpacity,
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //Qualifications
                            Text(
                              "Qualifications",
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),

                            BoxDecorationInput(
                              mainAxisAlignmentTextIcon:
                                  MainAxisAlignment.start,
                              colorInput: AppColors.backgroundWhite,
                              colorBorder: _selectedDegree == "" &&
                                      _isValidateValue == true
                                  ? AppColors.borderDanger
                                  : AppColors.borderSecondary,
                              paddingFaIcon:
                                  EdgeInsets.symmetric(horizontal: 1.7.w),
                              fontWeight: null,
                              widgetIconActive: FaIcon(
                                FontAwesomeIcons.caretDown,
                                color: AppColors.iconGrayOpacity,
                                size: IconSize.sIcon,
                              ),
                              press: () async {
                                var result = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return ListSingleSelectedAlertDialog(
                                        title: "Qualifications",
                                        listItems: _listDegrees,
                                        selectedListItem: _selectedDegree,
                                      );
                                    }).then(
                                  (value) {
                                    //value = "_id"
                                    //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                    if (value != "") {
                                      //
                                      //ເອົາ _listDegrees ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                                      dynamic findValue = _listDegrees
                                          .firstWhere((i) => i["_id"] == value);

                                      setState(() {
                                        _selectedDegree = findValue['_id'];
                                        _degreeName = findValue['name'];
                                      });
                                      print(_degreeName);
                                    }
                                  },
                                );
                              },
                              text: _selectedDegree != ""
                                  ? "${_degreeName}"
                                  : "Select Qualifications",
                              colorText: _selectedDegree == ""
                                  ? AppColors.fontGreyOpacity
                                  : AppColors.fontDark,
                              validateText: _isValidateValue == true &&
                                      _selectedDegree == ""
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
                            //From DateTime(Year)
                            Text(
                              "From Year",
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
                                  _isValidateValue == true && _fromYear == null
                                      ? AppColors.borderDanger
                                      : AppColors.borderSecondary,
                              paddingFaIcon:
                                  EdgeInsets.symmetric(horizontal: 1.7.w),
                              fontWeight:
                                  _fromYear == null ? FontWeight.bold : null,
                              widgetIconActive: FaIcon(
                                FontAwesomeIcons.calendar,
                                color: AppColors.iconGrayOpacity,
                                size: IconSize.sIcon,
                              ),
                              press: () {
                                // format date.now() ຈາກ 2022-10-30 19:44:31.180 ເປັນ 2022-10-30 00:00:00.000
                                var formatDateTimeNow = DateFormat("yyyy-MM-dd")
                                    .parse(_dateTimeNow.toString());
                                setState(() {
                                  _fromYear == null
                                      ? _fromYear = formatDateTimeNow
                                      : _fromYear;
                                });
                                showDialogDateTime(
                                    context,
                                    Text(
                                      "From Year",
                                      style:
                                          bodyTextNormal(null, FontWeight.bold),
                                    ),
                                    CupertinoDatePicker(
                                      initialDateTime: _fromYear == null
                                          ? formatDateTimeNow
                                          : _fromYear,
                                      mode: CupertinoDatePickerMode.monthYear,
                                      // dateOrder: DatePickerDateOrder.dmy,
                                      use24hFormat: true,
                                      onDateTimeChanged: (DateTime newDate) {
                                        setState(() {
                                          _fromYear = newDate;

                                          if (_toYear != null &&
                                              _toYear.isBefore(_fromYear)) {
                                            // If toDate is before fromDate, set toDate to null
                                            _toYear = null;
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
                              text: _fromYear == null
                                  ? 'From Year'
                                  : "${_fromYear?.year}",
                              colorText: _fromYear == null
                                  ? AppColors.fontGreyOpacity
                                  : AppColors.fontDark,
                              validateText:
                                  _isValidateValue == true && _fromYear == null
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
                              "To Year",
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            _fromYear != null
                                ? BoxDecorationInput(
                                    mainAxisAlignmentTextIcon:
                                        MainAxisAlignment.start,
                                    colorInput: AppColors.backgroundWhite,
                                    colorBorder: _isValidateValue == true &&
                                            _toYear == null
                                        ? AppColors.borderDanger
                                        : AppColors.borderSecondary,
                                    paddingFaIcon:
                                        EdgeInsets.symmetric(horizontal: 1.7.w),
                                    fontWeight: _toYear == null
                                        ? FontWeight.bold
                                        : null,
                                    widgetIconActive: FaIcon(
                                      FontAwesomeIcons.calendar,
                                      color: AppColors.iconGrayOpacity,
                                      size: IconSize.sIcon,
                                    ),
                                    press: () {
                                      setState(() {
                                        _toYear == null
                                            ? _toYear = _fromYear
                                            : _toYear;
                                      });

                                      showDialogDateTime(
                                          context,
                                          Text(
                                            "To Year",
                                            style: bodyTextNormal(
                                                null, FontWeight.bold),
                                          ),
                                          CupertinoDatePicker(
                                            initialDateTime: _toYear == null
                                                ? _fromYear
                                                : _toYear,
                                            mode: CupertinoDatePickerMode
                                                .monthYear,
                                            // dateOrder: DatePickerDateOrder.dmy,
                                            minimumDate: _fromYear,
                                            use24hFormat: true,
                                            onDateTimeChanged:
                                                (DateTime newDate) {
                                              setState(() {
                                                _toYear = newDate;
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
                                    text: _toYear == null
                                        ? 'To Year'
                                        : "${_toYear?.year}",
                                    colorText: _toYear == null
                                        ? AppColors.fontGreyOpacity
                                        : AppColors.fontDark,
                                    validateText: _isValidateValue == true &&
                                            _toYear == null
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
                                            _toYear == null
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
                                    text: "To Year",
                                    validateText: _isValidateValue == true &&
                                            _toYear == null
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
                            )
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
                          print("check for formkey.currentState!.validate()");
                          setState(() {
                            if (_selectedDegree == "" ||
                                _fromYear == null ||
                                _toYear == null) {
                              setState(() {
                                _isValidateValue = true;
                              });
                            } else {
                              addEducationSeeker();
                            }
                          });
                        } else {
                          print("invalid validate form");
                          if (_selectedDegree == "" ||
                              _fromYear == null ||
                              _toYear == null) {
                            setState(() {
                              _isValidateValue = true;
                            });
                          }
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

  getReuseTypeSeeker(String lang, String type) async {
    var res =
        await fetchData(getReuseTypeApiSeeker + "lang=${lang}&type=${type}");
    _listDegrees = res['seekerReuse'];

    setState(() {});
  }

  addEducationSeeker() async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertLoading();
      },
    );

    var res = await postData(addEducationSeekerApi, {
      "_id": _id,
      "subject": _subject,
      "startYear": _fromYear.toString(),
      "endYear": _toYear.toString(),
      "school": _collage,
      "qualifications": _selectedDegree
    });
    if (res['education'] != null) {
      Navigator.pop(context);
    }

    if (res['education'] != null) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomAlertDialogSuccess(
            title: "Success",
            text: "Save Education Success",
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
