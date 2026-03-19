// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_typing_uninitialized_variables, unused_local_variable, file_names, avoid_print, deprecated_member_use, prefer_final_fields, prefer_interpolation_to_compose_strings

import 'package:app/functions/colors.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListMultiSelectedAlertDialog extends StatefulWidget {
  const ListMultiSelectedAlertDialog({
    Key? key,
    required this.listItems,
    required this.selectedListItem,
    required this.title,
    this.status,
    this.codeController,
    this.changed,
  }) : super(key: key);

  final String title;
  final List listItems;
  final List selectedListItem;
  final status;
  final TextEditingController? codeController;
  final Function(String)? changed;

  @override
  State<ListMultiSelectedAlertDialog> createState() =>
      _ListMultiSelectedAlertDialogState();
}

class _ListMultiSelectedAlertDialogState
    extends State<ListMultiSelectedAlertDialog> {
  List _selectedArray = [];
  List _listItems = [];

  @override
  void initState() {
    super.initState();
    _selectedArray = [...widget.selectedListItem];
    _listItems = [...widget.listItems];
  }

  @override
  void didUpdateWidget(covariant ListMultiSelectedAlertDialog oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _listItems = [...widget.listItems];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,

      //
      //
      //Title
      title: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
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
                      style: fontAwesomeRegular(null, 20, null, null),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "${widget.title}",
              style: bodyTextMedium(null, null, FontWeight.bold),
            ),
            Container(
              height: 45,
              width: 45,
            )
          ],
        ),
      ),

      //
      //
      //Content Selection
      content: Container(
        color: AppColors.backgroundWhite,
        child: Column(
          children: [
            if (widget.status == "seekerHideCompany")
              //
              //
              //Search company name
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: SimpleTextFieldSingleValidate(
                  codeController: widget.codeController,
                  contenPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  enabledBorder: enableOutlineBorder(AppColors.borderBG),
                  changed: widget.changed,
                  hintText: "search".tr + " " + "company name".tr,
                  inputColor: AppColors.inputWhite,
                ),
              ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _listItems.length,
                    itemBuilder: (context, index) {
                      dynamic i = _listItems[index];
                      String name;

                      if (widget.status == "seekerHideCompany") {
                        name = i['companyName'];
                      } else {
                        name = i['name'];
                      }
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            final id = i['_id']?.toString() ?? "";

                            // ignore empty IDs
                            if (id.isEmpty) return;

                            if (_selectedArray.contains(id)) {
                              _selectedArray.removeWhere((e) => e == id);
                            } else {
                              _selectedArray.add(id);
                            }

                            // remove empty values for safety
                            _selectedArray
                                .removeWhere((e) => e.toString().isEmpty);

                            print(_selectedArray);
                          });
                          // setState(() {
                          //   //
                          //   //ຖ້າໂຕທີ່ເລືອກ _id ກົງກັບ _selectedArray(_id) ແມ່ນລົບອອກ
                          //   if (_selectedArray.contains(i['_id'])) {
                          //     _selectedArray
                          //         .removeWhere((e) => e == i['_id']);
                          //     print(_selectedArray);

                          //     return;
                          //   }
                          //   //
                          //   //ເອົາຂໍ້ມູນທີ່ເລືອກ Add ເຂົ້າໃນ Array _selectedArray
                          //   _selectedArray.add(i['_id']);
                          //   print(_selectedArray);
                          // });
                        },
                        child: Container(
                          color: AppColors.backgroundWhite,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          child: Row(
                            children: [
                              _selectedArray.contains(i['_id'])
                                  ? Icon(Icons.check_box,
                                      color: AppColors.iconPrimary)
                                  : Icon(Icons.check_box_outline_blank),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  '${name}',
                                  style: bodyTextNormal(
                                      null,
                                      _selectedArray.contains(i['_id'])
                                          ? AppColors.fontPrimary
                                          : null,
                                      FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              //
                              //_selectedArray.contains(i['_id']) // ໃຊ້ contains ກວດຄ່າ(_id)ທີ່ຢູ່ໃນ Array _selectedArray ວ່າຕົງກັນບໍ່
                              // if (_selectedArray.contains(i['_id']))
                              //   FaIcon(
                              //     FontAwesomeIcons.check,
                              //     color: AppColors.iconPrimary,
                              //   )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Button(
              text: "confirm".tr,
              textFontWeight: FontWeight.bold,
              press: () {
                Navigator.of(context).pop(_selectedArray);
              },
            ),
            SizedBox(
              height: 30,
            )
          ],
        )
      ],
    );
  }
}
