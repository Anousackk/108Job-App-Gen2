import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // if (message.data['notifyType'] != 'JOB') {
      //   if (navigatorKey.currentState != null) {
      //     navigatorKey.currentState!.push(MaterialPageRoute(
      //         builder: (_) => JobDetailPage(
      //               jobID: message.data['jobID'],
      //             )));
      //   }
      // }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // if (message.data['notifyType'] != 'JOB') {
      //   if (navigatorKey.currentState != null) {
      //     navigatorKey.currentState!.push(MaterialPageRoute(
      //         builder: (_) => JobDetailPage(
      //               jobID: message.data['jobID'],
      //             )));
      //   }
      // }
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