// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_local_variable, prefer_final_fields, unused_field, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, prefer_is_empty, avoid_print

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MessageDetail extends StatefulWidget {
  const MessageDetail({
    Key? key,
    this.messageId,
    this.status,
  }) : super(key: key);
  static String routeName = '/MessageDetail';
  final messageId;
  final status;

  @override
  State<MessageDetail> createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail> {
  ScrollController _scrollController = ScrollController();

  dynamic _messageDetail;
  String _message = "";
  String _callBackMessageId = "";
  bool _isLoading = true;

  fetchMessageDetail(dynamic messageId) async {
    var res = await fetchData(getMessageDetailSeeker + messageId);

    _messageDetail = res['info'];
    _message = _messageDetail['message'];

    if (widget.status == true) {
      setState(() {
        _callBackMessageId = widget.messageId;
      });
    }

    _isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessageDetail(widget.messageId);
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
                  child: Center(child: CustomLoadingLogoCircle()),
                )
              : Container(
                  color: AppColors.backgroundWhite,
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop(_callBackMessageId);
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
                                  "message detail".tr,
                                  style: bodyTextMedium(
                                      null, null, FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          child: HtmlWidget(
                            '$_message',
                            onTapUrl: (url) {
                              launchInBrowser(Uri.parse(url));
                              return true;
                            },
                            // textStyle: bodyTextNormal(null,
                            //     null, null),
                          ),
                        ),
                      )
                    ],
                  )),
        ),
      ),
    );
  }
}
