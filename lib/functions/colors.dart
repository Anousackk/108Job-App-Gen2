// ignore_for_file: constant_identifier_names, use_full_hex_values_for_flutter_colors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppColors {
  static Color neumorphismColor = Color(0xFFE7ECEF);

  static Color background = Color(0xf5f5f5f5);
  static Color backgroundWhite = Color(0xffFFFFFF);
  static Color backgroundGreyOpacity = Color(0xffDDDDDD);
  static Color backgroundSecond = HexColor("#0067BC");
  static Color backgroundAppBar = HexColor("#0067BC");

  static Color lightPrimary = HexColor("#E6F3FF");
  static Color lightGrayishCyan = HexColor("#E1FCFC");
  static Color lightOrange = HexColor("#FFF0E5");
  static Color lightGreen = HexColor("#E2EEE1");
  static Color lightDanger = HexColor("#FFEBEE");

  static Color inputLight = Color(0xffF1F3F6);
  static Color inputColor = Color(0xffEAEAEA);
  static Color inputWhite = Color(0xffFFFFFF);
  static Color inputGrey = Color(0xffDDDDDD);

  // static Color blue = Color(0xFF2558E8);
  static Color black = Color(0xFF000000);
  static Color opacityBlue = Color(0x0D0067BC);
  static Color greyShimmer = Color(0xffE0E0E0);
  static Color red = Color(0xFFDD2C00);

  static Color primary = HexColor("#0067BC");
  static Color info = Color(0xFFFDC527);
  static Color secondary = Color(0xffCDCDCD);
  static Color danger = Color(0xFFDD2C00);
  static Color warning = HexColor("#FF6D00");
  static Color success = HexColor("#3D8B35");
  static Color light = Color(0xffF1F3F6);
  static Color white = Color(0xffFFFFFF);
  static Color dark = Color(0xFF000000);
  static Color greyOpacity = Color(0xffDDDDDD);
  static Color greyWhite = Color(0xffEBEBEB);
  static Color grey = Color(0xff585858);
  static Color orange = HexColor("FF6D00");

  //border
  static Color borderBG = Color(0xf5f5f5f5);
  static Color borderSecondary = Color(0xEBEBEBEB);
  static Color borderGrey = Color(0xff585858);
  static Color borderWhite = Color(0xffFFFFFF);
  static Color borderDark = Color(0xFF000000);
  static Color borderPrimary = HexColor("#0067BC");
  static Color borderLightPrimary = HexColor("#E6F3FF");
  static Color borderDanger = Color(0xFFDD2C00);
  static Color borderGreyOpacity = Color(0xffDDDDDD);
  static Color borderInfo = Color(0xFFFDC527);
  static Color borderWaring = HexColor("#FF6D00");

  //font
  static Color fontPrimary = HexColor("#0067BC");
  static Color fontSecondary = Color(0xffCDCDCD);
  static Color fontGrey = Color(0xff585858);
  static Color fontGreyOpacity = Color(0xff888888);
  static Color fontWhite = Color(0xffFFFFFF);
  static Color fontDark = Color(0xFF000000);
  static Color fontDanger = Color(0xFFDD2C00);
  static Color fontWaring = HexColor("#FF6D00");
  static Color fontInfo = Color(0xFFFDC527);
  static Color fontSuccess = HexColor("#3D8B35");

  //icon
  static Color iconWarning = HexColor("#FF6D00");
  static Color iconInfo = Color(0xFFFDC527);
  static Color iconSuccess = HexColor("#3D8B35");
  static Color iconPrimary = HexColor("#0067BC");
  static Color iconGray = Color(0xff585858);
  static Color iconGrayOpacity = Color(0xff888888);
  static Color iconDark = Color(0xFF000000);
  static Color iconLight = Color(0xffFFFFFF);
  static Color iconDanger = Color(0xFFDD2C00);
  static Color iconSecondary = Color(0xffCDCDCD);

  //button
  static Color buttonGreyOpacity = Color(0xffDDDDDD);
  static Color buttonLightPrimary = Color(0xFFE1F5FE);
  static Color buttonPrimary = HexColor("#0067BC");
  static Color buttonSecondary = Color(0xffADADAD);
  static Color buttonDanger = Color(0xFFDD2C00);
  static Color buttonInfo = Color(0xFFFDC527);
  static Color buttonWarning = HexColor("#FF6D00");
  static Color buttonLightOrange = HexColor("#FFF0E5");

  static Color buttonGreyWhite = Color(0xffEBEBEB);
  static Color buttonGrey = Color(0xEBEBEBEB);
  static Color buttonWhite = Color(0xffFFFFFF);
  static Color buttonBG = Color(0xf5f5f5f5);

  //warning
  static Color warning600 = HexColor("#FDB913");
  static Color warning500 = HexColor("#FDC843");
  static Color warning400 = HexColor("#FEDD89");
  static Color warning300 = HexColor("#FEDD89");
  static Color warning200 = HexColor("#FEF1D0");
  static Color warning100 = HexColor("#FFF8E7");

  //success
  static Color success600 = HexColor("#006A43");
  static Color success500 = HexColor("#76C49E");
  static Color success400 = HexColor("#C6EFB6");
  static Color success300 = HexColor("#D7FEC8");
  static Color success200 = HexColor("#E8FEDF");
  static Color success100 = HexColor("#F9FFF6");

  //cyan
  static Color cyan600 = HexColor("#00E2E2");
  static Color cyan500 = HexColor("#5FEEEE");
  static Color cyan400 = HexColor("#92F4F4");
  static Color cyan300 = HexColor("#ADF7F7");
  static Color cyan200 = HexColor("#C8F9F9");
  static Color cyan100 = HexColor("#E3FCFC");

  //primary
  static Color primary600 = HexColor("#0067BC");
  static Color primary500 = HexColor("#97CDFF");
  static Color primary400 = HexColor("#B5DBFF");
  static Color primary300 = HexColor("#D3EAFF");
  static Color primary200 = HexColor("#E1F1FF");
  static Color primary100 = HexColor("#F0F8FF");

  //dark 900-100
  static Color dark600 = HexColor("#000000");
  static Color dark500 = HexColor("#7D7D7D");
  static Color dark400 = HexColor("#CCCCCC");
  static Color dark300 = HexColor("#D9D9D9");
  static Color dark200 = HexColor("#E6E6E6");
  static Color dark100 = HexColor("#F5F5F5");
}

class TextSize {
  static const Text textTitle = Text(
    '',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
  );
}
