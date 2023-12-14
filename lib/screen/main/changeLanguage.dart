// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_field, prefer_final_fields, avoid_print
import 'package:app/functions/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({Key? key}) : super(key: key);

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  String _isLocaleLanguage = "";
  checkLanguage() async {
    if (Get.locale == Locale('lo', 'LA')) {
      _isLocaleLanguage = 'lo';
    } else if (Get.locale == Locale('en', 'US')) {
      _isLocaleLanguage = 'en';
    }
    print(_isLocaleLanguage);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isLocaleLanguage == 'lo')
            GestureDetector(
              onTap: () {
                var langEng = Locale('en', 'US');
                setLanguage(langEng, 'en');
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/image/eng.png'),
                  ),
                ),
              ),
            ),
          if (_isLocaleLanguage == 'en')
            GestureDetector(
              onTap: () {
                var langLao = Locale('lo', 'LA');
                setLanguage(langLao, 'lo');
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/image/lao.png'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  setLanguage(lang, langString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('setLanguage', langString);

    Get.updateLocale(lang);
    checkLanguage();
  }
}
