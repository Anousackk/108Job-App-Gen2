// ignore_for_file: unused_local_variable, body_might_complete_normally_nullable, prefer_const_constructors, avoid_print

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/screen/screenAfterSignIn/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  loginWithFacebook(BuildContext context) async {
    print("press facebook");
    // FacebookAuth.instance.login();

    try {
      print("try");
      //Alert dialog loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomAlertLoading();
        },
      );
      FacebookAuth.instance.login().then((value) {
        print(value);

        if (value.status == LoginStatus.success) {
          print("LoginStatus.success");
          final AccessToken accessToken = value.accessToken!;

          FacebookAuth.instance.getUserData().then(
            (userData) async {
              print("Display Facebook sign in");
              print(userData);
              print(userData['id']);
              print(userData['email']);
              print(userData['name']);
              print(userData["picture"]['data']['url']);

              var fSignInId = userData['id'];
              var fSignInEmail = userData['email'];
              // var fSignInDisplayName = userData['name'];
              Image.network(userData["picture"]['data']['url']);

              var res = await postData(apiLoginWithFacebook, {
                "data": {
                  "id": fSignInId,
                  // "displayName": fSignInDisplayName,
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
          Navigator.pop(context);
        } else {
          print(value.status);
          print(value.message);
          Navigator.pop(context);
        }
      });
    } catch (error) {
      print("catch");
      Navigator.pop(context);
    }
  }

  loginWithGoogle(BuildContext context) async {
    try {
      //Alert dialog loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomAlertLoading();
        },
      );
      print("try");
      //Google Sign in
      // const scopes = <String>[
      //   'https://www.googleapis.com/auth/userinfo.email',
      //   'https://www.googleapis.com/auth/userinfo.profile	',
      // ];

      final GoogleSignInAccount? gUser = await GoogleSignIn(
        scopes: ['email'],
      ).signIn();

      final FirebaseAuth _auth = FirebaseAuth.instance;

      print("Display GoogleSignInAccount");
      print(gUser);
      print(gUser?.id);
      print(gUser?.displayName);
      print(gUser?.email);

      if (gUser != null) {
        print("gUser != null");

        //obtaiin auth details from request
        final GoogleSignInAuthentication gAuth = await gUser.authentication;

        //create a new credential for user
        final credential = GoogleAuthProvider.credential(
          idToken: gAuth.idToken,
          accessToken: gAuth.accessToken,
        );

        // Sign in with the credential
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        print("user: " + "${user}");
        print("credential: " + "${credential}");

        var gSignInId = gUser.id;
        var gSignInEmail = gUser.email;
        // var gSignInDisplayName = gUser.displayName;

        var res = await postData(apiLoginWithGoogle, {
          "data": {
            "id": gSignInId,
            // "displayName": gSignInDisplayName,
            "email": gSignInEmail
          }
        });

        // close alert dialog loading
        if (res != null) {
          Navigator.pop(context);
        }

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
      } else {
        print("gUser == null");
        Navigator.pop(context);
      }
    } catch (error) {
      print("catch");
      Navigator.pop(context);
    }
  }

  loginWithApple(BuildContext context) async {
    final firebaseAuth = FirebaseAuth.instance;
    try {
      print("try");

      //Alert dialog loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomAlertLoading();
        },
      );

      //
      //
      //
      //Request Apple ID token and authorization code
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          // AppleIDAuthorizationScopes.fullName,
        ],
      );
      print("credential " + "${credential}");

      var appleSigninId;
      var appleSigninEmail;

      if (credential.userIdentifier != null) {
        //
        //
        //set userIdentifier shared preferences.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'appleUserIdentifier',
          credential.userIdentifier.toString(),
        );
        print("userIdentifier: " + "${credential.userIdentifier!}");
        appleSigninId = credential.userIdentifier.toString();
      } else {
        final prefs = await SharedPreferences.getInstance();
        appleSigninId = await prefs.getString("appleUserIdentifier");
      }

      if (credential.email != null) {
        //
        //
        //set userIdentifier shared preferences.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('appleEmail', credential.email.toString());
        print("email: " + "${credential.email!}");
        appleSigninEmail = credential.email.toString();
      } else {
        final prefs = await SharedPreferences.getInstance();
        appleSigninEmail = await prefs.getString("appleEmail");
      }

      if (appleSigninId != null && appleSigninEmail != null) {
        var res = await postData(apiLoginWithApple, {
          "data": {
            "id": appleSigninId,
            // "displayName": gSignInDisplayName,
            "email": appleSigninEmail
          }
        });

        print(res);

        // close alert dialog loading
        if (res != null) {
          Navigator.pop(context);
        }

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
      }

      // print(credential.toString());
      // if (credential.givenName != null) {
      //   print("firstName: " + "${credential.givenName!}");
      // }

      // if (credential.familyName != null) {
      //   print("lastName: " + "${credential.familyName!}");
      // }
    } catch (error) {
      print(error);
      print("catch");
      Navigator.pop(context);
    }
  }

  googleSignOut() async {
    await GoogleSignIn().signOut();
  }

  facebookSignOut() async {
    await FacebookAuth.instance.logOut();
  }

  appleSignOut() async {
    final firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut();
    print("Apple SignOut");
  }

  loginSyncGoogleFacebook(
      BuildContext context, String type, Function(String val) callBack) async {
    //
    //
    //
    //Type Facebook
    if (type == "facebook") {
      print("sync facebook");

      //Alert dialog loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomAlertLoading();
        },
      );

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
              callBack(res['message']);

              //close alert dialog loading
              if (res != null) {
                Navigator.pop(context);
              }

              if (res["message"] == "Sync successful") {
                await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return CustomAlertDialogSuccessButtonConfirm(
                      title: "Connect Facebook Success",
                      text: res["message"],
                      textButton: "ok".tr,
                      press: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              } else {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return CustomAlertDialogWarningWithoutButton(
                      title: "Warning",
                      text: res["message"],
                      textButton: "ok".tr,
                      press: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              }
            },
          );
        } else if (value.status == LoginStatus.cancelled) {
          Navigator.pop(context);
          print("LoginStatus.cancelled");
        }
      });
    }

    //
    //
    //
    //Type Google
    else if (type == "google") {
      print("sync google");

      //Alert dialog loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomAlertLoading();
        },
      );

      try {
        //Google Sign in
        final GoogleSignInAccount? gUser = await GoogleSignIn(
          scopes: [
            'email',
          ],
        ).signIn();

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
          print("Display Sync GoogleAuthProvider");
          print(credential);

          var gSignInId = gUser.id;
          var gSignInEmail = gUser.email;
          var gSignInDisplayName = gUser.displayName;

          var res = await postData(apiSyncGoogleFacebookAip, {
            "id": gSignInId,
            "email": gSignInEmail,
            "type": "google",
          });
          callBack(res['message']);

          //close alert dialog loading
          if (res != null) {
            Navigator.pop(context);
          }

          if (res["message"] == "Sync successful") {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return CustomAlertDialogSuccessButtonConfirm(
                  title: "Connect Google Success",
                  text: res["message"],
                  textButton: "ok".tr,
                  press: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          } else {
            await showDialog(
              context: context,
              builder: (context) {
                return CustomAlertDialogWarningWithoutButton(
                  title: "Warning",
                  text: res["message"],
                  press: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        } else {
          Navigator.pop(context);
        }
      } catch (error) {
        Navigator.pop(context);
      }
    }

    //
    //
    //
    //Type Apple
    else if (type == "apple") {
      final firebaseAuth = FirebaseAuth.instance;

      try {
        print("sync apple");

        //Alert dialog loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return CustomAlertLoading();
          },
        );

        //
        //
        //
        //Request Apple ID token and authorization code
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            // AppleIDAuthorizationScopes.fullName,
          ],
        );

        var appleSigninId;
        var appleSigninEmail;

        if (credential.userIdentifier != null) {
          //
          //
          //set userIdentifier shared preferences.
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'appleUserIdentifier', credential.userIdentifier.toString());
          print("userIdentifier: " + "${credential.userIdentifier!}");
          appleSigninId = credential.userIdentifier.toString();
        } else {
          final prefs = await SharedPreferences.getInstance();
          appleSigninId = await prefs.getString("appleUserIdentifier");
        }

        if (credential.email != null) {
          //
          //
          //set userIdentifier shared preferences.
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('appleEmail', credential.email.toString());
          print("email: " + "${credential.email!}");
          appleSigninEmail = credential.email.toString();
        } else {
          final prefs = await SharedPreferences.getInstance();
          appleSigninEmail = await prefs.getString("appleEmail");
        }

        if (appleSigninId != null && appleSigninEmail != null) {
          var res = await postData(apiSyncGoogleFacebookAip, {
            "id": appleSigninId,
            "email": appleSigninEmail,
            "type": "apple",
          });
          callBack(res['message']);

          //close alert dialog loading
          if (res != null) {
            Navigator.pop(context);
          }

          if (res["message"] == "Sync successful") {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return CustomAlertDialogSuccessButtonConfirm(
                  title: "Connect Apple Success",
                  text: res["message"],
                  textButton: "ok".tr,
                  press: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          } else {
            await showDialog(
              context: context,
              builder: (context) {
                return CustomAlertDialogWarningWithoutButton(
                  title: "Warning",
                  text: res["message"],
                  press: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        } else {
          Navigator.pop(context);
        }
      } catch (error) {
        Navigator.pop(context);
      }
    }
  }
}

//"Sync successful"