//
//Profile Setting
// ignore_for_file: prefer_const_constructors

import 'package:app/functions/colors.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/boxDecDottedBorderProfileDetail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileSetting extends StatelessWidget {
  const ProfileSetting({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBarDefault(
          textTitle: "Profile Setting",
          // fontWeight: FontWeight.bold,
          leadingIcon: Icon(Icons.arrow_back),
          leadingPress: () {
            Navigator.of(context).pop();
          },
        ),
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  //
                  //
                  //BoxDecoration DottedBorder Profile Status
                  // BoxDecDottedBorderProfileDetail(
                  //   boxDecColor: AppColors.lightPrimary,
                  //   title: "Profile Status",
                  //   titleFontWeight: FontWeight.bold,
                  //   text:
                  //       "Get your profile approved or complete: Attached CV, Personal Information and Work Preferences to set the profile status",
                  //   buttonWidth: 140,
                  //   buttonIcon: FontAwesomeIcons.pen,
                  //   buttonText: "Update Profile",
                  //   pressButton: () {},
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  //
                  //
                  //BoxDecoration DottedBorder Profile Search
                  BoxDecDottedBorderProfileDetail(
                    boxDecColor: AppColors.lightPrimary,
                    title: "Profile Search",
                    titleFontWeight: FontWeight.bold,
                    text:
                        "To enable Searchable Profile, level up your profile to Newbie level",
                    buttonIcon: FontAwesomeIcons.pen,
                    buttonWidth: 140,
                    buttonText: "Update Profile",
                    pressButton: () {},
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BoxDecProfileSettingHaveValue(
                    boxDecColor: AppColors.lightPrimary,
                    title: "Profile Status",
                    titleFontWeight: FontWeight.bold,
                    text:
                        "Get your profile approved or complete: Attached CV, Personal Information and Work Preferences to set the profile status.",
                    actionOnOffIcon: FaIcon(
                      FontAwesomeIcons.eye,
                      color: AppColors.iconLight,
                      size: 20,
                    ),
                    actionOnOffText: "ON",
                    pressActionOnOff: () {},
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
