// import 'package:flutter/material.dart';

// import 'package:flutter/material.dart';

class CutDateString {
  cutDateString(String? date) {
    int cutoff = 10;
    return date != null
        ? rePositionDMY(
            (date.length <= cutoff) ? date : date.substring(0, cutoff))
        : '';
  }

  rePositionDMY(String? date) {
    String? year, month, day;
    year = date?.substring(0, 4);
    month = date?.substring(5, 7);
    day = date?.substring(8, 10);
    return '$day-$month-$year';
  }

  rePositionYMD(String? date) {
    String? year, month, day;
    year = date?.substring(6, 10);
    month = date?.substring(3, 5);
    day = date?.substring(0, 2);
    return '$year-$month-$day';
  }
}

// bool myJobSave = false;
// bool SavedIsChange(
//     List<bool?> getter, List<dynamic> repositories, String mapper) {
//   bool checker = false;
//   int index = 0;
//   debugPrint('doing function chechsaved');
//   if (getter.length == repositories.length) {
//     for (var element in repositories) {
//       if (element[mapper] != getter[index]) {
//         checker = true;
//       }
//       index = index + 1;
//     }
//   }
//   debugPrint('return checker: ' + checker.toString());
//   return checker;
// }
