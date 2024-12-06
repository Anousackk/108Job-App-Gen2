// ignore_for_file: prefer_if_null_operators, avoid_unnecessary_containers, prefer_const_constructors

import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';

class BoxDecorationInputPrefixTextSuffixWidget extends StatefulWidget {
  const BoxDecorationInputPrefixTextSuffixWidget({
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
    this.prefixColor,
    this.prefixIconText,
    this.prefixFontFamily,
    this.boxHeight,
  }) : super(key: key);
  final Function()? press, pressSuffixWidget;
  final Color? textColor,
      prefixColor,
      boxBorderColor,
      boxColor,
      validateValueColor;
  final String? validateValue, text, prefixIconText, prefixFontFamily;
  final Container validateText;
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
                    flex: 4,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "${widget.prefixIconText}",
                            style: xsIcon(
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
                              padding: EdgeInsets.only(left: 10),
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
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.pressSuffixWidget,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                      child: Container(
                        // color: AppColors.info,
                        alignment: AlignmentDirectional.centerEnd,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
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
        widget.validateText,
      ],
    );
  }
}
