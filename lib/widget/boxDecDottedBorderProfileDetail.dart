// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, prefer_if_null_operators

import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

class BoxDecDottedBorderProfileDetail extends StatefulWidget {
  const BoxDecDottedBorderProfileDetail(
      {Key? key,
      this.title,
      this.text,
      this.buttonText,
      this.titleColor,
      this.textColor,
      this.buttonTextColor,
      this.buttonIconColor,
      this.dotBorderColor,
      this.boxDecColor,
      this.buttonColor,
      this.pressButton,
      this.titleFontWeight,
      this.buttonWidth,
      this.buttonIcon})
      : super(key: key);

  final String? title, text, buttonText;
  final Color? titleColor,
      textColor,
      buttonColor,
      buttonTextColor,
      buttonIconColor,
      dotBorderColor,
      boxDecColor;
  final FontWeight? titleFontWeight;
  final double? buttonWidth;
  final IconData? buttonIcon;
  final Function()? pressButton;

  @override
  State<BoxDecDottedBorderProfileDetail> createState() =>
      _BoxDecDottedBorderProfileDetailState();
}

class _BoxDecDottedBorderProfileDetailState
    extends State<BoxDecDottedBorderProfileDetail> {
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      dashPattern: [4, 5],
      strokeWidth: 2,
      borderType: BorderType.RRect,
      radius: Radius.circular(10),
      color: widget.dotBorderColor ?? AppColors.borderPrimary,
      borderPadding: EdgeInsets.all(1),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.boxDecColor == null
              ? AppColors.backgroundWhite
              : widget.boxDecColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.title}",
                style: bodyTextNormal(
                  widget.titleColor == null
                      ? AppColors.fontPrimary
                      : widget.titleColor,
                  widget.titleFontWeight == null
                      ? FontWeight.normal
                      : widget.titleFontWeight,
                ),
              ),
              Text(
                "${widget.text}",
                style: bodyTextSmall(
                  widget.textColor == null
                      ? AppColors.fontGreyOpacity
                      : widget.textColor,
                ),
              ),
              Container(
                width: widget.buttonWidth == null ? 70 : widget.buttonWidth,
                child: TextButton(
                  style: ButtonStyle(
                    // padding: MaterialStateProperty.all<EdgeInsets>(
                    //     EdgeInsets.symmetric(horizontal: 40)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      widget.buttonColor == null
                          ? AppColors.buttonPrimary
                          : widget.buttonColor,
                    ),
                  ),
                  onPressed: widget.pressButton,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        widget.buttonIcon == null
                            ? FontAwesomeIcons.circlePlus
                            : widget.buttonIcon,
                        size: 15,
                        color: widget.buttonIconColor == null
                            ? AppColors.iconLight
                            : widget.buttonIconColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${widget.buttonText}",
                        style: bodyTextSmall(
                          widget.buttonTextColor == null
                              ? AppColors.fontWhite
                              : widget.buttonTextColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BoxDecProfileDetailHaveValue extends StatefulWidget {
  const BoxDecProfileDetailHaveValue(
      {Key? key,
      required this.widgetColumn,
      this.pressRight,
      this.pressLeft,
      this.statusLeft,
      this.statusRight,
      this.title,
      this.text,
      this.titleColor,
      this.titleFontWeight,
      this.textColor,
      this.widgetFaIcon,
      this.widgetFaIconRight})
      : super(key: key);

  final Widget widgetColumn;
  final Widget? widgetFaIcon, widgetFaIconRight;
  final String? title, text;
  final Color? titleColor, textColor;
  final FontWeight? titleFontWeight;
  final Function()? pressRight, pressLeft;
  final String? statusLeft, statusRight;

  @override
  State<BoxDecProfileDetailHaveValue> createState() =>
      _BoxDecProfileDetailHaveValueState();
}

class _BoxDecProfileDetailHaveValueState
    extends State<BoxDecProfileDetailHaveValue> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          "${widget.title}",
          style: bodyTextNormal(
            widget.titleColor == null
                ? AppColors.fontPrimary
                : widget.titleColor,
            widget.titleFontWeight == null
                ? FontWeight.normal
                : widget.titleFontWeight,
          ),
        ),
        Text(
          "${widget.text}",
          style: bodyTextSmall(
            widget.textColor == null
                ? AppColors.fontGreyOpacity
                : widget.textColor,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          padding: EdgeInsets.all(15),
          decoration: boxDecoration(null, AppColors.light, null),
          child: Row(children: [
            Container(
              child: widget.widgetFaIcon,
            ),
            Expanded(
              flex: 12,
              child: widget.widgetColumn,
            ),
            SizedBox(
              width: 5,
            ),
            if (widget.statusLeft == "have")
              GestureDetector(
                onTap: widget.pressLeft,
                child: Container(
                  padding: EdgeInsets.all(10),
                  // color: AppColors.blue,
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.pen,
                      size: IconSize.xsIcon,
                    ),
                  ),
                ),
              ),
            if (widget.statusRight == "have")
              GestureDetector(
                onTap: widget.pressRight,
                child: Container(
                  padding: EdgeInsets.all(10),
                  // color: AppColors.blue,
                  child: Center(
                    child: widget.widgetFaIconRight == null
                        ? FaIcon(
                            FontAwesomeIcons.trash,
                            size: IconSize.xsIcon,
                          )
                        : widget.widgetFaIconRight,
                  ),
                ),
              )
          ]),
        ),
      ],
    );
  }
}

class BoxDecProfileDetailHaveValueWithoutTitleText extends StatefulWidget {
  const BoxDecProfileDetailHaveValueWithoutTitleText(
      {Key? key,
      required this.widgetColumn,
      this.pressRight,
      this.pressLeft,
      this.statusLeft,
      this.statusRight,
      this.widgetFaIcon})
      : super(key: key);

  final Widget widgetColumn;
  final Widget? widgetFaIcon;

  final Function()? pressRight, pressLeft;
  final String? statusLeft, statusRight;

  @override
  State<BoxDecProfileDetailHaveValueWithoutTitleText> createState() =>
      _BoxDecProfileDetailHaveValueWithoutTitleTextState();
}

class _BoxDecProfileDetailHaveValueWithoutTitleTextState
    extends State<BoxDecProfileDetailHaveValueWithoutTitleText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: boxDecoration(null, AppColors.light, null),
          child: Row(children: [
            Container(
              child: widget.widgetFaIcon,
            ),
            Expanded(
              flex: 12,
              child: widget.widgetColumn,
            ),
            SizedBox(
              width: 5,
            ),
            if (widget.statusLeft == "have")
              Container(
                // color: AppColors.blue,
                child: Center(
                  child: GestureDetector(
                    onTap: widget.pressLeft,
                    child: FaIcon(
                      FontAwesomeIcons.pen,
                      size: IconSize.xsIcon,
                    ),
                  ),
                ),
              ),
            if (widget.statusRight == "have")
              Container(
                padding: EdgeInsets.only(left: 15),
                // color: AppColors.blue,
                child: Center(
                  child: GestureDetector(
                    onTap: widget.pressRight,
                    child: FaIcon(
                      FontAwesomeIcons.trash,
                      size: IconSize.xsIcon,
                    ),
                  ),
                ),
              )
          ]),
        ),
      ],
    );
  }
}

class BoxDecDottedBorderUploadCV extends StatefulWidget {
  const BoxDecDottedBorderUploadCV(
      {Key? key,
      this.title,
      this.text,
      this.buttonText,
      this.titleColor,
      this.textColor,
      this.buttonColor,
      this.buttonTextColor,
      this.buttonIconColor,
      this.dotBorderColor,
      this.boxDecColor,
      this.titleFontWeight,
      this.widgetFaIcon,
      this.pressButton,
      this.boxDecBorderRadius,
      this.buttonBorderColor})
      : super(key: key);

  final String? title, text, buttonText;
  final Color? titleColor,
      textColor,
      buttonColor,
      buttonTextColor,
      buttonIconColor,
      buttonBorderColor,
      dotBorderColor,
      boxDecColor;
  final FontWeight? titleFontWeight;
  final Widget? widgetFaIcon;
  final BorderRadiusGeometry? boxDecBorderRadius;

  final Function()? pressButton;

  @override
  State<BoxDecDottedBorderUploadCV> createState() =>
      _BoxDecDottedBorderUploadCVState();
}

class _BoxDecDottedBorderUploadCVState
    extends State<BoxDecDottedBorderUploadCV> {
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      dashPattern: [4, 5],
      strokeWidth: 2,
      borderType: BorderType.RRect,
      radius: Radius.circular(10),
      color: widget.dotBorderColor ?? AppColors.borderPrimary,
      borderPadding: EdgeInsets.all(1),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.boxDecColor == null
              ? AppColors.backgroundWhite
              : widget.boxDecColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              child: widget.widgetFaIcon,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${widget.title}",
              style: bodyTextNormal(
                widget.titleColor == null
                    ? AppColors.fontDark
                    : widget.titleColor,
                widget.titleFontWeight == null
                    ? FontWeight.normal
                    : widget.titleFontWeight,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "${widget.text}",
              style: bodyTextSmall(
                widget.textColor == null
                    ? AppColors.fontDark
                    : widget.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            ButtonDefault(
              boxDecBorderRadius: widget.boxDecBorderRadius == null
                  ? BorderRadius.circular(12.w)
                  : widget.boxDecBorderRadius,
              buttonBorderColor: widget.buttonBorderColor == null
                  ? AppColors.borderWhite
                  : widget.buttonBorderColor,
              colorButton: widget.buttonColor == null
                  ? AppColors.buttonPrimary
                  : widget.buttonColor,
              text: widget.buttonText,
              colorText: widget.buttonTextColor == null
                  ? AppColors.fontWhite
                  : widget.buttonTextColor,
              press: widget.pressButton,
            )
          ],
        ),
      ),
    );
  }
}
