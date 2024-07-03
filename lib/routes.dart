// ignore_for_file: prefer_const_constructors, unused_import

import 'package:app/screen/login/login.dart';
import 'package:app/screen/main/main.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearchDetail.dart';
import 'package:flutter/material.dart';

dynamic routes = {
  Login.routeName: (context) => Login(),
  MainBody.routeName: (context) => MainBody(),
  JobSearchDetail.routeName: (context) => JobSearchDetail()
};
