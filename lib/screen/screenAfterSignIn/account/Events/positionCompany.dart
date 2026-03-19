// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, non_constant_identifier_names, prefer_interpolation_to_compose_strings, avoid_print, use_build_context_synchronously, deprecated_member_use

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/formatNumber.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/helpers/eventAvailableHelper.dart';
import 'package:app/provider/eventAvailableProvider.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/Events/detailPosition.dart';
import 'package:app/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PositionCompany extends StatefulWidget {
  const PositionCompany({
    Key? key,
  }) : super(key: key);

  @override
  State<PositionCompany> createState() => _PositionCompanyState();
}

class _PositionCompanyState extends State<PositionCompany>
    with EventAvailableHelper {
  String _salary = "";
  int _staffQTY = 0;

  // applyByJobId(String jobId) async {
  //   var res = await postData(applyJobIdSeekerApi, {"_id": jobId});
  //   print("res applyByJobId: " + res.toString());
  //   if (res["message"] == "Your applied is complete.") {
  //     // Display success dialog
  //     showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (dialogContext) {
  //         return NewVer2CustAlertDialogSuccessBtnConfirm(
  //           title: "successfully".tr,
  //           contentText: "applied_success".tr,
  //           textButton: "ok".tr,
  //           press: () async {
  //             // ປິດ success dialog
  //             Navigator.of(dialogContext).pop();
  //           },
  //         );
  //       },
  //     );
  //     return true;
  //   } else {
  //     // Display warning dialog
  //     showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (dialogContext) {
  //         return NewVer5CustAlertDialogWarningBtnConfirm(
  //           title: "warning".tr,
  //           contentText: "already_applied".tr,
  //           textButton: "ok".tr,
  //           press: () async {
  //             // ປິດ success dialog
  //             Navigator.of(dialogContext).pop();
  //           },
  //         );
  //       },
  //     );
  //     return true;
  //   }
  // }

  @override
  void initState() {
    super.initState();

    // Should use setState() or markNeedsBuild() called during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventAvailableProvider>().fetchCompanyByIdListPosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventAvailableProvider = context.watch<EventAvailableProvider>();
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBarDefault(
          systemOverlayStyleColor: SystemUiOverlayStyle.dark,
          backgroundColor: AppColors.backgroundWhite,
          textTitle: "",
          fontWeight: FontWeight.bold,
          textColor: AppColors.fontDark,
          leadingPress: () {
            Navigator.pop(context);
          },
          leadingIcon: Icon(Icons.arrow_back),
        ),
        body: SafeArea(
          child: eventAvailableProvider.isLoadingPositionCompany
              ? Container(
                  color: AppColors.backgroundWhite,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(child: CustomLoadingLogoCircle()),
                )
              : Container(
                  color: AppColors.backgroundWhite,
                  height: double.infinity,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Company name
                          Text(
                            "${eventAvailableProvider.companyName}",
                            style: bodyTextMedium(null, null, FontWeight.bold),
                          ),

                          SizedBox(height: 20),

                          //List Company Position
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: eventAvailableProvider
                                  .companyListPosition.length,
                              itemBuilder: (context, index) {
                                dynamic i = eventAvailableProvider
                                    .companyListPosition[index];

                                _staffQTY = int.parse(i["staffQTY"].toString());

                                if (i["salary"] != null && i["salary"] != "") {
                                  int IntSalary =
                                      int.parse(i["salary"].toString());
                                  _salary = formatNumSalary(IntSalary);
                                }

                                return Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailPositionComapny(
                                            id: i["_id"],
                                            companyName: eventAvailableProvider
                                                .companyName,
                                            logo: eventAvailableProvider
                                                .companyLogoEventAvailable,
                                            title: i["title"],
                                            salary: i["salary"] == null
                                                ? ""
                                                : i["salary"].toString(),
                                            description: i["description"],
                                            isNegotiable: i["isNegotiable"],
                                            isAppliedEvenJobCompany:
                                                i["isApplied"],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundWhite,
                                        border: Border.all(
                                            color: AppColors.dark200),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //Title
                                          Text(
                                            "${i["title"]}",
                                            style: bodyTextMedium(
                                                "NotoSansLaoLoopedBold",
                                                null,
                                                FontWeight.bold),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),

                                          SizedBox(height: 10),

                                          //Salary
                                          Row(
                                            children: [
                                              Text(
                                                "starting_salary".tr,
                                                style: bodyTextMaxNormal(
                                                    null, null, null),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                i["isNegotiable"]
                                                    ? "negotiable".tr
                                                    : "${_salary}",
                                                style: bodyTextMaxNormal(
                                                    i["isNegotiable"]
                                                        ? null
                                                        : "SatoshiBlack",
                                                    AppColors.teal,
                                                    FontWeight.bold),
                                              ),
                                              SizedBox(width: 5),
                                              if (!i["isNegotiable"])
                                                Text(
                                                  "lak".tr,
                                                  style: bodyTextMaxNormal(
                                                      null, null, null),
                                                ),
                                            ],
                                          ),

                                          SizedBox(height: 5),

                                          //ເປີດຮັບອັດຕາ
                                          Row(
                                            children: [
                                              Text(
                                                "curently_open".tr,
                                                style: bodyTextMaxNormal(
                                                    null, null, null),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                "${_staffQTY}",
                                                style: bodyTextMaxNormal(
                                                    "SatoshiBlack",
                                                    AppColors.teal,
                                                    FontWeight.bold),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                "position".tr,
                                                style: bodyTextMaxNormal(
                                                    null, null, null),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 10),

                                          //Button Detail / Applied
                                          Row(
                                            children: [
                                              //Button Detail Position
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailPositionComapny(
                                                        id: i["_id"],
                                                        companyName:
                                                            i["companyName"],
                                                        logo: eventAvailableProvider
                                                            .companyLogoEventAvailable,
                                                        title: i["title"],
                                                        salary:
                                                            i["salary"] == null
                                                                ? ""
                                                                : i["salary"]
                                                                    .toString(),
                                                        description:
                                                            i["description"],
                                                        isNegotiable:
                                                            i["isNegotiable"],
                                                        isAppliedEvenJobCompany:
                                                            i["isApplied"],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                      color: AppColors.teal
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          color:
                                                              AppColors.teal)),
                                                  child: Text(
                                                    "view_details".tr,
                                                    style: bodyTextNormal(null,
                                                        AppColors.teal, null),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(width: 10),

                                              //Button Applied
                                              if (eventAvailableProvider
                                                  .isApplied)
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (!i["isApplied"]) {
                                                      print(
                                                          "approved event company isAppliedEvenJobCompany = false");
                                                      var result =
                                                          await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return NewVer3CustAlertDialogWarningPictrueBtnConfirmCancel(
                                                                  statusLogo:
                                                                      eventAvailableProvider.companyLogoEventAvailable !=
                                                                              ""
                                                                          ? ""
                                                                          : "ImageAsset",
                                                                  logo: eventAvailableProvider
                                                                              .companyLogoEventAvailable !=
                                                                          ""
                                                                      ? eventAvailableProvider
                                                                          .companyLogoEventAvailable
                                                                      : "no-image-available.png",
                                                                  title:
                                                                      "apply_job_modal_title"
                                                                          .tr,
                                                                  contentText:
                                                                      "${i["title"]}",
                                                                  textButtonLeft:
                                                                      'cancel'
                                                                          .tr,
                                                                  textButtonRight:
                                                                      'confirm'
                                                                          .tr,
                                                                );
                                                              });
                                                      if (result == 'Ok') {
                                                        setState(() {
                                                          i["isApplied"] = true;
                                                        });

                                                        // applyByJobId(
                                                        //     i["_id"].toString());
                                                        applyJobCompanyBySeekerHelper(
                                                            i["_id"]
                                                                .toString());
                                                      }
                                                    }
                                                  },
                                                  child: !i["isApplied"]
                                                      ? Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 8),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                AppColors.teal,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .teal),
                                                          ),
                                                          child: Text(
                                                            "apply".tr,
                                                            style: bodyTextNormal(
                                                                null,
                                                                AppColors
                                                                    .fontWhite,
                                                                null),
                                                          ),
                                                        )
                                                      : Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 8),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .dark400,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .dark400),
                                                          ),
                                                          child: Text(
                                                            "applied".tr,
                                                            style: bodyTextNormal(
                                                                null,
                                                                AppColors
                                                                    .fontWhite,
                                                                null),
                                                          ),
                                                        ),
                                                ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          SizedBox(height: 10),
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
