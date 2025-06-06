// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, prefer_if_null_operators, unnecessary_null_comparison, unused_local_variable, deprecated_member_use, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

//
//
//
//TextFormFieldTextRight
class TextFormFieldTextRight extends StatefulWidget {
  const TextFormFieldTextRight({
    Key? key,
    required this.hintText,
  }) : super(key: key);
  final String hintText;

  @override
  State<TextFormFieldTextRight> createState() => _TextFormFieldTextRightState();
}

class _TextFormFieldTextRightState extends State<TextFormFieldTextRight> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.end,
      decoration: InputDecoration(
        isDense: true,
        // contentPadding: EdgeInsets.all(1.3.h),
        contentPadding: EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.inputColor),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          // borderRadius: BorderRadius.circular(1.w),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'file-exclamation',
                style: TextStyle(
                    color: AppColors.grey,
                    // fontSize: 12.sp,
                    fontFamily: 'FontAwesomePro-Regular'),
              ),
              SizedBox(
                width: 2.w,
              ),
              Text(
                widget.hintText,
                // style: TextStyle(color: AppColors.grey, fontSize: 12.sp),
              )
            ],
          ),
        ),
        // labelText: 'eiei',
        labelStyle: TextStyle(color: AppColors.dark),
        filled: true,
        fillColor: AppColors.inputColor,
      ),
    );
  }
}

//
//
//TextFieldMultiValidate
class TextFieldMultiValidate extends StatefulWidget {
  TextFieldMultiValidate({
    Key? key,
    this.hintText,
    this.hintStyleColor,
    this.codeController,
    this.changed,
    this.press,
    required,
    this.iconColor,
    this.keyboardType,
  }) : super(key: key);
  final String? hintText;
  // final TextStyle? hintStyleColor;
  final Color? hintStyleColor;
  final TextEditingController? codeController;
  final Color? iconColor;
  final Function(String)? changed;
  final Function()? press;
  final TextInputType? keyboardType;

  @override
  State<TextFieldMultiValidate> createState() => _TextFieldMultiValidateState();
}

class _TextFieldMultiValidateState extends State<TextFieldMultiValidate> {
  final requirValidator = RequiredValidator(errorText: 'required');
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.press,
      onChanged: widget.changed,
      controller: widget.codeController,
      keyboardType: widget.keyboardType == null
          ? TextInputType.text
          : widget.keyboardType,
      // textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // contentPadding: EdgeInsets.symmetric(horizontal: 2.5.w),

        fillColor: AppColors.inputColor,
        filled: true,
        enabledBorder: enableOutlineBorder(
          AppColors.borderSecondary,
        ),
        focusedBorder: focusOutlineBorder(
          // AppColors.greyOpacity.withOpacity(0.2),
          AppColors.inputColor,
        ),
        hintText: "${widget.hintText}",
        hintStyle: TextStyle(
          color: widget.hintStyleColor == null
              ? AppColors.black
              : widget.hintStyleColor,
          // fontSize: 10.sp,
        ),
        // helperText: ' ',
      ),

      validator: MultiValidator([
        RequiredValidator(
          errorText: "required",
        ),

        // MinLengthValidator(6,
        //     errorText: "Password should be atleast 6 characters"),
        // MaxLengthValidator(15,
        //     errorText: "Password should not be greater than 15 characters")
      ]),

      // validator: requirValidator,
    );
  }
}

//
//
//SimpleTextFieldWithIconLeft
class SimpleTextFieldWithIconLeft extends StatefulWidget {
  SimpleTextFieldWithIconLeft({
    Key? key,
    this.hintText,
    this.hintStyleColor,
    this.textController,
    this.prefixIcon,
    this.changed,
    this.press,
    this.valueValidator,
    this.fontIcon,
    this.iconFontSize,
    this.colorIcon,
    this.keyboardType,
    this.textAlign,
    this.enabled,
    this.hintTextFontWeight,
    required this.isObscure,
  }) : super(key: key);
  final String? hintText, valueValidator;
  // final TextStyle? hintStyleColor;
  final Color? hintStyleColor;
  final FontWeight? hintTextFontWeight;
  final TextEditingController? textController;
  final String? prefixIcon, fontIcon;
  final Color? colorIcon;
  final double? iconFontSize;
  final Function(String)? changed;
  final TextInputType? keyboardType;
  final Function()? press;
  final bool? enabled;
  final dynamic textAlign;
  final bool isObscure;

  @override
  State<SimpleTextFieldWithIconLeft> createState() =>
      _SimpleTextFieldWithIconLeftState();
}

class _SimpleTextFieldWithIconLeftState
    extends State<SimpleTextFieldWithIconLeft> {
  @override
  Widget build(BuildContext context) {
    var textValidate = "required";
    return Container(
      // height: 13.w,
      child: TextFormField(
        onTap: widget.press,
        onChanged: widget.changed,
        controller: widget.textController,
        enabled: widget.enabled == null ? true : widget.enabled,
        obscureText: widget.isObscure,
        toolbarOptions: ToolbarOptions(
          paste: true,
          cut: true,
          copy: true,
          selectAll: true,
        ),
        textAlign:
            widget.textAlign == null ? TextAlign.start : widget.textAlign,
        keyboardType: widget.keyboardType == null
            ? TextInputType.text
            : widget.keyboardType,
        decoration: InputDecoration(
          //prefixIcon ແບບ flutter icon
          // prefixIcon: Icon(
          //   widget.icon,
          //   color:
          //       widget.iconColor == null ? AppColors.black : widget.iconColor,
          //   size: 12.sp,
          // ),

          //prefixIcon ແບບ String(FontAwesome)
          prefixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.prefixIcon}',
                style: sIcon(null, null),
              ),
            ],
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              // EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 3.5.w),
              EdgeInsets.symmetric(horizontal: 15, vertical: 15),

          fillColor: AppColors.inputColor,
          filled: true,
          enabledBorder: enableOutlineBorder(
            AppColors.borderSecondary,
          ),
          focusedBorder: focusOutlineBorder(
            AppColors.borderPrimary,
          ),
          hintText: "${widget.hintText}",
          hintStyle: bodyTextNormal(
            null,
            widget.hintStyleColor == null
                ? AppColors.fontGreyOpacity
                : widget.hintStyleColor,
            widget.hintTextFontWeight,
          ),
        ),

        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return "required";
          }
          return null;
        },

        // validator: MultiValidator([
        //   RequiredValidator(
        //     errorText: "validate_text".tr,
        //   ),
        // ]),
      ),
    );
  }
}

//
//
//
//
//SimpleTextFieldWithIconRight
class SimpleTextFieldWithIconRight extends StatefulWidget {
  SimpleTextFieldWithIconRight({
    Key? key,
    this.hintText,
    this.hintStyleColor,
    this.textController,
    required this.suffixIcon,
    this.changed,
    this.press,
    this.valueValidator,
    this.fontIcon,
    this.iconFontSize,
    this.suffixIconColor,
    this.keyboardType,
    this.textAlign,
    this.enabled,
    this.hintTextFontWeight,
    this.isObscure,
    this.inputColor,
  }) : super(key: key);
  final String? hintText, valueValidator;
  // final TextStyle? hintStyleColor;
  final Color? hintStyleColor;
  final FontWeight? hintTextFontWeight;
  final TextEditingController? textController;
  final String? fontIcon;
  final Color? suffixIconColor, inputColor;
  final double? iconFontSize;
  final Function(String)? changed;
  final TextInputType? keyboardType;
  final Function()? press;
  final bool? enabled;
  final dynamic textAlign;
  final Widget suffixIcon;
  final bool? isObscure;

  @override
  State<SimpleTextFieldWithIconRight> createState() =>
      _SimpleTextFieldWithIconRightState();
}

class _SimpleTextFieldWithIconRightState
    extends State<SimpleTextFieldWithIconRight> {
  @override
  Widget build(BuildContext context) {
    var textValidate = "required";
    return Container(
      // height: 50,
      child: TextFormField(
        onTap: widget.press,
        onChanged: widget.changed,
        controller: widget.textController,
        enabled: widget.enabled == null
            ? true
            : widget
                .enabled, //enable = true ສາມາດໃຊ້ປົກກະຕິ / enable = false ບໍ່ສາມາດກົດໄດ້
        obscureText: widget.isObscure ?? false,
        textAlign:
            widget.textAlign == null ? TextAlign.start : widget.textAlign,
        style: TextStyle(color: AppColors.fontDark),
        keyboardType: widget.keyboardType == null
            ? TextInputType.text
            : widget.keyboardType,
        toolbarOptions: ToolbarOptions(
          paste: true,
          cut: true,
          copy: true,
          selectAll: true,
        ),
        decoration: InputDecoration(
          // prefixIcon: Icon(
          //   widget.icon,
          //   color:
          //       widget.iconColor == null ? AppColors.black : widget.iconColor,
          //   size: 12.sp,
          // ),
          // prefixIcon: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       '${widget.icon}',
          //       style: sIcon(null, null),
          //     ),
          //   ],
          // ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              // EdgeInsets.symmetric(vertical: 3.5.w, horizontal: 3.5.w),
              EdgeInsets.symmetric(vertical: 15, horizontal: 15),

          fillColor: widget.inputColor == null
              ? AppColors.inputLight
              : widget.inputColor,
          filled: true,
          enabledBorder: enableOutlineBorder(
            AppColors.borderSecondary,
          ),
          focusedBorder: focusOutlineBorder(
            AppColors.borderPrimary,
          ),
          hintText: "${widget.hintText}",
          hintStyle: bodyTextNormal(
            null,
            widget.hintStyleColor == null
                ? AppColors.fontGreyOpacity
                : widget.hintStyleColor,
            widget.hintTextFontWeight,
          ),

          //suffixIcon ແບບ String(FontAwesome)
          // suffixIcon: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       '${widget.suffixIcon}',
          //       style: sIcon(null, null),
          //     ),
          //   ],
          // ),

          suffixIcon: IconButton(
            icon: widget.suffixIcon,
            color: widget.suffixIconColor,
            iconSize: IconSize.mIcon,
            onPressed: () {},
          ),
        ),

        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return "required".tr;
          }
          return null;
        },

        // validator: MultiValidator([
        //   RequiredValidator(
        //     errorText: "validate_text".tr,
        //   ),
        // ]),
      ),
    );
  }
}

//
//
//SimpleTextFieldSingleValidate
class SimpleTextFieldSingleValidate extends StatefulWidget {
  SimpleTextFieldSingleValidate({
    Key? key,
    this.hintText,
    this.hintStyleColor,
    this.codeController,
    this.changed,
    this.press,
    required,
    this.iconColor,
    this.keyboardType,
    this.maxLength,
    this.validator,
    this.onSave,
    this.enabled,
    this.textAlign,
    this.inputFormat,
    this.inputColor,
    this.heightCon,
    this.maxLines,
    this.hintTextFontWeight,
    this.suffixIcon,
    this.prefixIcon,
    this.contenPadding,
    this.enabledBorder,
  }) : super(key: key);
  final String? hintText;
  // final TextStyle? hintStyleColor;
  final double? heightCon;
  final int? maxLines;
  final Color? hintStyleColor;
  final TextEditingController? codeController;
  final Color? iconColor, inputColor;
  final Function(String)? changed;
  final Function()? press;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool? enabled;
  final dynamic inputFormat;
  final dynamic textAlign;
  final dynamic validator;
  final FontWeight? hintTextFontWeight;
  dynamic onSave;
  final Widget? suffixIcon, prefixIcon;
  final EdgeInsetsGeometry? contenPadding;
  final InputBorder? enabledBorder;

  @override
  State<SimpleTextFieldSingleValidate> createState() =>
      _SimpleTextFieldSingleValidateState();
}

class _SimpleTextFieldSingleValidateState
    extends State<SimpleTextFieldSingleValidate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.heightCon,
      child: TextFormField(
        maxLines: widget.maxLines == null ? 1 : widget.maxLines,
        inputFormatters: widget.inputFormat,
        onTap: widget.press,
        onChanged: widget.changed,
        controller: widget.codeController,
        enabled: widget.enabled == null ? true : widget.enabled,
        toolbarOptions: ToolbarOptions(
          paste: true,
          cut: true,
          copy: true,
          selectAll: true,
        ),
        textAlign:
            widget.textAlign == null ? TextAlign.start : widget.textAlign,
        keyboardType: widget.keyboardType == null
            ? TextInputType.text
            : widget.keyboardType,
        maxLength: widget.maxLength,

        // textAlign: TextAlign.center,
        decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: widget.contenPadding == null
                // ? EdgeInsets.symmetric(vertical: 3.5.w, horizontal: 3.5.w)
                ? EdgeInsets.symmetric(vertical: 15, horizontal: 15)
                : widget.contenPadding,
            fillColor: widget.inputColor == null
                ? AppColors.inputColor
                : widget.inputColor,
            filled: true,
            enabledBorder: widget.enabledBorder == null
                ? enableOutlineBorder(
                    AppColors.borderBG,
                  )
                : widget.enabledBorder,
            focusedBorder: focusOutlineBorder(
              AppColors.borderPrimary,
            ),
            hintText: "${widget.hintText}",
            hintStyle: bodyTextNormal(
              null,
              widget.hintStyleColor == null
                  ? AppColors.fontGreyOpacity
                  : widget.hintStyleColor,
              widget.hintTextFontWeight,
            ),
            suffixIcon: widget.suffixIcon

            // helperText: ' ',
            ),

        validator: widget.validator,
        onSaved: widget.onSave,
        // validator: (String? value) {
        //   if (value == null || value.isEmpty) {
        //     return "validate_text".tr;
        //   }
        //   return null;
        // },
      ),
    );
  }
}

//
//
//TextFieldTextCenter
class TextFieldTextCenter extends StatefulWidget {
  TextFieldTextCenter({
    Key? key,
    this.hintText,
    this.hintStyleColor,
    this.textController,
    this.changed,
    // required this.isObscure,
    this.iconButton,
    this.valueValidator,
    this.inputFormat,
    this.textAlign,
    this.keyboardType,
    this.enabled,
    this.inputColor,
  }) : super(key: key);
  final String? hintText, valueValidator;
  final Color? hintStyleColor, inputColor;
  final IconButton? iconButton;
  final TextEditingController? textController;
  final Function(String)? changed;
  final TextInputType? keyboardType;
  final dynamic inputFormat;
  final dynamic textAlign;
  final bool? enabled;

  // final bool isObscure;

  @override
  State<TextFieldTextCenter> createState() => _TextFieldTextCenterState();
}

class _TextFieldTextCenterState extends State<TextFieldTextCenter> {
  final requirValidator = RequiredValidator(errorText: 'required');
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 13.w,
      width: double.infinity,
      child: TextFormField(
        inputFormatters: widget.inputFormat,
        controller: widget.textController,
        onChanged: widget.changed,
        // obscureText: widget.isObscure,
        textAlign:
            widget.textAlign == null ? TextAlign.center : widget.textAlign,
        keyboardType: widget.keyboardType == null
            ? TextInputType.text
            : widget.keyboardType,
        enableInteractiveSelection: true,
        enabled: widget.enabled == null ? true : widget.enabled,
        toolbarOptions: ToolbarOptions(
          paste: true,
          cut: true,
          copy: true,
          selectAll: true,
        ),
        style: TextStyle(
          fontSize: 3.5.w,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),

          contentPadding:
              // EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 3.w),
              EdgeInsets.symmetric(horizontal: 10, vertical: 13),

          fillColor: widget.inputColor == null
              ? AppColors.inputColor
              : widget.inputColor,
          filled: true,
          enabledBorder: enableOutlineBorder(
            AppColors.white,
          ),
          focusedBorder: focusOutlineBorder(
            AppColors.borderPrimary,
          ),
          hintText: "${widget.hintText}",
          hintStyle: TextStyle(
            color: widget.hintStyleColor == null
                ? AppColors.fontGreyOpacity
                : widget.hintStyleColor,
            fontSize: FontSize.bodyTextNormal,
          ),
          // suffixIcon: widget.iconButton,
          // helperText: ' ',
        ),

        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return "required";
          }
          return null;
        },
      ),
    );
  }
}

//
//
//TextFieldPhoneNumber
class TextFieldPhoneNumber extends StatefulWidget {
  TextFieldPhoneNumber({
    Key? key,
    this.hintText,
    this.hintStyleColor,
    this.textController,
    this.preFix,
    this.changed,
    this.press,
    this.valueValidator,
    this.fontIcon,
    this.iconFontSize,
    this.colorIcon,
    this.keyboardType,
    this.textAlign,
    this.enabled,
    this.preFixColor,
    this.preFixFontWeight,
    this.hintTextFontWeight,
    this.isObscure,
    this.suffixIconColor,
    required this.suffixIcon,
  }) : super(key: key);
  final String? hintText, valueValidator;
  // final TextStyle? hintStyleColor;
  final Color? hintStyleColor;
  final TextEditingController? textController;
  final String? preFix, fontIcon;
  final Color? colorIcon, preFixColor, suffixIconColor;
  final double? iconFontSize;
  final TextInputType? keyboardType;
  final Function(String)? changed;
  final Function()? press;
  final bool? enabled;
  final dynamic textAlign;
  final FontWeight? preFixFontWeight, hintTextFontWeight;
  final bool? isObscure;
  final Widget suffixIcon;

  @override
  State<TextFieldPhoneNumber> createState() => _TextFieldPhoneNumberState();
}

class _TextFieldPhoneNumberState extends State<TextFieldPhoneNumber> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 13.w,
      child: TextFormField(
        onTap: widget.press,
        onChanged: widget.changed,
        controller: widget.textController,
        enabled: widget.enabled == null ? true : widget.enabled,
        obscureText: widget.isObscure ?? false,
        //inputFormatters ບໍ່ໃຫ້ພິມຕົວເລກບໍ່ເກີນ 8ຕົວ
        inputFormatters: [
          LengthLimitingTextInputFormatter(8),
        ],
        toolbarOptions: ToolbarOptions(
          paste: true,
          cut: true,
          copy: true,
          selectAll: true,
        ),
        textAlign:
            widget.textAlign == null ? TextAlign.start : widget.textAlign,
        keyboardType: widget.keyboardType == null
            ? TextInputType.text
            : widget.keyboardType,
        decoration: InputDecoration(
          prefixIcon: Container(
            // padding: EdgeInsets.only(right: 3.w),
            padding: EdgeInsets.only(right: 13),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: AppColors.borderGrey),
                    ),
                  ),
                  child: Padding(
                    // padding: EdgeInsets.symmetric(horizontal: 3.w),
                    padding: EdgeInsets.symmetric(horizontal: 13),

                    child: Text(
                      '${widget.preFix}',
                      style: bodyTextNormal(
                          null, widget.preFixColor, widget.preFixFontWeight),
                    ),
                  ),
                ),
              ],
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              // EdgeInsets.symmetric(vertical: 3.5.w, horizontal: 3.5.w),
              EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          fillColor: AppColors.inputLight,
          filled: true,
          enabledBorder: enableOutlineBorder(
            AppColors.borderSecondary,
          ),
          focusedBorder: focusOutlineBorder(
            AppColors.borderPrimary,
          ),
          hintText: "${widget.hintText}",
          hintStyle: bodyTextNormal(
            null,
            widget.hintStyleColor == null
                ? AppColors.fontGreyOpacity
                : widget.hintStyleColor,
            widget.hintTextFontWeight,
          ),
          suffixIcon: IconButton(
            icon: widget.suffixIcon,
            color: widget.suffixIconColor,
            iconSize: IconSize.sIcon,
            onPressed: () {},
          ),
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return "required".tr;
          } else if (value.length != 8) {
            return "enter8number".tr;
          }
          return null;
        },
      ),
    );
  }
}

//
//
//
//
//TextFieldEmailWithIconRight
class TextFieldEmailWithIconRight extends StatefulWidget {
  TextFieldEmailWithIconRight({
    Key? key,
    this.hintText,
    this.hintStyleColor,
    this.textController,
    required this.suffixIcon,
    this.changed,
    this.press,
    this.valueValidator,
    this.fontIcon,
    this.iconFontSize,
    this.suffixIconColor,
    this.keyboardType,
    this.textAlign,
    this.enabled,
    this.hintTextFontWeight,
    this.isObscure,
    this.inputColor,
  }) : super(key: key);
  final String? hintText, valueValidator;
  // final TextStyle? hintStyleColor;
  final Color? hintStyleColor;
  final FontWeight? hintTextFontWeight;
  final TextEditingController? textController;
  final String? fontIcon;
  final Color? suffixIconColor, inputColor;
  final double? iconFontSize;
  final Function(String)? changed;
  final TextInputType? keyboardType;
  final Function()? press;
  final bool? enabled;
  final dynamic textAlign;
  final Widget suffixIcon;
  final bool? isObscure;

  @override
  State<TextFieldEmailWithIconRight> createState() =>
      _TextFieldEmailWithIconRightState();
}

class _TextFieldEmailWithIconRightState
    extends State<TextFieldEmailWithIconRight> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50,
      child: TextFormField(
        onTap: widget.press,
        onChanged: widget.changed,
        controller: widget.textController,
        enabled: widget.enabled == null
            ? true
            : widget
                .enabled, //enable = true ສາມາດໃຊ້ປົກກະຕິ / enable = false ບໍ່ສາມາດກົດໄດ້
        obscureText: widget.isObscure ?? false,
        textAlign:
            widget.textAlign == null ? TextAlign.start : widget.textAlign,
        style: TextStyle(color: AppColors.fontDark),
        keyboardType: widget.keyboardType == null
            ? TextInputType.text
            : widget.keyboardType,
        toolbarOptions: ToolbarOptions(
          paste: true,
          cut: true,
          copy: true,
          selectAll: true,
        ),
        decoration: InputDecoration(
          // prefixIcon: Icon(
          //   widget.icon,
          //   color:
          //       widget.iconColor == null ? AppColors.black : widget.iconColor,
          //   size: 12.sp,
          // ),
          // prefixIcon: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       '${widget.icon}',
          //       style: sIcon(null, null),
          //     ),
          //   ],
          // ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              // EdgeInsets.symmetric(vertical: 3.5.w, horizontal: 3.5.w),
              EdgeInsets.symmetric(vertical: 15, horizontal: 15),

          fillColor: widget.inputColor == null
              ? AppColors.inputLight
              : widget.inputColor,
          filled: true,
          enabledBorder: enableOutlineBorder(
            AppColors.borderSecondary,
          ),
          focusedBorder: focusOutlineBorder(
            AppColors.borderPrimary,
          ),
          hintText: "${widget.hintText}",
          hintStyle: bodyTextNormal(
            null,
            widget.hintStyleColor == null
                ? AppColors.fontGreyOpacity
                : widget.hintStyleColor,
            widget.hintTextFontWeight,
          ),

          //suffixIcon ແບບ String(FontAwesome)
          // suffixIcon: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       '${widget.suffixIcon}',
          //       style: sIcon(null, null),
          //     ),
          //   ],
          // ),

          suffixIcon: IconButton(
            icon: widget.suffixIcon,
            color: widget.suffixIconColor,
            iconSize: IconSize.mIcon,
            onPressed: () {},
          ),
        ),

        validator: MultiValidator([
          RequiredValidator(
            errorText: "required".tr,
          ),
          EmailValidator(errorText: "example@mail.com")
        ]),
      ),
    );
  }
}

//
//
//TextFieldPassword
class TextFieldPassword extends StatefulWidget {
  TextFieldPassword({
    Key? key,
    this.hintText,
    this.hintStyleColor,
    this.codeController,
    this.changed,
    required this.isObscure,
    this.suffixIcon,
    this.inputFormat,
    this.prefixIcon,
    this.textAlign,
    this.hintTextFontWeight,
    this.enabled,
  }) : super(key: key);
  final String? hintText;
  final Color? hintStyleColor;
  final Widget? suffixIcon, prefixIcon;
  final TextEditingController? codeController;
  final Function(String)? changed;
  final bool? enabled;

  final bool isObscure;
  final dynamic inputFormat;
  final dynamic textAlign;
  final FontWeight? hintTextFontWeight;

  @override
  State<TextFieldPassword> createState() => _TextFieldPasswordState();
}

class _TextFieldPasswordState extends State<TextFieldPassword> {
  final requirValidator = RequiredValidator(errorText: 'required');
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 13.w,
      child: TextFormField(
        // inputFormatters: [
        //   UpperCaseTextFormatter(),
        // ],
        inputFormatters: widget.inputFormat,
        controller: widget.codeController,
        enabled: widget.enabled == null ? true : widget.enabled,
        onChanged: widget.changed,
        obscureText: widget.isObscure,
        textAlign:
            widget.textAlign == null ? TextAlign.start : widget.textAlign,
        enableInteractiveSelection: true,
        toolbarOptions: ToolbarOptions(
          paste: true,
          cut: true,
          copy: true,
          selectAll: true,
        ),
        style: TextStyle(
          // fontSize: 3.5.w,
          fontSize: 13,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(1.5.w),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              // EdgeInsets.symmetric(vertical: 3.5.w, horizontal: 3.5.w),
              EdgeInsets.symmetric(vertical: 15, horizontal: 15),

          fillColor: AppColors.inputLight,
          filled: true,
          enabledBorder: enableOutlineBorder(
            AppColors.borderSecondary,
          ),
          focusedBorder: focusOutlineBorder(
            AppColors.borderPrimary,
            // AppColors.blue.withOpacity(0.3),
          ),
          hintText: "${widget.hintText}",
          hintStyle: bodyTextNormal(
            null,
            widget.hintStyleColor == null
                ? AppColors.fontGreyOpacity
                : widget.hintStyleColor,
            widget.hintTextFontWeight,
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,

          // helperText: ' ',
        ),

        validator: MultiValidator([
          RequiredValidator(errorText: 'required'.tr),
          MinLengthValidator(8, errorText: "enter8password".tr),
          // MaxLengthValidator(30,
          //     errorText: "Password should not be greater than 30 characters")
        ]),
        // validator: requirValidator,
      ),
    );
  }
}

//DropdownButtonMenu
class DropdownButtonMenu extends StatefulWidget {
  DropdownButtonMenu(
      {Key? key,
      this.onChanged,
      this.items,
      this.value,
      this.validator,
      this.widgetPrefixIcon,
      this.inputColor,
      this.hintStyleColor,
      this.hintTextFontWeight,
      this.hintText,
      this.press})
      : super(key: key);
  // dynamic selectValue;
  final Function(Object?)? onChanged;
  final List<DropdownMenuItem<Object>>? items;
  final dynamic value;
  final String? Function(Object?)? validator;
  final Widget? widgetPrefixIcon;
  final Color? inputColor, hintStyleColor;
  final FontWeight? hintTextFontWeight;
  final String? hintText;
  final Function()? press;

  @override
  State<DropdownButtonMenu> createState() => _DropdownButtonMenuState();
}

class _DropdownButtonMenuState extends State<DropdownButtonMenu> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Container(
          // height: 12.5.w,
          child: DropdownButtonFormField(
            dropdownColor: AppColors
                .backgroundWhite, //Color ຂອງ dropdown ຫຼັງຈາກກົດເພື່ອເລືອກ item
            menuMaxHeight: 40.h, //Height ຂອງ dropdown ຫຼັງຈາກກົດເພື່ອເລືອກ item
            decoration: InputDecoration(
              prefixIcon: widget.widgetPrefixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  // EdgeInsets.symmetric(vertical: 3.5.w, horizontal: 3.5.w),
                  EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              fillColor: widget.inputColor == null
                  ? AppColors.inputColor
                  : widget.inputColor,
              filled: true,
              enabledBorder: enableOutlineBorder(
                AppColors.borderSecondary,
              ),
              focusedBorder: focusOutlineBorder(
                AppColors.borderPrimary,
              ),
            ),
            iconEnabledColor:
                AppColors.iconGrayOpacity, //Color ຂອງ dropdownIcon ເບື້ອງຂວາ
            icon: FaIcon(FontAwesomeIcons.caretDown,
                size: IconSize.sIcon), //Icon dropdown
            hint: Text(
              "${widget.hintText}",
              style: bodyTextNormal(
                null,
                widget.hintStyleColor == null
                    ? AppColors.fontGreyOpacity
                    : widget.hintStyleColor,
                widget.hintTextFontWeight,
              ),
            ),
            isExpanded: true, //ໂຕໜັງສືຍາວເກີນ Field ບໍ່ມີປັນຫາ
            onTap: widget.press,
            onChanged: widget.onChanged,
            value: widget.value, //ຄ່າທີ່ຈະໄປເຊັດເຂົ້າ DB
            items: widget.items, //ເອົາຄ່າທີ່ເປັນ Array ມາ map
            validator: widget.validator,

            // items
            //     .map((i) => DropdownMenuItem(
            //           value: i['value'].toString(),
            //           child: Text(
            //             i['text'],
            //             maxLines: 1,
            //             overflow: TextOverflow.ellipsis,
            //             softWrap: false,
            //             style: headerTextNormal(AppColors.fontPrimary),
            //             // style: TextStyle(
            //             //   fontSize: 3.5.w,
            //             //   color: AppColors.blue,
            //             // ),
            //           ),
            //         ))
            //     .toList(),
          ),
        ),
      ),
    );
  }
}

//DropdownMenuWithApi
class DropdownMenuWithApi extends StatefulWidget {
  DropdownMenuWithApi({Key? key, this.changed}) : super(key: key);
  // dynamic selectValue;
  final Function(Object?)? changed;

  @override
  State<DropdownMenuWithApi> createState() => _DropdownMenuWithApiState();
}

class _DropdownMenuWithApiState extends State<DropdownMenuWithApi> {
  // List items = [
  //   {"text": "ເດືອນປະຈຸບັນ", "value": ""},
  //   {"text": "ຍ້ອນຫຼັງ 1 ເດືອນ", "value": "1"},
  //   {"text": "ຍ້ອນຫຼັງ 2 ເດືອນ", "value": "2"},
  //   {"text": "ຍ້ອນຫຼັງ 3 ເດືອນ", "value": "3"},
  // ];
  List years = ['2023'];
  dynamic selectValue = "";
  int currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();

    // int nextYear = currentYear + 1;
    // if (currentYear == currentYear) {
    //   years.add(nextYear.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    // print(years);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 10),
        child: Container(
          width: 85,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              // enabledBorder: InputBorder.none,
              // focusedBorder: InputBorder.none,
              fillColor: AppColors.info,
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColors.primary.withOpacity(0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColors.primary.withOpacity(0.1),
                  // color: AppColors.blue.withOpacity(0.3),
                ),
              ),
            ),
            isExpanded: true,
            onChanged: widget.changed,
            value: currentYear.toString(),
            items: years
                .map((i) => DropdownMenuItem<String>(
                      value: i,
                      child: Text(
                        i,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: headerTextNormal(AppColors.fontDark),

                        // style: TextStyle(
                        //   fontSize: 3.5.w,
                        //   color: AppColors.blue,
                        // ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

// //SimpleBoxDecoration
// class SimpleBoxDecoration extends StatefulWidget {
//   const SimpleBoxDecoration({
//     Key? key,
//     this.icon,
//     this.fontIcon,
//     this.text,
//     this.press,
//     this.colorIcon,
//     this.colorText,
//     this.iconFontSize,
//   }) : super(key: key);
//   final String? icon, fontIcon, text;
//   final double? iconFontSize;
//   final Color? colorIcon;
//   final Color? colorText;
//   final Function()? press;

//   @override
//   State<SimpleBoxDecoration> createState() => _SimpleBoxDecorationState();
// }

// class _SimpleBoxDecorationState extends State<SimpleBoxDecoration> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.press,
//       child: Container(
//         padding: EdgeInsets.only(left: 1.5.w, right: 1.5.w),
//         decoration: boxDecoration(
//           AppColors.inputColor.withOpacity(0.2),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "${widget.icon}",
//               style: TextStyle(
//                 fontFamily: '${widget.fontIcon}',
//                 fontSize:
//                     widget.iconFontSize == null ? 10.w : widget.iconFontSize,
//                 color: widget.colorIcon == null
//                     ? AppColors.black
//                     : widget.colorIcon,
//               ),
//             ),
//             SizedBox(
//               height: 1.5.w,
//             ),
//             Flexible(
//               child: Text(
//                 "${widget.text}",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     fontSize: 3.w,
//                     color: widget.colorText == null
//                         ? AppColors.black
//                         : widget.colorText),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

//SimpleBoxDecoration
class SimpleBoxDecoration extends StatefulWidget {
  const SimpleBoxDecoration({
    Key? key,
    this.icon,
    this.fontIcon,
    this.text,
    this.press,
    this.colorIcon,
    this.colorText,
    this.iconFontSize,
    this.setHight,
    this.setWidth,
    this.boxDecorationColor,
    this.textSize,
    this.borderColor,
    this.mainAxisAlignments,
  }) : super(key: key);
  final String? icon, fontIcon, text;
  final double? iconFontSize, textSize, setHight, setWidth;
  final Color? boxDecorationColor, borderColor, colorIcon, colorText;
  final dynamic mainAxisAlignments;

  final Function()? press;

  @override
  State<SimpleBoxDecoration> createState() => _SimpleBoxDecorationState();
}

class _SimpleBoxDecorationState extends State<SimpleBoxDecoration> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        height: widget.setHight,
        width: widget.setWidth,
        // padding: EdgeInsets.only(left: 1.5.w, right: 1.5.w),
        // padding: EdgeInsets.all(10),
        decoration: boxDecoration(
            null,
            widget.boxDecorationColor == null
                ? AppColors.white
                : widget.boxDecorationColor!,
            widget.borderColor == null
                ? AppColors.white.withOpacity(0)
                : widget.borderColor!,
            null),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: widget.mainAxisAlignments == null
              ? MainAxisAlignment.center
              : widget.mainAxisAlignments,
          children: [
            Text(
              "${widget.icon}",
              style: TextStyle(
                fontFamily: '${widget.fontIcon}',
                fontSize: widget.iconFontSize == null
                    ? IconSize.lIcon
                    : widget.iconFontSize, //10.5.w
                color: widget.colorIcon == null
                    ? AppColors.black
                    : widget.colorIcon,
              ),
            ),
            SizedBox(
              height: 1.w,
            ),
            Flexible(
              child: Text(
                "${widget.text}",
                textAlign: TextAlign.center,
                // style: bodyTextNormal(null,
                //   widget.colorText == null ? AppColors.black : widget.colorText,
                // ),
                style: TextStyle(
                  fontSize: widget.textSize == null
                      ? FontSize.bodyTextNormal
                      : widget.textSize,
                  color: widget.colorText == null
                      ? AppColors.black
                      : widget.colorText,
                ),
                overflow: TextOverflow.clip,
                maxLines: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}

//BoxDecoration Image
class BoxDecorationImage extends StatefulWidget {
  const BoxDecorationImage(
      {Key? key, this.press, this.icon, this.fontIcon, this.colorIcon})
      : super(key: key);
  final Function()? press;
  final String? icon, fontIcon;
  final Color? colorIcon;

  @override
  State<BoxDecorationImage> createState() => _BoxDecorationImageState();
}

class _BoxDecorationImageState extends State<BoxDecorationImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        width: double.infinity,
        height: 45.w,
        decoration: boxDecoration(
            null, AppColors.inputColor, AppColors.white.withOpacity(0), null),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${widget.icon}",
              style: TextStyle(
                fontFamily: '${widget.fontIcon}',
                fontSize: 15.w,
                color: widget.colorIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
//BoxDecorationInput
class BoxDecorationInput extends StatefulWidget {
  const BoxDecorationInput({
    Key? key,
    this.press,
    this.icon,
    this.fontIcon,
    this.text,
    this.colorText,
    this.validateValue,
    this.colorValidateValue,
    this.iconActivity,
    this.iconColorActivity,
    this.pressIconActivity,
    required this.validateText,
    this.colorInput,
    this.colorBorder,
    this.boxDecBorderRadius,
    this.widgetIconActive,
    this.widgetFaIcon,
    this.paddingFaIcon,
    required this.mainAxisAlignmentTextIcon,
    this.fontWeight,
    this.heigth,
  }) : super(key: key);
  final Function()? press, pressIconActivity;
  final EdgeInsetsGeometry? paddingFaIcon;
  final String? icon, fontIcon;
  final Color? colorText,
      colorBorder,
      colorInput,
      colorValidateValue,
      iconColorActivity;
  final String? text;
  final FontWeight? fontWeight;
  final MainAxisAlignment mainAxisAlignmentTextIcon;
  final String? validateValue;
  final Container validateText;
  final BorderRadiusGeometry? boxDecBorderRadius;
  final IconData? iconActivity;
  final Widget? widgetFaIcon, widgetIconActive;
  final double? heigth;

  @override
  State<BoxDecorationInput> createState() => _BoxDecorationInputState();
}

class _BoxDecorationInputState extends State<BoxDecorationInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: widget.heigth == null ? 50 : widget.heigth,
          decoration: boxDecoration(
              widget.boxDecBorderRadius,
              widget.colorInput == null
                  ? AppColors.inputColor
                  : widget.colorInput,
              widget.colorBorder,
              null),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.press,
              borderRadius: BorderRadius.circular(8),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: widget.mainAxisAlignmentTextIcon,
                      children: [
                        Container(
                          padding: widget.paddingFaIcon == null
                              ? EdgeInsets.symmetric(horizontal: 12)
                              : widget.paddingFaIcon,
                          child: widget.widgetFaIcon,
                        ),
                        Flexible(
                          child: Text(
                            "${widget.text}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: bodyTextNormal(
                                null,
                                widget.colorText == null
                                    ? AppColors.fontDark
                                    : widget.colorText,
                                widget.fontWeight),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.pressIconActivity,
                    child: Container(
                      child: Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: widget.widgetIconActive),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        widget.validateText,
        // Container(
        //   width: double.infinity,
        //   padding: EdgeInsets.only(left: 10, top: 5, bottom: 10),
        //   child: Text(
        //     "${widget.validateValue}",
        //     style: TextStyle(
        //         color: widget.colorValidateValue == null
        //             ? AppColors.white.withOpacity(0)
        //             : widget.colorValidateValue,
        //         fontSize: 12),
        //   ),
        // ),
      ],
    );
  }
}

//BoxDecorationLoading
class BoxDecorationLoading extends StatelessWidget {
  const BoxDecorationLoading({
    Key? key,
    this.width,
    this.heigth,
  }) : super(key: key);
  final double? width, heigth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: heigth,
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: boxDecoration(
          null, AppColors.greyOpacity, AppColors.white.withOpacity(0), null),
    );
  }
}
