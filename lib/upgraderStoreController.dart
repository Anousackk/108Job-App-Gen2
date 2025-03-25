// ignore_for_file: override_on_non_overriding_member

import 'package:upgrader/upgrader.dart';
import 'dart:io';

class MyStoreController extends UpgraderStoreController {
  @override
  String get appStoreListingURL {
    if (Platform.isAndroid) {
      return "https://play.google.com/store/apps/details?id=com.onehundredeightjobs.app";
    } else if (Platform.isIOS) {
      return "https://apps.apple.com/la/app/108jobs/id1169598302";
    }
    return "";
  }
}
