// ignore_for_file: unused_local_variable, body_might_complete_normally_nullable, prefer_const_constructors, avoid_print

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/screen/screenAfterSignIn/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  loginWithFacebook(BuildContext context) async {
    FacebookAuth.instance
        .login(permissions: ["public_profile", "email"]).then((value) {
      print(value);

      if (value.status == LoginStatus.success) {
        print("LoginStatus.success");

        FacebookAuth.instance.getUserData().then(
          (userData) async {
            print("Display Facebook sign in");
            print(userData);
            print(userData['id']);
            print(userData['email']);
            print(userData['name']);
            var fSignInId = userData['id'];
            var fSignInEmail = userData['email'];
            var fSignInDisplayName = userData['name'];

            var res = await postData(apiLoginWithFacebook, {
              "data": {
                "id": fSignInId,
                "displayName": fSignInDisplayName,
                "email": fSignInEmail
              }
            });

            if (res["token"] != null) {
              var employeeToken = res["token"] ?? "";

              //
              //set token use shared preferences.
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('employeeToken', employeeToken);

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (route) => false);
            }
          },
        );
      } else if (value.status == LoginStatus.cancelled) {
        print("LoginStatus.cancelled");
      }
    });
  }

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

    if (gUser != null) {
      //obtaiin auth details from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

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

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      }
    } else {
      Navigator.pop(context);
    }
  }

  loginSyncGoogleFacebook(BuildContext context, String type,
      Function(bool success) callback) async {
    //
    //
    //Type Facebook
    if (type == "facebook") {
      FacebookAuth.instance
          .login(permissions: ["public_profile", "email"]).then((value) {
        print(value);

        if (value.status == LoginStatus.success) {
          print("LoginStatus.success");

          FacebookAuth.instance.getUserData().then(
            (userData) async {
              print("Display Facebook sign in");
              print(userData);
              print(userData['id']);
              print(userData['email']);
              print(userData['name']);
              var fSignInId = userData['id'];
              var fSignInEmail = userData['email'];
              var fSignInDisplayName = userData['name'];

              var res = await postData(apiSyncGoogleFacebookAip, {
                "id": fSignInId,
                "email": fSignInEmail,
                "type": "facebook",
              });

              if (res["message"] == "Sync successful") {
                callback(true);
              } else {
                callback(false);
              }
            },
          );
        } else if (value.status == LoginStatus.cancelled) {
          print("LoginStatus.cancelled");
        }
      });
      //
      //
      //Type Google
    } else if (type == "google") {
      //Google Sign in
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      print("Display GoogleSignInAccount");
      print(gUser);
      print(gUser?.id);
      print(gUser?.displayName);
      print(gUser?.email);

      if (gUser != null) {
        //obtaiin auth details from request
        final GoogleSignInAuthentication gAuth = await gUser.authentication;

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

        var res = await postData(apiSyncGoogleFacebookAip, {
          "id": gSignInId,
          "email": gSignInEmail,
          "type": "google",
        });

        if (res["message"] == "Sync successful") {
          callback(true);
        } else {
          callback(false);
        }
      }
    }
  }
}
