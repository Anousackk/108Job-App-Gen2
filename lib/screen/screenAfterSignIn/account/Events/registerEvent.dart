// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, avoid_print, prefer_final_fields, unused_field, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, deprecated_member_use, prefer_interpolation_to_compose_strings, use_build_context_synchronously, unused_local_variable, unnecessary_string_interpolations, prefer_adjacent_string_concatenation

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/provider/eventAvailableProvider.dart';
import 'package:app/provider/profileProvider.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/Events/eventTicket.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/Events/positionCompany.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/myProfile.dart';
import 'package:app/screen/screenAfterSignIn/account/Events/widget/eventBannerShirmmerWidget.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RegisterEvent extends StatefulWidget {
  const RegisterEvent({
    Key? key,
  }) : super(key: key);
  @override
  State<RegisterEvent> createState() => _RegisterEventState();
}

class _RegisterEventState extends State<RegisterEvent> {
  final ScrollController _scrollController = ScrollController();

  int? _pressIndexBox;

  pressApplyEvent() async {
    final eventAvailableProvider = context.read<EventAvailableProvider>();

    // Display AlertDialog Loading First
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    final res = await eventAvailableProvider.applyEvent();

    final statusCode = res?["statusCode"];

    if (!context.mounted) return;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    print("apply event: " + res.toString());

    if (statusCode == 200 || statusCode == 201) {
      await eventAvailableProvider.fetchEventAvailable();
      await eventAvailableProvider.fetchStatisticEvent();

      await showDialog(
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "successfully".tr,
            contentText: "registered_attend".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.of(context).pop(); // Close dialog
            },
          );
        },
      );
    } else if (statusCode == 409) {
      var result = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return NewVer2CustAlertDialogWarningBtnConfirmCancel(
              title: "title_pls_update_profile".tr,
              contentText: "text_pls_update_profile_complete".tr,
              textButtonLeft: "cancel".tr,
              textButtonRight: 'continue'.tr,
            );
          });
      if (result == "Ok") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyProfile(
              status: "Event",
            ),
          ),
        );
      }
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "${res?["body"]?["message"]}",
            textButton: "ok".tr,
          );
        },
      );
    }
  }

  pullDownRefreshScreen() {
    // Future.delayed(Duration(seconds: 1), () {
    context.read<EventAvailableProvider>().fetchStatisticEvent();
    context.read<EventAvailableProvider>().fetchEventAvailable();
    context.read<ProfileProvider>().fetchProfileSeeker();
    // });
  }

  @override
  void initState() {
    super.initState();

    // Should use setState() or markNeedsBuild() called during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventAvailableProvider>().fetchCompanyEventAvailable();
    });
    context.read<EventAvailableProvider>().fetchStatisticEvent();
    context.read<EventAvailableProvider>().fetchEventBanner();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final eventAvailableProvider = context.watch<EventAvailableProvider>();
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBarAddAction(
          systemOverlayStyleColor: SystemUiOverlayStyle.light,
          backgroundColor: AppColors.teal,
          leadingIcon: Icon(Icons.arrow_back),
          leadingPress: () {
            Navigator.pop(context);
          },
          textTitle: '',
          action: [
            //
            //
            //Button Ticket Event
            //ກວດສະຖານະເປັນ Basic Job Seeker ແລະ ສະຖານະງານຈັດຂຶ້ນ ແລະ ກົດລົງທະບຽນແລ້ວ
            // profileProvider.memberLevel == "Basic Job Seeker" ||
            // profileProvider.memberLevel == "Expert Job Seeker" &&
            if (eventAvailableProvider.isApplied)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventTicket(),
                    ),
                  );
                },
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    shape: BoxShape.circle,
                  ),
                  child: Align(
                    child: Text(
                      "\uf145",
                      style: fontAwesomeSolid(null, 20, AppColors.teal, null),
                    ),
                  ),
                ),
              ),

            SizedBox(width: 20),

            //Button scan QR code
            //ກວດສະຖານະເປັນ Expert Job Seeker ແລະ ສະຖານະງານຈັດຂຶ້ນ
            // if (_memberLevel == "Basic Job Seeker" &&
            //     eventAvailableProvider.eventInfo != null &&
            //     eventAvailableProvider.isApplied == true)
            //   GestureDetector(
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => QRScanner(),
            //         ),
            //       );
            //     },
            //     child: Container(
            //       height: 45,
            //       width: 45,
            //       decoration: BoxDecoration(
            //         color: AppColors.backgroundWhite,
            //         shape: BoxShape.circle,
            //       ),
            //       child: Icon(
            //         Icons.qr_code_scanner_outlined,
            //         color: AppColors.teal,
            //         size: 25,
            //       ),
            //     ),
            //   ),
            // SizedBox(width: 20)
          ],
        ),
        body: SafeArea(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Column(
                children: [
                  //
                  //
                  //Section Content
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await pullDownRefreshScreen();
                      },
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            //
                            //
                            // Cover Image Event
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.bottomCenter,
                              children: [
                                // Event Banner Image
                                Container(
                                  color: AppColors.teal,
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 20,
                                    bottom: 90,
                                  ),
                                  child: eventAvailableProvider
                                          .isLoadingCompanyEventAvailable
                                      ? EventBannerShirmmerWidget()
                                      : AspectRatio(
                                          // aspectRatio: 16 / 9,
                                          aspectRatio: 16 / 6,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.dark100,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.dark
                                                      .withOpacity(0.05),
                                                  offset: Offset(3, 2),
                                                  blurRadius: 4,
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                            ),
                                            width: double.infinity,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              // child: Image.asset(
                                              //   'assets/image/cover_wiifair_10.jpg',
                                              // ),

                                              child: Image.network(
                                                "${eventAvailableProvider.eventBannerImage}",
                                                fit: BoxFit.contain,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'assets/image/108job-logo-text.png',
                                                    fit: BoxFit.contain,
                                                  ); // Display an error message
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                ),

                                //Box Statistic Event
                                Positioned(
                                  bottom: -60,
                                  left: 0,
                                  right: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Container(
                                      height: 130,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: AppColors.dark),
                                      child: Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${eventAvailableProvider.candidateTotals}",
                                                    style: bodyTextMaxMedium(
                                                        "SatoshiBlack",
                                                        AppColors.fontWhite,
                                                        FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "candidates".tr,
                                                    style: bodyTextMaxNormal(
                                                        null,
                                                        AppColors.fontWhite,
                                                        FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 3,
                                            color: AppColors.borderWhite,
                                            height: 40,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${eventAvailableProvider.companyTotals}",
                                                    style: bodyTextMaxMedium(
                                                        "SatoshiBlack",
                                                        AppColors.fontWhite,
                                                        FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "company".tr,
                                                    style: bodyTextMaxNormal(
                                                        null,
                                                        AppColors.fontWhite,
                                                        FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 3,
                                            color: AppColors.borderWhite,
                                            height: 40,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${eventAvailableProvider.jobTotals}",
                                                    style: bodyTextMaxMedium(
                                                        "SatoshiBlack",
                                                        AppColors.fontWhite,
                                                        FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "position".tr,
                                                    style: bodyTextMaxNormal(
                                                        null,
                                                        AppColors.fontWhite,
                                                        FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 85),

                            //
                            //
                            // Card Event Pass
                            if (eventAvailableProvider.isApplied &&
                                    eventAvailableProvider.myAppliedInfo !=
                                        null ||
                                eventAvailableProvider.qrString != "")
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundWhite,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.teal),
                                  ),
                                  child: Column(
                                    children: [
                                      // Header Event Pass
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: AppColors.teal,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "event_pass".tr,
                                            style: bodyTextMedium(
                                                null,
                                                AppColors.fontWhite,
                                                FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      // Content Event Pass
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            // Profile Image
                                            Container(
                                              width: 80,
                                              height: 80,
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color:
                                                    AppColors.backgroundWhite,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    color: AppColors.teal,
                                                    width: 2),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: profileProvider
                                                            .imageSrc ==
                                                        ""
                                                    ? Image.asset(
                                                        'assets/image/defprofile.jpg',
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(
                                                        "${profileProvider.imageSrc}",
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Image.asset(
                                                            'assets/image/defprofile.jpg',
                                                            fit: BoxFit.cover,
                                                          ); // Display an error message
                                                        },
                                                      ),
                                              ),
                                            ),
                                            SizedBox(height: 10),

                                            // Candidate Name
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "candidate_name".tr + ": ",
                                                  style: bodyTextNormal(null,
                                                      AppColors.dark, null),
                                                ),
                                                Text(
                                                  "${eventAvailableProvider.candidateName}",
                                                  style: bodyTextNormal(
                                                      null,
                                                      AppColors.teal,
                                                      FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),

                                            // Candidate ID
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "candidate_id".tr + ": ",
                                                  style: bodyTextNormal(null,
                                                      AppColors.dark, null),
                                                ),
                                                Text(
                                                  "${eventAvailableProvider.candidateID}",
                                                  style: bodyTextNormal(
                                                      null,
                                                      AppColors.teal,
                                                      FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 20),

                                            //QR coed
                                            QrImageView(
                                              padding: EdgeInsets.zero,
                                              data: eventAvailableProvider
                                                  .qrString,
                                              size: 150,
                                            ),
                                            SizedBox(height: 20),

                                            Button(
                                              buttonColor: AppColors.warning600,
                                              text: "button_update_profile".tr,
                                              textColor: AppColors.fontDark,
                                              press: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyProfile(
                                                            status: "Event"),
                                                  ),
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(height: 20),

                            //
                            //
                            //Section Information Event
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${eventAvailableProvider.eventInfoName}",
                                    style: bodyTextMedium(
                                        null, null, FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ItemEventInfo(
                                    // prefixIconStr: "\uf3c5",
                                    // prefixIconColor: AppColors.iconGray,
                                    title: "event_address".tr + ":",
                                    text:
                                        "${eventAvailableProvider.eventInfoAddress}",
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ItemEventInfo(
                                    // prefixIconStr: "\uf073",
                                    // prefixIconColor: AppColors.iconGray,
                                    title: "event_date_time".tr + ":",
                                    text:
                                        "${eventAvailableProvider.eventInfoOpeningTime}",
                                    // text: "8 Aug 20225 Time 08:00 - 17:00",
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20),
                            Divider(color: AppColors.dark300),
                            SizedBox(height: 20),

                            //
                            //
                            //Section company
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    //ບໍລິສັດທີ່ເປີດຮັບສະໝັກພະນັກງານ
                                    Text(
                                      "companies_current_hiring".tr,
                                      style: bodyTextMedium(
                                          null, null, FontWeight.bold),
                                    ),

                                    SizedBox(height: 20),

                                    //GridView Of Company Hiring
                                    if (eventAvailableProvider
                                        .companyEventAvailable.isNotEmpty)
                                      GridView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          childAspectRatio: 0.88,
                                        ),
                                        itemCount: eventAvailableProvider
                                            .companyEventAvailable.length,
                                        itemBuilder: (context, index) {
                                          final i = eventAvailableProvider
                                              .companyEventAvailable[index];

                                          bool isPressBox =
                                              _pressIndexBox == index;

                                          return GestureDetector(
                                            onTapDown: (_) {
                                              setState(() {
                                                _pressIndexBox = index;
                                              });
                                            },
                                            onTapUp: (_) {
                                              setState(() {
                                                _pressIndexBox =
                                                    null; // Reset after tap is done
                                              });
                                            },
                                            onTapCancel: () {
                                              setState(() {
                                                _pressIndexBox =
                                                    null; // Reset if touch is canceled (e.g. dragged away)
                                              });
                                            },
                                            onTap: () {
                                              eventAvailableProvider
                                                      .companyIdEventAvailable =
                                                  i["_id"] ?? "";
                                              eventAvailableProvider
                                                  .companyNameEventAvailable = i[
                                                      "companyName"] ??
                                                  "";
                                              eventAvailableProvider
                                                  .companyLogoEventAvailable = i[
                                                      "logo"] ??
                                                  "";
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PositionCompany(
                                                      // companyAvailableEventId:
                                                      //     i["_id"],
                                                      // logo: i["logo"],
                                                      // eventAvailableIsApplied:
                                                      // eventAvailableProvider
                                                      //     .isApplied,
                                                      ),
                                                ),
                                              );
                                            },
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                // Box Card Company Hiring
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: isPressBox
                                                            ? AppColors.teal
                                                            : AppColors
                                                                .dark200),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: isPressBox
                                                        ? AppColors.teal
                                                            .withOpacity(0.2)
                                                        : AppColors
                                                            .backgroundWhite,
                                                  ),
                                                  padding: EdgeInsets.all(10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      //Image company
                                                      Container(
                                                        width: 70,
                                                        height: 70,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .backgroundWhite,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                            color:
                                                                AppColors.teal,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child: i["logo"] ==
                                                                    ""
                                                                ? Image.asset(
                                                                    "assets/image/logo_wiifair_10.jpg",
                                                                  )
                                                                : Image.network(
                                                                    "https://storage.googleapis.com/108-bucket/${i["logo"]}",
                                                                    fit: BoxFit
                                                                        .contain,
                                                                    errorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return Image
                                                                          .asset(
                                                                        "assets/image/logo_wiifair_10.jpg",
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      ); // Display an error message
                                                                    },
                                                                  ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),

                                                      //Company name
                                                      Flexible(
                                                        child: Text(
                                                          "${i["companyName"]}",
                                                          style: bodyTextNormal(
                                                              null,
                                                              isPressBox
                                                                  ? AppColors
                                                                      .teal
                                                                  : null,
                                                              FontWeight.bold),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      SizedBox(height: 15),

                                                      //Company need position
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: isPressBox
                                                              ? AppColors.teal
                                                              : AppColors
                                                                  .buttonBG,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "curently_open"
                                                                  .tr,
                                                              style: bodyTextNormal(
                                                                  null,
                                                                  isPressBox
                                                                      ? AppColors
                                                                          .fontWhite
                                                                      : AppColors
                                                                          .fontGrey,
                                                                  null),
                                                            ),
                                                            Text(
                                                              " ${i["jobTotals"]} ",
                                                              style: bodyTextNormal(
                                                                  "SatoshiBold",
                                                                  isPressBox
                                                                      ? AppColors
                                                                          .fontWhite
                                                                      : AppColors
                                                                          .teal,
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                            Flexible(
                                                              child: Text(
                                                                "position".tr,
                                                                style: bodyTextNormal(
                                                                    null,
                                                                    isPressBox
                                                                        ? AppColors
                                                                            .fontWhite
                                                                        : AppColors
                                                                            .fontGrey,
                                                                    null),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),

                                                // Status Online Of Box Company Hiring
                                                if (i["isOnline"])
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 3),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.teal,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "online".tr,
                                                        style:
                                                            bodyTextMiniSmall(
                                                                null,
                                                                AppColors
                                                                    .fontWhite,
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              height:
                                  eventAvailableProvider.isApplied ? 20 : 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              //
              //
              //Button register event / continue to profile
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    //
                    //
                    //ກວດສະຖານະງານຈັດຂຶ້ນ ແລະ ຍັງບໍ່ທັນກົດລົງທະບຽນ
                    if (eventAvailableProvider.eventInfo != null &&
                        eventAvailableProvider.isApplied == false)
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            // if (profileProvider.memberLevel ==
                            //         "Basic Job Seeker" ||
                            //     profileProvider.memberLevel ==
                            //         "Expert Job Seeker") {
                            pressApplyEvent();
                            // } else {
                            //   var result = await showDialog(
                            //       barrierDismissible: false,
                            //       context: context,
                            //       builder: (context) {
                            //         return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                            //           title: "ກະລຸນາອັບເດດຂໍ້ມູນ",
                            //           contentText:
                            //               "ໄປໜ້າໂປຣໄຟສແລ້ວຕື່ມຂໍ້ມູນໃຫ້ຄົບ. \nຈຶ່ງສາມາດລົງທະບຽນເຂົ້າຮ່ວມງານໄດ້.",
                            //           textButtonLeft: "cancel".tr,
                            //           textButtonRight: 'continue'.tr,
                            //         );
                            //       });
                            //   if (result == "Ok") {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => MyProfile(
                            //           status: "Event",
                            //         ),
                            //       ),
                            //     );
                            //   }
                            // }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: AppColors.warning600,
                            ),
                            child: Center(
                              child: Text(
                                "register_event".tr,
                                style: buttonTextMedium(
                                    null, AppColors.fontDark, FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemCircleLine extends StatefulWidget {
  const ItemCircleLine({
    Key? key,
    this.text,
    required this.widgetTopLine,
    required this.widgetBottomLine,
  }) : super(key: key);
  final String? text;
  final Widget widgetTopLine, widgetBottomLine;

  @override
  State<ItemCircleLine> createState() => _ItemCircleLineState();
}

class _ItemCircleLineState extends State<ItemCircleLine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      // color: AppColors.red,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //top line
              Expanded(
                child: widget.widgetTopLine,
              ),
              //circle
              CircleAvatar(
                radius: 5,
                backgroundColor: AppColors.teal,
              ),
              //bottom line
              Expanded(
                child: widget.widgetBottomLine,
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(
              "${widget.text}",
              style: bodyTextNormal(null, null, null),
            ),
          )
        ],
      ),
    );
  }
}

class ItemEventInfo extends StatefulWidget {
  final String title;
  final String text;
  final String? prefixIconStr, fontFamilyPrefixIcon;
  final Color? prefixIconColor;

  const ItemEventInfo({
    required this.title,
    required this.text,
    Key? key,
    this.prefixIconStr,
    this.fontFamilyPrefixIcon,
    this.prefixIconColor,
  }) : super(key: key);

  @override
  State<ItemEventInfo> createState() => _ItemEventInfoState();
}

class _ItemEventInfoState extends State<ItemEventInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.title,
          style: bodyTextMaxSmall(null, AppColors.fontGrey, null),
        ),
        Text(
          widget.text,
          style: bodyTextMaxNormal("NotoSansLaoLoopedBold", null, null),
        ),
      ],
    );
  }
}
