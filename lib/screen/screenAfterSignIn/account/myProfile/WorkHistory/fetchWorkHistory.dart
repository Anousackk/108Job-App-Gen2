// ignore_for_file: camel_case_types, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_init_to_null, avoid_print, prefer_typing_uninitialized_variables, unused_field, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, prefer_final_fields, unused_local_variable, prefer_is_empty, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/provider/profileProvider.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/WorkHistory/workHistory.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/boxDecDottedBorderProfileDetail.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FetchWorkHistory extends StatefulWidget {
  const FetchWorkHistory(
      {Key? key, required this.noExperience, this.pressButtonLeft})
      : super(key: key);

  final bool noExperience;
  final Function()? pressButtonLeft;

  @override
  State<FetchWorkHistory> createState() => _FetchWorkHistoryState();
}

class _FetchWorkHistoryState extends State<FetchWorkHistory> {
  //
  //Work History
  Map<String, dynamic>? objWorkHistory;
  String workHistoryId = "";

  dynamic _startYearWorkHistory = null;
  dynamic _endYearWorkHistory = null;
  String _company = "";
  String _position = "";
  bool _isLoading = true;
  bool isShowFormAddWorkHistory = false;
  bool isShowFormUpdateWorkHistory = false;

  pressDeleteWorkHistory(String id) async {
    final profileProvider = context.read<ProfileProvider>();

    // Display AlertDialog Loading First
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    final res = await profileProvider.deleteWorkHistory(id);

    final statusCode = res?["statusCode"];

    if (!context.mounted) return;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    print("delete work history: " + "${res}");

    if (statusCode == 200 || statusCode == 201) {
      await profileProvider.fetchProfileSeeker();
    }
  }

  pressUpdateNoExperience(bool val) async {
    final profileProvider = context.read<ProfileProvider>();

    final res = await profileProvider.updateNoExperience(val);

    final statusCode = res?["statusCode"];

    print("Update No Experience: $res");

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
        //Display form add education
        if (isShowFormAddWorkHistory)
          WorkHistory(
            onCancel: () {
              setState(() {
                isShowFormAddWorkHistory = false;
                isShowFormUpdateWorkHistory = false;
              });
            },
            onSaveSuccess: () async {
              await profileProvider.fetchProfileSeeker();
              setState(() {
                isShowFormAddWorkHistory = false;
                isShowFormUpdateWorkHistory = false;
              });
            },
          ),
        //Display form update education
        if (isShowFormUpdateWorkHistory)
          WorkHistory(
            id: workHistoryId,
            workHistory: objWorkHistory,
            onCancel: () {
              setState(() {
                isShowFormAddWorkHistory = false;
                isShowFormUpdateWorkHistory = false;
              });
            },
            onSaveSuccess: () async {
              await profileProvider.fetchProfileSeeker();
              setState(() {
                isShowFormUpdateWorkHistory = false;
              });
            },
          ),

        if (!isShowFormAddWorkHistory && !isShowFormUpdateWorkHistory)
          Container(
            color: AppColors.backgroundWhite,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                //
                //
                //ListView work history
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: profileProvider.workHistory.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: profileProvider.workHistory.length,
                          itemBuilder: (context, index) {
                            dynamic i = profileProvider.workHistory[index];

                            _startYearWorkHistory = i['startYear'];
                            //pars ISO to Flutter DateTime
                            parsDateTime(
                                value: '',
                                currentFormat: '',
                                desiredFormat: '');
                            DateTime startYear = parsDateTime(
                              value: _startYearWorkHistory,
                              currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                              desiredFormat: "yyyy-MM-dd HH:mm:ss",
                            );
                            _startYearWorkHistory = formatMonthYear(startYear);

                            _endYearWorkHistory = i['endYear'];
                            if (_endYearWorkHistory != null) {
                              //pars ISO to Flutter DateTime
                              parsDateTime(
                                  value: '',
                                  currentFormat: '',
                                  desiredFormat: '');
                              DateTime endYear = parsDateTime(
                                value: _endYearWorkHistory,
                                currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                                desiredFormat: "yyyy-MM-dd HH:mm:ss",
                              );
                              _endYearWorkHistory = formatMonthYear(endYear);
                            }
                            _company = i['company'];
                            _position = i['position'];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child:
                                  BoxDecProfileDetailHaveValueWithoutTitleText(
                                widgetColumn: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //
                                    //
                                    //Start-End month year
                                    Row(
                                      children: [
                                        Text(
                                          "${_startYearWorkHistory}",
                                          style: bodyTextMaxSmall(
                                              "SatoshiMedium", null, null),
                                        ),
                                        Text(" - "),
                                        Text(
                                          "${_endYearWorkHistory ?? 'Now'}",
                                          style: bodyTextMaxSmall(
                                              "SatoshiMedium", null, null),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    //
                                    //
                                    //Position
                                    Text(
                                      _position,
                                      style: bodyTextMiniMedium("SatoshiMedium",
                                          null, FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    //
                                    //
                                    //Compnay
                                    Text(
                                      _company,
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
                                    workHistoryId = i["_id"];
                                    objWorkHistory = i;
                                    isShowFormUpdateWorkHistory = true;
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
                                          contentText: "work_history".tr +
                                              ": ${i['position']}",
                                          textButtonLeft: 'cancel'.tr,
                                          textButtonRight: 'confirm'.tr,
                                          textButtonRightColor:
                                              AppColors.fontWhite,
                                        );
                                      });
                                  if (result == 'Ok') {
                                    print("confirm delete");
                                    pressDeleteWorkHistory(i['_id']);
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
                // Add Work History
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Button(
                    buttonColor: AppColors.primary200,
                    text: "add".tr + " " + "work_history".tr,
                    textFontFamily: "NotoSansLaoLoopedMedium",
                    textColor: AppColors.primary600,
                    press: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => WorkHistory(),
                      //   ),
                      // );
                      setState(() {
                        isShowFormAddWorkHistory = true;
                      });
                    },
                  ),
                ),

                //
                //
                //CheckBox No Experience
                if (profileProvider.workHistory.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // toggle value
                            bool newValue = !profileProvider.isNoExperience;

                            // update using provider setter
                            profileProvider.setIsNoExperience = newValue;

                            pressUpdateNoExperience(newValue);
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: profileProvider.isNoExperience
                                  ? AppColors.iconPrimary
                                  : AppColors.iconLight,
                              border: Border.all(
                                  color: profileProvider.isNoExperience
                                      ? AppColors.borderPrimary
                                      : AppColors.borderDark),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: profileProvider.isNoExperience
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
                        Text(
                          "button_no_experience".tr,
                          style: bodyTextNormal(null, null, FontWeight.bold),
                        ),
                      ],
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
                    if (profileProvider.workHistory.isNotEmpty ||
                        profileProvider.isNoExperience)
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
