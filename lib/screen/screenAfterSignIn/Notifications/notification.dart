// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_local_variable, prefer_final_fields, unused_field, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, prefer_is_empty, avoid_print

import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearchDetail.dart';
import 'package:app/widget/screenNoData.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key, this.callbackTotalNoti, this.statusFromScreen})
      : super(key: key);
  final Function(String)? callbackTotalNoti;
  final statusFromScreen;

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  ScrollController _scrollController = ScrollController();

  List _listNotifications = [];
  String _title = "";
  dynamic _openingDate;
  dynamic _closingDate;
  dynamic _status;
  bool _isLoading = false;
  bool _isLoadingMoreData = false;
  bool _hasMoreData = true;

  dynamic page = 1;
  dynamic perPage = 10;
  dynamic totals;
  dynamic totalNotiUnRead;

  fetchNotifications() async {
    if (!_hasMoreData) return;

    var res = await postData(
        getNotificationsSeeker, {"page": page, "perPage": perPage});

    List fetchNotification = res['notifyList'];
    // _listNotifications = res['notifyList'];
    totals = res['totals'];
    totalNotiUnRead = res['unreadTotals'].toString();

    page++;
    _listNotifications
        .addAll(List<Map<String, dynamic>>.from(fetchNotification));
    if (_listNotifications.length >= totals ||
        fetchNotification.length < perPage) {
      _hasMoreData = false;
    }
    _isLoadingMoreData = false;
    _isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  fetchApiCheckTotalNotiUnRead() async {
    var e = await postData(
        getNotificationsSeeker, {"page": page, "perPage": perPage});
    setState(() {
      totalNotiUnRead = e['unreadTotals'].toString();
    });
    print(totalNotiUnRead);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    _isLoading = true;
    fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        body: SafeArea(
          child: _isLoading
              ? Container(
                  color: AppColors.background,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Container(
                  color: AppColors.background,
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        color: AppColors.background,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            if (widget.statusFromScreen == "HomeScreen")
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
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
                                  "notification".tr,
                                  style: bodyTextMedium(null, FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _listNotifications.length > 0
                          ? Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: ListView.builder(
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: _listNotifications.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == _listNotifications.length) {
                                      return _hasMoreData
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            AppColors
                                                                .lightPrimary)),
                                                onPressed: () => {
                                                  setState(() {
                                                    _isLoadingMoreData = true;
                                                  }),
                                                  fetchNotifications(),
                                                },
                                                child: Text(
                                                  'view more'.tr,
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .fontPrimary),
                                                ),
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
                                    dynamic i = _listNotifications[index];
                                    _title = i['title'];
                                    _openingDate = i['openingDate'];
                                    _closingDate = i['closingDate'];
                                    _status = i['status'];
                                    // _status = true;

                                    //
                                    //Open Date
                                    //pars ISO to Flutter DateTime
                                    parsDateTime(
                                        value: '',
                                        currentFormat: '',
                                        desiredFormat: '');
                                    DateTime openDate = parsDateTime(
                                        value: _openingDate,
                                        currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                                        desiredFormat: "yyyy-MM-dd HH:mm:ss");
                                    //
                                    //Format to string 13-03-2024
                                    _openingDate = DateFormat('dd-MM-yyyy')
                                        .format(openDate);

                                    //pars ISO to Flutter DateTime
                                    parsDateTime(
                                        value: '',
                                        currentFormat: '',
                                        desiredFormat: '');
                                    DateTime closeDate = parsDateTime(
                                        value: _closingDate,
                                        currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                                        desiredFormat: "yyyy-MM-dd HH:mm:ss");
                                    //
                                    //Format to string 13-03-2024
                                    _closingDate = DateFormat('dd-MM-yyyy')
                                        .format(closeDate);
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    JobSearchDetail(
                                                        jobId: i['jobId'],
                                                        statusFromScreen:
                                                            "NotificationScreen"),
                                              ),
                                            ).then((value) async {
                                              if (value[1] != "") {
                                                await fetchApiCheckTotalNotiUnRead();

                                                setState(() {
                                                  dynamic job =
                                                      _listNotifications
                                                          .firstWhere((e) =>
                                                              e['jobId'] ==
                                                              value[1]);
                                                  job["status"] = false;

                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 200),
                                                      () {
                                                    widget.callbackTotalNoti!(
                                                        totalNotiUnRead
                                                            .toString());
                                                  });
                                                });
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: AppColors.backgroundWhite,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: _status
                                                  ? Border.all(
                                                      color: AppColors
                                                          .borderPrimary,
                                                      width: 2)
                                                  : Border.all(
                                                      color:
                                                          AppColors.borderWhite,
                                                      width: 2),
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
                                                      Text(
                                                        "${_title}",
                                                        style: bodyTextMaxNormal(
                                                            _status
                                                                ? null
                                                                : AppColors
                                                                    .fontGreyOpacity,
                                                            null),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "opening date".tr +
                                                                ": ",
                                                            style: bodyTextSmall(
                                                                AppColors
                                                                    .fontGreyOpacity),
                                                          ),
                                                          Text(
                                                            "${_openingDate}",
                                                            style: bodyTextSmall(
                                                                AppColors
                                                                    .fontGreyOpacity),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "closing date".tr +
                                                                ": ",
                                                            style: bodyTextSmall(
                                                                AppColors
                                                                    .fontGreyOpacity),
                                                          ),
                                                          Text(
                                                            "${_closingDate}",
                                                            style: bodyTextSmall(
                                                                AppColors
                                                                    .fontGreyOpacity),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        )
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
                          padding: const EdgeInsets.all(10),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  )),
        ),
      ),
    );
  }
}
