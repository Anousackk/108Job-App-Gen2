// ignore_for_file: camel_case_types, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_init_to_null, avoid_print, prefer_typing_uninitialized_variables, unused_field, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, prefer_final_fields

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/WorkHistory/workHistory.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/boxDecDottedBorderProfileDetail.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FetchWorkHistory extends StatefulWidget {
  const FetchWorkHistory({Key? key, this.onGoBack}) : super(key: key);

  final onGoBack;

  @override
  State<FetchWorkHistory> createState() => _FetchWorkHistoryState();
}

class _FetchWorkHistoryState extends State<FetchWorkHistory> {
  //
  //Work History
  List _workHistory = [];
  dynamic _startYearWorkHistory = null;
  dynamic _endYearWorkHistory = null;
  String _company = "";
  String _position = "";
  bool _isLoading = true;

  getProfileSeeker() async {
    var res = await fetchData(getProfileSeekerApi);
    _workHistory = res["workHistory"] ?? [];

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  deleteWorkHistory(String id) async {
    var res = await deleteData(deleteWorkHistorySeekerApi + id);
    print(res);
    if (res['message'] == 'Delete succeed') {
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
        return CustomLoadingLogoCircle();
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
      child: _isLoading
          ? Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
              ),
              body: Container(
                color: AppColors.backgroundWhite,
                width: double.infinity,
                height: double.infinity,
                child: Center(child: CustomLoadingLogoCircle()),
              ),
            )
          : Scaffold(
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
                  //Sectioin
                  //Content work history

                  Expanded(
                    child: Stack(
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
                                //ListView work history
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _workHistory.length,
                                  itemBuilder: (context, index) {
                                    dynamic i = _workHistory[index];

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
                                    _startYearWorkHistory =
                                        formatMonthYear(startYear);

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
                                      _endYearWorkHistory =
                                          formatMonthYear(endYear);
                                    }
                                    _company = i['company'];
                                    _position = i['position'];
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
                                            //Start-End month year
                                            Row(
                                              children: [
                                                Text(
                                                  "${_startYearWorkHistory}",
                                                  style: bodyTextMaxSmall(
                                                      "SatoshiMedium",
                                                      null,
                                                      null),
                                                ),
                                                Text(" - "),
                                                Text(
                                                  "${_endYearWorkHistory ?? 'Now'}",
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
                                            //Position
                                            Text(
                                              _position,
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
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => WorkHistory(
                                                id: i["_id"],
                                                workHistory: i,
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
                                                  contentText:
                                                      "work_history".tr +
                                                          ": ${i['position']}",
                                                  textButtonLeft: 'cancel'.tr,
                                                  textButtonRight: 'confirm'.tr,
                                                  textButtonRightColor:
                                                      AppColors.fontWhite,
                                                );
                                              });
                                          if (result == 'Ok') {
                                            print("confirm delete");
                                            deleteWorkHistory(i['_id']);
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
                        //Button add work history
                        Positioned(
                          bottom: 30,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Button(
                              buttonColor: AppColors.primary200,
                              text: "add".tr + " " + "work_history".tr,
                              textFontFamily: "NotoSansLaoLoopedMedium",
                              textColor: AppColors.primary600,
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkHistory(),
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
