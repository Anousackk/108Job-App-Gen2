// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_declarations, unused_local_variable, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, prefer_final_fields, unused_field, avoid_print, unnecessary_overrides, file_names, unused_element, prefer_is_empty, prefer_interpolation_to_compose_strings, use_build_context_synchronously, deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/ScreenAfterSignIn/JobSearch/jobSearchDetail_renew.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:app/functions/colors.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

// _typeTapCompanyDetail == "jobOpening"
class CompanyDetailRenew extends StatefulWidget {
  const CompanyDetailRenew({Key? key, this.companyId, this.typeTapCompany})
      : super(key: key);

  final companyId;
  final typeTapCompany;

  @override
  State<CompanyDetailRenew> createState() => _CompanyDetailRenewState();
}

class _CompanyDetailRenewState extends State<CompanyDetailRenew>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late YoutubePlayerController _youtubeController;
  ScrollController _scrollController = ScrollController();

  List _listJobOnlines = [];
  List _listBenefits = [];
  List _jobsOpening = [];
  List _galleryImage = [];

  String _id = "";
  String _memberLevel = "";
  String _logo = "";
  String _cardCover = "";
  String _companyName = "";
  String _industry = "";
  String _address = "";
  String _followerTotals = "";
  String _aboutCompany = "";
  String _website = "";
  String _facebook = "";
  String _youtube = "";
  String _twitter = "";
  String _tiktok = "";
  String _linkIn = "";
  String _phone = "";
  String _email = "";
  String _videoLink = "";
  String _checkStatusFollow = "";
  String _benefitName = "";
  String _jobOpeningName = "";
  String _jobOpeningWorkingLocation = "";
  String _typeTapCompanyDetail = "about";

  dynamic _jobOpeningOpeningDate;
  dynamic _jobOpeningClosingDate;
  dynamic _map;

  bool _isFollow = false;
  bool _isSubmit = false;
  bool _isLoading = true;
  bool isPress = false;
  bool _jobOpeningIsSave = false;
  bool isLaoText(String text) {
    // Lao Unicode range: 0E80–0EFF
    return text.runes.any((int rune) {
      return (rune >= 0x0E80 && rune <= 0x0EFF);
    });
  }

  String _callBackCompanyId = "";
  dynamic _callBackIsFollow;

  getDetailCompany(String companyId) async {
    var res = await postData(getCompanyDetailSeekerApi + '${companyId}', {});

    var companyInfo = res['companyInfo'];
    _id = companyInfo['_id'];
    _logo = companyInfo['logo'];
    _cardCover = companyInfo['cardCover'];
    _companyName = companyInfo['companyName'];
    _industry = companyInfo["industry"];
    _address = companyInfo['address'];
    _email = companyInfo['appliedEmails'];
    _phone = companyInfo['phone'];
    _website = companyInfo["website"];
    _facebook = companyInfo["facebook"];
    _youtube = companyInfo['youtube'];
    _tiktok = companyInfo['titok'];
    _linkIn = companyInfo["linkIn"];
    _videoLink = companyInfo["videoLink"] ?? "";
    _followerTotals = companyInfo['followerTotals'].toString();
    _aboutCompany = companyInfo['aboutCompany'] ?? "";
    _listJobOnlines = companyInfo['jobOnlines'] ?? [];
    _listBenefits = companyInfo['Benefits'] ?? [];
    _jobsOpening = companyInfo['jobOnlines'] ?? [];
    _galleryImage = companyInfo["Gallerys"] ?? [];
    _isFollow = companyInfo['follow'];
    _isSubmit = companyInfo['submitted'];

    if (res != null) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _youtubeController = YoutubePlayerController.fromVideoId(
      videoId: '${_videoLink}', // Your video ID
      autoPlay: false,
      params: YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  checkSeekerInfo() async {
    var res = await fetchData(informationApiSeeker);
    _memberLevel = res["info"][
        'memberLevel']; //['Basic Member', 'Basic Job Seeker', 'Expert Job Seeker']

    setState(() {});
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

    getDetailCompany(widget.companyId);

    if (message == "Followed") {
      Navigator.pop(context);

      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            strIcon: "\uf004",
            title: "follow".tr + " " + "successful".tr,
            contentText: "$companyName",
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
              setState(() {
                _checkStatusFollow = "Success";
              });
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
            strIcon: "\uf7a9",
            boxCircleColor: AppColors.warning200,
            iconColor: AppColors.warning600,
            title: "unfollow".tr + " " + "successful".tr,
            contentText: "$companyName",
            textButton: "ok".tr,
            buttonColor: AppColors.warning200,
            textButtonColor: AppColors.warning600,
            widgetBottomColor: AppColors.warning200,
            press: () {
              Navigator.pop(context);
              setState(() {
                _checkStatusFollow = "Success";
              });
            },
          );
        },
      );
    }
  }

  submittedCV(String companyName, String companyId) async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    var res = await postData(submitCVSeekerApi + '${companyId}', {});
    var message = res['message'];
    print(message);

    getDetailCompany(widget.companyId);

    if (message == "Submitted successfully") {
      Navigator.pop(context);

      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "submit cv".tr + " " + "successful".tr,
            contentText: "$companyName",
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
            },
          );
        },
      );
    } else if (message == "You had already submitted") {
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
    } else if (message == "Your member level can not Submit CV" &&
        _memberLevel == "Basic Member") {
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

  saveAndUnSaveJob(String jobId, String jobTitle) async {
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
      "JobId": jobId,
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
            contentText: "$jobTitle",
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
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
            contentText: "$jobTitle",
            textButton: "ok".tr,
            buttonColor: AppColors.warning200,
            textButtonColor: AppColors.warning600,
            widgetBottomColor: AppColors.warning200,
            press: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  pressTapCompanyDetail(String type) {
    setState(() {
      _typeTapCompanyDetail = type;
    });
  }

  setTypeTapCompanyDetail() {
    if (widget.typeTapCompany != null) {
      setState(() {
        _typeTapCompanyDetail = widget.typeTapCompany;
      });

      print(_typeTapCompanyDetail.toString());
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

    checkSeekerInfo();
    getDetailCompany(widget.companyId);
    setTypeTapCompanyDetail();

    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final neumorphismColor = AppColors.backgroundWhite;
    Offset distance = isPress ? Offset(7, 7) : Offset(7, 7);
    double blur = isPress ? 5.0 : 10.0;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          // backgroundColor: AppColors.background,
        ),
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: AppColors.backgroundWhite,
            child: _isLoading
                ? Center(
                    child: Container(
                      child: CustomLoadingLogoCircle(),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: AppColors.backgroundWhite,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: ClampingScrollPhysics(),
                            child: Column(
                              children: [
                                //
                                //
                                //
                                //
                                //
                                //Section Company cover image / logo image
                                Container(
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.center,
                                    children: [
                                      //
                                      //Cover imave
                                      //Image size 5/2
                                      Container(
                                        width: double.infinity,
                                        alignment: Alignment.topCenter,
                                        color: AppColors.background,
                                        child: AspectRatio(
                                          aspectRatio: 5 / 2,
                                          child: ClipRRect(
                                            child: _cardCover == ""
                                                ? Center(
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 30),
                                                      child: FaIcon(
                                                        FontAwesomeIcons.image,
                                                        size: 70,
                                                        color:
                                                            AppColors.secondary,
                                                      ),
                                                    ),
                                                  )
                                                : Image.network(
                                                    "https://storage.googleapis.com/108-bucket/${_cardCover}",
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Center(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 30),
                                                          child: FaIcon(
                                                            FontAwesomeIcons
                                                                .image,
                                                            size: 70,
                                                            color: AppColors
                                                                .secondary,
                                                          ),
                                                        ),
                                                      ); // Display an error message
                                                    },
                                                  ),
                                          ),
                                        ),
                                      ),

                                      //
                                      //
                                      //Button back
                                      Positioned(
                                        top: 20,
                                        left: 20,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop([
                                              _checkStatusFollow,
                                              _callBackCompanyId,
                                              _callBackIsFollow
                                            ]);
                                          },
                                          child: _cardCover == ""
                                              ? Text(
                                                  "\uf060",
                                                  style: fontAwesomeRegular(
                                                      null,
                                                      20,
                                                      AppColors.iconDark,
                                                      null),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .backgroundWhite,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    "\uf060",
                                                    style: fontAwesomeRegular(
                                                        null,
                                                        20,
                                                        AppColors.iconDark,
                                                        null),
                                                  ),
                                                ),
                                        ),
                                      ),

                                      //
                                      //
                                      //Company logo image
                                      Positioned(
                                        left: 20,
                                        bottom: -25,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: neumorphismColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color:
                                                    AppColors.borderSecondary),
                                            boxShadow: [],
                                          ),
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: _logo == ""
                                                    ? Image.asset(
                                                        'assets/image/no-image-available.png',
                                                        fit: BoxFit.contain,
                                                      )
                                                    : Image.network(
                                                        "https://storage.googleapis.com/108-bucket/${_logo}",
                                                        fit: BoxFit.contain,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Image.asset(
                                                            'assets/image/no-image-available.png',
                                                            fit: BoxFit.contain,
                                                          ); // Display an error message
                                                        },
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      //
                                      //
                                      //Follower
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: AppColors.backgroundWhite,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            "${_followerTotals} " +
                                                "follower".tr,
                                            style: bodyTextMiniSmall(
                                                null, null, null),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                SizedBox(height: 35),

                                //
                                //
                                //
                                //
                                //
                                //Section  company name, industry, address
                                Container(
                                  color: AppColors.backgroundWhite,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        _companyName,
                                        style: bodyTextNormal(
                                            null, null, FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "${_industry} ".tr,
                                        style: bodyTextSmall(null, null, null),
                                      ),
                                      Text(
                                        "${_address} ".tr,
                                        style: bodyTextSmall(null, null, null),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 10),

                                //
                                //
                                //Section about company
                                if (_aboutCompany != "")
                                  Padding(
                                    padding: EdgeInsetsGeometry.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Container(
                                      color: AppColors.backgroundWhite,
                                      child: Column(
                                        children: [
                                          //
                                          //
                                          //About title
                                          Row(
                                            children: [
                                              Container(
                                                width: 5,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary600,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "about_company".tr,
                                                style: bodyTextMaxNormal(null,
                                                    null, FontWeight.bold),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 20),

                                          //
                                          //
                                          //About(HtmlWidget)
                                          Container(
                                            color: AppColors.backgroundWhite,
                                            child: HtmlWidget(
                                              '$_aboutCompany',
                                              onTapUrl: (url) {
                                                launchInBrowser(Uri.parse(url));
                                                return true;
                                              },
                                              textStyle: bodyTextNormal(
                                                  null, null, null),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                //
                                //
                                //Section Job opening
                                if (_jobsOpening.length > 0)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Container(
                                      color: AppColors.backgroundWhite,
                                      child: Column(
                                        children: [
                                          //
                                          //
                                          //Job opening title
                                          Row(
                                            children: [
                                              Container(
                                                width: 5,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary600,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "job_opening".tr,
                                                style: bodyTextMaxNormal(null,
                                                    null, FontWeight.bold),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "${_jobsOpening.length}",
                                                style: bodyTextMaxNormal(
                                                    "SatoshiBlack",
                                                    AppColors.primary,
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 20),

                                          SizedBox(
                                            height: 120,
                                            width: double.infinity,
                                            //
                                            //
                                            //ListView horizontal box card job opening
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    ClampingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: _jobsOpening.length,
                                                itemBuilder: (context, index) {
                                                  double spacing = 10;
                                                  final jobOpeningIndex =
                                                      _jobsOpening[index];
                                                  _jobOpeningIsSave =
                                                      jobOpeningIndex[
                                                          'isSaved'];

                                                  //
                                                  //Open Date
                                                  //pars ISO to Flutter DateTime
                                                  parsDateTime(
                                                      value: '',
                                                      currentFormat: '',
                                                      desiredFormat: '');
                                                  DateTime jobOpeningOpenDate =
                                                      parsDateTime(
                                                          value: jobOpeningIndex[
                                                              "openingDate"],
                                                          currentFormat:
                                                              "yyyy-MM-ddTHH:mm:ssZ",
                                                          desiredFormat:
                                                              "yyyy-MM-dd HH:mm:ss");
                                                  //
                                                  //Format to string 13-03-2024
                                                  dynamic _jobOpeningOpenDate =
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(
                                                              jobOpeningOpenDate);

                                                  //
                                                  //Close Date
                                                  //pars ISO to Flutter DateTime
                                                  parsDateTime(
                                                      value: '',
                                                      currentFormat: '',
                                                      desiredFormat: '');
                                                  DateTime jobOpeningCloseDate =
                                                      parsDateTime(
                                                          value: jobOpeningIndex[
                                                              "closingDate"],
                                                          currentFormat:
                                                              "yyyy-MM-ddTHH:mm:ssZ",
                                                          desiredFormat:
                                                              "yyyy-MM-dd HH:mm:ss");
                                                  //
                                                  //Format to string 13-03-2024
                                                  dynamic _jobOpeningCloseDate =
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(
                                                              jobOpeningCloseDate);
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                      left: index == 0
                                                          ? 0
                                                          : spacing,
                                                      right: index == 9 ? 0 : 0,
                                                    ),
                                                    child: GestureDetector(
                                                      //
                                                      //
                                                      //onTap box card job opening
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                JobSearchDetailRenew(
                                                              jobId:
                                                                  jobOpeningIndex[
                                                                      "jobId"],
                                                              newJob:
                                                                  jobOpeningIndex[
                                                                      "newJob"],
                                                            ),
                                                          ),
                                                        ).then((value) {
                                                          print(
                                                              value.toString());
                                                          if (value[1] != "") {
                                                            //value[1] = jobsearchId
                                                            //value[2] = isSave
                                                            print(value
                                                                .toString());
                                                            setState(() {
                                                              dynamic job = _jobsOpening
                                                                  .firstWhere((e) =>
                                                                      e['jobId'] ==
                                                                      value[1]);

                                                              job["isSaved"] =
                                                                  value[2];
                                                            });
                                                          }
                                                        });
                                                      },

                                                      //
                                                      //
                                                      //Box card job opening
                                                      child: Container(
                                                        width: 75.w,
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .backgroundWhite,
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .borderBG),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
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
                                                            //Title job opening
                                                            Flexible(
                                                              child: Text(
                                                                  "${jobOpeningIndex["title"]}",
                                                                  style: bodyTextNormal(
                                                                      null,
                                                                      null,
                                                                      FontWeight
                                                                          .bold),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                            ),

                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    // color: AppColors
                                                                    //     .primary,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        //
                                                                        //
                                                                        //Working location job opening
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              "\uf5a0",
                                                                              style: fontAwesomeLight(null, 12, AppColors.iconPrimary, null),
                                                                            ),
                                                                            SizedBox(width: 5),
                                                                            Expanded(
                                                                              child: Text("${jobOpeningIndex["workingLocation"]}", style: bodyTextSmall(null, null, null), overflow: TextOverflow.ellipsis, maxLines: 1),
                                                                            ),
                                                                          ],
                                                                        ),

                                                                        SizedBox(
                                                                            height:
                                                                                5),

                                                                        //
                                                                        //
                                                                        //Start date - end date job opening
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              "\uf073",
                                                                              style: fontAwesomeLight(null, 12, AppColors.iconPrimary, null),
                                                                            ),
                                                                            SizedBox(width: 5),
                                                                            Text(
                                                                              "${_jobOpeningOpenDate}" + " - " + "${_jobOpeningCloseDate} ",
                                                                              style: bodyTextSmall(null, null, null),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),

                                                                SizedBox(
                                                                    width: 10),

                                                                //
                                                                //
                                                                //Button follow / following
                                                                Container(
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        jobOpeningIndex['isSaved'] =
                                                                            !jobOpeningIndex['isSaved'];
                                                                      });
                                                                      saveAndUnSaveJob(
                                                                          jobOpeningIndex[
                                                                              'jobId'],
                                                                          jobOpeningIndex[
                                                                              'title']);
                                                                    },
                                                                    child: _jobOpeningIsSave
                                                                        ? Container(
                                                                            padding:
                                                                                EdgeInsets.only(top: 15, left: 15),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                FaIcon(
                                                                                  FontAwesomeIcons.solidHeart,
                                                                                  size: 13,
                                                                                  color: AppColors.iconPrimary,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                Text(
                                                                                  "saved".tr,
                                                                                  style: bodyTextSmall(
                                                                                    null,
                                                                                    AppColors.fontPrimary,
                                                                                    null,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        : Container(
                                                                            padding:
                                                                                EdgeInsets.only(top: 15, left: 15),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                FaIcon(
                                                                                  FontAwesomeIcons.heart,
                                                                                  size: 13,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                Text(
                                                                                  "save".tr,
                                                                                  style: bodyTextSmall(null, null, null),
                                                                                ),
                                                                              ],
                                                                            ),
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
                                          ),

                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ),

                                //
                                //
                                //Section benefits
                                if (_listBenefits.length > 0)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Container(
                                      color: AppColors.backgroundWhite,
                                      child: Column(
                                        children: [
                                          //
                                          //
                                          //Benefits title
                                          Row(
                                            children: [
                                              Container(
                                                width: 5,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary600,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "benefit".tr,
                                                style: bodyTextMaxNormal(null,
                                                    null, FontWeight.bold),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 20),

                                          //
                                          //
                                          //ListView benefits
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: _listBenefits.length,
                                            itemBuilder: (context, index) {
                                              final benefitIndex =
                                                  _listBenefits[index];
                                              _benefitName =
                                                  benefitIndex['details'];

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("-"),

                                                    SizedBox(width: 10),

                                                    //
                                                    //
                                                    //Benefits text
                                                    Flexible(
                                                      child: Text(
                                                        "${_benefitName}",
                                                        style: bodyTextNormal(
                                                            null, null, null),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                //
                                //
                                //Section video link
                                if (_videoLink != "")
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Container(
                                      color: AppColors.backgroundWhite,
                                      child: Column(
                                        children: [
                                          //
                                          //
                                          //Video link title
                                          Row(
                                            children: [
                                              Container(
                                                width: 5,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary600,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "video".tr,
                                                style: bodyTextMaxNormal(null,
                                                    null, FontWeight.bold),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 20),

                                          //
                                          //
                                          //Youtube player
                                          YoutubePlayer(
                                            controller: _youtubeController,
                                            aspectRatio: 16 / 9,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                //
                                //
                                //Section gallery image
                                if (_galleryImage.length > 0)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Container(
                                      color: AppColors.backgroundWhite,
                                      child: Column(
                                        children: [
                                          //
                                          //
                                          //Photo gallery title
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 5,
                                                    height: 16,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.primary600,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    "photo_gallery".tr,
                                                    style: bodyTextMaxNormal(
                                                        null,
                                                        null,
                                                        FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              GestureDetector(
                                                //
                                                //
                                                //onTap see more gallery image display Dialog
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (
                                                        context,
                                                      ) {
                                                        return DialogListGalleryImage(
                                                            galleryImage:
                                                                _galleryImage);
                                                      });
                                                },
                                                child: Text(
                                                  "see_more".tr,
                                                  style: bodyTextNormal(
                                                      null, null, null),
                                                ),
                                              )
                                            ],
                                          ),

                                          SizedBox(height: 20),

                                          SizedBox(
                                            height: 300,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    ClampingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: _galleryImage.length,
                                                itemBuilder: (context,
                                                    galleryImageIndex) {
                                                  double spacing = 10;
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                      left:
                                                          galleryImageIndex == 0
                                                              ? 0
                                                              : spacing,
                                                      right:
                                                          galleryImageIndex == 9
                                                              ? 0
                                                              : 0,
                                                    ),
                                                    child: Container(
                                                      color: AppColors
                                                          .backgroundWhite,
                                                      child: Image.network(
                                                        "https://storage.googleapis.com/108-bucket/${_galleryImage[galleryImageIndex]}",
                                                        fit: BoxFit.contain,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Image.asset(
                                                            'assets/image/no-image-available.png',
                                                            fit: BoxFit.contain,
                                                          ); // Display an error message
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                if (_website != "" &&
                                    _facebook != "" &&
                                    _tiktok != "")
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Container(
                                      color: AppColors.backgroundWhite,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //
                                          //
                                          //Contact title
                                          Row(
                                            children: [
                                              Container(
                                                width: 5,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary600,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "contact".tr,
                                                style: bodyTextMaxNormal(null,
                                                    null, FontWeight.bold),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 20),

                                          //
                                          //
                                          //Website
                                          if (_website != "")
                                            Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Website: ",
                                                      style: bodyTextMinNormal(
                                                          null,
                                                          null,
                                                          FontWeight.bold),
                                                    ),
                                                    Flexible(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          launchInBrowser(
                                                              Uri.parse(
                                                                  _website));
                                                        },
                                                        child: Text(
                                                          "${_website}",
                                                          style: bodyTextNormal(
                                                              null, null, null),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                              ],
                                            ),

                                          //
                                          //
                                          //Facebook
                                          if (_facebook != "")
                                            Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Facebook: ",
                                                      style: bodyTextMinNormal(
                                                          null,
                                                          null,
                                                          FontWeight.bold),
                                                    ),
                                                    Flexible(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          launchInBrowser(
                                                              Uri.parse(
                                                                  _facebook));
                                                        },
                                                        child: Text(
                                                          "${_facebook}",
                                                          style: bodyTextNormal(
                                                              null, null, null),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                              ],
                                            ),

                                          //
                                          //
                                          //Tiktok
                                          if (_tiktok != "")
                                            Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Youtube: ",
                                                      style: bodyTextMinNormal(
                                                          null,
                                                          null,
                                                          FontWeight.bold),
                                                    ),
                                                    Flexible(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          launchInBrowser(
                                                              Uri.parse(
                                                                  _tiktok));
                                                        },
                                                        child: Text(
                                                          "${_tiktok}",
                                                          style: bodyTextNormal(
                                                              null, null, null),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),

                      //
                      //
                      //Button follow and submit cv
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundWhite,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.dark.withOpacity(0.05),
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
                              flex: 1,
                              child: !_isFollow
                                  ?
                                  //
                                  //
                                  //Button follow company
                                  ButtonWithIconLeft(
                                      paddingButton:
                                          WidgetStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(10),
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                      colorButton: AppColors.buttonWhite,
                                      widgetIcon: FaIcon(
                                        FontAwesomeIcons.heart,
                                        color: AppColors.iconDark,
                                        size: IconSize.xsIcon,
                                      ),
                                      colorText: AppColors.fontDark,
                                      text: "follow".tr,
                                      press: () {
                                        followCompany(
                                            _companyName, widget.companyId);
                                        setState(() {
                                          _isFollow = !_isFollow;
                                          _callBackCompanyId = _id;
                                          _callBackIsFollow = _isFollow;
                                        });
                                      },
                                    )
                                  :

                                  //
                                  //
                                  //Button following company
                                  ButtonWithIconLeft(
                                      paddingButton:
                                          WidgetStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(10),
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                      colorButton: AppColors.buttonWhite,
                                      widgetIcon: FaIcon(
                                        FontAwesomeIcons.solidHeart,
                                        color: AppColors.iconPrimary,
                                        size: IconSize.xsIcon,
                                      ),
                                      colorText: AppColors.fontPrimary,
                                      text: "following".tr,
                                      press: () {
                                        followCompany(
                                            _companyName, widget.companyId);
                                        setState(() {
                                          _isFollow = !_isFollow;
                                          _callBackCompanyId = _id;
                                          _callBackIsFollow = _isFollow;
                                        });
                                      },
                                    ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: !_isSubmit
                                  ?
                                  //
                                  //
                                  //Button submit cv
                                  Button(
                                      paddingButton:
                                          WidgetStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(10),
                                      ),
                                      text: "submit cv".tr,
                                      // press: () async {
                                      //   var result = await showDialog(
                                      //       context: context,
                                      //       builder: (context) {
                                      //         return AlertDialogBtnConfirmCancelBetween(
                                      //           title: "submit cv".tr,
                                      //           contentText: "${_companyName}" +
                                      //               "\n" +
                                      //               "are_you_sure_sent_cv".tr,
                                      //           textLeft: 'cancel'.tr,
                                      //           textRight: 'confirm'.tr,
                                      //           colorTextRight:
                                      //               AppColors.fontPrimary,
                                      //           borderColorButtonRight:
                                      //               AppColors.borderPrimary,
                                      //         );
                                      //       });
                                      //   if (result == 'Ok') {
                                      //     print("confirm submit cv");
                                      //     submittedCV(
                                      //       _companyName,
                                      //       widget.companyId,
                                      //     );
                                      //   }
                                      // },

                                      press: () async {
                                        var result = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return NewVer4CustAlertDialogWarning3TxtBtnConfirmCancel(
                                                boxCircleColor:
                                                    AppColors.primary200,
                                                iconColor: AppColors.primary600,
                                                title: "submit cv".tr,
                                                smallText:
                                                    "express_interest_explain"
                                                        .tr,
                                                contentText: "${_companyName}",
                                                textButtonLeft: 'cancel'.tr,
                                                textButtonRight: 'confirm'.tr,
                                                buttonRightColor:
                                                    AppColors.primary600,
                                                widgetBottomColor:
                                                    AppColors.primary200,
                                              );
                                            });
                                        if (result == 'Ok') {
                                          print("confirm submit cv");
                                          submittedCV(
                                            _companyName,
                                            widget.companyId,
                                          );
                                        }
                                      },
                                    )
                                  :

                                  //
                                  //
                                  //Button submitted cv
                                  Button(
                                      paddingButton:
                                          WidgetStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(10),
                                      ),
                                      text: "submitted cv".tr,
                                      buttonColor: AppColors.buttonGreyWhite,
                                      textColor: AppColors.fontDark,
                                      press: () {
                                        submittedCV(
                                          _companyName,
                                          widget.companyId,
                                        );
                                      },
                                    ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class DialogListGalleryImage extends StatelessWidget {
  const DialogListGalleryImage({
    Key? key,
    required List galleryImage,
  })  : _galleryImage = galleryImage,
        super(key: key);

  final List _galleryImage;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "\uf060",
                  style: fontAwesomeRegular(null, 20, AppColors.iconDark, null),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _galleryImage.length,
              itemBuilder: (context, i) {
                double spacing = 10;
                return Padding(
                  padding: EdgeInsets.only(
                    top: i == 0 ? 0 : spacing,
                    bottom: i == 9 ? 0 : 0,
                  ),
                  child: InteractiveViewer(
                    child: Image.network(
                      "https://storage.googleapis.com/108-bucket/${_galleryImage[i]}",
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                            'assets/image/no-image-available.png');
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    this.minHeight,
    this.maxHeight,
    required this.child,
  });

  final double? minHeight;
  final double? maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight ?? 62;

  @override
  double get maxExtent => maxHeight ?? 62;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
    // return true;
  }
}
