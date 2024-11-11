// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, unused_local_variable, prefer_if_null_operators, avoid_print, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, avoid_unnecessary_containers

import 'dart:async';

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/appbar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:app/widget/listSingleSelectedAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class Skill extends StatefulWidget {
  const Skill({Key? key, this.id, this.skill}) : super(key: key);
  final String? id;
  final dynamic skill;

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
  List _listSkillLevel = [];
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

  getSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    var getLanguageSharePref = prefs.getString('setLanguage');
    var getLanguageApiSharePref = prefs.getString('setLanguageApi');
    // print("local " + getLanguageSharePref.toString());
    // print("api " + getLanguageApiSharePref.toString());

    setState(() {
      _localeLanguageApi = getLanguageApiSharePref.toString();
    });

    getReuseTypeSeeker(_localeLanguageApi, 'SkillLevel', _listSkillLevel);
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferences();

    _id = widget.id ?? "";
    if (_id != null && _id != "") {
      print("id != null");
      print("${_id}");

      setValueGetById();
      // getKeySkillSeeker(_skill);
    }

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
            textTitle: "skill".tr,
            // fontWeight: FontWeight.bold,
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
                            //Skill
                            Text(
                              "skill".tr,
                              style:
                                  bodyTextNormal(null, null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
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
                              hintText: "enter".tr + " " + "skill".tr,
                              hintTextFontWeight: FontWeight.bold,
                              suffixIcon: Icon(
                                Icons.keyboard,
                              ),
                              suffixIconColor: AppColors.iconGrayOpacity,
                            ),

                            //
                            //
                            //
                            //
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 10),
                                              child: Container(
                                                  // child: Text("Loading"),
                                                  ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                  child:
                                                      Text('no have data'.tr)),
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

                            SizedBox(
                              height: 20,
                            ),

                            //
                            //
                            //
                            //
                            //
                            //
                            //Proficiency Skill / Skill level
                            Text(
                              "proficiency".tr,
                              style:
                                  bodyTextNormal(null, null, FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BoxDecorationInput(
                              mainAxisAlignmentTextIcon:
                                  MainAxisAlignment.start,
                              colorInput: AppColors.backgroundWhite,
                              colorBorder: _selectedSkillLevel == "" &&
                                      _isValidateValue == true
                                  ? AppColors.borderDanger
                                  : AppColors.borderSecondary,
                              paddingFaIcon:
                                  EdgeInsets.symmetric(horizontal: 1.7.w),
                              fontWeight: _selectedSkillLevel == ""
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
                                      return ListSingleSelectedAlertDialog(
                                        title: "proficiency".tr,
                                        listItems: _listSkillLevel,
                                        selectedListItem: _selectedSkillLevel,
                                      );
                                    }).then(
                                  (value) {
                                    //value = "_id"
                                    //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                    if (value != "") {
                                      //
                                      //ເອົາ _listSkillLevel ມາຊອກຫາວ່າມີຄ່າກົງກັບຄ່າທີ່ສົ່ງຄືນກັບມາບໍ່?
                                      dynamic findValue = _listSkillLevel
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
                              validateText: _isValidateValue == true &&
                                      _selectedSkillLevel == ""
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
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Button(
                      text: "save".tr,
                      fontWeight: FontWeight.bold,
                      press: () {
                        FocusScope.of(context).requestFocus(focusNode);
                        if (formkey.currentState!.validate()) {
                          print("personal information success");
                          if (_selectedSkillLevel == "") {
                            setState(() {
                              _isValidateValue = true;
                            });
                          } else {
                            addSkill();
                          }
                        } else {
                          print("invalid validate form");
                          if (_selectedSkillLevel == "") {
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
      listValue.clear();
      listValue.addAll(res['seekerReuse']);
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
    if (_listKeySkill.length >= totals || fetchKeySkill.length < perPage) {
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

  addSkill() async {
    //
    //ສະແດງ AlertDialog Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustAlertLoading();
      },
    );
    var res = await postData(addSkillSeekerApi, {
      "_id": _id,
      "keySkill": _skill,
      "skillLevelId": _selectedSkillLevel,
    });

    print(res);

    if (res['skills'] != null) {
      Navigator.pop(context);
    }

    if (res['skills'] != null) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return NewVer2CustAlertDialogSuccessBtnConfirm(
            title: "save".tr + " " + "successful".tr,
            contentText: "save".tr + " " + "skill".tr + "successful".tr,
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
}
