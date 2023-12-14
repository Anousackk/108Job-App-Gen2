// ignore_for_file: file_names, prefer_if_null_operators, prefer_const_constructors, unnecessary_null_comparison

import 'package:app/functions/colors.dart';
import 'package:flutter/material.dart';

//appbar
TextStyle appbarTextSmall(Color? textColor) {
  return TextStyle(
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 13,
  );
}

TextStyle appbarTextNormal(Color? textColor) {
  return TextStyle(
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 15,
  );
}

TextStyle appbarTextMedium(Color? textColor) {
  return TextStyle(
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 20,
  );
}

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

//body
TextStyle bodyTextSmall(Color? textColor) {
  return TextStyle(
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 13,
  );
}

TextStyle bodyTextNormal(Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 15,
  );
}

TextStyle bodyTextMaxNormal(Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 17,
  );
}

TextStyle bodyTextMedium(Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 20,
  );
}

TextStyle bodyTextMaxMedium(Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 25,
  );
}

TextStyle bodyTextLarge(Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 35,
  );
}

TextStyle bodyTextMaxLarge(Color? textColor, FontWeight? fontWeight) {
  return TextStyle(
    fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 45,
  );
}

//botder
TextStyle botderTextNormal(Color? textColor) {
  return TextStyle(
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 15,
  );
}

//button
TextStyle buttonTextNormal(Color? textColor) {
  return TextStyle(
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 15,
  );
}

//input
TextStyle inputTextSmall(Color? textColor) {
  return TextStyle(
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 13,
  );
}

TextStyle inputTextNormal(Color? textColor) {
  return TextStyle(
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 15,
  );
}

//tabBar
TextStyle tabBarTextSmall(Color? textColor) {
  return TextStyle(
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 15,
  );
}

TextStyle tabBarTextNormal() {
  return TextStyle(
    fontSize: 15,
  );
}

//textValidate
TextStyle textValidateSmall(Color? textColor) {
  return TextStyle(
    color: textColor == null ? AppColors.fontDanger : textColor,
    fontSize: 12,
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
