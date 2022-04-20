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

class FirebaseNotifcation {
  initialize() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
        debugPrint('kuy2');
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