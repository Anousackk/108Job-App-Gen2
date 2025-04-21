import 'package:app/functions/colors.dart';
import 'package:flutter/material.dart';

Widget shimmerBox(
    {required double height,
    required double width,
    BorderRadiusGeometry? borderRadius}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: AppColors.backgroundWhite,
      borderRadius: borderRadius ?? BorderRadius.circular(5),
    ),
  );
}
