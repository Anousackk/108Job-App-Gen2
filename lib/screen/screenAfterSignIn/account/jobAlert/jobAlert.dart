// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_local_variable, prefer_final_fields, unnecessary_brace_in_string_interps, avoid_print, unused_field, unnecessary_string_interpolations, file_names

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:app/widget/listJobFuncSelectedAlertDialog.dart';
import 'package:app/widget/listMultiSelectedAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    // print(res);
    if (res.isNotEmpty) {
      dynamic resJobAlertSetting = res['jobAlertSetting'];
      _jobFunctionJobAlert = resJobAlertSetting['jobFunction'];
      _jobLevelJobAlert = resJobAlertSetting['jobLevel'];
      _workLocationJobAlert = resJobAlertSetting['workLocation'];
      _industryJobAlert = resJobAlertSetting['industry'];

      _jobAlertForEdit = res['jobAlertForEdit'];
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
        return CustomAlertLoading();
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
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomAlertDialogSuccess(
            title: "Success",
            text: "Save Job Alert Success",
            textButton: "OK",
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
      String mapWorkProvince =
          _selectedProvincesListItem.map((p) => p['_id']).join(',');
      _selectedProvincesListItem = mapWorkProvince.split(',');
      //
      //Work Province Name
      _provinceName = i['workLocation'];
      String mapWorkProvinceName =
          _provinceName.map((p) => p['name']).join(',');
      _provinceName = mapWorkProvinceName.split(',');

      //
      //Industry Id
      _selectedIndustryListItem = i['industry'];
      String mapIndustry =
          _selectedIndustryListItem.map((i) => i['_id']).join(',');
      _selectedIndustryListItem = mapIndustry.split(',');
      //
      //Industry Name
      _industryName = i['industry'];
      String mapIndustryName = _industryName.map((i) => i['name']).join(',');
      _industryName = mapIndustryName.split(',');

      //
      //Job Level Id
      _selectedJobLevelListItem = i['jobLevel'];
      String mapJobLevelId =
          _selectedJobLevelListItem.map((i) => i['_id']).join(',');
      _selectedJobLevelListItem = mapJobLevelId.split(',');
      //
      //Job Level Name
      _jobLevelName = i['jobLevel'];
      String mapJobLevelName = _jobLevelName.map((i) => i['name']).join(',');
      _jobLevelName = mapJobLevelName.split(',');

      //
      //Job Function Id(selectedItem id)
      _selectedJobFunctionsItems = i['jobFunction'];
      _selectedJobFunctionsItems =
          _selectedJobFunctionsItems.map((e) => e['_id'].toString()).toList();
      //
      //Job Function Name(seletedItem name)
      _jobFunctionItemName = i['jobFunction'];
      String mapJobFunctionItemName =
          _jobFunctionItemName.map((j) => j['name']).join(',');
      _jobFunctionItemName = mapJobFunctionItemName.split(',');
    });
  }

  @override
  void initState() {
    super.initState();
    getJobAlert();
    getReuseTypeSeeker('EN', 'JobLevel', _listJobLevels);
    getReuseTypeSeeker('EN', 'Province', _listProvinces);
    getReuseTypeSeeker('EN', 'Industry', _listIndustries);
    getJobFunctionsSeeker();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBarDefault(
          textTitle: "Job Alert",
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
                    color: AppColors.background,
                    height: double.infinity,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //
                                      //Job Function
                                      Text(
                                        "Job Function",
                                        style: bodyTextNormal(null, null),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${_jobFunctionJobAlert}",
                                        style: bodyTextNormal(
                                            null, FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),

                                      //
                                      //Working Location
                                      Text(
                                        "Working Location",
                                        style: bodyTextNormal(null, null),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${_workLocationJobAlert}",
                                        style: bodyTextNormal(
                                            null, FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),

                                      //
                                      //Industry
                                      Text(
                                        "Industry",
                                        style: bodyTextNormal(null, null),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${_industryJobAlert}",
                                        style: bodyTextNormal(
                                            null, FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),

                                      //
                                      //Job level
                                      Text(
                                        "Job Level",
                                        style: bodyTextNormal(null, null),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${_jobLevelJobAlert}",
                                        style: bodyTextNormal(
                                            null, FontWeight.bold),
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
                          text: res.isNotEmpty ? "Edit" : "Add",
                          fontWeight: FontWeight.bold,
                          press: () async {
                            if (res.isNotEmpty) {
                              _jobAlertForEdit;

                              setValueGetById(_jobAlertForEdit);
                            }
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
                                            },
                                            child: FaIcon(
                                              FontAwesomeIcons.arrowLeft,
                                              size: 20,
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                "Job Alert",
                                                style: bodyTextMedium(
                                                    null, FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //
                                    //
                                    //Content Job Alert
                                    content: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      color: AppColors.backgroundWhite,
                                      height:
                                          MediaQuery.of(context).size.height,
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
                                            //Job Function
                                            Text(
                                              "Job Functions",
                                              style: bodyTextNormal(
                                                  null, FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),

                                            BoxDecorationInput(
                                              mainAxisAlignmentTextIcon:
                                                  MainAxisAlignment.start,
                                              colorInput:
                                                  AppColors.backgroundWhite,
                                              colorBorder:
                                                  _selectedJobFunctionsItems
                                                              .isEmpty &&
                                                          _isValidateValue ==
                                                              true
                                                      ? AppColors.borderDanger
                                                      : AppColors
                                                          .borderSecondary,
                                              paddingFaIcon:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              widgetIconActive: FaIcon(
                                                FontAwesomeIcons.caretDown,
                                                color:
                                                    AppColors.iconGrayOpacity,
                                                size: IconSize.sIcon,
                                              ),
                                              press: () async {
                                                var result = await showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return ListJobFuncSelectedAlertDialog(
                                                        title: "Job Functions",
                                                        listItems:
                                                            _listJobFunctions,
                                                        selectedListItems:
                                                            _selectedJobFunctionsItems,
                                                      );
                                                    }).then(
                                                  (value) {
                                                    print(value);
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
                                                      print(
                                                          _jobFunctionItemName);
                                                      print(
                                                          _selectedJobFunctionsItems);
                                                    }
                                                  },
                                                );
                                              },
                                              text: _selectedJobFunctionsItems
                                                      .isNotEmpty
                                                  ? "${_jobFunctionItemName.join(', ')}"
                                                  : "Select Job Function",
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
                                                        "required",
                                                        style: bodyTextSmall(
                                                          AppColors.fontDanger,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                            ),
                                            SizedBox(height: 10),

                                            //
                                            //
                                            //Work Location
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Text(
                                                "Work Province",
                                                style: bodyTextNormal(
                                                    null, FontWeight.bold),
                                              ),
                                            ),
                                            BoxDecorationInput(
                                              mainAxisAlignmentTextIcon:
                                                  MainAxisAlignment.start,
                                              colorInput:
                                                  AppColors.backgroundWhite,
                                              colorBorder:
                                                  AppColors.borderSecondary,
                                              paddingFaIcon:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              widgetIconActive: FaIcon(
                                                  FontAwesomeIcons.caretDown,
                                                  size: IconSize.sIcon,
                                                  color: AppColors
                                                      .iconGrayOpacity),
                                              press: () async {
                                                var result = await showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return ListMultiSelectedAlertDialog(
                                                        title: "Work Province",
                                                        listItems:
                                                            _listProvinces,
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
                                                              .contains(item[
                                                                  '_id'])) {
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
                                                      .isEmpty
                                                  ? "Select Work Province"
                                                  : "${_provinceName.join(', ')}",
                                              validateText: Container(),
                                            ),
                                            SizedBox(height: 10),

                                            //
                                            //
                                            //Industry
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Text(
                                                "Industry",
                                                style: bodyTextNormal(
                                                    null, FontWeight.bold),
                                              ),
                                            ),
                                            BoxDecorationInput(
                                              mainAxisAlignmentTextIcon:
                                                  MainAxisAlignment.start,
                                              colorInput:
                                                  AppColors.backgroundWhite,
                                              colorBorder:
                                                  AppColors.borderSecondary,
                                              paddingFaIcon:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              widgetIconActive: FaIcon(
                                                  FontAwesomeIcons.caretDown,
                                                  size: 20,
                                                  color: AppColors
                                                      .iconGrayOpacity),
                                              press: () async {
                                                var result = await showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return ListMultiSelectedAlertDialog(
                                                        title: "Industry",
                                                        listItems:
                                                            _listIndustries,
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
                                                              .contains(item[
                                                                  '_id'])) {
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
                                                  ? "Select Industry"
                                                  : "${_industryName.join(', ')}",
                                              validateText: Container(),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),

                                            //
                                            //
                                            //Job Level
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Text(
                                                "Job Level",
                                                style: bodyTextNormal(
                                                    null, FontWeight.bold),
                                              ),
                                            ),
                                            BoxDecorationInput(
                                              mainAxisAlignmentTextIcon:
                                                  MainAxisAlignment.start,
                                              colorInput:
                                                  AppColors.backgroundWhite,
                                              colorBorder:
                                                  AppColors.borderSecondary,
                                              paddingFaIcon:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              widgetIconActive: FaIcon(
                                                  FontAwesomeIcons.caretDown,
                                                  size: 20,
                                                  color: AppColors
                                                      .iconGrayOpacity),
                                              press: () async {
                                                var result = await showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return ListMultiSelectedAlertDialog(
                                                        title: "Job Level",
                                                        listItems:
                                                            _listJobLevels,
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
                                                              .contains(item[
                                                                  '_id'])) {
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
                                                  ? "Select Industry"
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
                                          text: "Save",
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
