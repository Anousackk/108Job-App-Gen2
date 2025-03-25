// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, unused_local_variable, prefer_if_null_operators, avoid_print, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, unnecessary_null_in_if_null_operators, avoid_init_to_null, file_names, sized_box_for_whitespace, deprecated_member_use, prefer_adjacent_string_concatenation, avoid_unnecessary_containers

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
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:quill_html_converter/quill_html_converter.dart';

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
  FocusScopeNode _currentFocus = FocusScopeNode();
  FocusNode focusNode = FocusNode();
  FocusNode editorFocusNode = FocusNode();
  QuillController _quillController = QuillController.basic();

  String? _id;
  String _company = "";
  String _jobTitle = "";
  String _responsibility = "";

  dynamic _fromMonthYear = null;
  dynamic _toMonthYear = null;

  bool _isValidateValue = false;
  bool _isCurrentJob = false;

  DateTime _dateTimeNow = DateTime.now();

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
      if (_fromMonthYear != null) {
        //
        //pars ISO to Flutter DateTime
        parsDateTime(value: '', currentFormat: '', desiredFormat: '');
        DateTime fromMonthYear = parsDateTime(
            value: _fromMonthYear,
            currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
            desiredFormat: "yyyy-MM-dd HH:mm:ss");
        //
        //Convert String to DateTime
        _fromMonthYear =
            DateFormat("yyyy-MM-dd").parse(fromMonthYear.toString());
      }

      _toMonthYear = i['endYear'];
      if (_toMonthYear != null) {
        //
        //pars ISO to Flutter DateTime
        parsDateTime(value: '', currentFormat: '', desiredFormat: '');
        DateTime toMonthYear = parsDateTime(
            value: _toMonthYear,
            currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
            desiredFormat: "yyyy-MM-dd HH:mm:ss");
        //
        //Convert String to DateTime
        _toMonthYear = DateFormat("yyyy-MM-dd").parse(toMonthYear.toString());
      }

      _companyController.text = _company;
      _jobTitleController.text = _jobTitle;

      try {
        // final json = jsonDecode(_responsibility);
        // _quillController.document = Document.fromJson(json);

        // Convert HTML to Quill Delta
        Delta delta = HtmlToDelta().convert(_responsibility.toString());

        _quillController.document = Document.fromDelta(delta);
      } catch (e) {
        //Handle the decoding error (e.g., print an error message)
        print('Error decoding JSON: $e');
      }
    });
  }

  pressCurrentJobCheckBox() {
    setState(() {
      _isCurrentJob = !_isCurrentJob;
      _toMonthYear = null;
    });
  }

  addWorkHistorySeeker() async {
    String quillConvertDeltaToHTML =
        _quillController.document.toDelta().toHtml();
    print(quillConvertDeltaToHTML.toString());
    //
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    var res = await postData(addWorkHistorySeekerApi, {
      "_id": _id,
      "company": _company,
      "startYear":
          _fromMonthYear != null ? _fromMonthYear.toString() : _fromMonthYear,
      "endYear": _toMonthYear != null ? _toMonthYear.toString() : _toMonthYear,
      "position": _jobTitle,
      "responsibility":
          // jsonEncode(_quillController.document.toDelta().toJson()),
          quillConvertDeltaToHTML,
      "isCurrentJob": _isCurrentJob
    });

    var updateNoExperience =
        await postData(noExperienceSeekerApi, {"noExperience": false});

    print("workHistory: " + "${res['workHistory']}");
    print("updateNoExperience: " + "${updateNoExperience}");

    if (res['workHistory'] != null) {
      Navigator.pop(context);
    }

    if (res['workHistory'] != null) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "save".tr + " " + "successful".tr,
            contentText:
                "save".tr + " " + "work_history".tr + " " + "successful".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
              Navigator.of(context).pop("Submitted");
            },
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _companyController.text = _company;
    _jobTitleController.text = _jobTitle;

    _id = widget.id ?? "";
    if (_id != null && _id != "") {
      print("id != null");
      print("${_id}");

      setValueGetById();
    }
  }

  @override
  void dispose() {
    _quillController.dispose();
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

    return GestureDetector(
      onTap: () {
        _currentFocus = FocusScope.of(context);
        if (!_currentFocus.hasPrimaryFocus) {
          _currentFocus.unfocus();
        }
      },
      child: MediaQuery(
        data:
            MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: AppColors.primary600,
          ),
          body: SafeArea(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: AppColors.backgroundWhite,
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    //
                    //
                    //
                    //
                    //Section
                    //Appbar custom
                    AppBarThreeWidgt(
                      //
                      //Widget Leading
                      //Navigator.pop
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 45,
                            width: 45,
                            color: AppColors.iconLight.withOpacity(0.1),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "\uf060",
                                style: fontAwesomeRegular(
                                    null, 20, AppColors.iconLight, null),
                              ),
                            ),
                          ),
                        ),
                      ),

                      //
                      //
                      //Widget Title
                      //Text title
                      title: Text(
                        "work_history".tr,
                        style: appbarTextMedium(
                            "NotoSansLaoLoopedBold", AppColors.fontWhite, null),
                      ),

                      //
                      //
                      //Widget Actions
                      //Profile setting
                      actions: Container(
                        height: 45,
                        width: 45,
                      ),
                    ),

                    //
                    //
                    //
                    //
                    //Section
                    //Content form work history
                    Expanded(
                      flex: 15,
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                              ),

                              //
                              //
                              //Company
                              Text(
                                "work_employer".tr,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //
                              //
                              //Company input
                              SimpleTextFieldWithIconRight(
                                textController: _companyController,
                                changed: (value) {
                                  setState(() {
                                    _company = value;
                                  });
                                },
                                inputColor: AppColors.inputWhite,
                                hintText: "enter".tr + " " + "work_employer".tr,
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
                                "work_position".tr,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //
                              //
                              //Job title input
                              SimpleTextFieldWithIconRight(
                                textController: _jobTitleController,
                                changed: (value) {
                                  setState(() {
                                    _jobTitle = value;
                                  });
                                },
                                inputColor: AppColors.inputWhite,
                                hintText: "enter".tr + " " + "work_position".tr,
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
                              //CheckBox current job
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      pressCurrentJobCheckBox();
                                    },
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        color: _isCurrentJob
                                            ? AppColors.iconPrimary
                                            : AppColors.iconLight,
                                        border: Border.all(
                                            color: _isCurrentJob
                                                ? AppColors.borderPrimary
                                                : AppColors.borderDark),
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
                                  Text("work_current".tr),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              //
                              //
                              //From DateTime(Month/Year)
                              Text(
                                "work_start_date".tr,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //
                              //
                              //From DateTime(Month/Year) select date
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
                                  FocusScope.of(context)
                                      .requestFocus(focusNode);

                                  //
                                  //
                                  //format date.now() ຈາກ 2022-10-30 19:44:31.180 ເປັນ 2022-10-30 00:00:00.000
                                  var formatDateTimeNow =
                                      DateFormat("yyyy-MM-dd")
                                          .parse(_dateTimeNow.toString());
                                  setState(() {
                                    _fromMonthYear == null
                                        ? _fromMonthYear = formatDateTimeNow
                                        : _fromMonthYear;
                                  });

                                  showDialogDateTime(
                                      context,
                                      Text(
                                        "work_start_date".tr,
                                        style: bodyTextMedium(
                                            null, null, FontWeight.bold),
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
                                    ? "work_start_date".tr
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
                                              null, AppColors.fontDanger, null),
                                        ),
                                      )
                                    : Container(),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              //
                              //
                              //To DateTime(Month/Year)
                              if (!_isCurrentJob)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "work_end_date".tr,
                                      style: bodyTextNormal(
                                          null, null, FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    //
                                    //ຖ້າມີຂໍ້ມູນ _fromMonthYear
                                    //To DateTime(Month/Year) select date
                                    _fromMonthYear != null
                                        ? BoxDecorationInput(
                                            mainAxisAlignmentTextIcon:
                                                MainAxisAlignment.start,
                                            colorInput:
                                                AppColors.backgroundWhite,
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
                                              FocusScope.of(context)
                                                  .requestFocus(focusNode);

                                              setState(() {
                                                _toMonthYear == null
                                                    ? _toMonthYear =
                                                        _fromMonthYear
                                                    : _toMonthYear;
                                              });

                                              showDialogDateTime(
                                                  context,
                                                  Text(
                                                    "work_end_date".tr,
                                                    style: bodyTextMedium(null,
                                                        null, FontWeight.bold),
                                                  ),
                                                  CupertinoDatePicker(
                                                    initialDateTime:
                                                        _toMonthYear == null
                                                            ? _fromMonthYear
                                                            : _toMonthYear,
                                                    mode:
                                                        CupertinoDatePickerMode
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
                                                ? "work_end_date".tr
                                                : "${_toMonthYear?.month}-${_toMonthYear?.year}",
                                            colorText: _toMonthYear == null
                                                ? AppColors.fontGreyOpacity
                                                : AppColors.fontDark,
                                            validateText: _isValidateValue ==
                                                        true &&
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
                                                          null,
                                                          AppColors.fontDanger,
                                                          null),
                                                    ),
                                                  )
                                                : Container(),
                                          )

                                        //
                                        //
                                        // ຖ້າຍັງບໍ່ມີຂໍ້ມູນ _fromMonthYear
                                        //To DateTime(Month/Year) select date
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
                                            colorText:
                                                AppColors.fontGreyOpacity,
                                            widgetIconActive: FaIcon(
                                              FontAwesomeIcons.calendar,
                                              color: AppColors.iconGrayOpacity,
                                              size: IconSize.sIcon,
                                            ),
                                            text: "work_end_date".tr,
                                            validateText: _isValidateValue ==
                                                        true &&
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
                                                          null,
                                                          AppColors.fontDanger,
                                                          null),
                                                    ),
                                                  )
                                                : Container(),
                                          ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),

                              //
                              //
                              // Responsibility
                              Text(
                                "work_responsibility".tr,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //
                              //
                              // Responsibility input
                              BoxDecorationInput(
                                mainAxisAlignmentTextIcon:
                                    MainAxisAlignment.start,
                                colorInput: AppColors.backgroundWhite,
                                colorBorder: AppColors.borderSecondary,
                                paddingFaIcon:
                                    EdgeInsets.symmetric(horizontal: 1.7.w),
                                press: () {
                                  FocusScope.of(context)
                                      .requestFocus(focusNode);

                                  //
                                  //
                                  //show dialog QuillEditor
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return Dialog(
                                          insetPadding: EdgeInsets.zero,
                                          child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Column(
                                              children: [
                                                //
                                                //
                                                //QuillToolbar
                                                Container(
                                                  width: double.infinity,
                                                  color: AppColors.background,
                                                  child: QuillToolbar.simple(
                                                    configurations:
                                                        QuillSimpleToolbarConfigurations(
                                                      controller:
                                                          _quillController,
                                                      toolbarIconAlignment:
                                                          WrapAlignment.start,
                                                      toolbarSectionSpacing: 0,
                                                      showFontFamily: false,
                                                      showFontSize: false,
                                                      showHeaderStyle: false,
                                                      showAlignmentButtons:
                                                          false,
                                                      showBackgroundColorButton:
                                                          false,
                                                      showClipboardCopy: false,
                                                      showClipboardCut: false,
                                                      showClipboardPaste: false,
                                                      showColorButton: false,
                                                      showCodeBlock: false,
                                                      showDirection: false,
                                                      showQuote: false,
                                                      showUndo: false,
                                                      showSuperscript: false,
                                                      showLeftAlignment: false,
                                                      showRedo: false,
                                                      showRightAlignment: false,
                                                      showSearchButton: false,
                                                      showJustifyAlignment:
                                                          false,
                                                      showLineHeightButton:
                                                          false,
                                                      showSubscript: false,
                                                      showCenterAlignment:
                                                          false,
                                                      showInlineCode: false,
                                                      showSmallButton: false,
                                                      // showClearFormat: false,
                                                      showIndent: false,
                                                      showListCheck: false,
                                                      showDividers: false,
                                                    ),
                                                  ),
                                                ),

                                                //
                                                //
                                                //QuillEditor
                                                Expanded(
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: AppColors
                                                            .background,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  8),
                                                        )),
                                                    child: QuillEditor.basic(
                                                      focusNode:
                                                          editorFocusNode,
                                                      configurations:
                                                          QuillEditorConfigurations(
                                                        keyboardAppearance:
                                                            Brightness.dark,
                                                        // requestKeyboardFocusOnCheckListChanged: true,
                                                        controller:
                                                            _quillController,

                                                        scrollPhysics:
                                                            ClampingScrollPhysics(),
                                                        readOnlyMouseCursor:
                                                            SystemMouseCursors
                                                                .text,
                                                        maxHeight: 400,
                                                        minHeight: 400,
                                                        placeholder:
                                                            "work_responsibility_detail"
                                                                .tr,
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        dialogTheme:
                                                            QuillDialogTheme(
                                                          labelTextStyle: TextStyle(
                                                              color: AppColors
                                                                  .fontPrimary),
                                                          buttonStyle:
                                                              ButtonStyle(
                                                            backgroundColor:
                                                                WidgetStateProperty
                                                                    .all(
                                                              AppColors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 20,
                                                          right: 20,
                                                          top: 20,
                                                        ),
                                                        child: Button(
                                                          text: "Done",
                                                          press: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                fontWeight: _quillController.document.isEmpty()
                                    ? FontWeight.bold
                                    : null,
                                text: _quillController.document.isEmpty()
                                    ? "work_responsibility_detail".tr
                                    : _quillController.document.toPlainText(),
                                colorText: _quillController.document.isEmpty()
                                    ? AppColors.fontGreyOpacity
                                    : AppColors.fontDark,
                                validateText: Container(),
                              ),

                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //
                    //
                    //
                    //
                    //Section
                    // Button save
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 30),
                      child: Button(
                        text: "save".tr,
                        textFontFamily: "NotoSansLaoLoopedMedium",
                        press: () {
                          FocusScope.of(context).requestFocus(focusNode);
                          if (formkey.currentState!.validate()) {
                            //
                            //_isCurrentJob = true ໃຫ້ກວດແຕ່ຟິວ _fromMonthYear
                            if (_isCurrentJob) {
                              if (_fromMonthYear == null) {
                                setState(() {
                                  _isValidateValue = true;
                                });
                              } else {
                                setState(() {
                                  _isValidateValue = false;
                                  addWorkHistorySeeker();
                                });
                              }
                            }
                            //
                            //_isCurrentJob = false ໃຫ້ກວດຟິວ _fromMonthYear and _toMonthYear
                            else {
                              if (_fromMonthYear == null ||
                                  _toMonthYear == null) {
                                setState(() {
                                  _isValidateValue = true;
                                });
                              } else {
                                setState(() {
                                  _isValidateValue = false;
                                  addWorkHistorySeeker();
                                });
                              }
                            }
                          } else {
                            setState(() {
                              _isValidateValue = true;
                            });
                          }
                        },
                      ),
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
}

//QuillToolbar
// Container(
//   width: double.infinity,
//   color: AppColors.background,
//   child: QuillToolbar.simple(
//     configurations:
//         QuillSimpleToolbarConfigurations(
//       controller: _quillController,
//       toolbarIconAlignment: WrapAlignment.start,
//       toolbarSectionSpacing: 0,
//       showFontFamily: false,
//       showFontSize: false,
//       showHeaderStyle: false,
//       showAlignmentButtons: false,
//       showBackgroundColorButton: false,
//       showClipboardCopy: false,
//       showClipboardCut: false,
//       showClipboardPaste: false,
//       showColorButton: false,
//       showCodeBlock: false,
//       showDirection: false,
//       showQuote: false,
//       showUndo: false,
//       showSuperscript: false,
//       showLeftAlignment: false,
//       showRedo: false,
//       showRightAlignment: false,
//       showSearchButton: false,
//       showJustifyAlignment: false,
//       showLineHeightButton: false,
//       showSubscript: false,
//       showCenterAlignment: false,
//       showInlineCode: false,
//       showSmallButton: false,
//       // showClearFormat: false,
//       showIndent: false,
//       showListCheck: false,
//       showDividers: false,
//     ),
//   ),
// ),

// //
// //
// //QuillEditor
// Container(
//   width: double.infinity,
//   decoration: BoxDecoration(
//       color: AppColors.background,
//       borderRadius: BorderRadius.only(
//         bottomLeft: Radius.circular(8),
//         bottomRight: Radius.circular(8),
//       )),
//   child: QuillEditor.basic(
//     focusNode: editorFocusNode,
//     configurations: QuillEditorConfigurations(
//       keyboardAppearance: Brightness.dark,
//       // requestKeyboardFocusOnCheckListChanged: true,
//       controller: _quillController,

//       scrollPhysics: ClampingScrollPhysics(),
//       readOnlyMouseCursor:
//           SystemMouseCursors.text,
//       maxHeight: 400,
//       minHeight: 400,
//       placeholder:
//           "work_responsibility_detail".tr,
//       padding: EdgeInsets.all(10),
//       dialogTheme: QuillDialogTheme(
//         labelTextStyle: TextStyle(
//             color: AppColors.fontPrimary),
//         buttonStyle: ButtonStyle(
//           backgroundColor:
//               WidgetStateProperty.all(
//             AppColors.red,
//           ),
//         ),
//       ),
//     ),
//   ),
// ),


