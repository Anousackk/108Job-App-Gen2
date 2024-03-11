// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, unnecessary_brace_in_string_interps

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/boxDecorationIcon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

class BoxIconSingleSelectedAlertDialog extends StatefulWidget {
  const BoxIconSingleSelectedAlertDialog({
    Key? key,
    required this.listItems,
    required this.selectedListItem,
    required this.title,
    this.crossAxisCount,
  }) : super(key: key);

  final String title;
  final List listItems;
  final String selectedListItem;
  final int? crossAxisCount;

  @override
  State<BoxIconSingleSelectedAlertDialog> createState() =>
      _BoxIconSingleSelectedAlertDialogState();
}

class _BoxIconSingleSelectedAlertDialogState
    extends State<BoxIconSingleSelectedAlertDialog> {
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
                    Navigator.of(context).pop(_selectedString);
                  },
                  child: FaIcon(FontAwesomeIcons.arrowLeft),
                ),
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: AppColors.backgroundWhite,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GridView.count(
              crossAxisCount:
                  widget.crossAxisCount ?? 3, // Number of columns in the grid
              children: List.generate(
                widget.listItems.length,
                (index) {
                  dynamic i = widget.listItems[index];
                  String name = i['name'];
                  String image = "";
                  if (i.containsKey('image')) {
                    image = i['image'];
                  }
                  return BoxDecorationImageAndText(
                    press: () {
                      setState(() {
                        _selectedString = i['_id'];
                      });
                    },
                    height: 28.w,
                    width: 28.w,
                    imageType: '',
                    borderColor: _selectedString == i['_id']
                        ? AppColors.borderPrimary
                        : AppColors.borderWhite,
                    imageStr: "${image}",
                    text: name,
                    textColor: _selectedString == i['_id']
                        ? AppColors.fontPrimary
                        : null,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
