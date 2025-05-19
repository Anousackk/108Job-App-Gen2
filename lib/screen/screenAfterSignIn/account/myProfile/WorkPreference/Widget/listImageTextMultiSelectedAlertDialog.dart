// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, sized_box_for_whitespace, file_names, unnecessary_brace_in_string_interps, prefer_final_fields

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListImageTextMultiSelectedAlertDialog extends StatefulWidget {
  const ListImageTextMultiSelectedAlertDialog({
    Key? key,
    required this.listItems,
    required this.selectedListItem,
    required this.title,
  }) : super(key: key);

  final String title;
  final List listItems;
  final List selectedListItem;

  @override
  State<ListImageTextMultiSelectedAlertDialog> createState() =>
      _ListImageTextMultiSelectedAlertDialogState();
}

class _ListImageTextMultiSelectedAlertDialogState
    extends State<ListImageTextMultiSelectedAlertDialog> {
  ScrollController _scrollController = ScrollController();
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
                    child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: widget.listItems.length,
                        itemBuilder: (context, index) {
                          dynamic i = widget.listItems[index];
                          String name = i['name'];
                          String image = "";
                          if (i.containsKey('image')) {
                            image = i['image'] ?? "";
                          }
                          return GestureDetector(
                            onTap: () {
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
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _selectedArray.contains(i['_id'])
                                        ? AppColors.primary200
                                        : AppColors.dark100,
                                    borderRadius: BorderRadius.circular(10),
                                    // border: Border.all(
                                    //   color: _selectedArray.contains(i['_id'])
                                    //       ? AppColors.borderPrimary
                                    //       : AppColors.borderWhite,
                                    // ),
                                  ),
                                  child: Row(
                                    children: [
                                      //
                                      //
                                      //Logo image
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          // border: Border.all(
                                          //   color: AppColors.borderSecondary,
                                          // ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color:
                                              _selectedArray.contains(i['_id'])
                                                  ? AppColors.primary200
                                                  : AppColors.dark100,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: image == ""
                                                ? Image.asset(
                                                    'assets/image/108job-logo-text.png',
                                                    fit: BoxFit.contain,
                                                  )
                                                : Image.network(
                                                    "https://storage.googleapis.com/108-bucket/${image}",
                                                    fit: BoxFit.contain,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.asset(
                                                        'assets/image/108job-logo-text.png',
                                                        fit: BoxFit.contain,
                                                      ); // Display an error message
                                                    },
                                                  ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),

                                      //
                                      //
                                      //Content text
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${name}",
                                              style: bodyTextNormal(
                                                  null, null, FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: AppColors.backgroundWhite),
                                        child: Center(
                                          child: Text(
                                            _selectedArray.contains(i['_id'])
                                                ? "\uf00c"
                                                : "\uf068",
                                            style: fontAwesomeSolid(
                                                null,
                                                null,
                                                _selectedArray
                                                        .contains(i['_id'])
                                                    ? AppColors.primary400
                                                    : AppColors.dark400,
                                                null),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        }),

                    // child: Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: GridView.count(
                    //     physics: ClampingScrollPhysics(),
                    //     crossAxisCount: 2, // Number of columns in the grid
                    //     mainAxisSpacing: 20,
                    //     crossAxisSpacing: 20,
                    //     children: List.generate(
                    //       widget.listItems.length,
                    //       (index) {
                    //         dynamic i = widget.listItems[index];
                    //         String name = i['name'];
                    //         String image = "";
                    //         if (i.containsKey('image')) {
                    //           image = i['image'];
                    //         }
                    //         return BoxDecorationImageAndText(
                    //           press: () {
                    //             setState(() {
                    //               //
                    //               //ຖ້າໂຕທີ່ເລືອກ _id ກົງກັບ _selectedArray(_id) ແມ່ນລົບອອກ
                    //               if (_selectedArray.contains(i['_id'])) {
                    //                 _selectedArray
                    //                     .removeWhere((e) => e == i['_id']);
                    //                 return;
                    //               }
                    //               //
                    //               //ເອົາຂໍ້ມູນທີ່ເລືອກ Add ເຂົ້າໃນ Array _selectedArray
                    //               _selectedArray.add(i['_id']);
                    //             });
                    //           },
                    //           // height: 150,
                    //           // width: 150,
                    //           imageType: 'imageNetwork',
                    //           borderColor: _selectedArray.contains(i['_id'])
                    //               ? AppColors.borderPrimary
                    //               : AppColors.borderWhite,
                    //           imageStr:
                    //               "https://storage.googleapis.com/108-bucket/${image}",
                    //           text: name,
                    //           textColor: _selectedArray.contains(i['_id'])
                    //               ? AppColors.fontPrimary
                    //               : null,
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),
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
