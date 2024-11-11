//
//Profile Setting
// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_final_fields, unused_field, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, sized_box_for_whitespace, await_only_futures, unused_local_variable, unnecessary_cast, avoid_print, prefer_is_empty, file_names

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/listMultiSelectedAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({
    Key? key,
    this.isSearchable,
  }) : super(key: key);
  final isSearchable;

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  List _listCompanies = [];
  List _listSeekerSearchableCompanies = [];

  String _logo = "";

  bool _isSearchable = false;
  bool _isLoading = true;
  bool _statusShowLoading = false;

  //
  //Selected list item(ສະເພາະເຂົ້າ Database)
  List _selectedCompaniesListItem = [];

  //
  //value display(ສະເພາະສະແດງ)
  List _companiesName = [];

  pressSearchable() async {
    setState(() {
      _isSearchable = !_isSearchable;
    });

    var res = await postData(searchableProfileSettingSeeker,
        {"isSearchable": _isSearchable as bool});

    // print("${res}");
  }

  fetchCompanies() async {
    var res = await postData(
        getCompaniesProfileSetting, {"page": 1, "perPage": 1000, "search": ""});
    _listCompanies = res['companyInfo'];

    _isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  fetchSeekerSearchableCompanies() async {
    var res = await fetchData(getSeekerSearchableCompaniesProfileSetting);

    if (res['mapper'] != null) {
      _listSeekerSearchableCompanies = res['mapper']['empId'];
      _selectedCompaniesListItem =
          _listSeekerSearchableCompanies.map((i) => i['_id']).toList();
    } else {
      _listSeekerSearchableCompanies = [];
    }

    // print(_listSeekerSearchableCompanies);
    // print(_selectedCompaniesListItem);

    if (mounted) {
      setState(() {});
    }
  }

  hideCompany() async {
    //
    //ສະແດງ AlertDialog Loading
    if (_statusShowLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustAlertLoading();
        },
      );
    }

    var res = await postData(hideCompanyProfileSetting, {
      "empId": _selectedCompaniesListItem,
    });

    // print("${res}");

    if (res != null && _statusShowLoading) {
      _statusShowLoading = false;
      Navigator.pop(context);
      fetchSeekerSearchableCompanies();
    }

    if (mounted) {
      setState(() {});
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
    _isSearchable = widget.isSearchable;
    fetchCompanies();
    fetchSeekerSearchableCompanies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBarDefault(
          textTitle: "profile setting".tr,
          // fontWeight: FontWeight.bold,
          leadingIcon: Icon(Icons.arrow_back),
          leadingPress: () {
            Navigator.of(context).pop();
          },
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
                  height: double.infinity,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),

                        //
                        //
                        //BoxDecoration DottedBorder Profile Status
                        // BoxDecDottedBorderProfileDetail(
                        //   boxDecColor: AppColors.lightPrimary,
                        //   title: "Profile Status",
                        //   titleFontWeight: FontWeight.bold,
                        //   text:
                        //       "Get your profile approved or complete: Attached CV, Personal Information and Work Preferences to set the profile status",
                        //   buttonWidth: 140,
                        //   buttonIcon: FontAwesomeIcons.pen,
                        //   buttonText: "Update Profile",
                        //   pressButton: () {},
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        //
                        //
                        //BoxDecoration DottedBorder Profile Search
                        // BoxDecDottedBorderProfileDetail(
                        //   boxDecColor: AppColors.lightPrimary,
                        //   title: "Profile Search",
                        //   titleFontWeight: FontWeight.bold,
                        //   text:
                        //       "To enable Searchable Profile, level up your profile to Newbie level",
                        //   buttonIcon: FontAwesomeIcons.pen,
                        //   buttonWidth: 140,
                        //   buttonText: "Update Profile",
                        //   pressButton: () {},
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // BoxDecProfileSettingHaveValue(
                        //   boxDecColor: AppColors.lightPrimary,
                        //   title: "Profile Status",
                        //   titleFontWeight: FontWeight.bold,
                        //   text:
                        //       "Get your profile approved or complete: Attached CV, Personal Information and Work Preferences to set the profile status.",
                        //   actionOnOffIcon: FaIcon(
                        //     FontAwesomeIcons.eye,
                        //     color: AppColors.iconLight,
                        //     size: 20,
                        //   ),
                        //   actionOnOffText: "ON",
                        //   pressActionOnOff: () {},
                        // ),

                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.lightPrimary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "profile status".tr,
                                  style: bodyTextNormal(
                                    null,
                                    AppColors.fontPrimary,
                                    FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "how to set profile status".tr,
                                  style: bodyTextSmall(
                                      null, AppColors.fontGreyOpacity, null),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.inputWhite,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "searchable profile".tr,
                                        style: bodyTextNormal(
                                            null, null, FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          pressSearchable();
                                        },
                                        child: _isSearchable
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 18,
                                                    vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: FaIcon(
                                                        FontAwesomeIcons.eye,
                                                        color:
                                                            AppColors.iconLight,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "on".tr,
                                                      style: bodyTextNormal(
                                                          null,
                                                          AppColors.fontWhite,
                                                          FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 18,
                                                    vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: AppColors.greyOpacity,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: FaIcon(
                                                        FontAwesomeIcons
                                                            .eyeSlash,
                                                        color: AppColors
                                                            .iconPrimary,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "off".tr,
                                                      style: bodyTextNormal(
                                                          null,
                                                          AppColors.fontPrimary,
                                                          FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    var result = await showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return ListMultiSelectedAlertDialog(
                                            title: "company".tr,
                                            listItems: _listCompanies,
                                            selectedListItem:
                                                _selectedCompaniesListItem,
                                            status: "seekerHideCompany",
                                          );
                                        }).then(
                                      (value) {
                                        print("01: ${value}");
                                        setState(() {
                                          //value = []
                                          //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                          if (value.length > 0) {
                                            _selectedCompaniesListItem = value;
                                            _companiesName =
                                                []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                            for (var item in _listCompanies) {
                                              //
                                              //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedCompaniesListItem ກົງກັບ _listCompanies ບໍ່
                                              if (_selectedCompaniesListItem
                                                  .contains(item['_id'])) {
                                                //
                                                //add Provinces Name ເຂົ້າໃນ _companiesName
                                                setState(() {
                                                  _companiesName
                                                      .add(item['companyName']);
                                                });
                                              }
                                            }
                                            print(
                                                "_selectedCompaniesListItem ${_selectedCompaniesListItem}");
                                            // print(_companiesName);

                                            _statusShowLoading = true;
                                            Future.delayed(
                                                Duration(milliseconds: 200),
                                                () {
                                              hideCompany();
                                            });
                                          } else {
                                            _selectedCompaniesListItem = value;
                                            _statusShowLoading = true;
                                            Future.delayed(
                                                Duration(milliseconds: 200),
                                                () {
                                              hideCompany();
                                            });
                                          }
                                        });
                                      },
                                    );
                                  },
                                  child: Container(
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "hide profile from companies".tr,
                                            style: bodyTextNormal(
                                                null, null, FontWeight.bold),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 10,
                                        // ),
                                        _selectedCompaniesListItem.isEmpty
                                            ? Expanded(
                                                flex: 3,
                                                child: Container(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: SimpleButton(
                                                    text: "hide".tr,
                                                  ),
                                                ))
                                            : Expanded(
                                                flex: 3,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      // color: AppColors.red,
                                                      // height:
                                                      //     _listSeekerSearchableCompanies
                                                      //                 .length >
                                                      //             3
                                                      //         ? 50
                                                      //         : 60,
                                                      // width: 40,
                                                      child: Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: GridView.count(
                                                          crossAxisCount:
                                                              _listSeekerSearchableCompanies
                                                                          .length >
                                                                      3
                                                                  ? 3
                                                                  : 4,
                                                          crossAxisSpacing:
                                                              _listSeekerSearchableCompanies
                                                                          .length >
                                                                      3
                                                                  ? 2
                                                                  : 2,
                                                          mainAxisSpacing: 10,
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          children: List.generate(
                                                              _listSeekerSearchableCompanies
                                                                          .length >
                                                                      3
                                                                  ? 3
                                                                  : _listSeekerSearchableCompanies
                                                                      .length,
                                                              (index) {
                                                            dynamic c =
                                                                _listSeekerSearchableCompanies[
                                                                    index];

                                                            return Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: AppColors
                                                                      .borderGreyOpacity,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
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
                                                                              5),
                                                                  child: Center(
                                                                    child: c['logo'] ==
                                                                            ""
                                                                        ? Image
                                                                            .asset(
                                                                            'assets/image/no-image-available.png',
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          )
                                                                        : Image
                                                                            .network(
                                                                            "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${c['logo']}",
                                                                            fit:
                                                                                BoxFit.contain,
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
                                                            );
                                                          }),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        //
                                        //
                                        //ຖ້າ _listCompaniesAssignedProvince ຫຼາຍກວ່າ 3 ໃຫ້ສະແດງ Card Count ໂຕເລກ
                                        if (_listSeekerSearchableCompanies
                                                .length >
                                            3)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 2),
                                            child: Container(
                                              height: 46,
                                              width: 46,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppColors
                                                      .borderGreyOpacity,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color:
                                                    AppColors.backgroundWhite,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${_listSeekerSearchableCompanies.length - 3}",
                                                    style: bodyTextMaxNormal(
                                                        null,
                                                        AppColors.fontPrimary,
                                                        null),
                                                  ),
                                                  FaIcon(
                                                    FontAwesomeIcons.plus,
                                                    size: 15,
                                                    color:
                                                        AppColors.iconPrimary,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
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
