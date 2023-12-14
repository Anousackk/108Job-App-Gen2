// ignore_for_file: prefer_const_constructors, prefer_if_null_operators, non_constant_identifier_names

import 'package:app/functions/colors.dart';
import 'package:flutter/material.dart';

class BoxDecorationIcon extends StatefulWidget {
  const BoxDecorationIcon({
    Key? key,
    this.press,
    this.boxHeight,
    this.boxWidth,
    this.padding,
    this.borderRadiusBox,
    this.colorBox,
    this.imageHeight,
    this.imageWidth,
    required this.StrImage,
  }) : super(key: key);
  final double? boxHeight, boxWidth, imageHeight, imageWidth;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadiusBox;
  final Color? colorBox;
  final String StrImage;
  final Function()? press;

  @override
  State<BoxDecorationIcon> createState() => _BoxDecorationIconState();
}

class _BoxDecorationIconState extends State<BoxDecorationIcon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        height: widget.boxHeight == null ? 50 : widget.boxHeight,
        width: widget.boxWidth == null ? 50 : widget.boxWidth,
        padding: widget.padding == null ? EdgeInsets.all(10) : widget.padding,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadiusBox == null
              ? BorderRadius.circular(10)
              : widget.borderRadiusBox,
          color:
              widget.colorBox == null ? AppColors.greyWhite : widget.colorBox,
        ),
        child: Image(
          image: AssetImage(widget.StrImage),
          height: widget.imageHeight == null ? 5 : widget.imageHeight,
          width: widget.imageWidth == null ? 5 : widget.imageWidth,
        ),
      ),
    );
  }
}
