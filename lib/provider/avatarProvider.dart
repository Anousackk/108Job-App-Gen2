// ignore_for_file: avoid_print, prefer_final_fields

import 'package:app/functions/api.dart';
import 'package:flutter/material.dart';

class AvatarProvider extends ChangeNotifier {
  //Private Variables
  List _listAvatar = [];

  bool _isLoadingAvatar = true;

  //Getters
  List get listAvatar => _listAvatar;

  bool get isLoadingAvatar => _isLoadingAvatar;

  fetchAvatar() async {
    try {
      var res = await fetchData(getAvatarSeekerApi);
      _listAvatar = res["info"] ?? [];
    } catch (e) {
      print("Fetch Avatar error: $e");
    }

    _isLoadingAvatar = false;
    notifyListeners();
  }

  updateAvatar(String avatarId) async {
    try {
      var res = await postDataStatusCode(updateAvatarSeekerApi, {
        "avatarId": avatarId,
      });

      return res;
    } catch (e) {
      print("Update Avatar error: $e");
    }
  }
}
