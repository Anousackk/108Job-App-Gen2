// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field, sized_box_for_whitespace, avoid_print, unused_local_variable, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, unused_element, prefer_is_empty, empty_statements, prefer_typing_uninitialized_variables

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
import 'package:get/get.dart';

class Company extends StatefulWidget {
  const Company({
    Key? key,
    this.companyType,
  }) : super(key: key);
  final companyType;

  @override
  State<Company> createState() => _CompanyState();
}

class _CompanyState extends State<Company> {
  TextEditingController _searchCompanyNameController = TextEditingController();
  ScrollController _scrollController = ScrollController();

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
  bool _isLoadingMoreData = false;
  bool _hasMoreData = true;

  dynamic page = 1;
  dynamic perPage = 10;
  dynamic totals;

  Timer? _timer;

  fetchCompanies(String searchType) async {
    if (!_hasMoreData) {
      _isLoadingMoreData = false;
      return;
    }

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
      "page": page,
      "perPage": perPage,
      "searchType": searchType
    });

    List fetchedCompanies = res['employerList'];
    totals = res['totals'];

    page++;
    _companies.addAll(List<Map<String, dynamic>>.from(fetchedCompanies));
    if (_companies.length >= totals || fetchedCompanies.length < perPage) {
      _hasMoreData = false;
    }
    _isLoadingMoreData = false;
    print("_isLoadingMoreData + ${_isLoadingMoreData}");
    _isLoading = false;

    if (res['employerList'] != null && _statusShowLoading) {
      _statusShowLoading = false;
      Navigator.pop(context);
    }
    // });

    if (mounted) {
      setState(() {});
    }
  }

  fetchCompaniesTypingSearch(String searchType) async {
    setState(() {
      _hasMoreData = true;
      page = 1;
    });
    if (!_hasMoreData) {
      _isLoadingMoreData = false;
      return;
    }

    var res = await postData(getCompaniesSeekerApi, {
      "companyName": _searchCompanyName,
      "industryId": _selectedIndustryListItem,
      "page": page,
      "perPage": perPage,
      "searchType": searchType
    });

    List fetchedCompanies = res['employerList'];
    totals = res['totals'];

    page++;
    _companies.clear();
    _companies.addAll(List<Map<String, dynamic>>.from(fetchedCompanies));
    if (_companies.length >= totals || fetchedCompanies.length < perPage) {
      _hasMoreData = false;
    }
    _isLoadingMoreData = false;

    if (mounted) {
      setState(() {});
    }
  }

  fetchCompanyFeature() async {
    var res = await postData(getCompaniesFeatureApi, {});
    _companiesFeatured = res['employerList'];

    if (mounted) {
      setState(() {});
    }
  }

  pressTapMyJobType(String val) async {
    setState(() {
      _statusShowLoading = true;
      _searchType = val;

      if (_searchType == "AllCompanies") {
      } else if (_searchType == "Hiring") {
      } else if (_searchType == "Following") {
      } else if (_searchType == "SubmittedCV") {}
    });
    _companies.clear();
    page = 1;
    _hasMoreData = true;
    fetchCompanies(val);
  }

  checkTypeMyJobFromHomePage() {
    if (widget.companyType == "Hiring") {
      setState(() {
        _searchType = widget.companyType;

        fetchCompanies(_searchType);
        fetchCompanyFeature();
      });
    }
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

    // await fetchCompanies(_searchType);
    // await fetchCompanyFeature();

    if (message == "Followed") {
      Navigator.pop(context);

      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomAlertDialogSuccessButtonConfirm(
            title: "successful".tr,
            text: "$companyName " + "followed".tr,
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
          return CustomAlertDialogSuccessButtonConfirm(
            title: "successful".tr,
            text: "$companyName " + "unfollowed".tr,
            textButton: "ok".tr,
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
    await fetchCompanyFeature();
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

    if (widget.companyType == "Hiring") {
      checkTypeMyJobFromHomePage();
    } else {
      fetchCompanies("AllCompanies");
      fetchCompanyFeature();
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _isLoadingMoreData = true;
        });
        fetchCompanies(_searchType);
      }
    });

    _searchCompanyNameController.text = _searchCompanyName;
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
            backgroundColor: AppColors.backgroundWhite,
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
                        // Text("${_hasMoreData}"),
                        // Text("${_isLoadingMoreData}"),
                        SizedBox(
                          height: 20,
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
                                  // contenPadding: EdgeInsets.symmetric(
                                  //     vertical: 2.5.w, horizontal: 3.5.w),
                                  contenPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
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
                                    _timer =
                                        Timer(Duration(milliseconds: 500), () {
                                      //
                                      // Perform API call here
                                      print(
                                          'Calling API get Companies after typing search');

                                      fetchCompaniesTypingSearch(_searchType);
                                      // fetchCompanyFeature();
                                    });
                                  },
                                  hintText:
                                      "search".tr + " " + "company name".tr,
                                  inputColor: AppColors.inputWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Expanded(
                          child: CustomScrollView(
                            controller: _scrollController,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            slivers: <Widget>[
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
                              //SliverToBoxAdapter Companies Feature
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
                                              "Sponsored companies",
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
                                                    //
                                                    //
                                                    //Featured card cover
                                                    Container(
                                                      decoration: BoxDecoration(
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
                                                      child: AspectRatio(
                                                        aspectRatio: 5 / 2,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8),
                                                            topRight:
                                                                Radius.circular(
                                                                    8),
                                                          ),
                                                          child:
                                                              i['cardCover'] ==
                                                                      ""
                                                                  ? Center(
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: 30),
                                                                        child:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .image,
                                                                          size:
                                                                              40,
                                                                          color:
                                                                              AppColors.secondary,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Image
                                                                      .network(
                                                                      "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${i['cardCover']}",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      errorBuilder: (context,
                                                                          error,
                                                                          stackTrace) {
                                                                        return Center(
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: 30),
                                                                            child:
                                                                                FaIcon(
                                                                              FontAwesomeIcons.image,
                                                                              size: 40,
                                                                              color: AppColors.secondary,
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
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    //
                                                                    //Industry
                                                                    Text(
                                                                      "${_industry}",
                                                                      style: bodyTextSmall(
                                                                          null),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),

                                                                    //
                                                                    //Address
                                                                    Text(
                                                                      "${_address}",
                                                                      style: bodyTextSmall(
                                                                          null),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
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
                                                                          "${_followerTotals} ",
                                                                          style:
                                                                              bodyTextSmall(null),
                                                                        ),
                                                                        Text(
                                                                          "follower"
                                                                              .tr,
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
                                                                        setState(
                                                                            () {
                                                                          i['follow'] =
                                                                              !i['follow'];
                                                                        });
                                                                        followCompany(
                                                                          i['companyName'],
                                                                          i['_id'],
                                                                        );
                                                                      },
                                                                      child: _isFollow
                                                                          ? Container(
                                                                              padding: EdgeInsets.all(8),
                                                                              decoration: BoxDecoration(
                                                                                color: AppColors.buttonPrimary,
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                // border: Border.all(color: AppColors.borderGreyOpacity),
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
                                                                                    "following".tr,
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
                                                                                    "follow".tr,
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
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //List Tap All Companies, Hiring Now, Following, Applied
                              SliverPersistentHeader(
                                pinned: true,
                                delegate: _SliverAppBarDelegate(
                                  maxHeight: 65,
                                  minHeight: 65,
                                  child: Column(
                                    children: [
                                      Container(
                                        color: AppColors.background,
                                        // height: 30,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        padding: EdgeInsets.only(bottom: 15),

                                        width: double.infinity,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          physics: ClampingScrollPhysics(),
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
                                                    "all company".tr,
                                                    style: bodyTextNormal(
                                                        _searchType ==
                                                                "AllCompanies"
                                                            ? AppColors
                                                                .fontWhite
                                                            : AppColors
                                                                .fontGreyOpacity,
                                                        _searchType ==
                                                                "AllCompanies"
                                                            ? FontWeight.bold
                                                            : null),
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
                                                    "hiring now".tr,
                                                    style: bodyTextNormal(
                                                        _searchType == "Hiring"
                                                            ? AppColors
                                                                .fontWhite
                                                            : AppColors
                                                                .fontGreyOpacity,
                                                        _searchType == "Hiring"
                                                            ? FontWeight.bold
                                                            : null),
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
                                                    "following".tr,
                                                    style: bodyTextNormal(
                                                        _searchType ==
                                                                "Following"
                                                            ? AppColors
                                                                .fontWhite
                                                            : AppColors
                                                                .fontGreyOpacity,
                                                        _searchType ==
                                                                "Following"
                                                            ? FontWeight.bold
                                                            : null),
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
                                                    "applied".tr,
                                                    style: bodyTextNormal(
                                                        _searchType ==
                                                                "SubmittedCV"
                                                            ? AppColors
                                                                .fontWhite
                                                            : AppColors
                                                                .fontGreyOpacity,
                                                        _searchType ==
                                                                "SubmittedCV"
                                                            ? FontWeight.bold
                                                            : null),
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
                              //SliverList of company
                              // _companies.length > 0
                              //     ?
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    if (index == _companies.length) {
                                      return _hasMoreData
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 10),
                                              child: Container(
                                                  // child: Text("Loading"),
                                                  ),
                                            )

                                          // Padding(
                                          //     padding: const EdgeInsets
                                          //         .symmetric(
                                          //         horizontal: 20,
                                          //         vertical: 8),
                                          //     child: ElevatedButton(
                                          //       style: ButtonStyle(
                                          //           backgroundColor:
                                          //               MaterialStatePropertyAll(
                                          //                   AppColors
                                          //                       .lightPrimary)),
                                          //       onPressed: () => {
                                          //         setState(() {
                                          //           _isLoadingMoreData =
                                          //               true;
                                          //         }),
                                          //         fetchCompanies(
                                          //             _searchType),
                                          //       },
                                          //       child: Text(
                                          //         'view more'.tr,
                                          //         style: TextStyle(
                                          //             color: AppColors
                                          //                 .fontPrimary),
                                          //       ),
                                          //     ),
                                          //   )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                  child:
                                                      Text('no have data'.tr)),
                                            );
                                    }

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
                                              // if (value == "Success") {
                                              //   setState(() {
                                              //     _statusShowLoading =
                                              //         true;
                                              //   });
                                              //   onGoBack(value);
                                              // }
                                              if (value[1] != "") {
                                                setState(() {
                                                  dynamic company = _companies
                                                      .firstWhere((e) =>
                                                          e['_id'] == value[1]);

                                                  company['follow'] = value[2];
                                                });
                                              }
                                            });
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
                                                                "${_followerTotals} " +
                                                                    "follower"
                                                                        .tr,
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
                                                    setState(() {
                                                      i['follow'] =
                                                          !i['follow'];
                                                    });
                                                    followCompany(
                                                      i['companyName'],
                                                      i['_id'],
                                                    );
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
                                                            // border: Border.all(
                                                            //   color: AppColors
                                                            //       .borderGreyOpacity,
                                                            // ),
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
                                                              Text(
                                                                  "following"
                                                                      .tr,
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
                                                              Text("follow".tr,
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
                                          height: 15,
                                        ),
                                      ],
                                    );
                                  },
                                  childCount: _companies.length + 1,
                                ),
                              ),
                              // : SliverToBoxAdapter(
                              //     child: Container(
                              //       // color: AppColors.red,
                              //       child: ScreenNoData(
                              //         faIcon: FontAwesomeIcons
                              //             .fileCircleExclamation,
                              //         colorIcon: AppColors.primary,
                              //         text: "no have data".tr,
                              //         colorText: AppColors.primary,
                              //       ),
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        if (_isLoadingMoreData)
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
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
