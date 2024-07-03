// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_typing_uninitialized_variables, unused_local_variable, file_names, avoid_print

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListMultiSelectedAlertDialog extends StatefulWidget {
  const ListMultiSelectedAlertDialog({
    Key? key,
    required this.listItems,
    required this.selectedListItem,
    required this.title,
    this.status,
  }) : super(key: key);

  final String title;
  final List listItems;
  final List selectedListItem;
  final status;

  @override
  State<ListMultiSelectedAlertDialog> createState() =>
      _ListMultiSelectedAlertDialogState();
}

class _ListMultiSelectedAlertDialogState
    extends State<ListMultiSelectedAlertDialog> {
  List _selectedArray = [];

  @override
  Widget build(BuildContext context) {
    setState(() {
      _selectedArray = widget.selectedListItem;

      print(_selectedArray);
    });

    return StatefulBuilder(
      builder: (context, setState) {
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // GestureDetector(
                //   onTap: () {
                //     Navigator.of(context).pop(_selectedArray);
                //   },
                //   child: FaIcon(FontAwesomeIcons.arrowLeft),
                // ),
                Text(
                  "${widget.title}",
                  style: bodyTextMedium(null, FontWeight.bold),
                ),
                Text("")
              ],
            ),
          ),

          //
          //
          //Content Selection
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            color: AppColors.backgroundWhite,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.listItems.length,
                        itemBuilder: (context, index) {
                          dynamic i = widget.listItems[index];
                          String name;
                          if (widget.status == "seekerHideCompany") {
                            name = i['companyName'];
                          } else {
                            name = i['name'];
                          }
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                //
                                //ຖ້າໂຕທີ່ເລືອກ _id ກົງກັບ _selectedArray(_id) ແມ່ນລົບອອກ
                                if (_selectedArray.contains(i['_id'])) {
                                  _selectedArray
                                      .removeWhere((e) => e == i['_id']);
                                  print(_selectedArray);

                                  return;
                                }
                                //
                                //ເອົາຂໍ້ມູນທີ່ເລືອກ Add ເຂົ້າໃນ Array _selectedArray
                                _selectedArray.add(i['_id']);
                                print(_selectedArray);
                              });
                            },
                            child: Container(
                              // color: AppColors.blue,
                              padding: EdgeInsets.symmetric(vertical: 15),
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
                SizedBox(
                  height: 20,
                ),
                Button(
                  text: "confirm".tr,
                  fontWeight: FontWeight.bold,
                  press: () {
                    Navigator.of(context).pop(_selectedArray);
                  },
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
