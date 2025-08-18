// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_typing_uninitialized_variables, unused_field, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unused_local_variable, avoid_print, file_names, use_full_hex_values_for_flutter_colors, deprecated_member_use, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, prefer_is_empty, unused_element

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/myProfile.dart';
import 'package:app/screen/ScreenAfterSignIn/JobSearch/Widget/iconAndText.dart';
import 'package:app/screen/screenAfterSignIn/company/companyDetail.dart';
import 'package:app/src/services/dynamicLinkService.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/vipoPoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class JobSearchDetailRenew extends StatefulWidget {
  const JobSearchDetailRenew({Key? key, this.jobId, this.newJob, this.status})
      : super(key: key);
  static String routeName = '/JobSearchDetailRenew';
  final jobId;
  final newJob;
  final status;

  @override
  State<JobSearchDetailRenew> createState() => _JobSearchDetailState();
}

class _JobSearchDetailState extends State<JobSearchDetailRenew> {
  QuillController _quillController = QuillController.basic();
  FocusNode editorFocusNode = FocusNode();
  HtmlEditorController _htmlEditorController = HtmlEditorController();
  late final WebViewController _webViewController;
  double _webViewHeight = 100;

  List _allOnlineJob = [];
  String _id = "";
  String _companyID = "";
  String _companyName = "";
  String _logo = "";
  String _language = "";
  String _industry = "";
  String _address = "";
  String _title = "";
  String _jobFunction = "";
  String _workLocation = "";
  String _salary = "";
  String _education = "";
  String _experience = "";
  String _description = "";
  String _staffQTY = "";
  String _callBackJobSearchId = "";

  dynamic _openDate;
  dynamic _closeDate;
  dynamic _taskAssign;
  dynamic _isTaskMemberStatus;

  bool _isShowSalary = false;
  bool _isSaved = false;
  bool _isApplied = false;
  bool _isLoading = false;
  bool _isFollow = false;

  int _isClick = 0;

  dynamic _callBackIsSave;
  dynamic _callBackIsNewJob;

  // String _checkNewJobFunctioin = "";
  String _checkStatusCallBack = "";

  fetchJobSearchDetail(dynamic jobId) async {
    var res = await fetchData(getJobSearchDetailSeekerApi + jobId);
    // print("${res}");
    dynamic _jobDetail = res['jobDetail'];

    _id = _jobDetail['jobId'];
    _companyID = _jobDetail['companyID'];
    _companyName = _jobDetail['companyName'];
    _logo = _jobDetail['logo'];
    _industry = _jobDetail['industry'];
    _address = _jobDetail['address'];
    _language = _jobDetail['jobLanguage'];

    _title = _jobDetail['title'];
    _jobFunction = _jobDetail['jobFunction'];
    _salary = _jobDetail['salaryRange'];
    _isShowSalary = _jobDetail['isShowSalary'];
    _workLocation = _jobDetail['workingLocations'];
    _education = _jobDetail['jobEductionLevel'];
    _experience = _jobDetail['jobExperience'];
    _openDate = _jobDetail['openingDate'];
    _closeDate = _jobDetail['closingDate'];
    _staffQTY = _jobDetail['staffQTY'];
    _isClick = int.parse(_jobDetail["isClick"].toString());
    _isFollow = _jobDetail["follow"];
    _isTaskMemberStatus = _jobDetail["taskMemberStatus"] == null
        ? true
        : _jobDetail["taskMemberStatus"];
    _taskAssign = _jobDetail["taskAssign"];

    print("from screen notification status: " + widget.status.toString());
    //
    //
    //ກວດວ່າເປັນວຽກໃໝ່ບໍ່ ມາຈາກໜ້າແຈ້ງເຕືອນວຽກ ຖ້າເປັນແຈ້ງເຕືອນໃໝ່ຈະສົ່ງ status ເປັນ false ກັບຄືນ
    if (widget.status == true) {
      setState(() {
        _callBackJobSearchId = widget.jobId;
        _callBackIsNewJob = false;
      });
    }

    //
    //Open Date
    //pars ISO to Flutter DateTime
    parsDateTime(value: '', currentFormat: '', desiredFormat: '');
    DateTime openDate = parsDateTime(
        value: _openDate,
        currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
        desiredFormat: "yyyy-MM-dd HH:mm:ss");
    //
    //Format to string 13-03-2024
    _openDate = DateFormat('dd/MM/yyyy').format(openDate);

    //
    //Close Date
    //pars ISO to Flutter DateTime
    parsDateTime(value: '', currentFormat: '', desiredFormat: '');
    DateTime closeDate = parsDateTime(
        value: _closeDate,
        currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
        desiredFormat: "yyyy-MM-dd HH:mm:ss");
    //
    //Format to string 13 Feb 2024
    _closeDate = DateFormat("dd/MM/yyyy").format(closeDate);

    _description = _jobDetail['description'];
    _isSaved = _jobDetail['isSaved'];
    _isApplied = _jobDetail['isApplied'];
    _allOnlineJob = res['allOnlineJob'] ?? [];
    _isLoading = false;

    // final cleanedHtml = _description
    //     .toString()
    //     .replaceAll(RegExp(r'<figure.*?>'), '')
    //     .replaceAll('</figure>', '')
    //     .replaceAll('</p>', '<br>');
    // final delta = HtmlToDelta().convert(cleanedHtml);
    // _quillController.document = Document.fromDelta(delta);
    // _quillController.readOnly = true;

    print("from screen jobsearch newJob: " + widget.newJob.toString());

    // _webViewController = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   // ..enableZoom(true)
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onNavigationRequest: (request) {
    //         final uri = Uri.parse(request.url);
    //         //Link http
    //         if (uri.scheme.startsWith('http')) {
    //           launchInBrowser(uri);
    //           return NavigationDecision.prevent;
    //         }
    //         //Email
    //         if (uri.scheme == 'mailto') {
    //           launchUrl(uri);
    //           return NavigationDecision.prevent;
    //         }
    //         //Tel
    //         if (uri.scheme == 'tel') {
    //           launchUrl(uri);
    //           return NavigationDecision.prevent;
    //         }
    //         //SMS
    //         if (uri.scheme == 'sms') {
    //           launchUrl(uri);
    //           return NavigationDecision.prevent;
    //         }

    //         return NavigationDecision.navigate;
    //       },
    //       onPageFinished: (url) async {
    //         final heightStr =
    //             await _webViewController.runJavaScriptReturningResult(
    //                 "document.documentElement.scrollHeight.toString()");
    //         final newHeight =
    //             double.tryParse(heightStr.toString().replaceAll('"', ''));

    //         if (newHeight != null && mounted) {
    //           setState(() => _webViewHeight = newHeight);
    //         }
    //       },
    //     ),
    //   )
    //   ..loadRequest(
    //     Uri.dataFromString(
    //       _wrapHtml(_description),
    //       mimeType: 'text/html',
    //       encoding: Encoding.getByName('utf-8'),
    //     ),
    //   );
    //
    //
    //ກວດວ່າເປັນວຽກໃໝ່ບໍ່ ມາຈາກໜ້າຄົ້ນຫາວຽກ ຖ້າເປັນວຽກໃໝ່ຈະສົ່ງ newJob ເປັນ false ກັບຄືນ
    if (widget.newJob == true) {
      _callBackJobSearchId = widget.jobId;
      _callBackIsNewJob = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  saveAndUnSaveJob() async {
    //
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    var res = await postData(saveJobSeekerApi, {
      "_id": "",
      "JobId": _id,
    });
    print(res);

    if (res['message'] == "Saved" || res['message'] == "Unsaved") {
      Navigator.pop(context);
    }

    if (res['message'] == "Saved") {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            strIcon: "\uf004",
            title: "save job".tr + " " + "successful".tr,
            contentText: "$_title",
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
              setState(() {
                _checkStatusCallBack = "Success";
              });
            },
          );
        },
      );
    } else if (res['message'] == "Unsaved") {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            strIcon: "\uf7a9",
            boxCircleColor: AppColors.warning200,
            iconColor: AppColors.warning600,
            title: "unsave job".tr + " " + "successful".tr,
            contentText: "$_title",
            textButton: "ok".tr,
            buttonColor: AppColors.warning200,
            textButtonColor: AppColors.warning600,
            widgetBottomColor: AppColors.warning200,
            press: () {
              Navigator.pop(context);
              setState(() {
                _checkStatusCallBack = "Success";
              });
            },
          );
        },
      );
    }
  }

  applyJob() async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    var res = await postData(applyJobSeekerApi, {
      "JobId": _id,
      "isCoverLetter": null,
    });
    var message = res['message'];

    print(res);
    if (message == "Applied succeed") {
      Navigator.pop(context);
      setState(() {
        _isApplied = !_isApplied;
      });

      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "apply".tr + " " + "successful".tr,
            contentText: "$_title",
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
              // Navigator.of(context).pop('Success');
              setState(() {
                _checkStatusCallBack = "Success";
              });
            },
          );
        },
      );
    } else {
      Navigator.pop(context);
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "$message",
          );
        },
      );
    }
  }

  followCompany(String companyName, String companyId) async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    var res = await postData(addFollowCompanySeekerApi + '${companyId}', {});
    var message = res['message'];
    print(message);

    if (message == "Followed") {
      Navigator.pop(context);

      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "followed".tr + " " + "successful".tr,
            contentText: "$companyName",
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
            },
          );
        },
      );
    } else if (message == "Unfollow") {
      Navigator.pop(context);

      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "unfollowed".tr + " " + "successful".tr,
            contentText: "$companyName",
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  sharePlusDynamiclink(BuildContext context, String jobSearchId) async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    try {
      final box = context.findRenderObject() as RenderBox?;
      dynamic dynamicLink =
          await DynamicLinkService.createDynamicLink(jobSearchId);

      final resultShare = await Share.share(
        dynamicLink.toString(),
        subject: _companyName.toString(),
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    } catch (e) {
      print("error share plus ${e}");
    } finally {
      Navigator.pop(context);
    }

    // final resultShare = await Share.shareUri(
    //   Uri.parse(dynamicLink.toString()),
    //   sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    // );

    // // Step 1: Download the file
    // final response = await http.get(Uri.parse(
    //     'https://storage.googleapis.com/108-bucket/${_logo}'));
    // final directory = await getApplicationDocumentsDirectory();
    // final file = File('${directory.path}/logo.png');
    // await file.writeAsBytes(response.bodyBytes);

    // // Step 2: Share the file
    // final resultShare = await Share.shareXFiles(
    //   [
    //     XFile(file.path) // Using the local file path
    //   ],
    //   subject: "${_companyName}",
    // );

    // scaffoldMessenger.showSnackBar(getResultSnackBar(resultShare));
    // print("${resultShare}");
  }

  SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Link copied"),
          // if (result.status == ShareResultStatus.success)
          //   Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }

  //
  //api ໃຊ້ກວດ isNew(status of new jobsearch) ຖ້າເປັນຄ່າ true ໃຫ້ເຊັດເປັນ false
  // fetchCheckNewJobSearch(id) async {
  //   var res = await postData("${checkNewJobSearchSeekerApi}/${id}", {});
  //   _checkNewJobFunctioin = res['message'];
  //   print(_checkNewJobFunctioin);
  //   setState(() {});
  // }

  showDialogVipoEvent(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColors.backgroundWhite.withOpacity(0.1),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.only(right: 50),
          child: Container(
            // width: 90.w,
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                )),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/image/Logo108.png', width: 100),
                  SizedBox(width: 15),
                  Text(
                    "ກົດຂ້ອຍ ແລ້ວຮັບໄປເລີຍ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  catchDuckVipoEvent(String valId) async {
    print("catch duck taskAssignId: " + valId);

    //
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    var res = await postData(catchDuckSeekerApi, {"taskId": valId});
    if (res['message'] != "" && res['message'] != null) {
      Navigator.pop(context);
    }

    if (res["message"] == "Catch Duck done.") {
      setState(() {
        _isTaskMemberStatus = !_isTaskMemberStatus;
      });
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogSuccessWithoutBtn(
            title: "successful".tr,
            contentText: "catch_duck_success".tr,
          );
        },
      );
    } else if (res['message'] == "You have already done this task.") {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "catch_duck_already".tr,
          );
        },
      );
    } else if (res['message'] == "Your membership level does not match.") {
      // await showDialog(
      //   context: context,
      //   builder: (context) {
      //     return CustAlertDialogWarningWithoutBtn(
      //       title: "warning".tr,
      //       contentText: "level_does_not_match".tr,
      //     );
      //   },
      // );

      var result = await showDialog(
          context: context,
          builder: (context) {
            return NewVer2CustAlertDialogWarningBtnConfirmCancel(
              title: "warning".tr,
              contentText: "level_does_not_match".tr,
              textButtonLeft: "cancel".tr,
              textButtonRight: 'button_update_profile'.tr,
            );
          });

      if (result == 'Ok') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyProfile(),
          ),
        );
      }
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogWarningWithoutBtn(
            title: "warning".tr,
            contentText: "${res["message"]}",
          );
        },
      );
    }
  }

  //error setState() called after dispose(). it can help!!!
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    print("1" + widget.jobId.toString());

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   showDialogVipoEvent(context);
    // });
    fetchJobSearchDetail(widget.jobId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _wrapHtml(String html) => """
  <html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
      body { background: #fff; color: #000; font-family: NotoSansLaoLoopedRegular, SatoshiRegular; margin: 8px; }
      table { border-collapse: collapse; width: 100%; }
      th, td { border: 1px solid #000; padding: 8px; text-align: left; }
    </style>
  </head>
  <body>$html</body>
  </html>
  """;

  bool _containsComplexTable(String html) {
    final lower = html.toLowerCase();
    return lower.contains('<table') &&
        (lower.contains('colspan') ||
            lower.contains('rowspan') ||
            lower.contains('style=') ||
            lower.length > 1000);
  }

  //HtmlWidget
  Widget _buildScrollableHtmlWidget() {
    print("use HtmlWidget()");
    return Container(
      // color: AppColors.red,
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 3.0,
        panEnabled: true,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: HtmlWidget(
              _description,
              onTapUrl: (url) {
                launchInBrowser(Uri.parse(url));
                return true;
              },
              onTapImage: (imageMetadata) {
                // Pick the first source available
                final src = imageMetadata.sources.isNotEmpty
                    ? imageMetadata.sources.first.url
                    : null;

                if (src != null) {
                  // For example, open in browser or show full-screen preview
                  launchInBrowser(Uri.parse(src));
                } else {
                  print('print: No image URL found.');
                }
              },
              customStylesBuilder: (element) {
                // print(element.localName.toString());
                if (element.localName == 'table') {
                  return {'border': '1px solid #000', 'width': '100%'};
                }
                if (element.localName == 'th' || element.localName == 'td') {
                  return {'border': '1px solid #000', 'padding': '8px'};
                }
                if (element.localName == 'figure') {
                  return {
                    'margin': '0',
                    'padding': '0',
                    'width': '100%',
                    'max-width': '100%',
                    'display': 'block',
                  };
                }
                if (element.localName == 'img') {
                  print("tag image");
                  return {
                    'width': '100%',
                    'max-width': '100%',
                    'height': 'auto',
                    'display': 'block',
                  };
                }
                return null;
              },
              textStyle: bodyTextMaxSmall(null, null, null),
            ),
          ),
        ),
      ),
    );
  }

  //WebView
  Widget _buildScrollableWebView() {
    print("use WebView()");

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: _webViewHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: WebViewWidget(controller: _webViewController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final useWebView = _containsComplexTable(_description);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        body: SafeArea(
          child: _isLoading
              ? Container(
                  color: AppColors.backgroundWhite,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: CustomLoadingLogoCircle(),
                  ),
                )
              : Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: AppColors.backgroundWhite,
                      child: Column(
                        children: [
                          //
                          //
                          //
                          //
                          //
                          //
                          //Appbar custom
                          Container(
                            // color: AppColors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //
                                //
                                //Button back
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop([
                                        _checkStatusCallBack,
                                        _callBackJobSearchId,
                                        _callBackIsSave,
                                        _callBackIsNewJob,
                                      ]);
                                    },
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        "\uf060",
                                        style: fontAwesomeRegular(
                                            null, 20, AppColors.iconDark, null),
                                      ),
                                    ),
                                  ),
                                ),

                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    child: Text(
                                      "${_companyName}",
                                      style: bodyTextMaxNormal(
                                          null, null, FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),

                                //
                                //
                                //Share jobdetail
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      sharePlusDynamiclink(context, _id);
                                    },
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        "\uf064",
                                        style: fontAwesomeSolid(
                                            null, 20, null, null),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          //
                          //
                          //
                          //
                          //
                          //Body content
                          Expanded(
                            flex: 15,
                            child: SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              child: Column(
                                children: [
                                  //
                                  //
                                  //Body header
                                  //Position / Address / Salary / Date / Views
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //
                                        //
                                        //Job Title,
                                        Text(
                                          "${_title}",
                                          style: bodyTextMedium(
                                              null, null, FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),

                                        Text(
                                          "${_address}",
                                          style: bodyTextMaxSmall(
                                              null, null, null),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${_openDate}" +
                                              " - " +
                                              "${_closeDate}",
                                          style: bodyTextMaxSmall(
                                              null, null, null),
                                        )
                                      ],
                                    ),
                                  ),

                                  Divider(color: AppColors.dark200),

                                  //
                                  //
                                  //Body Content
                                  //Job Description
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundWhite,
                                    ),
                                    child: Row(
                                      children: [
                                        //
                                        //
                                        //Description title
                                        Text(
                                          "job description".tr,
                                          style: bodyTextMaxNormal(
                                              null, null, FontWeight.bold),
                                        ),

                                        //Button view description
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //         builder: (_) =>
                                        //             HybridHtmlViewer(
                                        //           htmlContent:
                                        //               "${_description}",
                                        //         ),
                                        //       ),
                                        //     );
                                        //   },
                                        //   child: Container(
                                        //     padding: EdgeInsets.symmetric(
                                        //         horizontal: 20, vertical: 10),
                                        //     decoration: BoxDecoration(
                                        //       color: AppColors.primary,
                                        //       borderRadius:
                                        //           BorderRadius.circular(100),
                                        //     ),
                                        //     child: Text(
                                        //       "view_job_detail".tr,
                                        //       style: bodyTextMaxSmall(
                                        //           null,
                                        //           AppColors.fontWhite,
                                        //           FontWeight.bold),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),

                                  // Container(
                                  //   child: useWebView
                                  //       ? _buildScrollableWebView()
                                  //       : _buildScrollableHtmlWidget(),
                                  // ),
                                  Container(
                                    child: _buildScrollableHtmlWidget(),
                                  ),

                                  SizedBox(height: 20),
                                  Divider(color: AppColors.dark200),

                                  //
                                  //
                                  //Job summery
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Column(
                                      children: [
                                        //
                                        //
                                        //Job summery title
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "ລາຍລະອຽດວຽກໂດຍຫຍໍ້",
                                            style: bodyTextMaxNormal(
                                                null, null, FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(height: 20),

                                        //
                                        //
                                        //Experince
                                        SpaceBetweenTitleAndText(
                                          icon: '\uf64a',
                                          title: "experience".tr,
                                          text: _experience,
                                        ),
                                        SizedBox(height: 15),

                                        // Divider(color: AppColors.dark200),

                                        //
                                        //
                                        //Education
                                        SpaceBetweenTitleAndText(
                                          icon: '\uf19d',
                                          title: "education level".tr,
                                          text: _education,
                                        ),
                                        SizedBox(height: 15),

                                        // Divider(color: AppColors.dark200),

                                        //
                                        //
                                        //Salary
                                        SpaceBetweenTitleAndText(
                                          icon: '\uf0d6',
                                          title: "salary".tr,
                                          text: _salary,
                                        ),
                                        SizedBox(height: 15),

                                        // Divider(color: AppColors.dark200),

                                        //
                                        //
                                        //Language
                                        SpaceBetweenTitleAndText(
                                          icon: '\uf1ab',
                                          title: "preferred language".tr,
                                          text: "${_language}",
                                        ),
                                        SizedBox(height: 15),

                                        // Divider(color: AppColors.dark200),

                                        //
                                        //
                                        //Industry
                                        SpaceBetweenTitleAndText(
                                          icon: '\uf0d6',
                                          title: "industry".tr,
                                          text: _industry,
                                        ),
                                      ],
                                    ),
                                  ),

                                  Divider(color: AppColors.dark200),

                                  //
                                  //
                                  //Section body content
                                  //Box more job
                                  if (_allOnlineJob.length > 0)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: Container(
                                        color: AppColors.backgroundWhite,
                                        child: Column(
                                          children: [
                                            //
                                            //
                                            //title more job
                                            Row(
                                              children: [
                                                Text(
                                                  "more_from_company".tr,
                                                  style: bodyTextMaxNormal(null,
                                                      null, FontWeight.bold),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  "${_allOnlineJob.length}",
                                                  style: bodyTextMaxNormal(
                                                      "SatoshiBlack",
                                                      AppColors.primary,
                                                      FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 20),

                                            //
                                            //
                                            //ListView box more job
                                            SizedBox(
                                              height: 130,
                                              width: double.infinity,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      ClampingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      _allOnlineJob.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    double spacing = 10;
                                                    dynamic i =
                                                        _allOnlineJob[index];

                                                    //
                                                    //Open Date
                                                    //pars ISO to Flutter DateTime
                                                    parsDateTime(
                                                        value: '',
                                                        currentFormat: '',
                                                        desiredFormat: '');
                                                    DateTime
                                                        allOnlineJobOpenDate =
                                                        parsDateTime(
                                                            value: i[
                                                                "openingDate"],
                                                            currentFormat:
                                                                "yyyy-MM-ddTHH:mm:ssZ",
                                                            desiredFormat:
                                                                "yyyy-MM-dd HH:mm:ss");
                                                    //
                                                    //Format to string 13-03-2024
                                                    dynamic
                                                        _allOnlineJobOpenDate =
                                                        DateFormat('dd/MM/yyyy')
                                                            .format(
                                                                allOnlineJobOpenDate);

                                                    //
                                                    //Close Date
                                                    //pars ISO to Flutter DateTime
                                                    parsDateTime(
                                                        value: '',
                                                        currentFormat: '',
                                                        desiredFormat: '');
                                                    DateTime
                                                        allOnlineJobCloseDate =
                                                        parsDateTime(
                                                            value: i[
                                                                "closingDate"],
                                                            currentFormat:
                                                                "yyyy-MM-ddTHH:mm:ssZ",
                                                            desiredFormat:
                                                                "yyyy-MM-dd HH:mm:ss");
                                                    //
                                                    //Format to string 13-03-2024
                                                    dynamic
                                                        _allOnlineJobCloseDate =
                                                        DateFormat('dd/MM/yyyy')
                                                            .format(
                                                                allOnlineJobCloseDate);
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                        left: index == 0
                                                            ? 0
                                                            : spacing,
                                                        right:
                                                            index == 9 ? 0 : 0,
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  JobSearchDetailRenew(
                                                                jobId:
                                                                    i["jobIds"],
                                                                newJob:
                                                                    i["newJob"],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: 75.w,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 15),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .backgroundWhite,
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .borderBG),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              //
                                                              //
                                                              //Title position more job
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      "${i["title"]}",
                                                                      style: bodyTextNormal(
                                                                          null,
                                                                          null,
                                                                          null),
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),

                                                                  //
                                                                  //
                                                                  //Status new job
                                                                  if (i[
                                                                      'newJob'])
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .topCenter,
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              5),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8,
                                                                          vertical:
                                                                              4),
                                                                      // margin: EdgeInsets.only(
                                                                      //     right:
                                                                      //         15),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: AppColors
                                                                            .primary,
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        "job_card_new_job"
                                                                            .tr,
                                                                        style:
                                                                            bodyTextMiniSmall(
                                                                          null,
                                                                          AppColors
                                                                              .fontWhite,
                                                                          null,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),

                                                              Column(
                                                                children: [
                                                                  //
                                                                  //
                                                                  //Working location more job
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        "\uf5a0",
                                                                        style: fontAwesomeLight(
                                                                            null,
                                                                            12,
                                                                            AppColors.iconPrimary,
                                                                            null),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          "${i["workingLocations"]}",
                                                                          style: bodyTextSmall(
                                                                              null,
                                                                              null,
                                                                              null),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  SizedBox(
                                                                      height:
                                                                          5),

                                                                  //
                                                                  //
                                                                  //Start date - end date more job
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        "\uf073",
                                                                        style: fontAwesomeLight(
                                                                            null,
                                                                            12,
                                                                            AppColors.iconPrimary,
                                                                            null),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "${_allOnlineJobOpenDate}" +
                                                                            " - " +
                                                                            "${_allOnlineJobCloseDate} ",
                                                                        style: bodyTextSmall(
                                                                            null,
                                                                            null,
                                                                            null),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),

                                            SizedBox(height: 20),
                                          ],
                                        ),
                                      ),
                                    ),

                                  //
                                  //
                                  //Section body content
                                  //Box company
                                  //Profile Image, Company, Industry, Job Opening
                                  Container(
                                    // margin:
                                    //     EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundWhite,
                                      // borderRadius: BorderRadius.circular(10),
                                      // border:
                                      //     Border.all(color: AppColors.borderBG),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CompanyDetail(
                                                companyId: _companyID,
                                              ),
                                            ),
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          child: Row(
                                            children: [
                                              //
                                              //
                                              //Profile Image
                                              Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      AppColors.backgroundWhite,
                                                  border: Border.all(
                                                      color:
                                                          AppColors.borderBG),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Center(
                                                      child: _logo == "" ||
                                                              _logo.isEmpty
                                                          ? Image.asset(
                                                              'assets/image/no-image-available.png',
                                                              fit: BoxFit
                                                                  .contain,
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
                                                                  'assets/image/no-image-available.png',
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ); // Display an error message
                                                              },
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(width: 10),

                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      //
                                                      //
                                                      //Company Name
                                                      Text(
                                                        "${_companyName}",
                                                        style: bodyTextNormal(
                                                            null, null, null),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),

                                                      //
                                                      //
                                                      //Industry
                                                      Text(
                                                        "${_industry}",
                                                        style: bodyTextSmall(
                                                            null, null, null),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),

                                                      //
                                                      //
                                                      //Address
                                                      Text(
                                                        "${_address}",
                                                        style: bodyTextSmall(
                                                            null, null, null),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),

                                                      //
                                                      //
                                                      //Job Opening
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${_allOnlineJob.length} ",
                                                            style:
                                                                bodyTextSmall(
                                                                    null,
                                                                    null,
                                                                    null),
                                                          ),
                                                          Text(
                                                            "job_opening".tr,
                                                            style:
                                                                bodyTextSmall(
                                                                    null,
                                                                    null,
                                                                    null),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),

                                              //
                                              //
                                              //Icon chevronRight
                                              //Bottom follower / following
                                              // GestureDetector(
                                              //   onTap: () {
                                              //     followCompany(
                                              //       _companyName,
                                              //       _companyID,
                                              //     );
                                              //     setState(() {
                                              //       _isFollow = !_isFollow;
                                              //     });
                                              //   },
                                              //   child: _isFollow
                                              //       ? Container(
                                              //           padding: EdgeInsets.all(8),
                                              //           decoration: BoxDecoration(
                                              //             color:
                                              //                 AppColors.buttonPrimary,
                                              //             borderRadius:
                                              //                 BorderRadius.circular(
                                              //                     8),
                                              //             border: Border.all(
                                              //                 color: AppColors
                                              //                     .borderGreyOpacity),
                                              //           ),
                                              //           child: Row(
                                              //             children: [
                                              //               FaIcon(
                                              //                 FontAwesomeIcons.heart,
                                              //                 size: 13,
                                              //                 color:
                                              //                     AppColors.iconLight,
                                              //               ),
                                              //               SizedBox(
                                              //                 width: 8,
                                              //               ),
                                              //               Text(
                                              //                 "following".tr,
                                              //                 style: bodyTextSmall(null,null,
                                              //                     AppColors
                                              //                         .fontWhite),
                                              //               ),
                                              //             ],
                                              //           ),
                                              //         )
                                              //       : Container(
                                              //           padding: EdgeInsets.all(8),
                                              //           decoration: BoxDecoration(
                                              //             borderRadius:
                                              //                 BorderRadius.circular(
                                              //                     8),
                                              //             border: Border.all(
                                              //               color: AppColors
                                              //                   .borderGreyOpacity,
                                              //             ),
                                              //           ),
                                              //           child: Row(
                                              //             children: [
                                              //               FaIcon(
                                              //                 FontAwesomeIcons.heart,
                                              //                 size: 13,
                                              //               ),
                                              //               SizedBox(
                                              //                 width: 8,
                                              //               ),
                                              //               Text(
                                              //                 "follow".tr,
                                              //                 style:
                                              //                     bodyTextSmall(null,null,null),
                                              //               ),
                                              //             ],
                                              //           ),
                                              //         ),
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ),

                          //
                          //
                          //
                          //
                          //
                          //Button Save job / Apply job
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundWhite,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x000000).withOpacity(0.05),
                                  offset: Offset(0, -6),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                              ],
                              // border: Border(
                              //   top: BorderSide(color: AppColors.borderGreyOpacity),
                              // ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: !_isSaved
                                      ? ButtonWithIconLeft(
                                          paddingButton: WidgetStateProperty
                                              .all<EdgeInsets>(
                                            EdgeInsets.all(10),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          buttonBorderColor:
                                              AppColors.backgroundWhite,
                                          colorButton: AppColors.buttonWhite,
                                          widgetIcon: FaIcon(
                                            FontAwesomeIcons.heart,
                                            color: AppColors.iconDark,
                                            size: IconSize.xsIcon,
                                          ),
                                          colorText: AppColors.fontDark,
                                          text: "save job".tr,
                                          press: () {
                                            setState(() {
                                              _isSaved = !_isSaved;
                                              _callBackJobSearchId = _id;
                                              _callBackIsSave = _isSaved;
                                            });
                                            saveAndUnSaveJob();
                                          },
                                        )
                                      : ButtonWithIconLeft(
                                          paddingButton: WidgetStateProperty
                                              .all<EdgeInsets>(
                                            EdgeInsets.all(10),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          buttonBorderColor:
                                              AppColors.backgroundWhite,
                                          colorButton:
                                              AppColors.backgroundWhite,
                                          widgetIcon: FaIcon(
                                            FontAwesomeIcons.solidHeart,
                                            color: AppColors.iconPrimary,
                                            size: IconSize.xsIcon,
                                          ),
                                          colorText: AppColors.fontPrimary,
                                          text: "saved".tr,
                                          press: () {
                                            saveAndUnSaveJob();
                                            setState(() {
                                              _isSaved = !_isSaved;
                                              _callBackJobSearchId = _id;
                                              _callBackIsSave = _isSaved;
                                            });
                                          },
                                        ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: !_isApplied
                                      ? ButtonWithIconLeft(
                                          paddingButton: WidgetStateProperty
                                              .all<EdgeInsets>(
                                            EdgeInsets.all(10),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          colorButton: AppColors.buttonPrimary,
                                          widgetIcon: FaIcon(
                                            FontAwesomeIcons.paperPlane,
                                            color: AppColors.iconLight,
                                            size: IconSize.xsIcon,
                                          ),
                                          colorText: AppColors.fontWhite,
                                          // fontWeight: FontWeight.bold,
                                          text: "apply".tr,

                                          press: () async {
                                            var result = await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return NewVer3CustAlertDialogWarningPictrueBtnConfirmCancel(
                                                    logo: _logo,
                                                    title:
                                                        "apply_job_modal_title"
                                                            .tr,
                                                    contentText: "${_title}",
                                                    textButtonLeft: 'cancel'.tr,
                                                    textButtonRight:
                                                        'confirm'.tr,
                                                  );
                                                });
                                            if (result == 'Ok') {
                                              print("confirm apply");
                                              applyJob();
                                            }
                                          },
                                        )
                                      : ButtonWithIconLeft(
                                          paddingButton: WidgetStateProperty
                                              .all<EdgeInsets>(
                                            EdgeInsets.all(10),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          buttonBorderColor:
                                              AppColors.borderWaring,
                                          colorButton: AppColors.lightOrange,
                                          widgetIcon: FaIcon(
                                            FontAwesomeIcons.paperPlane,
                                            color: AppColors.iconWarning,
                                          ),
                                          colorText: AppColors.fontWaring,
                                          text: "applied".tr,
                                          press: () {
                                            applyJob();
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //
                    //
                    //widget vipo ກິດຈະກຳກົດເພື່ອຮັບລາງວັນ
                    if (!_isTaskMemberStatus && _taskAssign != null)
                      Positioned(
                        child: WidgetVipoPoint(
                          press: () {
                            catchDuckVipoEvent(_taskAssign["_id"]);
                          },
                        ),
                      )
                  ],
                ),
        ),
      ),
    );
  }
}
