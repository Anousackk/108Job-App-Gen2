// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, prefer_if_null_operators, unnecessary_null_comparison, unused_local_variable, deprecated_member_use, must_be_immutable

import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
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
        contentPadding: EdgeInsets.all(1.3.h),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.inputColor),
          borderRadius: BorderRadius.circular(1.w),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(1.w)),
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
                    fontSize: 12.sp,
                    fontFamily: 'FontAwesomePro-Regular'),
              ),
              SizedBox(
                width: 2.w,
              ),
              Text(
                widget.hintText,
                style: TextStyle(color: AppColors.grey, fontSize: 12.sp),
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
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 2.5.w),
        fillColor: AppColors.inputColor,
        filled: true,
        enabledBorder: enableOutlineBorder(
          AppColors.inputColor,
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
          fontSize: 10.sp,
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
    return TextFormField(
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
      textAlign: widget.textAlign == null ? TextAlign.start : widget.textAlign,
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

        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 2.5.w),
        fillColor: AppColors.inputColor,
        filled: true,
        enabledBorder: enableOutlineBorder(
          AppColors.inputColor,
        ),
        focusedBorder: focusOutlineBorder(
          AppColors.borderLightPrimary,
        ),
        hintText: "${widget.hintText}",
        hintStyle: bodyTextNormal(
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
    );
  }
}

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
    required this.isObscure,
  }) : super(key: key);
  final String? hintText, valueValidator;
  // final TextStyle? hintStyleColor;
  final Color? hintStyleColor;
  final FontWeight? hintTextFontWeight;
  final TextEditingController? textController;
  final String? fontIcon;
  final Color? suffixIconColor;
  final double? iconFontSize;
  final Function(String)? changed;
  final TextInputType? keyboardType;
  final Function()? press;
  final bool? enabled;
  final dynamic textAlign;
  final Widget suffixIcon;
  final bool isObscure;

  @override
  State<SimpleTextFieldWithIconRight> createState() =>
      _SimpleTextFieldWithIconRightState();
}

class _SimpleTextFieldWithIconRightState
    extends State<SimpleTextFieldWithIconRight> {
  @override
  Widget build(BuildContext context) {
    var textValidate = "required";
    return TextFormField(
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
      textAlign: widget.textAlign == null ? TextAlign.start : widget.textAlign,
      keyboardType: widget.keyboardType == null
          ? TextInputType.text
          : widget.keyboardType,
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

        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 3.w),
        fillColor: AppColors.inputLight,
        filled: true,
        enabledBorder: enableOutlineBorder(
          AppColors.borderSecondary,
        ),
        focusedBorder: focusOutlineBorder(
          AppColors.borderLightPrimary,
        ),
        hintText: "${widget.hintText}",
        hintStyle: bodyTextNormal(
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
          iconSize: 20,
          onPressed: () {},
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
  }) : super(key: key);
  final String? hintText;
  // final TextStyle? hintStyleColor;
  final Color? hintStyleColor;
  final TextEditingController? codeController;
  final Color? iconColor;
  final Function(String)? changed;
  final Function()? press;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool? enabled;
  final dynamic inputFormat;
  final dynamic textAlign;
  final dynamic validator;
  dynamic onSave;

  @override
  State<SimpleTextFieldSingleValidate> createState() =>
      _SimpleTextFieldSingleValidateState();
}

class _SimpleTextFieldSingleValidateState
    extends State<SimpleTextFieldSingleValidate> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
      textAlign: widget.textAlign == null ? TextAlign.start : widget.textAlign,
      keyboardType: widget.keyboardType == null
          ? TextInputType.text
          : widget.keyboardType,
      maxLength: widget.maxLength,

      // textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 2.5.w),
        fillColor: AppColors.inputColor,
        filled: true,
        enabledBorder: enableOutlineBorder(
          AppColors.inputColor,
        ),
        focusedBorder: focusOutlineBorder(
          AppColors.inputColor,
        ),
        hintText: "${widget.hintText}",
        hintStyle: TextStyle(
          color: widget.hintStyleColor == null
              ? AppColors.fontGreyOpacity
              : widget.hintStyleColor,
          fontSize: 10.sp,
        ),

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
  }) : super(key: key);
  final String? hintText, valueValidator;
  final Color? hintStyleColor;
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
            borderRadius: BorderRadius.circular(1.5.w),
          ),

          contentPadding:
              EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 3.w),
          fillColor: AppColors.inputColor,
          filled: true,
          enabledBorder: enableOutlineBorder(
            AppColors.white,
          ),
          focusedBorder: focusOutlineBorder(
            AppColors.borderLightPrimary,
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
    required this.isObscure,
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
  final bool isObscure;
  final Widget suffixIcon;

  @override
  State<TextFieldPhoneNumber> createState() => _TextFieldPhoneNumberState();
}

class _TextFieldPhoneNumberState extends State<TextFieldPhoneNumber> {
  @override
  Widget build(BuildContext context) {
    var textValidate = "required";
    return TextFormField(
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
      textAlign: widget.textAlign == null ? TextAlign.start : widget.textAlign,
      keyboardType: widget.keyboardType == null
          ? TextInputType.text
          : widget.keyboardType,
      decoration: InputDecoration(
        prefixIcon: Container(
          padding: EdgeInsets.only(right: 3.w),
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
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Text(
                    '${widget.preFix}',
                    style: bodyTextNormal(
                        widget.preFixColor, widget.preFixFontWeight),
                  ),
                ),
              ),
            ],
          ),
        ),

        // border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
        fillColor: AppColors.inputLight,
        filled: true,
        enabledBorder: enableOutlineBorder(
          AppColors.borderSecondary,
        ),
        focusedBorder: focusOutlineBorder(
          AppColors.borderLightPrimary,
        ),
        hintText: "${widget.hintText}",
        hintStyle: bodyTextNormal(
          widget.hintStyleColor == null
              ? AppColors.fontGreyOpacity
              : widget.hintStyleColor,
          widget.hintTextFontWeight,
        ),
        suffixIcon: IconButton(
          icon: widget.suffixIcon,
          color: widget.suffixIconColor,
          iconSize: 20,
          onPressed: () {},
        ),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "required";
        }
        return null;
      },
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
  final IconButton? suffixIcon, prefixIcon;
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
      // height: 20.w,
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
          fontSize: 3.5.w,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1.5.w),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
          fillColor: AppColors.inputLight,
          filled: true,
          enabledBorder: enableOutlineBorder(
            AppColors.borderSecondary,
          ),
          focusedBorder: focusOutlineBorder(
            AppColors.borderLightPrimary,
            // AppColors.blue.withOpacity(0.3),
          ),
          hintText: "${widget.hintText}",
          hintStyle: bodyTextNormal(
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
          RequiredValidator(errorText: 'required'),
          // MinLengthValidator(6,
          //     errorText: "Password should be atleast 6 characters"),
          // MaxLengthValidator(30,
          //     errorText: "Password should not be greater than 30 characters")
        ]),
        // validator: requirValidator,
      ),
    );
  }
}

//DropdownMenu
class DropdownMenuCustome extends StatefulWidget {
  DropdownMenuCustome({Key? key, this.changed}) : super(key: key);
  // dynamic selectValue;
  final Function(Object?)? changed;

  @override
  State<DropdownMenuCustome> createState() => _DropdownMenuCustomeState();
}

class _DropdownMenuCustomeState extends State<DropdownMenuCustome> {
  List items = [
    {"text": "this_month", "value": ""},
    {"text": "month_ago", "value": "1"},
    {"text": "two_month_ago", "value": "2"},
    {"text": "three_month_ago", "value": "3"},
  ];
  dynamic selectValue = "";
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Container(
          width: 32.w,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              // enabledBorder: InputBorder.none,
              // focusedBorder: InputBorder.none,
              fillColor: AppColors.white,
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 2.5.w),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.blue.withOpacity(0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.blue.withOpacity(0.1),
                  // color: AppColors.blue.withOpacity(0.3),
                ),
              ),
            ),
            isExpanded: true,
            onChanged: widget.changed,
            value: selectValue,
            items: items
                .map((i) => DropdownMenuItem(
                      value: i['value'].toString(),
                      child: Text(
                        i['text'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: headerTextNormal(AppColors.fontPrimary),
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
                  color: AppColors.blue.withOpacity(0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColors.blue.withOpacity(0.1),
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
          widget.boxDecorationColor == null
              ? AppColors.white
              : widget.boxDecorationColor!,
          widget.borderColor == null
              ? AppColors.white.withOpacity(0)
              : widget.borderColor!,
        ),
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
                // style: bodyTextNormal(
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
        decoration:
            boxDecoration(AppColors.inputColor, AppColors.white.withOpacity(0)),
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

//BoxDecorationInput
class BoxDecorationInput extends StatefulWidget {
  const BoxDecorationInput({
    Key? key,
    this.press,
    this.icon,
    this.fontIcon,
    this.colorIcon,
    this.text,
    this.colorText,
    this.validateValue,
    this.colorValidateValue,
    this.iconActivity,
    this.iconColorActivity,
    this.pressIconActivity,
    required this.colorBorder,
    required this.validateText,
    this.colorInput,
    this.fontFamily,
  }) : super(key: key);
  final Function()? press, pressIconActivity;
  final String? icon, fontIcon;
  final Color? colorIcon;
  final Color? colorText;
  final Color colorBorder;
  final Color? colorInput;
  final String? text, iconActivity, fontFamily;
  final String? validateValue;
  final Color? colorValidateValue, iconColorActivity;
  final Container validateText;

  @override
  State<BoxDecorationInput> createState() => _BoxDecorationInputState();
}

class _BoxDecorationInputState extends State<BoxDecorationInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.press,
          child: Container(
            width: double.infinity,
            height: 12.w,
            decoration: boxDecoration(
              widget.colorInput == null
                  ? AppColors.inputColor
                  : widget.colorInput,
              widget.colorBorder,
            ),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 9,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "${widget.icon}",
                          style: sIcon(
                            null,
                            widget.colorIcon == null
                                ? AppColors.black
                                : widget.colorIcon,
                          ),
                          // style: TextStyle(
                          //   fontFamily: '${widget.fontIcon}',
                          //   fontSize: 10.sp,
                          //   color: widget.colorIcon == null
                          //       ? AppColors.black
                          //       : widget.colorIcon,
                          // ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "${widget.text}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: inputTextNormal(
                            widget.colorText == null
                                ? AppColors.black
                                : widget.colorText,
                          ),
                          // style: TextStyle(
                          //   fontSize: 10.sp,
                          //   color: widget.colorText == null
                          //       ? AppColors.black
                          //       : widget.colorText,
                          // ),
                          // textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: widget.pressIconActivity,
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Text(
                          "${widget.iconActivity}" == null
                              ? ""
                              : "${widget.iconActivity}",
                          textAlign: TextAlign.end,
                          style: sIcon(
                              widget.fontFamily == null
                                  ? "FontAwesomePro-Regular"
                                  : widget.fontFamily,
                              widget.iconColorActivity == null
                                  ? AppColors.inputColor
                                  : widget.iconColorActivity),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
      decoration:
          boxDecoration(AppColors.greyOpacity, AppColors.white.withOpacity(0)),
    );
  }
}
