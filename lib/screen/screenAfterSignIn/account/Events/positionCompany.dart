// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/formatNumber.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/Events/detailPosition.dart';
import 'package:app/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PositionCompany extends StatefulWidget {
  const PositionCompany(
      {Key? key,
      required this.companyAvailableEventId,
      required this.isApplied})
      : super(key: key);
  final String companyAvailableEventId;
  final bool isApplied;

  @override
  State<PositionCompany> createState() => _PositionCompanyState();
}

class _PositionCompanyState extends State<PositionCompany> {
  List _companayPosition = [];
  String _companyName = "";
  String _title = "";
  String _description = "";

  String _salary = "";
  int _staffQTY = 0;

  getCompanyIdJobAvailable() async {
    var res = await postData(getCompanyIdAvailableEventSeekerApi, {
      "page": "",
      "perPage": "",
      "companyId": "${widget.companyAvailableEventId}"
    });

    _companyName = res["companyName"];
    _companayPosition = res["info"];

    setState(() {});
  }

  applyByJobId(String jobId) async {
    var res = await postData(applyJobIdSeekerApi, {"_id": jobId});
    print("res applyByJobId: " + res.toString());

    if (res["message"] == "Your applied is complete.") {
      // ສະແດງ success dialog
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "successful".tr,
            contentText: "applied_success".tr,
            textButton: "ok".tr,
            press: () async {
              // ປິດ success dialog
              Navigator.of(dialogContext).pop();
            },
          );
        },
      );

      return true;
    } else {
      // ສະແດງ warning dialog
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) {
          return NewVer5CustAlertDialogWarningBtnConfirm(
            title: "warning".tr,
            contentText: "already_applied".tr,
            textButton: "ok".tr,
            press: () async {
              // ປິດ success dialog
              Navigator.of(dialogContext).pop();
            },
          );
        },
      );

      return true;
    }
  }

  @override
  void initState() {
    super.initState();

    getCompanyIdJobAvailable();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBarDefault(
          backgroundColor: AppColors.dark100,
          textTitle: "",
          fontWeight: FontWeight.bold,
          textColor: AppColors.fontDark,
          leadingPress: () {
            Navigator.pop(context);
          },
          leadingIcon: Icon(Icons.arrow_back),
        ),
        body: SafeArea(
          child: Container(
            color: AppColors.dark100,
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    //
                    //Company name
                    Text(
                      "${_companyName}",
                      style: bodyTextMedium(null, null, FontWeight.bold),
                    ),

                    SizedBox(height: 20),

                    //
                    //
                    //List Company Position
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _companayPosition.length,
                        itemBuilder: (context, index) {
                          var i = _companayPosition[index];
                          _title = i["title"];
                          _description = i["description"];
                          int IntSalary = int.parse(i["salary"].toString());
                          _salary = formatNumSalary(IntSalary);
                          _staffQTY = int.parse(i["staffQTY"].toString());

                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPositionComapny(
                                      id: i["_id"],
                                      title: i["title"],
                                      salary: i["salary"].toString(),
                                      description: i["description"],
                                      isApplied: widget.isApplied,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundWhite,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //
                                    //
                                    //Title
                                    Text(
                                      "${_title}",
                                      style: bodyTextMedium(
                                          "NotoSansLaoLoopedBold",
                                          null,
                                          FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    SizedBox(height: 10),

                                    //
                                    //
                                    //Salary
                                    Row(
                                      children: [
                                        Text(
                                          "ເງິນເດືອນເລີ່ມຕົ້ນ",
                                          style: bodyTextMaxNormal(
                                              null, null, null),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "${_salary}",
                                          style: bodyTextMaxNormal(
                                              "SatoshiBlack",
                                              null,
                                              FontWeight.bold),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "ກີບ",
                                          style: bodyTextMaxNormal(
                                              null, null, null),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 5),

                                    //
                                    //
                                    //ເປີດຮັບອັດຕາ
                                    Row(
                                      children: [
                                        Text(
                                          "ເປີດຮັບ",
                                          style: bodyTextMaxNormal(
                                              null, null, null),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "${_staffQTY}",
                                          style: bodyTextMaxNormal(
                                              "SatoshiBlack",
                                              null,
                                              FontWeight.bold),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "ອັດຕາ",
                                          style: bodyTextMaxNormal(
                                              null, null, null),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 10),

                                    //
                                    //
                                    //Button detail / register
                                    Row(
                                      children: [
                                        //
                                        //
                                        //Button Detail Position
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailPositionComapny(
                                                  id: i["_id"],
                                                  title: i["title"],
                                                  salary:
                                                      i["salary"].toString(),
                                                  description: i["description"],
                                                  isApplied: widget.isApplied,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 8),
                                            decoration: BoxDecoration(
                                                color: AppColors.teal
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    color: AppColors.teal)),
                                            child: Text(
                                              "ເບິ່ງລາຍລະອຽດ",
                                              style: bodyTextNormal(
                                                  null, AppColors.teal, null),
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: 10),

                                        //
                                        //
                                        //Button Register
                                        if (widget.isApplied == true)
                                          GestureDetector(
                                            onTap: () {
                                              applyByJobId(i["_id"].toString());
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: AppColors.teal,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    color: AppColors.teal),
                                              ),
                                              child: Text(
                                                "ສະໝັກ",
                                                style: bodyTextNormal(null,
                                                    AppColors.fontWhite, null),
                                              ),
                                            ),
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    SizedBox(
                      height: 10,
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
