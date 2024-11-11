// ignore_for_file: avoid_unnecessary_containers, unnecessary_string_interpolations, prefer_if_null_operators, unnecessary_null_comparison, prefer_const_constructors, file_names

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScreenNoData extends StatefulWidget {
  const ScreenNoData({
    Key? key,
    this.icon,
    this.fontIcon,
    this.colorIcon,
    required this.text,
    this.colorText,
    this.faIcon,
  }) : super(key: key);
  final String? icon;
  final String? fontIcon;
  final Color? colorIcon;
  final String text;
  final Color? colorText;
  final IconData? faIcon;

  @override
  State<ScreenNoData> createState() => _ScreenNoDataState();
}

class _ScreenNoDataState extends State<ScreenNoData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            // child: Text(
            //   '${widget.icon}',
            //   style: TextStyle(
            //       fontFamily: '${widget.fontIcon}',
            //       fontSize: FontSize.bodyTextMaxLarge,
            //       color: widget.colorIcon == null
            //           ? AppColors.fontDark
            //           : widget.colorIcon
            // ),
            // ),
            child: FaIcon(widget.faIcon,
                size: 40,
                color: widget.colorIcon == null
                    ? AppColors.fontDark
                    : widget.colorIcon),
          ),
          Text(
            '${widget.text}',
            style: bodyTextNormal(
                null,
                widget.colorText == null
                    ? AppColors.fontDark
                    : widget.colorText,
                null),
            // style: TextStyle(color: widget.colorText),
          )
        ],
      )),
    );
  }
}
