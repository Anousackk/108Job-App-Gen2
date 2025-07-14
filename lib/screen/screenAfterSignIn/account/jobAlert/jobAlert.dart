// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_local_variable, prefer_final_fields, unnecessary_brace_in_string_interps, avoid_print, unused_field, unnecessary_string_interpolations, file_names, prefer_is_empty

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:app/widget/listJobFuncSelectedAlertDialog.dart';
import 'package:app/widget/listMultiSelectedAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobAlert extends StatefulWidget {
  const JobAlert({Key? key}) : super(key: key);

  @override
  State<JobAlert> createState() => _JobAlertState();
}

class _JobAlertState extends State<JobAlert> {
  //
  //Get list items all
  List _listJobFunctions = [];
  List _listProvinces = [];
  List _listIndustries = [];
  List _listJobLevels = [];

  //
  //Selected list item(ສະເພາະເຂົ້າ Database)
  List _selectedJobFunctionsItems = [];
  List _selectedProvincesListItem = [];
  List _selectedIndustryListItem = [];
  List _selectedJobLevelListItem = [];

  //
  //value display(ສະເພາະສະແດງ)
  List _jobFunctionItemName = [];
  List _provinceName = [];
  List _industryName = [];
  List _jobLevelName = [];

  bool _isValidateValue = false;
  bool _isLoading = true;

  dynamic _jobAlertForEdit;
  String _jobFunctionJobAlert = "";
  String _jobLevelJobAlert = "";
  String _workLocationJobAlert = "";
  String _industryJobAlert = "";
  String _localeLanguageApi = "";
  Map<String, dynamic> res = {};

  getReuseTypeSeeker(String lang, String type, List listValue) async {
    var res =
        await fetchData(getReuseTypeApiSeeker + "lang=${lang}&type=${type}");
    setState(() {
      listValue.clear(); // Clear the existing list
      listValue.addAll(res['seekerReuse']); // Add elements from the response
    });
  }

  getJobFunctionsSeeker() async {
    var res = await fetchData(getJobFunctionsSeekerApi);
    _listJobFunctions = res['mapper'];
    setState(() {});
  }

  getJobAlert() async {
    res = await fetchData(getJobAlertSeekerApi);
    print(res);
    if (res.isNotEmpty) {
      dynamic resJobAlertSetting = res['jobAlertSetting'];
      _jobFunctionJobAlert = resJobAlertSetting['jobFunction'];
      _jobLevelJobAlert = resJobAlertSetting['jobLevel'];
      _workLocationJobAlert = resJobAlertSetting['workLocation'];
      _industryJobAlert = resJobAlertSetting['industry'];

      _jobAlertForEdit = res['jobAlertForEdit'];
      _selectedIndustryListItem = _jobAlertForEdit['industry'];
      _selectedJobFunctionsItems = _jobAlertForEdit['jobFunction'];
      _selectedJobLevelListItem = _jobAlertForEdit['jobLevel'];
      _selectedProvincesListItem = _jobAlertForEdit['workLocation'];
    } else {
      print("eie");
    }

    _isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  addJobAlert() async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    var res = await postData(addJobAlertSeekerApi, {
      "jobTitle": [],
      "jobFunctionId": _selectedJobFunctionsItems,
      "jobLevelId": _selectedJobLevelListItem,
      "workLocation": _selectedProvincesListItem,
      "industryId": _selectedIndustryListItem
    });

    // print(res);
    if (res != null) {
      Navigator.pop(context);
    }

    if (res != null) {
      print(res.toString());
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "successful".tr,
            contentText:
                "save".tr + " " + "job_alert".tr + " " + "successful".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
              Navigator.pop(context);
              getJobAlert();
            },
          );
        },
      );
    }
  }

  setValueGetById(val) {
    setState(() {
      dynamic i = val;

      //
      //Work Province Id
      _selectedProvincesListItem = i['workLocation'];
      if (_selectedProvincesListItem.length > 0) {
        String mapWorkProvince =
            _selectedProvincesListItem.map((p) => p['_id']).join(',');
        _selectedProvincesListItem = mapWorkProvince.split(',');

        //
        //Work Province Name
        _provinceName = i['workLocation'];
        String mapWorkProvinceName =
            _provinceName.map((p) => p['name']).join(',');
        _provinceName = mapWorkProvinceName.split(',');
      }

      //
      //Industry Id
      _selectedIndustryListItem = i['industry'];
      if (_selectedIndustryListItem.length > 0) {
        String mapIndustry =
            _selectedIndustryListItem.map((i) => i['_id']).join(',');
        _selectedIndustryListItem = mapIndustry.split(',');
        //
        //Industry Name
        _industryName = i['industry'];
        String mapIndustryName = _industryName.map((i) => i['name']).join(',');
        _industryName = mapIndustryName.split(',');
      }

      //
      //Job Level Id
      _selectedJobLevelListItem = i['jobLevel'];
      if (_selectedJobLevelListItem.length > 0) {
        String mapJobLevelId =
            _selectedJobLevelListItem.map((i) => i['_id']).join(',');
        _selectedJobLevelListItem = mapJobLevelId.split(',');
        //
        //Job Level Name
        _jobLevelName = i['jobLevel'];
        String mapJobLevelName = _jobLevelName.map((i) => i['name']).join(',');
        _jobLevelName = mapJobLevelName.split(',');
      }

      //
      //Job Function Id(selectedItem id)
      _selectedJobFunctionsItems = i['jobFunction'];
      if (_selectedJobFunctionsItems.length > 0) {
        _selectedJobFunctionsItems =
            _selectedJobFunctionsItems.map((e) => e['_id'].toString()).toList();
        //
        //Job Function Name(seletedItem name)
        _jobFunctionItemName = i['jobFunction'];
        String mapJobFunctionItemName =
            _jobFunctionItemName.map((j) => j['name']).join(',');
        _jobFunctionItemName = mapJobFunctionItemName.split(',');
      }
    });
  }

  getSharedPreferences() async {
    // final prefs = await SharedPreferences.getInstance();
    // var getLanguageSharePref = prefs.getString('setLanguage');
    // var getLanguageApiSharePref = prefs.getString('setLanguageApi');
    var getLanguageSharePref = await SharedPrefsHelper.getString("setLanguage");
    var getLanguageApiSharePref =
        await SharedPrefsHelper.getString("setLanguageApi");

    // print("local " + getLanguageSharePref.toString());
    // print("api " + getLanguageApiSharePref.toString());

    setState(() {
      _localeLanguageApi = getLanguageApiSharePref.toString();
    });

    getReuseTypeSeeker(_localeLanguageApi, 'JobLevel', _listJobLevels);
    getReuseTypeSeeker(_localeLanguageApi, 'Province', _listProvinces);
    getReuseTypeSeeker(_localeLanguageApi, 'Industry', _listIndustries);
  }

  @override
  void initState() {
    super.initState();
    getJobAlert();
    getSharedPreferences();
    getJobFunctionsSeeker();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: _isLoading
          ? Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
              ),
              body: Container(
                color: AppColors.backgroundWhite,
                width: double.infinity,
                height: double.infinity,
                child: Center(child: CustomLoadingLogoCircle()),
              ),
            )
          : Scaffold(
              appBar: AppBarDefault(
                textTitle: "job_alert".tr,
                // fontWeight: FontWeight.bold,
                leadingIcon: Icon(Icons.arrow_back),
                leadingPress: () {
                  Navigator.of(context).pop();
                },
              ),
              body: SafeArea(
                  child: Container(
                color: AppColors.background,
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Text("${_selectedIndustryListItem}"),
                    // Text("${_selectedJobFunctionsItems}"),
                    // Text("${_selectedJobLevelListItem}"),
                    // Text("${_selectedProvincesListItem}"),
                    SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Column(
                          children: [
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
                                  //Job Function
                                  Text(
                                    "job function".tr,
                                    style: bodyTextNormal(null, null, null),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${_jobFunctionJobAlert != 'Any' ? _jobFunctionJobAlert : ''}",
                                    style: bodyTextNormal(
                                        null, null, FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),

                                  //
                                  //
                                  //Working Province
                                  Text(
                                    "work province".tr,
                                    style: bodyTextNormal(null, null, null),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${_workLocationJobAlert != 'Any' ? _workLocationJobAlert : ''}",
                                    style: bodyTextNormal(
                                        null, null, FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),

                                  //
                                  //
                                  //Industry
                                  Text(
                                    "industry".tr,
                                    style: bodyTextNormal(null, null, null),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${_industryJobAlert != 'Any' ? _industryJobAlert : ''}",
                                    style: bodyTextNormal(
                                        null, null, FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),

                                  //
                                  //
                                  //Job level
                                  Text(
                                    "job level".tr,
                                    style: bodyTextNormal(null, null, null),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${_jobLevelJobAlert != 'Any' ? _jobLevelJobAlert : ''}",
                                    style: bodyTextNormal(
                                        null, null, FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Button(
                      text: res.isNotEmpty
                          // ||  res['jobAlertForEdit']['jobFunction'].length >
                          //       0 ||
                          //   res['jobAlertForEdit']['jobLevel'].length >
                          //       0 ||
                          //   res['jobAlertForEdit']['workLocation']
                          //           .length >
                          //       0 ||
                          //   res['jobAlertForEdit']['industry'].length > 0
                          ? "edit".tr
                          : "add".tr,
                      press: () async {
                        print(res);
                        if (res.isNotEmpty) {
                          _jobAlertForEdit;

                          setValueGetById(_jobAlertForEdit);
                        }

                        //
                        //
                        //
                        //
                        //
                        //Alert Dialog Job Alert
                        var result = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return AlertDialog(
                                titlePadding: EdgeInsets.zero,
                                contentPadding: EdgeInsets.zero,
                                insetPadding: EdgeInsets.zero,
                                actionsPadding: EdgeInsets.zero,

                                //
                                //
                                //Title Job Alert
                                title: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  decoration: BoxDecoration(
                                      color: AppColors.backgroundWhite,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppColors.borderSecondary,
                                        ),
                                      )),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          getJobAlert();
                                        },
                                        child: FaIcon(
                                          FontAwesomeIcons.arrowLeft,
                                          size: 20,
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "job_alert".tr,
                                            style: bodyTextMedium(
                                                null, null, FontWeight.bold),
                                          ),
                                        ),
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
                                //Content Job Alert
                                content: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  color: AppColors.backgroundWhite,
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: SingleChildScrollView(
                                    physics: ClampingScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),

                                        //
                                        //
                                        //
                                        //
                                        //
                                        //Job Function
                                        Text(
                                          "job function".tr,
                                          style: bodyTextNormal(
                                              null, null, FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),

                                        BoxDecorationInput(
                                          mainAxisAlignmentTextIcon:
                                              MainAxisAlignment.start,
                                          colorInput: AppColors.backgroundWhite,
                                          colorBorder:
                                              _selectedJobFunctionsItems
                                                          .isEmpty &&
                                                      _isValidateValue == true
                                                  ? AppColors.borderDanger
                                                  : AppColors.borderSecondary,
                                          paddingFaIcon: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          widgetIconActive: FaIcon(
                                            FontAwesomeIcons.caretDown,
                                            color: AppColors.iconGrayOpacity,
                                            size: IconSize.sIcon,
                                          ),
                                          press: () async {
                                            var result = await showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return ListJobFuncSelectedAlertDialog(
                                                    title: "job function".tr,
                                                    listItems:
                                                        _listJobFunctions,
                                                    selectedListItems:
                                                        _selectedJobFunctionsItems,
                                                  );
                                                }).then(
                                              (value) {
                                                print(value);
                                                setState(() {
                                                  _selectedJobFunctionsItems =
                                                      value;
                                                  List pName = [];
                                                  List chName = [];

                                                  //value = [_selectedListItemsChilds]
                                                  //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                                  if (value != null) {
                                                    print("value != null");
                                                    _selectedJobFunctionsItems =
                                                        value;
                                                    _jobFunctionItemName =
                                                        []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                                    for (var pItem
                                                        in _listJobFunctions) {
                                                      //
                                                      //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedJobFunctionsItems ກົງກັບ _listJobFunctions ບໍ່
                                                      if (_selectedJobFunctionsItems
                                                          .contains(
                                                              pItem["_id"])) {
                                                        setState(() {
                                                          _jobFunctionItemName
                                                              .add(pItem[
                                                                  "name"]);
                                                        });
                                                      }
                                                      for (var chItem
                                                          in pItem["item"]) {
                                                        if (_selectedJobFunctionsItems
                                                            .contains(chItem[
                                                                "_id"])) {
                                                          setState(() {
                                                            _jobFunctionItemName
                                                                .add(chItem[
                                                                    "name"]);
                                                          });
                                                        }
                                                      }
                                                    }

                                                    // print(pName);
                                                    // print(chName);
                                                    print(_jobFunctionItemName);
                                                    print(
                                                        _selectedJobFunctionsItems);
                                                  }
                                                });
                                              },
                                            );
                                          },
                                          text: _selectedJobFunctionsItems
                                                  .isNotEmpty
                                              ? "${_jobFunctionItemName.join(', ')}"
                                              : "select".tr +
                                                  " " +
                                                  "job function".tr,
                                          validateText: _isValidateValue ==
                                                      true &&
                                                  _selectedJobFunctionsItems
                                                      .isEmpty
                                              ? Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.only(
                                                    left: 15,
                                                    top: 5,
                                                  ),
                                                  child: Text(
                                                    "required".tr,
                                                    style: bodyTextSmall(
                                                        null,
                                                        AppColors.fontDanger,
                                                        null),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                        SizedBox(height: 10),

                                        //
                                        //
                                        //
                                        //
                                        //
                                        //Work Location
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            "work province".tr,
                                            style: bodyTextNormal(
                                                null, null, FontWeight.bold),
                                          ),
                                        ),
                                        BoxDecorationInput(
                                          mainAxisAlignmentTextIcon:
                                              MainAxisAlignment.start,
                                          colorInput: AppColors.backgroundWhite,
                                          colorBorder:
                                              AppColors.borderSecondary,
                                          paddingFaIcon: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          widgetIconActive: FaIcon(
                                              FontAwesomeIcons.caretDown,
                                              size: IconSize.sIcon,
                                              color: AppColors.iconGrayOpacity),
                                          press: () async {
                                            var result = await showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return ListMultiSelectedAlertDialog(
                                                    title: "work province".tr,
                                                    listItems: _listProvinces,
                                                    selectedListItem:
                                                        _selectedProvincesListItem,
                                                  );
                                                }).then(
                                              (value) {
                                                setState(() {
                                                  //value = []
                                                  //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                                  if (value.length > 0) {
                                                    _selectedProvincesListItem =
                                                        value;
                                                    _provinceName =
                                                        []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                                    for (var item
                                                        in _listProvinces) {
                                                      //
                                                      //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedProvincesListItem ກົງກັບ _listProvinces ບໍ່
                                                      if (_selectedProvincesListItem
                                                          .contains(
                                                              item['_id'])) {
                                                        //
                                                        //add Provinces Name ເຂົ້າໃນ _provinceName
                                                        setState(() {
                                                          _provinceName.add(
                                                              item['name']);
                                                        });
                                                      }
                                                    }
                                                    print(_provinceName);
                                                  }
                                                });
                                              },
                                            );
                                          },
                                          text: _selectedProvincesListItem
                                                      .length >
                                                  0
                                              ? "${_provinceName.join(', ')}"
                                              : "select".tr +
                                                  " " +
                                                  "work province".tr,
                                          validateText: Container(),
                                        ),
                                        SizedBox(height: 10),

                                        //
                                        //
                                        //
                                        //
                                        //
                                        //Industry
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            "industry".tr,
                                            style: bodyTextNormal(
                                                null, null, FontWeight.bold),
                                          ),
                                        ),
                                        BoxDecorationInput(
                                          mainAxisAlignmentTextIcon:
                                              MainAxisAlignment.start,
                                          colorInput: AppColors.backgroundWhite,
                                          colorBorder:
                                              AppColors.borderSecondary,
                                          paddingFaIcon: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          widgetIconActive: FaIcon(
                                              FontAwesomeIcons.caretDown,
                                              size: 20,
                                              color: AppColors.iconGrayOpacity),
                                          press: () async {
                                            var result = await showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return ListMultiSelectedAlertDialog(
                                                    title: "industry".tr,
                                                    listItems: _listIndustries,
                                                    selectedListItem:
                                                        _selectedIndustryListItem,
                                                  );
                                                }).then(
                                              (value) {
                                                setState(() {
                                                  //value = []
                                                  //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                                  if (value.length > 0) {
                                                    _selectedIndustryListItem =
                                                        value;
                                                    _industryName =
                                                        []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                                    for (var item
                                                        in _listIndustries) {
                                                      //
                                                      //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedIndustryListItem ກົງກັບ _listIndustries ບໍ່
                                                      if (_selectedIndustryListItem
                                                          .contains(
                                                              item['_id'])) {
                                                        //
                                                        //add Language Name ເຂົ້າໃນ _industryName
                                                        setState(() {
                                                          _industryName.add(
                                                              item['name']);
                                                        });
                                                      }
                                                    }
                                                    print(_industryName);
                                                  }
                                                });
                                              },
                                            );
                                          },
                                          text: _selectedIndustryListItem
                                                  .isEmpty
                                              ? "select".tr +
                                                  " " +
                                                  "industry".tr
                                              : "${_industryName.join(', ')}",
                                          validateText: Container(),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),

                                        //
                                        //
                                        //
                                        //
                                        //
                                        //
                                        //Job Level
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            "job level".tr,
                                            style: bodyTextNormal(
                                                null, null, FontWeight.bold),
                                          ),
                                        ),
                                        BoxDecorationInput(
                                          mainAxisAlignmentTextIcon:
                                              MainAxisAlignment.start,
                                          colorInput: AppColors.backgroundWhite,
                                          colorBorder:
                                              AppColors.borderSecondary,
                                          paddingFaIcon: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          widgetIconActive: FaIcon(
                                              FontAwesomeIcons.caretDown,
                                              size: 20,
                                              color: AppColors.iconGrayOpacity),
                                          press: () async {
                                            var result = await showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return ListMultiSelectedAlertDialog(
                                                    title: "job level".tr,
                                                    listItems: _listJobLevels,
                                                    selectedListItem:
                                                        _selectedJobLevelListItem,
                                                  );
                                                }).then(
                                              (value) {
                                                setState(() {
                                                  //value = []
                                                  //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                                  if (value.length > 0) {
                                                    _selectedJobLevelListItem =
                                                        value;
                                                    _jobLevelName =
                                                        []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                                    for (var item
                                                        in _listJobLevels) {
                                                      //
                                                      //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedJobLevelListItem ກົງກັບ _listJobLevels ບໍ່
                                                      if (_selectedJobLevelListItem
                                                          .contains(
                                                              item['_id'])) {
                                                        //
                                                        //add Language Name ເຂົ້າໃນ _jobLevelName
                                                        setState(() {
                                                          _jobLevelName.add(
                                                              item['name']);
                                                        });
                                                      }
                                                    }
                                                    print(_jobLevelName);
                                                  }
                                                });
                                              },
                                            );
                                          },
                                          text: _selectedJobLevelListItem
                                                  .isEmpty
                                              ? "select".tr +
                                                  " " +
                                                  "job level".tr
                                              : "${_jobLevelName.join(', ')}",
                                          validateText: Container(),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  // if (res!.isNotEmpty)
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 30),
                                    color: AppColors.backgroundWhite,
                                    child: Button(
                                      text: "save".tr,
                                      press: () {
                                        addJobAlert();
                                      },
                                    ),
                                  ),
                                ],
                              );
                            });
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )),
            ),
    );
  }
}
