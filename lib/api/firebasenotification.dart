import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  "High Importance Notifcations",
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationplugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  debugPrint("Handling a background message : ${message.messageId}");
  debugPrint(message.data.toString());
}

class FirebaseNotifcation {
  initialize() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (Platform.isAndroid) {
      await flutterLocalNotificationplugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
    var intializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/splash');
    var intializationSettingsIOS = const IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        defaultPresentSound: false);
    var initializationSettings = InitializationSettings(
        android: intializationSettingsAndroid, iOS: intializationSettingsIOS);

    flutterLocalNotificationplugin.initialize(initializationSettings);
    // FirebaseMessaging.onMessageOpenedApp.listen((event) {

    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      // var noti = message.data;
      debugPrint(message.data.toString());
      // AppleNotification apple = message.notification?.apple;
      flutterLocalNotificationplugin.show(
          notification.hashCode,
          notification?.title,
          notification?.body,
          NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  channelDescription: channel.description,
                  icon: android?.smallIcon),
              iOS: const IOSNotificationDetails(subtitle: 'detail')));
    });
  }

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
