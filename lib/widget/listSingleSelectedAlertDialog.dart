// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, file_names

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListSingleSelectedAlertDialog extends StatefulWidget {
  const ListSingleSelectedAlertDialog({
    Key? key,
    required this.listItems,
    required this.selectedListItem,
    required this.title,
  }) : super(key: key);

  final String title;
  final List listItems;
  final String selectedListItem;

  @override
  State<ListSingleSelectedAlertDialog> createState() =>
      _ListSingleSelectedAlertDialogState();
}

class _ListSingleSelectedAlertDialogState
    extends State<ListSingleSelectedAlertDialog> {
  String _selectedString = "";

  @override
  Widget build(BuildContext context) {
    setState(() {
      _selectedString = widget.selectedListItem;
    });

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          // actionsPadding: EdgeInsets.zero,

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
                //     Navigator.of(context).pop(_selectedString);
                //   },
                //   child: FaIcon(FontAwesomeIcons.arrowLeft),
                // ),
                Text(
                  "${widget.title}",
                  style: bodyTextMedium(null, null, FontWeight.bold),
                ),
                Text("")
              ],
            ),
          ),

          //
          //
          //Content Selection
          content: Container(
            color: AppColors.backgroundWhite,
            padding: EdgeInsets.symmetric(horizontal: 20),
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

                          var name = i['name'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedString = i['_id'];
                              });
                            },
                            child: Container(
                              // color: AppColors.blue,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                children: [
                                  _selectedString == i['_id']
                                      ? Icon(
                                          Icons.radio_button_checked,
                                          color: AppColors.iconPrimary,
                                        )
                                      : Icon(Icons.radio_button_off),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${name}',
                                      style: bodyTextNormal(
                                          null,
                                          _selectedString == i['_id']
                                              ? AppColors.iconPrimary
                                              : null,
                                          FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
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
                  textFontWeight: FontWeight.bold,
                  press: () {
                    Navigator.of(context).pop(_selectedString);
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
