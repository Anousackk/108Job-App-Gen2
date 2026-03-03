// ignore_for_file: avoid_print

import 'package:app/functions/api.dart';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:flutter/material.dart';

class EventAvailableProvider extends ChangeNotifier {
  //Private Variables
  List _companyEventAvailable = [];
  List _companyListPosition = [];

  Map<String, dynamic>? _eventInfo;
  Map<String, dynamic>? _myAppliedInfo;

  bool _isApplied = false;
  bool _isLoadingCompanyEventAvailable = false;

  String _eventInfoId = "";
  String _eventInfoName = "";
  String _eventInfoAddress = "";
  String _eventInfoOpeningTime = "";
  String _qrString = "";
  String _candidateName = "";
  String _candidateID = "";
  String _eventBannerImage = "";
  String _companyIdEventAvailable = "";
  String _companyNameEventAvailable = "";
  String _companyLogoEventAvailable = "";
  String _companyName = "";

  int _candidateTotals = 0;
  int _companyTotals = 0;
  int _jobTotals = 0;

  double _latitude = 0.0;
  double _longtitude = 0.0;

  //Getters

  List get companyEventAvailable => _companyEventAvailable;
  List get companyListPosition => _companyListPosition;

  Map<String, dynamic>? get eventInfo => _eventInfo;
  Map<String, dynamic>? get myAppliedInfo => _myAppliedInfo;

  bool get isApplied => _isApplied;
  bool get isLoadingCompanyEventAvailable => _isLoadingCompanyEventAvailable;

  String get eventInfoId => _eventInfoId;
  String get eventInfoName => _eventInfoName;
  String get eventInfoAddress => _eventInfoAddress;
  String get eventInfoOpeningTime => _eventInfoOpeningTime;
  String get qrString => _qrString;
  String get candidateName => _candidateName;
  String get candidateID => _candidateID;
  String get eventBannerImage => _eventBannerImage;
  String get companyIdEventAvailable => _companyIdEventAvailable;
  String get companyNameEventAvailable => _companyNameEventAvailable;
  String get companyLogoEventAvailable => _companyLogoEventAvailable;
  String get companyName => _companyName;

  int get candidateTotals => _candidateTotals;
  int get companyTotals => _companyTotals;
  int get jobTotals => _jobTotals;

  double get latitude => _latitude;
  double get longtitude => _longtitude;

  set isLoadingCompanyEventAvailable(bool value) {
    _isLoadingCompanyEventAvailable = value;
    notifyListeners();
  }

  set companyIdEventAvailable(String value) {
    _companyIdEventAvailable = value;
    notifyListeners();
  }

  set companyNameEventAvailable(String value) {
    _companyNameEventAvailable = value;
    notifyListeners();
  }

  set companyLogoEventAvailable(String value) {
    _companyLogoEventAvailable = value;
    notifyListeners();
  }

  fetchEventAvailable() async {
    try {
      var res = await fetchData(getEventAvailableSeekerApi);

      if (res.containsKey("message")) {
        print("res containsKey message: ${res["message"]}");
        return;
      }

      print("Fetch Event Available: $res");

      _eventInfo = res["eventInfo"] ?? null;
      _isApplied = res["isApplied"] as bool? ?? false;
      _myAppliedInfo = res["myAppliedInfo"] ?? null;

      final coords = _eventInfo?["map"]?["coordinates"];
      // if (coords is List && coords.length >= 2) {
      _latitude = double.tryParse(coords[1]?.toString() ?? "") ?? 0.0;
      _longtitude = double.tryParse(coords[0]?.toString() ?? "") ?? 0.0;
      // }

      // ຖ້າວ່າ _eventInfo == null ຈະລົບຄ່າຂອງ qrString ອອກ
      if (_eventInfo == null || !_isApplied) {
        await SharedPrefsHelper.remove("qrString");
        print("removed qrString");
      }

      // if (_eventInfo != null) {
      _eventInfoId = _eventInfo?["_id"] ?? "";
      _eventInfoName = _eventInfo?["name"] ?? "";
      _eventInfoAddress = _eventInfo?["address"] ?? "";
      _eventInfoOpeningTime = _eventInfo?["openingTime"] ?? "";
      // } else {
      //   _eventInfoId = "";
      //   _eventInfoName = "";
      //   _eventInfoAddress = "";
      //   _eventInfoOpeningTime = "";
      // }

      // if (_myAppliedInfo != null) {
      _qrString = _myAppliedInfo?["qrString"] ?? "";
      _candidateName = _myAppliedInfo?["candidateName"] ?? "";
      _candidateID = _myAppliedInfo?["id"] ?? "";
      // }
      //  else {
      //   _qrString = "";
      //   _candidateName = "";
      //   _candidateID = "";
      // }

      notifyListeners();
    } catch (e) {
      print("Fetch Event Available Error: $e");
    }
  }

  fetchStatisticEvent() async {
    try {
      var res = await fetchData(getStatisticEventSeekerApi);
      _candidateTotals = int.parse(res["candidateTotals"].toString());
      _companyTotals = int.parse(res["companyTotals"].toString());
      _jobTotals = int.parse(res["jobTotals"].toString());

      notifyListeners();
    } catch (e) {
      print("Fetch Statistic Event Error: $e");
    }
  }

  fetchEventBanner() async {
    try {
      var res = await fetchData(getEventBannerApi);

      _eventBannerImage = res["info"][0]["image"];
      notifyListeners();
    } catch (e) {
      print("Fetch Banner Event Error: $e");
    }
  }

  fetchCompanyEventAvailable() async {
    _isLoadingCompanyEventAvailable = true;
    notifyListeners();
    try {
      var res = await postData(
          getCompanyAvailableEventSeekerApi, {"page": "", "perPage": ""});

      _companyEventAvailable = res["info"] ?? [];
      _isLoadingCompanyEventAvailable = false;
      notifyListeners();
    } catch (e) {
      print("Fetch Company Event Available Error: $e");
    }
  }

  fetchCompanyByIdListPosition() async {
    try {
      var res = await postData(getCompanyIdAvailableEventSeekerApi, {
        "companyId": companyIdEventAvailable,
        "page": "",
        "perPage": "",
      });

      _companyListPosition = res["info"];
      _companyName = res["companyName"];
      notifyListeners();
    } catch (e) {
      print("Fetch Company By Id List Position Error: $e");
    }
  }

  applyEvent() async {
    try {
      var res = await postDataStatusCode(
          applyEventSeekerApi, {"eventId": eventInfoId});

      return res;
    } catch (e) {
      print("Apply Event Error: $e");
    }
  }
}
