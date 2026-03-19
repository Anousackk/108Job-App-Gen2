// ignore_for_file: camel_case_types, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_init_to_null, avoid_print, prefer_typing_uninitialized_variables, unused_field, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, prefer_final_fields, prefer_if_null_operators, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/provider/profileProvider.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Education/education.dart';
import 'package:app/widget/boxDecDottedBorderProfileDetail.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FetchEducation extends StatefulWidget {
  const FetchEducation({Key? key, this.pressButtonLeft}) : super(key: key);

  final Function()? pressButtonLeft;

  @override
  State<FetchEducation> createState() => _FetchEducationState();
}

class _FetchEducationState extends State<FetchEducation> {
  //
  //
  //Education
  Map<String, dynamic>? objEducation;
  String educationId = "";

  dynamic _startYearEducation;
  dynamic _endYearWorkEducation;
  String _qualificationName = "";
  String _collage = "";
  String _subject = "";
  bool _isLoading = true;
  bool isShowFormAddEducation = false;
  bool isShowFormUpdateEducation = false;

  pressDeleteEducation(String id) async {
    final profileProvider = context.read<ProfileProvider>();

    // Display AlertDialog Loading First
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    final res = await profileProvider.deleteEducation(id);

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
        //Display form add education
        if (isShowFormAddEducation)
          Education(
            onCancel: () {
              setState(() {
                isShowFormAddEducation = false;
                isShowFormUpdateEducation = false;
              });
            },
            onSaveSuccess: () async {
              setState(() {
                isShowFormAddEducation = false;
                isShowFormUpdateEducation = false;
              });
            },
          ),

        //Display form update education
        if (isShowFormUpdateEducation)
          Education(
            id: educationId,
            education: objEducation,
            onCancel: () {
              setState(() {
                isShowFormAddEducation = false;
                isShowFormUpdateEducation = false;
              });
            },
            onSaveSuccess: () async {
              setState(() {
                isShowFormAddEducation = false;
                isShowFormUpdateEducation = false;
              });
            },
          ),

        //Display form list education
        if (!isShowFormAddEducation && !isShowFormUpdateEducation)
          Container(
            color: AppColors.backgroundWhite,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                //
                //
                //ListView education
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: profileProvider.education.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: profileProvider.education.length,
                          itemBuilder: (context, index) {
                            dynamic i = profileProvider.education[index];
                            DateTime dateTimeNow = DateTime.now();
                            DateTime utcNow = dateTimeNow.toUtc();
                            dynamic formattedStartDateUtc =
                                DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                                    .format(utcNow);
                            dynamic formattedEndDateUtc =
                                DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                                    .format(utcNow);

                            _startYearEducation = i['startYear'] == null
                                ? formattedStartDateUtc
                                : i['startYear'];
                            //pars ISO to Flutter DateTime
                            parsDateTime(
                                value: '',
                                currentFormat: '',
                                desiredFormat: '');
                            DateTime startYear = parsDateTime(
                              value: _startYearEducation,
                              currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                              desiredFormat: "yyyy-MM-dd HH:mm:ss",
                            );
                            _startYearEducation = formatYear(startYear);

                            _endYearWorkEducation = i['endYear'] == null
                                ? formattedEndDateUtc
                                : i['endYear'];
                            //pars ISO to Flutter DateTime
                            parsDateTime(
                                value: '',
                                currentFormat: '',
                                desiredFormat: '');
                            DateTime endYear = parsDateTime(
                              value: _endYearWorkEducation,
                              currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                              desiredFormat: "yyyy-MM-dd HH:mm:ss",
                            );
                            _endYearWorkEducation = formatYear(endYear);
                            _collage = i['school'];
                            _subject = i['subject'];
                            _qualificationName = i['qualifications']['name'];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child:
                                  BoxDecProfileDetailHaveValueWithoutTitleText(
                                widgetColumn: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //
                                    //
                                    //Start-End year
                                    Row(
                                      children: [
                                        Text(
                                          "${_startYearEducation}",
                                          style: bodyTextMaxSmall(
                                              "SatoshiMedium", null, null),
                                        ),
                                        Text(" - "),
                                        Text(
                                          "${_endYearWorkEducation}",
                                          style: bodyTextMaxSmall(
                                              "SatoshiMedium", null, null),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5),

                                    //
                                    //
                                    //Qualification name
                                    Text(
                                      _qualificationName,
                                      style: bodyTextMiniMedium("SatoshiMedium",
                                          null, FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),

                                    //
                                    //
                                    //Subject
                                    Text(
                                      _subject,
                                      style: bodyTextMaxSmall(
                                          "SatoshiMedium", null, null),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),

                                    //
                                    //
                                    //Collage
                                    Text(
                                      _collage,
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
                                    educationId = i["_id"];
                                    objEducation = i;
                                    isShowFormUpdateEducation = true;
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
                                          contentText: "education".tr +
                                              ": ${i['qualifications']['name']}",
                                          textButtonLeft: 'cancel'.tr,
                                          textButtonRight: 'confirm'.tr,
                                          textButtonRightColor:
                                              AppColors.fontWhite,
                                        );
                                      });
                                  if (result == 'Ok') {
                                    print("confirm delete");
                                    pressDeleteEducation(i['_id']);
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
                // Button Add Education
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Button(
                    buttonColor: AppColors.primary200,
                    text: "add".tr + " " + 'education'.tr,
                    textFontFamily: "NotoSansLaoLoopedMedium",
                    textColor: AppColors.primary600,
                    press: () {
                      setState(() {
                        isShowFormAddEducation = true;
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
                    if (profileProvider.education.isNotEmpty)
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
