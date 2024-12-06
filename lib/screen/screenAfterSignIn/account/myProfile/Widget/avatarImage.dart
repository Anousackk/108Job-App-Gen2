// ignore_for_file: prefer_final_fields, unused_field, prefer_const_constructors, avoid_unnecessary_containers, avoid_print, sized_box_for_whitespace

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoxDecAvatarImage extends StatefulWidget {
  const BoxDecAvatarImage({
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
  State<BoxDecAvatarImage> createState() => _BoxDecAvatarImageState();
}

class _BoxDecAvatarImageState extends State<BoxDecAvatarImage> {
  String _selectedString = "";

  @override
  Widget build(BuildContext context) {
    setState(() {
      _selectedString = widget.selectedListItem;
    });
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,

        //
        //
        //Title
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          // color: AppColors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  height: 70,
                  width: 70,
                  color: AppColors.iconLight.withOpacity(0.1),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(100),
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
              ),
              Text(
                widget.title,
                style: bodyTextMedium("NotoSansLaoLoopedBold", null, null),
              ),
              Container(
                height: 70,
                width: 70,
              )
            ],
          ),
        ),

        //
        //
        //Content
        content: Container(
          color: AppColors.backgroundWhite,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
            physics: ClampingScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            padding: const EdgeInsets.all(20.0),
            children: widget.listItems.map((src) {
              return GestureDetector(
                onTap: () {
                  print(src['_id'].toString());
                  setState(() {
                    _selectedString = src['_id'];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: _selectedString == src['_id']
                        ? Border.all(color: AppColors.cyan500, width: 5)
                        : Border.all(
                            color: AppColors.borderWhite.withOpacity(0.1),
                            width: 5,
                          ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      "${src["src"]}",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print(error);
                        return Image.asset(
                          'assets/image/no-image-available.png',
                          fit: BoxFit.cover,
                        ); // Display an error message
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        //
        //
        //Action
        actions: [
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Button(
                  buttonColor: AppColors.primary200,
                  text: "confirm".tr,
                  textFontFamily: "NotoSansLaoLoopedMedium",
                  textColor: AppColors.primary600,
                  press: () {
                    Navigator.of(context).pop(["Confirm", _selectedString]);
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          )
        ],
      );
    });
  }
}
