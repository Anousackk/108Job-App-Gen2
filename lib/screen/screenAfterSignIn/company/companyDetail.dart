// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_declarations, unused_local_variable, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, prefer_final_fields, unused_field, avoid_print, unnecessary_overrides, file_names, unused_element

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearchDetail.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/screenNoData.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:app/functions/colors.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class CompanyDetail extends StatefulWidget {
  const CompanyDetail({Key? key, this.companyId}) : super(key: key);

  final companyId;

  @override
  State<CompanyDetail> createState() => _CompanyDetailState();
}

class _CompanyDetailState extends State<CompanyDetail>
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
  String _followerTotals = "";
  String _aboutCompany = "";
  String _address = "";
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
    _address = companyInfo['address'];
    _email = companyInfo['appliedEmails'];
    _phone = companyInfo['phone'];
    _website = companyInfo["website"];
    _facebook = companyInfo["facebook"];
    _youtube = companyInfo['youtube'];
    _tiktok = companyInfo['titok'];
    _linkIn = companyInfo["linkIn"];
    _videoLink = companyInfo["videoLink"];
    _followerTotals = companyInfo['followerTotals'].toString();
    _aboutCompany = companyInfo['aboutCompany'];
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

    _youtubeController = YoutubePlayerController(
      initialVideoId: '${_videoLink}', // Your video ID
      params: YoutubePlayerParams(
        autoPlay: false,
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
        return CustomAlertLoading();
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
          return CustomAlertDialogSuccess(
            title: "successful".tr,
            text: "$companyName " + "followed".tr,
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
          return CustomAlertDialogSuccess(
            title: "successful".tr,
            text: "$companyName " + "unfollowed".tr,
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
    }
  }

  submittedCV(String companyName, String companyId) async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertLoading();
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
          return CustomAlertDialogSuccess(
            title: "successful".tr,
            text: "$companyName " + "submitted cv".tr,
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
          return CustomAlertDialogWarning(
            title: "warning".tr,
            text: "$message",
          );
        },
      );
    } else if (message == "Your member level can not Submit CV" &&
        _memberLevel == "Basic Member") {
      Navigator.pop(context);

      await showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialogWarning(
            title: "warning".tr,
            text: "$message",
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
        return CustomAlertLoading();
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
          return CustomAlertDialogSuccess(
            title: "successful".tr,
            text: "$jobTitle " + "save job".tr + "successful".tr,
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
          return CustomAlertDialogSuccess(
            title: "successful".tr,
            text: "$jobTitle " + "unsave job".tr + "successful".tr,
            textButton: "ok".tr,
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
          backgroundColor: AppColors.background,
        ),
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: AppColors.background,
            child: _isLoading
                ? Center(
                    child: Container(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: AppColors.backgroundWhite,
                          child: CustomScrollView(
                            controller: _scrollController,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            slivers: [
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //Section 1 Company card cover
                              SliverToBoxAdapter(
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
                                    //
                                    //
                                    //Image size 5/2
                                    Container(
                                      width: double.infinity,
                                      // padding: EdgeInsets.only(top: 20),
                                      alignment: Alignment.topCenter,
                                      color: AppColors.background,
                                      child: AspectRatio(
                                        aspectRatio: 5 / 2,
                                        child: ClipRRect(
                                          // borderRadius: BorderRadius.only(
                                          //   topLeft: Radius.circular(8),
                                          //   topRight: Radius.circular(8),
                                          // ),
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
                                                  "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${_cardCover}",
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
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
                                                  color:
                                                      AppColors.backgroundWhite,
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: EdgeInsets.all(8),
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
                                    Positioned(
                                      bottom: -50,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: neumorphismColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColors.borderSecondary),
                                          boxShadow: [],
                                        ),
                                        child: Container(
                                          height: 100,
                                          width: 100,
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
                                                      "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${_logo}",
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
                                    )
                                  ],
                                ),
                              ),

                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //Section 2 Company logo
                              // SliverToBoxAdapter(
                              //   child: SizedBox(
                              //     height: 70,
                              //     child: Stack(
                              //       clipBehavior: Clip.none,
                              //       alignment: Alignment.center,
                              //       children: [
                              //         SizedBox(
                              //           height: double.infinity,
                              //           width: double.infinity,
                              //           child: Container(
                              //             decoration: BoxDecoration(
                              //               color: AppColors.backgroundWhite,
                              //               borderRadius: BorderRadius.only(
                              //                   // topLeft: Radius.circular(25),
                              //                   // topRight: Radius.circular(25),
                              //                   ),
                              //               boxShadow: [
                              //                 BoxShadow(
                              //                   color: AppColors.grey
                              //                       .withOpacity(0.2),
                              //                   spreadRadius: 0,
                              //                   blurRadius: 4,
                              //                   offset: Offset(0, -3),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //         Positioned(
                              //           top: -50,
                              //           child: Listener(
                              //             child: Container(
                              //               decoration: BoxDecoration(
                              //                 color: neumorphismColor,
                              //                 borderRadius:
                              //                     BorderRadius.circular(10),
                              //                 border: Border.all(
                              //                     color: AppColors
                              //                         .borderSecondary),
                              //                 boxShadow: [],
                              //               ),
                              //               child: Container(
                              //                 height: 100,
                              //                 width: 100,
                              //                 child: Padding(
                              //                   padding:
                              //                       const EdgeInsets.all(5),
                              //                   child: ClipRRect(
                              //                     borderRadius:
                              //                         BorderRadius.circular(8),
                              //                     child: _logo == ""
                              //                         ? Image.asset(
                              //                             'assets/image/no-image-available.png',
                              //                             fit: BoxFit.contain,
                              //                           )
                              //                         : Image.network(
                              //                             "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${_logo}",
                              //                             fit: BoxFit.contain,
                              //                             errorBuilder:
                              //                                 (context, error,
                              //                                     stackTrace) {
                              //                               return Image.asset(
                              //                                 'assets/image/no-image-available.png',
                              //                                 fit: BoxFit
                              //                                     .contain,
                              //                               ); // Display an error message
                              //                             },
                              //                           ),
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),

                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //Section 3 Company Logo, Company Name
                              SliverToBoxAdapter(
                                child: Container(
                                  color: AppColors.backgroundWhite,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 60,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(
                                          _companyName,
                                          style: bodyTextMedium(
                                              null, FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          "${_followerTotals} " + "follower".tr)
                                    ],
                                  ),
                                ),
                              ),

                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //Section 4 Tap list horizontal
                              SliverPersistentHeader(
                                pinned: true,
                                delegate: _SliverAppBarDelegate(
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundWhite,
                                      // color: AppColors.red,
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          //
                                          //
                                          //
                                          //
                                          //About Tapxw
                                          GestureDetector(
                                            onTap: () {
                                              pressTapCompanyDetail('about');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 17, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: _typeTapCompanyDetail ==
                                                        "about"
                                                    ? AppColors.lightPrimary
                                                    : AppColors.buttonGreyWhite,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color:
                                                        _typeTapCompanyDetail ==
                                                                "about"
                                                            ? AppColors
                                                                .borderPrimary
                                                            : AppColors
                                                                .buttonGreyWhite),
                                              ),
                                              child: Text(
                                                "about".tr,
                                                style: bodyTextNormal(
                                                    _typeTapCompanyDetail ==
                                                            "about"
                                                        ? AppColors.fontPrimary
                                                        : AppColors.fontDark,
                                                    null),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),

                                          //
                                          //
                                          //
                                          //
                                          //JobOpening Tap
                                          GestureDetector(
                                            onTap: () {
                                              pressTapCompanyDetail(
                                                  'jobOpening');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 17, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: _typeTapCompanyDetail ==
                                                        "jobOpening"
                                                    ? AppColors.lightPrimary
                                                    : AppColors.buttonGreyWhite,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color:
                                                        _typeTapCompanyDetail ==
                                                                "jobOpening"
                                                            ? AppColors
                                                                .borderPrimary
                                                            : AppColors
                                                                .buttonGreyWhite),
                                              ),
                                              child: Text(
                                                "job open".tr,
                                                style: bodyTextNormal(
                                                    _typeTapCompanyDetail ==
                                                            "jobOpening"
                                                        ? AppColors.fontPrimary
                                                        : AppColors.fontDark,
                                                    null),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),

                                          //
                                          //
                                          //
                                          //
                                          //Video Tap
                                          GestureDetector(
                                            onTap: () {
                                              pressTapCompanyDetail('video');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 17, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: _typeTapCompanyDetail ==
                                                        "video"
                                                    ? AppColors.lightPrimary
                                                    : AppColors.buttonGreyWhite,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color:
                                                        _typeTapCompanyDetail ==
                                                                "video"
                                                            ? AppColors
                                                                .borderPrimary
                                                            : AppColors
                                                                .buttonGreyWhite),
                                              ),
                                              child: Text(
                                                "video".tr,
                                                style: bodyTextNormal(
                                                    _typeTapCompanyDetail ==
                                                            "video"
                                                        ? AppColors.fontPrimary
                                                        : AppColors.fontDark,
                                                    null),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),

                                          //
                                          //
                                          //
                                          //
                                          //Photo Gallery Tap
                                          GestureDetector(
                                            onTap: () {
                                              pressTapCompanyDetail('photo');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 17, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: _typeTapCompanyDetail ==
                                                        "photo"
                                                    ? AppColors.lightPrimary
                                                    : AppColors.buttonGreyWhite,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color:
                                                        _typeTapCompanyDetail ==
                                                                "photo"
                                                            ? AppColors
                                                                .borderPrimary
                                                            : AppColors
                                                                .buttonGreyWhite),
                                              ),
                                              child: Text(
                                                "photo gallery".tr,
                                                style: bodyTextNormal(
                                                    _typeTapCompanyDetail ==
                                                            "photo"
                                                        ? AppColors.fontPrimary
                                                        : AppColors.fontDark,
                                                    null),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),

                                          //
                                          //
                                          //
                                          //
                                          //Benitfit Tap
                                          GestureDetector(
                                            onTap: () {
                                              pressTapCompanyDetail('benefit');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 17, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: _typeTapCompanyDetail ==
                                                        "benefit"
                                                    ? AppColors.lightPrimary
                                                    : AppColors.buttonGreyWhite,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color:
                                                        _typeTapCompanyDetail ==
                                                                "benefit"
                                                            ? AppColors
                                                                .borderPrimary
                                                            : AppColors
                                                                .buttonGreyWhite),
                                              ),
                                              child: Text(
                                                "benefit".tr,
                                                style: bodyTextNormal(
                                                    _typeTapCompanyDetail ==
                                                            "benefit"
                                                        ? AppColors.fontPrimary
                                                        : AppColors.fontDark,
                                                    null),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),

                                          //
                                          //
                                          //
                                          //
                                          //Contact Tap
                                          GestureDetector(
                                            onTap: () {
                                              pressTapCompanyDetail('contact');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 17, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: _typeTapCompanyDetail ==
                                                        "contact"
                                                    ? AppColors.lightPrimary
                                                    : AppColors.buttonGreyWhite,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color:
                                                        _typeTapCompanyDetail ==
                                                                "contact"
                                                            ? AppColors
                                                                .borderPrimary
                                                            : AppColors
                                                                .buttonGreyWhite),
                                              ),
                                              child: Text(
                                                "contact".tr,
                                                style: bodyTextNormal(
                                                    _typeTapCompanyDetail ==
                                                            "contact"
                                                        ? AppColors.fontPrimary
                                                        : AppColors.fontDark,
                                                    null),
                                              ),
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
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //Section 4 View Detail On Tap

                              //
                              //
                              //
                              //
                              //About(HtmlWidget)
                              if (_typeTapCompanyDetail == "about")
                                SliverToBoxAdapter(
                                  child: SingleChildScrollView(
                                    physics: ClampingScrollPhysics(),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                      ),
                                      child: HtmlWidget(
                                        '$_aboutCompany',
                                        onTapUrl: (url) {
                                          launchInBrowser(Uri.parse(url));
                                          return true;
                                        },
                                        textStyle: TextStyle(
                                            fontSize: 12,
                                            fontFamily: isLaoText(_aboutCompany)
                                                ? 'NotoSansLaoRegular'
                                                : 'SatoshiMedium'),
                                      ),
                                    ),
                                  ),
                                ),

                              //
                              //
                              //
                              //
                              //
                              //TabBarView Jobs Opening
                              if (_typeTapCompanyDetail == "jobOpening")
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      dynamic i = _jobsOpening[index];
                                      _jobOpeningName = i['title'];
                                      _jobOpeningWorkingLocation =
                                          i['workingLocation'];
                                      _jobOpeningOpeningDate = i['openingDate'];
                                      _jobOpeningClosingDate = i['closingDate'];
                                      _jobOpeningIsSave = i['isSaved'];

                                      //
                                      //Open Date
                                      //pars ISO to Flutter DateTime
                                      parsDateTime(
                                          value: '',
                                          currentFormat: '',
                                          desiredFormat: '');
                                      DateTime openDate = parsDateTime(
                                          value: _jobOpeningOpeningDate,
                                          currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                                          desiredFormat: "yyyy-MM-dd HH:mm:ss");
                                      //
                                      //Format to string 13 Feb 2024
                                      _jobOpeningOpeningDate =
                                          DateFormat('dd MMM yyyy')
                                              .format(openDate);

                                      //
                                      //Close Date
                                      //pars ISO to Flutter DateTime
                                      parsDateTime(
                                          value: '',
                                          currentFormat: '',
                                          desiredFormat: '');
                                      DateTime closeDate = parsDateTime(
                                          value: _jobOpeningClosingDate,
                                          currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                                          desiredFormat: "yyyy-MM-dd HH:mm:ss");
                                      //
                                      //Format to string 13 Feb 2024
                                      _jobOpeningClosingDate =
                                          DateFormat("dd MMM yyyy")
                                              .format(closeDate);
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        JobSearchDetail(
                                                            jobId: i['jobId'],
                                                            newJob:
                                                                i['newJob']),
                                                  ),
                                                ).then((value) {
                                                  if (value[1] != "") {
                                                    setState(() {
                                                      dynamic job = _jobsOpening
                                                          .firstWhere((e) =>
                                                              e['jobId'] ==
                                                              value[1]);

                                                      job["isSaved"] = value[2];
                                                    });
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                  color: AppColors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: AppColors
                                                          .borderSecondary),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 7,
                                                      child: Row(
                                                        children: [
                                                          //
                                                          //
                                                          //Content Company
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    "${_jobOpeningName}",
                                                                    style: bodyTextNormal(
                                                                        null,
                                                                        FontWeight
                                                                            .bold),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    FaIcon(
                                                                      FontAwesomeIcons
                                                                          .locationDot,
                                                                      size: 12,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Flexible(
                                                                      child: Text(
                                                                          "${_jobOpeningWorkingLocation}",
                                                                          style: bodyTextSmall(
                                                                              null),
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    FaIcon(
                                                                      FontAwesomeIcons
                                                                          .calendar,
                                                                      size: 12,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      "${_jobOpeningOpeningDate} - ${_jobOpeningClosingDate}",
                                                                      style: bodyTextSmall(
                                                                          null),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),

                                                    //
                                                    //
                                                    //Button follow / following
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          i['isSaved'] =
                                                              !i['isSaved'];
                                                        });
                                                        saveAndUnSaveJob(
                                                            i['jobId'],
                                                            i['title']);
                                                      },
                                                      child: _jobOpeningIsSave
                                                          ? Container(
                                                              child: Row(
                                                                children: [
                                                                  FaIcon(
                                                                    FontAwesomeIcons
                                                                        .solidHeart,
                                                                    size: 13,
                                                                    color: AppColors
                                                                        .iconPrimary,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    "saved".tr,
                                                                    style: bodyTextSmall(
                                                                        AppColors
                                                                            .fontPrimary),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : Container(
                                                              child: Row(
                                                                children: [
                                                                  FaIcon(
                                                                    FontAwesomeIcons
                                                                        .heart,
                                                                    size: 13,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    "save".tr,
                                                                    style:
                                                                        bodyTextSmall(
                                                                            null),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    childCount: _jobsOpening.length,
                                  ),
                                ),

                              //
                              //
                              //
                              //
                              //
                              //
                              //TabBarView Video
                              if (_typeTapCompanyDetail == "video")
                                SliverToBoxAdapter(
                                  child: SingleChildScrollView(
                                    physics: ClampingScrollPhysics(),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                      ),
                                      child: SingleChildScrollView(
                                        physics: ClampingScrollPhysics(),
                                        child: YoutubePlayerIFrame(
                                          controller: _youtubeController,
                                          aspectRatio: 16 / 9,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              //
                              //
                              //
                              //
                              //
                              //
                              //TabBarView Photo Gallery
                              if (_typeTapCompanyDetail == "photo")
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return Column(
                                        children: [
                                          Container(
                                            color: AppColors.backgroundWhite,
                                            child: Image.network(
                                              "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${_galleryImage[index]}",
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      );
                                    },
                                    childCount: _galleryImage.length,
                                  ),
                                ),

                              //
                              //
                              //
                              //
                              //
                              //
                              //TabBarView Benefits
                              if (_typeTapCompanyDetail == "benefit")
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      dynamic i = _listBenefits[index];
                                      _benefitName = i['details'];
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 3),
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .solidCircleCheck,
                                                      size: 15,
                                                      color:
                                                          AppColors.iconPrimary,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      "${_benefitName}",
                                                      style: bodyTextNormal(
                                                          null, null),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    childCount: _listBenefits.length,
                                  ),
                                ),

                              //
                              //
                              //
                              //
                              //
                              //
                              //TabBarView Contact
                              if (_typeTapCompanyDetail == "contact")
                                SliverToBoxAdapter(
                                  child: SingleChildScrollView(
                                    physics: ClampingScrollPhysics(),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${_companyName}",
                                              style: bodyTextNormal(
                                                  null, FontWeight.bold),
                                            ),
                                            Text(
                                              "${_address}",
                                              style: bodyTextNormal(null, null),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),

                                            //
                                            //
                                            //Email
                                            if (_email != "")
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      child: FaIcon(
                                                        FontAwesomeIcons.at,
                                                        color:
                                                            AppColors.iconDark,
                                                        size: IconSize.xsIcon,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Flexible(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          launchInBrowser(
                                                              Uri.parse(
                                                                  _email));
                                                        },
                                                        child: Text(
                                                          "${_email}",
                                                          style: bodyTextNormal(
                                                              null, null),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),

                                            //
                                            //
                                            //Phone
                                            if (_phone != "")
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      child: FaIcon(
                                                        FontAwesomeIcons.phone,
                                                        color:
                                                            AppColors.iconDark,
                                                        size: IconSize.xsIcon,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Flexible(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          launchPhoneCall(
                                                              _phone);
                                                        },
                                                        child: Text(
                                                          "${_phone}",
                                                          style: bodyTextNormal(
                                                              null, null),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),

                                            //
                                            //
                                            //Website
                                            if (_website != "")
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Container(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .windowMaximize,
                                                          color: AppColors
                                                              .iconDark,
                                                          size: IconSize.xsIcon,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
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
                                                            style:
                                                                bodyTextNormal(
                                                                    null, null),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            //
                                            //
                                            //Facebook
                                            if (_facebook != "")
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      child: FaIcon(
                                                        FontAwesomeIcons
                                                            .facebook,
                                                        color:
                                                            AppColors.iconDark,
                                                        size: IconSize.xsIcon,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
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
                                                              null, null),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),

                                            //
                                            //
                                            //YouTube
                                            if (_youtube != "")
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      child: FaIcon(
                                                        FontAwesomeIcons
                                                            .youtube,
                                                        color:
                                                            AppColors.iconDark,
                                                        size: IconSize.xsIcon,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Flexible(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          launchInBrowser(
                                                              Uri.parse(
                                                                  _youtube));
                                                        },
                                                        child: Text(
                                                          "${_youtube}",
                                                          style: bodyTextNormal(
                                                              null, null),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            //
                                            //
                                            //Tiktok
                                            if (_tiktok != "")
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      child: FaIcon(
                                                        FontAwesomeIcons
                                                            .youtube,
                                                        color:
                                                            AppColors.iconDark,
                                                        size: IconSize.xsIcon,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
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
                                                              null, null),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),

                                            //
                                            //
                                            //LinkIn
                                            if (_linkIn != "")
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      child: FaIcon(
                                                        FontAwesomeIcons
                                                            .linkedinIn,
                                                        color:
                                                            AppColors.iconDark,
                                                        size: IconSize.xsIcon,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Flexible(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          launchInBrowser(
                                                              Uri.parse(
                                                                  _linkIn));
                                                        },
                                                        child: Text(
                                                          "${_linkIn}",
                                                          style: bodyTextNormal(
                                                              null, null),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            SizedBox(
                                              height: 20,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      //
                      //
                      //
                      //
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
                              flex: 1,
                              child: !_isFollow
                                  ? ButtonWithIconLeft(
                                      paddingButton:
                                          WidgetStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(10),
                                      ),
                                      borderRadius: BorderRadius.circular(12.w),
                                      colorButton: AppColors.buttonWhite,
                                      widgetIcon: FaIcon(
                                        FontAwesomeIcons.heart,
                                        color: AppColors.iconDark,
                                        size: IconSize.xsIcon,
                                      ),
                                      colorText: AppColors.fontDark,
                                      // fontWeight:
                                      //     FontWeight.bold,
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
                                  : ButtonWithIconLeft(
                                      paddingButton:
                                          WidgetStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(10),
                                      ),
                                      borderRadius: BorderRadius.circular(12.w),
                                      colorButton: AppColors.buttonWhite,
                                      widgetIcon: FaIcon(
                                        FontAwesomeIcons.solidHeart,
                                        color: AppColors.iconPrimary,
                                        size: IconSize.xsIcon,
                                      ),
                                      colorText: AppColors.fontPrimary,
                                      // fontWeight:
                                      //     FontWeight.bold,
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
                                  ? Button(
                                      paddingButton:
                                          WidgetStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(10),
                                      ),
                                      text: "submit cv".tr,
                                      // fontWeight:
                                      //     FontWeight.bold,
                                      press: () {
                                        submittedCV(
                                            _companyName, widget.companyId);
                                      },
                                    )
                                  : Button(
                                      paddingButton:
                                          WidgetStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(10),
                                      ),
                                      text: "submitted cv".tr,
                                      colorText: AppColors.fontDark,
                                      // fontWeight:
                                      //     FontWeight.bold,
                                      colorButton: AppColors.buttonGreyWhite,
                                      press: () {
                                        submittedCV(
                                            _companyName, widget.companyId);
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
  double get minExtent => minHeight ?? 70;

  @override
  double get maxExtent => maxHeight ?? 70;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
