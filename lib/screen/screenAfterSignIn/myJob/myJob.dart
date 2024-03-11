// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_local_variable

import 'package:app/functions/colors.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

class MyJobs extends StatefulWidget {
  const MyJobs({Key? key}) : super(key: key);

  @override
  State<MyJobs> createState() => _MyJobsState();
}

class _MyJobsState extends State<MyJobs> {
  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScopeNode();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: GestureDetector(
        onTap: () {
          currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            // setState(() {
            //   _isFocusIconColorTelAndEmail = false;
            // });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: AppColors.white,
          ),
          body: SafeArea(
            child: Container(
              color: AppColors.background,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    // SizedBox(
                    //   height: 20,
                    // ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.borderSecondary),
                        ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 17, vertical: 10),
                              decoration: BoxDecoration(
                                  color: AppColors.buttonPrimary,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Saved Job",
                                style: bodyTextNormal(
                                    AppColors.fontWhite, FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 17, vertical: 10),
                              decoration: BoxDecoration(
                                  color: AppColors.buttonGrey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Applied Job",
                                style: bodyTextNormal(
                                    AppColors.fontGreyOpacity, FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 17, vertical: 10),
                              decoration: BoxDecoration(
                                  color: AppColors.buttonGrey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Job Alert",
                                style: bodyTextNormal(
                                    AppColors.fontGreyOpacity, FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 17, vertical: 10),
                              decoration: BoxDecoration(
                                  color: AppColors.buttonGrey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Hidded Job",
                                style: bodyTextNormal(
                                    AppColors.fontGreyOpacity, FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      // color: AppColors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          //
                          //
                          //Search and Filter
                          Row(
                            children: [
                              //
                              //
                              //Search keywords
                              Expanded(
                                flex: 8,
                                child: SimpleTextFieldSingleValidate(
                                  hintText: 'Search keywords',
                                  inputColor: AppColors.inputWhite,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              //
                              //
                              //BoxDecoration Filter
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: BoxDecorationInput(
                                    boxDecBorderRadius:
                                        BorderRadius.circular(10),
                                    colorInput: AppColors.inputGrey,
                                    widgetFaIcon: FaIcon(
                                      FontAwesomeIcons.barsStaggered,
                                      size: 20,
                                      color: AppColors.iconGray,
                                    ),
                                    paddingFaIcon:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    mainAxisAlignmentTextIcon:
                                        MainAxisAlignment.center,
                                    text: "Filter",
                                    colorText: AppColors.fontGrey,
                                    validateText: Container(),
                                    press: () async {
                                      //
                                      //
                                      //Alert Dialog Filter
                                      var result = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            titlePadding: EdgeInsets.zero,
                                            contentPadding: EdgeInsets.zero,
                                            insetPadding: EdgeInsets.zero,
                                            actionsPadding: EdgeInsets.zero,

                                            //
                                            //
                                            //Title Filter Alert
                                            title: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 15),
                                              decoration: BoxDecoration(
                                                  color:
                                                      AppColors.backgroundWhite,
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: AppColors
                                                          .borderSecondary,
                                                    ),
                                                  )),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .arrowLeft,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 15),
                                                        child: Text(
                                                          "Filter",
                                                          style: bodyTextMedium(
                                                              null,
                                                              FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            //
                                            //
                                            //Content Filter Alert
                                            content: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                              color: AppColors.backgroundWhite,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //
                                                    //
                                                    //Sort By
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 10),
                                                          child: Text(
                                                            "Sort By",
                                                            style:
                                                                bodyTextNormal(
                                                                    null,
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            //
                                                            //Post Date Lastest
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          10),
                                                              decoration:
                                                                  boxDecoration(
                                                                null,
                                                                AppColors.light,
                                                                AppColors.light,
                                                              ),
                                                              child: Text(
                                                                "Post Date (Lastest)",
                                                                style: bodyTextNormal(
                                                                    null,
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            //
                                                            //Post date Oldest
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          10),
                                                              decoration:
                                                                  boxDecoration(
                                                                null,
                                                                AppColors.light,
                                                                AppColors.light,
                                                              ),
                                                              child: Text(
                                                                "Post Date (Oldest)",
                                                                style: bodyTextNormal(
                                                                    null,
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),

                                                    //
                                                    //
                                                    //Education Level
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 10),
                                                          child: Text(
                                                            "Education Level",
                                                            style:
                                                                bodyTextNormal(
                                                                    null,
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            //
                                                            //High School
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          10),
                                                              decoration:
                                                                  boxDecoration(
                                                                null,
                                                                AppColors.light,
                                                                AppColors.light,
                                                              ),
                                                              child: Text(
                                                                "High School",
                                                                style: bodyTextNormal(
                                                                    null,
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),

                                                            //
                                                            //Higher Diploma
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          10),
                                                              decoration:
                                                                  boxDecoration(
                                                                null,
                                                                AppColors.light,
                                                                AppColors.light,
                                                              ),
                                                              child: Text(
                                                                "Higher Diploma",
                                                                style: bodyTextNormal(
                                                                    null,
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            //
                                                            //Bachelor Degree
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          10),
                                                              decoration:
                                                                  boxDecoration(
                                                                null,
                                                                AppColors.light,
                                                                AppColors.light,
                                                              ),
                                                              child: Text(
                                                                "Bachelor Degree",
                                                                style: bodyTextNormal(
                                                                    null,
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),

                                                            //
                                                            //Master Degree
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          10),
                                                              decoration:
                                                                  boxDecoration(
                                                                null,
                                                                AppColors.light,
                                                                AppColors.light,
                                                              ),
                                                              child: Text(
                                                                "Master Degree",
                                                                style: bodyTextNormal(
                                                                    null,
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            //
                                                            //Not Specific
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          10),
                                                              decoration:
                                                                  boxDecoration(
                                                                null,
                                                                AppColors.light,
                                                                AppColors.light,
                                                              ),
                                                              child: Text(
                                                                "Not Specific",
                                                                style: bodyTextNormal(
                                                                    null,
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),

                                                    //
                                                    //
                                                    //Job Function
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      child: Text(
                                                        "Job Function",
                                                        style: bodyTextNormal(
                                                            null,
                                                            FontWeight.bold),
                                                      ),
                                                    ),
                                                    BoxDecorationInput(
                                                      colorInput: AppColors
                                                          .backgroundWhite,
                                                      colorBorder: AppColors
                                                          .borderSecondary,
                                                      text:
                                                          "Select Job Function",
                                                      widgetIconActive: FaIcon(
                                                        FontAwesomeIcons
                                                            .caretDown,
                                                        size: 20,
                                                        color: AppColors
                                                            .iconSecondary,
                                                      ),
                                                      paddingFaIcon:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      mainAxisAlignmentTextIcon:
                                                          MainAxisAlignment
                                                              .start,
                                                      press: () {},
                                                      validateText: Container(),
                                                    ),
                                                    SizedBox(height: 5),

                                                    //
                                                    //
                                                    //Work Location
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      child: Text(
                                                        "Work Location",
                                                        style: bodyTextNormal(
                                                            null,
                                                            FontWeight.bold),
                                                      ),
                                                    ),
                                                    BoxDecorationInput(
                                                      colorInput: AppColors
                                                          .backgroundWhite,
                                                      colorBorder: AppColors
                                                          .borderSecondary,
                                                      text:
                                                          "Select Work Location",
                                                      widgetIconActive: FaIcon(
                                                          FontAwesomeIcons
                                                              .caretDown,
                                                          size: 20,
                                                          color: AppColors
                                                              .iconSecondary),
                                                      paddingFaIcon:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      mainAxisAlignmentTextIcon:
                                                          MainAxisAlignment
                                                              .start,
                                                      press: () {},
                                                      validateText: Container(),
                                                    ),
                                                    SizedBox(height: 5),

                                                    //
                                                    //
                                                    //Language
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      child: Text(
                                                        "Language",
                                                        style: bodyTextNormal(
                                                            null,
                                                            FontWeight.bold),
                                                      ),
                                                    ),
                                                    BoxDecorationInput(
                                                      colorInput: AppColors
                                                          .backgroundWhite,
                                                      colorBorder: AppColors
                                                          .borderSecondary,
                                                      text: "Select Language",
                                                      widgetIconActive: FaIcon(
                                                          FontAwesomeIcons
                                                              .caretDown,
                                                          size: 20,
                                                          color: AppColors
                                                              .iconSecondary),
                                                      paddingFaIcon:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      mainAxisAlignmentTextIcon:
                                                          MainAxisAlignment
                                                              .start,
                                                      press: () {},
                                                      validateText: Container(),
                                                    ),
                                                    SizedBox(height: 5),

                                                    //
                                                    //
                                                    //Industry
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      child: Text(
                                                        "Industry",
                                                        style: bodyTextNormal(
                                                            null,
                                                            FontWeight.bold),
                                                      ),
                                                    ),
                                                    BoxDecorationInput(
                                                      colorInput: AppColors
                                                          .backgroundWhite,
                                                      colorBorder: AppColors
                                                          .borderSecondary,
                                                      text: "Select Industry",
                                                      widgetIconActive: FaIcon(
                                                          FontAwesomeIcons
                                                              .caretDown,
                                                          size: 20,
                                                          color: AppColors
                                                              .iconSecondary),
                                                      paddingFaIcon:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      mainAxisAlignmentTextIcon:
                                                          MainAxisAlignment
                                                              .start,
                                                      press: () {},
                                                      validateText: Container(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 20),
                                                color:
                                                    AppColors.backgroundWhite,
                                                child: Button(
                                                  text: "Apply",
                                                  press: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),

                          //
                          //
                          //Count Jobs available
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              children: [
                                Text(
                                  "10",
                                  style: bodyTextNormal(
                                      AppColors.fontPrimary, FontWeight.bold),
                                ),
                                Text(
                                  " Job you have saved",
                                  style: bodyTextNormal(null, FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          //
                          //
                          //All Jobs available
                          Container(
                            height: 250,
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.only(bottom: 15),
                            decoration: boxDecoration(
                                null, AppColors.backgroundWhite, null),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //
                                //
                                //Logo Company and Status
                                Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //
                                      //Logo Company
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 75,
                                              height: 75,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                      AppColors.borderSecondary,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppColors.greyWhite,
                                              ),
                                            ),
                                            SizedBox(width: 25),
                                            Column(
                                              children: [
                                                Text("10 Days ago"),
                                                Text("3000 Views"),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),

                                      //
                                      //Status
                                      Container(
                                        alignment: Alignment.topCenter,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          "New",
                                          style: bodyTextSmall(
                                              AppColors.fontWhite),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                //
                                //Position
                                Text(
                                  "Excel Data Management and Database Developer",
                                  style: bodyTextMedium(null, FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                //
                                //Company Name
                                Row(children: [
                                  FaIcon(
                                    FontAwesomeIcons.building,
                                    size: 15,
                                    color: AppColors.iconGrayOpacity,
                                  ),
                                  Text("  Company Name",
                                      style: bodyTextSmall(null)),
                                ]),

                                //
                                //Work Location
                                Row(children: [
                                  FaIcon(
                                    FontAwesomeIcons.locationDot,
                                    size: 15,
                                    color: AppColors.iconGrayOpacity,
                                  ),
                                  Text("  Work Location",
                                      style: bodyTextSmall(null)),
                                ]),

                                //
                                //Start Date to End Date
                                Row(children: [
                                  FaIcon(
                                    FontAwesomeIcons.calendarWeek,
                                    size: 15,
                                    color: AppColors.iconGrayOpacity,
                                  ),
                                  Text('  01 Nov 2023',
                                      style: bodyTextSmall(null)),
                                  Text(' - '),
                                  Text("15 Dec 2023",
                                      style: bodyTextSmall(null))
                                ])
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  height: 250,
                                  padding: EdgeInsets.all(15),
                                  // margin: EdgeInsets.only(bottom: 15),
                                  decoration: boxDecoration(
                                      null, AppColors.backgroundWhite, null),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //
                                      //
                                      //Logo Company and Status
                                      Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //
                                            //Logo Company
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 75,
                                                    height: 75,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: AppColors
                                                            .borderSecondary,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          AppColors.greyWhite,
                                                    ),
                                                  ),
                                                  SizedBox(width: 25),
                                                  Column(
                                                    children: [
                                                      Text("10 Days ago"),
                                                      Text("3000 Views"),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),

                                            //
                                            //Status
                                            Container(
                                              alignment: Alignment.topCenter,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: AppColors.greyOpacity,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                "Reead",
                                                style: bodyTextSmall(
                                                    AppColors.fontGreyOpacity),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      //
                                      //Position
                                      Text(
                                        "Excel Data Management and Database Developer",
                                        style: bodyTextMedium(
                                            null, FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      //
                                      //Company Name
                                      Row(children: [
                                        FaIcon(
                                          FontAwesomeIcons.building,
                                          size: 15,
                                          color: AppColors.iconGrayOpacity,
                                        ),
                                        Text("  Company Name",
                                            style: bodyTextSmall(null)),
                                      ]),

                                      //
                                      //Work Location
                                      Row(children: [
                                        FaIcon(
                                          FontAwesomeIcons.locationDot,
                                          size: 15,
                                          color: AppColors.iconGrayOpacity,
                                        ),
                                        Text("  Work Location",
                                            style: bodyTextSmall(null)),
                                      ]),

                                      //
                                      //Start Date to End Date
                                      Row(children: [
                                        FaIcon(
                                          FontAwesomeIcons.calendarWeek,
                                          size: 15,
                                          color: AppColors.iconGrayOpacity,
                                        ),
                                        Text('  01 Nov 2023',
                                            style: bodyTextSmall(null)),
                                        Text(' - '),
                                        Text("15 Dec 2023",
                                            style: bodyTextSmall(null))
                                      ])
                                    ],
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    width: double.infinity,
                                    height: 250,
                                    decoration: boxDecoration(null,
                                        AppColors.dark.withOpacity(0.5), null),
                                  ),
                                ),
                                Positioned(
                                  // bottom: null,
                                  // right: 50.w,
                                  // left: 50.w,
                                  // top: null,
                                  child: Container(
                                    width: 50.w,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: AppColors.backgroundWhite,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "This job has expired ",
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "View",
                                              style: TextStyle(
                                                color: AppColors.fontPrimary,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
