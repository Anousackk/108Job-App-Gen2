// ignore_for_file: prefer_if_null_operators, avoid_unnecessary_containers, prefer_const_constructors, unnecessary_null_in_if_null_operators

import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class BoxDecorationInputPrefixTextSuffixWidget extends StatefulWidget {
  const BoxDecorationInputPrefixTextSuffixWidget({
    Key? key,
    this.press,
    this.text,
    this.textColor,
    this.pressSuffixWidget,
    this.boxBorderColor,
    this.boxColor,
    this.suffixWidget,
    this.prefixColor,
    this.prefixIconText,
    this.prefixFontFamily,
    this.boxHeight,
    this.statusReview,
  }) : super(key: key);
  final Function()? press, pressSuffixWidget;
  final Color? textColor, prefixColor, boxBorderColor, boxColor;
  final String? text, statusReview, prefixIconText, prefixFontFamily;
  final Widget? suffixWidget;
  final double? boxHeight;

  @override
  State<BoxDecorationInputPrefixTextSuffixWidget> createState() =>
      _BoxDecorationInputPrefixTextSuffixWidgetState();
}

class _BoxDecorationInputPrefixTextSuffixWidgetState
    extends State<BoxDecorationInputPrefixTextSuffixWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: widget.boxHeight ?? 55,
          decoration: boxDecoration(
              BorderRadius.circular(6),
              widget.boxColor == null ? AppColors.dark100 : widget.boxColor,
              widget.boxBorderColor,
              null),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.press,
              borderRadius: BorderRadius.circular(6),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "${widget.prefixIconText}",
                            style: sIcon(
                              widget.prefixFontFamily == null
                                  ? null
                                  : widget.prefixFontFamily,
                              widget.prefixColor == null
                                  ? AppColors.dark
                                  : widget.prefixColor,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            // color: AppColors.primary,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                "${widget.text}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: inputTextMiniNormal(
                                  "NotoSansLaoLoopedSemiBold",
                                  widget.textColor == null
                                      ? AppColors.dark
                                      : widget.textColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          // color: AppColors.red,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              widget.statusReview != null
                                  ? "${widget.statusReview}"
                                  : "",
                              style: bodyTextSmall(
                                  null, AppColors.warning600, null),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: widget.pressSuffixWidget,
                      child: Container(
                        // color: AppColors.info,
                        alignment: AlignmentDirectional.centerEnd,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: widget.suffixWidget,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BoxDotBorderPrefixTextSuffixText extends StatefulWidget {
  const BoxDotBorderPrefixTextSuffixText({
    Key? key,
    this.press,
    this.text,
    this.textColor,
    this.pressSuffixWidget,
    this.boxBorderColor,
    this.boxColor,
    this.suffixWidget,
    this.boxHeight,
    this.prefixWidget,
    this.pressPrefixWidget,
    this.suffixBoxColor,
    this.suffixTextColor,
    this.suffixText,
    this.prefixText,
  }) : super(key: key);
  final Function()? press, pressPrefixWidget, pressSuffixWidget;
  final Color? textColor,
      boxBorderColor,
      boxColor,
      suffixBoxColor,
      suffixTextColor;
  final String? text, prefixText, suffixText;
  final Widget? prefixWidget, suffixWidget;
  final double? boxHeight;

  @override
  State<BoxDotBorderPrefixTextSuffixText> createState() =>
      _BoxDotBorderPrefixTextSuffixTextState();
}

class _BoxDotBorderPrefixTextSuffixTextState
    extends State<BoxDotBorderPrefixTextSuffixText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DottedBorder(
          options: RoundedRectDottedBorderOptions(
            dashPattern: [7, 3],
            strokeWidth: 1,
            color: AppColors.borderGreyOpacity,
            radius: Radius.circular(0),
          ),
          child: Container(
            width: double.infinity,
            height: widget.boxHeight ?? 60,
            decoration: boxDecoration(
                BorderRadius.circular(0),
                widget.boxColor ?? AppColors.backgroundWhite,
                widget.boxBorderColor,
                null),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: AppColors.white,
                highlightColor: AppColors.primary100,
                onTap: widget.press,
                borderRadius: BorderRadius.circular(0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            //Prefix Widget
                            GestureDetector(
                              onTap: widget.pressPrefixWidget,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: AppColors.dark,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Text(
                                    "${widget.prefixText}",
                                    style: bodyTextMaxNormal(null,
                                        AppColors.fontWhite, FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            //Text
                            Flexible(
                              child: Container(
                                child: Text(
                                  "${widget.text}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: inputTextMiniNormal(
                                    "NotoSansLaoLoopedSemiBold",
                                    widget.textColor == null
                                        ? AppColors.dark
                                        : widget.textColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 10),

                      //Suffix Widget
                      Container(
                        child: GestureDetector(
                          onTap: widget.pressSuffixWidget,
                          child: Container(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: widget.suffixBoxColor ??
                                      AppColors.dark200),
                              child: Text(
                                "${widget.suffixText}",
                                style: bodyTextSmall(
                                    null, widget.suffixTextColor ?? null, null),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FormStepAddUpdateMyProfile extends StatefulWidget {
  const FormStepAddUpdateMyProfile(
      {Key? key,
      this.formWidget,
      this.textColor,
      this.boxBorderColor,
      this.boxColor,
      this.suffixBoxColor,
      this.suffixTextColor,
      this.text,
      this.prefixText,
      this.suffixText})
      : super(key: key);

  final Widget? formWidget;
  final Color? textColor,
      boxBorderColor,
      boxColor,
      suffixBoxColor,
      suffixTextColor;
  final String? text, prefixText, suffixText;

  @override
  State<FormStepAddUpdateMyProfile> createState() =>
      _FormStepAddUpdateMyProfileState();
}

class _FormStepAddUpdateMyProfileState
    extends State<FormStepAddUpdateMyProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.boxColor ?? AppColors.backgroundWhite,
        border: Border(
          top: BorderSide(
            color: widget.boxBorderColor ?? AppColors.borderPrimary,
            width: 2,
          ),
          bottom: BorderSide(
            color: widget.boxBorderColor ?? AppColors.borderPrimary,
            width: 2,
          ),
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.primary100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: AppColors.primary, shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            "${widget.prefixText}",
                            style: bodyTextMaxNormal(
                                null, AppColors.fontWhite, FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      //Text
                      Flexible(
                        child: Container(
                          child: Text(
                            "${widget.text}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: inputTextMiniNormal(
                              "NotoSansLaoLoopedSemiBold",
                              widget.textColor ?? AppColors.dark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  child: Container(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: widget.suffixBoxColor ?? AppColors.dark200),
                      child: Text(
                        "${widget.suffixText}",
                        style: bodyTextSmall(
                            null, widget.suffixTextColor ?? null, null),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(child: widget.formWidget)
        ],
      ),
    );
  }
}
