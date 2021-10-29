import 'package:flutter/material.dart';

import 'package:app/screen/ControlScreen/bottom_navigation.dart';

Future pushBottomNavigation(int page, BuildContext context) async {
  pageIndex = page;
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (BuildContext context) => const BottomNavigation()),
      (Route<dynamic> route) => false);
}
