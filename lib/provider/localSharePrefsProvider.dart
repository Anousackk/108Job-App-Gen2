import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:flutter/material.dart';

class LocalSharedPrefsProvider extends ChangeNotifier {
  String localLanguage = "";
  localLanguageFromSharedPreference() async {
    // var getLanguageSharePref = await SharedPrefsHelper.getString("setLanguage");
    var getLanguageApiSharePref =
        await SharedPrefsHelper.getString("setLanguageApi");

    localLanguage = getLanguageApiSharePref.toString();
    notifyListeners();

    return localLanguage;
  }
}
