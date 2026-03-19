// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unused_local_variable, avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_is_empty, unused_element, file_names, prefer_adjacent_string_concatenation, use_build_context_synchronously, prefer_interpolation_to_compose_strings, deprecated_member_use

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/provider/profileProvider.dart';
import 'package:app/provider/reuseTypeProvider.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/WorkPreference/Widget/listImageTextMultiSelectedAlertDialog.dart';
import 'package:app/widget/appbar.dart';
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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_quill/flutter_quill.dart';

class WorkPreferences extends StatefulWidget {
  const WorkPreferences(
      {Key? key,
      this.id,
      this.workPreference,
      this.pressButtonLeft,
      this.onSaveSuccess})
      : super(key: key);
  final String? id;
  final dynamic workPreference;
  final Function()? pressButtonLeft, onSaveSuccess;

  @override
  State<WorkPreferences> createState() => _WorkPreferencesState();
}

class _WorkPreferencesState extends State<WorkPreferences> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _workPositionController = TextEditingController();

  TextEditingController _salaryController = TextEditingController();
  QuillController _quillController = QuillController.basic();
  FocusScopeNode _currentFocus = FocusScopeNode();
  FocusNode focusNode = FocusNode();
  FocusNode editorFocusNode = FocusNode();

  bool isToolBarVisible = true;

  //
  //Get list items all

  List _listJobFunctionsItem = [];

  //
  //Selected list item(ສະເພາະເຂົ້າ Database)
  String? _id;
  String _workPosition = "";
  String _currency = "₭";
  String _salary = "";
  // String _selectedJobLevel = "";
  // String _selectedJobFunctions = "";
  // List _selectedJobFunctionsItems = [];
  List _selectedIndustriesListItem = [];
  // List _selectedBenefitsListItem = [];
  List _selectedProvincesListItem = [];

  //
  //value display(ສະເພາະສະແດງ)
  // List _jobFunctionItemName = [];
  List _industryName = [];
  // List _benefitName = [];
  // String _joblevelName = "";
  List _provinceName = [];
  String _localeLanguageApi = "";

  bool _isValidateValue = false;
  String _formattedValue = '';

  setValueGetById() {
    final NumberFormat formatter = NumberFormat('#,##0');
    setState(() {
      dynamic i = widget.workPreference;
      _workPosition = i['currentJobTitle'];
      _workPositionController.text = _workPosition;

      _salary = i['salary'] == "" ? "0" : i['salary'].toString();
      _salaryController.text = formatter.format(int.parse(_salary));

      _currency = i['currency'] == "" ? "₭" : i['currency'];
      // _selectedJobLevel = i['jobLevelId']['_id'];
      // _joblevelName = i['jobLevelId']['name'];

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

      // Industry Name
      _industryName = i['industryId'];
      String mapIndustryName = _industryName.map((i) => i['name']).join(',');
      _industryName = mapIndustryName.split(',');

      //
      //Benefit Id
      // _selectedBenefitsListItem = i['benefitsId'];
      // String mapBenefit =
      //     _selectedBenefitsListItem.map((b) => b['_id']).join(',');
      // _selectedBenefitsListItem = mapBenefit.split(',');
      //
      //Benefit Name
      // _benefitName = i['benefitsId'];
      // String mapBenefitName = _benefitName.map((b) => b['name']).join(',');
      // _benefitName = mapBenefitName.split(',');

      //
      //Job Function Id(selectedItem id)
      // _selectedJobFunctionsItems = i['jobFunctionId'];
      // _selectedJobFunctionsItems =
      //     _selectedJobFunctionsItems.map((e) => e['_id'].toString()).toList();
      // String mapJobFunctionId =
      //     _selectedJobFunctionsItems.map((j) => j['_id']).join(',');
      // _selectedJobFunctionsItems = mapJobFunctionId.split(',');
      //
      //Job Function Name(seletedItem name)
      // _jobFunctionItemName = i['jobFunctionId'];
      // String mapJobFunctionItemName =
      //     _jobFunctionItemName.map((j) => j['name']).join(',');
      // _jobFunctionItemName = mapJobFunctionItemName.split(',');
    });
  }

  addWorkPreference() async {
    final profileProvider = context.read<ProfileProvider>();

    // Display AlertDialog Loading First
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    int numberWithoutCommas = int.parse(_salary.split(',').join(''));
    _salary = numberWithoutCommas.toString();

    final res = await profileProvider.addWorkPreference(
      _workPosition,
      _currency.toString(),
      _salary,
      //  _selectedJobLevel,
      // _selectedJobFunctionsItems,
      // _selectedBenefitsListItem,
      _selectedIndustriesListItem,
      _selectedProvincesListItem,
      profileProvider.statusEventUpdateProfile,
    );
    final statusCode = res?["statusCode"];

    if (!context.mounted) return;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    if (statusCode == 200 || statusCode == 201) {
      await profileProvider.fetchProfileSeeker();

      // Call parent callback
      if (!context.mounted) return;
      widget.onSaveSuccess?.call();
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CustAlertDialogErrorWithoutBtn(
            title: "incorrect".tr,
            text: "incorrect".tr,
          );
        },
      );
    }
  }

  checkByIdDisplayFormUpdate() {
    //Check by _id ເພື່ອເອົາຂໍ້ມູນມາອັບເດດ
    _id = widget.id ?? "";
    if (_id != null && _id != "") {
      print("workPreferenceId != null");

      setValueGetById();
    }
  }

  @override
  void initState() {
    super.initState();
    checkByIdDisplayFormUpdate();

    _workPositionController.text = _workPosition;
    _salaryController.text = _salary;
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final reuseTypeProvider = context.watch<ReuseTypeProvider>();

    return GestureDetector(
      onTap: () {
        _currentFocus = FocusScope.of(context);
        if (!_currentFocus.hasPrimaryFocus) {
          _currentFocus.unfocus();
        }
      },
      child: Container(
        // height: double.infinity,
        // width: double.infinity,
        color: AppColors.backgroundWhite,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            //
            //
            //Section
            //Form WorkPreferences
            Form(
              key: formkey,
              child: Column(
                children: [
                  //
                  //
                  //Section
                  //Content WorkPreferences
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        //
                        //Expected Work Position
                        Text(
                          "position".tr,
                          style: bodyTextNormal(null, null, FontWeight.bold),
                        ),
                        SizedBox(height: 5),

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
                        SizedBox(height: 20),

                        //
                        //
                        //Expected Salary
                        Text(
                          "salary".tr,
                          style: bodyTextNormal(null, null, FontWeight.bold),
                        ),
                        SizedBox(height: 5),

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
                            width: 100,
                            height: 55,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(1.w),
                                bottomRight: Radius.circular(1.w),
                              ),
                              // border: Border.all(
                              //   color: AppColors.greyOpacity,
                              // ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomCurrency(context, _currency);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_currency == r"$")
                                        Text(
                                          "usd".tr,
                                          style: bodyTextNormal(
                                              null, AppColors.fontWhite, null),
                                        ),
                                      if (_currency == "₭")
                                        Text(
                                          "lak".tr,
                                          style: bodyTextNormal(
                                              null, AppColors.fontWhite, null),
                                        ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.caretDown,
                                        color: AppColors.iconLight,
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
                        SizedBox(height: 20),

                        //Job Level
                        // Text(
                        //   "job level".tr,
                        //   style: bodyTextNormal(null, null, FontWeight.bold),
                        // ),
                        // SizedBox(height: 5),
                        // BoxDecorationInput(
                        //   mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                        //   colorInput: AppColors.backgroundWhite,
                        //   colorBorder: _selectedJobLevel == "" &&
                        //           _isValidateValue == true
                        //       ? AppColors.borderDanger
                        //       : AppColors.borderSecondary,
                        //   paddingFaIcon:
                        //       EdgeInsets.symmetric(horizontal: 1.7.w),
                        //   fontWeight:
                        //       _selectedJobLevel != "" ? null : FontWeight.bold,
                        //   widgetIconActive: FaIcon(
                        //     FontAwesomeIcons.caretDown,
                        //     color: AppColors.iconGrayOpacity,
                        //     size: IconSize.sIcon,
                        //   ),
                        //   press: () async {
                        //     FocusScope.of(context).requestFocus(focusNode);
                        //     var result = await showDialog(
                        //         barrierDismissible: false,
                        //         context: context,
                        //         builder: (context) {
                        //           return ListSingleSelectedAlertDialog(
                        //             title: "job level".tr,
                        //             listItems: reuseTypeProvider.listJobLevel,
                        //             selectedListItem: _selectedJobLevel,
                        //           );
                        //         }).then(
                        //       (value) {
                        //         //value = "_id"
                        //         //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                        //         setState(() {
                        //           if (value != "") {
                        //             //
                        //             //ເອົາ _listJobLevels ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                        //             dynamic findValue = reuseTypeProvider
                        //                 .listJobLevel
                        //                 .firstWhere((i) => i["_id"] == value);
                        //             setState(() {
                        //               _selectedJobLevel = findValue['_id'];
                        //               _joblevelName = findValue['name'];
                        //             });
                        //             print(_joblevelName);
                        //           }
                        //         });
                        //       },
                        //     );
                        //   },
                        //   text: _selectedJobLevel != ""
                        //       ? "${_joblevelName}"
                        //       : "select".tr + "job level".tr,
                        //   colorText: _selectedJobLevel == ""
                        //       ? AppColors.fontGreyOpacity
                        //       : AppColors.fontDark,
                        //   validateText: _isValidateValue == true &&
                        //           _selectedJobLevel == ""
                        //       ? Container(
                        //           width: double.infinity,
                        //           padding: EdgeInsets.only(
                        //             left: 15,
                        //             top: 5,
                        //           ),
                        //           child: Text(
                        //             "required".tr,
                        //             style: bodyTextSmall(
                        //                 null, AppColors.fontDanger, null),
                        //           ),
                        //         )
                        //       : Container(),
                        // ),
                        // SizedBox(height: 20),

                        //Job Function
                        // Text(
                        //   "job function".tr,
                        //   style: bodyTextNormal(null, null, FontWeight.bold),
                        // ),
                        // SizedBox(height: 5),
                        // BoxDecorationInput(
                        //   mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                        //   colorInput: AppColors.backgroundWhite,
                        //   colorBorder: _selectedJobFunctionsItems.isEmpty &&
                        //           _isValidateValue == true
                        //       ? AppColors.borderDanger
                        //       : AppColors.borderSecondary,
                        //   paddingFaIcon:
                        //       EdgeInsets.symmetric(horizontal: 1.7.w),
                        //   fontWeight: _selectedJobFunctionsItems.isEmpty
                        //       ? FontWeight.bold
                        //       : null,
                        //   widgetIconActive: FaIcon(
                        //     FontAwesomeIcons.caretDown,
                        //     color: AppColors.iconGrayOpacity,
                        //     size: IconSize.sIcon,
                        //   ),
                        //   press: () async {
                        //     FocusScope.of(context).requestFocus(focusNode);
                        //     var result = await showDialog(
                        //         barrierDismissible: false,
                        //         context: context,
                        //         builder: (context) {
                        //           return ListJobFuncSelectedAlertDialog(
                        //             title: "job function".tr,
                        //             listItems: profileProvider.listJobFunction,
                        //             selectedListItems:
                        //                 _selectedJobFunctionsItems,
                        //           );
                        //         }).then(
                        //       (value) {
                        //         print(value);
                        //         setState(() {
                        //           _selectedJobFunctionsItems = value;
                        //           List pName = [];
                        //           List chName = [];
                        //           //value = [_selectedListItemsChilds]
                        //           //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                        //           if (value != null) {
                        //             print("value != null");
                        //             _selectedJobFunctionsItems = value;
                        //             _jobFunctionItemName =
                        //                 []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້
                        //             for (var pItem
                        //                 in profileProvider.listJobFunction) {
                        //               //
                        //               //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedJobFunctionsItems ກົງກັບ _listJobFunctions ບໍ່
                        //               if (_selectedJobFunctionsItems
                        //                   .contains(pItem["_id"])) {
                        //                 setState(() {
                        //                   _jobFunctionItemName
                        //                       .add(pItem["name"]);
                        //                 });
                        //               }
                        //               for (var chItem in pItem["item"]) {
                        //                 if (_selectedJobFunctionsItems
                        //                     .contains(chItem["_id"])) {
                        //                   setState(() {
                        //                     _jobFunctionItemName
                        //                         .add(chItem["name"]);
                        //                   });
                        //                 }
                        //               }
                        //             }
                        //           }
                        //         });
                        //       },
                        //     );
                        //   },
                        //   text: _selectedJobFunctionsItems.isNotEmpty
                        //       ? "${_jobFunctionItemName.join(', ')}"
                        //       : "select".tr + " " + "job function".tr,
                        //   colorText: _selectedJobFunctionsItems.isEmpty
                        //       ? AppColors.fontGreyOpacity
                        //       : AppColors.fontDark,
                        //   validateText: _isValidateValue == true &&
                        //           _selectedJobFunctionsItems.isEmpty
                        //       ? Container(
                        //           width: double.infinity,
                        //           padding: EdgeInsets.only(
                        //             left: 15,
                        //             top: 5,
                        //           ),
                        //           child: Text(
                        //             "required".tr,
                        //             style: bodyTextSmall(
                        //                 null, AppColors.fontDanger, null),
                        //           ),
                        //         )
                        //       : Container(),
                        // ),
                        // SizedBox(height: 20),

                        //
                        //
                        //Expected Work Provinces
                        Text(
                          "province".tr,
                          style: bodyTextNormal(null, null, FontWeight.bold),
                        ),
                        SizedBox(height: 5),

                        BoxDecorationInput(
                          mainAxisAlignmentTextIcon: MainAxisAlignment.start,
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
                                    listItems: reuseTypeProvider.listProvince,
                                    selectedListItem:
                                        _selectedProvincesListItem,
                                  );
                                }).then(
                              (value) {
                                print("${value}");
                                setState(() {
                                  //value = []
                                  //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                  if (value != null && value.length > 0) {
                                    _selectedProvincesListItem = value;
                                    _provinceName =
                                        []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                    for (var item
                                        in reuseTypeProvider.listProvince) {
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
                                        null, AppColors.fontDanger, null),
                                  ),
                                )
                              : Container(),
                        ),
                        SizedBox(height: 20),

                        //Expected Work Industry
                        Text(
                          "industry".tr,
                          style: bodyTextNormal(null, null, FontWeight.bold),
                        ),
                        SizedBox(height: 5),

                        BoxDecorationInput(
                          mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                          colorInput: AppColors.backgroundWhite,
                          colorBorder: _selectedIndustriesListItem.isEmpty &&
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
                                    listItems: reuseTypeProvider.listIndustry,
                                    selectedListItem:
                                        _selectedIndustriesListItem,
                                  );
                                }).then(
                              (value) {
                                setState(() {
                                  print(value);
                                  //value = []
                                  //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                  if (value != null && value.length > 0) {
                                    _selectedIndustriesListItem = value;
                                    _industryName =
                                        []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້
                                    for (var item
                                        in reuseTypeProvider.listIndustry) {
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
                                        null, AppColors.fontDanger, null),
                                  ),
                                )
                              : Container(),
                        ),
                        SizedBox(height: 20),

                        //Expected Benefits
                        // Text(
                        //   "benefit".tr,
                        //   style: bodyTextNormal(null, null, FontWeight.bold),
                        // ),
                        // SizedBox(height: 5),
                        // BoxDecorationInput(
                        //   mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                        //   colorInput: AppColors.backgroundWhite,
                        //   colorBorder: _selectedBenefitsListItem.isEmpty &&
                        //           _isValidateValue == true
                        //       ? AppColors.borderDanger
                        //       : AppColors.borderSecondary,
                        //   paddingFaIcon:
                        //       EdgeInsets.symmetric(horizontal: 1.7.w),
                        //   fontWeight: _selectedBenefitsListItem.isEmpty
                        //       ? FontWeight.bold
                        //       : null,
                        //   widgetIconActive: FaIcon(
                        //     FontAwesomeIcons.caretDown,
                        //     color: AppColors.iconGrayOpacity,
                        //     size: IconSize.sIcon,
                        //   ),
                        //   press: () async {
                        //     FocusScope.of(context).requestFocus(focusNode);
                        //     var result = await showDialog(
                        //         barrierDismissible: false,
                        //         context: context,
                        //         builder: (context) {
                        //           //ຮູບແບບ Box image text
                        //           // return BoxIconMultiSelectedAlertDialog(
                        //           //   title: "benefit".tr,
                        //           //   listItems: _listBenefits,
                        //           //   selectedListItem:
                        //           //       _selectedBenefitsListItem,
                        //           // );
                        //           return ListImageTextMultiSelectedAlertDialog(
                        //             title: "benefit".tr,
                        //             listItems: profileProvider.listBenefit,
                        //             selectedListItem: _selectedBenefitsListItem,
                        //           );
                        //         }).then(
                        //       (value) {
                        //         //value = []
                        //         //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                        //         setState(() {
                        //           if (value.length > 0) {
                        //             _selectedBenefitsListItem = value;
                        //             _benefitName =
                        //                 []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້
                        //             for (var item
                        //                 in profileProvider.listBenefit) {
                        //               //
                        //               //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedBenefitsListItem ກົງກັບ _listIndustries ບໍ່
                        //               if (_selectedBenefitsListItem
                        //                   .contains(item['_id'])) {
                        //                 //
                        //                 //add Provinces Name ເຂົ້າໃນ _benefitName
                        //                 setState(() {
                        //                   _benefitName.add(item['name']);
                        //                 });
                        //               }
                        //             }
                        //             print(_benefitName);
                        //           }
                        //         });
                        //       },
                        //     );
                        //   },
                        //   text: _selectedBenefitsListItem.isEmpty
                        //       ? "select".tr + " " + "benefit".tr
                        //       : "${_benefitName.join(', ')}",
                        //   colorText: _selectedBenefitsListItem.isEmpty
                        //       ? AppColors.fontGreyOpacity
                        //       : AppColors.fontDark,
                        //   validateText: _isValidateValue == true &&
                        //           _selectedBenefitsListItem.isEmpty
                        //       ? Container(
                        //           width: double.infinity,
                        //           padding: EdgeInsets.only(
                        //             left: 15,
                        //             top: 5,
                        //           ),
                        //           child: Text(
                        //             "required".tr,
                        //             style: bodyTextSmall(
                        //                 null, AppColors.fontDanger, null),
                        //           ),
                        //         )
                        //       : Container(),
                        // ),
                        // SizedBox(height: 20),

                        // SizedBox(height: 30),
                      ],
                    ),
                  ),

                  Divider(color: AppColors.borderGreyOpacity, thickness: 1),

                  //
                  //
                  //Section Button Save And Next
                  Row(
                    children: [
                      GestureDetector(
                        onTap: widget.pressButtonLeft,
                        child: Container(
                          color: AppColors.backgroundWhite,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Skip for now",
                            style: bodyTextNormal(
                                null, AppColors.fontGreyOpacity, null),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Button(
                            text: "save_and_next".tr,
                            textFontWeight: FontWeight.bold,
                            press: () {
                              FocusScope.of(context).requestFocus(focusNode);
                              if (formkey.currentState!.validate()) {
                                if (_selectedProvincesListItem.isEmpty ||
                                    _selectedIndustriesListItem.isEmpty) {
                                  setState(() {
                                    _isValidateValue = true;
                                  });
                                } else {
                                  print("success validate form");
                                  addWorkPreference();
                                }
                              } else {
                                print("invalid validate form");

                                if (_selectedProvincesListItem.isEmpty ||
                                    _selectedIndustriesListItem.isEmpty) {
                                  setState(() {
                                    _isValidateValue = true;
                                  });
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 20),
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
                        style: bodyTextMedium(null, null, FontWeight.bold),
                      ),
                      Text("")
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currency = "₭";
                          });
                        },
                        child: Container(
                          color: AppColors.backgroundWhite,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "LAK (Lao kip)",
                                style: bodyTextNormal(
                                    null,
                                    currency == "₭"
                                        ? AppColors.fontPrimary
                                        : null,
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
                          color: AppColors.backgroundWhite,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "USD (US Dollar)",
                                style: bodyTextNormal(
                                    null,
                                    currency == r"$"
                                        ? AppColors.fontPrimary
                                        : null,
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
                    ],
                  ),
                ),
                Button(
                  text: "confirm".tr,
                  textFontWeight: FontWeight.bold,
                  press: () {
                    Navigator.of(context).pop(currency);
                  },
                ),
                SizedBox(
                  height: 60,
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
