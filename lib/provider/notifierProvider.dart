import 'package:flutter/material.dart';

class NotifierProvider extends ChangeNotifier {
  String _profileImage = "";

  String get profileImamge => _profileImage;

  void setValueNotifierProvider(String newValue) {
    _profileImage = newValue;
    notifyListeners(); // Notify listeners of the change
  }
}
