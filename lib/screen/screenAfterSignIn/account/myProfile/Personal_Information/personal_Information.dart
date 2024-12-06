// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, unused_local_variable, prefer_if_null_operators, avoid_print, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_typing_uninitialized_variables, unnecessary_new, prefer_is_empty, file_names

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
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({Key? key, this.id, this.profile})
      : super(key: key);
  final String? id;
  final profile;

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  FocusScopeNode _currentFocus = FocusScopeNode();
  FocusNode focusNode = FocusNode();

  //
  //Get list items all
  List _listProvinces = [];
  List _listDistricts = [];
  List _listNationality = [];
  List _listCountry = [];
  List _listGender = [];
  List _listMaritalStatus = [];

  //
  //Selected list item(ສະເພາະເຂົ້າ Database)
  String? _id;
  String _name = "";
  String _lastName = "";
  dynamic _dateOfBirth;
  String _selectedGender = "";
  String _selectedMaritalStatus = "";
  String _selectedNationality = "";
  String _selectedCountry = "";
  String _selectedProvince = "";
  String _selectedDistrict = "";

  //
  //value display(ສະເພາະສະແດງ)
  String _nationalityName = "";
  String _countryName = "";
  String _provinceName = "";
  String _districtName = "";
  String _genderName = "";
  String _maritalStatusName = "";
  String _localeLanguageApi = "";

  bool _isValidateValue = false;
  DateTime _dateTimeNow = DateTime.now();

  setValueGetById() {
    setState(() {
      dynamic i = widget.profile;

      _name = i['firstName'];
      _lastName = i['lastName'];
      _dateOfBirth = i['dateOfBirth'];

      if (_dateOfBirth != null) {
        //
        //Convert String to DateTime ປ່ຽນຈາກ "Jan-13-1999" ເພື່ອເຊັດເປັນ 1999-01-13 00:00:00.000
        // DateTime tempDate = new DateFormat("MMM-dd-yyyy").parse(_dateOfBirth);
        // _dateOfBirth = tempDate;

        //pars ISO to Flutter DateTime
        parsDateTime(value: '', currentFormat: '', desiredFormat: '');
        DateTime parsDateOfBirth = parsDateTime(
          value: _dateOfBirth,
          currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
          desiredFormat: "yyyy-MM-dd HH:mm:ss",
        );

        _dateOfBirth = parsDateOfBirth;
      }

      _selectedGender = i['genderId'] != null ? i['genderId']['_id'] : "";
      _genderName = i['genderId'] != null ? i['genderId']['name'] : "";
      _selectedMaritalStatus =
          i['maritalStatusId'] != null ? i['maritalStatusId']['_id'] : "";
      _maritalStatusName =
          i['maritalStatusId'] != null ? i['maritalStatusId']['name'] : "";
      _selectedNationality =
          i['nationalityId'] != null ? i['nationalityId']['_id'] : "";
      _nationalityName =
          i['nationalityId'] != null ? i['nationalityId']['name'] : "";
      _selectedCountry =
          i['currentResidenceId'] != null ? i['currentResidenceId']['_id'] : "";
      _countryName = i['currentResidenceId'] != null
          ? i['currentResidenceId']['name']
          : "";
      _selectedDistrict = i['districtId'] != null ? i['districtId']['_id'] : "";
      _districtName = i['districtId'] != null ? i['districtId']['name'] : "";
      _selectedProvince =
          i['districtId'] == null || !i['districtId'].containsKey('provinceId')
              ? ""
              : i['districtId']['provinceId']['_id'];
      _provinceName =
          i['districtId'] == null || !i['districtId'].containsKey('provinceId')
              ? ""
              : i['districtId']['provinceId']['name'];

      //
      // ຖ້າມີ ProvinceId and DistrictId ແລ້ວ map ເອົາ ProvincsAndDistricts ວ່າ _province(_id) ກົງກັບ _provinces
      if (_selectedDistrict != "" && _selectedProvince != "") {
        var mapDistrict =
            _listProvinces.firstWhere((d) => d['_id'] == _selectedProvince);
        _listDistricts = mapDistrict['districts'];
      }

      _nameController.text = _name;
      _lastNameController.text = _lastName;
    });
  }

  getSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    var getLanguageSharePref = prefs.getString('setLanguage');
    var getLanguageApiSharePref = prefs.getString('setLanguageApi');
    // print("local " + getLanguageSharePref.toString());
    // print("api " + getLanguageApiSharePref.toString());

    setState(() {
      _localeLanguageApi = getLanguageApiSharePref.toString();
    });

    getReuseTypeSeeker(_localeLanguageApi, 'Nationality', _listNationality);
    getReuseTypeSeeker(_localeLanguageApi, 'CurrentResidence', _listCountry);
    getReuseTypeSeeker(_localeLanguageApi, 'Gender', _listGender);
    getReuseTypeSeeker(_localeLanguageApi, 'MaritalStatus', _listMaritalStatus);
    getProvinceAndDistrict(_localeLanguageApi);
  }

  @override
  void initState() {
    super.initState();

    getSharedPreferences();

    //
    //
    //Check by _id ເພື່ອເອົາຂໍ້ມູນມາອັບເດດ
    _id = widget.id ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          // appBar: AppBarDefault(
          //   textTitle: "personal_info".tr,
          //   // fontWeight: FontWeight.bold,
          //   leadingIcon: Icon(Icons.arrow_back),
          //   leadingPress: () {
          //     Navigator.pop(context);
          //   },
          // ),
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: AppColors.primary600,
          ),
          body: SafeArea(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: AppColors.backgroundWhite,
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
                      "personal_info".tr,
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
                  //Content personal information
                  Expanded(
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Form(
                        key: formkey,
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
                              //Name
                              Text(
                                "first name".tr,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //
                              //
                              //Name input
                              SimpleTextFieldWithIconRight(
                                textController: _nameController,
                                changed: (value) {
                                  setState(() {
                                    _name = value;
                                  });
                                },
                                inputColor: AppColors.inputWhite,
                                hintText:
                                    "enter your".tr + " " + "first name".tr,
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
                              //LastName
                              Text(
                                "last name".tr,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //
                              //
                              //last name input
                              SimpleTextFieldWithIconRight(
                                textController: _lastNameController,
                                changed: (value) {
                                  setState(() {
                                    _lastName = value;
                                  });
                                },
                                inputColor: AppColors.inputWhite,
                                hintText:
                                    "enter your".tr + " " + "last name".tr,
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
                              //Date of birth
                              Text(
                                "date of birth".tr,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //
                              //
                              //Date of birth select date
                              BoxDecorationInput(
                                mainAxisAlignmentTextIcon:
                                    MainAxisAlignment.start,
                                colorInput: AppColors.backgroundWhite,
                                colorBorder: _isValidateValue == true &&
                                        _dateOfBirth == null
                                    ? AppColors.borderDanger
                                    : AppColors.borderSecondary,
                                paddingFaIcon:
                                    EdgeInsets.symmetric(horizontal: 8),
                                fontWeight: null,
                                widgetIconActive: FaIcon(
                                  FontAwesomeIcons.calendar,
                                  color: AppColors.iconGrayOpacity,
                                  size: IconSize.sIcon,
                                ),
                                press: () {
                                  FocusScope.of(context)
                                      .requestFocus(focusNode);

                                  // format date.now() ຈາກ 2022-10-30 19:44:31.180 ເປັນ 2022-10-30 00:00:00.000
                                  var formatDateTimeNow =
                                      DateFormat("yyyy-MM-dd")
                                          .parse(_dateTimeNow.toString());
                                  setState(() {
                                    _dateOfBirth == null
                                        ? _dateOfBirth = formatDateTimeNow
                                        : _dateOfBirth;

                                    print(_dateOfBirth);
                                  });

                                  showDialogDateTime(
                                      context,
                                      Text(
                                        "date of birth".tr,
                                        style: bodyTextNormal(
                                            null, null, FontWeight.bold),
                                      ),
                                      CupertinoDatePicker(
                                        initialDateTime: _dateOfBirth == null
                                            ? formatDateTimeNow
                                            : _dateOfBirth,
                                        maximumDate: formatDateTimeNow,
                                        mode: CupertinoDatePickerMode.date,
                                        dateOrder: DatePickerDateOrder.dmy,
                                        use24hFormat: true,
                                        onDateTimeChanged: (DateTime newDate) {
                                          setState(
                                            () => _dateOfBirth = newDate,
                                          );
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
                                text: _dateOfBirth == null
                                    ? "date of birth".tr
                                    : "${_dateOfBirth?.day}-${_dateOfBirth?.month}-${_dateOfBirth?.year}",
                                colorText: _dateOfBirth == null
                                    ? AppColors.fontGreyOpacity
                                    : AppColors.fontDark,
                                validateText: _isValidateValue == true &&
                                        _dateOfBirth == null
                                    ? Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(
                                          left: 15,
                                          top: 5,
                                        ),
                                        child: Text(
                                          "required",
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
                              //Gender
                              Text(
                                "gender".tr,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //
                              //
                              //Gender box decoration select
                              BoxDecorationInput(
                                mainAxisAlignmentTextIcon:
                                    MainAxisAlignment.start,
                                colorInput: AppColors.backgroundWhite,
                                colorBorder: _selectedGender == "" &&
                                        _isValidateValue == true
                                    ? AppColors.borderDanger
                                    : AppColors.borderSecondary,
                                paddingFaIcon:
                                    EdgeInsets.symmetric(horizontal: 8),
                                fontWeight: null,
                                widgetIconActive: FaIcon(
                                  FontAwesomeIcons.caretDown,
                                  color: AppColors.iconGrayOpacity,
                                  size: IconSize.sIcon,
                                ),
                                press: () async {
                                  FocusScope.of(context)
                                      .requestFocus(focusNode);

                                  var result = await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return ListSingleSelectedAlertDialog(
                                          title: "gender".tr,
                                          listItems: _listGender,
                                          selectedListItem: _selectedGender,
                                        );
                                      }).then(
                                    (value) {
                                      // print(_currentFocus);
                                      //value = "_id"
                                      //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                      if (value != "") {
                                        //
                                        //ເອົາ _listGender ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                                        dynamic findValue =
                                            _listGender.firstWhere(
                                                (i) => i["_id"] == value);

                                        setState(() {
                                          _selectedGender = findValue['_id'];
                                          _genderName = findValue['name'];
                                        });

                                        print(_genderName);
                                      }
                                    },
                                  );
                                },
                                text: _selectedGender != ""
                                    ? "${_genderName}"
                                    : "select".tr + " " + "gender".tr,
                                colorText: _selectedGender == ""
                                    ? AppColors.fontGreyOpacity
                                    : AppColors.fontDark,
                                validateText: _isValidateValue == true &&
                                        _selectedGender == ""
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

                              // Row(
                              //   children: [
                              //     Expanded(
                              //       flex: 1,
                              //       child: ButtonWithIconLeft(
                              //         paddingButton:
                              //             MaterialStateProperty.all<EdgeInsets>(
                              //           EdgeInsets.symmetric(vertical: 12),
                              //         ),
                              //         borderRadius: BorderRadius.circular(2.5.w),
                              //         colorButton: _gender == "Male"
                              //             ? AppColors.buttonLightBlue
                              //             : AppColors.buttonWhite,
                              //         buttonBorderColor: _gender == "Male"
                              //             ? AppColors.borderPrimary
                              //             : AppColors.borderSecondary,
                              //         widgetIcon: FaIcon(
                              //           FontAwesomeIcons.mars,
                              //           color: _gender == "Male"
                              //               ? AppColors.iconPrimary
                              //               : AppColors.iconDark,
                              //           size: IconSize.sIcon,
                              //         ),
                              //         text: "Male",
                              //         colorText: _gender == "Male"
                              //             ? AppColors.iconPrimary
                              //             : AppColors.iconDark,
                              //         press: () {
                              //           selectValueGender("Male");
                              //         },
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       width: 10,
                              //     ),
                              //     Expanded(
                              //       flex: 1,
                              //       child: ButtonWithIconLeft(
                              //         paddingButton:
                              //             MaterialStateProperty.all<EdgeInsets>(
                              //           EdgeInsets.symmetric(vertical: 12),
                              //         ),
                              //         borderRadius: BorderRadius.circular(2.5.w),
                              //         colorButton: _gender == "Female"
                              //             ? AppColors.buttonLightBlue
                              //             : AppColors.buttonWhite,
                              //         buttonBorderColor: _gender == "Female"
                              //             ? AppColors.borderPrimary
                              //             : AppColors.borderSecondary,
                              //         widgetIcon: FaIcon(
                              //           FontAwesomeIcons.venus,
                              //           color: _gender == "Female"
                              //               ? AppColors.iconPrimary
                              //               : AppColors.iconDark,
                              //           size: IconSize.sIcon,
                              //         ),
                              //         text: "Female",
                              //         colorText: _gender == "Female"
                              //             ? AppColors.iconPrimary
                              //             : AppColors.iconDark,
                              //         press: () {
                              //           selectValueGender("Female");
                              //         },
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       width: 10,
                              //     ),
                              //     Expanded(
                              //       flex: 1,
                              //       child: ButtonWithIconLeft(
                              //         paddingButton:
                              //             MaterialStateProperty.all<EdgeInsets>(
                              //           EdgeInsets.symmetric(vertical: 12),
                              //         ),
                              //         borderRadius: BorderRadius.circular(2.5.w),
                              //         colorButton: _gender == "Other"
                              //             ? AppColors.buttonLightBlue
                              //             : AppColors.buttonWhite,
                              //         buttonBorderColor: _gender == "Other"
                              //             ? AppColors.borderPrimary
                              //             : AppColors.borderSecondary,
                              //         widgetIcon: FaIcon(
                              //           FontAwesomeIcons.marsAndVenus,
                              //           color: _gender == "Other"
                              //               ? AppColors.iconPrimary
                              //               : AppColors.iconDark,
                              //           size: IconSize.sIcon,
                              //         ),
                              //         text: "Other",
                              //         colorText: _gender == "Other"
                              //             ? AppColors.iconPrimary
                              //             : AppColors.iconDark,
                              //         press: () {
                              //           selectValueGender("Other");
                              //         },
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(
                                height: 20,
                              ),

                              //
                              //
                              //Marital Status
                              Text(
                                "marital status".tr,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //
                              //
                              //Marital Status box decoration select
                              BoxDecorationInput(
                                mainAxisAlignmentTextIcon:
                                    MainAxisAlignment.start,
                                colorInput: AppColors.backgroundWhite,
                                colorBorder: _selectedMaritalStatus == "" &&
                                        _isValidateValue == true
                                    ? AppColors.borderDanger
                                    : AppColors.borderSecondary,
                                paddingFaIcon:
                                    EdgeInsets.symmetric(horizontal: 8),
                                fontWeight: null,
                                widgetIconActive: FaIcon(
                                  FontAwesomeIcons.caretDown,
                                  color: AppColors.iconGrayOpacity,
                                  size: IconSize.sIcon,
                                ),
                                press: () async {
                                  FocusScope.of(context)
                                      .requestFocus(focusNode);

                                  var result = await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return ListSingleSelectedAlertDialog(
                                          title: "marital status".tr,
                                          listItems: _listMaritalStatus,
                                          selectedListItem:
                                              _selectedMaritalStatus,
                                        );
                                      }).then(
                                    (value) {
                                      //value = "_id"
                                      //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                      if (value != "") {
                                        //
                                        //ເອົາ _listMaritalStatus ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                                        dynamic findValue =
                                            _listMaritalStatus.firstWhere(
                                                (i) => i["_id"] == value);

                                        setState(() {
                                          _selectedMaritalStatus =
                                              findValue['_id'];
                                          _maritalStatusName =
                                              findValue['name'];
                                        });

                                        print(_maritalStatusName);
                                      }
                                    },
                                  );
                                },
                                text: _selectedMaritalStatus != ""
                                    ? "${_maritalStatusName}"
                                    : "select".tr + " " + "marital status".tr,
                                colorText: _selectedMaritalStatus == ""
                                    ? AppColors.fontGreyOpacity
                                    : AppColors.fontDark,
                                validateText: _isValidateValue == true &&
                                        _selectedMaritalStatus == ""
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
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       flex: 1,
                              //       child: ButtonWithIconLeft(
                              //         paddingButton:
                              //             MaterialStateProperty.all<EdgeInsets>(
                              //           EdgeInsets.symmetric(vertical: 12),
                              //         ),
                              //         borderRadius: BorderRadius.circular(2.5.w),
                              //         colorButton: _maritalStatus == "Single"
                              //             ? AppColors.buttonLightBlue
                              //             : AppColors.buttonWhite,
                              //         buttonBorderColor: _maritalStatus == "Single"
                              //             ? AppColors.borderPrimary
                              //             : AppColors.borderSecondary,
                              //         widgetIcon: FaIcon(
                              //           FontAwesomeIcons.person,
                              //           color: _maritalStatus == "Single"
                              //               ? AppColors.iconPrimary
                              //               : AppColors.iconDark,
                              //           size: IconSize.sIcon,
                              //         ),
                              //         text: "Single",
                              //         colorText: _maritalStatus == "Single"
                              //             ? AppColors.iconPrimary
                              //             : AppColors.iconDark,
                              //         press: () {
                              //           selectValueMarital("Single");
                              //         },
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       width: 10,
                              //     ),
                              //     Expanded(
                              //       flex: 1,
                              //       child: ButtonWithIconLeft(
                              //         paddingButton:
                              //             MaterialStateProperty.all<EdgeInsets>(
                              //           EdgeInsets.symmetric(vertical: 12),
                              //         ),
                              //         borderRadius: BorderRadius.circular(2.5.w),
                              //         colorButton: _maritalStatus == "Married"
                              //             ? AppColors.buttonLightBlue
                              //             : AppColors.buttonWhite,
                              //         buttonBorderColor: _maritalStatus == "Married"
                              //             ? AppColors.borderPrimary
                              //             : AppColors.borderSecondary,
                              //         widgetIcon: FaIcon(
                              //           FontAwesomeIcons.solidHeart,
                              //           color: _maritalStatus == "Married"
                              //               ? AppColors.iconPrimary
                              //               : AppColors.iconDark,
                              //           size: IconSize.sIcon,
                              //         ),
                              //         text: "Married",
                              //         colorText: _maritalStatus == "Married"
                              //             ? AppColors.iconPrimary
                              //             : AppColors.iconDark,
                              //         press: () {
                              //           selectValueMarital("Married");
                              //         },
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(
                                height: 20,
                              ),

                              //
                              //
                              //Nationality
                              Text(
                                "nationality".tr,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //
                              //
                              //Nationality box decoration select
                              BoxDecorationInput(
                                mainAxisAlignmentTextIcon:
                                    MainAxisAlignment.start,
                                colorInput: AppColors.backgroundWhite,
                                colorBorder: _selectedNationality == "" &&
                                        _isValidateValue == true
                                    ? AppColors.borderDanger
                                    : AppColors.borderSecondary,
                                paddingFaIcon:
                                    EdgeInsets.symmetric(horizontal: 8),
                                fontWeight: null,
                                widgetIconActive: FaIcon(
                                  FontAwesomeIcons.caretDown,
                                  color: AppColors.iconGrayOpacity,
                                  size: IconSize.sIcon,
                                ),
                                press: () async {
                                  FocusScope.of(context)
                                      .requestFocus(focusNode);

                                  var result = await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return ListSingleSelectedAlertDialog(
                                          title: "nationality".tr,
                                          listItems: _listNationality,
                                          selectedListItem:
                                              _selectedNationality,
                                        );
                                      }).then(
                                    (value) {
                                      //value = "_id"
                                      //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                      if (value != "") {
                                        //
                                        //ເອົາ _listNationality ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                                        dynamic findValue =
                                            _listNationality.firstWhere(
                                                (i) => i["_id"] == value);

                                        setState(() {
                                          _selectedNationality =
                                              findValue['_id'];
                                          _nationalityName = findValue['name'];
                                        });

                                        print(_nationalityName);
                                      }
                                    },
                                  );
                                },
                                text: _selectedNationality != ""
                                    ? "${_nationalityName}"
                                    : "select".tr + " " + "nationality".tr,
                                colorText: _selectedNationality == ""
                                    ? AppColors.fontGreyOpacity
                                    : AppColors.fontDark,
                                validateText: _isValidateValue == true &&
                                        _selectedNationality == ""
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
                              //Country
                              Text(
                                "country".tr,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //
                              //
                              //Country box decoration select
                              BoxDecorationInput(
                                mainAxisAlignmentTextIcon:
                                    MainAxisAlignment.start,
                                colorInput: AppColors.backgroundWhite,
                                colorBorder: _selectedCountry == "" &&
                                        _isValidateValue == true
                                    ? AppColors.borderDanger
                                    : AppColors.borderSecondary,
                                paddingFaIcon:
                                    EdgeInsets.symmetric(horizontal: 8),
                                fontWeight: null,
                                widgetIconActive: FaIcon(
                                  FontAwesomeIcons.caretDown,
                                  color: AppColors.iconGrayOpacity,
                                  size: IconSize.sIcon,
                                ),
                                press: () async {
                                  FocusScope.of(context)
                                      .requestFocus(focusNode);

                                  var result = await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return ListSingleSelectedAlertDialog(
                                          title: "country".tr,
                                          listItems: _listCountry,
                                          selectedListItem: _selectedCountry,
                                        );
                                      }).then(
                                    (value) {
                                      //value = "_id"
                                      //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                      if (value != "") {
                                        //
                                        //ເອົາ _listCountry ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                                        dynamic findValue =
                                            _listCountry.firstWhere(
                                                (i) => i["_id"] == value);

                                        setState(() {
                                          _selectedCountry = findValue['_id'];
                                          _countryName = findValue['name'];
                                        });

                                        print(_countryName);
                                      }
                                    },
                                  );
                                },
                                text: _selectedCountry != ""
                                    ? "${_countryName}"
                                    : "select".tr + " " + "country".tr,
                                colorText: _selectedCountry == ""
                                    ? AppColors.fontGreyOpacity
                                    : AppColors.fontDark,
                                validateText: _isValidateValue == true &&
                                        _selectedCountry == ""
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
                              //Province
                              Text(
                                "province".tr,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //
                              //
                              //Province box decoration select
                              BoxDecorationInput(
                                mainAxisAlignmentTextIcon:
                                    MainAxisAlignment.start,
                                colorInput: AppColors.backgroundWhite,
                                colorBorder: _selectedProvince == "" &&
                                        _isValidateValue == true
                                    ? AppColors.borderDanger
                                    : AppColors.borderSecondary,
                                paddingFaIcon:
                                    EdgeInsets.symmetric(horizontal: 8),
                                fontWeight: null,
                                widgetIconActive: FaIcon(
                                  FontAwesomeIcons.caretDown,
                                  color: AppColors.iconGrayOpacity,
                                  size: IconSize.sIcon,
                                ),
                                press: () async {
                                  FocusScope.of(context)
                                      .requestFocus(focusNode);

                                  var result = await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return ListSingleSelectedAlertDialog(
                                          title: "province".tr,
                                          listItems: _listProvinces,
                                          selectedListItem: _selectedProvince,
                                        );
                                      }).then(
                                    (value) {
                                      //value = "_id"
                                      //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                      if (value != "") {
                                        //
                                        //ເອົາ _listProvinces ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                                        dynamic findValue =
                                            _listProvinces.firstWhere(
                                                (i) => i["_id"] == value);

                                        setState(() {
                                          _selectedProvince = findValue['_id'];
                                          _provinceName = findValue['name'];
                                        });
                                        print(_provinceName);

                                        //
                                        //map ເອົາ Provincs And Districts ທີ່ເຮົາເລືອກ _province(_id) ກົງກັບ _provinces
                                        //add ໂຕທີ່ເຮົາ map ໃສ່ _districts
                                        var mapDistrict =
                                            _listProvinces.firstWhere((d) =>
                                                d['_id'] == _selectedProvince);

                                        //
                                        //add ໂຕທີ່ເຮົາ map ໃສ່ _districts
                                        _listDistricts =
                                            mapDistrict['districts'];

                                        if (_selectedDistrict != "" &&
                                            _selectedProvince != "") {
                                          _listDistricts = [];
                                          _selectedDistrict = "";
                                          var mapDistrict =
                                              _listProvinces.firstWhere((d) =>
                                                  d['_id'] ==
                                                  _selectedProvince);
                                          _listDistricts =
                                              mapDistrict['districts'];
                                        }
                                      }
                                    },
                                  );
                                },
                                text: _selectedProvince != ""
                                    ? "${_provinceName}"
                                    : "select".tr + " " + "province".tr,
                                colorText: _selectedProvince == ""
                                    ? AppColors.fontGreyOpacity
                                    : AppColors.fontDark,
                                validateText: _isValidateValue == true &&
                                        _selectedProvince == ""
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

                              // DropdownButtonMenu(
                              //   inputColor: AppColors.backgroundWhite,
                              //   hintTextFontWeight: FontWeight.bold,
                              //   hintText: 'Select Province',
                              //   onChanged: (i) {
                              //     setState(() {
                              //       _province = i;
                              //       //
                              //       //map ເອົາ Provincs And Districts ທີ່ເຮົາເລືອກ _province(_id) ກົງກັບ _provinces
                              //       var mapDistrict = _listProvinces
                              //           .firstWhere((d) => d['_id'] == _province);
                              //       //
                              //       //add ໂຕທີ່ເຮົາ map ໃສ່ _districts
                              //       _listDistricts = mapDistrict['districts'];
                              //       if (_district != null && _province != null) {
                              //         _listDistricts = [];
                              //         _district = null;
                              //         var mapDistrict = _listProvinces
                              //             .firstWhere((d) => d['_id'] == _province);
                              //         _listDistricts = mapDistrict['districts'];
                              //       }
                              //       // print(_province);
                              //       // print(mapDistrict);
                              //     });
                              //   },
                              //   value: _province,
                              //   items: _listProvinces
                              //       .map(
                              //         (i) => DropdownMenuItem(
                              //           value: i['_id'].toString(),
                              //           child: Text(
                              //             i['name'],
                              //             overflow: TextOverflow.ellipsis,
                              //           ),
                              //         ),
                              //       )
                              //       .toList(),
                              //   validator: (value) =>
                              //       value == null || value == "" ? "required" : null,
                              // ),
                              SizedBox(
                                height: 20,
                              ),

                              //
                              //
                              //District
                              Text(
                                "district".tr,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //
                              //
                              //District box decoration select
                              BoxDecorationInput(
                                mainAxisAlignmentTextIcon:
                                    MainAxisAlignment.start,
                                colorInput: AppColors.backgroundWhite,
                                colorBorder: _selectedDistrict == "" &&
                                        _isValidateValue == true
                                    ? AppColors.borderDanger
                                    : AppColors.borderSecondary,
                                paddingFaIcon:
                                    EdgeInsets.symmetric(horizontal: 8),
                                fontWeight: null,
                                widgetIconActive: FaIcon(
                                  FontAwesomeIcons.caretDown,
                                  color: AppColors.iconGrayOpacity,
                                  size: IconSize.sIcon,
                                ),
                                press: () async {
                                  FocusScope.of(context)
                                      .requestFocus(focusNode);

                                  var result = await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return ListSingleSelectedAlertDialog(
                                          title: "district".tr,
                                          listItems: _listDistricts,
                                          selectedListItem: _selectedDistrict,
                                        );
                                      }).then(
                                    (value) {
                                      //value = "_id"
                                      //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                      if (value != "") {
                                        //
                                        //ເອົາ _listDistricts ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                                        dynamic findValue =
                                            _listDistricts.firstWhere(
                                                (i) => i["_id"] == value);

                                        setState(() {
                                          _selectedDistrict = findValue['_id'];
                                          _districtName = findValue['name'];
                                        });

                                        print(_districtName);
                                      }
                                    },
                                  );
                                },
                                text: _selectedDistrict != ""
                                    ? "${_districtName}"
                                    : "select".tr + " " + "district".tr,
                                colorText: _selectedDistrict == ""
                                    ? AppColors.fontGreyOpacity
                                    : AppColors.fontDark,
                                validateText: _isValidateValue == true &&
                                        _selectedDistrict == ""
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
                                height: 30,
                              ),
                            ],
                          ),
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
                      textFontWeight: FontWeight.bold,
                      press: () {
                        FocusScope.of(context).requestFocus(focusNode);
                        if (formkey.currentState!.validate()) {
                          print("for check formkey.currentState!.validate()");

                          if (_dateOfBirth == null ||
                              _selectedNationality == "" ||
                              _selectedCountry == "" ||
                              _selectedProvince == "" ||
                              _selectedDistrict == "" ||
                              _selectedGender == "" ||
                              _selectedMaritalStatus == "") {
                            setState(() {
                              _isValidateValue = true;
                            });
                          } else {
                            addProfileSeeker();
                          }
                        } else {
                          print("invalid validate form");

                          if (_dateOfBirth == null ||
                              _selectedNationality == "" ||
                              _selectedCountry == "" ||
                              _selectedProvince == "" ||
                              _selectedDistrict == "" ||
                              _selectedGender == "" ||
                              _selectedMaritalStatus == "") {
                            setState(() {
                              _isValidateValue = true;
                            });
                          }
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

  getProvinceAndDistrict(String lang) async {
    var res = await fetchData(getProvinceAndDistrictApiSeeker + "lang=${lang}");
    setState(() {
      _listProvinces = res['provinces'];

      if (res['provinces'] != null || res['provinces'].length > 0) {
        //
        //Check by _id ເພື່ອເອົາຂໍ້ມູນມາອັບເດດ
        if (_id != null && _id != "") {
          print("seekerId + ${_id}");

          setValueGetById();
        }
      }
    });
  }

  addProfileSeeker() async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustAlertLoading();
      },
    );

    var res = await postData(addProfileApiSeeker, {
      "firstName": _name,
      "lastName": _lastName,
      "dateOfBirth": _dateOfBirth.toString(),
      "genderId": _selectedGender,
      "maritalStatusId": _selectedMaritalStatus,
      "nationalityId": _selectedNationality,
      "currentResidenceId": _selectedCountry,
      "districtId": _selectedDistrict
    });
    //
    //ປິດ AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    if (res != null) {
      Navigator.pop(context);
    }

    print(res);

    if (res['created'] != null) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "save".tr + " " + "successful".tr,
            contentText:
                "save".tr + " " + "personal_info".tr + " " + "successful".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogErrorWithoutBtn(
            title: "incorrect".tr,
            text: "incorrect".tr,
          );
        },
      );
    }
  }
}
