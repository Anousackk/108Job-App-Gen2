// ignore_for_file: unused_local_variable, body_might_complete_normally_nullable, prefer_const_constructors, avoid_print, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, prefer_adjacent_string_concatenation, unnecessary_string_interpolations, await_only_futures, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:app/screen/screenAfterSignIn/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  loginWithFacebook(
      BuildContext context, dynamic fcmToken, dynamic modelName) async {
    print("press facebook");
    // FacebookAuth.instance.login();

    try {
      print("Login facebook try");
      //
      //
      //Alert dialog loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomLoadingLogoCircle();
        },
      );
      FacebookAuth.instance.login().then((value) {
        print("Fn login() then " + value.toString());

        if (value.status == LoginStatus.success) {
          print("Login status success");
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
                //
                //set token use shared preferences.
                // final prefs = await SharedPreferences.getInstance();
                // await prefs.setString('employeeToken', employeeToken);
                await SharedPrefsHelper.setString(
                    "employeeToken", employeeToken);

                var resAddToken = await postData(apiAddTokenSeeker, {
                  "notifyToken": [
                    {
                      "appToken": fcmToken,
                      "model": modelName,
                    }
                  ]
                });

                print("login facebook add token success: ${resAddToken}");

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                    (route) => false);
              }
            },
          );
        } else if (value.status == LoginStatus.cancelled) {
          print("Login status cancelled");
          Navigator.pop(context);
        } else {
          print(value.status);
          print(value.message);
          Navigator.pop(context);
        }
      });
    } catch (error) {
      print("Login facebokk catch");
      print(error);
      Navigator.pop(context);
    }
  }

  loginWithGoogle(
      BuildContext context, dynamic fcmToken, dynamic modelName) async {
    try {
      //
      //
      //Alert dialog loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomLoadingLogoCircle();
        },
      );

      print("Login google try");
      //Google Sign in
      // const scopes = <String>[
      //   'https://www.googleapis.com/auth/userinfo.email',
      //   'https://www.googleapis.com/auth/userinfo.profile	',
      // ];

      final googleSignIn = GoogleSignIn(scopes: ['email']);
      await googleSignIn.signOut(); // ensure fresh sign-in

      final GoogleSignInAccount? gUser = await googleSignIn.signIn();

      final FirebaseAuth _auth = FirebaseAuth.instance;

      print("Display GoogleSignInAccount");
      print(gUser);
      print(gUser?.id);
      print(gUser?.displayName);
      print(gUser?.email);

      if (gUser != null) {
        print("gUser isn't null");

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

        if (res["token"] != null) {
          var employeeToken = res["token"] ?? "";

          //
          //
          //set token use shared preferences.
          // final prefs = await SharedPreferences.getInstance();
          // await prefs.setString('employeeToken', employeeToken);

          await SharedPrefsHelper.setString("employeeToken", employeeToken);

          var resAddToken = await postData(apiAddTokenSeeker, {
            "notifyToken": [
              {
                "appToken": fcmToken,
                "model": modelName,
              }
            ]
          });

          print("login google add token success: ${resAddToken}");

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (route) => false);
        }
      } else {
        print("gUser is null");
        Navigator.pop(context);
      }
    } catch (error) {
      print("Login google catch");
      print(error);
      Navigator.pop(context);
    }
  }

  loginWithApple(
      BuildContext context, dynamic fcmToken, dynamic modelName) async {
    final firebaseAuth = FirebaseAuth.instance;
    try {
      print("Login apple try");

      //
      //
      //Alert dialog loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomLoadingLogoCircle();
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
        print("Credential userIdentifier isn't null");
        //
        //
        //set userIdentifier shared preferences.
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString(
        //   'appleUserIdentifier',
        //   credential.userIdentifier.toString(),
        // );
        await SharedPrefsHelper.setString(
          "appleUserIdentifier",
          credential.userIdentifier.toString(),
        );

        print("userIdentifier: " + "${credential.userIdentifier!}");
        appleSigninId = credential.userIdentifier.toString();
      } else {
        // final prefs = await SharedPreferences.getInstance();
        // appleSigninId = await prefs.getString("appleUserIdentifier");
        appleSigninId =
            await SharedPrefsHelper.getString("appleUserIdentifier");
      }

      if (credential.email != null) {
        //
        //
        //set userIdentifier shared preferences.
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('appleEmail', credential.email.toString());
        await SharedPrefsHelper.setString(
          "appleEmail",
          credential.email.toString(),
        );

        print("email: " + "${credential.email!}");
        appleSigninEmail = credential.email.toString();
      } else {
        // final prefs = await SharedPreferences.getInstance();
        // appleSigninEmail = await prefs.getString("appleEmail");
        appleSigninEmail = await SharedPrefsHelper.getString("appleEmail");
      }

      if (appleSigninId != null && appleSigninEmail != null) {
        var res = await postData(apiLoginWithApple, {
          "data": {
            "id": appleSigninId,
            // "displayName": gSignInDisplayName,
            "email": appleSigninEmail
          }
        });

        if (res["token"] != null) {
          var employeeToken = res["token"] ?? "";

          //
          //
          //set token use shared preferences.
          // final prefs = await SharedPreferences.getInstance();
          // await prefs.setString('employeeToken', employeeToken);
          await SharedPrefsHelper.setString("employeeToken", employeeToken);

          var resAddToken = await postData(apiAddTokenSeeker, {
            "notifyToken": [
              {
                "appToken": fcmToken,
                "model": modelName,
              }
            ]
          });

          print("login apple add token success: ${resAddToken}");

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
      print("Login apple catch");
      print(error);
      Navigator.pop(context);
    }
  }

  googleSignOut() async {
    await GoogleSignIn().signOut();

    // Disconnect instead of just signing out, to reset the example state as
    // much as possible.
    // await GoogleSignIn.instance.disconnect();
    print("Google sign out");
  }

  facebookSignOut() async {
    await FacebookAuth.instance.logOut();
    print("Facebook sign out");
  }

  appleSignOut() async {
    final firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut();
    print("Apple sign out");
  }

  loginSyncGoogleFacebook(
      BuildContext context, String type, Function(String val) callBack) async {
    //
    //
    //
    //Type Facebook
    if (type == "facebook") {
      print("sync facebook");

      //
      //
      //Alert dialog loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomLoadingLogoCircle();
        },
      );

      FacebookAuth.instance
          .login(permissions: ["public_profile", "email"]).then(
        (value) {
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
                callBack("Sync successfully");

                //close alert dialog loading
                if (res != null) {
                  Navigator.pop(context);
                }

                if (res["message"] == "Sync successfully") {
                  await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return NewVer2CustAlertDialogSuccessBtnConfirm(
                        title: "Facebook",
                        contentText: "Sync successfully".tr,
                        textButton: "ok".tr,
                        press: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                } else if (res["message"] == "Not found user info") {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return CustAlertDialogWarningWithoutBtn(
                        title: "warning".tr,
                        contentText: "Not found user info".tr,
                      );
                    },
                  );
                } else if (res["message"] ==
                    "This email already synced another account") {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return CustAlertDialogWarningWithoutBtn(
                        title: "warning".tr,
                        contentText:
                            "This email already synced another account".tr,
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
        },
      );
    }

    //
    //
    //
    //Type Google
    else if (type == "google") {
      print("sync google");

      //
      //
      //Alert dialog loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomLoadingLogoCircle();
        },
      );

      try {
        //Google Sign in
        final googleSignIn = GoogleSignIn(scopes: ['email']);
        await googleSignIn.signOut(); // ensure fresh sign-in

        final GoogleSignInAccount? gUser = await googleSignIn.signIn();

        print(gUser);
        print(gUser?.id);
        print(gUser?.displayName);
        print(gUser?.email);

        if (gUser != null) {
          print("gUser isn't null");
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
          callBack("Sync successfully");

          //close alert dialog loading
          if (res != null) {
            Navigator.pop(context);
          }

          if (res["message"] == "Sync successfully") {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return NewVer2CustAlertDialogSuccessBtnConfirm(
                  title: "Google",
                  contentText: "Sync successfully".tr,
                  textButton: "ok".tr,
                  press: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          } else if (res["message"] == "Not found user info") {
            await showDialog(
              context: context,
              builder: (context) {
                return CustAlertDialogWarningWithoutBtn(
                  title: "warning".tr,
                  contentText: "Not found user info".tr,
                );
              },
            );
          } else if (res["message"] ==
              "This email already synced another account") {
            await showDialog(
              context: context,
              builder: (context) {
                return CustAlertDialogWarningWithoutBtn(
                  title: "warning".tr,
                  contentText: "This email already synced another account".tr,
                );
              },
            );
          }
        } else {
          print("gUser is null");
          Navigator.pop(context);
        }
      } catch (error) {
        print("catch error");
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

        //
        //
        //Alert dialog loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return CustomLoadingLogoCircle();
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
          // final prefs = await SharedPreferences.getInstance();
          // await prefs.setString(
          //     'appleUserIdentifier', credential.userIdentifier.toString());
          await SharedPrefsHelper.setString(
            "appleUserIdentifier",
            credential.userIdentifier.toString(),
          );

          print("userIdentifier: " + "${credential.userIdentifier!}");
          appleSigninId = credential.userIdentifier.toString();
        } else {
          // final prefs = await SharedPreferences.getInstance();
          // appleSigninId = await prefs.getString("appleUserIdentifier");
          appleSigninId =
              await SharedPrefsHelper.getString("appleUserIdentifier");
        }

        if (credential.email != null) {
          //
          //
          //set userIdentifier shared preferences.
          // final prefs = await SharedPreferences.getInstance();
          // await prefs.setString('appleEmail', credential.email.toString());
          await SharedPrefsHelper.setString(
            "appleEmail",
            credential.email.toString(),
          );

          print("email: " + "${credential.email!}");
          appleSigninEmail = credential.email.toString();
        } else {
          // final prefs = await SharedPreferences.getInstance();
          // appleSigninEmail = await prefs.getString("appleEmail");
          appleSigninEmail = await SharedPrefsHelper.getString("appleEmail");
        }

        if (appleSigninId != null && appleSigninEmail != null) {
          var res = await postData(apiSyncGoogleFacebookAip, {
            "id": appleSigninId,
            "email": appleSigninEmail,
            "type": "apple",
          });
          callBack("Sync successfully");

          //close alert dialog loading
          if (res != null) {
            Navigator.pop(context);
          }

          if (res["message"] == "Sync successfully") {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return NewVer2CustAlertDialogSuccessBtnConfirm(
                  title: "Apple",
                  contentText: "Sync successfully".tr,
                  textButton: "ok".tr,
                  press: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          } else if (res["message"] == "Not found user info") {
            await showDialog(
              context: context,
              builder: (context) {
                return CustAlertDialogWarningWithoutBtn(
                  title: "warning".tr,
                  contentText: "Not found user info".tr,
                );
              },
            );
          } else if (res["message"] ==
              "This email already synced another account") {
            await showDialog(
              context: context,
              builder: (context) {
                return CustAlertDialogWarningWithoutBtn(
                  title: "warning".tr,
                  contentText: "This email already synced another account".tr,
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
