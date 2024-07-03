// ignore_for_file: prefer_const_constructors, prefer_if_null_operators, non_constant_identifier_names, unnecessary_string_interpolations, file_names

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

//
//
// Boxdecoration Icon with AssetImage / Image.network ຕ້ອງມີ imageType = "imageNetwork"
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
    this.imageType,
  }) : super(key: key);
  final double? boxHeight, boxWidth, imageHeight, imageWidth;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadiusBox;
  final Color? colorBox;
  final String StrImage;
  final String? imageType;
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
        child: widget.imageType == "imageNetwork"
            ? Image.network(
                widget.StrImage,
                height: widget.imageHeight == null ? 5 : widget.imageHeight,
                width: widget.imageWidth == null ? 5 : widget.imageWidth,
              )
            : Image(
                image: AssetImage(widget.StrImage),
                height: widget.imageHeight == null ? 5 : widget.imageHeight,
                width: widget.imageWidth == null ? 5 : widget.imageWidth,
              ),
      ),
    );
  }
}

//
//
//Boxdecoration Icon by FontAwesome
class BoxDecorationIconFontAwesome extends StatefulWidget {
  const BoxDecorationIconFontAwesome({
    Key? key,
    this.press,
    this.boxHeight,
    this.boxWidth,
    this.padding,
    this.borderRadiusBox,
    this.colorBox,
    this.imageHeight,
    this.imageWidth,
    // required this.StrImage,
    // this.fontIcon,
    this.iconSize,
    this.iconColor,
    required this.faIcon,
  }) : super(key: key);
  final double? boxHeight, boxWidth, imageHeight, imageWidth;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadiusBox;
  final Color? colorBox, iconColor;
  // final String StrImage;
  // final String? fontIcon;
  final double? iconSize;
  final Function()? press;
  final IconData faIcon;

  @override
  State<BoxDecorationIconFontAwesome> createState() =>
      _BoxDecorationIconFontAwesomeState();
}

class _BoxDecorationIconFontAwesomeState
    extends State<BoxDecorationIconFontAwesome> {
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
        // child: Image(
        //   image: AssetImage(widget.StrImage),
        //   height: widget.imageHeight == null ? 5 : widget.imageHeight,
        //   width: widget.imageWidth == null ? 5 : widget.imageWidth,
        // ),
        // child: Text(
        //   widget.StrImage,
        //   style: TextStyle(
        //     fontFamily: widget.fontIcon == null
        //         ? 'FontAwesomePro-Light'
        //         : widget.fontIcon,
        //     fontSize: widget.iconFontSize == null
        //         ? IconSize.lIcon
        //         : widget.iconFontSize, //10.5.w
        //     color:
        //         widget.colorIcon == null ? AppColors.black : widget.colorIcon,
        //   ),
        // ),

        child: IconButton(
          onPressed: () {},
          icon: FaIcon(
            widget.faIcon,
            size: widget.iconSize == null ? 50 : widget.iconSize,
            color: widget.iconColor == null
                ? AppColors.iconDark
                : widget.iconColor,
          ),
        ),
      ),
    );
  }
}

//
//
//Boxdecoration image(top) and text(bottom)
class BoxDecorationImageAndText extends StatefulWidget {
  const BoxDecorationImageAndText(
      {Key? key,
      this.height,
      this.width,
      this.press,
      this.borderRadius,
      this.borderColor,
      this.boxColor,
      this.imageHeight,
      this.imageWidth,
      required this.imageStr,
      this.imageType,
      this.text,
      this.textColor,
      this.fontWeight})
      : super(key: key);
  final String imageStr;
  final String? imageType, text;
  final FontWeight? fontWeight;
  final double? height, width, imageHeight, imageWidth;
  final BorderRadiusGeometry? borderRadius;
  final Color? boxColor, borderColor, textColor;
  final Function()? press;

  @override
  State<BoxDecorationImageAndText> createState() =>
      _BoxDecorationImageAndTextState();
}

class _BoxDecorationImageAndTextState extends State<BoxDecorationImageAndText> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Center(
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius == null
                ? BorderRadius.circular(10)
                : widget.borderRadius,
            border: Border.all(
              color: widget.borderColor ?? AppColors.borderWhite,
              width: 2,
            ),
            color:
                widget.boxColor == null ? AppColors.greyWhite : widget.boxColor,
          ),
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.imageType == "imageNetwork"
                  ? Image.network(
                      "${widget.imageStr}",
                      height: widget.imageHeight == null ? 14.w : null,
                      width: widget.imageWidth == null ? 14.w : null,
                      fit: BoxFit.cover,
                    )
                  : Image(
                      image: AssetImage(
                        "${widget.imageStr}",
                      ),
                      height: widget.imageHeight == null ? 14.w : null,
                      width: widget.imageWidth == null ? 14.w : null,
                      fit: BoxFit.cover,
                    ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${widget.text}',
                style: bodyTextNormal(
                  widget.textColor == null
                      ? AppColors.fontDark
                      : widget.textColor,
                  widget.fontWeight == null
                      ? FontWeight.bold
                      : widget.fontWeight,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
