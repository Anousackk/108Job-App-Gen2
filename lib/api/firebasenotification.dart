import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../screen/ControlScreen/bottom_navigation.dart';
import '../screen/job_detail_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  debugPrint("Handling a background message : ${message.messageId}");
  debugPrint(message.data.toString());
}

Map modifyNotiJson(Map<String, dynamic> message) {
  message['data'] = Map.from(message);
  message['notification'] = message['aps']['alert'];
  return message;
}

class FirebaseNotifcation {
  initialize() async {
    debugPrint('do init firebase');

    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    try {
      if (Platform.isIOS) {
        NotificationSettings settings =
            await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          debugPrint('User granted permission');
        } else if (settings.authorizationStatus ==
            AuthorizationStatus.provisional) {
          debugPrint('User granted provisional permission');
        } else {
          debugPrint('User declined or has not accepted permission');
        }
      }
    } catch (e) {
      debugPrint('eieiekuy' + e.toString());
    }
    // FirebaseMessaging.onMessageOpenedApp.listen((event) {

    // });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        if (message.data['screen'] == 'Jobpage') {
          if (navState.currentState != null) {
            navState.currentState!.push(MaterialPageRoute(
                builder: (_) => JobDetailPage(
                      jobID: message.data['id'].toString(),
                    )));
          }
        }
        if (message.data['screen'] == 'CVpage') {
          if (navState.currentState != null) {
            pageIndex = 4;
            pageController = PageController(keepPage: true, initialPage: 4);
            Navigator.pushNamedAndRemoveUntil(navState.currentState!.context,
                '/', (Route<dynamic> route) => false);
          }
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['screen'] == 'Jobpage') {
        if (navState.currentState != null) {
          navState.currentState!.push(MaterialPageRoute(
              builder: (_) => JobDetailPage(
                    jobID: message.data['id'].toString(),
                  )));
        }
      }
      if (message.data['screen'] == 'CVpage') {
        if (navState.currentState != null) {
          pageIndex = 4;
          pageController = PageController(keepPage: true, initialPage: 4);
          Navigator.pushNamedAndRemoveUntil(navState.currentState!.context, '/',
              (Route<dynamic> route) => false);
        }
      }
    });
  }

// '@drawable/splash'
  Future<String?> getToken() async {
    debugPrint('try get token from firebase: ');
    String? token = await FirebaseMessaging.instance.getToken();
    debugPrint(token);
    return token;
  }

  subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }
}
      // Future selectNotification(String payload) async {
      //    if (payload != null) {
      //      debugPrint('notification payload: $payload');
      //    }
      //   navigatorKey.currentState!.push(MaterialPageRoute(
      //         builder: (_) => JobDetailPage(
      //               jobID: message.data['jobID'],
      //             )));
      //  } 