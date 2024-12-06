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
      // case UpgraderMessage.buttonTitleIgnore:
      //   return buttonTitleIgnore; // Hides the Ignore button
      // case UpgraderMessage.buttonTitleLater:
      //   return buttonTitleLater; // Hides the Later button
      // case UpgraderMessage.buttonTitleUpdate:
      //   return buttonTitleUpdate;
      // case UpgraderMessage.prompt:
      //   return prompt;
      default:
        return message(messageKey);
    }
  }
}
