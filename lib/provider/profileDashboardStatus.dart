// ignore_for_file: file_names, avoid_print

import 'package:app/functions/api.dart';
import 'package:flutter/material.dart';

class ProfileDashboardStatusProvider extends ChangeNotifier {
  // Private Variables
  int _totalSavedJobs = 0;
  int _totalAppliedJobs = 0;
  int _totalHiddenJobs = 0;
  int _totalJobAlerts = 0;
  int _totalJobSearchs = 0;
  int _totalCompanies = 0;
  int _totalNotifications = 0;
  int _totalMessages = 0;

  // Getters
  int get totalSavedJobs => _totalSavedJobs;
  int get totalAppliedJobs => _totalAppliedJobs;
  int get totalHiddenJobs => _totalHiddenJobs;
  int get totalJobAlerts => _totalJobAlerts;
  int get totalJobSearchs => _totalJobSearchs;
  int get totalCompanies => _totalCompanies;
  int get totalNotifications => _totalNotifications;
  int get totalMessages => _totalMessages;

  fetchProfileDashboardStatus() async {
    try {
      var res = await fetchData(getProfileDashboardStatus);

      _totalSavedJobs = int.parse("${res["totalSavedJobs"]}");
      _totalAppliedJobs = int.parse("${res["totalAppliedJobs"]}");
      _totalHiddenJobs = int.parse("${res["totalHiddenJobs"]}");
      _totalJobAlerts = int.parse("${res["totalJobAlerts"]}");
      _totalJobSearchs = int.parse("${res["totalJobs"]}");
      _totalCompanies = int.parse("${res["totalCompanies"]}");
      _totalNotifications = int.parse("${res["totalNotifications"]}");
      _totalMessages = int.parse("${res["totalMessages"]}");

      notifyListeners();

      print("Fetch ProfileDashboardStatus is working");
    } catch (e) {
      print("Fetch ProfileDashboardStatus error: $e");
    }
  }

  void resetData() {
    _totalSavedJobs = 0;
    _totalAppliedJobs = 0;
    _totalHiddenJobs = 0;
    _totalJobAlerts = 0;

    notifyListeners();
  }
}
