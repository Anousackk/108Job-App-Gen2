// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, unused_local_variable, prefer_if_null_operators, avoid_print, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, avoid_unnecessary_containers, sized_box_for_whitespace, use_build_context_synchronously

import 'dart:async';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/provider/localSharePrefsProvider.dart';
import 'package:app/provider/profileProvider.dart';
import 'package:app/provider/reuseTypeProvider.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:app/widget/listSingleSelectedAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class Skill extends StatefulWidget {
  const Skill(
      {Key? key,
      this.id,
      this.skill,
      this.pressButtonLeft,
      this.onSaveSuccess,
      this.onCancel})
      : super(key: key);
  final String? id;
  final dynamic skill;
  final Function()? pressButtonLeft, onSaveSuccess, onCancel;

  @override
  State<Skill> createState() => _SkillState();
}

class _SkillState extends State<Skill> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();
  TextEditingController _skillController = TextEditingController();
  FocusScopeNode _currentFocus = FocusScopeNode();
  FocusNode focusNode = FocusNode();

  //Get list items all
  // List _listSkillLevel = [];
  List _listKeySkill = [];

  //Selected list item(ສະເພາະເຂົ້າ Database)
  String? _id;
  String _skill = "";
  String _selectedSkillLevel = "";

  //value display(ສະເພາະສະແດງ)
  String _skillLevelName = "";
  String _localeLanguageApi = "";

  bool _isLoadingMoreData = false;
  bool _hasMoreData = true;

  dynamic page = 1;
  dynamic perPage = 5;
  dynamic totals;

  bool _isValidateValue = false;
  Timer? _timer;

  setValueGetById() {
    setState(() {
      dynamic i = widget.skill;

      _skill = i['name'];
      _selectedSkillLevel = i['skillLevelId']['_id'];
      _skillLevelName = i['skillLevelId']['name'];
      _skillController.text = _skill;
    });
  }

  getKeySkillSeeker(String searchVal) async {
    if (!_hasMoreData) {
      _isLoadingMoreData = false;
      return;
    }

    var res = await postData(getKeySkillSeekerApi, {
      "lang": _localeLanguageApi,
      "search": searchVal,
      "page": page,
      "perPage": perPage,
    });

    print(res);

    List fetchKeySkill = res['getKeySkill'];
    totals = res['totals'];

    page++;
    _listKeySkill.addAll(List<Map<String, dynamic>>.from(fetchKeySkill));
    if (_listKeySkill.length >= totals || fetchKeySkill.length == 0) {
      _hasMoreData = false;
    }
    _isLoadingMoreData = false;

    if (mounted) {
      setState(() {});
    }
    // setState(() {
    //   if (res['getKeySkill'] != null) {
    //     print("!=null");
    //     _listKeySkill = res['getKeySkill'];
    //   } else {
    //     _listKeySkill = [];
    //   }
    // });
  }

  pressAddSkill() async {
    final profileProvider = context.read<ProfileProvider>();

    // Display AlertDialog Loading First
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomLoadingLogoCircle();
      },
    );

    final res = await profileProvider.addSkill(
      _id,
      _skill,
      _selectedSkillLevel,
      profileProvider.statusEventUpdateProfile,
    );

    final statusCode = res?["statusCode"];

    if (!context.mounted) return;

    // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
    Navigator.pop(context);

    if (statusCode == 200 || statusCode == 201) {
      await profileProvider.fetchProfileSeeker();

      // Call parent callback
      if (widget.onSaveSuccess != null) {
        widget.onSaveSuccess!();
      }
    }
  }

  checkByIdDisplayFormUpdate() {
    //Check by _id ເພື່ອເອົາຂໍ້ມູນມາອັບເດດ
    _id = widget.id ?? "";
    if (_id != null && _id != "") {
      print("skillId + ${_id}");

      setValueGetById();
    }
  }

  @override
  void initState() {
    super.initState();

    checkByIdDisplayFormUpdate();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _isLoadingMoreData = true;
        });

        getKeySkillSeeker(_skill);
      }
    });

    _skillController.text = _skill;
  }

  @override
  void dispose() {
    _skillController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

        child: Form(
          key: formkey,
          child: Column(
            children: [
              //
              //
              //Section
              //Content skill
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    //
                    //Skill
                    Text(
                      "skills".tr,
                      style: bodyTextNormal(null, null, FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                    //
                    //
                    //Skill input
                    SimpleTextFieldWithIconRight(
                      textController: _skillController,
                      changed: (value) {
                        setState(() {
                          _skill = value;
                        });

                        // Cancel previous timer if it exists
                        _timer?.cancel();

                        // Start a new timer
                        _timer = Timer(Duration(milliseconds: 500), () {
                          // Perform API call here
                          print('Calling API Get KeySkill');
                          setState(() {
                            _listKeySkill.clear();
                            _hasMoreData = true;
                            page = 1;
                          });
                          getKeySkillSeeker(_skill);
                        });
                      },
                      inputColor: AppColors.inputWhite,
                      hintText: "enter".tr + " " + "skills".tr,
                      hintTextFontWeight: FontWeight.bold,
                      suffixIcon: Icon(
                        Icons.keyboard,
                      ),
                      suffixIconColor: AppColors.iconGrayOpacity,
                    ),

                    //
                    //
                    //show list keySkill if _listKeySkill is not empty
                    if (_listKeySkill.isNotEmpty)
                      Container(
                        height: totals > 5 ? 200 : null,
                        // height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics: totals > 5
                              ? ScrollPhysics()
                              : NeverScrollableScrollPhysics(),
                          itemCount: _listKeySkill.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _listKeySkill.length) {
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
                                          child: Text('no have data'.tr)),
                                    );
                            }
                            dynamic i = _listKeySkill[index];
                            String name = i['name'];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _skill = name;
                                  _skillController.text = _skill;

                                  _listKeySkill = [];
                                });
                                print("${_skill}");
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Text("${name}"),
                              ),
                            );
                          },
                        ),
                      ),
                    SizedBox(height: 20),

                    //
                    //
                    //Proficiency Skill / Skill level
                    Text(
                      "proficiency".tr,
                      style: bodyTextNormal(null, null, FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                    //
                    //
                    //Proficiency Skill / Skill level box select
                    BoxDecorationInput(
                      mainAxisAlignmentTextIcon: MainAxisAlignment.start,
                      colorInput: AppColors.backgroundWhite,
                      colorBorder:
                          _selectedSkillLevel == "" && _isValidateValue == true
                              ? AppColors.borderDanger
                              : AppColors.borderSecondary,
                      paddingFaIcon: EdgeInsets.symmetric(horizontal: 1.7.w),
                      fontWeight:
                          _selectedSkillLevel == "" ? FontWeight.bold : null,
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
                                title: "proficiency".tr,
                                listItems: reuseTypeProvider.listSkillLevel,
                                selectedListItem: _selectedSkillLevel,
                              );
                            }).then(
                          (value) {
                            //value = "_id"
                            //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                            if (value != "") {
                              //
                              //ເອົາ _listSkillLevel ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                              dynamic findValue = reuseTypeProvider
                                  .listSkillLevel
                                  .firstWhere((i) => i["_id"] == value);

                              setState(() {
                                _selectedSkillLevel = findValue['_id'];
                                _skillLevelName = findValue['name'];
                              });

                              print(_skillLevelName);
                            }
                          },
                        );
                      },
                      text: _selectedSkillLevel != ""
                          ? "${_skillLevelName}"
                          : "select".tr + " " + "proficiency".tr,
                      colorText: _selectedSkillLevel == ""
                          ? AppColors.fontGreyOpacity
                          : AppColors.fontDark,
                      validateText:
                          _isValidateValue == true && _selectedSkillLevel == ""
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
                  ],
                ),
              ),

              Divider(color: AppColors.borderGreyOpacity, thickness: 1),

              //
              //
              //Section Button Cancel And Save
              Row(
                children: [
                  // Button Cancel
                  Expanded(
                    child: Button(
                      text: "cancel".tr,
                      textColor: AppColors.fontDark,
                      buttonColor: AppColors.buttonBG,
                      press: widget.onCancel,
                    ),
                  ),

                  Expanded(child: Container()),

                  // Button Save And Next
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Button(
                        text: "save".tr,
                        textFontWeight: FontWeight.bold,
                        press: () {
                          FocusScope.of(context).requestFocus(focusNode);
                          if (formkey.currentState!.validate()) {
                            if (_selectedSkillLevel == "") {
                              setState(() {
                                _isValidateValue = true;
                              });
                            } else {
                              setState(() {
                                _isValidateValue = false;
                              });
                              pressAddSkill();
                            }
                          } else {
                            print("invalid validate form");
                            setState(() {
                              _isValidateValue = true;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
