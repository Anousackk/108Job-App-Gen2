// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, unused_field, avoid_print, unused_local_variable, prefer_typing_uninitialized_variables, prefer_final_fields, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, prefer_is_empty, unused_element, unnecessary_null_in_if_null_operators, prefer_if_null_operators, prefer_adjacent_string_concatenation, unnecessary_null_comparison, avoid_init_to_null, file_names, prefer_interpolation_to_compose_strings, deprecated_member_use, use_build_context_synchronously, unrelated_type_equality_checks

import 'dart:io';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/helpers/eventAvailableHelper.dart';
import 'package:app/provider/avatarProvider.dart';
import 'package:app/provider/eventAvailableProvider.dart';
import 'package:app/provider/profileProvider.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Education/fetchEducation.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Language/fetchLanguage.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Personal_Information/personal_Information.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Skill/fetchSkill.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/UploadCV/uploadCV.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/Widget/avatarImage.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/WorkHistory/fetchWorkHistory.dart';
import 'package:app/screen/ScreenAfterSignIn/account/MyProfile/ProfileSetting/profileSetting.dart';
import 'package:app/screen/ScreenAfterSignIn/account/MyProfile/WorkPreference/workPreferences.dart';
import 'package:app/screen/screenAfterSignIn/account/myProfile/Widget/boxContainChooseHaveCVFile.dart';
import 'package:app/screen/screenAfterSignIn/account/myProfile/Widget/boxPrefixSuffix.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key, this.status}) : super(key: key);

  final String? status;

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile>
    with SingleTickerProviderStateMixin, EventAvailableHelper {
  final ScrollController _scrollController = ScrollController();

  //
  //Upload File
  dynamic _fileValue;
  String _strFilePath = "";

  // List _avatars = [];

  String _statusUploadImage = "";

  File? _image;

  int stepMyProfile = 1;

  // String haveCVFile = "";

  // pressApplyEvent() async {
  //   final eventAvailableProvider = context.read<EventAvailableProvider>();
  //   // Display AlertDialog Loading First
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return CustomLoadingLogoCircle();
  //     },
  //   );
  //   final res = await eventAvailableProvider.applyEvent(context);
  //   final statusCode = res?["statusCode"];
  //   if (!context.mounted) return;
  //   // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
  //   Navigator.pop(context);
  //   if (statusCode == 200 || statusCode == 201) {
  //     await eventAvailableProvider.fetchEventAvailable();
  //     await eventAvailableProvider.fetchStatisticEvent();
  //     Navigator.pop(context);
  //   } else {
  //     await showDialog(
  //       context: context,
  //       builder: (context) {
  //         return CustAlertDialogWarningWithoutBtn(
  //           title: "warning".tr,
  //           contentText: "${res?["body"]?["message"]}",
  //         );
  //       },
  //     );
  //   }
  // }

  pressStepMyProfile(int val) {
    setState(() {
      stepMyProfile = val;
    });
  }

  //error setState() called after dispose(). it can help!!!
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool conditionShowApplyEventButton() {
    final profileProvider = context.read<ProfileProvider>();
    final eventAvailableProvider = context.read<EventAvailableProvider>();

    // must not be applied & must be Event
    if (profileProvider.statusFormProfile == "Event" &&
        !eventAvailableProvider.isApplied) {
      // Case 1: User already has CV
      if (profileProvider.haveCVFile == "Yes") {
        return profileProvider.personalInformationStatus &&
            profileProvider.workPreferenceStatus &&
            profileProvider.resumeStatus;
      }

      // Case 2: User does NOT have CV
      if (profileProvider.haveCVFile == "No") {
        return profileProvider.personalInformationStatus &&
            profileProvider.workPreferenceStatus &&
            profileProvider.resumeStatus &&
            profileProvider.educationStatus &&
            profileProvider.workHistoryStatus &&
            profileProvider.languageStatus &&
            profileProvider.skillStatus;
      }
    }

    return false;
  }

  checkStatusFormProfile() {
    final profileProvider = context.read<ProfileProvider>();

    if (widget.status == "Event") {
      profileProvider.statusFormProfile = "Event";
      profileProvider.statusEventUpdateProfile = "wiifair";
      profileProvider.haveCVFile = "";
    } else {
      profileProvider.statusFormProfile = "";
      profileProvider.statusEventUpdateProfile = "";
    }
  }

  @override
  void initState() {
    super.initState();

    context.read<AvatarProvider>().fetchAvatar();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkStatusFormProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final avatarProvider = context.watch<AvatarProvider>();
    final eventAvailableProvider = context.watch<EventAvailableProvider>();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: profileProvider.isLoadingProfile
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
                child: Container(
                  color: AppColors.backgroundWhite,
                  child: Column(
                    children: [
                      // Text("${profileProvider.statusEventUpdateProfile}"),
                      //
                      //
                      //Section Appbar Custom
                      AppBarThreeWidgt(
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

                        //Widget Title
                        //Text title
                        title: Text(
                          "my_profile".tr,
                          style: appbarTextMedium("NotoSansLaoLoopedBold",
                              AppColors.fontWhite, null),
                        ),

                        //Widget Actions
                        //Profile setting
                        actions:
                            // _status == "Approved" &&
                            profileProvider.memberLevel != "Basic Member"
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileSetting(
                                            isSearchable:
                                                profileProvider.isSearchable,
                                          ),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        height: 45,
                                        width: 45,
                                        color: AppColors.iconLight
                                            .withOpacity(0.1),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "\uf013",
                                            style: fontAwesomeRegular(null, 20,
                                                AppColors.iconLight, null),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 45,
                                    width: 45,
                                  ),
                      ),

                      //
                      //
                      //Section Body Content
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await profileProvider.fetchProfileSeeker();
                          },
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                //
                                //
                                //Box Container Avatar Image
                                Container(
                                  width: double.infinity,
                                  color: AppColors.primary100,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashColor: AppColors.white,
                                      highlightColor: AppColors.primary100,
                                      //Press alert dialog show avatar image
                                      onTap: () async {
                                        dynamic result = await showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return BoxDecAvatarImage(
                                                listItems:
                                                    avatarProvider.listAvatar,
                                                selectedListItem:
                                                    profileProvider
                                                        .selectedAvatarImage,
                                                title: "avatar_image".tr,
                                              );
                                            });

                                        if (result != null) {
                                          if (result[0] == "Confirm") {
                                            // Display AlertDialog Loading First
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return CustomLoadingLogoCircle();
                                              },
                                            );

                                            final res = await avatarProvider
                                                .updateAvatar(
                                                    result[1].toString());

                                            final statusCode =
                                                res?["statusCode"];

                                            if (!context.mounted) return;

                                            // Always close dialog first
                                            Navigator.pop(context);

                                            if (statusCode == 200 ||
                                                statusCode == 201) {
                                              await profileProvider
                                                  .fetchProfileSeeker();
                                            }
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  //Avatar image
                                                  Stack(
                                                    clipBehavior: Clip.none,
                                                    alignment: Alignment.center,
                                                    children: <Widget>[
                                                      Container(
                                                        width: 90,
                                                        height: 90,
                                                        child: _image != null
                                                            //ຖ້າວ່າມີຮູບ (_image != null)
                                                            ? ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                child:
                                                                    Image.file(
                                                                  _image!,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              )
                                                            //ຖ້າວ່າບໍ່ມີຮູບ (_image == null)
                                                            : ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                child: profileProvider
                                                                            .avatarObj ==
                                                                        null
                                                                    ? Image
                                                                        .asset(
                                                                        'assets/image/defprofile.jpg',
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      )
                                                                    : Image
                                                                        .network(
                                                                        "${profileProvider.avatarScr}",
                                                                        fit: BoxFit
                                                                            .contain,
                                                                        errorBuilder: (context,
                                                                            error,
                                                                            stackTrace) {
                                                                          print(
                                                                              error);
                                                                          return Image
                                                                              .asset(
                                                                            'assets/image/defprofile.jpg',
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          ); // Display an error message
                                                                        },
                                                                      ),
                                                              ),
                                                      ),

                                                      //Gallery image icon at the bottom right corner
                                                      Positioned(
                                                        bottom: 0,
                                                        right: -5,
                                                        child: GestureDetector(
                                                          onTap: () {},
                                                          child: Container(
                                                            height: 25,
                                                            width: 25,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: AppColors
                                                                  .backgroundWhite,
                                                            ),
                                                            child: Text(
                                                              "\uf021",
                                                              style: fontAwesomeRegular(
                                                                  null,
                                                                  10,
                                                                  AppColors
                                                                      .dark500,
                                                                  null),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 10),

                                                  //Column text right avatar image
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "avatar_image".tr,
                                                          style: bodyTextMaxNormal(
                                                              "NotoSansLaoLoopedBold",
                                                              null,
                                                              FontWeight.bold),
                                                        ),
                                                        Text(
                                                          "select_avatar_intro_text"
                                                              .tr,
                                                          style: bodyTextSmall(
                                                              null, null, null),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                //
                                //
                                // Choose have or haven't CV file
                                if (profileProvider.statusFormProfile ==
                                    "Event")
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Container(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 20),
                                          Text(
                                            "do_u_have_cv_file".tr,
                                            style: bodyTextMaxNormal(
                                                null, null, FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          BoxContainChooseHaveCVFile(
                                            press: () {
                                              setState(() {
                                                profileProvider.haveCVFile =
                                                    "Yes";
                                                pressStepMyProfile(0);
                                              });
                                            },
                                            borderColor:
                                                profileProvider.haveCVFile ==
                                                        "Yes"
                                                    ? AppColors.success200
                                                    : AppColors.dark200,
                                            boxColor:
                                                profileProvider.haveCVFile ==
                                                        "Yes"
                                                    ? AppColors.success200
                                                    : AppColors.backgroundWhite,
                                            circleIconColor:
                                                profileProvider.haveCVFile ==
                                                        "Yes"
                                                    ? AppColors.backgroundWhite
                                                    : AppColors.dark100,
                                            iconColor:
                                                profileProvider.haveCVFile ==
                                                        "Yes"
                                                    ? AppColors.success
                                                    : AppColors.dark400,
                                            icon: "\uf316",
                                            text: "yes_have_cv_file".tr,
                                            textColor:
                                                profileProvider.haveCVFile ==
                                                        "Yes"
                                                    ? AppColors.fontDark
                                                    : AppColors.fontDark,
                                          ),
                                          SizedBox(height: 10),
                                          BoxContainChooseHaveCVFile(
                                            press: () {
                                              setState(() {
                                                profileProvider.haveCVFile =
                                                    "No";
                                                pressStepMyProfile(0);
                                              });
                                            },
                                            borderColor:
                                                profileProvider.haveCVFile ==
                                                        "No"
                                                    ? AppColors.primary200
                                                    : AppColors.dark200,
                                            boxColor:
                                                profileProvider.haveCVFile ==
                                                        "No"
                                                    ? AppColors.primary200
                                                    : AppColors.backgroundWhite,
                                            circleIconColor:
                                                profileProvider.haveCVFile ==
                                                        "No"
                                                    ? AppColors.backgroundWhite
                                                    : AppColors.dark100,
                                            iconColor:
                                                profileProvider.haveCVFile ==
                                                        "No"
                                                    ? AppColors.primary
                                                    : AppColors.dark400,
                                            icon: "\uf317",
                                            text: "no_have_cv_file".tr,
                                            textColor:
                                                profileProvider.haveCVFile ==
                                                        "No"
                                                    ? AppColors.fontDark
                                                    : AppColors.fontDark,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                SizedBox(height: 30),

                                //
                                //
                                //Form Profile
                                if (profileProvider.statusFormProfile == "" ||
                                    profileProvider.statusFormProfile ==
                                            "Event" &&
                                        profileProvider.haveCVFile != "")
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: Column(
                                            children: [
                                              //Box Decoration Personal Information
                                              if (stepMyProfile != 1)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15),
                                                  child:
                                                      BoxDotBorderPrefixTextSuffixText(
                                                    press: () {
                                                      pressStepMyProfile(1);
                                                    },
                                                    prefixText: "1",
                                                    text: "personal_info".tr,
                                                    suffixBoxColor: profileProvider
                                                            .personalInformationStatus
                                                        ? AppColors.primary300
                                                        : null,
                                                    suffixText: profileProvider
                                                            .personalInformationStatus
                                                        ? "completed".tr
                                                        : "blank".tr,
                                                    suffixTextColor: profileProvider
                                                            .personalInformationStatus
                                                        ? AppColors.primary
                                                        : null,
                                                  ),
                                                ),

                                              //Show Form Personal Information
                                              if (stepMyProfile == 1)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15),
                                                  child:
                                                      FormStepAddUpdateMyProfile(
                                                    prefixText: "1",
                                                    text: "personal_info".tr,
                                                    suffixBoxColor: profileProvider
                                                            .personalInformationStatus
                                                        ? AppColors.primary300
                                                        : null,
                                                    suffixText: profileProvider
                                                            .personalInformationStatus
                                                        ? "Completed"
                                                        : "Blank",
                                                    suffixTextColor: profileProvider
                                                            .personalInformationStatus
                                                        ? AppColors.primary
                                                        : null,
                                                    formWidget: Container(
                                                      child: profileProvider
                                                                      .seekerProfile ==
                                                                  null ||
                                                              profileProvider
                                                                      .seekerProfile ==
                                                                  ""
                                                          ? PersonalInformation(
                                                              pressButtonLeft:
                                                                  () {
                                                              pressStepMyProfile(
                                                                  2);
                                                            })
                                                          : PersonalInformation(
                                                              id: profileProvider
                                                                      .seekerProfile?[
                                                                  '_id'],
                                                              profile:
                                                                  profileProvider
                                                                      .seekerProfile,
                                                              pressButtonLeft:
                                                                  () {
                                                                pressStepMyProfile(
                                                                    2);
                                                              },
                                                              onSaveSuccess:
                                                                  () async {
                                                                pressStepMyProfile(
                                                                    2);
                                                              },
                                                            ),
                                                    ),
                                                  ),
                                                ),

                                              //Box Decoration Work Preferences
                                              if (stepMyProfile != 2)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15),
                                                  child:
                                                      BoxDotBorderPrefixTextSuffixText(
                                                    press: () {
                                                      pressStepMyProfile(2);
                                                    },
                                                    prefixText: "2",
                                                    text: "work_preference".tr,
                                                    suffixWidget: Text(
                                                      "\uf054",
                                                      style: fontAwesomeSolid(
                                                          null, 14, null, null),
                                                    ),
                                                    suffixBoxColor: profileProvider
                                                            .workPreferenceStatus
                                                        ? AppColors.primary300
                                                        : null,
                                                    suffixText: profileProvider
                                                            .workPreferenceStatus
                                                        ? "Completed"
                                                        : "Blank",
                                                    suffixTextColor: profileProvider
                                                            .workPreferenceStatus
                                                        ? AppColors.primary
                                                        : null,
                                                  ),
                                                ),

                                              //Show Form Work Preferences
                                              if (stepMyProfile == 2)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15),
                                                  child:
                                                      FormStepAddUpdateMyProfile(
                                                    prefixText: "2",
                                                    text: "work_preference".tr,
                                                    suffixBoxColor: profileProvider
                                                            .workPreferenceStatus
                                                        ? AppColors.primary300
                                                        : null,
                                                    suffixText: profileProvider
                                                            .workPreferenceStatus
                                                        ? "Completed"
                                                        : "Blank",
                                                    suffixTextColor: profileProvider
                                                            .workPreferenceStatus
                                                        ? AppColors.primary
                                                        : null,
                                                    formWidget: Container(
                                                      child: profileProvider
                                                                      .workPreferences ==
                                                                  null ||
                                                              profileProvider
                                                                      .workPreferences ==
                                                                  ""
                                                          ? WorkPreferences(
                                                              pressButtonLeft:
                                                                  () {
                                                              if (profileProvider
                                                                          .statusFormProfile ==
                                                                      "Event" &&
                                                                  profileProvider
                                                                          .haveCVFile ==
                                                                      "Yes") {
                                                                pressStepMyProfile(
                                                                    7);
                                                              } else {
                                                                pressStepMyProfile(
                                                                    3);
                                                              }
                                                            })
                                                          : WorkPreferences(
                                                              id: "workPreferenceId",
                                                              workPreference:
                                                                  profileProvider
                                                                      .workPreferences,
                                                              pressButtonLeft:
                                                                  () {
                                                                if (profileProvider
                                                                            .statusFormProfile ==
                                                                        "Event" &&
                                                                    profileProvider
                                                                            .haveCVFile ==
                                                                        "Yes") {
                                                                  pressStepMyProfile(
                                                                      7);
                                                                } else {
                                                                  pressStepMyProfile(
                                                                      3);
                                                                }
                                                              },
                                                              onSaveSuccess:
                                                                  () async {
                                                                if (profileProvider
                                                                            .statusFormProfile ==
                                                                        "Event" &&
                                                                    profileProvider
                                                                            .haveCVFile ==
                                                                        "Yes") {
                                                                  pressStepMyProfile(
                                                                      7);
                                                                } else {
                                                                  pressStepMyProfile(
                                                                      3);
                                                                }
                                                              },
                                                            ),
                                                    ),
                                                  ),
                                                ),

                                              //Box Decoration Education
                                              if (stepMyProfile != 3 &&
                                                  (profileProvider
                                                              .statusFormProfile ==
                                                          "" ||
                                                      (profileProvider
                                                                  .statusFormProfile ==
                                                              "Event" &&
                                                          profileProvider
                                                                  .haveCVFile ==
                                                              "No")))
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15),
                                                  child:
                                                      BoxDotBorderPrefixTextSuffixText(
                                                    press: () {
                                                      pressStepMyProfile(3);
                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //     builder: (context) =>
                                                      //         FetchEducation(),
                                                      //   ),
                                                      // ).then((val) => onGoBack(val));
                                                    },
                                                    prefixText: "3",
                                                    text: "education".tr,
                                                    suffixBoxColor:
                                                        profileProvider
                                                                .educationStatus
                                                            ? AppColors
                                                                .primary300
                                                            : null,
                                                    suffixText: profileProvider
                                                            .educationStatus
                                                        ? "Completed"
                                                        : "Blank",
                                                    suffixTextColor:
                                                        profileProvider
                                                                .educationStatus
                                                            ? AppColors.primary
                                                            : null,
                                                  ),
                                                ),

                                              //Show Form Education
                                              if (stepMyProfile == 3)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15),
                                                  child:
                                                      FormStepAddUpdateMyProfile(
                                                    prefixText: "3",
                                                    text: "education".tr,
                                                    suffixBoxColor:
                                                        profileProvider
                                                                .educationStatus
                                                            ? AppColors
                                                                .primary300
                                                            : null,
                                                    suffixText: profileProvider
                                                            .educationStatus
                                                        ? "Completed"
                                                        : "Blank",
                                                    suffixTextColor:
                                                        profileProvider
                                                                .educationStatus
                                                            ? AppColors.primary
                                                            : null,
                                                    formWidget: Container(
                                                      child: FetchEducation(
                                                        pressButtonLeft: () {
                                                          pressStepMyProfile(4);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                              //Box Decoration Work History
                                              if (stepMyProfile != 4 &&
                                                  (profileProvider
                                                              .statusFormProfile ==
                                                          "" ||
                                                      (profileProvider
                                                                  .statusFormProfile ==
                                                              "Event" &&
                                                          profileProvider
                                                                  .haveCVFile ==
                                                              "No")))
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15),
                                                  child:
                                                      BoxDotBorderPrefixTextSuffixText(
                                                    press: () {
                                                      pressStepMyProfile(4);
                                                    },
                                                    prefixText: "4",
                                                    text: "work_history".tr,
                                                    suffixBoxColor:
                                                        profileProvider
                                                                .workHistoryStatus
                                                            ? AppColors
                                                                .primary300
                                                            : null,
                                                    suffixText: profileProvider
                                                            .workHistoryStatus
                                                        ? "Completed"
                                                        : "Blank",
                                                    suffixTextColor:
                                                        profileProvider
                                                                .workHistoryStatus
                                                            ? AppColors.primary
                                                            : null,
                                                  ),
                                                ),

                                              //Show Form Work History
                                              if (stepMyProfile == 4)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15),
                                                  child:
                                                      FormStepAddUpdateMyProfile(
                                                    prefixText: "4",
                                                    text: "work_history".tr,
                                                    suffixBoxColor:
                                                        profileProvider
                                                                .workHistoryStatus
                                                            ? AppColors
                                                                .primary300
                                                            : null,
                                                    suffixText: profileProvider
                                                            .workHistoryStatus
                                                        ? "Completed"
                                                        : "Blank",
                                                    suffixTextColor:
                                                        profileProvider
                                                                .workHistoryStatus
                                                            ? AppColors.primary
                                                            : null,
                                                    formWidget:
                                                        FetchWorkHistory(
                                                      noExperience:
                                                          profileProvider
                                                              .isNoExperience,
                                                      pressButtonLeft: () {
                                                        pressStepMyProfile(5);
                                                      },
                                                    ),
                                                  ),
                                                ),

                                              //Box Decoration Language
                                              if (stepMyProfile != 5 &&
                                                  (profileProvider
                                                              .statusFormProfile ==
                                                          "" ||
                                                      (profileProvider
                                                                  .statusFormProfile ==
                                                              "Event" &&
                                                          profileProvider
                                                                  .haveCVFile ==
                                                              "No")))
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15),
                                                  child:
                                                      BoxDotBorderPrefixTextSuffixText(
                                                    press: () {
                                                      pressStepMyProfile(5);
                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //     builder: (context) =>
                                                      //         FetchLanguage(),
                                                      //   ),
                                                      // ).then((val) => onGoBack(val));
                                                    },
                                                    prefixText: "5",
                                                    text: "language_skill".tr,
                                                    suffixWidget: Text(
                                                      "\uf054",
                                                      style: fontAwesomeSolid(
                                                          null, 14, null, null),
                                                    ),
                                                    suffixBoxColor:
                                                        profileProvider
                                                                .languageStatus
                                                            ? AppColors
                                                                .primary300
                                                            : null,
                                                    suffixText: profileProvider
                                                            .languageStatus
                                                        ? "Completed"
                                                        : "Blank",
                                                    suffixTextColor:
                                                        profileProvider
                                                                .languageStatus
                                                            ? AppColors.primary
                                                            : null,
                                                  ),
                                                ),

                                              //Show Form Language
                                              if (stepMyProfile == 5)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15),
                                                  child:
                                                      FormStepAddUpdateMyProfile(
                                                    prefixText: "5",
                                                    text: "language_skill".tr,
                                                    suffixBoxColor:
                                                        profileProvider
                                                                .languageStatus
                                                            ? AppColors
                                                                .primary300
                                                            : null,
                                                    suffixText: profileProvider
                                                            .languageStatus
                                                        ? "Completed"
                                                        : "Blank",
                                                    suffixTextColor:
                                                        profileProvider
                                                                .languageStatus
                                                            ? AppColors.primary
                                                            : null,
                                                    formWidget: FetchLanguage(
                                                      pressButtonLeft: () {
                                                        pressStepMyProfile(6);
                                                      },
                                                    ),
                                                  ),
                                                ),

                                              //Box Decoration Skill
                                              if (stepMyProfile != 6 &&
                                                  (profileProvider
                                                              .statusFormProfile ==
                                                          "" ||
                                                      (profileProvider
                                                                  .statusFormProfile ==
                                                              "Event" &&
                                                          profileProvider
                                                                  .haveCVFile ==
                                                              "No")))
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15),
                                                  child:
                                                      BoxDotBorderPrefixTextSuffixText(
                                                    press: () {
                                                      pressStepMyProfile(6);
                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //     builder: (context) =>
                                                      //         FetchSkill(),
                                                      //   ),
                                                      // ).then((val) => onGoBack(val));
                                                    },
                                                    prefixText: "6",
                                                    text: "skills".tr,
                                                    suffixWidget: Text(
                                                      "\uf054",
                                                      style: fontAwesomeSolid(
                                                          null, 14, null, null),
                                                    ),
                                                    suffixBoxColor:
                                                        profileProvider
                                                                .skillStatus
                                                            ? AppColors
                                                                .primary300
                                                            : null,
                                                    suffixText: profileProvider
                                                            .skillStatus
                                                        ? "Completed"
                                                        : "Blank",
                                                    suffixTextColor:
                                                        profileProvider
                                                                .skillStatus
                                                            ? AppColors.primary
                                                            : null,
                                                  ),
                                                ),

                                              //Show Form Skill
                                              if (stepMyProfile == 6)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15),
                                                  child:
                                                      FormStepAddUpdateMyProfile(
                                                    prefixText: "6",
                                                    text: "skills".tr,
                                                    suffixBoxColor:
                                                        profileProvider
                                                                .skillStatus
                                                            ? AppColors
                                                                .primary300
                                                            : null,
                                                    suffixText: profileProvider
                                                            .skillStatus
                                                        ? "Completed"
                                                        : "Blank",
                                                    suffixTextColor:
                                                        profileProvider
                                                                .skillStatus
                                                            ? AppColors.primary
                                                            : null,
                                                    formWidget: FetchSkill(
                                                      pressButtonLeft: () {
                                                        pressStepMyProfile(7);
                                                      },
                                                    ),
                                                  ),
                                                ),

                                              //Box Decoration Resume File
                                              if (stepMyProfile != 7)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15),
                                                  child:
                                                      BoxDotBorderPrefixTextSuffixText(
                                                    press: () {
                                                      pressStepMyProfile(7);
                                                    },
                                                    prefixText: profileProvider
                                                                    .statusFormProfile ==
                                                                "Event" &&
                                                            profileProvider
                                                                    .haveCVFile ==
                                                                "Yes"
                                                        ? "3"
                                                        : "7",
                                                    text: "cv_file".tr,
                                                    suffixBoxColor:
                                                        profileProvider
                                                                .resumeStatus
                                                            ? AppColors
                                                                .primary300
                                                            : null,
                                                    suffixText: profileProvider
                                                            .resumeStatus
                                                        ? "Completed"
                                                        : "Blank",
                                                    suffixTextColor:
                                                        profileProvider
                                                                .resumeStatus
                                                            ? AppColors.primary
                                                            : null,
                                                  ),
                                                ),

                                              //Show Form Resume File
                                              if (stepMyProfile == 7)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15),
                                                  child:
                                                      FormStepAddUpdateMyProfile(
                                                    prefixText: profileProvider
                                                                    .statusFormProfile ==
                                                                "Event" &&
                                                            profileProvider
                                                                    .haveCVFile ==
                                                                "Yes"
                                                        ? "3"
                                                        : "7",
                                                    text: "cv_file".tr,
                                                    suffixBoxColor:
                                                        profileProvider
                                                                .resumeStatus
                                                            ? AppColors
                                                                .primary300
                                                            : null,
                                                    suffixText: profileProvider
                                                            .resumeStatus
                                                        ? "Completed"
                                                        : "Blank",
                                                    suffixTextColor:
                                                        profileProvider
                                                                .resumeStatus
                                                            ? AppColors.primary
                                                            : null,
                                                    formWidget: UploadCV(
                                                      onSaveSuccess: () async {
                                                        if (profileProvider
                                                                .statusFormProfile ==
                                                            "Event") {
                                                          pressStepMyProfile(0);

                                                          print(
                                                              "UploadCV onSaveSuccess");

                                                          // Auto ApplyEvent work when function condition is met:
                                                          // profileProvider.statusFormProfile == Event
                                                          // profileProvider.haveCVFile == Yes
                                                          // profileProvider.personalInformationStatus == true
                                                          // profileProvider.workPreferenceStatus == true
                                                          // eventAvailableProvider.isApplied == false
                                                          if (!eventAvailableProvider
                                                                  .isApplied &&
                                                              profileProvider
                                                                  .personalInformationStatus &&
                                                              profileProvider
                                                                  .workPreferenceStatus) {
                                                            print(
                                                                "Auto ApplyEvent work");
                                                            // pressApplyEvent();
                                                            applyEventHelper(
                                                              onPressOkay: () {
                                                                // Close dialog
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();

                                                                // Navigate back to registerEvent.dart
                                                                if (Navigator
                                                                    .canPop(
                                                                        context)) {
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              },
                                                            );
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),

                                        // Text(
                                        //     "${eventAvailableProvider.isApplied}"),
                                        // Text(
                                        //     "${profileProvider.personalInformationStatus}"),
                                        // Text(
                                        //     "${profileProvider.workPreferenceStatus}"),

                                        if (conditionShowApplyEventButton())
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Button(
                                                  buttonColor:
                                                      AppColors.warning600,
                                                  text: "register_event".tr,
                                                  textColor: AppColors.fontDark,
                                                  textFontWeight:
                                                      FontWeight.bold,
                                                  press: () {
                                                    // pressApplyEvent();
                                                    applyEventHelper(
                                                      onPressOkay: () {
                                                        // Close dialog
                                                        Navigator.of(context)
                                                            .pop();

                                                        // Navigate back to registerEvent.dart
                                                        if (Navigator.canPop(
                                                            context)) {
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        SizedBox(height: 30),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
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

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//Profile Detail
// class ProfileDetail extends StatefulWidget {
//   const ProfileDetail({
//     Key? key,
//     this.profile,
//     this.workPreferences,
//     this.cv,
//     required this.educations,
//     required this.workHistories,
//     required this.languageSkills,
//     required this.skills,
//     this.onGoBack,
//   }) : super(key: key);

//   final dynamic profile;
//   final dynamic workPreferences;
//   final dynamic cv;
//   final List educations;
//   final List workHistories;
//   final List languageSkills;
//   final List skills;
//   final onGoBack;

//   @override
//   State<ProfileDetail> createState() => _ProfileDetailState();
// }

// class _ProfileDetailState extends State<ProfileDetail> {
//   //
//   //Profile Seekr
//   String _address = "";
//   String _dateOfBirth = "";
//   String _genDerName = "";
//   String _maritalStatusName = "";
//   String _mobile = "";
//   String _email = "";

//   //
//   //Work Preference
//   String _salary = "";
//   String _currentJobTitle = "";
//   String _jobLevel = "";
//   List _listJobFunctions = [];
//   String _jobFunctions = "";
//   List _listWorkProvinces = [];
//   String _workProvinces = "";
//   List _listBenefits = [];
//   String _benefits = "";

//   //
//   //CV
//   dynamic _cvName;
//   dynamic _cvUploadDate;
//   String _cvSrc = "";
//   String _mimeType = "";

//   //
//   //Work History
//   dynamic _startYearWorkHistory = null;
//   dynamic _endYearWorkHistory = null;
//   String _company = "";
//   String _position = "";

//   //
//   //Education
//   dynamic _startYearEducation;
//   dynamic _endYearWorkEducation;
//   String _qualificationName = "";
//   String _collage = "";
//   String _subject = "";

//   //
//   //Language
//   String _languageName = "";
//   String _languageLevelName = "";

//   //
//   //Skill
//   String _skillName = "";
//   String _skillLevelName = "";

//   Future<Directory?>? _tempDirectory;
//   late String _localPath;
//   late bool _permissionReady;
//   late TargetPlatform? platform;
//   String _memberLevel = "";

//   // void _requestDownloadsDirectory() {
//   //   setState(() {
//   //     _tempDirectory = getDownloadsDirectory();
//   //     print(_tempDirectory);
//   //   });
//   // }
//   // Future<bool> _checkPermission() async {
//   //   if (platform == TargetPlatform.android) {
//   //     final status = await Permission.storage.status;
//   //     if (status != PermissionStatus.granted) {
//   //       final result = await Permission.storage.request();
//   //       if (result == PermissionStatus.granted) {
//   //         return true;
//   //       }
//   //     } else {
//   //       return true;
//   //     }
//   //   } else {
//   //     return true;
//   //   }
//   //   return false;
//   // }

//   // Future<void> _prepareSaveDir() async {
//   //   _localPath = (await _findLocalPath())!;
//   //   print(_localPath);
//   //   final savedDir = Directory(_localPath);
//   //   bool hasExisted = await savedDir.exists();
//   //   if (!hasExisted) {
//   //     savedDir.create();
//   //   }
//   // }

//   // Future<String?> _findLocalPath() async {
//   //   if (platform == TargetPlatform.android) {
//   //     return "/sdcard/download/";
//   //   } else {
//   //     var directory = await getApplicationDocumentsDirectory();
//   //     return directory.path + Platform.pathSeparator + 'Download';
//   //   }
//   // }

//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isAndroid) {
//       platform = TargetPlatform.android;
//     } else {
//       platform = TargetPlatform.iOS;
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.profile != null) {
//       _address = widget.profile["address"];
//       _dateOfBirth = !widget.profile.containsKey('dateOfBirth')
//           ? ""
//           : widget.profile['dateOfBirth'];

//       if (_dateOfBirth != "") {
//         //pars ISO to Flutter DateTime
//         parsDateTime(value: '', currentFormat: '', desiredFormat: '');
//         DateTime parsDateOfBirth = parsDateTime(
//           value: _dateOfBirth,
//           currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
//           desiredFormat: "yyyy-MM-dd HH:mm:ss",
//         );
//         _dateOfBirth = formatDate(parsDateOfBirth);
//       }

//       _genDerName = widget.profile['genderId'] != null
//           ? widget.profile['genderId']['name']
//           : "";
//       _maritalStatusName = widget.profile['maritalStatusId'] != null
//           ? widget.profile['maritalStatusId']['name']
//           : "";
//       _email = widget.profile['email'];
//       _mobile = widget.profile['mobile'];
//     }
//     if (widget.cv != null) {
//       _cvName = widget.cv['link'].split('/')[1];
//       _cvUploadDate = widget.cv['updatedAt'];
//       parsDateTime(value: '', currentFormat: '', desiredFormat: '');
//       DateTime cvUploadDate = parsDateTime(
//         value: _cvUploadDate,
//         currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
//         desiredFormat: "yyyy-MM-dd HH:mm:ss",
//       );
//       _cvUploadDate = formatDate(cvUploadDate);
//       _cvSrc = widget.cv['src'];
//       _mimeType = widget.cv['mimeType'];
//       _mimeType = _mimeType.split("/")[1].toString();
//     }
//     if (widget.workPreferences != null) {
//       _currentJobTitle = widget.workPreferences['currentJobTitle'];

//       _salary = widget.workPreferences['salary'].toString();
//       int parseIntSalary = int.parse(_salary);
//       _salary = NumberFormat('#,##0').format(parseIntSalary);

//       _jobLevel = widget.workPreferences['jobLevelId']['name'];

//       _listJobFunctions = widget.workPreferences['jobFunctionId'];
//       _jobFunctions = _listJobFunctions.map((jf) => jf['name']).join(', ');

//       _listWorkProvinces = widget.workPreferences['workLocation'];
//       _workProvinces = _listWorkProvinces.map((p) => p['name']).join(', ');

//       _listBenefits = widget.workPreferences['benefitsId'];
//       _benefits = _listBenefits.map((b) => b['name']).join(', ');
//     }

//     // var splitHttps = _cvSrc.split(":");
//     // var splitHost = _cvSrc.split("/");
//     // var splitPath = _cvSrc.split(".com");

//     // final Uri toLaunch = Uri(
//     //     scheme: splitHttps[0].toString(),
//     //     host: splitHost[2].toString(),
//     //     path: splitPath[1].toString());

//     // print(splitPath);

//     return Container(
//       child: SingleChildScrollView(
//         physics: ClampingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             //
//             //
//             //
//             //
//             //Job Seeker Area
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Basic Job Seeker",
//                     style: bodyTextMaxNormal(null, null, FontWeight.bold),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     "complete section your profile".tr,
//                     style: bodyTextNormal(null, null, null),
//                     overflow: TextOverflow.fade,
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         "to the next level".tr + ": ",
//                         style: bodyTextNormal(null, null, null),
//                       ),
//                       Text(
//                         _memberLevel == "Basic Member" || _memberLevel == ""
//                             ? "Basic Job Seeker"
//                             : _memberLevel == "Basic Job Seeker"
//                                 ? "Expert Job Seeker"
//                                 : "Expert Job Seeker",
//                         style: bodyTextNormal(
//                             null, AppColors.fontSuccess, FontWeight.bold),
//                       ),
//                     ],
//                   ),

//                   SizedBox(
//                     height: 20,
//                   ),

//                   //
//                   //
//                   //BoxDecoration DottedBorder Personal Information
//                   widget.profile == null || widget.profile == ""
//                       ? BoxDecDottedBorderProfileDetail(
//                           boxDecColor: AppColors.lightPrimary,
//                           title: "personal_info".tr,
//                           titleFontWeight: FontWeight.bold,
//                           text: "let us know".tr,
//                           buttonText: "add".tr,
//                           pressButton: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => PersonalInformation(),
//                               ),
//                             ).then(widget.onGoBack);
//                           },
//                         )
//                       : BoxDecProfileDetailHaveValue(
//                           title: "personal_info".tr,
//                           titleFontWeight: FontWeight.bold,
//                           text: "let us know".tr,
//                           widgetColumn: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "address".tr + ":",
//                                 style: bodyTextNormal(null, null, null),
//                               ),
//                               Text(
//                                 _address,
//                                 style:
//                                     bodyTextNormal(null, null, FontWeight.bold),
//                               ),
//                               SizedBox(
//                                 height: 8,
//                               ),
//                               Text(
//                                 "birth".tr +
//                                     ", " +
//                                     "gender".tr +
//                                     ", " +
//                                     "marital status".tr +
//                                     ":",
//                                 style: bodyTextNormal(null, null, null),
//                               ),
//                               Text(
//                                 "$_dateOfBirth " +
//                                     "$_genDerName " +
//                                     "$_maritalStatusName ",
//                                 style:
//                                     bodyTextNormal(null, null, FontWeight.bold),
//                               ),
//                               SizedBox(
//                                 height: 8,
//                               ),
//                               Text(
//                                 "email".tr + ":",
//                                 style: bodyTextNormal(null, null, null),
//                               ),
//                               Text(
//                                 _email,
//                                 style:
//                                     bodyTextNormal(null, null, FontWeight.bold),
//                               ),
//                               SizedBox(
//                                 height: 8,
//                               ),
//                               Text(
//                                 "phone".tr + ":",
//                                 style: bodyTextNormal(null, null, null),
//                               ),
//                               Text(
//                                 _mobile,
//                                 style:
//                                     bodyTextNormal(null, null, FontWeight.bold),
//                               ),
//                             ],
//                           ),

//                           //
//                           //
//                           //Button Left For Update
//                           statusLeft: "have",
//                           pressLeft: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => PersonalInformation(
//                                   id: widget.profile['_id'],
//                                   profile: widget.profile,
//                                 ),
//                               ),
//                             ).then(widget.onGoBack);
//                           },
//                         ),

//                   SizedBox(
//                     height: 20,
//                   ),

//                   //
//                   //
//                   //BoxDecoration DottedBorder Work Preferences
//                   widget.workPreferences == null || widget.workPreferences == ""
//                       ? BoxDecDottedBorderProfileDetail(
//                           boxDecColor: AppColors.lightPrimary,
//                           title: "work_preference".tr,
//                           titleFontWeight: FontWeight.bold,
//                           text: "add".tr + " " + "work_preference".tr,
//                           buttonText: "add".tr,
//                           pressButton: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => WorkPreferences(),
//                               ),
//                             ).then(widget.onGoBack);
//                           },
//                         )
//                       : BoxDecProfileDetailHaveValue(
//                           title: "work_preference".tr,
//                           titleFontWeight: FontWeight.bold,
//                           text: "add".tr + " " + "work_preference".tr,
//                           widgetColumn: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "salary".tr + ":",
//                                 style: bodyTextNormal(null, null, null),
//                               ),
//                               Text(
//                                 _salary,
//                                 style:
//                                     bodyTextNormal(null, null, FontWeight.bold),
//                               ),
//                               SizedBox(
//                                 height: 8,
//                               ),
//                               Text(
//                                 "job title".tr + ":",
//                                 style: bodyTextNormal(null, null, null),
//                               ),
//                               Text(
//                                 _currentJobTitle,
//                                 style:
//                                     bodyTextNormal(null, null, FontWeight.bold),
//                               ),
//                               SizedBox(
//                                 height: 8,
//                               ),
//                               Text(
//                                 "job function".tr + ":",
//                                 style: bodyTextNormal(null, null, null),
//                               ),
//                               Text(
//                                 _jobFunctions,
//                                 style:
//                                     bodyTextNormal(null, null, FontWeight.bold),
//                               ),
//                               SizedBox(
//                                 height: 8,
//                               ),
//                               Text(
//                                 "work province".tr,
//                                 style: bodyTextNormal(null, null, null),
//                               ),
//                               Text(
//                                 _workProvinces,
//                                 style:
//                                     bodyTextNormal(null, null, FontWeight.bold),
//                               ),
//                               SizedBox(
//                                 height: 8,
//                               ),
//                               Text(
//                                 "job level".tr + ":",
//                                 style: bodyTextNormal(null, null, null),
//                               ),
//                               Text(
//                                 _jobLevel,
//                                 style:
//                                     bodyTextNormal(null, null, FontWeight.bold),
//                               ),
//                               SizedBox(
//                                 height: 8,
//                               ),
//                               Text(
//                                 "benefit".tr + ":",
//                                 style: bodyTextNormal(null, null, null),
//                               ),
//                               Text(
//                                 _benefits,
//                                 style:
//                                     bodyTextNormal(null, null, FontWeight.bold),
//                               ),
//                             ],
//                           ),

//                           //
//                           //
//                           //Status Left For Update
//                           statusLeft: "have",
//                           pressLeft: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => WorkPreferences(
//                                   id: "workPreferenceId",
//                                   workPreference: widget.workPreferences,
//                                 ),
//                               ),
//                             ).then(widget.onGoBack);
//                           },
//                         ),
//                   SizedBox(
//                     height: 20,
//                   ),

//                   //
//                   //
//                   //BoxDecoration DottedBorder Upload CV
//                   widget.cv == null
//                       ? BoxDecDottedBorderProfileDetail(
//                           boxDecColor: AppColors.lightPrimary,
//                           title: "upload cv".tr,
//                           titleFontWeight: FontWeight.bold,
//                           text: "cv_file_support".tr,
//                           buttonText: "add".tr,
//                           pressButton: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => UploadCV(),
//                               ),
//                             ).then(widget.onGoBack);
//                           },
//                         )
//                       : BoxDecProfileDetailHaveValue(
//                           title: "upload cv".tr,
//                           titleFontWeight: FontWeight.bold,
//                           text: "cv_file_support".tr,
//                           widgetFaIcon: Expanded(
//                             flex: 2,
//                             child: Container(
//                               child: FaIcon(
//                                 _mimeType == "pdf"
//                                     ? FontAwesomeIcons.filePdf
//                                     : FontAwesomeIcons.fileWord,
//                                 size: IconSize.lIcon,
//                                 color: AppColors.iconPrimary,
//                               ),
//                             ),
//                           ),
//                           widgetColumn: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "${_cvName}",
//                                 style:
//                                     bodyTextNormal(null, null, FontWeight.bold),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               Text(
//                                 "uploaded".tr + " ${_cvUploadDate}",
//                                 style: bodyTextNormal(null, null, null),
//                               ),
//                             ],
//                           ),

//                           //
//                           //
//                           //Button Right ellipsis function(Upload, Preview, Download)
//                           widgetFaIconRight: FaIcon(
//                             FontAwesomeIcons.ellipsis,
//                             size: IconSize.xsIcon,
//                           ),
//                           statusRight: "have",
//                           pressRight: () {
//                             //
//                             //
//                             //show modal bottom upload new cv, preview, download
//                             showModalBottomSheet(
//                               context: context,
//                               builder: (builder) {
//                                 return ModalBottomUploadCV(
//                                   //
//                                   //
//                                   //button upload new resume
//                                   () {
//                                     Navigator.pop(context);

//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => UploadCV(),
//                                       ),
//                                     ).then(widget.onGoBack);
//                                   },
//                                   null,
//                                   "upload new CV".tr,

//                                   //
//                                   //
//                                   //button preview cv
//                                   () {
//                                     launchInWebView(Uri.parse(_cvSrc));
//                                   },
//                                   null,
//                                   "view".tr,

//                                   //
//                                   //
//                                   //button download cv
//                                   () {
//                                     launchInBrowser(Uri.parse(_cvSrc));
//                                   },
//                                   null,
//                                   "download".tr,
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                   SizedBox(
//                     height: 30,
//                   ),

//                   // Button(
//                   //   text: "Request for review",
//                   //   fontWeight: FontWeight.bold,
//                   //   colorButton: AppColors.buttonSecondary,
//                   // ),
//                   // SizedBox(
//                   //   height: 5,
//                   // ),
//                   // Align(
//                   //   alignment: Alignment.center,
//                   //   child:
//                   //       Text("Complete all sections above to request for review"),
//                   // ),
//                   // SizedBox(
//                   //   height: 30,
//                   // ),
//                 ],
//               ),
//             ),
//             Divider(
//               height: 3,
//               color: AppColors.borderBG,
//             ),

//             //
//             //
//             //
//             //
//             //
//             //Expert Job Seeker Area
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Text(
//                     "Expert Job Seeker",
//                     style: bodyTextMaxNormal(null, null, FontWeight.bold),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     "complete section your profile".tr,
//                     style: bodyTextNormal(null, null, null),
//                     overflow: TextOverflow.fade,
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         "to the next level".tr + ": ",
//                         style: bodyTextNormal(null, null, null),
//                       ),
//                       Text(
//                         "Expert Job Seeker",
//                         style: bodyTextNormal(
//                             null, AppColors.fontSuccess, FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),

//                   //
//                   //
//                   //BoxDecoration DottedBorder Work History
//                   widget.workHistories.length > 0
//                       ? Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               "work_history".tr,
//                               style: bodyTextMedium(
//                                   null, AppColors.fontPrimary, FontWeight.bold),
//                             ),
//                             Text(
//                               "details employment history".tr,
//                               style: bodyTextSmall(
//                                 null,
//                                 AppColors.fontGreyOpacity,
//                                 null,
//                               ),
//                             ),
//                             SizedBox(height: 15),
//                             ListView.builder(
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               itemCount: widget.workHistories.length,
//                               itemBuilder: (context, index) {
//                                 dynamic i = widget.workHistories[index];

//                                 _startYearWorkHistory = i['startYear'];
//                                 //pars ISO to Flutter DateTime
//                                 parsDateTime(
//                                     value: '',
//                                     currentFormat: '',
//                                     desiredFormat: '');
//                                 DateTime startYear = parsDateTime(
//                                   value: _startYearWorkHistory,
//                                   currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
//                                   desiredFormat: "yyyy-MM-dd HH:mm:ss",
//                                 );
//                                 _startYearWorkHistory =
//                                     formatMonthYear(startYear);

//                                 _endYearWorkHistory = i['endYear'];
//                                 if (_endYearWorkHistory != null) {
//                                   //pars ISO to Flutter DateTime
//                                   parsDateTime(
//                                       value: '',
//                                       currentFormat: '',
//                                       desiredFormat: '');
//                                   DateTime endYear = parsDateTime(
//                                     value: _endYearWorkHistory,
//                                     currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
//                                     desiredFormat: "yyyy-MM-dd HH:mm:ss",
//                                   );
//                                   _endYearWorkHistory =
//                                       formatMonthYear(endYear);
//                                 }
//                                 _company = i['company'];
//                                 _position = i['position'];

//                                 return Padding(
//                                   padding: const EdgeInsets.only(bottom: 5),
//                                   child:
//                                       BoxDecProfileDetailHaveValueWithoutTitleText(
//                                     widgetColumn: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Text(
//                                               "${_startYearWorkHistory}",
//                                               style: bodyTextNormal(
//                                                   null, null, null),
//                                             ),
//                                             Text(" - "),
//                                             Text(
//                                               "${_endYearWorkHistory ?? 'Now'}",
//                                               style: bodyTextNormal(
//                                                   null, null, null),
//                                             )
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           height: 5,
//                                         ),
//                                         Text(
//                                           _position,
//                                           style: bodyTextNormal(
//                                               null, null, FontWeight.bold),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         SizedBox(
//                                           height: 5,
//                                         ),
//                                         Text(
//                                           _company,
//                                           style:
//                                               bodyTextNormal(null, null, null),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ],
//                                     ),

//                                     //
//                                     //
//                                     //Button Left For Update
//                                     statusLeft: "have",
//                                     pressLeft: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => WorkHistory(
//                                             id: i["_id"],
//                                             workHistory: i,
//                                           ),
//                                         ),
//                                       ).then(widget.onGoBack);
//                                     },

//                                     //
//                                     //
//                                     //Button Right For Delete
//                                     statusRight: "have",
//                                     pressRight: () async {
//                                       var result = await showDialog(
//                                           context: context,
//                                           builder: (context) {
//                                             return NewVer2CustAlertDialogWarningBtnConfirmCancel(
//                                               title: "delete_this_info".tr,
//                                               contentText: "work_history".tr +
//                                                   ": ${i['position']}",
//                                               textButtonLeft: 'cancel'.tr,
//                                               textButtonRight: 'confirm'.tr,
//                                               textButtonRightColor:
//                                                   AppColors.fontWhite,
//                                             );
//                                           });
//                                       if (result == 'Ok') {
//                                         print("confirm delete");
//                                         deleteWorkHistory(i['_id']);
//                                       }
//                                     },
//                                   ),
//                                 );
//                               },
//                             ),
//                             CustomButtonIconText(
//                               buttonColor: AppColors.lightPrimary,
//                               widgetPrefixIcon: FaIcon(
//                                 FontAwesomeIcons.plus,
//                                 color: AppColors.fontPrimary,
//                               ),
//                               text: "add".tr + " " + 'work history'.tr,
//                               textColor: AppColors.fontPrimary,
//                               press: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => WorkHistory(),
//                                   ),
//                                 ).then(widget.onGoBack);
//                               },
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Divider(
//                               height: 2,
//                               color: AppColors.borderBG,
//                             )
//                           ],
//                         )
//                       : BoxDecDottedBorderProfileDetail(
//                           boxDecColor: AppColors.lightPrimary,
//                           title: "work_history".tr,
//                           titleFontWeight: FontWeight.bold,
//                           text: "details employment history".tr,
//                           buttonText: "add".tr,
//                           pressButton: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => WorkHistory(),
//                               ),
//                             ).then(widget.onGoBack);
//                           },
//                         ),

//                   SizedBox(
//                     height: 20,
//                   ),

//                   //
//                   //
//                   //BoxDecoration DottedBorder Education
//                   widget.educations.length > 0
//                       ? Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               "education".tr,
//                               style: bodyTextMedium(
//                                   null, AppColors.fontPrimary, FontWeight.bold),
//                             ),
//                             Text(
//                               "details education".tr,
//                               style: bodyTextSmall(
//                                 null,
//                                 AppColors.fontGreyOpacity,
//                                 null,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 15,
//                             ),
//                             ListView.builder(
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               itemCount: widget.educations.length,
//                               itemBuilder: (context, index) {
//                                 dynamic i = widget.educations[index];
//                                 DateTime dateTimeNow = DateTime.now();
//                                 DateTime utcNow = dateTimeNow.toUtc();
//                                 dynamic formattedStartDateUtc =
//                                     DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
//                                         .format(utcNow);
//                                 dynamic formattedEndDateUtc =
//                                     DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
//                                         .format(utcNow);

//                                 _startYearEducation = i['startYear'] == null
//                                     ? formattedStartDateUtc
//                                     : i['startYear'];
//                                 //pars ISO to Flutter DateTime
//                                 parsDateTime(
//                                     value: '',
//                                     currentFormat: '',
//                                     desiredFormat: '');
//                                 DateTime startYear = parsDateTime(
//                                   value: _startYearEducation,
//                                   currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
//                                   desiredFormat: "yyyy-MM-dd HH:mm:ss",
//                                 );
//                                 _startYearEducation = formatYear(startYear);

//                                 _endYearWorkEducation = i['endYear'] == null
//                                     ? formattedEndDateUtc
//                                     : i['endYear'];
//                                 //pars ISO to Flutter DateTime
//                                 parsDateTime(
//                                     value: '',
//                                     currentFormat: '',
//                                     desiredFormat: '');
//                                 DateTime endYear = parsDateTime(
//                                   value: _endYearWorkEducation,
//                                   currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
//                                   desiredFormat: "yyyy-MM-dd HH:mm:ss",
//                                 );
//                                 _endYearWorkEducation = formatYear(endYear);
//                                 _collage = i['school'];
//                                 _subject = i['subject'];
//                                 _qualificationName =
//                                     i['qualifications']['name'];

//                                 return Padding(
//                                   padding: const EdgeInsets.only(bottom: 5),
//                                   child:
//                                       BoxDecProfileDetailHaveValueWithoutTitleText(
//                                     widgetColumn: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           _startYearEducation +
//                                               " - " +
//                                               _endYearWorkEducation,
//                                           style:
//                                               bodyTextNormal(null, null, null),
//                                         ),
//                                         SizedBox(
//                                           height: 5,
//                                         ),
//                                         Text(
//                                           _qualificationName,
//                                           style: bodyTextNormal(
//                                               null, null, FontWeight.bold),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         SizedBox(
//                                           height: 5,
//                                         ),
//                                         Text(
//                                           _subject,
//                                           style:
//                                               bodyTextNormal(null, null, null),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         SizedBox(
//                                           height: 5,
//                                         ),
//                                         Text(
//                                           _collage,
//                                           style:
//                                               bodyTextNormal(null, null, null),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ],
//                                     ),

//                                     //
//                                     //
//                                     //Button Left For Update
//                                     statusLeft: "have",
//                                     pressLeft: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => Education(
//                                             id: i["_id"],
//                                             education: i,
//                                           ),
//                                         ),
//                                       ).then(widget.onGoBack);
//                                     },

//                                     //
//                                     //
//                                     //Button Right For Delete
//                                     statusRight: "have",
//                                     pressRight: () async {
//                                       var result = await showDialog(
//                                           context: context,
//                                           builder: (context) {
//                                             return NewVer2CustAlertDialogWarningBtnConfirmCancel(
//                                               title: "delete_this_info".tr,
//                                               contentText: "education".tr +
//                                                   ": ${i['qualifications']['name']}",
//                                               textButtonLeft: 'cancel'.tr,
//                                               textButtonRight: 'confirm'.tr,
//                                               textButtonRightColor:
//                                                   AppColors.fontWhite,
//                                             );
//                                           });
//                                       if (result == 'Ok') {
//                                         print("confirm delete");
//                                         deleteEducation(i['_id']);
//                                       }
//                                     },
//                                   ),
//                                 );
//                               },
//                             ),
//                             CustomButtonIconText(
//                               buttonColor: AppColors.lightPrimary,
//                               widgetPrefixIcon: FaIcon(
//                                 FontAwesomeIcons.plus,
//                                 color: AppColors.fontPrimary,
//                               ),
//                               text: "add".tr + " " + "education".tr,
//                               textColor: AppColors.fontPrimary,
//                               press: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => Education(),
//                                   ),
//                                 ).then(widget.onGoBack);
//                               },
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Divider(
//                               height: 2,
//                               color: AppColors.borderBG,
//                             )
//                           ],
//                         )
//                       : BoxDecDottedBorderProfileDetail(
//                           boxDecColor: AppColors.lightPrimary,
//                           title: "education".tr,
//                           titleFontWeight: FontWeight.bold,
//                           text: "details education".tr,
//                           buttonText: "add".tr,
//                           pressButton: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => Education(),
//                               ),
//                             ).then(widget.onGoBack);
//                           },
//                         ),

//                   SizedBox(
//                     height: 20,
//                   ),

//                   //
//                   //
//                   //BoxDecoration DottedBorder Language
//                   widget.languageSkills.length > 0
//                       ? Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               "language_skill".tr,
//                               style: bodyTextMedium(
//                                   null, AppColors.fontPrimary, FontWeight.bold),
//                             ),
//                             Text(
//                               "add all languages".tr,
//                               style: bodyTextSmall(
//                                 null,
//                                 AppColors.fontGreyOpacity,
//                                 null,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 15,
//                             ),
//                             ListView.builder(
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               itemCount: widget.languageSkills.length,
//                               itemBuilder: (context, index) {
//                                 dynamic i = widget.languageSkills[index];

//                                 _languageName = i['LanguageId']['name'];
//                                 _languageLevelName =
//                                     i['LanguageLevelId']['name'];

//                                 return Padding(
//                                   padding: const EdgeInsets.only(bottom: 5),
//                                   child:
//                                       BoxDecProfileDetailHaveValueWithoutTitleText(
//                                     widgetColumn: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           _languageName,
//                                           style: bodyTextNormal(
//                                               null, null, FontWeight.bold),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         SizedBox(
//                                           height: 5,
//                                         ),
//                                         Text(
//                                           _languageLevelName,
//                                           style:
//                                               bodyTextNormal(null, null, null),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ],
//                                     ),

//                                     //
//                                     //Button Left For Update
//                                     statusLeft: "have",
//                                     pressLeft: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => Language(
//                                             id: i['_id'],
//                                             language: i,
//                                           ),
//                                         ),
//                                       ).then(widget.onGoBack);
//                                     },
//                                     //
//                                     //Button Right For Delete
//                                     statusRight: "have",
//                                     pressRight: () async {
//                                       var result = await showDialog(
//                                           context: context,
//                                           builder: (context) {
//                                             return NewVer2CustAlertDialogWarningBtnConfirmCancel(
//                                               title: "delete_this_info".tr,
//                                               contentText: "language_skill".tr +
//                                                   ': ${i['LanguageId']['name']}',
//                                               textButtonLeft: 'cancel'.tr,
//                                               textButtonRight: 'confirm'.tr,
//                                               textButtonRightColor:
//                                                   AppColors.fontWhite,
//                                             );
//                                           });
//                                       if (result == 'Ok') {
//                                         print("confirm delete");
//                                         deleteLanguage(i['_id']);
//                                       }
//                                     },
//                                   ),
//                                 );
//                               },
//                             ),
//                             CustomButtonIconText(
//                               buttonColor: AppColors.lightPrimary,
//                               widgetPrefixIcon: FaIcon(
//                                 FontAwesomeIcons.plus,
//                                 color: AppColors.fontPrimary,
//                               ),
//                               text: "add".tr + " " + "language_skill".tr,
//                               textColor: AppColors.fontPrimary,
//                               press: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => Language(),
//                                   ),
//                                 ).then(widget.onGoBack);
//                               },
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Divider(
//                               height: 2,
//                               color: AppColors.borderBG,
//                             )
//                           ],
//                         )
//                       : BoxDecDottedBorderProfileDetail(
//                           boxDecColor: AppColors.lightPrimary,
//                           title: "language_skill".tr,
//                           titleFontWeight: FontWeight.bold,
//                           text: "add all languages".tr,
//                           buttonText: "add".tr,
//                           pressButton: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => Language(),
//                               ),
//                             ).then(widget.onGoBack);
//                           },
//                         ),
//                   SizedBox(
//                     height: 20,
//                   ),

//                   //
//                   //
//                   //BoxDecoration DottedBorder Skill
//                   widget.skills.length > 0
//                       ? Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               "skills".tr,
//                               style: bodyTextMedium(
//                                   null, AppColors.fontPrimary, FontWeight.bold),
//                             ),
//                             Text(
//                               "you should list skills".tr,
//                               style: bodyTextSmall(
//                                 null,
//                                 AppColors.fontGreyOpacity,
//                                 null,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 15,
//                             ),
//                             ListView.builder(
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               itemCount: widget.skills.length,
//                               itemBuilder: (context, index) {
//                                 dynamic i = widget.skills[index];
//                                 _skillName = i['keySkillId']['name'];
//                                 _skillLevelName = i['skillLevelId']['name'];

//                                 return Padding(
//                                   padding: const EdgeInsets.only(bottom: 5),
//                                   child:
//                                       BoxDecProfileDetailHaveValueWithoutTitleText(
//                                     widgetColumn: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           _skillName,
//                                           style: bodyTextNormal(
//                                               null, null, FontWeight.bold),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         SizedBox(
//                                           height: 5,
//                                         ),
//                                         Text(
//                                           _skillLevelName,
//                                           style:
//                                               bodyTextNormal(null, null, null),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ],
//                                     ),
//                                     //
//                                     //Button Left For Update
//                                     statusLeft: "have",
//                                     pressLeft: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => Skill(
//                                             id: i['_id'],
//                                             skill: i,
//                                           ),
//                                         ),
//                                       ).then(widget.onGoBack);
//                                     },
//                                     //
//                                     //Button Right For Delete
//                                     statusRight: "have",
//                                     pressRight: () async {
//                                       var result = await showDialog(
//                                           context: context,
//                                           builder: (context) {
//                                             return NewVer2CustAlertDialogWarningBtnConfirmCancel(
//                                               title: "delete_this_info".tr,
//                                               contentText: "skills".tr +
//                                                   ": ${i['keySkillId']['name']}",
//                                               textButtonLeft: 'cancel'.tr,
//                                               textButtonRight: 'confirm'.tr,
//                                               textButtonRightColor:
//                                                   AppColors.fontWhite,
//                                             );
//                                           });
//                                       if (result == 'Ok') {
//                                         print("confirm delete");
//                                         deleteSkill(i['_id']);
//                                       }
//                                     },
//                                   ),
//                                 );
//                               },
//                             ),
//                             CustomButtonIconText(
//                               buttonColor: AppColors.lightPrimary,
//                               widgetPrefixIcon: FaIcon(
//                                 FontAwesomeIcons.plus,
//                                 color: AppColors.fontPrimary,
//                               ),
//                               text: "add".tr + " " + 'skill'.tr,
//                               textColor: AppColors.fontPrimary,
//                               press: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => Skill(),
//                                   ),
//                                 ).then(widget.onGoBack);
//                               },
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Divider(
//                               height: 2,
//                               color: AppColors.borderBG,
//                             )
//                           ],
//                         )
//                       : BoxDecDottedBorderProfileDetail(
//                           boxDecColor: AppColors.lightPrimary,
//                           title: "skills".tr,
//                           titleFontWeight: FontWeight.bold,
//                           text: "you should list skills".tr,
//                           buttonText: "add".tr,
//                           pressButton: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => Skill(),
//                               ),
//                             ).then(widget.onGoBack);
//                           },
//                         ),
//                   SizedBox(
//                     height: 20,
//                   ),

//                   // Button(
//                   //   text: "Request for review",
//                   //   fontWeight: FontWeight.bold,
//                   // ),
//                   // SizedBox(
//                   //   height: 30,
//                   // ),
//                 ],
//               ),
//             ),

//             // SizedBox(
//             //   height: 10,
//             // ),
//           ],
//         ),
//       ),
//     );
//   }

//   deleteEducation(String id) async {
//     await deleteData(deleteEducationSeekerApi + id).then((value) {
//       print(value);
//       if (value['message'] == 'Delete succeed') {
//         setState(() {
//           widget.onGoBack(id); // Corrected: invoke the callback function
//         });
//       }
//     });
//   }

//   deleteWorkHistory(String id) async {
//     await deleteData(deleteWorkHistorySeekerApi + id).then((value) {
//       print(value);
//       if (value['message'] == 'Delete succeed') {
//         setState(() {
//           widget.onGoBack(id); // Corrected: invoke the callback function
//         });
//       }
//     });
//   }

//   deleteLanguage(String id) async {
//     await deleteData(deleteLanguageSeekerApi + id).then((value) {
//       print(value);
//       if (value['message'] == 'Delete succeed') {
//         setState(() {
//           widget.onGoBack(id); // Corrected: invoke the callback function
//         });
//       }
//     });
//   }

//   deleteSkill(String id) async {
//     await deleteData(deleteSkillSeekerApi + id).then((value) {
//       print(value);
//       if (value['message'] == 'Delete succeed') {
//         setState(() {
//           widget.onGoBack(id); // Corrected: invoke the callback function
//         });
//       }
//     });
//   }
// }
