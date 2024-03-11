// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unused_local_variable, prefer_final_fields, unused_field, avoid_unnecessary_containers, avoid_print, prefer_typing_uninitialized_variables

import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListJobFuncSelectedAlertDialog extends StatefulWidget {
  const ListJobFuncSelectedAlertDialog({
    Key? key,
    required this.title,
    required this.listItems,
    required this.selectedListItems,
  }) : super(key: key);

  final String title;
  final List listItems;
  final List selectedListItems;

  @override
  State<ListJobFuncSelectedAlertDialog> createState() =>
      _ListJobFuncSelectedAlertDialogState();
}

class _ListJobFuncSelectedAlertDialogState
    extends State<ListJobFuncSelectedAlertDialog> {
  List _listItemsParents = [];
  String _selectedStrItemsParentName = "";
  String _selectedStrItemsParentId = "";
  dynamic _countListItemsChilds;

  List _listItemsChilds = [];
  List _selectedListItemsChilds = [];
  int _countSelectedListItemsChilds = 0;

  List _onPressItem = [];
  List eiei = [];
  List _selectedIndex = [-1];

  dynamic _isSlideListVisible;
  dynamic _isCheckStatusCheckBox = false;

  handleTap(value) {
    setState(() {
      value = [];
    });
  }

  @override
  void initState() {
    super.initState();

    _listItemsParents = widget.listItems;
    _selectedListItemsChilds = widget.selectedListItems;

    if (_selectedListItemsChilds.isNotEmpty) {
      for (int idx = 0; idx < _listItemsParents.length; idx++) {
        if (_selectedListItemsChilds.contains(_listItemsParents[idx]['_id'])) {
          _selectedIndex.add(idx);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   _listItems = widget.listItems;
    //   _selectedItem = widget.selectedListItems;
    // });

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          // backgroundColor: AppColors.backgroundWhite,

          //
          //
          //Title
          title: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(_selectedListItemsChilds);

                    //
                    //When popping the Navigator, make sure _selectedItem is not empty
                    // if (_selectedListItemsChilds.isNotEmpty) {
                    //   Navigator.of(context).pop(_selectedListItemsChilds);
                    // } else {
                    //   print("No _selectedListItemChilds");
                    //   Navigator.of(context).pop();
                    // }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    // color: AppColors.blue,
                    child: FaIcon(
                      FontAwesomeIcons.arrowLeft,
                      size: IconSize.mIcon,
                    ),
                  ),
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
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text("selecteList: ${_selectedListItemsChilds}"),
                Text("selectedIndex: ${_selectedIndex}"),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: AppColors.backgroundWhite,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _listItemsParents.length,
                    itemBuilder: (context, index) {
                      dynamic i = _listItemsParents[index];
                      String name = i['name'];
                      _countListItemsChilds = i['count'];

                      return Column(
                        children: [
                          //
                          //ໜ້າສະແດງ ListView Parents
                          //press i['isCheck'] = true for slide to Childs design
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // _selectedStrItemsParentId = i['_id'];
                                // _selectedStrItemsParentName = i['name'];
                                _listItemsChilds = i['item'];

                                if (_selectedIndex.contains(index)) {
                                  print("text a");
                                  if (!i['isCheck']) {
                                    print("show slide");
                                    i['isCheck'] = true;
                                    // return;
                                  } else {
                                    print("hide slide");
                                    i['isCheck'] = false;
                                    if (i['item'].every((mb) =>
                                        _selectedListItemsChilds
                                            .contains(mb['_id']))) {
                                      print("hide slide every");
                                      i['isCheck'] = false;
                                    } else {
                                      print("hide slide remove");

                                      _selectedIndex.remove(index);
                                    }
                                  }
                                } else if (!_selectedIndex.contains(index)) {
                                  print("text b");
                                  i['isCheck'] = true;
                                  _selectedIndex.add(index);
                                }

                                // if (_selectedListItemsChilds
                                //     .contains(i['_id'])) {
                                //   return;
                                // }
                                //
                                //ເອົາຂໍ້ມູນທີ່ເລືອກ(press) add ເຂົ້າໃນ array
                                // _selectedListItemsChilds.add(i['_id']);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                children: [
                                  //
                                  //
                                  //checkbox Parents
                                  //pree list addAll item
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _listItemsChilds = i['item'];
                                        print(_listItemsChilds);

                                        if (!i['isCheck']) {
                                          print("check slided false");
                                          if (_selectedIndex.contains(index)) {
                                            print("check a to remove");
                                            _selectedIndex.remove(index);
                                          } else {
                                            print("check b to add");
                                            _selectedIndex.add(index);
                                          }
                                        }

                                        //
                                        //ຖ້າວ່າ _selectedListItemsChilds ມີຄ່າຂອງ i['item'] ທັງໝົດແມ່ນໃຫ້ເຮັດເງື່ອນໄຂຕໍ່ໄປ
                                        if (i['item'].every((cx) =>
                                            _selectedListItemsChilds
                                                .contains(cx["_id"]))) {
                                          print(
                                              "i['item'] every in _selectedListItemsChilds");
                                          //
                                          //ຖ້າໂຕທີ່ເລືອກ _id ກົງກັບ _selectedListItemsChilds(_id) ແມ່ນລົບອອກ
                                          if (_selectedListItemsChilds
                                              .contains(i['_id'])) {
                                            _selectedListItemsChilds
                                                .removeWhere(
                                              (e) => e == i['_id'],
                                            );

                                            //
                                            //ເອົາ _selectedListItemsChilds ມາກວດວ່າມີ _id ກົງກັບ item ບໍ່? ຖ້າມີໃຫ້ເລົບອອກທັງໝົດ
                                            for (int parentId = 0;
                                                parentId <
                                                    _listItemsChilds.length;
                                                parentId++) {
                                              final String idToRemove =
                                                  _listItemsChilds[parentId]
                                                      ['_id'];

                                              for (int childId = 0;
                                                  childId <
                                                      _selectedListItemsChilds
                                                          .length;
                                                  childId++) {
                                                if (_selectedListItemsChilds
                                                    .contains(idToRemove)) {
                                                  _selectedListItemsChilds
                                                      .removeWhere((el) =>
                                                          el == idToRemove);
                                                }
                                              }
                                            }
                                            return;
                                          }
                                        } else {
                                          print(
                                              "i['item'] some value in _selectedListItemsChilds");

                                          if (_selectedListItemsChilds
                                              .contains(i['_id'])) {
                                            print("add some value");
                                            for (var xj in _listItemsChilds) {
                                              var idToAddItem = xj["_id"];
                                              if (!_selectedListItemsChilds
                                                  .contains(idToAddItem)) {
                                                _selectedListItemsChilds
                                                    .add(idToAddItem);
                                              }
                                            }
                                          } else {
                                            print("add all value");
                                            dynamic mapId = _listItemsChilds
                                                .map((i) => i['_id'])
                                                .toList();

                                            List<String> mapIdStringList =
                                                mapId.cast<String>();
                                            //
                                            //ເອົາຂໍ້ມູນທີ່ເລືອກ(press) add ເຂົ້າໃນ array
                                            _selectedListItemsChilds
                                                .add(i['_id']);
                                            _selectedListItemsChilds
                                                .addAll(mapIdStringList);
                                          }
                                        }
                                        //
                                        //ຖ້າວ່າ _selectedListItemsChilds ບໍ່ມີຄ່າຂອງ i['item'] ທັງໝົດ
                                        // else {
                                        // for (var xp = 0;
                                        //     xp < i['item'].length;
                                        //     xp++) {
                                        //   String xpId = i['item'][xp]['_id'];
                                        //   if (!_selectedListItemsChilds
                                        //       .contains(xpId)) {
                                        //     _selectedListItemsChilds
                                        //         .add(xpId);
                                        //   } else {
                                        //
                                        //ເອົາ item(Childs)ໄດ້ມາຈາກການກົດ press(_listItemsChilds) ມາ map ເອົາ _id

                                        //
                                        //
                                        //
                                        //
                                        //
                                        //
                                        //dynamic mapId = _listItemsChilds
                                        //     .map((i) => i['_id'])
                                        //     .toList();
                                        // //
                                        // //ເອົາຂໍ້ມູນທີ່ເລືອກ(press) add ເຂົ້າໃນ array
                                        // _selectedListItemsChilds
                                        //     .add(i['_id']);
                                        // _selectedListItemsChilds
                                        //     .addAll(mapId);

                                        //   }
                                        // }
                                        // }
                                      });
                                    },
                                    //
                                    //
                                    //checkbox icon Parents
                                    child: Container(
                                      child: i['item'].every(
                                                  (eCheckBoxParents) =>
                                                      _selectedListItemsChilds
                                                          .contains(
                                                              eCheckBoxParents[
                                                                  '_id'])) &&
                                              _selectedIndex.contains(index)
                                          ? Icon(Icons.check_box,
                                              color: AppColors.iconPrimary)
                                          : Icon(Icons.check_box_outline_blank),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),

                                  //
                                  //
                                  //Text Parents Name
                                  Expanded(
                                    child: Text(
                                      '${name}',
                                      style: bodyTextNormal(
                                          _selectedListItemsChilds
                                                  .contains(i['_id'])
                                              ? AppColors.iconPrimary
                                              : null,
                                          FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // Text("${i['isCheck']}"),
                                  Text(
                                    "${_countListItemsChilds}",
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.chevronRight,
                                    size: IconSize.sIcon,
                                    color: _selectedListItemsChilds
                                            .contains(i['_id'])
                                        ? AppColors.iconPrimary
                                        : AppColors.iconDark,
                                  )
                                ],
                              ),
                            ),
                          ),
                          //
                          //
                          //
                          //
                          //
                          //
                          //
                          //
                          //ສະແດງ Slide of Child
                          //ຖ້າວ່າ i['isCheck'] = true && _selectedIndex == index(ໂຕທີ່ເຮົາຄິກຕົງກັບ _listItemsParents[index] ນັ້ນ)
                          if (i['isCheck'] && _selectedIndex.contains(index))
                            Container(
                              child: Column(
                                children: [
                                  //
                                  //box container display ParentName from press Parents
                                  // Container(
                                  //   width: double.infinity,
                                  //   padding: EdgeInsets.all(15),
                                  //   decoration: BoxDecoration(
                                  //     color: AppColors.greyWhite,
                                  //     border: Border.all(
                                  //         color: AppColors.borderGrey),
                                  //     borderRadius:
                                  //         BorderRadius.circular(1.5.w),
                                  //   ),
                                  //   child: Text(
                                  //     "${_selectedStrItemsParentName} == ${_selectedStrItemsParentId}",
                                  //     style: bodyTextNormal(
                                  //         null, FontWeight.bold),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: 15,
                                  // ),

                                  // Text("${eiei}"),
                                  // Text("${eiei.length}"),

                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: i['item'].length,
                                    itemBuilder: (context, childIndex) {
                                      dynamic p = i['item'][childIndex];
                                      String name = p['name'];

                                      return GestureDetector(
                                        //
                                        //
                                        //checkbox Childs
                                        //pree list multiselected
                                        onTap: () {
                                          setState(() {
                                            //
                                            //ຖ້າໂຕທີ່ເລືອກ p['_id'] ກົງກັບ _selectedListItemsChilds(_id) ແມ່ນລົບອອກ
                                            if (_selectedListItemsChilds
                                                .contains(p['_id'])) {
                                              _selectedListItemsChilds
                                                  .removeWhere(
                                                (e) => e == p['_id'],
                                              );
                                              if (_listItemsChilds.every(
                                                  (eCheckBoxChilds) =>
                                                      !_selectedListItemsChilds
                                                          .contains(
                                                              eCheckBoxChilds[
                                                                  '_id']))) {
                                                _selectedListItemsChilds
                                                    .removeWhere(
                                                  (x) => x == i['_id'],
                                                );
                                              }

                                              return;
                                            }

                                            //
                                            //i['_id'] ໄດ້ມາຈາກ ParentId
                                            //ຖ້າວ່າ _selectedListItemsChilds ບໍ່ມີ ParentId ຈະ add ເຂົ້າ _selectedListItemsChilds
                                            if (!_selectedListItemsChilds
                                                .contains(i['_id'])) {
                                              _selectedListItemsChilds
                                                  .add(i['_id']);
                                            }

                                            //
                                            //ເອົາຂໍ້ມູນທີ່ເລືອກ p['_id'] add ເຂົ້າໃນ array _selectedListItemsChilds
                                            _selectedListItemsChilds
                                                .add(p['_id']);
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          margin: EdgeInsets.only(left: 20),
                                          child: Row(
                                            children: [
                                              //
                                              //
                                              //checkbox icon Childs
                                              Container(
                                                child: _selectedListItemsChilds
                                                        .contains(p['_id'])
                                                    ? Icon(Icons.check_box,
                                                        color: AppColors
                                                            .iconPrimary)
                                                    : Icon(Icons
                                                        .check_box_outline_blank),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              //
                                              //
                                              //Text Childs Name
                                              Expanded(
                                                child: Text(
                                                  '${name}',
                                                  style: bodyTextNormal(
                                                      _selectedListItemsChilds
                                                              .contains(
                                                                  p['_id'])
                                                          ? AppColors
                                                              .fontPrimary
                                                          : null,
                                                      FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
