// ignore_for_file: file_names

import 'package:upgrader/upgrader.dart';

class MyUpgraderMessages extends UpgraderMessages {
  @override
  String? message(UpgraderMessage messageKey) {
    switch (messageKey) {
      case UpgraderMessage.title:
        return "Update 108Jobs";

      case UpgraderMessage.body:
        return "We've just released a major update for 108Jobs! It's faster, more secure, and packed with new features you'll love. Update today!";

      case UpgraderMessage.buttonTitleUpdate:
        return "Update Now";
      case UpgraderMessage.buttonTitleIgnore:
        break;
      case UpgraderMessage.buttonTitleLater:
        break;
      case UpgraderMessage.releaseNotes:
        break;
      case UpgraderMessage.prompt:
        return null;
    }
    return super.message(messageKey);
    // return null;
  }
}
