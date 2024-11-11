// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, prefer_if_null_operators, non_constant_identifier_names, unused_local_variable, unused_field, unnecessary_string_interpolations, prefer_final_fields, unnecessary_null_in_if_null_operators

import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/screenAfterSignIn/account/jobAlert/jobAlert.dart';
import 'package:app/screen/screenAfterSignIn/account/loginInfo/loginInformation.dart';
import 'package:app/screen/screenAfterSignIn/account/myProfile/myProfile.dart';
import 'package:app/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Account extends StatefulWidget {
  const Account(
      {Key? key,
      this.callBackToMyJobsSavedJob,
      this.callBackToMyJobsAppliedJob})
      : super(key: key);
  final VoidCallback? callBackToMyJobsSavedJob;
  final Function(dynamic)? callBackToMyJobsAppliedJob;

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
  int _savedJobs = 0;
  int _appliedJobs = 0;
  int _epmSavedSeeker = 0;
  int _submitedCV = 0;

  dynamic _workPreferences;

  bool _isLoading = true;

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

  getTotalJobSeeker() async {
    var res = await fetchData(getTotalMyJobSeekerApi);

    _savedJobs = int.parse(res['saveJobTotals'].toString());
    _appliedJobs = int.parse(res['appliedJobTotals'].toString());
    _submitedCV = int.parse(res['submittedTotals'].toString());
    _epmSavedSeeker = int.parse(res['empViewTotals'].toString());

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getProfileSeeker();
    getTotalJobSeeker();
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
        // appBar: AppBar(
        //   toolbarHeight: 0,
        //   systemOverlayStyle: SystemUiOverlayStyle.light,
        //   backgroundColor: AppColors.backgroundAppBar,
        // ),
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
                      //
                      //
                      //
                      //
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
                                  // DottedBorder(
                                  // dashPattern: [6, 7],
                                  // strokeWidth: 2,
                                  // borderType: BorderType.Circle,
                                  // color: AppColors.borderWhite,
                                  // borderPadding: EdgeInsets.all(1),
                                  Container(
                                    width: 150,
                                    height: 150,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: _imageSrc == ""
                                          ? Image.asset(
                                              'assets/image/defprofile.jpg',
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              "${_imageSrc}",
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/image/defprofile.jpg',
                                                  fit: BoxFit.cover,
                                                ); // Display an error message
                                              },
                                            ),
                                    ),

                                    // decoration: BoxDecoration(
                                    //   shape: BoxShape.circle,
                                    //   color: AppColors.greyOpacity,
                                    //   image: _imageSrc == ""
                                    //       ? DecorationImage(
                                    //           image: AssetImage(
                                    //               'assets/image/def-profile.png'),
                                    //           fit: BoxFit.cover,
                                    //         )
                                    //       : DecorationImage(
                                    //           image: NetworkImage(_imageSrc),
                                    //           fit: BoxFit.cover,
                                    //         ),
                                    // ),

                                    // child: CircleAvatar(
                                    //   radius: 90,
                                    //   backgroundImage:
                                    //       AssetImage('assets/image/def-profile.png'),
                                    // ),
                                  ),
                                  // ),
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
                                        style: bodyTextSmall(
                                            null, AppColors.fontWhite, null),
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
                                  null, AppColors.fontWhite, FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              _currentJobTitle == ""
                                  ? "- -"
                                  : "${_currentJobTitle}",
                              style: bodyTextNormal(
                                  null, AppColors.fontWhite, null),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),

                      //
                      //
                      //
                      //
                      //
                      //
                      //
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
                              "profile".tr,
                              style:
                                  bodyTextNormal(null, null, FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: widget.callBackToMyJobsSavedJob,
                                    child: StatisicBox(
                                      boxColor: AppColors.lightPrimary,
                                      amount: "${_savedJobs}",
                                      text: "saved job".tr,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: StatisicBox(
                                    boxColor: AppColors.lightGrayishCyan,
                                    amount: "${_epmSavedSeeker}",
                                    text: "company view profile".tr,
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
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.callBackToMyJobsAppliedJob!(
                                            "AppliedJob");
                                      });
                                    },
                                    child: StatisicBox(
                                      boxColor: AppColors.lightOrange,
                                      amount: "${_appliedJobs}",
                                      text: "applied job".tr,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: StatisicBox(
                                    boxColor: AppColors.lightGreen,
                                    amount: "${_submitedCV}",
                                    text: "submitted cv".tr,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20),

                            //
                            //
                            //
                            //
                            //
                            //
                            //Account Setting
                            Text(
                              "account setting".tr,
                              style:
                                  bodyTextNormal(null, null, FontWeight.bold),
                            ),
                            SizedBox(height: 10),

                            //
                            //
                            //
                            //
                            //
                            //Login Information
                            BoxDecorationInput(
                              boxDecBorderRadius: BorderRadius.circular(10),
                              colorInput: AppColors.buttonGrey,
                              widgetFaIcon: FaIcon(
                                FontAwesomeIcons.lock,
                                size: IconSize.xsIcon,
                              ),
                              // paddingFaIcon: EdgeInsets.only(left: 20, right: 10),
                              mainAxisAlignmentTextIcon:
                                  MainAxisAlignment.start,
                              text: "login info".tr,
                              widgetIconActive: FaIcon(
                                FontAwesomeIcons.chevronRight,
                                size: IconSize.xsIcon,
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
                            //
                            //
                            //
                            //My Profile
                            BoxDecorationInput(
                              boxDecBorderRadius: BorderRadius.circular(10),
                              colorInput: AppColors.buttonGrey,
                              widgetFaIcon: FaIcon(
                                FontAwesomeIcons.solidUser,
                                size: IconSize.xsIcon,
                              ),
                              // paddingFaIcon: EdgeInsets.only(left: 20, right: 10),
                              mainAxisAlignmentTextIcon:
                                  MainAxisAlignment.start,
                              text: "my profile".tr,
                              widgetIconActive: FaIcon(
                                FontAwesomeIcons.chevronRight,
                                size: IconSize.xsIcon,
                              ),
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyProfile(),
                                  ),
                                ).then((value) {
                                  if (value == "Success") {
                                    getProfileSeeker();
                                  }
                                });
                              },
                              validateText: Container(),
                            ),
                            SizedBox(height: 5),

                            //
                            //
                            //
                            //
                            //Job Alert
                            BoxDecorationInput(
                              boxDecBorderRadius: BorderRadius.circular(10),
                              colorInput: AppColors.buttonGrey,
                              widgetFaIcon: FaIcon(
                                FontAwesomeIcons.solidBell,
                                size: IconSize.xsIcon,
                              ),
                              // paddingFaIcon: EdgeInsets.only(left: 20, right: 10),
                              mainAxisAlignmentTextIcon:
                                  MainAxisAlignment.start,
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobAlert(),
                                  ),
                                );
                              },
                              text: "job alert".tr,
                              widgetIconActive: FaIcon(
                                FontAwesomeIcons.chevronRight,
                                size: IconSize.xsIcon,
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
      height: 110,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: boxDecoration(BorderRadius.circular(10),
          boxColor == null ? AppColors.lightPrimary : boxColor, null, null),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${amount}",
            style: bodyTextMaxMedium(null, null, FontWeight.bold),
          ),
          Text(
            "${text}",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
