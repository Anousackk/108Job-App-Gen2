// ignore_for_file: avoid_print, unnecessary_null_in_if_null_operators, prefer_interpolation_to_compose_strings, unnecessary_brace_in_string_interps, prefer_final_fields

import 'package:app/functions/api.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  //Private Variables
  List _education = [];
  List _workHistory = [];
  List _languageSkill = [];
  List _skills = [];
  List _listProvince = [];
  List _listDistrict = [];
  List _listBenefit = [];
  List _listJobFunction = [];

  Map<String, dynamic>? _seekerProfile;
  Map<String, dynamic>? _workPreferences;
  Map<String, dynamic>? _reviewStatus;
  Map<String, dynamic>? _avatarObj;
  Map<String, dynamic>? _cv;
  Map<String, dynamic>? _vipoCV;

  String _firstName = "";
  String _lastName = "";
  String _memberLevel = "";
  String _status = "";
  String _imageSrc = "";
  String _cvSrc = "";
  String _cvSystemGenerateSrc = "";
  String _currentJobTitle = "";
  String _selectedAvatarImage = "";
  String _avatarScr = "";
  String _statusFormProfile = "";
  String _haveCVFile = "";
  String _statusEventUpdateProfile = "";

  int _percentage = 0;
  int _savedJobs = 0;
  int _appliedJobs = 0;
  int _epmSavedSeeker = 0;
  int _submitedCV = 0;
  int _totalPoint = 0;

  double _percentageUsed = 0.0;

  bool _isProfileVerified = false;
  bool _isLoadingProfile = true;
  bool _isSearchable = false;
  bool _personalInformationStatus = false;
  bool _workPreferenceStatus = false;
  bool _resumeStatus = false;
  bool _educationStatus = false;
  bool _workHistoryStatus = false;
  bool _languageStatus = false;
  bool _skillStatus = false;
  bool _isReview = false;
  bool _isNoExperience = false;

  //Getters
  List get education => _education;
  List get workHistory => _workHistory;
  List get languageSkill => _languageSkill;
  List get skills => _skills;
  List get listProvince => _listProvince;
  List get listDistrict => _listDistrict;
  List get listBenefit => _listBenefit;
  List get listJobFunction => _listJobFunction;

  Map<String, dynamic>? get seekerProfile => _seekerProfile;
  Map<String, dynamic>? get workPreferences => _workPreferences;
  Map<String, dynamic>? get avatarObj => _avatarObj;
  Map<String, dynamic>? get cv => _cv;
  Map<String, dynamic>? get vipoCV => _vipoCV;

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get memberLevel => _memberLevel;
  String get imageSrc => _imageSrc;
  String get cvSrc => _cvSrc;
  String get cvSystemGenerateSrc => _cvSystemGenerateSrc;
  String get status => _status;
  String get selectedAvatarImage => _selectedAvatarImage;
  String get avatarScr => _avatarScr;
  String get currentJobTitle => _currentJobTitle;
  String get statusFormProfile => _statusFormProfile;
  String get haveCVFile => _haveCVFile;
  String get statusEventUpdateProfile => _statusEventUpdateProfile;

  int get percentage => _percentage;
  int get savedJobs => _savedJobs;
  int get appliedJobs => _appliedJobs;
  int get epmSavedSeeker => _epmSavedSeeker;
  int get submitedCV => _submitedCV;
  int get totalPoint => _totalPoint;

  double get percentageUsed => _percentageUsed;

  bool get isProfileVerified => _isProfileVerified;
  bool get isSearchable => _isSearchable;
  bool get isLoadingProfile => _isLoadingProfile;
  bool get personalInformationStatus => _personalInformationStatus;
  bool get workPreferenceStatus => _workPreferenceStatus;
  bool get resumeStatus => _resumeStatus;
  bool get educationStatus => _educationStatus;
  bool get workHistoryStatus => _workHistoryStatus;
  bool get languageStatus => _languageStatus;
  bool get skillStatus => _skillStatus;
  bool get isReview => _isReview;
  bool get isNoExperience => _isNoExperience;

  void setPercentage(int value) {
    _percentage = value;
    notifyListeners();
  }

  void setPercentageUse(double value) {
    _percentageUsed = value;
    notifyListeners();
  }

  void setIsLoadingProfile(bool value) {
    _isLoadingProfile = value;
    notifyListeners();
  }

  set listDistrict(List value) {
    _listDistrict = value;
    notifyListeners();
  }

  set setIsNoExperience(bool value) {
    _isNoExperience = value;
    notifyListeners();
  }

  set statusFormProfile(String value) {
    _statusFormProfile = value;
    notifyListeners();
  }

  set haveCVFile(String value) {
    _haveCVFile = value;
    notifyListeners();
  }

  set imageSrc(String value) {
    _imageSrc = value;
    notifyListeners();
  }

  set statusEventUpdateProfile(String value) {
    _statusEventUpdateProfile = value;
    notifyListeners();
  }

  fetchProfileSeeker() async {
    try {
      var res = await fetchData(getProfileSeekerApi);

      _seekerProfile = res['profile'];
      _reviewStatus = res['reviewStatus'];

      _firstName = _seekerProfile?['firstName'] ?? "";
      _lastName = _seekerProfile?['lastName'] ?? "";
      _memberLevel = _seekerProfile?['memberLevel'] ?? "";
      _status = _seekerProfile?['status'] ?? "";
      _isSearchable = _seekerProfile?['isSearchable'] as bool;
      _avatarObj = _seekerProfile?['avatar'] ?? null;

      // if (_avatarObj != null) {
      _selectedAvatarImage = _avatarObj?["_id"] ?? "";
      _avatarScr = _avatarObj?["src"] ?? "";
      // }
      // if (_seekerProfile?['file'] != "") {
      // _imageSrc = !_seekerProfile?['file'].containsKey("src") ||
      //         _seekerProfile?['file']["src"] == null
      //     ? ""
      //     : _seekerProfile!['file']["src"];
      // }

      _imageSrc = (_seekerProfile!['file'] is Map &&
              _seekerProfile!['file']["src"] != null)
          ? _seekerProfile!['file']["src"]
          : "";

      _personalInformationStatus =
          (_reviewStatus?["personalInformationStatus"] as bool?) ?? false;
      _workPreferenceStatus =
          (_reviewStatus?["workPreferenceStatus"] as bool?) ?? false;
      _resumeStatus = (_reviewStatus?["resumeStatus"] as bool?) ?? false;
      _educationStatus = (_reviewStatus?["educationStatus"] as bool?) ?? false;
      _workHistoryStatus =
          (_reviewStatus?["workHistoryStatus"] as bool?) ?? false;
      _languageStatus = (_reviewStatus?["languageStatus"] as bool?) ?? false;
      _skillStatus = (_reviewStatus?["skillStatus"] as bool?) ?? false;

      _workPreferences = res["workPreferences"] ?? null;
      _cv = res["cv"] ?? null;
      _cvSrc =
          _cv != null && _cv is Map && _cv!['src'] != null ? _cv!['src'] : "";
      _vipoCV = !res.containsKey("vipoCV") ? null : res["vipoCV"];
      _cvSystemGenerateSrc =
          _vipoCV != null && _vipoCV is Map && _vipoCV!['src'] != null
              ? _vipoCV!['src']
              : "";
      _education = res["education"] ?? [];
      _workHistory = res["workHistory"] ?? [];
      _languageSkill = res["languageSkill"] ?? [];
      _skills = res["skills"] ?? [];
      _isReview = (res["isReview"] as bool?) ?? false;
      _isNoExperience = (res["noExperience"] as bool?) ?? false;

      // if (_workPreferences != null) {
      _currentJobTitle = _workPreferences?['currentJobTitle'] ?? "";
      // }

      _percentage = res["percentage"] == null
          ? 0
          : int.parse(res["percentage"].toString());

      _percentageUsed = _percentage / 100;

      _isProfileVerified = res['isProfileVerified'] as bool? ?? false;

      print("Fetch Profile Seeker: $res");
    } catch (e) {
      print("Fetch profile error: $e");
    }

    _isLoadingProfile = false;
    notifyListeners();
  }

  fetchTotalJobSeeker() async {
    try {
      var res = await fetchData(getTotalMyJobSeekerApi);
      print("${res}");

      _savedJobs = int.parse(res['saveJobTotals'].toString());
      _appliedJobs = int.parse(res['appliedJobTotals'].toString());
      _submitedCV = int.parse(res['submittedTotals'].toString());
      _epmSavedSeeker = int.parse(res['empViewTotals'].toString());
      _totalPoint = int.parse(res['totalPoint'].toString());
      notifyListeners();
    } catch (e) {
      print("Fetch Total JobSeeker error: $e");
    }
  }

  fetchBennefit(String lang) async {
    try {
      var res = await fetchData(benefitsSeekerApi + "lang=${lang}");

      _listBenefit = res['benefits'];
      notifyListeners();
    } catch (e) {
      print("Fetch benefit error: $e");
    }
  }

  fetchJobFunction() async {
    try {
      var res = await fetchData(getJobFunctionsSeekerApi);

      _listJobFunction = res['mapper'];
      notifyListeners();
    } catch (e) {
      print("Fetch job function error: $e");
    }
  }

  fetchProvinceAndDistrict(String lang) async {
    try {
      var res =
          await fetchData(getProvinceAndDistrictApiSeeker + "lang=${lang}");

      _listProvince = res['provinces'];
      notifyListeners();
    } catch (e) {
      print("Fetch avatar error: $e");
    }
  }

  addPersonalInformation(
      String firstName,
      String lastName,
      String dateOfBirth,
      String genderId,
      String maritalStatusId,
      // String nationalityId,
      // String currentResidenceId,
      String districtId,
      String professionalSummary,
      String event) async {
    try {
      final res = await postDataStatusCode(addProfileApiSeeker, {
        "firstName": firstName,
        "lastName": lastName,
        "dateOfBirth": dateOfBirth,
        "genderId": genderId,
        "maritalStatusId": maritalStatusId,
        // "nationalityId": nationalityId,
        // "currentResidenceId": currentResidenceId,
        "districtId": districtId,
        "professionalSummary": professionalSummary,
        "event": event,
      });

      return res;
    } catch (e) {
      print("Add personal information error: $e");
    }
  }

  addWorkPreference(
    String currentJobTitle,
    String currency,
    String expectedSalary,
    //  String jobLevelId,
    //  List jobFunctionId,
    //  List benefitsId,
    List industryId,
    List provinceId,
    String event,
  ) async {
    try {
      final res = await postDataStatusCode(addWorkPreferenceSeekerApi, {
        "currentJobTitle": currentJobTitle,
        "currency": currency,
        "expectedSalary": expectedSalary,
        "jobLevelId": null,
        "jobFunctionId": [],
        "benefitsId": [],
        "industryId": industryId,
        "provinceId": provinceId,
        "event": event,
      });

      return res;
    } catch (e) {
      print("Add work preference error: $e");
    }
  }

  addEducation(
    String? id,
    String subject,
    String startYear,
    String endYear,
    String school,
    String qualifications,
    bool currentlyStudying,
    String event,
  ) async {
    try {
      var res = await postDataStatusCode(addEducationSeekerApi, {
        "_id": id,
        "subject": subject,
        "startYear": startYear,
        "endYear": endYear,
        "school": school,
        "qualifications": qualifications,
        "currentlyStudying": currentlyStudying,
        "event": event,
      });

      return res;
    } catch (e) {
      print("Add education error: $e");
    }
  }

  deleteEducation(String id) async {
    try {
      var res = await deleteDataStatusCode(deleteEducationSeekerApi + id);

      return res;
    } catch (e) {
      print("Delete education error: $e");
    }
  }

  updateNoExperience(bool val) async {
    try {
      var res = await postDataStatusCode(
          noExperienceSeekerApi, {"noExperience": val});

      return res;
    } catch (e) {
      print("Update no experience error: $e");
    }
  }

  addWorkHistory(
    String? id,
    String company,
    String? startYear,
    String? endYear,
    String position,
    String? responsibility,
    bool isCurrentJob,
    String event,
  ) async {
    try {
      var res = await postDataStatusCode(addWorkHistorySeekerApi, {
        "_id": id,
        "company": company,
        "startYear": startYear,
        "endYear": endYear,
        "position": position,
        "responsibility": responsibility,
        "isCurrentJob": isCurrentJob,
        "event": event,
      });

      return res;
    } catch (e) {
      print("Add work history error: $e");
    }
  }

  deleteWorkHistory(String id) async {
    try {
      var res = await deleteDataStatusCode(deleteWorkHistorySeekerApi + id);

      return res;
    } catch (e) {
      print("Delete work history error: $e");
    }
  }

  addLanguageSkill(
    String? id,
    String languageId,
    String languageLevelId,
    String event,
  ) async {
    try {
      var res = await postDataStatusCode(addLanguageSeekerApi, {
        "_id": id,
        "LanguageId": languageId,
        "LanguageLevelId": languageLevelId,
        "event": event,
      });

      return res;
    } catch (e) {
      print("Add language skill error: $e");
    }
  }

  deleteLanguageSkill(String id) async {
    try {
      var res = await deleteDataStatusCode(deleteLanguageSeekerApi + id);

      return res;
    } catch (e) {
      print("Delete work history error: $e");
    }
  }

  addSkill(
    String? id,
    String keySkill,
    String skillLevelId,
    String event,
  ) async {
    try {
      var res = await postDataStatusCode(addSkillSeekerApi, {
        "_id": id,
        "keySkill": keySkill,
        "skillLevelId": skillLevelId,
        "event": event,
      });

      return res;
    } catch (e) {
      print("Add skill error: $e");
    }
  }

  deleteSkill(String id) async {
    try {
      var res = await deleteDataStatusCode(deleteSkillSeekerApi + id);

      return res;
    } catch (e) {
      print("Delete skill error: $e");
    }
  }

  uploadOrUpdateCV(
    Map<String, dynamic>? cvFile,
    bool systemGenCVStatus,
    String event,
  ) async {
    try {
      var res = await postDataStatusCode(
        uploadOrUpdateCVApiSeeker,
        {
          "cv": cvFile,
          "vipoCVStatus": systemGenCVStatus,
          "event": event,
        },
      );
      return res;
    } catch (e) {
      print("Upload or update CV error: $e");
    }
  }

  deleteCV(bool systemGenCVStatus) async {
    try {
      var res = await postDataStatusCode(deleteCVApiSeeker, {
        "vipoCVStatus": systemGenCVStatus,
      });

      return res;
    } catch (e) {
      print("Delete CV error: $e");
    }
  }
}
