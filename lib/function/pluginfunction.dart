import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/sized.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SharedPref {
  Future read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      return json.decode(prefs.getString(key)!);
    } catch (e) {
      return null;
    }
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      prefs.setString(key, json.encode(value));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  readDateTime(String key) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      return DateTime.fromMillisecondsSinceEpoch(
          json.decode(prefs.getString(key)!));
    } catch (e) {
      return null;
    }
  }

  saveDateTime(String key, DateTime value) async {
    int time = value.millisecondsSinceEpoch;

    final prefs = await SharedPreferences.getInstance();

    try {
      prefs.setString(key, json.encode(time));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  saveListstr(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      prefs.setStringList(key, value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  readListstr(String key) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      return prefs.getStringList(key);
    } catch (e) {
      return null;
    }
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      prefs.remove(key);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

Future pushPage(BuildContext context, page) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

Future upLoadDioResume(String filename, String url) async {
  try {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        filename,
        filename: filename.split("/").last,
      ),
    });

    Response response = await Dio().post(
      url,
      data: formData,
      onSendProgress: (count, total) {
        double resumePercent = count / total * 100;
        debugPrint(resumePercent.toString());
      },
    );

    Map responseBody = response.data;
    return responseBody;
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

// isEmptyList(List<String> listString) {
//   bool checking;
//   checking = listString == [] && listString == null;
//   return checking;
// }

isEmptyString(String? string) {
  bool checking;
  checking = '$string'.trim().isEmpty || string == null;
  return checking;
}

setShowFieldStudy(List? name, List? degree) {
  List<String> showfield = [];
  if (name != null) {
    int i = 0;
    for (var element in name) {
      showfield.add('${degree?[i]} - $element');
      i = i + 1;
    }
    return showfield;
  } else {
    return [];
  }
}

setShowLang(List? name, List? level) {
  List<String> showLanguage = [];
  if (name != null) {
    int i = 0;
    for (var element in name) {
      showLanguage.add('$element - ${level?[i]}');
      i = i + 1;
    }
    return showLanguage;
  } else {
    return [];
  }
}

Future showDialogPickerText(
    List<Widget> genderActions, BuildContext context, String title) async {
  await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('$title ',
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: 'PoppinsSemiBold')),
          cancelButton: CupertinoActionSheetAction(
            child: Text(l.cancel,
                style: const TextStyle(
                    // fontSize: 20,
                    color: Colors.red,
                    fontFamily: 'PoppinsSemiBold')),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          ),
          actions: genderActions,
        );
      });
}

lightIconFreeSizedColor(
    {required BuildContext context, Color? color, double? mediasSize}) {
  return TextStyle(
      color: color ?? Colors.black,
      fontSize: mediasSize == null
          ? mediaWidthSized(context, 15)
          : mediaWidthSized(context, mediasSize),
      fontFamily: 'FontAwesomeProLight');
}

regularIconFreeSizedColor(
    {required BuildContext context, Color? color, double? mediasSize}) {
  return TextStyle(
      color: color ?? Colors.black,
      fontSize: mediasSize == null
          ? mediaWidthSized(context, 15)
          : mediaWidthSized(context, mediasSize),
      fontFamily: 'FontAwesomeProRegular');
}

solidIconFreeSizedColor(
    {required BuildContext context, Color? color, double? mediasSize}) {
  return TextStyle(
      color: color ?? Colors.black,
      fontSize: mediasSize == null
          ? mediaWidthSized(context, 15)
          : mediaWidthSized(context, mediasSize),
      fontFamily: 'FontAwesomeProSolid');
}

textStyleBold(
    {required BuildContext context, required double size, Color? color}) {
  return TextStyle(
      color: color,
      fontFamily: 'PoppinsSemiBold',
      fontSize: mediaWidthSized(context, size));
}

textStyleRegular(
    {required BuildContext context, required double size, Color? color}) {
  return TextStyle(
      color: color,
      fontFamily: 'PoppinsRegular',
      fontSize: mediaWidthSized(context, size));
}

textStyleMedium(
    {required BuildContext context,
    bool? underLine,
    required double size,
    Color? color,
    bool? english}) {
  return TextStyle(
      decoration: underLine == null || underLine == false
          ? null
          : TextDecoration.underline,
      color: color,
      fontFamily: 'PoppinsMedium',
      fontSize: mediaWidthSized(context, size));
}

Future selectpicturefrom(BuildContext context, {onPress1, onPress2}) async {
  await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(l.choosepic,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: 'PoppinsSemiBold')),
          cancelButton: CupertinoActionSheetAction(
            child: Text(l.cancel,
                style: const TextStyle(
                  // fontSize: 20,
                  color: Colors.red,
                  // fontFamily: 'PoppinsSemiBold'
                )),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            CupertinoActionSheetAction(
                onPressed: onPress1,
                child: Text(l.camera,
                    style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.blue,
                        fontFamily: 'PoppinsMedium'))),
            CupertinoActionSheetAction(
                onPressed: onPress2,
                child: Text(l.gallery,
                    style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.blue,
                        fontFamily: 'PoppinsMedium'))),
          ],
        );
      });
}

Future upLoadDioImage(String filename, String url) async {
  try {
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(filename,
          filename: filename.split("/").last,
          contentType: MediaType('image', 'jpg')),
    });

    Response response = await Dio().post(
      url,
      data: formData,
      onSendProgress: (count, total) {
        double imagePercent = count / total * 100;
        debugPrint(imagePercent.toString());
      },
    );

    Map responseBody = response.data;
    return responseBody;
  } catch (e) {
    debugPrint(e.toString());
  }
}

seperateTranslate(List localList) {
  List list = [];
  for (var element in localList) {
    list.add(TranslateQuery.translateProvince(element));
  }
  return list;
}
