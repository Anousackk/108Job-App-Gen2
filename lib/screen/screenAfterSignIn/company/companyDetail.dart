// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_declarations, unused_local_variable, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, prefer_final_fields, unused_field, avoid_print, unnecessary_overrides

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:app/functions/colors.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

class CompanyDetail extends StatefulWidget {
  const CompanyDetail({Key? key, this.companyId}) : super(key: key);

  final companyId;

  @override
  State<CompanyDetail> createState() => _CompanyDetailState();
}

class _CompanyDetailState extends State<CompanyDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isPress = false;

  String _memberLevel = "";
  String _logo = "";
  String _companyName = "";
  String _followerTotals = "";
  String _aboutCompany = "";
  String _checkStatusFollow = "";

  List _jobOnlines = [];
  bool _isFollow = false;
  bool _isSubmit = false;
  bool _isLoading = true;

  getDetailCompany(String companyId) async {
    var res = await postData(getCompanyDetailSeekerApi + '${companyId}', {});

    var companyInfo = res['companyInfo'];
    _logo = companyInfo['logo'];
    _companyName = companyInfo['companyName'];
    _followerTotals = companyInfo['followerTotals'].toString();
    _aboutCompany = companyInfo['aboutCompany'];
    _jobOnlines = companyInfo['jobOnlines'];
    _isFollow = companyInfo['follow'];
    _isSubmit = companyInfo['submitted'];

    if (res != null) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
      });
    }

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
            title: "Success",
            text: "$companyName Followed",
            textButton: "OK",
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
            title: "Success",
            text: "$companyName Unfollowed",
            textButton: "OK",
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
            title: "Success",
            text: "$companyName Submitted",
            textButton: "OK",
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
            title: "Warning",
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
            title: "Warning",
            text: "$message",
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

    checkSeekerInfo();
    getDetailCompany(widget.companyId);

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
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
                        flex: 5,
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              alignment: Alignment.topCenter,
                              color: AppColors.background,
                              child: FaIcon(
                                FontAwesomeIcons.solidImage,
                                size: 70,
                                color: AppColors.backgroundGreyOpacity,
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: 20,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(_checkStatusFollow);
                                },
                                child: FaIcon(FontAwesomeIcons.arrowLeft),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 20,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.backgroundWhite,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.grey.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: Offset(0, -3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 70,
                                  ),
                                  Text(
                                    _companyName,
                                    style:
                                        bodyTextMedium(null, FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("${_followerTotals} Follower"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                    child: DefaultTabController(
                                      length: 4,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            child: TabBar(
                                              controller: _tabController,
                                              isScrollable: true,
                                              indicatorPadding: EdgeInsets.zero,
                                              dividerHeight: 0,
                                              labelPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              tabAlignment: TabAlignment.center,
                                              unselectedLabelColor:
                                                  AppColors.black,
                                              indicatorColor: AppColors.white,
                                              tabs: [
                                                Tab(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 12),
                                                    decoration: BoxDecoration(
                                                      color: _tabController
                                                                  .index ==
                                                              0
                                                          ? AppColors
                                                              .lightPrimary
                                                          : AppColors
                                                              .buttonGreyWhite,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: _tabController
                                                                      .index ==
                                                                  0
                                                              ? AppColors
                                                                  .borderPrimary
                                                              : AppColors
                                                                  .buttonGreyWhite),
                                                    ),
                                                    child: Text(
                                                      "About",
                                                      style: bodyTextNormal(
                                                          _tabController
                                                                      .index ==
                                                                  0
                                                              ? AppColors
                                                                  .fontPrimary
                                                              : AppColors
                                                                  .fontDark,
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Tab(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 12),
                                                    decoration: BoxDecoration(
                                                      color: _tabController
                                                                  .index ==
                                                              1
                                                          ? AppColors
                                                              .lightPrimary
                                                          : AppColors
                                                              .buttonGreyWhite,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: _tabController
                                                                      .index ==
                                                                  1
                                                              ? AppColors
                                                                  .borderPrimary
                                                              : AppColors
                                                                  .buttonGreyWhite),
                                                    ),
                                                    child: Text(
                                                      "Opening Jobs",
                                                      style: bodyTextNormal(
                                                          _tabController
                                                                      .index ==
                                                                  1
                                                              ? AppColors
                                                                  .fontPrimary
                                                              : AppColors
                                                                  .fontDark,
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Tab(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 12),
                                                    decoration: BoxDecoration(
                                                      color: _tabController
                                                                  .index ==
                                                              2
                                                          ? AppColors
                                                              .lightPrimary
                                                          : AppColors
                                                              .buttonGreyWhite,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: _tabController
                                                                      .index ==
                                                                  2
                                                              ? AppColors
                                                                  .borderPrimary
                                                              : AppColors
                                                                  .buttonGreyWhite),
                                                    ),
                                                    child: Text(
                                                      "People",
                                                      style: bodyTextNormal(
                                                          _tabController
                                                                      .index ==
                                                                  2
                                                              ? AppColors
                                                                  .fontPrimary
                                                              : AppColors
                                                                  .fontDark,
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Tab(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 12),
                                                    decoration: BoxDecoration(
                                                      color: _tabController
                                                                  .index ==
                                                              3
                                                          ? AppColors
                                                              .lightPrimary
                                                          : AppColors
                                                              .buttonGreyWhite,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: _tabController
                                                                      .index ==
                                                                  3
                                                              ? AppColors
                                                                  .borderPrimary
                                                              : AppColors
                                                                  .buttonGreyWhite),
                                                    ),
                                                    child: Text(
                                                      "Gallery",
                                                      style: bodyTextNormal(
                                                          _tabController
                                                                      .index ==
                                                                  3
                                                              ? AppColors
                                                                  .fontPrimary
                                                              : AppColors
                                                                  .fontDark,
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: TabBarView(
                                              controller: _tabController,
                                              children: [
                                                //
                                                //
                                                //HtmlWidget
                                                SingleChildScrollView(
                                                  physics:
                                                      ClampingScrollPhysics(),
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 20,
                                                        right: 20,
                                                        bottom: 30),
                                                    child: HtmlWidget(
                                                      '$_aboutCompany',
                                                      onTapUrl: (url) {
                                                        launchInBrowser(
                                                            Uri.parse(url));
                                                        return true;
                                                      },
                                                      textStyle: bodyTextNormal(
                                                          null, null),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 20,
                                                        right: 20,
                                                        bottom: 30),
                                                    child: Text("Opening Jobs"),
                                                  ),
                                                ),
                                                Container(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 20,
                                                        right: 20,
                                                        bottom: 30),
                                                    child: Text("People"),
                                                  ),
                                                ),
                                                Container(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 20,
                                                        right: 20,
                                                        bottom: 30),
                                                    child: Text("Gallery"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                    color:
                                                        AppColors.greyOpacity),
                                              ),
                                            ),
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 20,
                                                bottom: 20),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: !_isFollow
                                                      ? ButtonWithIconLeft(
                                                          paddingButton:
                                                              MaterialStateProperty
                                                                  .all<
                                                                      EdgeInsets>(
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        15),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.w),
                                                          colorButton: AppColors
                                                              .buttonBG,
                                                          widgetIcon: FaIcon(
                                                            FontAwesomeIcons
                                                                .heart,
                                                            color: AppColors
                                                                .iconDark,
                                                          ),
                                                          colorText: AppColors
                                                              .fontDark,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          text: "Follow",
                                                          press: () {
                                                            followCompany(
                                                                _companyName,
                                                                widget
                                                                    .companyId);
                                                            setState(() {
                                                              _isFollow =
                                                                  !_isFollow;
                                                            });
                                                          },
                                                        )
                                                      : ButtonWithIconLeft(
                                                          paddingButton:
                                                              MaterialStateProperty
                                                                  .all<
                                                                      EdgeInsets>(
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        15),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.w),
                                                          colorButton: AppColors
                                                              .lightPrimary,
                                                          widgetIcon: FaIcon(
                                                            FontAwesomeIcons
                                                                .solidHeart,
                                                            color: AppColors
                                                                .iconPrimary,
                                                          ),
                                                          colorText: AppColors
                                                              .fontPrimary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          text: "Following",
                                                          press: () {
                                                            followCompany(
                                                                _companyName,
                                                                widget
                                                                    .companyId);
                                                            setState(() {
                                                              _isFollow =
                                                                  !_isFollow;
                                                            });
                                                          },
                                                        ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: !_isSubmit
                                                      ? Button(
                                                          text:
                                                              'Submit general CV',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          press: () {
                                                            submittedCV(
                                                                _companyName,
                                                                widget
                                                                    .companyId);
                                                          },
                                                        )
                                                      : Button(
                                                          text: 'Submitted',
                                                          colorText: AppColors
                                                              .fontDark,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          colorButton: AppColors
                                                              .buttonGreyWhite,
                                                          press: () {
                                                            submittedCV(
                                                                _companyName,
                                                                widget
                                                                    .companyId);
                                                          },
                                                        ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              top: -50,
                              child: Listener(
                                // onPointerUp: (_) => setState(() {
                                //   isPress = false;
                                // }),
                                // onPointerDown: (_) => setState(() {
                                //   isPress = true;
                                // }),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 100),
                                  decoration: BoxDecoration(
                                    color: neumorphismColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: blur,
                                        offset: -distance,
                                        color: AppColors.white,
                                        inset: isPress,
                                      ),
                                      BoxShadow(
                                        blurRadius: blur,
                                        offset: distance,
                                        color: Color(0xFFA7A9AF),
                                        inset: isPress,
                                      )
                                    ],
                                  ),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: _logo == ""
                                            ? Image.asset(
                                                'assets/image/no-image-available.png',
                                                fit: BoxFit.contain,
                                              )
                                            : Image.network(
                                                "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${_logo}",
                                                fit: BoxFit.contain,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'assets/image/no-image-available.png',
                                                    fit: BoxFit.contain,
                                                  ); // Display an error message
                                                },
                                              ),
                                        // ? Container(
                                        //     color:
                                        //         AppColors.backgroundWhite,
                                        //   )
                                        // : Image(
                                        //     image: NetworkImage(
                                        //         "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${_logo}"),
                                        //     fit: BoxFit.contain,
                                        //   ),
                                      ),
                                    ),
                                  ),
                                ),
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
