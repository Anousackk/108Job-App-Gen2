// ignore_for_file: prefer_final_fields, avoid_print, unnecessary_brace_in_string_interps

import 'package:app/functions/api.dart';
import 'package:flutter/material.dart';

class PopupBannerProvider extends ChangeNotifier {
  //Private Variables
  List _listPopupBanner = [];

  String _imagePopupBanner = "";
  String _urlPopupBanner = "";
  bool _isShowPopupBanner = true;

  //Getters
  List get listPopupBanner => _listPopupBanner;

  String get imagePopupBanner => _imagePopupBanner;
  String get urlPopupBanner => _urlPopupBanner;
  bool get isShowPopupBanner => _isShowPopupBanner;

  fetchPopupBanner() async {
    try {
      var res = await postData(getPopupBanner, {});
      if (res == 401) {
        return 401;
      }

      _listPopupBanner = res["info"] ?? [];

      if (_listPopupBanner.isNotEmpty) {
        print("Fetch Popupbanner: ${_listPopupBanner}");
        _imagePopupBanner = _listPopupBanner[0]['image'] ?? "";
        _urlPopupBanner = _listPopupBanner[0]['url']?.toString().trim() ?? "";
      }

      // var res = await postDataStatusCode(getPopupBanner, {});
      // int statusCode = res["statusCode"];
      // final body = res["body"];

      // print("fetchPopupBanner status: $statusCode");

      // if (statusCode == 401) {
      //   // token expired
      //   return 401;
      // }

      // if (statusCode == 200 || statusCode == 201) {
      //   _listPopupBanner = body["info"] ?? [];

      //   if (_listPopupBanner.isNotEmpty) {
      //     _imagePopupBanner = _listPopupBanner[0]['image'] ?? "";
      //     _urlPopupBanner = _listPopupBanner[0]['url']?.toString().trim() ?? "";
      //   }
      // } else {
      //   print(
      //       "fetchPopupBanner unexpected statusCode: $statusCode, body: $body");
      // }

      // return statusCode;

      notifyListeners();
    } catch (e) {
      print("Fetch PopupBanner error: $e");
    }
  }

  void setIsShowPopupBanner(bool value) {
    _isShowPopupBanner = value;
    notifyListeners();
  }
}
