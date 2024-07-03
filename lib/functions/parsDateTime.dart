// ignore_for_file: unused_element, avoid_print, prefer_const_constructors, file_names

import 'package:intl/intl.dart';

parsDateTime(
    {required value,
    required String currentFormat,
    required String desiredFormat,
    isUtc = false}) {
  DateTime? dateTimeFormat = DateTime.now();
  DateTime? dateTime;
  if (value != null || value.isNotEmpty) {
    try {
      dateTimeFormat = DateFormat(currentFormat).parse(value, isUtc).toLocal();
      dateTime = dateTimeFormat.add(Duration(hours: 7)); // +7 hours
    } catch (e) {
      print("$e");
    }
  }
  return dateTime;
}

formatDate(dateTime) => DateFormat("dd/MM/yyyy").format(dateTime);
formatDayMMMYear(dateTime) => DateFormat("dd/MMM/yyyy").format(dateTime);

formatYMD(dateTime) => DateFormat("yyyy-MM-dd").format(dateTime);

formatDateTime(dateTime) => DateFormat("d-M-yyyy HH:mm:ss").format(dateTime);
formatDateHourMinuts(dateTime) =>
    DateFormat("dd/MM/yyyy, HH:mm").format(dateTime);
formatYearMonthToDisplay(dateTime) => DateFormat("yy/MM").format(dateTime);

formatYearMonth(dateTime) => DateFormat("yyyy/MM").format(dateTime);
formatMonthYear(dateTime) => DateFormat("MM/yyyy").format(dateTime);

formatYear(dateTime) => DateFormat("yyyy").format(dateTime);

formatTimeAddDatabase(dateTime) => DateFormat("HHmm").format(dateTime);
formatTimeDisplay(dateTime) => DateFormat("HH:mm").format(dateTime);
