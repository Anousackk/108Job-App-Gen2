// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, sized_box_for_whitespace, unnecessary_null_comparison, prefer_if_null_operators, avoid_unnecessary_containers, camel_case_types, deprecated_member_use

import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ButtonDefault extends StatefulWidget {
  const ButtonDefault({
    Key? key,
    this.text,
    this.press,
    this.colorButton,
    this.colorText,
    this.fontWeight,
    this.buttonBorderColor,
    this.boxDecBorderRadius,
    this.paddingButton,
  }) : super(key: key);
  final String? text;
  final Color? colorButton, buttonBorderColor;
  final Color? colorText;
  final FontWeight? fontWeight;
  final BorderRadiusGeometry? boxDecBorderRadius;
  final WidgetStateProperty<EdgeInsetsGeometry?>? paddingButton;

  final Function()? press;

  @override
  State<ButtonDefault> createState() => _ButtonDefaultState();
}

class _ButtonDefaultState extends State<ButtonDefault> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextButton(
        style: ButtonStyle(
          side: WidgetStateProperty.resolveWith<BorderSide>(
            (Set<WidgetState> states) {
              return BorderSide(
                color: widget.buttonBorderColor ?? AppColors.borderWhite,
              ); // Default border color
            },
          ),
          padding: widget.paddingButton ??
              WidgetStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 20),
              ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius:
                  widget.boxDecBorderRadius ?? BorderRadius.circular(12.w),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(
            widget.colorButton == null ? AppColors.primary : widget.colorButton,
          ),
        ),
        onPressed: widget.press,
        child: Text(
          '${widget.text}',
          style: buttonTextNormal(
            null,
            widget.colorText == null ? AppColors.white : widget.colorText,
            widget.fontWeight,
          ),
        ),
      ),
    );
  }
}

class ButtonWithIconLeft extends StatefulWidget {
  const ButtonWithIconLeft({
    Key? key,
    this.text,
    this.press,
    this.colorButton,
    this.colorText,
    this.fontWeight,
    this.widgetIcon,
    this.borderRadius,
    this.buttonBorderColor,
    this.paddingButton,
  }) : super(key: key);
  final String? text;
  final Color? colorButton, buttonBorderColor;
  final Color? colorText;
  final FontWeight? fontWeight;
  final Widget? widgetIcon;
  final BorderRadiusGeometry? borderRadius;
  final WidgetStateProperty<EdgeInsetsGeometry?>? paddingButton;
  final Function()? press;

  @override
  State<ButtonWithIconLeft> createState() => _ButtonWithIconLeftState();
}

class _ButtonWithIconLeftState extends State<ButtonWithIconLeft> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: TextButton(
        style: ButtonStyle(
          padding: widget.paddingButton ??
              WidgetStateProperty.all<EdgeInsets>(
                EdgeInsets.zero,
              ),
          side: WidgetStateProperty.resolveWith<BorderSide>(
            (Set<WidgetState> states) {
              return BorderSide(
                color: widget.buttonBorderColor ??
                    AppColors.borderWhite.withOpacity(0),
              ); // Default border color
            },
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12.w),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(
            widget.colorButton == null ? AppColors.primary : widget.colorButton,
          ),
        ),
        onPressed: widget.press,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(child: widget.widgetIcon),
            SizedBox(
              width: 8,
            ),
            Flexible(
              child: Text(
                '${widget.text}',
                style: buttonTextNormal(
                  null,
                  widget.colorText == null ? AppColors.white : widget.colorText,
                  widget.fontWeight,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatefulWidget {
  const Button({
    Key? key,
    this.text,
    this.press,
    this.buttonColor,
    this.textColor,
    this.textFontWeight,
    this.buttonBorderColor,
    this.boxHeight,
    this.paddingButton,
    this.textFontFamily,
  }) : super(key: key);
  final String? text, textFontFamily;
  final Color? textColor, buttonColor, buttonBorderColor;
  final FontWeight? textFontWeight;
  final double? boxHeight;
  final WidgetStateProperty<EdgeInsetsGeometry?>? paddingButton;

  final Function()? press;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.boxHeight ?? 45,
      child: TextButton(
        style: ButtonStyle(
          padding: widget.paddingButton ??
              WidgetStateProperty.all<EdgeInsets>(
                EdgeInsets.zero,
              ),
          side: WidgetStateProperty.resolveWith<BorderSide>(
            (Set<WidgetState> states) {
              return BorderSide(
                color: widget.buttonBorderColor ??
                    AppColors.borderWhite.withOpacity(0),
              ); // Default border color
            },
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.w),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(
            widget.buttonColor == null ? AppColors.primary : widget.buttonColor,
          ),
        ),
        onPressed: widget.press,
        child: Text(
          '${widget.text}',
          style: buttonTextMaxNormal(
            widget.textFontFamily == null ? null : widget.textFontFamily,
            widget.textColor == null ? AppColors.white : widget.textColor,
            widget.textFontWeight,
          ),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

//SimpleButton
class SimpleButton extends StatefulWidget {
  const SimpleButton({
    Key? key,
    this.text,
    this.press,
    this.colorButton,
    this.colorText,
    this.fontWeight,
    this.buttonBorderColor,
  }) : super(key: key);
  final String? text;
  final Color? colorText, colorButton, buttonBorderColor;
  final FontWeight? fontWeight;
  final Function()? press;

  @override
  State<SimpleButton> createState() => _SimpleButtonState();
}

class _SimpleButtonState extends State<SimpleButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // height: 12.w,
      height: 45,
      child: TextButton(
        style: ButtonStyle(
          side: WidgetStateProperty.resolveWith<BorderSide>(
            (Set<WidgetState> states) {
              return BorderSide(
                color: widget.buttonBorderColor ??
                    AppColors.borderWhite.withOpacity(0),
              ); // Default border color
            },
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              // borderRadius: BorderRadius.circular(1.5.w),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(
            widget.colorButton == null
                ? AppColors.buttonPrimary
                : widget.colorButton,
          ),
        ),
        onPressed: widget.press,
        child: Text("${widget.text}",
            style: bodyTextMaxNormal(
                null,
                widget.colorText == null
                    ? AppColors.fontWhite
                    : widget.colorText,
                widget.fontWeight == null
                    ? FontWeight.normal
                    : widget.fontWeight)
            // style: TextStyle(
            //     fontSize: 10.sp,
            //     color: widget.colorText == null
            //         ? AppColors.white
            //         : widget.colorText),
            ),
      ),
    );
  }
}

//_CustomButtonIconTextState
class CustomButtonIconText extends StatefulWidget {
  const CustomButtonIconText({
    Key? key,
    this.text,
    this.buttonColor,
    this.press,
    this.textColor,
    this.widgetPrefixIcon,
    this.textFontFamily,
    this.textFontWeight,
    this.boxBorderRadius,
  }) : super(key: key);
  final String? text, textFontFamily;
  final FontWeight? textFontWeight;
  final Color? buttonColor, textColor;
  final Widget? widgetPrefixIcon;
  final BorderRadiusGeometry? boxBorderRadius;
  final Function()? press;

  @override
  State<CustomButtonIconText> createState() => _CustomButtonIconTextState();
}

class _CustomButtonIconTextState extends State<CustomButtonIconText> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: TextButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius:
                  widget.boxBorderRadius ?? BorderRadius.circular(1.5.w),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(
              widget.buttonColor ?? AppColors.buttonPrimary),
        ),
        onPressed: widget.press,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: widget.widgetPrefixIcon,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                '${widget.text}',
                style: buttonTextMaxNormal(
                  widget.textFontFamily == null ? null : widget.textFontFamily,
                  widget.textColor == null ? AppColors.white : widget.textColor,
                  widget.textFontWeight,
                ),
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonLauncher extends StatefulWidget {
  const ButtonLauncher(
      {Key? key,
      required this.text,
      this.colorButton,
      required this.icon,
      required this.fontIcon,
      this.colorText,
      this.press,
      this.fontWeight})
      : super(key: key);

  final String text;
  final Color? colorButton;
  final String icon;
  final String fontIcon;
  final Color? colorText;
  final FontWeight? fontWeight;
  final Function()? press;

  @override
  State<ButtonLauncher> createState() => _ButtonLauncherState();
}

class _ButtonLauncherState extends State<ButtonLauncher> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.colorButton == null
              ? AppColors.primary
              : widget.colorButton,
          borderRadius: BorderRadius.circular(1.5.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${widget.icon}",
              style: TextStyle(
                fontSize: IconSize.xsIcon,
                color: widget.colorText == null
                    ? AppColors.white
                    : widget.colorText,
                fontFamily: "${widget.fontIcon}",
              ),
            ),
            SizedBox(
              width: 2.w,
            ),
            Text(
              "${widget.text}",
              // style: TextStyle(
              //   fontSize: 10.sp,
              //   color: widget.colorText == null
              //       ? AppColors.white
              //       : widget.colorText,
              // ),
              style: bodyTextNormal(
                  null,
                  widget.colorText == null ? AppColors.white : widget.colorText,
                  widget.fontWeight == null
                      ? FontWeight.normal
                      : widget.fontWeight),
            ),
          ],
        ),
      ),
    );
  }
}

//SimpleDropdown
class SimpleDropdown extends StatefulWidget {
  const SimpleDropdown({
    Key? key,
    required this.icon,
    required this.items,
    required this.values,
  }) : super(key: key);
  final Icon icon;
  final List items;
  final String values;

  @override
  State<SimpleDropdown> createState() => _SimpleDropdownState();
}

class _SimpleDropdownState extends State<SimpleDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          prefixIcon: widget.icon,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          fillColor: AppColors.greyOpacity,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.greyOpacity,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.greyOpacity,
              // color: AppColors.primary.withOpacity(0.3),
            ),
          ),
        ),
        // isExpanded: true,
        value: widget.values,
        items: widget.items
            .map((i) => DropdownMenuItem(
                  value: i,
                  child: Text(
                    i,
                  ),
                ))
            .toList(),
        onChanged: (i) => setState(() {
          i as String?;
        }),
      ),
    );
  }
}

class BottomButtonExpanded extends StatefulWidget {
  const BottomButtonExpanded({
    Key? key,
    this.pressApproved,
    this.pressRejected,
    required this.textCancel,
    required this.textConfirm,
    this.colorButtonCancel,
    this.colorButtonConfirm,
    this.colorTextButtonCancel,
    this.colorTextButtonConfirm,
  }) : super(key: key);
  final Function()? pressApproved, pressRejected;
  final String textCancel, textConfirm;
  final Color? colorButtonCancel;
  final Color? colorButtonConfirm;
  final Color? colorTextButtonCancel;
  final Color? colorTextButtonConfirm;

  @override
  State<BottomButtonExpanded> createState() => _BottomButtonExpandedState();
}

class _BottomButtonExpandedState extends State<BottomButtonExpanded> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 1.h, bottom: 3.h),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SimpleButton(
                    text: widget.textCancel,
                    colorButton: widget.colorButtonCancel == null
                        ? AppColors.info
                        : widget.colorButtonCancel,
                    colorText: widget.colorTextButtonCancel == null
                        ? AppColors.black
                        : widget.colorTextButtonCancel,
                    press: widget.pressRejected,
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  flex: 2,
                  child: SimpleButton(
                    text: widget.textConfirm,
                    colorButton: widget.colorButtonConfirm == null
                        ? AppColors.primary
                        : widget.colorButtonConfirm,
                    colorText: widget.colorTextButtonConfirm == null
                        ? AppColors.white
                        : widget.colorTextButtonConfirm,
                    press: widget.pressApproved,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomButton extends StatefulWidget {
  const BottomButton({
    Key? key,
    this.pressApproved,
    this.pressRejected,
    required this.textApproved,
    required this.textRejected,
  }) : super(key: key);
  final Function()? pressApproved, pressRejected;
  final String textApproved;
  final String textRejected;

  @override
  State<BottomButton> createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SimpleButton(
                    text: widget.textRejected,
                    colorButton: AppColors.info,
                    colorText: AppColors.black,
                    press: widget.pressRejected,
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  flex: 2,
                  child: SimpleButton(
                    text: widget.textApproved,
                    colorButton: AppColors.primary,
                    colorText: AppColors.white,
                    press: widget.pressApproved,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonSpaceBetween extends StatefulWidget {
  const ButtonSpaceBetween({
    Key? key,
    this.pressApproved,
    this.pressRejected,
    required this.textApproved,
    required this.textRejected,
    this.buttonColorApproved,
    this.buttonColorRejected,
    this.colorTextApproved,
    this.colorTextRejected,
  }) : super(key: key);
  final Function()? pressApproved, pressRejected;
  final String textApproved;
  final String textRejected;
  final Color? buttonColorApproved,
      buttonColorRejected,
      colorTextApproved,
      colorTextRejected;

  @override
  State<ButtonSpaceBetween> createState() => _ButtonSpaceBetweenState();
}

class _ButtonSpaceBetweenState extends State<ButtonSpaceBetween> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SimpleButton(
                    text: widget.textRejected,
                    colorButton: widget.buttonColorRejected == null
                        ? AppColors.info
                        : widget.buttonColorRejected,
                    colorText: widget.colorTextRejected == null
                        ? AppColors.black
                        : widget.colorTextRejected,
                    press: widget.pressRejected,
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  flex: 1,
                  child: SimpleButton(
                    text: widget.textApproved,
                    colorButton: widget.buttonColorApproved == null
                        ? AppColors.primary
                        : widget.buttonColorApproved,
                    colorText: widget.colorTextApproved == null
                        ? AppColors.white
                        : widget.colorTextApproved,
                    press: widget.pressApproved,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//
//
//ປຸ່ມ button
class BottomSingleCancelButton extends StatefulWidget {
  const BottomSingleCancelButton({
    Key? key,
    this.pressCancelled,
    this.text,
  }) : super(key: key);
  final Function()? pressCancelled;
  final String? text;

  @override
  State<BottomSingleCancelButton> createState() =>
      _BottomSingleCancelButtonState();
}

class _BottomSingleCancelButtonState extends State<BottomSingleCancelButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 3.w),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Button(
                    text: widget.text,
                    buttonColor: AppColors.danger,
                    textColor: AppColors.white,
                    press: widget.pressCancelled,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//
//
//ປຸ່ມ button single
class BottomSingleButton extends StatefulWidget {
  const BottomSingleButton({
    Key? key,
    this.press,
    this.text,
    this.colorButton,
    this.colorText,
    this.colorContain,
  }) : super(key: key);
  final Function()? press;
  final String? text;
  final Color? colorButton, colorText, colorContain;

  @override
  State<BottomSingleButton> createState() => _BottomSingleButtonState();
}

class _BottomSingleButtonState extends State<BottomSingleButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          widget.colorContain == null ? AppColors.white : widget.colorContain,
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Button(
                    text: widget.text,
                    buttonColor: widget.colorButton,
                    textColor: widget.colorText == null
                        ? AppColors.fontWhite
                        : widget.colorText,
                    press: widget.press,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
