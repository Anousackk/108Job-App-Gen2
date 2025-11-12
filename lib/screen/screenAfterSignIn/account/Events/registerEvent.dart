// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, avoid_print, prefer_final_fields, unused_field, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, deprecated_member_use, prefer_interpolation_to_compose_strings, use_build_context_synchronously, unused_local_variable, unnecessary_string_interpolations, prefer_adjacent_string_concatenation

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/Events/eventTicket.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/Events/positionCompany.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/Events/scannerQRCode.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/myProfile.dart';
import 'package:app/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegisterEvent extends StatefulWidget {
  const RegisterEvent(
      {Key? key,
      this.eventInfoName,
      this.eventInfoAddress,
      this.eventInfoOpeningTime,
      this.eventInfoId,
      required this.isApplied,
      this.eventInfo,
      this.memberLevel,
      required this.imageSrc,
      required this.firstName,
      required this.lastName,
      this.objEventAvailable})
      : super(key: key);
  final String? eventInfoId,
      eventInfoName,
      eventInfoAddress,
      eventInfoOpeningTime,
      memberLevel;
  final String imageSrc, firstName, lastName;
  final objEventAvailable;
  final bool isApplied;
  final dynamic eventInfo;

  @override
  State<RegisterEvent> createState() => _RegisterEventState();
}

class _RegisterEventState extends State<RegisterEvent> {
  List company = [];

  String _companyName = "";
  String _logo = "";
  String _memberLevel = "";
  String _eventBannerImage = "";

  int _companyJobTotals = 0;
  int _candidateTotals = 0;
  int _companyTotals = 0;
  int _jobTotals = 0;
  int? _pressIndexBox;

  bool _isLoading = true;
  bool _isOnline = false;

  applyEvent() async {
    var res =
        await postData(applyEventSeekerApi, {"eventId": widget.eventInfoId});
    print("res apply event: " + res.toString());

    if (res["message"] == "Applied succeed") {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "successful".tr,
            contentText: "registered_attend".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context)
                  .pop("Applied Succeed"); // Return to first screen
            },
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "already_registered_attend".tr,
            textButton: "ok".tr,
          );
        },
      );
    }
  }

  getStatisticEvent() async {
    var res = await fetchData(getStatisticEventSeekerApi);
    _candidateTotals = int.parse(res["candidateTotals"].toString());
    _companyTotals = int.parse(res["companyTotals"].toString());
    _jobTotals = int.parse(res["jobTotals"].toString());

    setState(() {});
  }

  getCompanyAvailable() async {
    var res = await postData(
        getCompanyAvailableEventSeekerApi, {"page": "", "perPage": ""});

    setState(() {
      _memberLevel = widget.memberLevel.toString();
      print(
          "_memberLevel from method getCompanyAvailable: " + "${_memberLevel}");
      company = res["info"];
      _isLoading = false;
    });
  }

  getProfileSeeker() async {
    var res = await fetchData(getProfileSeekerApi);
    _memberLevel = res['profile']['memberLevel'];
    print("_memberLevel from method getProfileSeeker: " +
        _memberLevel.toString());

    setState(() {});
  }

  getEventInfo() async {
    var res = await fetchData(getEventBannerApi);
    _eventBannerImage = res["info"][0]["image"];
    print("res event banner image: " + _eventBannerImage.toString());

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getCompanyAvailable();
    getStatisticEvent();
    getEventInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: _isLoading
          ? Scaffold(
              body: Container(
                color: AppColors.dark100,
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: CustomLoadingLogoCircle(),
                ),
              ),
            )
          : Scaffold(
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
                  //ກວດສະຖານະເປັນ Expert Job Seeker ແລະ ສະຖານະງານຈັດຂຶ້ນ ແລະ ກົດລົງທະບຽນແລ້ວ
                  if (_memberLevel == "Expert Job Seeker" &&
                      widget.eventInfo != null &&
                      widget.isApplied == true)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventTicket(
                              imageSrc: widget.imageSrc,
                              firstName: widget.firstName,
                              lastName: widget.lastName,
                              objEventAvailable: widget.objEventAvailable,
                            ),
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
                            style: fontAwesomeSolid(
                                null, 20, AppColors.teal, null),
                          ),
                        ),
                      ),
                    ),

                  SizedBox(width: 10),

                  //
                  //
                  //Button scan QR code
                  //ກວດສະຖານະເປັນ Expert Job Seeker ແລະ ສະຖານະງານຈັດຂຶ້ນ
                  if (_memberLevel == "Expert Job Seeker" &&
                      widget.eventInfo != null &&
                      widget.isApplied == true)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRScanner(),
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
                        child: Icon(
                          Icons.qr_code_scanner_outlined,
                          color: AppColors.teal,
                          size: 25,
                        ),
                      ),
                    ),
                  SizedBox(width: 20)
                ],
              ),
              body: SafeArea(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Column(
                      children: [
                        //Section Appbar custom
                        // AppBarThreeWidgt(
                        //   boxColor: AppColors.teal,
                        //   //
                        //   //Widget Leading
                        //   //Navigator.pop
                        //   leading: GestureDetector(
                        //     onTap: () {
                        //       Navigator.pop(context);
                        //     },
                        //     child: ClipRRect(
                        //       borderRadius: BorderRadius.circular(100),
                        //       child: Container(
                        //         height: 45,
                        //         width: 45,
                        //         color: AppColors.teal,
                        //         child: Align(
                        //           alignment: Alignment.center,
                        //           child: Text(
                        //             "\uf060",
                        //             style: fontAwesomeRegular(
                        //                 null, 20, AppColors.iconLight, null),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        //   //
                        //   //
                        //   //Widget Title
                        //   //Text title
                        //   title: Text(
                        //     "",
                        //   ),
                        //   //
                        //   //
                        //   //Widget Actions
                        //   //Profile setting
                        //   actions: Row(
                        //     children: [
                        //       //
                        //       //
                        //       //Button Ticket Event
                        //       //ກວດສະຖານະເປັນ Expert Job Seeker ແລະ ສະຖານະງານຈັດຂຶ້ນ ແລະ ກົດລົງທະບຽນແລ້ວ
                        //       if (_memberLevel == "Expert Job Seeker" &&
                        //           widget.eventInfo != null &&
                        //           widget.isApplied == true)
                        //         GestureDetector(
                        //           onTap: () {
                        //             Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                 builder: (context) => EventTicket(
                        //                   imageSrc: widget.imageSrc,
                        //                   firstName: widget.firstName,
                        //                   lastName: widget.lastName,
                        //                   objEventAvailable:
                        //                       widget.objEventAvailable,
                        //                 ),
                        //               ),
                        //             );
                        //           },
                        //           child: Container(
                        //             height: 45,
                        //             width: 45,
                        //             decoration: BoxDecoration(
                        //               color: AppColors.backgroundWhite,
                        //               shape: BoxShape.circle,
                        //             ),
                        //             child: Align(
                        //               child: Text(
                        //                 "\uf145",
                        //                 style: fontAwesomeSolid(
                        //                     null, 20, AppColors.teal, null),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       SizedBox(width: 10),
                        //       //
                        //       //
                        //       //Button scan QR code
                        //       //ກວດສະຖານະເປັນ Expert Job Seeker ແລະ ສະຖານະງານຈັດຂຶ້ນ
                        //       if (_memberLevel == "Expert Job Seeker" &&
                        //           widget.eventInfo != null &&
                        //           widget.isApplied == true)
                        //         GestureDetector(
                        //           onTap: () {
                        //             Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                 builder: (context) => QRScanner(),
                        //               ),
                        //             );
                        //           },
                        //           child: Container(
                        //             height: 45,
                        //             width: 45,
                        //             decoration: BoxDecoration(
                        //               color: AppColors.backgroundWhite,
                        //               shape: BoxShape.circle,
                        //             ),
                        //             child: Icon(
                        //               Icons.qr_code_scanner_outlined,
                        //               color: AppColors.teal,
                        //               size: 25,
                        //             ),
                        //           ),
                        //         ),
                        //     ],
                        //   ),
                        // ),

                        //
                        //
                        //
                        //
                        //
                        //Section Content
                        Expanded(
                          child: SingleChildScrollView(
                            physics: ClampingScrollPhysics(),
                            child: Column(
                              children: [
                                //
                                //
                                //Section Cover Image Event
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    //
                                    //
                                    //Image Event
                                    Container(
                                      color: AppColors.teal,
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 20,
                                        bottom: 90,
                                      ),
                                      child: AspectRatio(
                                        // aspectRatio: 16 / 9,
                                        aspectRatio: 16 / 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.dark100,
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                                BorderRadius.circular(20),
                                            // child: Image.asset(
                                            //   'assets/image/cover_wiifair_10.jpg',
                                            // ),

                                            child: Image.network(
                                              "${_eventBannerImage}",
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/image/cover_wiifair_10.jpg',
                                                  fit: BoxFit.contain,
                                                ); // Display an error message
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    //
                                    //
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: AppColors.dark),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${_candidateTotals}",
                                                      style: bodyTextMaxMedium(
                                                          "SatoshiBlack",
                                                          AppColors.fontWhite,
                                                          FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "ຜູ້ສະໝັກ",
                                                      style: bodyTextMaxNormal(
                                                          null,
                                                          AppColors.fontWhite,
                                                          FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 3,
                                                color: AppColors.borderWhite,
                                                height: 40,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${_companyTotals}",
                                                      style: bodyTextMaxMedium(
                                                          "SatoshiBlack",
                                                          AppColors.fontWhite,
                                                          FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "ບໍລິສັດ",
                                                      style: bodyTextMaxNormal(
                                                          null,
                                                          AppColors.fontWhite,
                                                          FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 3,
                                                color: AppColors.borderWhite,
                                                height: 40,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${_jobTotals}",
                                                      style: bodyTextMaxMedium(
                                                          "SatoshiBlack",
                                                          AppColors.fontWhite,
                                                          FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "ຕຳແໜ່ງງານ",
                                                      style: bodyTextMaxNormal(
                                                          null,
                                                          AppColors.fontWhite,
                                                          FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                SizedBox(
                                  height: 85,
                                ),

                                //
                                //
                                //Section Information Event
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${widget.eventInfoName}",
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
                                        text: "${widget.eventInfoAddress}",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ItemEventInfo(
                                        // prefixIconStr: "\uf073",
                                        // prefixIconColor: AppColors.iconGray,
                                        title: "event_date_time".tr + ":",
                                        text: "${widget.eventInfoOpeningTime}",
                                        // text: "8 Aug 20225 Time 08:00 - 17:00",
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  color: AppColors.dark300,
                                ),
                                SizedBox(
                                  height: 20,
                                ),

                                //
                                //
                                //Section company
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        //
                                        //
                                        //ບໍລິສັດທີ່ເປີດຮັບສະໝັກພະນັກງານ
                                        Text(
                                          "ບໍລິສັດທີ່ເປີດຮັບສະໝັກພະນັກງານ",
                                          style: bodyTextMedium(
                                              null, null, FontWeight.bold),
                                        ),

                                        SizedBox(height: 20),

                                        //
                                        //
                                        //GridView of company
                                        GridView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: 0.88,
                                          ),
                                          itemCount: company.length,
                                          itemBuilder: (context, index) {
                                            final i = company[index];
                                            _companyName = i["companyName"];
                                            _logo = i["logo"];
                                            _companyJobTotals = i["jobTotals"];
                                            _isOnline = i["isOnline"];

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
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PositionCompany(
                                                      companyAvailableEventId:
                                                          i["_id"] ?? "",
                                                      logo: i["logo"],
                                                      isApplied:
                                                          widget.isApplied,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: isPressBox
                                                              ? AppColors.teal
                                                              : AppColors
                                                                  .borderGreyOpacity),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: isPressBox
                                                          ? AppColors.teal
                                                              .withOpacity(0.2)
                                                          : AppColors
                                                              .backgroundWhite,
                                                    ),
                                                    padding: EdgeInsets.all(15),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        //
                                                        //
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
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                              color: AppColors
                                                                  .teal,
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
                                                              child: _logo == ""
                                                                  ? Image.asset(
                                                                      "assets/image/logo_wiifair_10.jpg",
                                                                    )
                                                                  : Image
                                                                      .network(
                                                                      "https://storage.googleapis.com/108-bucket/${_logo}",
                                                                      fit: BoxFit
                                                                          .contain,
                                                                      errorBuilder: (context,
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

                                                        //
                                                        //
                                                        //Company name
                                                        Flexible(
                                                          child: Text(
                                                            _companyName,
                                                            style: bodyTextNormal(
                                                                null,
                                                                isPressBox
                                                                    ? AppColors
                                                                        .teal
                                                                    : null,
                                                                FontWeight
                                                                    .bold),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),

                                                        SizedBox(height: 10),

                                                        //
                                                        //
                                                        //Company need position
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 0,
                                                                  vertical: 8),
                                                          decoration: BoxDecoration(
                                                              color: isPressBox
                                                                  ? AppColors
                                                                      .teal
                                                                  : AppColors
                                                                      .buttonBG,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "ເປີດຮັບ",
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
                                                                " ${_companyJobTotals} ",
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
                                                              Text(
                                                                "ຕຳແໜ່ງ",
                                                                style: bodyTextNormal(
                                                                    null,
                                                                    isPressBox
                                                                        ? AppColors
                                                                            .fontWhite
                                                                        : AppColors
                                                                            .fontGrey,
                                                                    null),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  if (i["isOnline"])
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 8,
                                                                vertical: 3),
                                                        decoration:
                                                            BoxDecoration(
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
                                                          "Online",
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
                                  height: widget.isApplied ? 20 : 100,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    //
                    //
                    //
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
                          if (widget.eventInfo != null &&
                              widget.isApplied == false)
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  if (_memberLevel == "Expert Job Seeker") {
                                    applyEvent();
                                  } else {
                                    var result = await showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                            title: "ກະລຸນາອັບເດດຂໍ້ມູນ",
                                            contentText:
                                                "ໄປໜ້າໂປຣໄຟສແລ້ວຕື່ມຂໍ້ມູນໃຫ້ຄົບ. \nຈຶ່ງສາມາດລົງທະບຽນເຂົ້າຮ່ວມງານໄດ້.",
                                            textButtonLeft: "cancel".tr,
                                            textButtonRight: 'continue'.tr,
                                          );
                                        });
                                    if (result == "Ok") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyProfile(),
                                        ),
                                      ).then((val) {
                                        getProfileSeeker();
                                      });
                                    }
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    color: AppColors.warning600,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "ລົງທະບຽນເຂົ້າຮ່ວມງານ",
                                      style: buttonTextMedium(null,
                                          AppColors.fontDark, FontWeight.bold),
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
