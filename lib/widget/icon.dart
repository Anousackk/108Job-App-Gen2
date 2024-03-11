// ignore_for_file: prefer_const_constructors, prefer_if_null_operators

import 'package:app/functions/colors.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

//NotificationIcon
class NotificationIcon extends StatefulWidget {
  const NotificationIcon({
    Key? key,
    this.icon,
    this.text,
    this.press,
  }) : super(key: key);
  final String? icon, text;
  final GestureTapCallback? press;

  @override
  State<NotificationIcon> createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: SizedBox(
        width: 45,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: EdgeInsets.only(right: 10, top: 8),
                decoration: boxDecoration(null, AppColors.greyOpacity,
                    AppColors.white.withOpacity(0)),
                child: Text(
                  ' ${widget.icon} ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'FontAwesomePro-Solid',
                      fontSize: 25,
                      color: AppColors.blue),
                ),
              ),
            ),
            // SizedBox(
            //   height: 5,
            // ),
            // Text(
            //   "$text",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 10),
            // )
          ],
        ),
      ),
    );
  }
}

//SimpleIcon
class SimpleIcon extends StatefulWidget {
  const SimpleIcon({
    Key? key,
    this.icon,
    this.press,
    this.colorIcon,
    this.fontSizeIcon,
  }) : super(key: key);
  final String? icon;
  final double? fontSizeIcon;
  final Function()? press;
  final Color? colorIcon;

  @override
  State<SimpleIcon> createState() => _SimpleIconState();
}

class _SimpleIconState extends State<SimpleIcon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Column(
        children: [
          Text(
            '${widget.icon}',
            style: TextStyle(
              fontFamily: 'FontAwesomePro-Solid',
              fontSize: widget.fontSizeIcon == null ? 5.w : widget.fontSizeIcon,
              color:
                  widget.colorIcon == null ? AppColors.blue : widget.colorIcon,
            ),
          ),
        ],
      ),
    );
  }
}
