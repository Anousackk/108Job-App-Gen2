// ignore_for_file: prefer_if_null_operators, avoid_unnecessary_containers, prefer_const_constructors

import 'package:app/functions/colors.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';

class BoxDecInputProfileSettingPrefixTextSuffixWidget extends StatefulWidget {
  const BoxDecInputProfileSettingPrefixTextSuffixWidget({
    Key? key,
    this.press,
    this.text,
    this.textColor,
    this.validateValue,
    this.validateValueColor,
    this.pressSuffixWidget,
    this.boxBorderColor,
    required this.validateText,
    this.boxColor,
    this.suffixWidget,
    this.boxHeight,
  }) : super(key: key);
  final Function()? press, pressSuffixWidget;
  final Color? textColor, boxBorderColor, boxColor, validateValueColor;
  final String? validateValue, text;
  final Container validateText;
  final Widget? suffixWidget;
  final double? boxHeight;

  @override
  State<BoxDecInputProfileSettingPrefixTextSuffixWidget> createState() =>
      _BoxDecInputProfileSettingPrefixTextSuffixWidgetState();
}

class _BoxDecInputProfileSettingPrefixTextSuffixWidgetState
    extends State<BoxDecInputProfileSettingPrefixTextSuffixWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.press,
          child: Container(
            width: double.infinity,
            height: widget.boxHeight ?? 55,
            decoration: boxDecoration(
                BorderRadius.circular(8),
                widget.boxColor == null ? AppColors.dark100 : widget.boxColor,
                widget.boxBorderColor,
                null),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      // color: AppColors.primary,
                      child: Text(
                        "${widget.text}",
                        overflow: TextOverflow.ellipsis,
                        style: inputTextMiniNormal(
                          "NotoSansLaoLoopedSemiBold",
                          widget.textColor == null
                              ? AppColors.dark
                              : widget.textColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: widget.pressSuffixWidget,
                      child: Container(
                        // color: AppColors.info,
                        alignment: AlignmentDirectional.centerEnd,
                        child: widget.suffixWidget,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        widget.validateText,
      ],
    );
  }
}
