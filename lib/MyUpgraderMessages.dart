// ignore_for_file: file_names

import 'package:upgrader/upgrader.dart';

class MyUpgraderMessages extends UpgraderMessages {
  @override
  String message(UpgraderMessage messageKey) {
    switch (messageKey) {
      case UpgraderMessage.body:
        return "We've just released a major update for 108Jobs! It's faster, more secure, and packed with new features you'll love. Update today!";
      // case UpgraderMessage.prompt:
      //   return 'Would you like to update now?';
      case UpgraderMessage.title:
        return "Important update available!";
      default:
        return message(messageKey);
    }
  }
}
