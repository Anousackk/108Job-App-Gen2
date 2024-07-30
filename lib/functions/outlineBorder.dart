// ignore_for_file: file_names, unused_import, prefer_if_null_operators

import 'package:app/functions/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

OutlineInputBorder enableOutlineBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(1.5.w),
    borderSide: BorderSide(
      color: color,
    ),
  );
}

OutlineInputBorder focusOutlineBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(1.5.w),
    borderSide: BorderSide(
      color: color,
    ),
  );
}

BoxDecoration boxDecoration(BorderRadiusGeometry? borderRadius, Color? color,
    Color? borderColor, double? borderWidth) {
  return BoxDecoration(
    borderRadius:
        borderRadius == null ? BorderRadius.circular(20) : borderRadius,
    color: color == null ? AppColors.greyOpacity : color,
    border: Border.all(
        color: borderColor == null
            ? AppColors.borderGrey.withOpacity(0)
            : borderColor,
        width: borderWidth == null ? 1 : borderWidth),
  );
}

// BoxDecoration boxDecorationBorderStyle(Color borderColor) {
//   return BoxDecoration(
//     border: Border.all(
//       color: borderColor,
//       width: 1,
//       style: BorderStyle.solid,
//     ),
//   );
// }

BoxDecoration boxDecorationImage(Color color, DecorationImage image) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(1.5.w),
    color: color,
    image: image,
  );
}

BoxDecoration boxDecorationProfileImage(Color color, DecorationImage image) {
  return BoxDecoration(
    // borderRadius: BorderRadius.circular(1.5.w),
    shape: BoxShape.circle,
    color: color,
    image: image,
  );
}

BoxDecoration boxDecorationIcon(Color color, Color borderColor) {
  return BoxDecoration(
    // borderRadius: BorderRadius.circular(1.5.w),
    shape: BoxShape.circle,
    color: color,
    border: Border.all(color: borderColor),
  );
}
