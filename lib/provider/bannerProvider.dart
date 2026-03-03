// ignore_for_file: file_names, avoid_print

import 'package:app/functions/api.dart';
import 'package:flutter/material.dart';

class BannerProvider extends ChangeNotifier {
  //Private Variables
  List _listTopBanners = [];

  bool _isLoadingTopBanner = true;

  //Getters
  List get listTopBanners => _listTopBanners;

  bool get isLoadingTopBanner => _isLoadingTopBanner;

  fetchTopBanner() async {
    try {
      var res = await postData(getTopBannerEmployee, {});
      _listTopBanners = res['info'] ?? [];
      print("Fetch TopBanner: $_listTopBanners");
    } catch (e) {
      print("Fetch Top Banner error: $e");
    }

    _isLoadingTopBanner = false;
    notifyListeners();
  }

  void setIsLoadingBanner(bool value) {
    _isLoadingTopBanner = value;
    notifyListeners();
  }
}
