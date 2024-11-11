// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_local_variable, prefer_final_fields, unused_field, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, prefer_is_empty, avoid_print

import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/screenAfterSignIn/message/messageDetail.dart';
import 'package:app/widget/screenNoData.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class Messages extends StatefulWidget {
  const Messages({
    Key? key,
    this.callbackTotalNoti,
  }) : super(key: key);
  static String routeName = '/Message';
  final Function(String)? callbackTotalNoti;

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  ScrollController _scrollController = ScrollController();

  List _listMessages = [];
  String _message = "";
  dynamic _createdAt;
  dynamic _status;
  bool _isLoading = false;
  bool _isLoadingMoreData = false;
  bool _hasMoreData = true;

  dynamic page = 1;
  dynamic perPage = 10;
  dynamic totals;
  dynamic totalMessageUnRead;

  fetchMessages() async {
    if (!_hasMoreData) {
      _isLoadingMoreData = false;
      return;
    }

    var res = await postData(getNotificationsSeeker,
        {"page": page, "perPage": perPage, "type": "Messages_Page"});

    List fetchNotification = res['notifyList'];
    // _listMessages = res['notifyList'];
    totals = res['totals'];
    totalMessageUnRead = res['unreadTotals'].toString();

    page++;
    _listMessages.addAll(List<Map<String, dynamic>>.from(fetchNotification));
    if (_listMessages.length >= totals || fetchNotification.length < perPage) {
      _hasMoreData = false;
    }
    _isLoadingMoreData = false;
    _isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  fetchApiCheckTotalMessageUnRead() async {
    var e = await postData(getNotificationsSeeker,
        {"page": page, "perPage": perPage, "type": "Messages_Page"});
    setState(() {
      totalMessageUnRead = e['unreadTotals'].toString();
    });
    print(totalMessageUnRead);
    if (mounted) {
      setState(() {});
    }
  }

  String parseHtmlString(String htmlString) {
    dom.Document document = parse(htmlString);
    return document.body?.text ?? '';
  }

  @override
  void initState() {
    super.initState();

    _isLoading = true;
    fetchMessages();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _isLoadingMoreData = true;
        });
        fetchMessages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        body: SafeArea(
          child: _isLoading
              ? Container(
                  color: AppColors.backgroundWhite,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Container(
                  color: AppColors.backgroundWhite,
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        color: AppColors.backgroundWhite,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop(totalMessageUnRead);
                              },
                              child: FaIcon(
                                FontAwesomeIcons.arrowLeft,
                                size: 20,
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "message".tr,
                                  style: bodyTextMedium(
                                      null, null, FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _listMessages.length > 0
                          ? Expanded(
                              child: Container(
                                // padding: EdgeInsets.symmetric(horizontal: 20),
                                child: ListView.builder(
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: _listMessages.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == _listMessages.length) {
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
                                          // Padding(
                                          //     padding:
                                          //         const EdgeInsets.all(8.0),
                                          //     child: ElevatedButton(
                                          //       style: ButtonStyle(
                                          //           backgroundColor:
                                          //               MaterialStatePropertyAll(
                                          //                   AppColors
                                          //                       .lightPrimary)),
                                          //       onPressed: () => {
                                          //         setState(() {
                                          //           _isLoadingMoreData = true;
                                          //         }),
                                          //         fetchMessages(),
                                          //       },
                                          //       child: Text(
                                          //         'view more'.tr,
                                          //         style: TextStyle(
                                          //             color: AppColors
                                          //                 .fontPrimary),
                                          //       ),
                                          //     ),
                                          //   )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                  child:
                                                      Text('no have data'.tr)),
                                            );
                                    }
                                    dynamic i = _listMessages[index];
                                    _message = parseHtmlString(i['message']);
                                    _createdAt = i['createdAt'] ?? null;
                                    _status = i['status'];

                                    if (_createdAt != null) {
                                      //
                                      //Create Date
                                      //pars ISO to Flutter DateTime
                                      parsDateTime(
                                          value: '',
                                          currentFormat: '',
                                          desiredFormat: '');
                                      DateTime createdAt = parsDateTime(
                                          value: _createdAt,
                                          currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                                          desiredFormat: "yyyy-MM-dd HH:mm:ss");
                                      //
                                      //Format to string 13-03-2024
                                      _createdAt = DateFormat('dd-MM-yyyy')
                                          .format(createdAt);
                                    }

                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MessageDetail(
                                                  messageId: i['msgId'],
                                                  status: i['status'],
                                                ),
                                              ),
                                            ).then((value) async {
                                              if (value != "") {
                                                print("call back mess id : " +
                                                    value);
                                                await fetchApiCheckTotalMessageUnRead();

                                                setState(() {
                                                  dynamic mes = _listMessages
                                                      .firstWhere((m) =>
                                                          m['msgId'] == value);
                                                  print(mes.toString());
                                                  mes["status"] = false;

                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 100),
                                                      () {
                                                    widget.callbackTotalNoti!(
                                                        totalMessageUnRead
                                                            .toString());
                                                  });
                                                });
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15),
                                            decoration: BoxDecoration(
                                              color: _status
                                                  ? AppColors.lightPrimary
                                                  : AppColors.backgroundWhite,
                                              // borderRadius:
                                              //     BorderRadius.circular(10),
                                              // border: _status
                                              //     ? Border.all(
                                              //         color: AppColors
                                              //             .borderPrimary,
                                              //         width: 2)
                                              //     : Border.all(
                                              //         color:
                                              //             AppColors.borderWhite,
                                              //         width: 2),
                                            ),
                                            child: Row(
                                              children: [
                                                // Container(
                                                //   padding: EdgeInsets.symmetric(horizontal: 10),
                                                //   child: FaIcon(
                                                //     FontAwesomeIcons.envelope,
                                                //     size: 30,
                                                //   ),
                                                // ),
                                                // SizedBox(
                                                //   width: 10,
                                                // ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "${_message}",
                                                              style:
                                                                  bodyTextMaxNormal(
                                                                      null,
                                                                      null,
                                                                      FontWeight
                                                                          .bold),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          if (_status)
                                                            Container(
                                                              height: 8,
                                                              width: 8,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: AppColors
                                                                    .primary,
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "date".tr + ": ",
                                                            style: bodyTextSmall(
                                                                null,
                                                                AppColors
                                                                    .fontGreyOpacity,
                                                                null),
                                                          ),
                                                          Text(
                                                            "${_createdAt}",
                                                            style: bodyTextSmall(
                                                                null,
                                                                AppColors
                                                                    .fontGreyOpacity,
                                                                null),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   height: 10,
                                        // )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            )
                          : Expanded(
                              child: ScreenNoData(
                                faIcon: FontAwesomeIcons.fileCircleExclamation,
                                colorIcon: AppColors.primary,
                                text: "no have data".tr,
                                colorText: AppColors.primary,
                              ),
                            ),
                      if (_isLoadingMoreData)
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  )),
        ),
      ),
    );
  }
}
