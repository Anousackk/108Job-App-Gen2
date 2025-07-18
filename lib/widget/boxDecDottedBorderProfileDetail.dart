// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, prefer_if_null_operators, file_names

import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//
//
//BoxDecoration DottedBorder Profile Detail
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
      options: RoundedRectDottedBorderOptions(
        dashPattern: [4, 5],
        strokeWidth: 2,
        // borderType: BorderType.RRect,
        radius: Radius.circular(10),
        color: widget.dotBorderColor ?? AppColors.borderPrimary,
        borderPadding: EdgeInsets.all(1),
      ),
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
                  null,
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
                    null,
                    widget.textColor == null
                        ? AppColors.fontGreyOpacity
                        : widget.textColor,
                    null),
              ),
              Container(
                width: widget.buttonWidth == null ? 70 : widget.buttonWidth,
                child: TextButton(
                  style: ButtonStyle(
                    // padding: MaterialStateProperty.all<EdgeInsets>(
                    //     EdgeInsets.symmetric(horizontal: 40)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all(
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
                            null,
                            widget.buttonTextColor == null
                                ? AppColors.fontWhite
                                : widget.buttonTextColor,
                            null),
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

//
//
//BoxDecoration Profile Detail Have Value
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
        //
        //
        //Title
        Text(
          "${widget.title}",
          style: bodyTextMedium(
            null,
            widget.titleColor == null
                ? AppColors.fontPrimary
                : widget.titleColor,
            widget.titleFontWeight == null
                ? FontWeight.normal
                : widget.titleFontWeight,
          ),
        ),
        //
        //
        //Text
        Text(
          "${widget.text}",
          style: bodyTextSmall(
              null,
              widget.textColor == null
                  ? AppColors.fontGreyOpacity
                  : widget.textColor,
              null),
        ),
        SizedBox(
          height: 15,
        ),
        //
        //
        //Content
        Container(
          padding: EdgeInsets.all(15),
          decoration: boxDecoration(
              BorderRadius.circular(6), AppColors.light, null, null),
          child: Row(children: [
            //
            //
            //Widget faIcon
            Container(
              child: widget.widgetFaIcon,
            ),
            //
            //
            //Widget Expanded
            Expanded(
              flex: 12,
              child: widget.widgetColumn,
            ),
            SizedBox(
              width: 5,
            ),

            //
            //
            //Status left
            if (widget.statusLeft == "have")
              GestureDetector(
                onTap: widget.pressLeft,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppColors.light,
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.pen,
                      size: IconSize.xsIcon,
                    ),
                  ),
                ),
              ),

            //
            //
            //Status right
            if (widget.statusRight == "have")
              GestureDetector(
                onTap: widget.pressRight,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppColors.light,
                      borderRadius: BorderRadius.circular(50)),
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

//
//
//BoxDecoration Profile Detail Have Value Without Title Text
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
          decoration: boxDecoration(
              BorderRadius.circular(6), AppColors.light, null, null),
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
                decoration: BoxDecoration(
                  color: AppColors.light,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.pressLeft,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: FaIcon(
                        FontAwesomeIcons.pen,
                        size: IconSize.xsIcon,
                      ),
                    ),
                  ),
                ),
              ),
            if (widget.statusRight == "have")
              Container(
                decoration: BoxDecoration(
                  color: AppColors.light,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.pressRight,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: FaIcon(
                        FontAwesomeIcons.trash,
                        size: IconSize.xsIcon,
                      ),
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

//
//
//BoxDecoration DottedBorder UploadCV
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
      this.press,
      this.boxDecBorderRadius,
      this.buttonBorderColor,
      this.titleFontFamily,
      this.textFontFamily})
      : super(key: key);

  final String? title, titleFontFamily, text, textFontFamily, buttonText;
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

  final Function()? press;

  @override
  State<BoxDecDottedBorderUploadCV> createState() =>
      _BoxDecDottedBorderUploadCVState();
}

class _BoxDecDottedBorderUploadCVState
    extends State<BoxDecDottedBorderUploadCV> {
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        dashPattern: [7, 4],
        strokeWidth: 1,
        // borderType: BorderType.RRect,
        radius: Radius.circular(10),
        color: widget.dotBorderColor ?? AppColors.borderPrimary,
        borderPadding: EdgeInsets.all(1),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.boxDecColor == null
              ? AppColors.backgroundWhite
              : widget.boxDecColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.press,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  // Container(
                  //   child: widget.widgetFaIcon,
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Text(
                    "${widget.title}",
                    style: bodyTextMaxNormal(
                      widget.titleFontFamily == null
                          ? null
                          : widget.titleFontFamily,
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
                        widget.textFontFamily == null
                            ? null
                            : widget.textFontFamily,
                        widget.textColor == null
                            ? AppColors.fontDark
                            : widget.textColor,
                        null),
                    textAlign: TextAlign.center,
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // ButtonDefault(
                  //   boxDecBorderRadius: widget.boxDecBorderRadius == null
                  //       ? BorderRadius.circular(12.w)
                  //       : widget.boxDecBorderRadius,
                  //   buttonBorderColor: widget.buttonBorderColor == null
                  //       ? AppColors.borderWhite
                  //       : widget.buttonBorderColor,
                  //   colorButton: widget.buttonColor == null
                  //       ? AppColors.buttonPrimary
                  //       : widget.buttonColor,
                  //   text: widget.buttonText,
                  //   colorText: widget.buttonTextColor == null
                  //       ? AppColors.fontWhite
                  //       : widget.buttonTextColor,
                  //   press: widget.pressButton,
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BoxDecProfileSettingHaveValue extends StatefulWidget {
  const BoxDecProfileSettingHaveValue(
      {Key? key,
      this.boxDecColor,
      this.titleColor,
      this.textColor,
      this.title,
      this.text,
      this.titleFontWeight,
      this.pressActionOnOff,
      this.actionOnOffBoxDecColor,
      this.actionOnOffIcon,
      this.actionOnOffText})
      : super(key: key);

  final Widget? actionOnOffIcon;
  final Color? boxDecColor, titleColor, textColor, actionOnOffBoxDecColor;
  final String? title, text, actionOnOffText;
  final FontWeight? titleFontWeight;
  final Function()? pressActionOnOff;

  @override
  State<BoxDecProfileSettingHaveValue> createState() =>
      _BoxDecProfileSettingHaveValueState();
}

class _BoxDecProfileSettingHaveValueState
    extends State<BoxDecProfileSettingHaveValue> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                null,
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
                  null,
                  widget.textColor == null
                      ? AppColors.fontGreyOpacity
                      : widget.textColor,
                  null),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.inputWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Searchable Profile",
                    style: bodyTextNormal(null, null, FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: widget.pressActionOnOff,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: widget.actionOnOffBoxDecColor == null
                            ? AppColors.primary
                            : widget.actionOnOffBoxDecColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Container(
                            child: widget.actionOnOffIcon,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${widget.actionOnOffText}",
                            style: bodyTextNormal(
                                null, AppColors.fontWhite, FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.inputLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Hide your profile from these companies",
                      style: bodyTextNormal(null, null, FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 40,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            width: 40,
                            decoration:
                                BoxDecoration(color: AppColors.greyOpacity),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
