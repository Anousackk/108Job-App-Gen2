// ignore_for_file: file_names, prefer_if_null_operators, prefer_const_constructors, unnecessary_null_comparison

import 'package:app/functions/colors.dart';
import 'package:flutter/material.dart';

//
//
//
//appbar
TextStyle appbarTextSmall(Color? textColor) {
  return TextStyle(
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 13,
  );
}

TextStyle appbarTextNormal(Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    color: textColor == null ? AppColors.fontDark : textColor,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    fontSize: 15,
  );
}

TextStyle appbarTextMedium(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    fontSize: 20,
  );
}

//
//
//
//header
TextStyle headerTextNormal(Color? textColor) {
  return TextStyle(
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 15,
  );
}

TextStyle headerTextMediuml(Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 20,
  );
}

TextStyle bodyTitleNormal(Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 18,
  );
}

//
//
//
//
//
//body

TextStyle bodyTextMiniSmall(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 11,
  );
}

TextStyle bodyTextSmall(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 12,
  );
}

TextStyle bodyTextMaxSmall(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 13,
  );
}

TextStyle bodyTextMinNormal(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 14,
  );
}

TextStyle bodyTextNormal(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 15,
  );
}

TextStyle bodyTextMaxNormal(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 16,
  );
}

TextStyle bodyTextSuperMaxNormal(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 17,
  );
}

TextStyle bodyTextMiniMedium(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 18,
  );
}

TextStyle bodyTextMedium(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 20,
  );
}

TextStyle bodyTextMaxMedium(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 25,
  );
}

TextStyle bodyTextSuperMaxMedium(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 30,
  );
}

TextStyle bodyTextLarge(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 35,
  );
}

TextStyle bodyTextMaxLarge(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 45,
  );
}

//
//
//
//botder
TextStyle botderTextNormal(Color? textColor) {
  return TextStyle(
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 15,
  );
}

//
//
//
//
//
//button
TextStyle buttonTextSmall(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 12,
  );
}

TextStyle buttonTextMaxSmall(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 13,
  );
}

TextStyle buttonTextMinNormal(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 14,
  );
}

TextStyle buttonTextNormal(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 15,
  );
}

TextStyle buttonTextMaxNormal(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 16,
  );
}

TextStyle buttonTextSuperMaxNormal(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 17,
  );
}

TextStyle buttonTextMiniMedium(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 18,
  );
}

TextStyle buttonTextMedium(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 20,
  );
}

TextStyle buttonTextMaxMedium(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 25,
  );
}

TextStyle buttonTextLarge(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 35,
  );
}

TextStyle buttonTextMaxLarge(
    String? fontFamily, Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 45,
  );
}

//
//
//
//input
TextStyle inputTextSmall(String? fontFamily, Color? textColor) {
  return TextStyle(
    fontFamily: fontFamily,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 13,
  );
}

TextStyle inputTextMiniNormal(String? fontFamily, Color? textColor) {
  return TextStyle(
    fontFamily: fontFamily,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 14,
  );
}

TextStyle inputTextNormal(String? fontFamily, Color? textColor) {
  return TextStyle(
    fontFamily: fontFamily,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 15,
  );
}

TextStyle inputTextMaxNormal(String? fontFamily, Color? textColor) {
  return TextStyle(
    fontFamily: fontFamily,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 16,
  );
}

//
//
//
//tabBar
TextStyle tabBarTextSmall(Color? textColor) {
  return TextStyle(
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 15,
  );
}

TextStyle tabBarTextNormal(FontWeight? fontWeight) {
  return TextStyle(
    fontSize: 15,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
  );
}

//textValidate
TextStyle textValidateSmall(Color? textColor) {
  return TextStyle(
    color: textColor == null ? AppColors.fontDanger : textColor,
    fontSize: 12,
  );
}

//
//
//
//Font Awesome
TextStyle fontAwesomeSolid(String? fontFamily, double? fontSize, Color? color,
    FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily == null ? "FontAwesomeSolid" : fontFamily,
    fontSize: fontSize == null ? 15 : fontSize,
    color: color == null ? AppColors.iconDark : color,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
  );
}

TextStyle fontAwesomeRegular(String? fontFamily, double? fontSize, Color? color,
    FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily == null ? "FontAwesomeRegular" : fontFamily,
    fontSize: fontSize == null ? 15 : fontSize,
    color: color == null ? AppColors.iconDark : color,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
  );
}

TextStyle fontAwesomeLight(String? fontFamily, double? fontSize, Color? color,
    FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily == null ? "FontAwesomeLight" : fontFamily,
    fontSize: fontSize == null ? 15 : fontSize,
    color: color == null ? AppColors.iconDark : color,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
  );
}

TextStyle fontAwesomeBrands(String? fontFamily, double? fontSize, Color? color,
    FontWeight? fontWeight) {
  return TextStyle(
    fontFamily: fontFamily == null ? "FontAwesomeBrands" : fontFamily,
    fontSize: fontSize == null ? 15 : fontSize,
    color: color == null ? AppColors.iconDark : color,
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
  );
}

class FontSize {
  //appbar
  static const double appbarTextSmall = 13;
  static const double appbarTextNormal = 15;
  static const double appbarTextMedium = 20;

//body
  static const double bodyTextSmall = 13;
  static const double bodyTextNormal = 15;
  static const double bodyTextMaxNormal = 17;
  static const double bodyTextMedium = 20;
  static const double bodyTextMaxMedium = 25;
  static const double bodyTextLarge = 35;
  static const double bodyTextMaxLarge = 45;

  //border
  static const double botderTextNormal = 15;

  //button
  static const double buttonTextNormal = 15;

  //input
  static const double inputTextSmall = 13;
  static const double inputTextNormal = 15;

  //tabBar
  static const double tabBarTextSmall = 15;
  static const double tabBarTextNormal = 15;
}
