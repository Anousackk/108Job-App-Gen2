// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'package:app/functions/api.dart';
import 'package:flutter/material.dart';

class GlobalSettingProvider extends ChangeNotifier {
  // Private Variables
  bool _isHideBoothCheckIn = false;

  // Getters
  bool get isHideBoothCheckIn => _isHideBoothCheckIn;

  //
  // Setters
  set isHideBoothCheckIn(bool value) {
    _isHideBoothCheckIn = value;
    notifyListeners();
  }

  fetchGlobalSetting() async {
    try {
      var res = await fetchData(apiGlobalSetting);
      if (res != null && res is Map) {
        _isHideBoothCheckIn =
            res['globalSetting']['isHideBoothCheckIn'] as bool? ?? false;
      }

      notifyListeners();
      print("Fetch Global Setting: $_isHideBoothCheckIn");
    } catch (e) {
      print("Fetch Global Setting error: $e");
    }
  }
}
