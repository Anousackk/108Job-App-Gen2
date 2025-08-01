// ignore_for_file: avoid_unnecessary_containers

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';

class SpaceBetweenTitleAndText extends StatefulWidget {
  const SpaceBetweenTitleAndText({
    Key? key,
    required this.icon,
    required this.title,
    this.text,
  }) : super(key: key);

  final String icon, title;
  final String? text;

  @override
  State<SpaceBetweenTitleAndText> createState() =>
      _SpaceBetweenTitleAndTextState();
}

class _SpaceBetweenTitleAndTextState extends State<SpaceBetweenTitleAndText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // color: AppColors.red,
          child: Row(
            children: [
              // Text(
              //   "${widget.icon}",
              //   style: fontAwesomeRegular(null, 16, AppColors.primary600, null),
              // ),
              // SizedBox(width: 10),
              Text(
                "${widget.title}",
                style: bodyTextNormal(null, null, null),
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Container(
            // color: AppColors.success,
            child: Text(
              "${widget.text}",
              style: bodyTextNormal(null, null, null),
              // overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              // maxLines: 2,
            ),
          ),
        )
      ],
    );
  }
}

class IconAndTextWidget extends StatefulWidget {
  const IconAndTextWidget({
    Key? key,
    required this.text,
    required this.iconString,
    this.mainAxisAlignment,
  }) : super(key: key);

  final String iconString, text;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  State<IconAndTextWidget> createState() => _IconAndTextWidgetState();
}

class _IconAndTextWidgetState extends State<IconAndTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            "${widget.iconString}",
            style: fontAwesomeRegular(null, 16, AppColors.primary600, null),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            "${widget.text}",
            style: bodyTextMaxSmall(null, null, null),
          ),
        )
      ],
    );
  }
}
