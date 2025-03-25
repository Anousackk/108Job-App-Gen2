// ignore_for_file: file_names

import 'package:upgrader/upgrader.dart';

class MyUpgraderMessages extends UpgraderMessages {
  @override
  String? message(UpgraderMessage messageKey) {
    // if (languageCode == 'es') {
    switch (messageKey) {
      case UpgraderMessage.body:
        return "We've just released a major update for 108Jobs! It's faster, more secure, and packed with new features you'll love. Update today!";
      // case UpgraderMessage.buttonTitleIgnore:
      //   return buttonTitleIgnore;
      // case UpgraderMessage.buttonTitleLater:
      //   return buttonTitleLater;
      case UpgraderMessage.buttonTitleUpdate:
        return buttonTitleUpdate;
      // case UpgraderMessage.prompt:
      //   return prompt;
      // case UpgraderMessage.releaseNotes:
      //   return releaseNotes;
      case UpgraderMessage.title:
        return "Update New Version";
      default:
      // message(messageKey);
    }
    // return message(messageKey);
    return null;
  }
  // }
}
