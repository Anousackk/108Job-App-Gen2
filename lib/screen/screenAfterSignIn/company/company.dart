// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field, sized_box_for_whitespace, avoid_print, unused_local_variable, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, unused_element, prefer_is_empty

import 'dart:async';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/screenAfterSignIn/company/companyDetail.dart';
import 'package:app/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

class Company extends StatefulWidget {
  const Company({
    Key? key,
  }) : super(key: key);

  @override
  State<Company> createState() => _CompanyState();
}

class _CompanyState extends State<Company> {
  TextEditingController _searchCompanyNameController = TextEditingController();

  List _companies = [];
  List _companiesFeatured = [];
  List _selectedIndustryListItem = [];

  String _searchCompanyName = "";
  String _companyName = "";
  String _logo = "";
  String _industry = "";
  String _searchType = "AllCompanies";
  String _address = "";
  String _followerTotals = "";

  bool _isFollow = false;
  bool _statusShowLoading = false;
  bool _isLoading = true;

  Timer? _timer;

  fetchCompanies(String searchType) async {
    if (_statusShowLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomAlertLoading();
        },
      );
    }
    var res = await postData(getCompaniesSeekerApi, {
      "companyName": _searchCompanyName,
      "industryId": _selectedIndustryListItem,
      "page": 1,
      "perPage": 1000,
      "searchType": searchType
    });
    //
    //fetch for companies type featured
    var featured = await postData(getCompaniesSeekerApi, {
      "companyName": _searchCompanyName,
      "industryId": _selectedIndustryListItem,
      "page": 1,
      "perPage": 1000,
      "searchType": "AllCompanies"
    });
    _companies = res['employerList'];
    _companiesFeatured = featured['employerList'];
    _companiesFeatured =
        _companiesFeatured.where((obj) => obj['isFeature'] == true).toList();

    _isLoading = false;

    if (res['employerList'] != null && _statusShowLoading) {
      _statusShowLoading = false;
      Navigator.pop(context);
    }

    if (mounted) {
      setState(() {});
    }
  }

  pressTapMyJobType(String val) async {
    setState(() {
      _searchType = val;

      if (_searchType == "AllCompanies") {
      } else if (_searchType == "Hiring") {
      } else if (_searchType == "Following") {
      } else if (_searchType == "SubmittedCV") {}
    });
    fetchCompanies(val);
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

    fetchCompanies(_searchType);

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
            },
          );
        },
      );
    }
  }

  onGoBack(dynamic value) async {
    print("onGoBack");
    await fetchCompanies(_searchType);
  }

  @override
  void initState() {
    super.initState();

    fetchCompanies("AllCompanies");

    _searchCompanyNameController.text = _searchCompanyName;
  }

  @override
  void dispose() {
    _searchCompanyNameController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScopeNode();
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: GestureDetector(
        onTap: () {
          currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            // setState(() {
            //   _isFocusIconColorTelAndEmail = false;
            // });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: AppColors.white,
          ),
          body: SafeArea(
            child: _isLoading
                ? Container(
                    color: AppColors.background,
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container(
                    color: AppColors.background,
                    // padding: EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),

                        //
                        //
                        //Search and Filter
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              //
                              //
                              //Search keywords
                              Expanded(
                                // flex: 8,
                                child: SimpleTextFieldSingleValidate(
                                  codeController: _searchCompanyNameController,
                                  contenPadding: EdgeInsets.symmetric(
                                      vertical: 2.5.w, horizontal: 3.5.w),
                                  enabledBorder: enableOutlineBorder(
                                    AppColors.borderBG,
                                  ),
                                  changed: (value) {
                                    setState(() {
                                      _searchCompanyName = value;
                                    });

                                    //
                                    //Cancel previous timer if it exists
                                    _timer?.cancel();

                                    //
                                    //Start a new timer
                                    _timer = Timer(Duration(seconds: 1), () {
                                      //
                                      // Perform API call here
                                      print('Calling API Get JobsSearch');
                                      setState(() {
                                        _statusShowLoading = true;
                                      });
                                      fetchCompanies(_searchType);
                                    });
                                  },
                                  hintText: 'Search Company Name',
                                  inputColor: AppColors.inputWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ), //

                        Expanded(
                          child: CustomScrollView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            slivers: <Widget>[
                              //
                              //
                              //SliverToBoxAdapter
                              if (_companiesFeatured.length > 0)
                                SliverToBoxAdapter(
                                  child: Column(
                                    children: [
                                      //
                                      //
                                      // Featured title
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 20),
                                        child: Row(
                                          children: [
                                            Text(
                                              "FEATURED",
                                              style: bodyTextMedium(
                                                  null, FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //
                                      //
                                      //Featured list company card
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        height: 340,
                                        width: double.infinity,
                                        child: ListView.builder(
                                          physics: ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _companiesFeatured.length,
                                          itemBuilder: (context, index) {
                                            dynamic i =
                                                _companiesFeatured[index];
                                            _companyName = i['companyName'];
                                            _industry = i['industry'];
                                            _address = i['address'];
                                            _logo = i['logo'];
                                            _followerTotals =
                                                i['followerTotals'].toString();
                                            _isFollow = i['follow'];

                                            //
                                            //
                                            //Featured card
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CompanyDetail(
                                                      companyId: i['_id'],
                                                    ),
                                                  ),
                                                ).then((value) {
                                                  if (value == "Success") {
                                                    setState(() {
                                                      _statusShowLoading = true;
                                                    });
                                                    onGoBack(value);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                height: 340,
                                                width: 280,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Column(
                                                  children: [
                                                    //
                                                    //
                                                    //Featured cover image
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .greyShimmer,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8),
                                                            topRight:
                                                                Radius.circular(
                                                                    8),
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    //
                                                    //
                                                    //Featured details
                                                    Expanded(
                                                      flex: 4,
                                                      child: Stack(
                                                        clipBehavior: Clip.none,
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .backgroundWhite,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        8),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              // border: Border(
                                                              //   left: BorderSide(
                                                              //       color: AppColors
                                                              //           .borderGreyOpacity),
                                                              //   right: BorderSide(
                                                              //       color: AppColors
                                                              //           .borderGreyOpacity),
                                                              //   bottom: BorderSide(
                                                              //       color: AppColors
                                                              //           .borderGreyOpacity),
                                                              // ),
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 40,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    children: [
                                                                      //
                                                                      //Company Name
                                                                      Text(
                                                                        "${_companyName}",
                                                                        style: bodyTextMaxNormal(
                                                                            null,
                                                                            FontWeight.bold),
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),

                                                                      //
                                                                      //Industry
                                                                      Text(
                                                                        "${_industry}",
                                                                        style: bodyTextSmall(
                                                                            null),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),

                                                                      //
                                                                      //Address
                                                                      Text(
                                                                        "${_address}",
                                                                        style: bodyTextSmall(
                                                                            null),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                                //
                                                                //
                                                                //Bottom follower / following
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    //
                                                                    //Follower
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          "${_followerTotals}",
                                                                          style:
                                                                              bodyTextSmall(null),
                                                                        ),
                                                                        Text(
                                                                          " Followers",
                                                                          style:
                                                                              bodyTextSmall(null),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                    //
                                                                    //Following / Follow
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        followCompany(
                                                                          i['companyName'],
                                                                          i['_id'],
                                                                        );
                                                                        setState(
                                                                            () {
                                                                          _isFollow =
                                                                              !_isFollow;
                                                                        });
                                                                      },
                                                                      child: _isFollow
                                                                          ? Container(
                                                                              padding: EdgeInsets.all(8),
                                                                              decoration: BoxDecoration(
                                                                                color: AppColors.buttonPrimary,
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                border: Border.all(color: AppColors.borderGreyOpacity),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  FaIcon(
                                                                                    FontAwesomeIcons.heart,
                                                                                    size: 13,
                                                                                    color: AppColors.iconLight,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 8,
                                                                                  ),
                                                                                  Text(
                                                                                    "Following",
                                                                                    style: bodyTextSmall(AppColors.fontWhite),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          : Container(
                                                                              padding: EdgeInsets.all(8),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                border: Border.all(
                                                                                  color: AppColors.borderGreyOpacity,
                                                                                ),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  FaIcon(
                                                                                    FontAwesomeIcons.heart,
                                                                                    size: 13,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 8,
                                                                                  ),
                                                                                  Text(
                                                                                    "Follow",
                                                                                    style: bodyTextSmall(null),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),

                                                          //
                                                          //
                                                          //Featured company logo
                                                          Positioned(
                                                            top: -40,
                                                            child: Container(
                                                              height: 90,
                                                              width: 90,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: AppColors
                                                                      .borderSecondary,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: AppColors
                                                                    .backgroundWhite,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  child: _logo ==
                                                                          ""
                                                                      ? Image
                                                                          .asset(
                                                                          'assets/image/no-image-available.png',
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        )
                                                                      : Image
                                                                          .network(
                                                                          "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${_logo}",
                                                                          fit: BoxFit
                                                                              .contain,
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Image.asset(
                                                                              'assets/image/no-image-available.png',
                                                                              fit: BoxFit.contain,
                                                                            ); // Display an error message
                                                                          },
                                                                        ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ),

                              //
                              //
                              //
                              //List Tap All Companies, Hiring Now, Following, Applied
                              SliverPersistentHeader(
                                pinned: true,
                                delegate: _SliverAppBarDelegate(
                                  child: Column(
                                    children: [
                                      Container(
                                        color: AppColors.background,
                                        height: 70,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        width: double.infinity,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  pressTapMyJobType(
                                                      "AllCompanies");
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                                  decoration: BoxDecoration(
                                                    color: _searchType ==
                                                            "AllCompanies"
                                                        ? AppColors
                                                            .buttonPrimary
                                                        : AppColors.buttonGrey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Text(
                                                    "All Companies",
                                                    style: bodyTextNormal(
                                                        _searchType ==
                                                                "AllCompanies"
                                                            ? AppColors
                                                                .fontWhite
                                                            : AppColors
                                                                .fontGreyOpacity,
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  pressTapMyJobType("Hiring");
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                                  decoration: BoxDecoration(
                                                    color: _searchType ==
                                                            "Hiring"
                                                        ? AppColors
                                                            .buttonPrimary
                                                        : AppColors.buttonGrey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Text(
                                                    "Hiring Now",
                                                    style: bodyTextNormal(
                                                        _searchType == "Hiring"
                                                            ? AppColors
                                                                .fontWhite
                                                            : AppColors
                                                                .fontGreyOpacity,
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  pressTapMyJobType(
                                                      "Following");
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                                  decoration: BoxDecoration(
                                                    color: _searchType ==
                                                            "Following"
                                                        ? AppColors
                                                            .buttonPrimary
                                                        : AppColors.buttonGrey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Text(
                                                    "Following",
                                                    style: bodyTextNormal(
                                                        _searchType ==
                                                                "Following"
                                                            ? AppColors
                                                                .fontWhite
                                                            : AppColors
                                                                .fontGreyOpacity,
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  pressTapMyJobType(
                                                      "SubmittedCV");
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                                  decoration: BoxDecoration(
                                                    color: _searchType ==
                                                            "SubmittedCV"
                                                        ? AppColors
                                                            .buttonPrimary
                                                        : AppColors.buttonGrey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Text(
                                                    "Applied",
                                                    style: bodyTextNormal(
                                                        _searchType ==
                                                                "SubmittedCV"
                                                            ? AppColors
                                                                .fontWhite
                                                            : AppColors
                                                                .fontGreyOpacity,
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              //
                              //
                              //List Company of SliverList
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    dynamic i = _companies[index];
                                    _companyName = i['companyName'];
                                    _industry = i['industry'];
                                    _address = i['address'];
                                    _logo = i['logo'];
                                    _followerTotals =
                                        i['followerTotals'].toString();
                                    _isFollow = i['follow'];

                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CompanyDetail(
                                                  companyId: i['_id'],
                                                ),
                                              ),
                                            ).then((value) {
                                              if (value == "Success") {
                                                setState(() {
                                                  _statusShowLoading = true;
                                                });
                                                onGoBack(value);
                                              }
                                            });
                                            ;
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              // border: Border.all(
                                              //     color: AppColors
                                              //         .borderSecondary),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 7,
                                                  child: Row(
                                                    children: [
                                                      //
                                                      //
                                                      //Logo Company
                                                      Container(
                                                        height: 90,
                                                        width: 90,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: AppColors
                                                                .borderSecondary,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: AppColors
                                                              .backgroundWhite,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child: _logo == ""
                                                                ? Image.asset(
                                                                    'assets/image/no-image-available.png',
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  )
                                                                : Image.network(
                                                                    "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${_logo}",
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
                                                      SizedBox(
                                                        width: 15,
                                                      ),

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
                                                                "${_companyName}",
                                                                style: bodyTextNormal(
                                                                    null,
                                                                    FontWeight
                                                                        .bold),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                            Text("${_industry}",
                                                                style:
                                                                    bodyTextSmall(
                                                                        null),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                            Text("${_address}",
                                                                style:
                                                                    bodyTextSmall(
                                                                        null),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                            Text(
                                                                "${_followerTotals} Followers",
                                                                style:
                                                                    bodyTextSmall(
                                                                        null))
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
                                                    followCompany(
                                                      i['companyName'],
                                                      i['_id'],
                                                    );
                                                    setState(() {
                                                      _isFollow = !_isFollow;
                                                    });
                                                  },
                                                  child: _isFollow
                                                      ? Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                            8,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .buttonPrimary,
                                                            border: Border.all(
                                                              color: AppColors
                                                                  .borderGreyOpacity,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .heart,
                                                                size: 13,
                                                                color: AppColors
                                                                    .iconLight,
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text("Following",
                                                                  style: bodyTextSmall(
                                                                      AppColors
                                                                          .fontWhite)),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                            8,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: AppColors
                                                                  .borderSecondary,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
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
                                                              Text("Follow",
                                                                  style:
                                                                      bodyTextSmall(
                                                                          null)),
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
                                        ),
                                      ],
                                    );
                                  },
                                  childCount: _companies.length,
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  height: 30,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
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
