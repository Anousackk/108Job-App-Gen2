// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_field, prefer_final_fields, avoid_print, unused_local_variable, file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({Key? key, this.callBackSetLanguage}) : super(key: key);
  final Function(dynamic)? callBackSetLanguage;

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  String _isLocaleLanguage = "";
  // String _isLanguageApi = "";
  checkLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    var getLanguageSharePref = prefs.getString('setLanguage');
    var getLanguageApiSharePref = prefs.getString('setLanguageApi');

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
        // _isLanguageApi = 'LA';
      });
    } else if (Get.locale == Locale('en', 'US')) {
      setState(() {
        _isLocaleLanguage = 'en';
        // _isLanguageApi = 'EN';
      });
    }
    print("_isLocaleLanguage form Login: " + _isLocaleLanguage);
    // print("_isLanguageApi form Login: " + _isLanguageApi);
  }

  @override
  void initState() {
    super.initState();
    checkLanguage();
  }

  @override
  void dispose() {
    super.dispose();
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
                setState(() {
                  var langEng = Locale('en', 'US');
                  setLanguage(langEng, 'en', "EN");
                });
              },
              child: Container(
                width: 30,
                height: 30,
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
                setState(() {
                  var langLao = Locale('lo', 'LA');
                  setLanguage(langLao, 'lo', "LA");
                });
              },
              child: Container(
                width: 30,
                height: 30,
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

  setLanguage(lang, langString, langApi) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('setLanguage', langString);
    await prefs.setString('setLanguageApi', langApi);

    widget.callBackSetLanguage!("Set Language Success");
    print("Set Language Success");

    Get.updateLocale(lang);
    checkLanguage();

    setState(() {});
  }
}
