// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, avoid_print, prefer_final_fields, unused_field, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/Events/eventTicket.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/Events/positionCompany.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/Events/scannerQRCode.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
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

  int _companyJobTotals = 0;
  int _candidateTotals = 0;
  int _companyTotals = 0;
  int _jobTotals = 0;
  int? _pressIndexBox;

  bool _isLoading = true;

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
      company = res["info"];

      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getCompanyAvailable();
    getStatisticEvent();
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
                  if (widget.memberLevel == "Expert Job Seeker" &&
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
                  if (widget.memberLevel == "Expert Job Seeker" &&
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
                        //       if (widget.memberLevel == "Expert Job Seeker" &&
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
                        //       if (widget.memberLevel == "Expert Job Seeker" &&
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
                                    Container(
                                      color: AppColors.teal,
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 20,
                                          bottom: 90),
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Container(
                                          decoration: BoxDecoration(
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
                                            child: Image.asset(
                                              'assets/image/cover_wiifair_10.jpg',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
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
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.start,
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
                                                      isApplied:
                                                          widget.isApplied,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColors.teal),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: isPressBox
                                                      ? AppColors.teal
                                                          .withOpacity(0.2)
                                                      : AppColors
                                                          .backgroundWhite,
                                                ),
                                                padding: EdgeInsets.all(15),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    //
                                                    //
                                                    //Image company
                                                    Container(
                                                      width: 70,
                                                      height: 70,
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .backgroundWhite,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                          color: AppColors.teal,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          child: _logo == ""
                                                              ? Image.asset(
                                                                  "assets/image/logo_wiifair_10.jpg",
                                                                )
                                                              : Image.network(
                                                                  "https://storage.googleapis.com/108-bucket/${_logo}",
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

                                                    //
                                                    //
                                                    //Company name
                                                    Flexible(
                                                      child: Text(
                                                        _companyName,
                                                        style: bodyTextNormal(
                                                            null,
                                                            isPressBox
                                                                ? AppColors.teal
                                                                : null,
                                                            FontWeight.bold),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),

                                                    SizedBox(height: 10),

                                                    //
                                                    //
                                                    //Company need position
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                              vertical: 8),
                                                      decoration: BoxDecoration(
                                                          color: isPressBox
                                                              ? AppColors.teal
                                                              : AppColors.teal
                                                                  .withOpacity(
                                                                      0.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
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
                                                                "SatoshiBlack",
                                                                isPressBox
                                                                    ? AppColors
                                                                        .fontWhite
                                                                    : AppColors
                                                                        .teal,
                                                                null),
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

                                // ກິດຈະກຳພາຍໃນງານຈະມີ
                                //
                                // Padding(
                                //   padding: EdgeInsets.symmetric(horizontal: 20),
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Text(
                                //         "ກິດຈະກຳພາຍໃນງານຈະມີ:",
                                //         style:
                                //             bodyTextMedium(null, null, FontWeight.bold),
                                //       ),
                                //       SizedBox(
                                //         height: 10,
                                //       ),
                                //       ItemCircleLine(
                                //         widgetTopLine: Container(),
                                //         text: "ພົບກັບບໍລິສັດທີ່ເຂົ້າຮ່ວມ 25 ບໍລິສັດ",
                                //         widgetBottomLine: Container(
                                //           width: 2,
                                //           color: AppColors.teal,
                                //         ),
                                //       ),
                                //       ItemCircleLine(
                                //         widgetTopLine: Container(
                                //           width: 2,
                                //           color: AppColors.teal,
                                //         ),
                                //         text: "ຂຽນ CV ສະໝັກວຽກ",
                                //         widgetBottomLine: Container(
                                //           width: 2,
                                //           color: AppColors.teal,
                                //         ),
                                //       ),
                                //       ItemCircleLine(
                                //         widgetTopLine: Container(
                                //           width: 2,
                                //           color: AppColors.teal,
                                //         ),
                                //         text: "ພາລົງທະບຽນສະໝັກວຽກ",
                                //         widgetBottomLine: Container(
                                //           width: 2,
                                //           color: AppColors.teal,
                                //         ),
                                //       ),
                                //       ItemCircleLine(
                                //         widgetTopLine: Container(
                                //           width: 2,
                                //           color: AppColors.teal,
                                //         ),
                                //         text: "ທົດລອງສຳພາດວຽກ",
                                //         widgetBottomLine: Container(
                                //           width: 2,
                                //           color: AppColors.teal,
                                //         ),
                                //       ),
                                //       ItemCircleLine(
                                //         widgetTopLine: Container(
                                //           width: 2,
                                //           color: AppColors.teal,
                                //         ),
                                //         text: "ຮ່ວມຫຼິ້ນກິດຈະກຳພາຍໃນງານ",
                                //         widgetBottomLine: Container(
                                //           width: 2,
                                //           color: AppColors.teal,
                                //         ),
                                //       ),
                                //       ItemCircleLine(
                                //         widgetTopLine: Container(
                                //           width: 2,
                                //           color: AppColors.teal,
                                //         ),
                                //         text: "ຮັບຂອງລາງວັນຈາກກິດຈະກຳ",
                                //         widgetBottomLine: Container(),
                                //       ),
                                //       SizedBox(height: 20)
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),

                        //Bottom Button Register / Back
                        // Container(
                        //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        //   decoration: BoxDecoration(
                        //     color: AppColors.backgroundWhite,
                        //     // borderRadius: BorderRadius.only(
                        //     //   topLeft: Radius.circular(10),
                        //     //   topRight: Radius.circular(10),
                        //     // ),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: AppColors.dark.withOpacity(0.05),
                        //         offset: Offset(0, -6),
                        //         blurRadius: 4,
                        //         spreadRadius: 0,
                        //       ),
                        //     ],
                        //   ),
                        //   child: Stack(
                        //     clipBehavior: Clip.none,
                        //     alignment: AlignmentDirectional.topCenter,
                        //     children: [
                        //       Container(
                        //         // color: AppColors.red,
                        //         child: Row(
                        //           children: [
                        //             Expanded(
                        //               flex: 1,
                        //               child: Button(
                        //                 text: "back".tr,
                        //                 textColor: AppColors.fontDark,
                        //                 buttonColor: AppColors.backgroundWhite,
                        //                 press: () {
                        //                   Navigator.pop(context);
                        //                 },
                        //               ),
                        //             ),
                        //             Expanded(
                        //               flex: 1,
                        //               child: Button(
                        //                 text: "register".tr,
                        //                 textColor: AppColors.fontDark,
                        //                 buttonColor: AppColors.backgroundWhite,
                        //                 press: () {
                        //                   applyEvent();
                        //                 },
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //       Positioned(
                        //         top: -40,
                        //         left: 0,
                        //         right: 0,
                        //         child: Container(
                        //           height: 70,
                        //           width: 70,
                        //           decoration: BoxDecoration(
                        //             color: AppColors.teal,
                        //             shape: BoxShape.circle,
                        //             border: Border.all(
                        //               color: AppColors.backgroundWhite,
                        //               width: 5,
                        //             ),
                        //             boxShadow: [
                        //               BoxShadow(
                        //                 color: AppColors.dark.withOpacity(0.05),
                        //                 offset: Offset(0, -6),
                        //                 blurRadius: 4,
                        //                 spreadRadius: 0,
                        //               ),
                        //             ],
                        //           ),
                        //           child: Icon(
                        //             Icons.qr_code_scanner_outlined,
                        //             color: AppColors.fontWhite,
                        //             size: 30,
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // )
                      ],
                    ),

                    //
                    //
                    //
                    //
                    //
                    //ກວດສະຖານະເປັນ Expert Job Seeker ແລະ ສະຖານະງານຈັດຂຶ້ນ ແລະ ຍັງບໍ່ທັນກົດລົງທະບຽນ
                    if (widget.memberLevel == "Expert Job Seeker" &&
                        widget.eventInfo != null &&
                        widget.isApplied == false)
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Button(
                                  buttonColor: AppColors.teal,
                                  text: "register".tr,
                                  textColor: AppColors.fontWhite,
                                  press: () {
                                    applyEvent();
                                  },
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
