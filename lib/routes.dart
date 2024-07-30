// ignore_for_file: prefer_const_constructors, unused_import

import 'package:app/screen/login/login.dart';
import 'package:app/screen/main/main.dart';
import 'package:app/screen/screenAfterSignIn/Notifications/notification.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearchDetail.dart';
import 'package:app/screen/screenAfterSignIn/message/message.dart';
import 'package:app/screen/screenAfterSignIn/message/messageDetail.dart';
import 'package:flutter/material.dart';

dynamic routes = {
  Login.routeName: (context) => Login(),
  MainBody.routeName: (context) => MainBody(),
  JobSearchDetail.routeName: (context) => JobSearchDetail(),
  Notifications.routeName: (context) => Notifications(),
  Messages.routeName: (context) => Messages(),
  MessageDetail.routeName: (context) => MessageDetail()
};
