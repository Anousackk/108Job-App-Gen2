// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, unused_local_variable, prefer_if_null_operators, avoid_print, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, sized_box_for_whitespace, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/provider/localSharePrefsProvider.dart';
import 'package:app/provider/profileProvider.dart';
import 'package:app/provider/reuseTypeProvider.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:app/widget/listSingleSelectedAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class Language extends StatefulWidget {
  const Language(
      {Key? key, this.id, this.language, this.onCancel, this.onSaveSuccess})
      : super(key: key);
  final String? id;
  final dynamic language;
  final Function()? onCancel;
  final Function()? onSaveSuccess;

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  FocusScopeNode _currentFocus = FocusScopeNode();

  //Get list items all
  // List _listLanguage = [];
  // List _listLanguageLevel = [];

  //
  //Selected list item(ສະເພາະເຂົ້າ Database)
  String? _id;
  String _selectedLanguage = "";
  String _selectedProficiency = "";

  //
  //value display(ສະເພາະສະແດງ)
  String _languageName = "";
  String _proficiencyName = "";
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

  pressAddLanguageSkill() async {
    final profileProvider = context.read<ProfileProvider>();

    // Display AlertDialog Loading First
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    final res = await profileProvider.addLanguageSkill(
      _id,
      _selectedLanguage,
      _selectedProficiency,
      profileProvider.statusEventUpdateProfile,
    );

    final statusCode = res?["statusCode"];

    if (!context.mounted) return;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    print("languageSkill: " + "${res}");

    if (statusCode == 200 || statusCode == 201) {
      // Call parent callback
      if (widget.onSaveSuccess != null) {
        widget.onSaveSuccess!();
      }
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

  checkByIdDisplayFormUpdate() {
    //Check by _id ເພື່ອເອົາຂໍ້ມູນມາອັບເດດ
    _id = widget.id ?? "";
    if (_id != null && _id != "") {
      print("languageId + ${_id}");

      setValueGetById();
    }
  }

  @override
  void initState() {
    super.initState();

    checkByIdDisplayFormUpdate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reuseTypeProvider = context.watch<ReuseTypeProvider>();

    return GestureDetector(
      onTap: () {
        _currentFocus = FocusScope.of(context);
        if (!_currentFocus.hasPrimaryFocus) {
          _currentFocus.unfocus();
        }
      },
      child: Container(
        // height: double.infinity,
        // width: double.infinity,
        color: AppColors.backgroundWhite,
        padding: EdgeInsets.symmetric(horizontal: 20),

        //
        //
        //Form Language
        child: Form(
          key: formkey,
          child: Column(
            children: [
              //
              //
              //Section
              //Content Language
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    //
                    //Language
                    Text(
                      "language_skill".tr,
                      style: bodyTextNormal(null, null, FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                    //
                    //
                    //Language box select
                    BoxDecorationInput(
                      mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                      colorInput: AppColors.backgroundWhite,
                      colorBorder:
                          _selectedLanguage == "" && _isValidateValue == true
                              ? AppColors.borderDanger
                              : AppColors.borderSecondary,
                      paddingFaIcon: EdgeInsets.symmetric(horizontal: 1.7.w),
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
                                listItems: reuseTypeProvider.listLanguage,
                                selectedListItem: _selectedLanguage,
                              );
                            }).then(
                          (value) {
                            //value = "_id"
                            //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                            if (value != "") {
                              //
                              //ເອົາ _listLanguage ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                              dynamic findValue = reuseTypeProvider.listLanguage
                                  .firstWhere((i) => i["_id"] == value);

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
                      validateText:
                          _isValidateValue == true && _selectedLanguage == ""
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
                    SizedBox(height: 20),

                    //
                    //
                    //Proficiency Language / Language level
                    Text(
                      "proficiency".tr,
                      style: bodyTextNormal(null, null, FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                    //
                    //
                    //Proficiency Language / Language level box select
                    BoxDecorationInput(
                      mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                      colorInput: AppColors.backgroundWhite,
                      colorBorder:
                          _selectedProficiency == "" && _isValidateValue == true
                              ? AppColors.borderDanger
                              : AppColors.borderSecondary,
                      paddingFaIcon: EdgeInsets.symmetric(horizontal: 1.7.w),
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
                                listItems: reuseTypeProvider.listLanguageLevel,
                                selectedListItem: _selectedProficiency,
                              );
                            }).then(
                          (value) {
                            //value = "_id"
                            //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                            if (value != "") {
                              //
                              //ເອົາ _listLanguageLevel ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                              dynamic findValue = reuseTypeProvider
                                  .listLanguageLevel
                                  .firstWhere((i) => i["_id"] == value);

                              setState(() {
                                _selectedProficiency = findValue['_id'];
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
                      validateText:
                          _isValidateValue == true && _selectedProficiency == ""
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

              Divider(color: AppColors.borderGreyOpacity, thickness: 1),

              //
              //
              //Section Button Cancel And Save
              Row(
                children: [
                  // Button Cancel
                  Expanded(
                    child: Button(
                      text: "cancel".tr,
                      textColor: AppColors.fontDark,
                      buttonColor: AppColors.buttonBG,
                      press: widget.onCancel,
                    ),
                  ),

                  Expanded(child: Container()),

                  // Button Save And Next
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
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
                              setState(() {
                                _isValidateValue = false;
                              });
                              pressAddLanguageSkill();
                            }
                          } else {
                            print("invalid validate form");
                            setState(() {
                              _isValidateValue = true;
                            });
                          }
                        },
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
  }
}
