// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings

import 'package:app/functions/api.dart';
import 'package:flutter/material.dart';

class ProvinceProvider extends ChangeNotifier {
  List listProvince = [];
  bool isLoadingJobByProvince = true;

  fetchProvince(String lang) async {
    // isLoadingJobByProvince = true;
    // notifyListeners();

    try {
      var res = await fetchData(groupIndustryWorkingLocationEmployee +
          "lang=${lang}&type=WorkingLocation");
      listProvince = res['info'] ?? [];
    } catch (e) {
      print("Fetch province error: $e");
    }

    isLoadingJobByProvince = false;
    notifyListeners();
  }
}
