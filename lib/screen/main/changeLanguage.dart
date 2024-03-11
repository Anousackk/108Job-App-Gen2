// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_field, prefer_final_fields, avoid_print, unused_local_variable
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
    final prefs = await SharedPreferences.getInstance();
    var getLanguageSharePref = prefs.getString('setLanguage');

    // if (getLanguageSharePref == 'lo') {
    //   setState(() {
    //     _isLocaleLanguage = 'lo';
    //   });
    // } else if (getLanguageSharePref == 'en') {
    //   setState(() {
    //     _isLocaleLanguage = 'en';
    //   });
    // }

    if (Get.locale == Locale('lo', 'LA')) {
      setState(() {
        _isLocaleLanguage = 'lo';
      });
    } else if (Get.locale == Locale('en', 'US')) {
      setState(() {
        _isLocaleLanguage = 'en';
      });
    }
    print("Navbar: " + _isLocaleLanguage);
  }

  @override
  void initState() {
    super.initState();
    checkLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //
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
                width: 40,
                height: 40,
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
                width: 40,
                height: 40,
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
