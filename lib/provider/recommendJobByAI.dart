import 'package:app/functions/api.dart';
import 'package:flutter/material.dart';

class RecommendJobAIProvider with ChangeNotifier {
  //Private Variables
  List _listRecommendJobs = [];

  int _totalRecommendJobs = 0;

  // Getters
  List get listRecommendJobs => _listRecommendJobs;

  int get totalRecommendJobs => _totalRecommendJobs;

  Future<void> fetchRecommendJobAI() async {
    var res = await postData(getRecommendJobByAIApi, {});

    _listRecommendJobs = res["jobs"] ?? [];
    _totalRecommendJobs = _listRecommendJobs.length;

    notifyListeners();
  }
}
