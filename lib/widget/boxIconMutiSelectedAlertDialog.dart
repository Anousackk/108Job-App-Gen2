// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, sized_box_for_whitespace, file_names, unnecessary_brace_in_string_interps

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/boxDecorationIcon.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoxIconMultiSelectedAlertDialog extends StatefulWidget {
  const BoxIconMultiSelectedAlertDialog({
    Key? key,
    required this.listItems,
    required this.selectedListItem,
    required this.title,
  }) : super(key: key);

  final String title;
  final List listItems;
  final List selectedListItem;

  @override
  State<BoxIconMultiSelectedAlertDialog> createState() =>
      _BoxIconMultiSelectedAlertDialogState();
}

class _BoxIconMultiSelectedAlertDialogState
    extends State<BoxIconMultiSelectedAlertDialog> {
  List _selectedArray = [];

  @override
  Widget build(BuildContext context) {
    setState(() {
      _selectedArray = widget.selectedListItem;
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
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.count(
                        physics: ClampingScrollPhysics(),
                        crossAxisCount: 2, // Number of columns in the grid
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
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
                                  //
                                  //ຖ້າໂຕທີ່ເລືອກ _id ກົງກັບ _selectedArray(_id) ແມ່ນລົບອອກ
                                  if (_selectedArray.contains(i['_id'])) {
                                    _selectedArray
                                        .removeWhere((e) => e == i['_id']);

                                    return;
                                  }

                                  //
                                  //ເອົາຂໍ້ມູນທີ່ເລືອກ Add ເຂົ້າໃນ Array _selectedArray
                                  _selectedArray.add(i['_id']);
                                });
                              },
                              // height: 150,
                              // width: 150,
                              imageType: 'imageNetwork',
                              borderColor: _selectedArray.contains(i['_id'])
                                  ? AppColors.borderPrimary
                                  : AppColors.borderWhite,
                              imageStr:
                                  "https://storage.googleapis.com/108-bucket/${image}",
                              text: name,
                              textColor: _selectedArray.contains(i['_id'])
                                  ? AppColors.fontPrimary
                                  : null,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Button(
                    text: "confirm".tr,
                    textFontWeight: FontWeight.bold,
                    press: () {
                      Navigator.of(context).pop(_selectedArray);
                    },
                  ),
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
