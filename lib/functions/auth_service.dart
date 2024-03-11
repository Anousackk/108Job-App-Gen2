// ignore_for_file: unused_local_variable, body_might_complete_normally_nullable, prefer_const_constructors

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/screen/screenAfterSignIn/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  loginWithGoogle(BuildContext context) async {
    //Alert dialog loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertLoading();
      },
    );

    //Google Sign in
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    print("Display GoogleSignInAccount");
    print(gUser);
    print(gUser?.id);
    print(gUser?.displayName);
    print(gUser?.email);

    //obtaiin auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
      idToken: gAuth.idToken,
      accessToken: gAuth.accessToken,
    );
    print("Display GoogleAuthProvider");
    print(credential);

    var gSignInId = gUser.id;
    var gSignInEmail = gUser.email;
    var gSignInDisplayName = gUser.displayName;

    var res = await postData(apiLoginWithGoogle, {
      "data": {
        "id": gSignInId,
        "displayName": gSignInDisplayName,
        "email": gSignInEmail
      }
    });

    //close alert dialog loading
    if (res != null) {
      Navigator.pop(context);
    }

    if (res["token"] != null) {
      var employeeToken = res["token"] ?? "";

      //
      //set token use shared preferences.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('employeeToken', employeeToken);

      //Next to Home screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }

    //finally, lets sign in

    // return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
