//
//Profile Setting
// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_final_fields, unused_field, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, sized_box_for_whitespace, await_only_futures, unused_local_variable, unnecessary_cast, avoid_print, prefer_is_empty, file_names

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/ProfileSetting/Widget/boxHideCompanies.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/ProfileSetting/Widget/boxPrefixSuffix.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/listMultiSelectedAlertDialog.dart';
import 'package:flutter/material.dart';
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
  String _companyName = "";

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

    if (mounted) {
      setState(() {});
    }
  }

  hideCompany(String status) async {
    print("Hide Company Working");
    //
    //
    //ສະແດງ AlertDialog Loading
    if (_statusShowLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomLoadingLogoCircle();
        },
      );
    }

    var res = await postData(hideCompanyProfileSetting, {
      "empId": _selectedCompaniesListItem,
    });

    print("${res}");

    if (res != null && _statusShowLoading) {
      _statusShowLoading = false;
      await fetchSeekerSearchableCompanies();
      Navigator.pop(context);
    }

    if (res != null) {
      await showDialog(
        // barrierDismissible: false,
        context: context,
        builder: (context) {
          return status == "add"
              ? CustAlertDialogSuccessWithoutBtn(
                  title: "successful".tr,
                  contentText: "change_information_success".tr,
                )
              : CustAlertDialogSuccessWithoutBtn(
                  boxCircleColor: AppColors.warning200,
                  iconColor: AppColors.warning600,
                  title: "delete_success".tr,
                  contentText: _companyName,
                );
        },
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  deleteHideCompany(String id, String companyName) {
    if (mounted) {
      setState(() {
        _selectedCompaniesListItem.removeWhere((item) => item.toString() == id);
        _companyName = companyName;

        Future.delayed(Duration(milliseconds: 200), () {
          hideCompany("delete");
        });

        print(_selectedCompaniesListItem.toString());
      });
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
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: AppColors.primary600,
        ),
        body: SafeArea(
          child: Column(
            children: [
              //
              //
              //
              //
              //Section
              //Appbar custom
              AppBarThreeWidgt(
                //
                //Widget Leading
                //Navigator.pop
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 45,
                      width: 45,
                      color: AppColors.iconLight.withOpacity(0.1),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "\uf060",
                          style: fontAwesomeRegular(
                              null, 20, AppColors.iconLight, null),
                        ),
                      ),
                    ),
                  ),
                ),

                //
                //
                //Widget Title
                //Text title
                title: Text(
                  "profile setting".tr,
                  style: appbarTextMedium(
                      "NotoSansLaoLoopedBold", AppColors.fontWhite, null),
                ),

                //
                //
                //Widget Actions
                //Profile setting
                actions: Container(
                  height: 45,
                  width: 45,
                ),
              ),

              //
              //
              //
              //
              //Section
              //Content profile setting
              Expanded(
                child: _isLoading
                    ? Container(
                        color: AppColors.background,
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(child: CustomLoadingLogoCircle()),
                      )
                    : Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: AppColors.backgroundWhite,
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "profile status".tr,
                                      style: bodyTextMaxNormal(
                                        "NotoSansLaoLoopedBold",
                                        null,
                                        FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),

                                    BoxDecInputProfileSettingPrefixTextSuffixWidget(
                                      text: "Profile Searchable",
                                      press: () {
                                        pressSearchable();
                                      },
                                      suffixWidget: _isSearchable
                                          ? Container(
                                              child: Text(
                                                "\uf205",
                                                style: fontAwesomeSolid(
                                                    null,
                                                    24,
                                                    AppColors.primary600,
                                                    null),
                                              ),
                                            )
                                          : Container(
                                              child: Text(
                                                "\uf204",
                                                style: fontAwesomeSolid(
                                                    null,
                                                    24,
                                                    AppColors.dark500,
                                                    null),
                                              ),
                                            ),
                                      validateText: Container(),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),

                                    // Container(
                                    //   width: double.infinity,
                                    //   padding: EdgeInsets.all(10),
                                    //   decoration: BoxDecoration(
                                    //     color: AppColors.inputWhite,
                                    //     borderRadius: BorderRadius.circular(10),
                                    //   ),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       Text(
                                    //         "searchable profile".tr,
                                    //         style: bodyTextNormal(
                                    //             null, null, FontWeight.bold),
                                    //       ),
                                    //       GestureDetector(
                                    //         onTap: () {
                                    //           pressSearchable();
                                    //         },
                                    //         child: _isSearchable
                                    //             ? Container(
                                    //                 padding: EdgeInsets.symmetric(
                                    //                     horizontal: 18, vertical: 8),
                                    //                 decoration: BoxDecoration(
                                    //                   color: AppColors.primary,
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(50),
                                    //                 ),
                                    //                 child: Row(
                                    //                   children: [
                                    //                     Container(
                                    //                       child: FaIcon(
                                    //                         FontAwesomeIcons.eye,
                                    //                         color:
                                    //                             AppColors.iconLight,
                                    //                         size: 20,
                                    //                       ),
                                    //                     ),
                                    //                     SizedBox(
                                    //                       width: 10,
                                    //                     ),
                                    //                     Text(
                                    //                       "on".tr,
                                    //                       style: bodyTextNormal(
                                    //                           null,
                                    //                           AppColors.fontWhite,
                                    //                           FontWeight.bold),
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //               )
                                    //             : Container(
                                    //                 padding: EdgeInsets.symmetric(
                                    //                     horizontal: 18, vertical: 8),
                                    //                 decoration: BoxDecoration(
                                    //                   color: AppColors.greyOpacity,
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(50),
                                    //                 ),
                                    //                 child: Row(
                                    //                   children: [
                                    //                     Container(
                                    //                       child: FaIcon(
                                    //                         FontAwesomeIcons.eyeSlash,
                                    //                         color:
                                    //                             AppColors.iconPrimary,
                                    //                         size: 20,
                                    //                       ),
                                    //                     ),
                                    //                     SizedBox(
                                    //                       width: 10,
                                    //                     ),
                                    //                     Text(
                                    //                       "off".tr,
                                    //                       style: bodyTextNormal(
                                    //                           null,
                                    //                           AppColors.fontPrimary,
                                    //                           FontWeight.bold),
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //               ),
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),

                                    Text(
                                      "Hide from companies below",
                                      style: bodyTextMaxNormal(
                                        "NotoSansLaoLoopedBold",
                                        null,
                                        FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),

                                    BoxDecInputHideCompanies(
                                      prefixImage: null,
                                      text: "Add Company",
                                      press: () async {
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
                                            if (value != null) {
                                              setState(() {
                                                //value = []
                                                //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                                if (value.length > 0) {
                                                  _selectedCompaniesListItem =
                                                      value;
                                                  _companiesName =
                                                      []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້
                                                  for (var item
                                                      in _listCompanies) {
                                                    //
                                                    //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedCompaniesListItem ກົງກັບ _listCompanies ບໍ່
                                                    if (_selectedCompaniesListItem
                                                        .contains(
                                                            item['_id'])) {
                                                      //
                                                      //add Provinces Name ເຂົ້າໃນ _companiesName
                                                      setState(() {
                                                        _companiesName.add(item[
                                                            'companyName']);
                                                      });
                                                    }
                                                  }
                                                  print(
                                                      "_selectedCompaniesListItem ${_selectedCompaniesListItem}");
                                                  // print(_companiesName);
                                                  _statusShowLoading = true;
                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 200),
                                                      () {
                                                    hideCompany("add");
                                                  });
                                                } else {
                                                  _selectedCompaniesListItem =
                                                      value;
                                                  _statusShowLoading = true;
                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 200),
                                                      () {
                                                    hideCompany("add");
                                                  });
                                                }
                                              });
                                            }
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Text(_selectedCompaniesListItem.toString()),
                                    // Text(_listSeekerSearchableCompanies
                                    //     .toString()),

                                    if (_selectedCompaniesListItem.length > 0)
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            _listSeekerSearchableCompanies
                                                .length,
                                        itemBuilder: (context, index) {
                                          dynamic i =
                                              _listSeekerSearchableCompanies[
                                                  index];
                                          return Column(
                                            children: [
                                              BoxDecInputHideCompanies(
                                                boxColor: AppColors.dark100,
                                                prefixBoxImageColor:
                                                    AppColors.backgroundWhite,
                                                prefixImage: "${i["logo"]}",
                                                text: "${i["companyName"]}",
                                                suffixIcon: "\uf1f8",
                                                press: () {},
                                                suffixPress: () async {
                                                  var result = await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                                          title:
                                                              "delete_this_info"
                                                                  .tr,
                                                          contentText:
                                                              "${i["companyName"]}",
                                                          textButtonLeft:
                                                              'cancel'.tr,
                                                          textButtonRight:
                                                              'confirm'.tr,
                                                        );
                                                      });
                                                  if (result == 'Ok') {
                                                    print(
                                                        "confirm delete hide company");
                                                    _statusShowLoading = true;
                                                    deleteHideCompany(
                                                        "${i["_id"]}",
                                                        "${i["companyName"]}");
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          );
                                        },
                                      ),

                                    // GestureDetector(
                                    //   onTap: () async {
                                    //     var result = await showDialog(
                                    //         barrierDismissible: false,
                                    //         context: context,
                                    //         builder: (context) {
                                    //           return ListMultiSelectedAlertDialog(
                                    //             title: "company".tr,
                                    //             listItems: _listCompanies,
                                    //             selectedListItem:
                                    //                 _selectedCompaniesListItem,
                                    //             status: "seekerHideCompany",
                                    //           );
                                    //         }).then(
                                    //       (value) {
                                    //         print("01: ${value}");
                                    //         setState(() {
                                    //           //value = []
                                    //           //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                    //           if (value.length > 0) {
                                    //             _selectedCompaniesListItem = value;
                                    //             _companiesName =
                                    //                 []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້
                                    //             for (var item in _listCompanies) {
                                    //               //
                                    //               //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedCompaniesListItem ກົງກັບ _listCompanies ບໍ່
                                    //               if (_selectedCompaniesListItem
                                    //                   .contains(item['_id'])) {
                                    //                 //
                                    //                 //add Provinces Name ເຂົ້າໃນ _companiesName
                                    //                 setState(() {
                                    //                   _companiesName
                                    //                       .add(item['companyName']);
                                    //                 });
                                    //               }
                                    //             }
                                    //             print(
                                    //                 "_selectedCompaniesListItem ${_selectedCompaniesListItem}");
                                    //             // print(_companiesName);
                                    //             _statusShowLoading = true;
                                    //             Future.delayed(
                                    //                 Duration(milliseconds: 200), () {
                                    //               hideCompany();
                                    //             });
                                    //           } else {
                                    //             _selectedCompaniesListItem = value;
                                    //             _statusShowLoading = true;
                                    //             Future.delayed(
                                    //                 Duration(milliseconds: 200), () {
                                    //               hideCompany();
                                    //             });
                                    //           }
                                    //         });
                                    //       },
                                    //     );
                                    //   },
                                    //   child: Container(
                                    //     child: Row(
                                    //       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //       children: [
                                    //         Expanded(
                                    //           flex: 3,
                                    //           child: Text(
                                    //             "hide profile from companies".tr,
                                    //             style: bodyTextNormal(
                                    //                 null, null, FontWeight.bold),
                                    //           ),
                                    //         ),
                                    //         // SizedBox(
                                    //         //   width: 10,
                                    //         // ),
                                    //         _selectedCompaniesListItem.isEmpty
                                    //             ? Expanded(
                                    //                 flex: 3,
                                    //                 child: Container(
                                    //                   padding:
                                    //                       EdgeInsets.only(left: 10),
                                    //                   child: SimpleButton(
                                    //                     text: "hide".tr,
                                    //                   ),
                                    //                 ))
                                    //             : Expanded(
                                    //                 flex: 3,
                                    //                 child: Column(
                                    //                   mainAxisAlignment:
                                    //                       MainAxisAlignment.center,
                                    //                   children: [
                                    //                     Container(
                                    //                       // color: AppColors.red,
                                    //                       // height:
                                    //                       //     _listSeekerSearchableCompanies
                                    //                       //                 .length >
                                    //                       //             3
                                    //                       //         ? 50
                                    //                       //         : 60,
                                    //                       // width: 40,
                                    //                       child: Directionality(
                                    //                         textDirection:
                                    //                             TextDirection.rtl,
                                    //                         child: GridView.count(
                                    //                           crossAxisCount:
                                    //                               _listSeekerSearchableCompanies
                                    //                                           .length >
                                    //                                       3
                                    //                                   ? 3
                                    //                                   : 4,
                                    //                           crossAxisSpacing:
                                    //                               _listSeekerSearchableCompanies
                                    //                                           .length >
                                    //                                       3
                                    //                                   ? 2
                                    //                                   : 2,
                                    //                           mainAxisSpacing: 10,
                                    //                           shrinkWrap: true,
                                    //                           physics:
                                    //                               NeverScrollableScrollPhysics(),
                                    //                           children: List.generate(
                                    //                               _listSeekerSearchableCompanies
                                    //                                           .length >
                                    //                                       3
                                    //                                   ? 3
                                    //                                   : _listSeekerSearchableCompanies
                                    //                                       .length,
                                    //                               (index) {
                                    //                             dynamic c =
                                    //                                 _listSeekerSearchableCompanies[
                                    //                                     index];
                                    //                             return Container(
                                    //                               decoration:
                                    //                                   BoxDecoration(
                                    //                                 border:
                                    //                                     Border.all(
                                    //                                   color: AppColors
                                    //                                       .borderGreyOpacity,
                                    //                                 ),
                                    //                                 borderRadius:
                                    //                                     BorderRadius
                                    //                                         .circular(
                                    //                                             5),
                                    //                                 color: AppColors
                                    //                                     .backgroundWhite,
                                    //                               ),
                                    //                               child: Padding(
                                    //                                 padding:
                                    //                                     const EdgeInsets
                                    //                                         .all(5),
                                    //                                 child: ClipRRect(
                                    //                                   borderRadius:
                                    //                                       BorderRadius
                                    //                                           .circular(
                                    //                                               5),
                                    //                                   child: Center(
                                    //                                     child: c['logo'] ==
                                    //                                             ""
                                    //                                         ? Image
                                    //                                             .asset(
                                    //                                             'assets/image/no-image-available.png',
                                    //                                             fit: BoxFit
                                    //                                                 .contain,
                                    //                                           )
                                    //                                         : Image
                                    //                                             .network(
                                    //                                             "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${c['logo']}",
                                    //                                             fit: BoxFit
                                    //                                                 .contain,
                                    //                                             errorBuilder: (context,
                                    //                                                 error,
                                    //                                                 stackTrace) {
                                    //                                               return Image.asset(
                                    //                                                 'assets/image/no-image-available.png',
                                    //                                                 fit: BoxFit.contain,
                                    //                                               ); // Display an error message
                                    //                                             },
                                    //                                           ),
                                    //                                   ),
                                    //                                 ),
                                    //                               ),
                                    //                             );
                                    //                           }),
                                    //                         ),
                                    //                       ),
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //               ),
                                    //         //
                                    //         //
                                    //         //ຖ້າ _listCompaniesAssignedProvince ຫຼາຍກວ່າ 3 ໃຫ້ສະແດງ Card Count ໂຕເລກ
                                    //         if (_listSeekerSearchableCompanies
                                    //                 .length >
                                    //             3)
                                    //           Padding(
                                    //             padding:
                                    //                 const EdgeInsets.only(left: 2),
                                    //             child: Container(
                                    //               height: 46,
                                    //               width: 46,
                                    //               decoration: BoxDecoration(
                                    //                 border: Border.all(
                                    //                   color:
                                    //                       AppColors.borderGreyOpacity,
                                    //                 ),
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(5),
                                    //                 color: AppColors.backgroundWhite,
                                    //               ),
                                    //               child: Row(
                                    //                 crossAxisAlignment:
                                    //                     CrossAxisAlignment.center,
                                    //                 mainAxisAlignment:
                                    //                     MainAxisAlignment.center,
                                    //                 children: [
                                    //                   Text(
                                    //                     "${_listSeekerSearchableCompanies.length - 3}",
                                    //                     style: bodyTextMaxNormal(
                                    //                         null,
                                    //                         AppColors.fontPrimary,
                                    //                         null),
                                    //                   ),
                                    //                   FaIcon(
                                    //                     FontAwesomeIcons.plus,
                                    //                     size: 15,
                                    //                     color: AppColors.iconPrimary,
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //           )
                                    //       ],
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
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
    );
  }
}
