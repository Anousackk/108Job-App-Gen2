// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unused_local_variable, avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_is_empty, unused_element, file_names

import 'dart:convert';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/boxIconMutiSelectedAlertDialog.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:app/widget/listJobFuncSelectedAlertDialog.dart';
import 'package:app/widget/listMultiSelectedAlertDialog.dart';
import 'package:app/widget/listSingleSelectedAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_quill/flutter_quill.dart';

class WorkPreferences extends StatefulWidget {
  const WorkPreferences({Key? key, this.id, this.workPreference})
      : super(key: key);
  final String? id;
  final dynamic workPreference;

  @override
  State<WorkPreferences> createState() => _WorkPreferencesState();
}

class _WorkPreferencesState extends State<WorkPreferences> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _workPositionController = TextEditingController();
  TextEditingController _salaryController = TextEditingController();
  TextEditingController _professionalSummaryController =
      TextEditingController();
  QuillController _quillController = QuillController.basic();
  FocusScopeNode _currentFocus = FocusScopeNode();
  FocusNode focusNode = FocusNode();
  FocusNode editorFocusNode = FocusNode();

  bool isToolBarVisible = true;

  //
  //Get list items all
  List _listJobFunctions = [];
  List _listJobFunctionsItem = [];
  List _listJobLevels = [];
  List _listProvinces = [];
  List _listIndustries = [];
  List _listBenefits = [];

  //
  //Selected list item(ສະເພາະເຂົ້າ Database)
  String? _id;
  String _workPosition = "";
  String _currency = "₭";
  String _salary = "";
  String _selectedJobLevel = "";
  String _selectedJobFunctions = "";
  List _selectedJobFunctionsItems = [];
  List _selectedProvincesListItem = [];
  List _selectedIndustriesListItem = [];
  List _selectedBenefitsListItem = [];
  String _professionalSummary = "";

  //
  //value display(ສະເພາະສະແດງ)
  List _jobFunctionItemName = [];
  List _provinceName = [];
  List _industryName = [];
  List _benefitName = [];
  String _joblevelName = "";
  String _localeLanguageApi = "";

  bool _isValidateValue = false;
  String _formattedValue = '';

  setValueGetById() {
    final NumberFormat formatter = NumberFormat('#,##0');
    setState(() {
      dynamic i = widget.workPreference;
      _workPosition = i['currentJobTitle'];
      _workPositionController.text = _workPosition;

      _salary = i['salary'].toString();
      _salaryController.text = formatter.format(int.parse(_salary));

      _currency = i['currency'];
      _selectedJobLevel = i['jobLevelId']['_id'];
      _joblevelName = i['jobLevelId']['name'];
      _professionalSummary = i['professionalSummary'];

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
      _selectedIndustriesListItem = i['industryId'];
      String mapIndustry =
          _selectedIndustriesListItem.map((i) => i['_id']).join(',');
      _selectedIndustriesListItem = mapIndustry.split(',');
      //
      //Industry Name
      _industryName = i['industryId'];
      String mapIndustryName = _industryName.map((i) => i['name']).join(',');
      _industryName = mapIndustryName.split(',');

      //
      //Benefit Id
      _selectedBenefitsListItem = i['benefitsId'];
      String mapBenefit =
          _selectedBenefitsListItem.map((b) => b['_id']).join(',');
      _selectedBenefitsListItem = mapBenefit.split(',');
      //
      //Benefit Name
      _benefitName = i['benefitsId'];
      String mapBenefitName = _benefitName.map((b) => b['name']).join(',');
      _benefitName = mapBenefitName.split(',');

      //
      //Job Function Id(selectedItem id)
      _selectedJobFunctionsItems = i['jobFunctionId'];
      _selectedJobFunctionsItems =
          _selectedJobFunctionsItems.map((e) => e['_id'].toString()).toList();
      // String mapJobFunctionId =
      //     _selectedJobFunctionsItems.map((j) => j['_id']).join(',');
      // _selectedJobFunctionsItems = mapJobFunctionId.split(',');
      //
      //Job Function Name(seletedItem name)
      _jobFunctionItemName = i['jobFunctionId'];
      String mapJobFunctionItemName =
          _jobFunctionItemName.map((j) => j['name']).join(',');
      _jobFunctionItemName = mapJobFunctionItemName.split(',');

      try {
        final json = jsonDecode(_professionalSummary);
        _quillController.document = Document.fromJson(json);
      } catch (e) {
        // Handle the decoding error (e.g., print an error message)
        print('Error decoding JSON: $e');
      }
    });
  }

  getSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    var getLanguageSharePref = prefs.getString('setLanguage');
    var getLanguageApiSharePref = prefs.getString('setLanguageApi');
    // print("local " + getLanguageSharePref.toString());
    // print("api " + getLanguageApiSharePref.toString());

    setState(() {
      _localeLanguageApi = getLanguageApiSharePref.toString();
    });

    getReuseTypeSeeker(_localeLanguageApi, 'JobLevel', _listJobLevels);
    getReuseTypeSeeker(_localeLanguageApi, 'Province', _listProvinces);
    getReuseTypeSeeker(_localeLanguageApi, 'Industry', _listIndustries);

    getBenefitsSeeker(_localeLanguageApi);
  }

  @override
  void initState() {
    super.initState();

    getSharedPreferences();
    getJobFunctionsSeeker();

    _id = widget.id ?? "";
    if (_id != null && _id != "") {
      print("id != null");
      print("${_id}");

      setValueGetById();
    }
    _workPositionController.text = _workPosition;
    _salaryController.text = _salary;
    // focusNode.addListener(() {
    //   setState(() {
    //     isToolBarVisible = focusNode.hasPrimaryFocus;
    //   });
    // });
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _currentFocus = FocusScope.of(context);
        if (!_currentFocus.hasPrimaryFocus) {
          _currentFocus.unfocus();
        }
      },
      child: MediaQuery(
        data:
            MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
        child: Scaffold(
          appBar: AppBarDefault(
            textTitle: "work preferences".tr,
            leadingIcon: Icon(Icons.arrow_back),
            leadingPress: () {
              Navigator.pop(context);
            },
          ),
          body: SafeArea(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: AppColors.backgroundWhite,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    Expanded(
                      flex: 15,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),

                            //
                            //
                            //
                            //
                            //
                            //Expected Work Position
                            Text(
                              "position".tr,
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SimpleTextFieldWithIconRight(
                              textController: _workPositionController,
                              changed: (value) {
                                setState(() {
                                  _workPosition = value;
                                });
                              },
                              inputColor: AppColors.inputWhite,
                              hintText: "enter".tr + " " + "position".tr,
                              hintTextFontWeight: FontWeight.bold,
                              suffixIcon: Icon(
                                Icons.keyboard,
                              ),
                              suffixIconColor: AppColors.iconGrayOpacity,
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //
                            //
                            // Text(
                            //   'Formatted Value: $_formattedValue',
                            //   style: TextStyle(fontSize: 20.0),
                            // ),
                            // TextField(
                            //   controller: _controller,
                            //   keyboardType: TextInputType.number,
                            //   decoration: InputDecoration(
                            //     labelText: 'Enter a number',
                            //   ),
                            //   onChanged: (value) {
                            //     setState(() {
                            //       // Parse the input value as an integer
                            //       int inputValue = int.tryParse(value) ?? 0;
                            //       print(inputValue);
                            //       // Format the integer value with commas
                            //       _formattedValue =
                            //           NumberFormat.decimalPattern()
                            //               .format(inputValue);
                            //       print(_formattedValue);
                            //     });
                            //   },
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
                            //Expected Salary
                            Text(
                              "salary".tr,
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),

                            SimpleTextFieldSingleValidate(
                              codeController: _salaryController,
                              changed: (value) {
                                // String cleanedString =
                                //     value.replaceAll(",", "");
                                // dynamic valDouble = cleanedString;
                                // MoneyFormatter fmf =
                                //     MoneyFormatter(amount: valDouble);
                                setState(() {
                                  // _salary = fmf.output.withoutFractionDigits;
                                  _salary = value;
                                });
                              },
                              // heightCon: 12.5.w,

                              keyboardType: TextInputType.number,
                              // keyboardType: TextInputType.numberWithOptions(
                              //     decimal: true),
                              inputFormat: [ThousandsSeparatorInputFormatter()],
                              inputColor: AppColors.inputWhite,
                              hintText: "0",
                              hintTextFontWeight: FontWeight.bold,
                              suffixIcon: Container(
                                // margin: EdgeInsets.only(right: 1),
                                width: 150,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: AppColors.greyOpacity,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(1.w),
                                    bottomRight: Radius.circular(1.w),
                                  ),
                                  border: Border.all(
                                    color: AppColors.greyOpacity,
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomCurrency(context, _currency);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (_currency == r"$")
                                            Text(
                                              "usd".tr + "/" + "month".tr,
                                              style: bodyTextNormal(null, null),
                                            ),
                                          if (_currency == "₭")
                                            Text(
                                              "kip".tr + "/" + "month".tr,
                                              style: bodyTextNormal(null, null),
                                            ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          FaIcon(
                                            FontAwesomeIcons.caretDown,
                                            color: AppColors.iconDark,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value == "") {
                                  return "required".tr;
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //
                            //
                            //
                            //Job Level
                            Text(
                              "job level".tr,
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),

                            BoxDecorationInput(
                              mainAxisAlignmentTextIcon:
                                  MainAxisAlignment.start,
                              colorInput: AppColors.backgroundWhite,
                              colorBorder: _selectedJobLevel == "" &&
                                      _isValidateValue == true
                                  ? AppColors.borderDanger
                                  : AppColors.borderSecondary,
                              paddingFaIcon:
                                  EdgeInsets.symmetric(horizontal: 1.7.w),
                              fontWeight: _selectedJobLevel != ""
                                  ? null
                                  : FontWeight.bold,
                              widgetIconActive: FaIcon(
                                FontAwesomeIcons.caretDown,
                                color: AppColors.iconGrayOpacity,
                                size: IconSize.sIcon,
                              ),
                              press: () async {
                                FocusScope.of(context).requestFocus(focusNode);

                                var result = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return ListSingleSelectedAlertDialog(
                                        title: "job level".tr,
                                        listItems: _listJobLevels,
                                        selectedListItem: _selectedJobLevel,
                                      );
                                    }).then(
                                  (value) {
                                    //value = "_id"
                                    //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                    setState(() {
                                      if (value != "") {
                                        //
                                        //ເອົາ _listJobLevels ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                                        dynamic findValue =
                                            _listJobLevels.firstWhere(
                                                (i) => i["_id"] == value);

                                        setState(() {
                                          _selectedJobLevel = findValue['_id'];
                                          _joblevelName = findValue['name'];
                                        });
                                        print(_joblevelName);
                                      }
                                    });
                                  },
                                );
                              },
                              text: _selectedJobLevel != ""
                                  ? "${_joblevelName}"
                                  : "select".tr + "job level".tr,
                              colorText: _selectedJobLevel == ""
                                  ? AppColors.fontGreyOpacity
                                  : AppColors.fontDark,
                              validateText: _isValidateValue == true &&
                                      _selectedJobLevel == ""
                                  ? Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        top: 5,
                                      ),
                                      child: Text(
                                        "required".tr,
                                        style: bodyTextSmall(
                                          AppColors.fontDanger,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //
                            //
                            //
                            //Job Function
                            Text(
                              "job function".tr,
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),

                            BoxDecorationInput(
                              mainAxisAlignmentTextIcon:
                                  MainAxisAlignment.start,
                              colorInput: AppColors.backgroundWhite,
                              colorBorder: _selectedJobFunctionsItems.isEmpty &&
                                      _isValidateValue == true
                                  ? AppColors.borderDanger
                                  : AppColors.borderSecondary,
                              paddingFaIcon:
                                  EdgeInsets.symmetric(horizontal: 1.7.w),
                              fontWeight: _selectedJobFunctionsItems.isEmpty
                                  ? FontWeight.bold
                                  : null,
                              widgetIconActive: FaIcon(
                                FontAwesomeIcons.caretDown,
                                color: AppColors.iconGrayOpacity,
                                size: IconSize.sIcon,
                              ),
                              press: () async {
                                FocusScope.of(context).requestFocus(focusNode);

                                var result = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return ListJobFuncSelectedAlertDialog(
                                        title: "job function".tr,
                                        listItems: _listJobFunctions,
                                        selectedListItems:
                                            _selectedJobFunctionsItems,
                                      );
                                    }).then(
                                  (value) {
                                    print(value);
                                    setState(() {
                                      _selectedJobFunctionsItems = value;
                                      List pName = [];
                                      List chName = [];

                                      //value = [_selectedListItemsChilds]
                                      //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                      if (value != null) {
                                        print("value != null");
                                        _selectedJobFunctionsItems = value;
                                        _jobFunctionItemName =
                                            []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                        for (var pItem in _listJobFunctions) {
                                          //
                                          //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedJobFunctionsItems ກົງກັບ _listJobFunctions ບໍ່
                                          if (_selectedJobFunctionsItems
                                              .contains(pItem["_id"])) {
                                            setState(() {
                                              _jobFunctionItemName
                                                  .add(pItem["name"]);
                                            });
                                          }
                                          for (var chItem in pItem["item"]) {
                                            if (_selectedJobFunctionsItems
                                                .contains(chItem["_id"])) {
                                              setState(() {
                                                _jobFunctionItemName
                                                    .add(chItem["name"]);
                                              });
                                            }
                                          }
                                        }

                                        // print(pName);
                                        // print(chName);
                                        print(_jobFunctionItemName);
                                      }
                                    });
                                  },
                                );
                              },
                              text: _selectedJobFunctionsItems.isNotEmpty
                                  ? "${_jobFunctionItemName.join(', ')}"
                                  : "select".tr + " " + "job function".tr,
                              colorText: _selectedJobFunctionsItems.isEmpty
                                  ? AppColors.fontGreyOpacity
                                  : AppColors.fontDark,
                              validateText: _isValidateValue == true &&
                                      _selectedJobFunctionsItems.isEmpty
                                  ? Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        top: 5,
                                      ),
                                      child: Text(
                                        "required".tr,
                                        style: bodyTextSmall(
                                          AppColors.fontDanger,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //
                            //
                            //
                            //Expected Work Provinces
                            Text(
                              "province".tr,
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxDecorationInput(
                              mainAxisAlignmentTextIcon:
                                  MainAxisAlignment.start,
                              colorInput: AppColors.backgroundWhite,
                              colorBorder: _selectedProvincesListItem.isEmpty &&
                                      _isValidateValue == true
                                  ? AppColors.borderDanger
                                  : AppColors.borderSecondary,
                              paddingFaIcon:
                                  EdgeInsets.symmetric(horizontal: 1.7.w),
                              fontWeight: _selectedProvincesListItem.isEmpty
                                  ? FontWeight.bold
                                  : null,
                              widgetIconActive: FaIcon(
                                FontAwesomeIcons.caretDown,
                                color: AppColors.iconGrayOpacity,
                                size: IconSize.sIcon,
                              ),
                              press: () async {
                                FocusScope.of(context).requestFocus(focusNode);

                                var result = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return ListMultiSelectedAlertDialog(
                                        title: "province".tr,
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
                                        _selectedProvincesListItem = value;
                                        _provinceName =
                                            []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                        for (var item in _listProvinces) {
                                          //
                                          //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedProvincesListItem ກົງກັບ _listProvinces ບໍ່
                                          if (_selectedProvincesListItem
                                              .contains(item['_id'])) {
                                            //
                                            //add Provinces Name ເຂົ້າໃນ _provinceName
                                            setState(() {
                                              _provinceName.add(item['name']);
                                            });
                                          }
                                        }
                                        print(_provinceName);
                                      }
                                    });
                                  },
                                );
                              },
                              text: _selectedProvincesListItem.isEmpty
                                  ? "province".tr
                                  : "${_provinceName.join(', ')}",
                              colorText: _selectedProvincesListItem.isEmpty
                                  ? AppColors.fontGreyOpacity
                                  : AppColors.fontDark,
                              validateText: _isValidateValue == true &&
                                      _selectedProvincesListItem.isEmpty
                                  ? Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        top: 5,
                                      ),
                                      child: Text(
                                        "required".tr,
                                        style: bodyTextSmall(
                                          AppColors.fontDanger,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //
                            //
                            //
                            //Expected Work Industry
                            Text(
                              "industry".tr,
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxDecorationInput(
                              mainAxisAlignmentTextIcon:
                                  MainAxisAlignment.start,
                              colorInput: AppColors.backgroundWhite,
                              colorBorder:
                                  _selectedIndustriesListItem.isEmpty &&
                                          _isValidateValue == true
                                      ? AppColors.borderDanger
                                      : AppColors.borderSecondary,
                              paddingFaIcon:
                                  EdgeInsets.symmetric(horizontal: 1.7.w),
                              fontWeight: _selectedIndustriesListItem.isEmpty
                                  ? FontWeight.bold
                                  : null,
                              widgetIconActive: FaIcon(
                                FontAwesomeIcons.caretDown,
                                color: AppColors.iconGrayOpacity,
                                size: IconSize.sIcon,
                              ),
                              press: () async {
                                FocusScope.of(context).requestFocus(focusNode);

                                var result = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return ListMultiSelectedAlertDialog(
                                        title: "industry".tr,
                                        listItems: _listIndustries,
                                        selectedListItem:
                                            _selectedIndustriesListItem,
                                      );
                                    }).then(
                                  (value) {
                                    setState(() {
                                      print(value);
                                      //value = []
                                      //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                      if (value.length > 0) {
                                        _selectedIndustriesListItem = value;
                                        _industryName =
                                            []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                        for (var item in _listIndustries) {
                                          //
                                          //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedIndustriesListItem ກົງກັບ _listIndustries ບໍ່
                                          if (_selectedIndustriesListItem
                                              .contains(item['_id'])) {
                                            //
                                            //add Provinces Name ເຂົ້າໃນ _industryName
                                            setState(() {
                                              _industryName.add(item['name']);
                                            });
                                          }
                                        }
                                        print(_industryName);
                                      }
                                    });
                                  },
                                );
                              },
                              text: _selectedIndustriesListItem.isEmpty
                                  ? "select".tr + " " + "industry".tr
                                  : "${_industryName.join(', ')}",
                              colorText: _selectedIndustriesListItem.isEmpty
                                  ? AppColors.fontGreyOpacity
                                  : AppColors.fontDark,
                              validateText: _isValidateValue == true &&
                                      _selectedIndustriesListItem.isEmpty
                                  ? Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        top: 5,
                                      ),
                                      child: Text(
                                        "required".tr,
                                        style: bodyTextSmall(
                                          AppColors.fontDanger,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //
                            //
                            //Expected Benefits
                            Text(
                              "benefit".tr,
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxDecorationInput(
                              mainAxisAlignmentTextIcon:
                                  MainAxisAlignment.start,
                              colorInput: AppColors.backgroundWhite,
                              colorBorder: _selectedBenefitsListItem.isEmpty &&
                                      _isValidateValue == true
                                  ? AppColors.borderDanger
                                  : AppColors.borderSecondary,
                              paddingFaIcon:
                                  EdgeInsets.symmetric(horizontal: 1.7.w),
                              fontWeight: _selectedBenefitsListItem.isEmpty
                                  ? FontWeight.bold
                                  : null,
                              widgetIconActive: FaIcon(
                                FontAwesomeIcons.caretDown,
                                color: AppColors.iconGrayOpacity,
                                size: IconSize.sIcon,
                              ),
                              press: () async {
                                FocusScope.of(context).requestFocus(focusNode);

                                var result = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return BoxIconMultiSelectedAlertDialog(
                                        title: "benefit".tr,
                                        listItems: _listBenefits,
                                        selectedListItem:
                                            _selectedBenefitsListItem,
                                      );
                                    }).then(
                                  (value) {
                                    //value = []
                                    //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                    setState(() {
                                      if (value.length > 0) {
                                        _selectedBenefitsListItem = value;
                                        _benefitName =
                                            []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                        for (var item in _listBenefits) {
                                          //
                                          //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedBenefitsListItem ກົງກັບ _listIndustries ບໍ່
                                          if (_selectedBenefitsListItem
                                              .contains(item['_id'])) {
                                            //
                                            //add Provinces Name ເຂົ້າໃນ _benefitName
                                            setState(() {
                                              _benefitName.add(item['name']);
                                            });
                                          }
                                        }
                                        print(_benefitName);
                                      }
                                    });
                                  },
                                );
                              },
                              text: _selectedBenefitsListItem.isEmpty
                                  ? "select".tr + " " + "benefit".tr
                                  : "${_benefitName.join(', ')}",
                              colorText: _selectedBenefitsListItem.isEmpty
                                  ? AppColors.fontGreyOpacity
                                  : AppColors.fontDark,
                              validateText: _isValidateValue == true &&
                                      _selectedBenefitsListItem.isEmpty
                                  ? Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        top: 5,
                                      ),
                                      child: Text(
                                        "required".tr,
                                        style: bodyTextSmall(
                                          AppColors.fontDanger,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            // Text("${_professionalSummary}"),
                            // Text(jsonEncode(_quillController.document
                            //         .toDelta()
                            //         .toJson())
                            //     .toString()),

                            //
                            //
                            //Professional Summary
                            Text(
                              "professional summary".tr,
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // SimpleTextFieldSingleValidate(
                            //   codeController: _professionalSummaryController,
                            //   heightCon: 250,
                            //   maxLines: 20,
                            //   inputColor: AppColors.backgroundWhite,
                            //   changed: (value) {
                            //     setState(() {
                            //       _professionalSummary = value;
                            //     });
                            //   },
                            //   hintText: "tell about you".tr,
                            //   hintTextFontWeight: FontWeight.bold,
                            //   validator: (value) {
                            //     if (value == null || value == "") {
                            //       return "required".tr;
                            //     }
                            //     return null;
                            //   },
                            // ),

                            Container(
                              width: double.infinity,
                              color: AppColors.background,
                              child: QuillToolbar.simple(
                                configurations:
                                    QuillSimpleToolbarConfigurations(
                                  controller: _quillController,
                                  toolbarIconAlignment: WrapAlignment.start,
                                  toolbarSectionSpacing: 0,
                                  showFontFamily: false,
                                  showFontSize: false,
                                  showHeaderStyle: false,
                                  showAlignmentButtons: false,
                                  showBackgroundColorButton: false,
                                  showClipboardCopy: false,
                                  showClipboardCut: false,
                                  showClipboardPaste: false,
                                  showColorButton: false,
                                  showCodeBlock: false,
                                  showDirection: false,
                                  showQuote: false,
                                  showUndo: false,
                                  showSuperscript: false,
                                  showLeftAlignment: false,
                                  showRedo: false,
                                  showRightAlignment: false,
                                  showSearchButton: false,
                                  showJustifyAlignment: false,
                                  showLineHeightButton: false,
                                  showSubscript: false,
                                  showCenterAlignment: false,
                                  showInlineCode: false,
                                  showSmallButton: false,
                                  // showClearFormat: false,
                                  showIndent: false,
                                  showListCheck: false,
                                  showDividers: false,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  )),
                              child: QuillEditor.basic(
                                focusNode: editorFocusNode,
                                configurations: QuillEditorConfigurations(
                                  keyboardAppearance: Brightness.dark,
                                  // requestKeyboardFocusOnCheckListChanged: true,
                                  controller: _quillController,

                                  scrollPhysics: ClampingScrollPhysics(),
                                  readOnlyMouseCursor: SystemMouseCursors.text,
                                  maxHeight: 400,
                                  minHeight: 400,
                                  placeholder: "professional summary".tr,
                                  padding: EdgeInsets.all(10),
                                  dialogTheme: QuillDialogTheme(
                                    labelTextStyle:
                                        TextStyle(color: AppColors.fontPrimary),
                                    buttonStyle: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                        AppColors.red,
                                      ),
                                    ),
                                  ),
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
                    SizedBox(
                      height: 10,
                    ),

                    //
                    //
                    //
                    //
                    //Button Save
                    Button(
                      text: "save".tr,
                      fontWeight: FontWeight.bold,
                      press: () {
                        if (formkey.currentState!.validate()) {
                          print("for check formkey.currentState!.validate()");
                          if (_selectedJobLevel == "" ||
                              _selectedJobFunctionsItems.isEmpty ||
                              _selectedProvincesListItem.isEmpty ||
                              _selectedIndustriesListItem.isEmpty ||
                              _selectedBenefitsListItem.isEmpty) {
                            setState(() {
                              _isValidateValue = true;
                            });
                          } else {
                            print("success validate form");
                            addWorkPreference();
                          }
                        } else {
                          print("invalid validate form");

                          if (_selectedJobLevel == "" ||
                              _selectedJobFunctionsItems.isEmpty ||
                              _selectedProvincesListItem.isEmpty ||
                              _selectedIndustriesListItem.isEmpty ||
                              _selectedBenefitsListItem.isEmpty) {
                            setState(() {
                              _isValidateValue = true;
                            });
                          }
                        }
                      },
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
      ),
    );
  }

  getReuseTypeSeeker(String lang, String type, List listValue) async {
    var res =
        await fetchData(getReuseTypeApiSeeker + "lang=${lang}&type=${type}");
    setState(() {
      listValue.clear(); // Clear the existing list
      listValue.addAll(res['seekerReuse']); // Add elements from the response
    });
  }

  getBenefitsSeeker(String lang) async {
    var res = await fetchData(benefitsSeekerApi + "lang=${lang}");
    _listBenefits = res['benefits'];

    setState(() {});
  }

  getJobFunctionsSeeker() async {
    var res = await fetchData(getJobFunctionsSeekerApi);
    _listJobFunctions = res['mapper'];
    setState(() {});
  }

  addWorkPreference() async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertLoading();
      },
    );

    int numberWithoutCommas = int.parse(_salary.split(',').join(''));
    _salary = numberWithoutCommas.toString();

    var res = await postData(addWorkPreferenceSeekerApi, {
      "currentJobTitle": _workPosition,
      "currency": _currency.toString(),
      "expectedSalary": _salary,
      "jobLevelId": _selectedJobLevel,
      "jobFunctionId": _selectedJobFunctionsItems,
      "industryId": _selectedIndustriesListItem,
      "benefitsId": _selectedBenefitsListItem,
      "provinceId": _selectedProvincesListItem,
      "professionalSummary":
          jsonEncode(_quillController.document.toDelta().toJson())
    });
    print(res);

    if (res['workPreference'] != null) {
      Navigator.pop(context);
    }

    if (res['workPreference'] != null) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomAlertDialogSuccessButtonConfirm(
            title: "successful".tr,
            text: "save".tr + " " + "job level".tr + " " + "successful".tr,
            textButton: "ok".tr,
            press: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

//
//
//Show Modal Bottom Currency LAK, BAHT, USD
  showModalBottomCurrency(BuildContext context, dynamic currency) async {
    await showModalBottomSheet(
      backgroundColor: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(20),
          //   topRight: Radius.circular(20),
          // ),
          ),
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      context: context,
      builder: (context) {
        // print(currency);

        return StatefulBuilder(builder: (context, setState) {
          return Container(
            width: double.infinity,
            height: 95.h,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(currency);
                        },
                        child: FaIcon(FontAwesomeIcons.arrowLeft),
                      ),
                      Text(
                        "Currency",
                        style: bodyTextMedium(null, FontWeight.bold),
                      ),
                      Text("")
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currency = "₭";
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "LAK(Lao kip)",
                          style: bodyTextNormal(
                              currency == "₭" ? AppColors.fontPrimary : null,
                              FontWeight.bold),
                        ),
                        FaIcon(
                          FontAwesomeIcons.kipSign,
                          size: 20,
                          color: currency == "₭"
                              ? AppColors.iconPrimary
                              : AppColors.iconDark,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currency = r"$";
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "USD(US Dollar)",
                          style: bodyTextNormal(
                              currency == r"$" ? AppColors.fontPrimary : null,
                              FontWeight.bold),
                        ),
                        FaIcon(
                          FontAwesomeIcons.dollarSign,
                          size: 20,
                          color: currency == r"$"
                              ? AppColors.iconPrimary
                              : AppColors.iconDark,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          );
        });
      },
    ).then((value) {
      setState(() {
        _currency = value;
      });
    });
  }
}

// DropdownButtonMenu(
//   inputColor: AppColors.backgroundWhite,
//   hintTextFontWeight: FontWeight.bold,
//   hintText: 'Select Benefits',
//   onChanged: (i) {
//     setState(() {
//       _benefit = i;
//     });
//   },
//   value: _benefit,
//   items: _listBenefits
//       .map(
//         (i) => DropdownMenuItem(
//           value: i['_id'].toString(),
//           child: Text(
//             i['name'],
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       )
//       .toList(),
//   validator: (value) => value == null || value == ""
//       ? "required"
//       : null,
// ),

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##0');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove any existing commas
    String newText = newValue.text.replaceAll(',', '');

    // Parse the input as a number
    final num? value = num.tryParse(newText);
    if (value == null) {
      return oldValue;
    }

    // Format the number with commas
    final String formattedText = _formatter.format(value);

    // Calculate the new cursor position
    int selectionIndex =
        formattedText.length - (newValue.text.length - newValue.selection.end);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
