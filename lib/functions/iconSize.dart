// ignore_for_file: prefer_if_null_operators

import 'package:app/functions/colors.dart';
import 'package:flutter/material.dart';

TextStyle xsIcon(String? fontFamily, Color? textColor) {
  return TextStyle(
    fontFamily: fontFamily == null ? "FontAwesomePro-Regular" : fontFamily,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 15,
  );
}

TextStyle sIcon(String? fontFamily, Color? textColor) {
  return TextStyle(
    fontFamily: fontFamily == null ? "FontAwesomePro-Light" : fontFamily,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 20,
  );
}

TextStyle mIcon(String? fontFamily, Color? textColor) {
  return TextStyle(
    fontFamily: fontFamily == null ? "FontAwesomePro-Regular" : fontFamily,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 30,
  );
}

TextStyle lIcon(String? fontFamily, Color? textColor) {
  return TextStyle(
    fontFamily: fontFamily == null ? "FontAwesomePro-Regular" : fontFamily,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 40,
  );
}

TextStyle xlIcon(String? fontFamily, Color? textColor) {
  return TextStyle(
    fontFamily: fontFamily == null ? "FontAwesomePro-Regular" : fontFamily,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 50,
  );
}

TextStyle xxlIcon(String? fontFamily, Color? textColor) {
  return TextStyle(
    fontFamily: fontFamily == null ? "FontAwesomePro-Regular" : fontFamily,
    color: textColor == null ? AppColors.fontDark : textColor,
    fontSize: 80,
  );
}

class IconSize {
  static const double xsIcon = 15;
  static const double sIcon = 20;
  static const double mIcon = 25;
  static const double lIcon = 30;
  static const double xlIcon = 35;
  static const double xxlIcon = 40;
  static const double xxxlIcon = 45;
  static const double xxxxlIcon = 50;
}
