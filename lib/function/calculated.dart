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
