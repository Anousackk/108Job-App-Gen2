// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unused_local_variable, avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_is_empty

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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

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
  String _salary = "";
  String _currency = "₭";
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

  bool _isValidateValue = false;

  TextEditingController _controller = TextEditingController();
  String _formattedValue = '';

  setValueGetById() {
    setState(() {
      dynamic i = widget.workPreference;
      _workPosition = i['currentJobTitle'];
      _salary = i['salary'].toString();
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

      _workPositionController.text = _workPosition;
      _salaryController.text = _salary;
      _professionalSummaryController.text = _professionalSummary;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _salaryController.addListener(_formatSalary);

    getReuseTypeSeeker('EN', 'JobLevel', _listJobLevels);
    getReuseTypeSeeker('EN', 'Province', _listProvinces);
    getReuseTypeSeeker('EN', 'Industry', _listIndustries);

    getBenefitsSeeker('EN');
    getJobFunctionsSeeker();

    _id = widget.id ?? "";
    if (_id != null && _id != "") {
      print("id != null");
      print("${_id}");

      setValueGetById();
    }

    _workPositionController.text = _workPosition;
    // _salaryController.text = _salary;
    _professionalSummaryController.text = _professionalSummary;
  }

  @override
  void dispose() {
    _salaryController.removeListener(_formatSalary);
    _salaryController.dispose();
    super.dispose();
  }

  void _formatSalary() {
    final value = _salaryController.text.replaceAll(',', ''); // Remove commas
    final numericRegex = RegExp(r'^\d+(\.\d+)?$');
    if (numericRegex.hasMatch(value)) {
      final formattedValue =
          NumberFormat('#,##0').format(int.tryParse(value) ?? 0);
      _salaryController.value = TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScopeNode();

    return GestureDetector(
      onTap: () {
        currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MediaQuery(
        data:
            MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
        child: Scaffold(
          appBar: AppBarDefault(
            textTitle: "Work Preferences",
            fontWeight: FontWeight.bold,
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
                            //Expected Work Position
                            Text(
                              "Expected Work Position",
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
                              hintText: "Enter Work Position",
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
                            //Expected Salary
                            Text(
                              "Expected Salary",
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SimpleTextFieldSingleValidate(
                              codeController: _salaryController,
                              changed: (value) {
                                setState(() {
                                  _salary = value;
                                });

                                print(_salary);
                              },
                              // heightCon: 12.5.w,
                              keyboardType: TextInputType.number,
                              inputColor: AppColors.inputWhite,
                              hintText: "0",
                              hintTextFontWeight: FontWeight.bold,
                              suffixIcon: Container(
                                width: 150,
                                height: 13.w,
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
                                              "USD/Month",
                                              style: bodyTextNormal(null, null),
                                            ),
                                          if (_currency == "₭")
                                            Text(
                                              "Kip/Month",
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
                                  return "required";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //Job Level
                            Text(
                              "Job Level",
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
                                var result = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return ListSingleSelectedAlertDialog(
                                        title: "Job Level",
                                        listItems: _listJobLevels,
                                        selectedListItem: _selectedJobLevel,
                                      );
                                    }).then(
                                  (value) {
                                    //value = "_id"
                                    //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                    if (value != "") {
                                      //
                                      //ເອົາ _listJobLevels ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                                      dynamic findValue = _listJobLevels
                                          .firstWhere((i) => i["_id"] == value);

                                      setState(() {
                                        _selectedJobLevel = findValue['_id'];
                                        _joblevelName = findValue['name'];
                                      });
                                      print(_joblevelName);
                                    }
                                  },
                                );
                              },
                              text: _selectedJobLevel != ""
                                  ? "${_joblevelName}"
                                  : "Select Job Level",
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
                                        "required",
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
                            //Job Function
                            Text(
                              "Job Functions",
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
                                var result = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return ListJobFuncSelectedAlertDialog(
                                        title: "Job Functions",
                                        listItems: _listJobFunctions,
                                        selectedListItems:
                                            _selectedJobFunctionsItems,
                                      );
                                    }).then(
                                  (value) {
                                    print(value);
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
                                  },
                                );
                              },
                              text: _selectedJobFunctionsItems.isNotEmpty
                                  ? "${_jobFunctionItemName.join(', ')}"
                                  : "Select Job Function",
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
                                        "required",
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
                            //Expected Work Provinces
                            Text(
                              "Expected Work Provinces",
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
                                var result = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return ListMultiSelectedAlertDialog(
                                        title: "Work Province",
                                        listItems: _listProvinces,
                                        selectedListItem:
                                            _selectedProvincesListItem,
                                      );
                                    }).then(
                                  (value) {
                                    print(value);
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
                                  },
                                );
                              },
                              text: _selectedProvincesListItem.isEmpty
                                  ? "Work Province"
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
                                        "required",
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
                            //Expected Work Industry
                            Text(
                              "Expected Work Industry",
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
                                var result = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return ListMultiSelectedAlertDialog(
                                        title: "Industry",
                                        listItems: _listIndustries,
                                        selectedListItem:
                                            _selectedIndustriesListItem,
                                      );
                                    }).then(
                                  (value) {
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
                                  },
                                );
                              },
                              text: _selectedIndustriesListItem.isEmpty
                                  ? "Select Industry"
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
                                        "required",
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
                            //Expected Benefits
                            Text(
                              "Expected Benefits",
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
                                var result = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return BoxIconMultiSelectedAlertDialog(
                                        title: "Benefit",
                                        listItems: _listBenefits,
                                        selectedListItem:
                                            _selectedBenefitsListItem,
                                      );
                                    }).then(
                                  (value) {
                                    //value = []
                                    //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
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
                                  },
                                );
                              },
                              text: _selectedBenefitsListItem.isEmpty
                                  ? "Select Benefit"
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
                                        "required",
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
                            //Professional Summary
                            Text(
                              "Professional Summary",
                              style: bodyTextNormal(null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SimpleTextFieldSingleValidate(
                              codeController: _professionalSummaryController,
                              heightCon: 250,
                              maxLines: 20,
                              inputColor: AppColors.backgroundWhite,
                              changed: (value) {
                                setState(() {
                                  _professionalSummary = value;
                                });
                              },
                              hintText: "Tell us more about you",
                              hintTextFontWeight: FontWeight.bold,
                              validator: (value) {
                                if (value == null || value == "") {
                                  return "required";
                                }
                                return null;
                              },
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
                    //Button Save
                    Button(
                      text: "Save",
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
      "expectedSalary": int.parse(_salary),
      "jobLevelId": _selectedJobLevel,
      "jobFunctionId": _selectedJobFunctionsItems,
      "industryId": _selectedIndustriesListItem,
      "benefitsId": _selectedBenefitsListItem,
      "provinceId": _selectedProvincesListItem,
      "professionalSummary": _professionalSummary
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
          return CustomAlertDialogSuccess(
            title: "Success",
            text: "Save Job Level Success",
            textButton: "OK",
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