// ignore_for_file: avoid_print

import 'package:app/functions/api.dart';
import 'package:flutter/material.dart';

class MyJobProvider extends ChangeNotifier {
  unSaveAndUnHideMyJob(String id, String type) async {
    try {
      final res = await postDataStatusCode(deleteMyJobSeekerApi, {
        "_id": id,
        "type": type,
      });
      print("unSave unHide My Job: $res");

      return res;
    } catch (e) {
      print("unSave unHide My Job error: $e");
      return null;
    }
  }
}
