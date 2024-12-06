// ignore_for_file: prefer_if_null_operators, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, unnecessary_null_in_if_null_operators

import 'package:app/functions/colors.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BoxDecInputHideCompanies extends StatefulWidget {
  const BoxDecInputHideCompanies({
    Key? key,
    this.boxColor,
    this.boxBorderColor,
    this.prefixBoxImageColor,
    this.prefixIconImageColor,
    this.press,
    this.prefixIconSize,
    this.text,
    this.textColor,
    this.textFontFamily,
    this.suffixIconColor,
    this.suffixIconSize,
    this.suffixPress,
    this.suffixIcon,
    this.prefixImage,
  }) : super(key: key);

  final String? prefixImage, text, textFontFamily, suffixIcon;
  final Color? boxColor,
      boxBorderColor,
      prefixBoxImageColor,
      prefixIconImageColor,
      textColor,
      suffixIconColor;
  final double? prefixIconSize, suffixIconSize;
  final Function()? press, suffixPress;

  @override
  State<BoxDecInputHideCompanies> createState() =>
      _BoxDecInputHideCompaniesState();
}

class _BoxDecInputHideCompaniesState extends State<BoxDecInputHideCompanies> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
        width: double.infinity,
        decoration: boxDecoration(
            BorderRadius.circular(8),
            widget.boxColor ?? AppColors.primary100,
            widget.boxBorderColor,
            null),
        child: Row(
          children: [
            //
            //
            //Prefix image
            Container(
              height: 57,
              width: 57,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.borderSecondary,
                ),
                color: widget.prefixBoxImageColor ?? AppColors.primary300,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: widget.prefixImage == null
                  ? Align(
                      alignment: Alignment.center,
                      child: FaIcon(
                        FontAwesomeIcons.plus,
                        size: widget.prefixIconSize ?? 20,
                        color:
                            widget.prefixIconImageColor ?? AppColors.primary600,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: widget.prefixImage == ""
                            ? Image.asset(
                                'assets/image/no-image-available.png',
                                fit: BoxFit.contain,
                              )
                            : Image.network(
                                "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${widget.prefixImage}",
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/image/no-image-available.png',
                                    fit: BoxFit.contain,
                                  ); // Display an error message
                                },
                              ),
                      ),
                    ),
            ),
            SizedBox(
              width: 10,
            ),
            //
            //
            //Text
            Expanded(
              child: Text(
                widget.text ?? "",
                style: bodyTextNormal(
                    widget.textFontFamily ?? "NotoSansLaoLoopedMedium",
                    widget.textColor ?? AppColors.primary600,
                    null),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            //
            //
            //Suffix icon
            GestureDetector(
              onTap: widget.suffixPress,
              child: Container(
                color: widget.boxColor ?? AppColors.primary100,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    widget.suffixIcon ?? "",
                    style: fontAwesomeSolid(null, widget.suffixIconSize ?? 14,
                        widget.suffixIconColor ?? null, null),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
