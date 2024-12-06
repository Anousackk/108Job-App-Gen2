// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, unused_local_variable, prefer_if_null_operators, avoid_print, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, sized_box_for_whitespace

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:app/widget/listSingleSelectedAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class Language extends StatefulWidget {
  const Language({Key? key, this.id, this.language}) : super(key: key);
  final String? id;
  final dynamic language;

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  //Get list items all
  List _listLanguage = [];
  List _listLanguageLevel = [];

  //
  //Selected list item(ສະເພາະເຂົ້າ Database)
  String? _id;
  String _selectedLanguage = "";
  String _selectedProficiency = "";

  //
  //value display(ສະເພາະສະແດງ)
  String _languageName = "";
  String _proficiencyName = "";

  String _localeLanguageApi = "";
  bool _isValidateValue = false;

  setValueGetById() {
    setState(() {
      dynamic i = widget.language;

      _selectedLanguage = i['LanguageId']['_id'];
      _languageName = i['LanguageId']['name'];
      _selectedProficiency = i['LanguageLevelId']['_id'];
      _proficiencyName = i['LanguageLevelId']['name'];
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

    getReuseTypeSeeker(_localeLanguageApi, 'LanguageLevel', _listLanguageLevel);
    getReuseTypeSeeker(_localeLanguageApi, 'Language', _listLanguage);
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferences();

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
                        "language_skill".tr,
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
                    //Content form language
                    Expanded(
                      flex: 15,
                      child: SingleChildScrollView(
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
                              //Language
                              Text(
                                "language_skill".tr,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //
                              //
                              //Language box select
                              BoxDecorationInput(
                                mainAxisAlignmentTextIcon:
                                    MainAxisAlignment.start,
                                colorInput: AppColors.backgroundWhite,
                                colorBorder: _selectedLanguage == "" &&
                                        _isValidateValue == true
                                    ? AppColors.borderDanger
                                    : AppColors.borderSecondary,
                                paddingFaIcon:
                                    EdgeInsets.symmetric(horizontal: 1.7.w),
                                fontWeight: FontWeight.bold,
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
                                          title: "language_skill".tr,
                                          listItems: _listLanguage,
                                          selectedListItem: _selectedLanguage,
                                        );
                                      }).then(
                                    (value) {
                                      //value = "_id"
                                      //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                      if (value != "") {
                                        //
                                        //ເອົາ _listLanguage ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                                        dynamic findValue =
                                            _listLanguage.firstWhere(
                                                (i) => i["_id"] == value);

                                        setState(() {
                                          _selectedLanguage = findValue['_id'];
                                          _languageName = findValue['name'];
                                        });

                                        print(_languageName);
                                      }
                                    },
                                  );
                                },
                                text: _selectedLanguage != ""
                                    ? "${_languageName}"
                                    : "select".tr + " " + "language_skill".tr,
                                colorText: _selectedLanguage == ""
                                    ? AppColors.fontGreyOpacity
                                    : AppColors.fontDark,
                                validateText: _isValidateValue == true &&
                                        _selectedLanguage == ""
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
                              //Proficiency Language / Language level
                              Text(
                                "proficiency".tr,
                                style:
                                    bodyTextNormal(null, null, FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //
                              //
                              //Proficiency Language / Language level box select
                              BoxDecorationInput(
                                mainAxisAlignmentTextIcon:
                                    MainAxisAlignment.start,
                                colorInput: AppColors.backgroundWhite,
                                colorBorder: _selectedProficiency == "" &&
                                        _isValidateValue == true
                                    ? AppColors.borderDanger
                                    : AppColors.borderSecondary,
                                paddingFaIcon:
                                    EdgeInsets.symmetric(horizontal: 1.7.w),
                                fontWeight: FontWeight.bold,
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
                                          title: "proficiency".tr,
                                          listItems: _listLanguageLevel,
                                          selectedListItem:
                                              _selectedProficiency,
                                        );
                                      }).then(
                                    (value) {
                                      //value = "_id"
                                      //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                      if (value != "") {
                                        //
                                        //ເອົາ _listLanguageLevel ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                                        dynamic findValue =
                                            _listLanguageLevel.firstWhere(
                                                (i) => i["_id"] == value);

                                        setState(() {
                                          _selectedProficiency =
                                              findValue['_id'];
                                          _proficiencyName = findValue['name'];
                                        });

                                        print(_proficiencyName);
                                      }
                                    },
                                  );
                                },
                                text: _selectedProficiency != ""
                                    ? "${_proficiencyName}"
                                    : "select".tr + " " + "proficiency".tr,
                                colorText: _selectedProficiency == ""
                                    ? AppColors.fontGreyOpacity
                                    : AppColors.fontDark,
                                validateText: _isValidateValue == true &&
                                        _selectedProficiency == ""
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
                          if (formkey.currentState!.validate()) {
                            print("check for formkey.currentState!.validate()");
                            if (_selectedLanguage == "" ||
                                _selectedProficiency == "") {
                              setState(() {
                                _isValidateValue = true;
                              });
                            } else {
                              addLanguageSeeker();
                            }
                          } else {
                            print("invalid validate form");
                            if (_selectedLanguage == "" ||
                                _selectedProficiency == "") {
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

  addLanguageSeeker() async {
    //
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustAlertLoading();
      },
    );

    var res = await postData(addLanguageSeekerApi, {
      "_id": _id,
      "LanguageId": _selectedLanguage,
      "LanguageLevelId": _selectedProficiency
    });
    if (res['languageSkill'] != null) {
      Navigator.pop(context);
    }

    if (res['languageSkill'] != null) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "save".tr + " " + "successful".tr,
            contentText:
                "save".tr + " " + "language_skill".tr + " " + "successful".tr,
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
}
