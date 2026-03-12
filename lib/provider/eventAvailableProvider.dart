// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventAvailableProvider extends ChangeNotifier {
  //Private Variables
  List _companyEventAvailable = [];
  List _companyListPosition = [];
  List _boothCheckedInCompanies = [];
  List _aiMatchingJobAndAppliedJobEvent = [];
  List _appliedJobEvent = [];

  Map<String, dynamic>? _eventInfo;
  Map<String, dynamic>? _myAppliedInfo;

  bool _isApplied = false;
  bool _isLoadingCompanyEventAvailable = false;
  bool _isRedeemAvailableBooth = false;
  bool _isAlreadyRedeemedBooth = false;

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
  String _boothsCheckedIn = "";

  int _candidateTotals = 0;
  int _companyTotals = 0;
  int _jobTotals = 0;
  int _aiMatchingJobEventTotals = 0;
  int _appliedJobEventTotals = 0;

  double _latitude = 0.0;
  double _longtitude = 0.0;

  //Getters
  List get companyEventAvailable => _companyEventAvailable;
  List get companyListPosition => _companyListPosition;
  List get boothCheckedInCompanies => _boothCheckedInCompanies;
  List get aiMatchingJobAndAppliedJobEvent => _aiMatchingJobAndAppliedJobEvent;
  List get appliedJobEvent => _appliedJobEvent;

  Map<String, dynamic>? get eventInfo => _eventInfo;
  Map<String, dynamic>? get myAppliedInfo => _myAppliedInfo;

  bool get isApplied => _isApplied;
  bool get isLoadingCompanyEventAvailable => _isLoadingCompanyEventAvailable;
  bool get isRedeemAvailableBooth => _isRedeemAvailableBooth;
  bool get isAlreadyRedeemedBooth => _isAlreadyRedeemedBooth;

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
  String get boothsCheckedIn => _boothsCheckedIn;

  int get candidateTotals => _candidateTotals;
  int get companyTotals => _companyTotals;
  int get jobTotals => _jobTotals;
  int get aiMatchingJobEventTotals => _aiMatchingJobEventTotals;
  int get appliedJobEventTotals => _appliedJobEventTotals;

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

      print("Fetch Event Available is working");
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

      print("Fetch Statistic Event is working");
    } catch (e) {
      print("Fetch Statistic Event Error: $e");
    }
  }

  fetchEventBanner() async {
    try {
      var res = await fetchData(getEventBannerApi);

      _eventBannerImage = res["info"][0]["image"];
      notifyListeners();

      print("Fetch Banner Event is working");
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

      print("Fetch Company Event Available is working");
    } catch (e) {
      print("Fetch Company Event Available Error: $e");
    }
  }

  fetchCompanyByIdListPosition() async {
    try {
      var res = await postData(getCompanyIdAvailableEventSeekerApi, {
        "companyId": _companyIdEventAvailable,
        "page": "",
        "perPage": "",
      });

      _companyListPosition = res["info"];
      _companyName = res["companyName"];
      notifyListeners();

      print("Fetch Company By Id List Position is working");
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

  applyJobCompanyBySeeker(BuildContext context, String jobId) async {
    try {
      // Display AlertDialog Loading First
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomLoadingLogoCircle();
        },
      );
      final res = await postDataStatusCode(applyJobIdSeekerApi, {"_id": jobId});
      final statusCode = res?["statusCode"];

      print("${res}");

      if (!context.mounted) return;

      // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
      Navigator.pop(context);

      if (statusCode == 200 || statusCode == 201) {
        // Display success dialog
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (dialogContext) {
            return NewVer2CustAlertDialogSuccessBtnConfirm(
              title: "successfully".tr,
              contentText: "applied_success".tr,
              textButton: "ok".tr,
              press: () async {
                // Close success dialog
                Navigator.of(dialogContext).pop();
              },
            );
          },
        );

        await fetchCompanyByIdListPosition();
        await fetchAIMatchingJobAndAppliedJob();
      } else {
        // Display warning dialog
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (dialogContext) {
            return CustAlertDialogWarningWithoutBtn(
              title: "warning".tr,
              contentText: "already_applied".tr,
            );
          },
        );
      }
    } catch (e) {
      print("Apply Job Company By Seeker Error: $e");
    }
  }

  fetchCheckInBoothBySeeker() async {
    try {
      var res = await postData(getCheckInBoothBySeekerApi, {});
      _boothCheckedInCompanies = res["booths"] ?? [];
      _boothsCheckedIn = res["boothsCheckedIn"];
      _isRedeemAvailableBooth = res["isRedeemAvailable"];
      _isAlreadyRedeemedBooth = res["isAlreadyRedeemed"];

      notifyListeners();

      print("Fetch Check In Booths By Seeker is working");
    } catch (e) {
      print("Fetch Check In Booth By Seeker Error: $e");
    }
  }

  fetchAIMatchingJobAndAppliedJob() async {
    try {
      var resAI = await postData(getAIMatchingJobAndAppliedJobApi,
          {"page": 1, "perPage": 1000, "type": "AIMatching"});
      var resApplied = await postData(getAIMatchingJobAndAppliedJobApi,
          {"page": 1, "perPage": 1000, "type": "ApplyJob"});
      _aiMatchingJobAndAppliedJobEvent = resAI["jobs"] ?? [];
      _appliedJobEvent = resApplied["jobs"] ?? [];

      _aiMatchingJobEventTotals = resAI["total"] ?? 0;
      _appliedJobEventTotals = resApplied["total"] ?? 0;

      notifyListeners();

      print("Fetch AI Matching Job And Applied Job is working");
    } catch (e) {
      print("Fetch AI Matching Job And Applied Job Error: $e");
    }
  }

  checkInBoothCompanyEvent(
      BuildContext context, String qrString, String code) async {
    try {
      // Display AlertDialog Loading First
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomLoadingLogoCircle();
        },
      );

      final res = await postDataStatusCode(checkInBoothComapnyEventApi, {
        "qrString": qrString,
        "code": code,
      });

      final statusCode = res?["statusCode"];

      print("${res}");

      if (!context.mounted) return;

      // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
      Navigator.pop(context);

      if (statusCode == 200 || statusCode == 201) {
        // Display success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return NewVer2CustAlertDialogSuccessBtnConfirm(
              title: "successfully".tr,
              contentText: "Scan QR Code Successfully",
              textButton: "ok".tr,
              press: () async {
                // Close dialog
                Navigator.of(context).pop();

                // Navigate back to registerEvent.dart
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            );
          },
        );

        await fetchCheckInBoothBySeeker();
      } else {
        // Display dialog warning
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return NewVer5CustAlertDialogWarningBtnConfirm(
              title: "warning".tr,
              contentText: "${res?["body"]?["message"]}",
              textButton: "ok".tr,
              press: () {
                // Close dialog
                Navigator.pop(context);

                // Navigate back to registerEvent.dart
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            );
          },
        );
      }

      // return res;
    } catch (e) {
      print("Check In Booth Company Event Error: $e");
    }
  }

  reedeemCodeEvent(BuildContext context, String redeemCode) async {
    try {
      // Display AlertDialog Loading First
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomLoadingLogoCircle();
        },
      );
      final res = await postDataStatusCode(
          reedeemCodeEventApi, {"redeemCode": redeemCode});

      final statusCode = res?["statusCode"];

      print("${res}");

      if (!context.mounted) return;

      // Close AlertDialog Loading ຫຼັງຈາກ api ເຮັດວຽກແລ້ວ
      Navigator.pop(context);

      if (statusCode == 200 || statusCode == 201) {
        // Display success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return NewVer2CustAlertDialogSuccessBtnConfirm(
              title: "successfully".tr,
              contentText: "Reedeem Reward Successfully",
              press: () {
                // Close dialog
                Navigator.pop(context);

                // Navigate back to registerEvent.dart
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            );
          },
        );

        fetchCheckInBoothBySeeker();
      } else {
        // Display dialog warning
        await showDialog(
          context: context,
          builder: (context) {
            return CustAlertDialogWarningWithoutBtn(
              title: "warning".tr,
              contentText: "${res?["body"]?["message"]}",
            );
          },
        );
      }
    } catch (e) {
      print("Reedeem Code Event Error: $e");
    }
  }
}
