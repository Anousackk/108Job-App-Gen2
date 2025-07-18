// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, non_constant_identifier_names, unused_field, prefer_final_fields, prefer_const_literals_to_create_immutables, avoid_print

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/formatNumber.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/parser/html_to_delta.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
// import 'package:flutter_quill_extensions/flutter_quill_embeds.dart';
import 'package:get/get.dart';

class DetailPositionComapny extends StatefulWidget {
  const DetailPositionComapny({
    Key? key,
    required this.title,
    required this.salary,
    required this.description,
    required this.id,
    required this.isApplied,
  }) : super(key: key);
  final String id, title, salary, description;
  final bool isApplied;

  @override
  State<DetailPositionComapny> createState() => _DetailPositionComapnyState();
}

class _DetailPositionComapnyState extends State<DetailPositionComapny> {
  QuillController _quillController = QuillController.basic();
  FocusNode editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  String _salary = "";

  fetchValue() async {
    setState(() {
      int IntSalary = int.parse("${widget.salary}");
      _salary = formatNumSalary(IntSalary);

      try {
        final cleanedHtml = widget.description
            .replaceAll(RegExp(r'<figure.*?>'), '')
            .replaceAll('</figure>', '')
            .replaceAll('</p>', '<br>');

        print(cleanedHtml.toString());

        final delta = HtmlToDelta().convert(cleanedHtml);
        _quillController.document = Document.fromDelta(delta);
      } catch (e, stack) {
        print("HTML to Delta conversion error: $e");
        print(stack);
      }
    });
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

              // ຖ້າ success dialog ປີດກ່ອນແລ້ວຈຶ່ງກັບໄປໜ້າ PositionCompany
              await Future.delayed(Duration(milliseconds: 200));

              // ກັບໄປໜ້າ PositionCompany
              if (Navigator.canPop(context)) Navigator.pop(context);
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

              // ຖ້າ success dialog ປີດກ່ອນແລ້ວຈຶ່ງກັບໄປໜ້າ PositionCompany
              await Future.delayed(Duration(milliseconds: 200));

              // ກັບໄປໜ້າ PositionCompany
              if (Navigator.canPop(context)) Navigator.pop(context);
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

    fetchValue();
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
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              color: AppColors.dark100,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      //
                      //
                      //
                      //
                      //
                      //Section BoxDecoration Position / Salary
                      Container(
                        width: double.infinity,
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
                            //Position title
                            Text(
                              "${widget.title}",
                              style:
                                  bodyTextMedium(null, null, FontWeight.bold),
                            ),

                            SizedBox(height: 20),

                            //
                            //
                            //Salary
                            Row(
                              children: [
                                Text(
                                  "ເງິນເດືອນເລີ່ມຕົ້ນ",
                                  style: bodyTextMaxNormal(null, null, null),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  _salary,
                                  style: bodyTextMaxNormal(
                                      "SatoshiBlack", null, FontWeight.bold),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "ກີບ",
                                  style: bodyTextMaxNormal(null, null, null),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      //
                      //
                      //
                      //
                      //
                      //Section BoxDecoration Editor Description
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppColors.backgroundWhite,
                            borderRadius: BorderRadius.circular(10)),
                        child: QuillEditor(
                          focusNode: editorFocusNode,
                          scrollController: _editorScrollController,
                          controller: _quillController,
                          config: QuillEditorConfig(
                            embedBuilders: FlutterQuillEmbeds.editorBuilders(),
                            keyboardAppearance: Brightness.dark,
                            requestKeyboardFocusOnCheckListChanged: false,
                            scrollPhysics: NeverScrollableScrollPhysics(),
                            readOnlyMouseCursor: SystemMouseCursors.text,
                            // maxHeight: 400,
                            // minHeight: 400,
                            placeholder: "",
                            padding: EdgeInsets.all(10),
                          ),
                        ),
                      ),

                      SizedBox(height: 110)
                    ],
                  ),
                ),
              ),
            ),
            if (widget.isApplied == true)
              Positioned(
                // top: 0,
                bottom: 40,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Button(
                          buttonColor: AppColors.teal,
                          text: "ສະໝັກວຽກນີ້",
                          press: () {
                            applyByJobId("${widget.id}");
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
