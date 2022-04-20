import 'dart:async';
import 'dart:io';

import 'package:app/api/rest_api.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:app/function/pluginfunction.dart';

import 'firebasenotification.dart';

String? currentToken;
String? notifyToken;
String? deviceID;
bool firebaseRun = false;
bool isCheckedDevice = false;
Future<String?> getDeviceID() async {
  var deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
}

sendNotifyToken() {
  getDeviceID().then((value) {
    deviceID = value.toString();
    debugPrint(value.toString());
    debugPrint(currentToken);
    debugPrint('will set api: ' +
        (currentToken != null &&
                notifyToken != null &&
                isCheckedDevice == false)
            .toString());
    Future.delayed(const Duration(seconds: 3)).then((empty) async {
      if (currentToken != null &&
          notifyToken != null &&
          isCheckedDevice == false) {
        await postAPI(addtoken, {
          "notifyToken": [
            {"appToken": notifyToken, "model": value}
          ]
        }).then((value) {
          if (currentToken != null &&
              notifyToken != null &&
              isCheckedDevice == false) {
            isCheckedDevice = true;
          }

          debugPrint(value.toString());
        });
      }
    });
  });
}

class AuthUtil {
  String? token;
  Future getToken() async {
    try {
      var reading = await SharedPref().read('token');
      token = reading;
    } catch (e) {
      token = null;
      debugPrint(e.toString());
    }
  }

  FirebaseNotifcation firebase = FirebaseNotifcation();
  Future handleAsync() async {
    firebaseRun = true;
    await firebase.initialize();
    notifyToken = await firebase.getToken();
    debugPrint("Firebase token : $notifyToken");
  }

  Future<String?> buildgetTokenAndLang() async {
    if (firebaseRun == false) {
      await handleAsync();
    }

    try {
      var reading = await SharedPref().read('token');
      token = reading;
      currentToken = reading;

      return token!;
    } catch (e) {
      return null;
    }
  }

  static Future setToken(value) async {
    try {
      return await SharedPref().save('token', value);
    } catch (e) {
      return null;
    }
  }

  Future removeToken() async {
    try {
      return await SharedPref().remove('token');
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
