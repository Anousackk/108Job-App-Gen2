// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, prefer_if_null_operators, non_constant_identifier_names, unused_local_variable, unused_field, unnecessary_string_interpolations, prefer_final_fields, unnecessary_null_in_if_null_operators

import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/screenAfterSignIn/account/loginInfo/loginInformation.dart';
import 'package:app/screen/screenAfterSignIn/account/myProfile/myProfile.dart';
import 'package:app/widget/input.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

class Account extends StatefulWidget {
  const Account({Key? key, this.callback}) : super(key: key);
  final VoidCallback? callback;

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  dynamic _seekerProfile;
  String _firstName = "";
  String _lastName = "";
  String _imageSrc = "";
  String _memberLevel = "";
  String _currentJobTitle = "";

  dynamic _workPreferences;

  bool _isLoading = false;

  getProfileSeeker() async {
    var res = await fetchData(getProfileSeekerApi);
    _seekerProfile = res['profile'];
    _firstName = _seekerProfile['firstName'];
    _lastName = _seekerProfile['lastName'];
    _memberLevel = _seekerProfile['memberLevel'];
    if (_seekerProfile['file'] != "") {
      _imageSrc = !_seekerProfile['file'].containsKey("src") ||
              _seekerProfile['file']["src"] == null
          ? ""
          : _seekerProfile['file']["src"];
    }

    _workPreferences = res['workPreferences'] ?? null;
    if (_workPreferences != null) {
      _currentJobTitle = _workPreferences['currentJobTitle'];
    }

    _isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    getProfileSeeker();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: AppColors.backgroundAppBar,
        ),
        body: SafeArea(
          child: _isLoading
              ? Container(
                  color: AppColors.background,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      //
                      //
                      //Profile Image
                      Container(
                        color: AppColors.primary,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  //
                                  //
                                  //Placeholder circle for profile picture
                                  DottedBorder(
                                    dashPattern: [6, 7],
                                    strokeWidth: 2,
                                    borderType: BorderType.Circle,
                                    color: AppColors.borderWhite,
                                    borderPadding: EdgeInsets.all(1),
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.greyOpacity,
                                        image: _imageSrc == ""
                                            ? DecorationImage(
                                                image: AssetImage(
                                                    'assets/image/def-profile.png'),
                                                fit: BoxFit.cover,
                                              )
                                            : DecorationImage(
                                                image: NetworkImage(_imageSrc),
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      // child: CircleAvatar(
                                      //   radius: 90,
                                      //   backgroundImage:
                                      //       AssetImage('assets/image/def-profile.png'),
                                      // ),
                                    ),
                                  ),
                                  //
                                  //
                                  //Status Seeker on top profile image
                                  Positioned(
                                    top: -20,
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.success,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        _memberLevel,
                                        style:
                                            bodyTextSmall(AppColors.fontWhite),
                                      ),
                                    ),
                                  ),

                                  //
                                  //
                                  //Camera icon at the bottom right corner
                                  // Positioned(
                                  //   bottom: 0,
                                  //   right: 0,
                                  //   child: Container(
                                  //     alignment: Alignment.center,
                                  //     padding: EdgeInsets.all(8),
                                  //     decoration: BoxDecoration(
                                  //       shape: BoxShape.circle,
                                  //       color: AppColors.grey,
                                  //       border:
                                  //           Border.all(color: AppColors.borderWhite),
                                  //     ),
                                  //     child: FaIcon(
                                  //       FontAwesomeIcons.camera,
                                  //       color: AppColors.iconLight,
                                  //       size: 15,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            //
                            //
                            //Profile Name
                            Text(
                              "${_firstName} ${_lastName}",
                              style: bodyTextMedium(
                                  AppColors.fontWhite, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              _currentJobTitle == ""
                                  ? "- -"
                                  : "${_currentJobTitle}",
                              style: bodyTextNormal(AppColors.fontWhite, null),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),

                      //
                      //
                      //Profile Statisics
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            //
                            //
                            //Profile Statisics
                            Text(
                              "Profile Statisics",
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: widget.callback,
                                    child: StatisicBox(
                                      boxColor: AppColors.lightPrimary,
                                      amount: "100",
                                      text: "Saved Job",
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: StatisicBox(
                                    boxColor: AppColors.lightGrayishCyan,
                                    amount: "13",
                                    text: "Company viewed your profile",
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: StatisicBox(
                                    boxColor: AppColors.lightOrange,
                                    amount: "30",
                                    text: "Applied Job",
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: StatisicBox(
                                    boxColor: AppColors.lightGreen,
                                    amount: "30",
                                    text: "Submited General CV",
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20),

                            //
                            //
                            //Account Setting
                            Text(
                              "Account Setting",
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(height: 10),

                            //
                            //
                            //Login Information
                            BoxDecorationInput(
                              boxDecBorderRadius: BorderRadius.circular(10),
                              widgetFaIcon: FaIcon(
                                FontAwesomeIcons.lock,
                                size: 20,
                                color: AppColors.iconGray,
                              ),
                              // paddingFaIcon: EdgeInsets.only(left: 20, right: 10),
                              mainAxisAlignmentTextIcon:
                                  MainAxisAlignment.start,
                              text: "Login Information",
                              widgetIconActive: FaIcon(
                                FontAwesomeIcons.chevronRight,
                                color: AppColors.iconGrayOpacity,
                                size: IconSize.sIcon,
                              ),
                              validateText: Container(),
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginInformation(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 5),

                            //
                            //
                            //My Profile
                            BoxDecorationInput(
                              boxDecBorderRadius: BorderRadius.circular(10),
                              widgetFaIcon: FaIcon(
                                FontAwesomeIcons.solidUser,
                                size: 20,
                                color: AppColors.iconGray,
                              ),
                              // paddingFaIcon: EdgeInsets.only(left: 20, right: 10),
                              mainAxisAlignmentTextIcon:
                                  MainAxisAlignment.start,
                              text: "My Profile",
                              widgetIconActive: FaIcon(
                                FontAwesomeIcons.chevronRight,
                                color: AppColors.iconGrayOpacity,
                                size: IconSize.sIcon,
                              ),
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyProfile(),
                                  ),
                                );
                              },
                              validateText: Container(),
                            ),
                            SizedBox(height: 5),

                            //
                            //
                            //Job Alert
                            BoxDecorationInput(
                              boxDecBorderRadius: BorderRadius.circular(10),
                              widgetFaIcon: FaIcon(
                                FontAwesomeIcons.solidBell,
                                size: 20,
                                color: AppColors.iconGray,
                              ),
                              // paddingFaIcon: EdgeInsets.only(left: 20, right: 10),
                              mainAxisAlignmentTextIcon:
                                  MainAxisAlignment.start,
                              press: () {},
                              text: "Job Alert",
                              widgetIconActive: FaIcon(
                                FontAwesomeIcons.chevronRight,
                                color: AppColors.iconGrayOpacity,
                                size: IconSize.sIcon,
                              ),
                              validateText: Container(),
                            ),
                            SizedBox(height: 5),

                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class StatisicBox extends StatelessWidget {
  const StatisicBox({
    Key? key,
    this.amount,
    this.text,
    this.boxColor,
  }) : super(key: key);
  final String? amount, text;
  final Color? boxColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: boxDecoration(BorderRadius.circular(2.w),
          boxColor == null ? AppColors.lightPrimary : boxColor, null),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${amount}",
            style: bodyTextMaxMedium(null, FontWeight.bold),
          ),
          Text(
            "${text}",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          )
        ],
      ),
    );
  }
}
