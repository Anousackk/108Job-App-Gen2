// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field, sized_box_for_whitespace, avoid_print, unused_local_variable, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, unused_element, prefer_is_empty, empty_statements, prefer_typing_uninitialized_variables, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings, use_build_context_synchronously, deprecated_member_use

import 'dart:async';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/helpers/companyHelper.dart';
import 'package:app/screen/screenAfterSignIn/company/companyDetail.dart';
import 'package:app/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Company extends StatefulWidget {
  const Company({
    Key? key,
    this.companyType,
    this.hasInternet,
  }) : super(key: key);
  final companyType;
  final hasInternet;

  @override
  State<Company> createState() => _CompanyState();
}

class _CompanyState extends State<Company> with CompanyHelper {
  TextEditingController _searchCompanyNameController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  FocusScopeNode _currentFocus = FocusScopeNode();
  FocusNode focusNode = FocusNode();

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
          return CustomLoadingLogoCircle();
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
    if (_companies.length >= totals || fetchedCompanies.length == 0) {
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
    if (_companies.length >= totals || fetchedCompanies.length == 0) {
      _hasMoreData = false;
    }
    _isLoadingMoreData = false;

    if (mounted) {
      setState(() {});
    }
  }

  // fetchCompanyFeature() async {
  //   var res = await postData(getCompaniesFeatureApi, {});
  //   _companiesFeatured = res['employerList'];

  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  resetAndFetchCompanies() {
    setState(() {
      _hasMoreData = true;
      page = 1;
      _companies.clear();
    });
    fetchCompanies(_searchType);
  }

  pressTapTypeCompany(String val) async {
    setState(() {
      _statusShowLoading = true;
      _searchType = val;

      if (_searchType == "AllCompanies") {
      } else if (_searchType == "Hiring") {
      } else if (_searchType == "Following") {
      } else if (_searchType == "SubmittedCV") {}
    });

    resetAndFetchCompanies();
  }

  checkTypeCompanyFromHomePage() {
    if (widget.companyType == "Hiring") {
      setState(() {
        _searchType = widget.companyType;

        fetchCompanies(_searchType);
        // fetchCompanyFeature();
      });
    }
  }

  Widget _buildFilterOption({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback press,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: press,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.backgroundWhite
                : AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected ? AppColors.primaryCustom : AppColors.borderWhite,
              // width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryCustom
                      : AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected ? AppColors.fontWhite : AppColors.fontDark,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: bodyTextNormal(
                    null,
                    isSelected ? AppColors.primaryCustom : AppColors.fontDark,
                    isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    print("widget hasInternet company: " + "${widget.hasInternet}");

    // if (widget.hasInternet == false) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     showInternetDisconnected(context);
    //   });
    // } else {
    if (widget.companyType == "Hiring") {
      checkTypeCompanyFromHomePage();
    } else {
      fetchCompanies("AllCompanies");
      // fetchCompanyFeature();
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
    // }
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: GestureDetector(
        onTap: () {
          _currentFocus = FocusScope.of(context);
          if (!_currentFocus.hasPrimaryFocus) {
            _currentFocus.unfocus();
          }
        },
        child: Scaffold(
          // appBar: AppBar(
          //   toolbarHeight: 0,
          //   systemOverlayStyle: SystemUiOverlayStyle.dark,
          //   backgroundColor: AppColors.backgroundWhite,
          // ),

          // appBar: AppBarDefault(
          //   backgroundColor: AppColors.backgroundWhite,
          //   textTitle: 'company'.tr,
          //   textColor: AppColors.fontDark,
          //   leadingIcon: Icon(Icons.arrow_back, color: AppColors.fontDark),
          //   leadingPress: () {
          //     Navigator.pop(context);
          //   },
          // ),
          body: SafeArea(
            child: _isLoading
                ? Container(
                    color: AppColors.dark100,
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(child: CustomLoadingLogoCircle()),
                  )
                : Container(
                    color: AppColors.background,
                    // padding: EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),

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
                              //Search company name
                              Expanded(
                                child: SimpleTextFieldSingleValidate(
                                  codeController: _searchCompanyNameController,
                                  focusNode: focusNode,
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

                              SizedBox(width: 10),

                              //
                              //
                              //Filter type company
                              GestureDetector(
                                onTap: () {
                                  focusNode.unfocus();
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundWhite,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Handle bar
                                            // Container(
                                            //   margin: EdgeInsets.only(top: 12),
                                            //   width: 40,
                                            //   height: 4,
                                            //   decoration: BoxDecoration(
                                            //     color: AppColors.borderBG,
                                            //     borderRadius:
                                            //         BorderRadius.circular(2),
                                            //   ),
                                            // ),

                                            // Header
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 20),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryCustom,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "select_type".tr,
                                                    style: bodyTextMedium(
                                                        null,
                                                        AppColors.fontWhite,
                                                        FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Options
                                            Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  // Type AllCompanies
                                                  _buildFilterOption(
                                                    icon:
                                                        Icons.business_outlined,
                                                    title: "all company".tr,
                                                    isSelected: _searchType ==
                                                        "AllCompanies",
                                                    press: () {
                                                      Navigator.pop(context);
                                                      pressTapTypeCompany(
                                                          "AllCompanies");
                                                    },
                                                  ),

                                                  SizedBox(height: 8),

                                                  // Type Hiring
                                                  _buildFilterOption(
                                                    icon: Icons.work_outline,
                                                    title: "hiring now".tr,
                                                    isSelected:
                                                        _searchType == "Hiring",
                                                    press: () {
                                                      Navigator.pop(context);
                                                      pressTapTypeCompany(
                                                          "Hiring");
                                                    },
                                                  ),

                                                  SizedBox(height: 8),

                                                  // Type Following
                                                  _buildFilterOption(
                                                    icon:
                                                        Icons.favorite_outline,
                                                    title: "following".tr,
                                                    isSelected: _searchType ==
                                                        "Following",
                                                    press: () {
                                                      Navigator.pop(context);
                                                      pressTapTypeCompany(
                                                          "Following");
                                                    },
                                                  ),

                                                  SizedBox(height: 8),

                                                  // Type SubmittedCV
                                                  _buildFilterOption(
                                                    icon: Icons.send_outlined,
                                                    title: "applied".tr,
                                                    isSelected: _searchType ==
                                                        "SubmittedCV",
                                                    press: () {
                                                      Navigator.pop(context);
                                                      pressTapTypeCompany(
                                                          "SubmittedCV");
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 45,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundWhite,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: AppColors.borderPrimary,
                                        width: 1),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: FaIcon(
                                      FontAwesomeIcons.barsStaggered,
                                      size: 15,
                                      color: AppColors.iconPrimary,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            physics: ClampingScrollPhysics(),
                            itemCount: _companies.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _companies.length) {
                                return _hasMoreData
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 10),
                                        child: Container(
                                            // child: Text("Loading"),
                                            ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text('no have data'.tr),
                                        ),
                                      );
                              }
                              dynamic i = _companies[index];
                              _companyName = i['companyName'];
                              _industry = i['industry'];
                              _address = i['address'];
                              _logo = i['logo'];
                              _followerTotals = i['followerTotals'].toString();
                              _isFollow = i['follow'];
                              return Column(
                                children: [
                                  //
                                  //
                                  //onTap company box card
                                  GestureDetector(
                                    onTap: () {
                                      focusNode.unfocus();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CompanyDetail(
                                            companyId: i['_id'],
                                          ),
                                        ),
                                      ).then((value) {
                                        print(
                                            "Company Detail Callback: $value");
                                        if (value[1] != "") {
                                          setState(() {
                                            dynamic company =
                                                _companies.firstWhere((e) =>
                                                    e['_id'] == value[1]);
                                            company['follow'] = value[2];
                                          });
                                        }
                                      });
                                    },

                                    //
                                    //
                                    //Company box card
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      height: 350,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          //
                                          //
                                          //Company card cover
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors
                                                  .backgroundGreyOpacity
                                                  .withOpacity(0.3),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                            ),
                                            child: AspectRatio(
                                              aspectRatio: 5 / 2,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8),
                                                ),
                                                child: i['cardCover'] == ""
                                                    ? Center(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 30),
                                                          child: FaIcon(
                                                            FontAwesomeIcons
                                                                .image,
                                                            size: 40,
                                                            color: AppColors
                                                                .secondary,
                                                          ),
                                                        ),
                                                      )
                                                    : Image.network(
                                                        "https://storage.googleapis.com/108-bucket/${i['cardCover']}",
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Center(
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          30),
                                                              child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .image,
                                                                size: 40,
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
                                          //Company details
                                          Expanded(
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .backgroundWhite,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(8),
                                                      bottomRight:
                                                          Radius.circular(8),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 35),

                                                      Expanded(
                                                        child: Container(
                                                          // color: AppColors.red,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              //
                                                              //
                                                              //Company Name
                                                              Text(
                                                                "${_companyName}",
                                                                style: bodyTextMaxNormal(
                                                                    "NotoSansLaoLoopedBold",
                                                                    null,
                                                                    FontWeight
                                                                        .bold),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              SizedBox(
                                                                  height: 5),

                                                              //
                                                              //
                                                              //Industry
                                                              Text(
                                                                  "${_industry}",
                                                                  style:
                                                                      bodyTextSmall(
                                                                          null,
                                                                          null,
                                                                          null),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),

                                                              //
                                                              //
                                                              //Address
                                                              Text(
                                                                  "${_address}",
                                                                  style:
                                                                      bodyTextSmall(
                                                                          null,
                                                                          null,
                                                                          null),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                      // SizedBox(height: 5),
                                                      // Divider(
                                                      //     color: AppColors
                                                      //         .borderBG,
                                                      //     thickness: 1),
                                                      // SizedBox(height: 5),

                                                      //
                                                      //
                                                      //Bottom follower / following
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          // crossAxisAlignment:
                                                          //     CrossAxisAlignment
                                                          //         .end,
                                                          children: [
                                                            //
                                                            //
                                                            //Follower
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "${_followerTotals} ",
                                                                  style: bodyTextSmall(
                                                                      "SatoshiBlack",
                                                                      AppColors
                                                                          .fontPrimary,
                                                                      null),
                                                                ),
                                                                Text(
                                                                  "follower".tr,
                                                                  style:
                                                                      bodyTextSmall(
                                                                          null,
                                                                          null,
                                                                          null),
                                                                ),
                                                              ],
                                                            ),

                                                            //
                                                            //
                                                            //Button following / follow
                                                            Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  focusNode
                                                                      .unfocus();
                                                                  setState(() {
                                                                    i['follow'] =
                                                                        !i['follow'];
                                                                  });
                                                                  followAndUnFollowCompanyHelper(
                                                                      i['_id'],
                                                                      i['companyName']);
                                                                },
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                child: _isFollow
                                                                    ? Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                20,
                                                                            vertical:
                                                                                10),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              AppColors.buttonPrimary,
                                                                          borderRadius:
                                                                              BorderRadius.circular(100),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            FaIcon(
                                                                              FontAwesomeIcons.solidHeart,
                                                                              size: 13,
                                                                              color: AppColors.iconLight,
                                                                            ),
                                                                            SizedBox(width: 8),
                                                                            Text(
                                                                              "following".tr,
                                                                              style: bodyTextSmall(null, AppColors.fontWhite, null),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                20,
                                                                            vertical:
                                                                                10),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(100),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                AppColors.borderDark,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            FaIcon(FontAwesomeIcons.heart,
                                                                                size: 13),
                                                                            SizedBox(width: 8),
                                                                            Text(
                                                                              "follow".tr,
                                                                              style: bodyTextSmall(null, null, null),
                                                                            ),
                                                                          ],
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

                                                //
                                                //
                                                //Company logo
                                                Positioned(
                                                  top: -45,
                                                  child: Container(
                                                    height: 90,
                                                    width: 90,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: AppColors
                                                            .borderSecondary,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: AppColors
                                                          .backgroundWhite,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: _logo == ""
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
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                ],
                              );
                            },
                          ),
                        ),
                        // SizedBox(
                        //   height: 10
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
