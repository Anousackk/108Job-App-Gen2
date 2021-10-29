import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:app/function/pluginfunction.dart';

import 'firebasenotification.dart';

String? currentToken;
String? notifyToken;
bool firebaseRun = false;

class AuthUtil {
  String? token;
  Future getToken() async {
    try {
      var reading = await SharedPref().read('token');
      token = reading;
    } catch (e) {
      token = "null";
      debugPrint(e.toString());
    }
  }

  FirebaseNotifcation firebase = FirebaseNotifcation();
  Future handleAsync() async {
    await firebase.initialize();
    notifyToken = await firebase.getToken();
    debugPrint("Firebase token : $notifyToken");
    firebaseRun = true;
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
