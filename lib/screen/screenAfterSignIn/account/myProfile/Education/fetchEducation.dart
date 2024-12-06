// ignore_for_file: camel_case_types, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_init_to_null, avoid_print, prefer_typing_uninitialized_variables, unused_field, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, prefer_final_fields, prefer_if_null_operators

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Education/education.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/boxDecDottedBorderProfileDetail.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FetchEducation extends StatefulWidget {
  const FetchEducation({Key? key, this.onGoBack}) : super(key: key);

  final onGoBack;

  @override
  State<FetchEducation> createState() => _FetchEducationState();
}

class _FetchEducationState extends State<FetchEducation> {
  //
  //
  //Education
  List _education = [];
  dynamic _startYearEducation;
  dynamic _endYearWorkEducation;
  String _qualificationName = "";
  String _collage = "";
  String _subject = "";
  bool _isLoading = true;

  getProfileSeeker() async {
    var res = await fetchData(getProfileSeekerApi);
    _education = res["education"] ?? [];

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  deleteEducation(String id) async {
    var res = await deleteData(deleteEducationSeekerApi + id);
    print(res);
    if (res['message'] == 'Delete succeed') {
      //
      //ສະແດງ AlertDialog Loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustAlertLoading();
        },
      );
      await getProfileSeeker();
      Navigator.pop(context);
    }
    setState(() {});
  }

  onGoBack(dynamic value) async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustAlertLoading();
      },
    );
    await getProfileSeeker();
    Navigator.pop(context);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    getProfileSeeker();
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: AppColors.primary600,
        ),
        body: SafeArea(
            child: Column(
          children: [
            //
            //
            //
            //
            //
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
                "education".tr,
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
            //Sectioin
            //Content work history

            Expanded(
              child: _isLoading
                  ? Container(
                      color: AppColors.backgroundWhite,
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Container(
                            // color: AppColors.red,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                //
                                //
                                //ListView education
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _education.length,
                                  itemBuilder: (context, index) {
                                    dynamic i = _education[index];
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
                                    _qualificationName =
                                        i['qualifications']['name'];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child:
                                          BoxDecProfileDetailHaveValueWithoutTitleText(
                                        widgetColumn: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //
                                            //
                                            //Start-End year
                                            Row(
                                              children: [
                                                Text(
                                                  "${_startYearEducation}",
                                                  style: bodyTextMaxSmall(
                                                      "SatoshiMedium",
                                                      null,
                                                      null),
                                                ),
                                                Text(" - "),
                                                Text(
                                                  "${_endYearWorkEducation}",
                                                  style: bodyTextMaxSmall(
                                                      "SatoshiMedium",
                                                      null,
                                                      null),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            //
                                            //
                                            //Qualification name
                                            Text(
                                              _qualificationName,
                                              style: bodyTextMiniMedium(
                                                  "SatoshiMedium",
                                                  null,
                                                  FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            //
                                            //
                                            //Subject
                                            Text(
                                              _subject,
                                              style: bodyTextMaxSmall(
                                                  "SatoshiMedium", null, null),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
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
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Education(
                                                id: i["_id"],
                                                education: i,
                                              ),
                                            ),
                                          ).then((val) {
                                            print(val);
                                            if (val == "Submitted") {
                                              onGoBack(val);
                                            }
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
                                            deleteEducation(i['_id']);
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 100,
                                )
                              ],
                            ),
                          ),
                        ),

                        //
                        //
                        //Button add education
                        Positioned(
                          bottom: 30,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Button(
                              buttonColor: AppColors.primary200,
                              text: "add".tr + " " + 'education'.tr,
                              textFontFamily: "NotoSansLaoLoopedMedium",
                              textColor: AppColors.primary600,
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Education(),
                                  ),
                                ).then((val) {
                                  if (val == "Submitted") {
                                    onGoBack(val);
                                  }
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          ],
        )),
      ),
    );
  }
}
