// ignore_for_file: camel_case_types, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_init_to_null, avoid_print, prefer_typing_uninitialized_variables, unused_field, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, prefer_final_fields, prefer_if_null_operators, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/provider/profileProvider.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Language/language.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/boxDecDottedBorderProfileDetail.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FetchLanguage extends StatefulWidget {
  const FetchLanguage({
    Key? key,
    this.pressButtonLeft,
  }) : super(key: key);

  final Function()? pressButtonLeft;

  @override
  State<FetchLanguage> createState() => _FetchLanguageState();
}

class _FetchLanguageState extends State<FetchLanguage> {
  //
  //
  //Language
  Map<String, dynamic>? objLanguageSkill;
  String languageSkillId = "";
  String _languageName = "";
  String _languageLevelName = "";
  bool isShowFormAddLanguageSkill = false;
  bool isShowFormUpdateLanguageSkill = false;

  pressDeleteLanguage(String id) async {
    final profileProvider = context.read<ProfileProvider>();

    // Display AlertDialog Loading First
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    final res = await profileProvider.deleteLanguageSkill(id);

    final statusCode = res?["statusCode"];

    if (!context.mounted) return;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    print("delete language: " + "${res}");

    if (statusCode == 200 || statusCode == 201) {
      await profileProvider.fetchProfileSeeker();
    }
  }

  @override
  void initState() {
    super.initState();

    // getProfileSeeker();
  }

  //error setState() called after dispose(). it can help!!!
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    return Column(
      children: [
        //Display form add language
        if (isShowFormAddLanguageSkill)
          Language(
            onCancel: () {
              setState(() {
                isShowFormAddLanguageSkill = false;
                isShowFormUpdateLanguageSkill = false;
              });
            },
            onSaveSuccess: () async {
              await profileProvider.fetchProfileSeeker();
              setState(() {
                isShowFormAddLanguageSkill = false;
                isShowFormUpdateLanguageSkill = false;
              });
            },
          ),

        //Display form update language
        if (isShowFormUpdateLanguageSkill)
          Language(
            id: languageSkillId,
            language: objLanguageSkill,
            onCancel: () {
              setState(() {
                isShowFormAddLanguageSkill = false;
                isShowFormUpdateLanguageSkill = false;
              });
            },
            onSaveSuccess: () async {
              await profileProvider.fetchProfileSeeker();
              setState(() {
                isShowFormAddLanguageSkill = false;
                isShowFormUpdateLanguageSkill = false;
              });
            },
          ),

        //Display Form List Language
        if (!isShowFormAddLanguageSkill && !isShowFormUpdateLanguageSkill)
          Container(
            color: AppColors.backgroundWhite,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                //
                //
                //ListView Language
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: profileProvider.languageSkill.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: profileProvider.languageSkill.length,
                          itemBuilder: (context, index) {
                            dynamic i = profileProvider.languageSkill[index];
                            _languageName = i['LanguageId']['name'];
                            _languageLevelName = i['LanguageLevelId']['name'];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child:
                                  BoxDecProfileDetailHaveValueWithoutTitleText(
                                widgetColumn: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //
                                    //
                                    //Language name
                                    Text(
                                      _languageName,
                                      style: bodyTextMiniMedium("SatoshiMedium",
                                          null, FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),

                                    //
                                    //
                                    //Language level name
                                    Text(
                                      _languageLevelName,
                                      style: bodyTextMaxSmall(
                                          "SatoshiMedium", null, null),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),

                                //
                                //
                                //Button Left For Update
                                statusLeft: "have",
                                pressLeft: () {
                                  setState(() {
                                    languageSkillId = i["_id"];
                                    objLanguageSkill = i;
                                    isShowFormUpdateLanguageSkill = true;
                                  });
                                },

                                //
                                //
                                //Button Right For Delete
                                statusRight: "have",
                                pressRight: () async {
                                  var result = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                          title: "delete_this_info".tr,
                                          contentText: "language_skill".tr +
                                              ': ${i['LanguageId']['name']}',
                                          textButtonLeft: 'cancel'.tr,
                                          textButtonRight: 'confirm'.tr,
                                          textButtonRightColor:
                                              AppColors.fontWhite,
                                        );
                                      });
                                  if (result == 'Ok') {
                                    print("confirm delete");
                                    pressDeleteLanguage(i['_id']);
                                  }
                                },
                              ),
                            );
                          },
                        )
                      : Text(
                          "u_have_not_add_any".tr,
                          style: bodyTextNormal(null, null, FontWeight.bold),
                        ),
                ),

                //
                //
                // Button Add Language
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Button(
                    buttonColor: AppColors.primary200,
                    text: "add".tr + " " + "language_skill".tr,
                    textFontFamily: "NotoSansLaoLoopedMedium",
                    textColor: AppColors.primary600,
                    press: () {
                      setState(() {
                        isShowFormAddLanguageSkill = true;
                      });
                    },
                  ),
                ),

                Divider(color: AppColors.borderGreyOpacity, thickness: 1),

                //
                //
                // Section Button Skip And Save And Next
                Row(
                  children: [
                    // Button Skip
                    GestureDetector(
                      onTap: widget.pressButtonLeft,
                      child: Container(
                        color: AppColors.backgroundWhite,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Skip for now",
                          style: bodyTextNormal(
                              null, AppColors.fontGreyOpacity, null),
                        ),
                      ),
                    ),

                    Expanded(child: Container()),

                    // Button Save And Next
                    if (profileProvider.languageSkill.isNotEmpty)
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Button(
                            text: "next".tr,
                            textFontWeight: FontWeight.bold,
                            press: widget.pressButtonLeft,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
