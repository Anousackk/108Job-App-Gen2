// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, non_constant_identifier_names, unused_field, prefer_final_fields, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously, curly_braces_in_flow_control_structures, prefer_interpolation_to_compose_strings, unnecessary_null_comparison

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/formatNumber.dart';
import 'package:app/functions/htmlWidget.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/helpers/eventAvailableHelper.dart';
import 'package:app/provider/eventAvailableProvider.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/dialogDisplayImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/parser/html_to_delta.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DetailPositionComapny extends StatefulWidget {
  const DetailPositionComapny({
    Key? key,
    required this.title,
    required this.salary,
    required this.description,
    required this.id,
    this.logo,
    required this.isAppliedEvenJobCompany,
    required this.isNegotiable,
    required this.companyName,
  }) : super(key: key);
  final String id, companyName, title, salary, description;
  final String? logo;
  final bool isAppliedEvenJobCompany, isNegotiable;

  @override
  State<DetailPositionComapny> createState() => _DetailPositionComapnyState();
}

class _DetailPositionComapnyState extends State<DetailPositionComapny>
    with EventAvailableHelper {
  QuillController _quillController = QuillController.basic();
  FocusNode editorFocusNode = FocusNode();
  ScrollController _editorScrollController = ScrollController();

  String _salary = "";
  String _splitFigureDes = "";
  bool _isAppliedEvenJobCompany = false;

  fetchValue() async {
    setState(() {
      if (widget.salary != "" && widget.salary != null) {
        int IntSalary = int.parse("${widget.salary}");
        _salary = formatNumSalary(IntSalary);
      }
      _isAppliedEvenJobCompany = widget.isAppliedEvenJobCompany;

      try {
        final cleanedHtml = widget.description
            .replaceAll(RegExp(r'<figure.*?>'), '')
            .replaceAll('</figure>', '')
            .replaceAll('</p>', '<br>');

        print("cleanedHtml: " + cleanedHtml.toString());
        _splitFigureDes = cleanedHtml;

        final delta = HtmlToDelta().convert(cleanedHtml);
        _quillController.document = Document.fromDelta(delta);
        _quillController.readOnly = true;
      } catch (e, stack) {
        print("HTML to Delta conversion error: $e");
        print(stack);
      }
    });
  }

  // applyByJobId(String jobId) async {
  //   var res = await postData(applyJobIdSeekerApi, {"_id": jobId});
  //   print("res applyByJobId: " + res.toString());
  //   if (res["message"] == "Your applied is complete.") {
  //     // ສະແດງ success dialog
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
  //             // ຖ້າ success dialog ປີດກ່ອນແລ້ວຈຶ່ງກັບໄປໜ້າ PositionCompany
  //             await Future.delayed(Duration(milliseconds: 200));
  //             // ກັບໄປໜ້າ PositionCompany
  //             if (Navigator.canPop(context))
  //               Navigator.of(context).pop("AppliedEventJobCompany");
  //             ;
  //           },
  //         );
  //       },
  //     );
  //     return true;
  //   } else {
  //     // ສະແດງ warning dialog
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
  //             // ຖ້າ success dialog ປີດກ່ອນແລ້ວຈຶ່ງກັບໄປໜ້າ PositionCompany
  //             await Future.delayed(Duration(milliseconds: 200));
  //             // ກັບໄປໜ້າ PositionCompany
  //             if (Navigator.canPop(context)) Navigator.pop(context);
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

    fetchValue();
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
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              color: AppColors.backgroundWhite,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Company name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "${widget.companyName}",
                          style: bodyTextMedium(null, null, FontWeight.bold),
                        ),
                      ),

                      SizedBox(height: 20),

                      //Section BoxDecoration Position / Salary
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundWhite,
                            border: Border.all(color: AppColors.teal),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Position title
                              Text(
                                "${widget.title}",
                                style:
                                    bodyTextMedium(null, null, FontWeight.bold),
                              ),

                              SizedBox(height: 20),

                              //Salary
                              Row(
                                children: [
                                  Text(
                                    "starting_salary".tr,
                                    style: bodyTextMaxNormal(null, null, null),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    widget.isNegotiable
                                        ? "negotiable".tr
                                        : _salary,
                                    style: bodyTextMaxNormal(
                                        widget.isNegotiable
                                            ? null
                                            : "SatoshiBlack",
                                        AppColors.teal,
                                        FontWeight.bold),
                                  ),
                                  SizedBox(width: 5),
                                  if (!widget.isNegotiable)
                                    Text(
                                      "lak".tr,
                                      style:
                                          bodyTextMaxNormal(null, null, null),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // SizedBox(height: 20),

                      // Text("${widget.description}"),

                      //Section BoxDecoration Editor Description
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundWhite,
                        ),
                        // child: HtmlWidget(
                        //   _splitFigureDes,
                        //   onTapUrl: (url) {
                        //     launchInBrowser(Uri.parse(url));
                        //     return true;
                        //   },
                        //   onTapImage: (imageMetadata) {
                        //     // Pick the first source available
                        //     final src = imageMetadata.sources.isNotEmpty
                        //         ? imageMetadata.sources.first.url
                        //         : null;
                        //     if (src != null) {
                        //       // For example, open in browser or show full-screen preview
                        //       launchInBrowser(Uri.parse(src));
                        //     } else {
                        //       print('print: No image URL found.');
                        //     }
                        //   },
                        //   textStyle: bodyTextNormal(null, null, null),
                        // ),

                        child: buildScrollableHtmlWidget(
                          _splitFigureDes,
                          (imageMetadata) {
                            // Pick the first source available
                            final src = imageMetadata.sources.isNotEmpty
                                ? imageMetadata.sources.first.url
                                : null;

                            if (src != null) {
                              print("onTapImage src show dialog: " +
                                  src.toString());

                              // Display dialog image
                              showDialog(
                                  context: context,
                                  builder: (
                                    context,
                                  ) {
                                    return DialogSingleImage(
                                      imagePath: src.toString(),
                                    );
                                  });

                              // For example, open in browser or show full-screen preview
                              // launchInBrowser(Uri.parse(src));
                            } else {
                              print('print: No image URL found.');
                            }
                          },
                        ),
                      ),

                      SizedBox(height: 110)
                    ],
                  ),
                ),
              ),
            ),
            if (eventAvailableProvider.isApplied)
              Positioned(
                // top: 0,
                bottom: 40,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    //
                    //
                    // Button Applied
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Button(
                          buttonColor: _isAppliedEvenJobCompany
                              ? AppColors.dark400
                              : AppColors.teal,
                          text: _isAppliedEvenJobCompany
                              ? "applied".tr
                              : "apply".tr,
                          press: () async {
                            if (!_isAppliedEvenJobCompany) {
                              var result = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return NewVer3CustAlertDialogWarningPictrueBtnConfirmCancel(
                                      statusLogo: widget.logo != "" &&
                                              widget.logo != null
                                          ? ""
                                          : "ImageAsset",
                                      logo: widget.logo != "" &&
                                              widget.logo != null
                                          ? widget.logo
                                          : "no-image-available.png",
                                      title: "apply_job_modal_title".tr,
                                      contentText: "${widget.title}",
                                      textButtonLeft: 'cancel'.tr,
                                      textButtonRight: 'confirm'.tr,
                                    );
                                  });
                              if (result == 'Ok') {
                                setState(() {
                                  _isAppliedEvenJobCompany = true;
                                });
                                // applyByJobId("${widget.id}");
                                applyJobCompanyBySeekerHelper("${widget.id}");
                              }
                            }
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
    );
  }
}
