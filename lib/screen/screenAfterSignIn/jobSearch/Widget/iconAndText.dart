// ignore_for_file: avoid_unnecessary_containers

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  bool isOverflowing = false;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: AppColors.orange,
      child: Row(
        crossAxisAlignment: isOverflowing
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //left icon + title
          Container(
            // color: AppColors.red,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    "${widget.icon}",
                    style: fontAwesomeRegular(
                        null, 16, AppColors.primary600, null),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "${widget.title}",
                  style: bodyTextNormal(null, null, null),
                ),
              ],
            ),
          ),

          SizedBox(width: 20),

          //right text + show more/less
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Measure text
                final span = TextSpan(
                  text: widget.text ?? "",
                  style: bodyTextNormal(null, null, null),
                );

                final tp = TextPainter(
                  text: span,
                  maxLines: 1, // check only 1 line
                  textDirection: TextDirection.ltr,
                )..layout(maxWidth: constraints.maxWidth);

                bool overflow = tp.didExceedMaxLines;

                // Update overflowing state
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && overflow != isOverflowing) {
                    setState(() {
                      isOverflowing = overflow;
                    });
                  }
                });

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.text ?? "",
                      style: bodyTextNormal(null, null, null),
                      textAlign: TextAlign.end,
                      maxLines: isExpanded ? null : 1,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3),

                    // Show 1 more / Show less if text has more 1 line
                    if (isOverflowing)
                      GestureDetector(
                        onTap: () => setState(() => isExpanded = !isExpanded),
                        child: Text(
                          isExpanded ? "show_less".tr : "show_one_more".tr,
                          style:
                              bodyTextSmall(null, AppColors.fontPrimary, null),
                        ),
                      ),
                  ],
                );
              },
            ),
          )
        ],
      ),
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
