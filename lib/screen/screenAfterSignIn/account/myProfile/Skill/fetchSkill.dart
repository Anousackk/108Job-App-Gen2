// ignore_for_file: camel_case_types, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_init_to_null, avoid_print, prefer_typing_uninitialized_variables, unused_field, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, prefer_final_fields, prefer_if_null_operators, prefer_interpolation_to_compose_strings

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/provider/profileProvider.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Skill/skill.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/boxDecDottedBorderProfileDetail.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FetchSkill extends StatefulWidget {
  const FetchSkill({
    Key? key,
    this.pressButtonLeft,
  }) : super(key: key);

  final Function()? pressButtonLeft;

  @override
  State<FetchSkill> createState() => _FetchSkillState();
}

class _FetchSkillState extends State<FetchSkill> {
  //
  //
  //Skill
  Map<String, dynamic>? objSkill;
  String skillId = "";

  String _skillName = "";
  String _skillLevelName = "";
  bool isShowFormAddSkill = false;
  bool isShowFormUpdateSkill = false;

  pressDeleteSkill(String id) async {
    final profileProvider = context.read<ProfileProvider>();

    // Display AlertDialog Loading First
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    var res = await profileProvider.deleteSkill(id);
    final statusCode = res?["statusCode"];

    if (!context.mounted) return;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    if (statusCode == 200 || statusCode == 201) {
      await profileProvider.fetchProfileSeeker();
    }
  }

  @override
  void initState() {
    super.initState();
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
        //Display form add skill
        if (isShowFormAddSkill)
          Skill(
            onCancel: () {
              setState(() {
                isShowFormAddSkill = false;
                isShowFormUpdateSkill = false;
              });
            },
            onSaveSuccess: () async {
              setState(() {
                isShowFormAddSkill = false;
                isShowFormUpdateSkill = false;
              });
            },
          ),

        //Display form update skill
        if (isShowFormUpdateSkill)
          Skill(
            id: skillId,
            skill: objSkill,
            onCancel: () {
              setState(() {
                isShowFormAddSkill = false;
                isShowFormUpdateSkill = false;
              });
            },
            onSaveSuccess: () async {
              setState(() {
                isShowFormAddSkill = false;
                isShowFormUpdateSkill = false;
              });
            },
          ),

        //Display form list skills
        if (!isShowFormAddSkill && !isShowFormUpdateSkill)
          Container(
            color: AppColors.backgroundWhite,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                //
                //
                //ListView skills
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: profileProvider.skills.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: profileProvider.skills.length,
                          itemBuilder: (context, index) {
                            dynamic i = profileProvider.skills[index];
                            _skillName = i['keySkillId']['name'];
                            _skillLevelName = i['skillLevelId']['name'];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child:
                                  BoxDecProfileDetailHaveValueWithoutTitleText(
                                widgetColumn: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //
                                    //
                                    //Skill name
                                    Text(
                                      _skillName,
                                      style: bodyTextMiniMedium("SatoshiMedium",
                                          null, FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),

                                    //
                                    //
                                    //Skill level name
                                    Text(
                                      _skillLevelName,
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
                                    skillId = i["_id"];
                                    objSkill = i;
                                    isShowFormUpdateSkill = true;
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
                                          contentText: "skills".tr +
                                              ": ${i['keySkillId']['name']}",
                                          textButtonLeft: 'cancel'.tr,
                                          textButtonRight: 'confirm'.tr,
                                          textButtonRightColor:
                                              AppColors.fontWhite,
                                        );
                                      });
                                  if (result == 'Ok') {
                                    print("confirm delete");
                                    pressDeleteSkill(i['_id']);
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

                // Button Add Skill
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Button(
                    buttonColor: AppColors.primary200,
                    text: "add".tr + " " + "skills".tr,
                    textFontFamily: "NotoSansLaoLoopedMedium",
                    textColor: AppColors.primary600,
                    press: () {
                      setState(() {
                        isShowFormAddSkill = true;
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
                    if (profileProvider.skills.isNotEmpty)
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
