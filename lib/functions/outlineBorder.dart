// ignore_for_file: file_names, unused_import

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

OutlineInputBorder enableOutlineBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(2.w),
    borderSide: BorderSide(
      color: color,
    ),
  );
}

OutlineInputBorder focusOutlineBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(2.w),
    borderSide: BorderSide(
      color: color,
    ),
  );
}

BoxDecoration boxDecoration(Color? color, Color borderColor) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(1.5.w),
    border: Border.all(
      color: borderColor,
    ),
    color: color,
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
