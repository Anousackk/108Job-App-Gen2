// ignore_for_file: unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings, unused_local_variable, avoid_print

import 'package:app/functions/api.dart';
import 'package:flutter/material.dart';

class ReuseTypeProvider extends ChangeNotifier {
  List listNationality = [];
  List listCountry = [];
  List listGender = [];
  List listMaritalStatus = [];
  List listSkillLevel = [];
  List listLanguage = [];
  List listLanguageLevel = [];
  List listJobLevel = [];
  List listProvince = [];
  List listIndustry = [];

  // Job search filter lists
  List listIndustryFilter = [];
  List listProvinceFilter = [];
  List listJobExperienceFilter = [];
  List listEducationLevelFilter = [];
  List listJobLevelFilter = [];

  Future<void> fetchReuseFilterJobSearchSeeker(
      String lang, String resValue) async {
    try {
      var res =
          await fetchData(getReuseFilterJobSearchSeekerApi + "lang=$lang");

      Iterable<dynamic> iterableRes = res[resValue] ?? [];

      switch (resValue) {
        case 'industry':
          listIndustryFilter = iterableRes.toList();
          break;
        case 'workLocation':
          listProvinceFilter = iterableRes.toList();
          break;
        case 'jobExperience':
          listJobExperienceFilter = iterableRes.toList();
          break;
        case 'educationLevel':
          listEducationLevelFilter = iterableRes.toList();
          break;
        case 'jobLevel':
          listJobLevelFilter = iterableRes.toList();
          break;
      }

      notifyListeners();
    } catch (e) {
      print("Fetch reuse filter job search error: $e");
    }
  }

  Future<void> fetchReuseTypeSeeker(String lang, String type) async {
    try {
      var res = await fetchData(
        getReuseTypeApiSeeker + "lang=$lang&type=$type",
      );

      final List<dynamic> data = res['seekerReuse'] ?? [];

      switch (type) {
        case 'Nationality':
          listNationality = data;
          break;

        case 'CurrentResidence':
          listCountry = data;
          break;

        case 'Gender':
          listGender = data;
          break;

        case 'MaritalStatus':
          listMaritalStatus = data;
          break;

        case 'SkillLevel':
          listSkillLevel = data;
          break;

        case 'Language':
          listLanguage = data;
          break;

        case 'LanguageLevel':
          listLanguageLevel = data;
          break;

        case 'JobLevel':
          listJobLevel = data;
          break;

        case 'Province':
          listProvince = data;
          break;

        case 'Industry':
          listIndustry = data;
          break;
      }

      notifyListeners();
    } catch (e) {
      print("Fetch reuse type error: $e");
    }
  }
}
