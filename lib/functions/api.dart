// ignore_for_file: prefer_interpolation_to_compose_strings, depend_on_referenced_packages

import 'dart:convert';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

//Url Server Dev
// const String globalURL = 'https://db-dev.108.jobs/application-api';

//Url Server 108Jobs
const String globalURL = 'https://db.108.jobs/application-api';

//Login with google && facebook
const apiLoginWithGoogle = globalURL + "/seeker-signup-google-app";
const apiLoginWithFacebook = globalURL + "/seeker-signup-facebook-app";
const apiLoginWithApple = globalURL + "/seeker-signup-apple-app";
const apiSyncGoogleFacebookAip =
    globalURL + "/connect-google-facebook-seeker-app";
const apiDisconnectGoogleFacebookAip =
    globalURL + "/disconnect-google-facebook-seeker-app";

//Register
const apiRegisterSeeker = globalURL + '/new-register-basic-member-seeker-app';
const apiVerifyCodeSeeker = globalURL + '/verify-register-code-seeker-app';
const apiNewVerifyCodeSeeker =
    globalURL + '/seeker-verify-request-register-app';
const apirequestOTPRegisterSeeker =
    globalURL + '/seeker-request-otp-register-app';

//Reset new Password
const apiResetNewPasswordSeeker = globalURL + "/seeker-reset-password-app";

//Set Password
const apiSetPasswordSeeker = globalURL + "/seeker-set-password-app";

//Delere Account
const apiDeleteAccountSeeker = globalURL + "/seeker-delete-account-app";

//Login
const apiSigInSeeker = globalURL + "/seeker-login-app";
const apiAddTokenSeeker = globalURL + "/add-token";
const apiLogoutSeeker = globalURL + "/logout";

//Information
//['Basic Member', 'Basic Job Seeker', 'Expert Job Seeker']
const informationApiSeeker = globalURL + "/seeker-login-information-app";
const changePasswordApiSeeker = globalURL + "/seeker-change-password-app";
// const addPhoneNumEmailPassApiSeeker = globalURL + "/seeker-set-mobile-email-app";

//
//new add/update phone number/email in Login Infomation screen
const addPhoneEmailRequestOTPSeekerApi =
    globalURL + "/seeker-request-verifycode-app";
const verifyCodeLoginInfoSeekerApi = globalURL + "/seeker-verify-code-app";
const changePhoneEmailLoginInfoSeekerApi =
    globalURL + "/seeker-change-email-app";
const resendOTPLoginInfoSeekerApi = globalURL + "/seeker-resend-verifycode-app";

//Forgot Password
const requestOTPCodeApiSeeker = globalURL + "/seeker-request-verification-app";
const resendOTPCodeApiSeeker = globalURL + "/seeker-resend-verification-app";
const apiNewResendOTPCodeApiSeeker =
    globalURL + "/seeker-resend-request-otp-register-verify-code-app";

//
//Job Search
const getJobsSearchSeekerApi = globalURL + "/get-job-search-app";
const getJobSearchDetailSeekerApi = globalURL + "/get-job-detail-app/";
const checkNewJobSearchSeekerApi = globalURL + "/save-new-job-app";
const getReuseFilterJobSearchSeekerApi =
    globalURL + "/get-reuse-filter-injob-search-app?";

//
//Company
const getCompaniesSeekerApi = globalURL + "/get-search-employer-seeker-app";
const getCompaniesFeatureApi = globalURL + "/get-employer-feature-seeker-app";
const getCompanyDetailSeekerApi =
    globalURL + '/get-employer-detail-seeker-app/';
//follow
const addFollowCompanySeekerApi =
    globalURL + "/add-seeker-follow-employer-app/";
const unFollowCompanySeekerApi = globalURL + "/seeker-unfollow-employer-app/";
//submit
const submitCVSeekerApi = globalURL + "/seeker-submit-cv-employer-app/";
const unSubmitCVSeekerApi = globalURL + "/seeker-unsubmit-cv-employer-app/";
const getSubmitCVSeekerApi = globalURL + "/get-seeker-submit-cv-employer-app";

//
//Home Page
const getTopBannerEmployee = globalURL + "/get-topbanner-seeker";
const getSpotLightEmployee = globalURL + "/get-spotlight-seeker";
const getHiringEmployee = globalURL + "/get-hiring-employer-seeker-app";
const getTopWorkingLocationEmployee =
    globalURL + "/get-top-workinglocation-app";
const groupIndustryWorkingLocationEmployee =
    globalURL + "/get-grouy-by-industry-workinglocation-app?";
const getPopupBanner = globalURL + "/get-popup-banner-seeker";

//
//Job Search && My Job
const saveJobSeekerApi = globalURL + "/seeker-save-job-app";
const hideJobSeekerApi = globalURL + "/seeker-hide-job-app";
const deleteMyJobSeekerApi = globalURL + "/seeker-delete-my-job-app";
const applyJobSeekerApi = globalURL + "/seeker-apply-job-app";
const catchDuckSeekerApi = globalURL + "/catch-duck-seeker-app";

//
//My Job
const getMyJobSeekerApi = globalURL + "/seeker-get-my-job-app";

//
//Notifications
const getNotificationsSeeker = globalURL + "/notify-historied-app";

//
//Messages
const getMessageDetailSeeker = globalURL + "/message-detail-app/";

//
//My Profile
const getProfileSeekerApi = globalURL + "/seeker-profile-app";
const getTotalMyJobSeekerApi = globalURL + "/seeker-get-totals-myjob-app";

//
//Avatar
const getAvatarSeekerApi = globalURL + "/seeker-get-avatar-app";
const updateAvatarSeekerApi = globalURL + "/seeker-update-avatar-app";

//Profile Setting
const searchableProfileSettingSeeker = globalURL + "/issearchable-seeker-app";
const getCompaniesProfileSetting =
    globalURL + "/get-employer-list-in-seeker-app";
const getSeekerSearchableCompaniesProfileSetting =
    globalURL + "/get-hide-employer-profile-list-app";
const hideCompanyProfileSetting =
    globalURL + "/seeker-hide-employer-profile-app";

//Job Aert
const getJobAlertSeekerApi = globalURL + "/seeker-get-job-alert-app";
const addJobAlertSeekerApi = globalURL + "/seeker-create-job-alert-app";

//Personal Information
const addProfileApiSeeker = globalURL + "/add-seeker-profile-app";
const uploadOrUpdateProfileImageApiSeeker =
    globalURL + "/seeker-reupload-profile-app";
const uploadProfileApiSeeker = globalURL + "/upload-seeker-profile-app";

//Province and district
const getProvinceAndDistrictApiSeeker = globalURL + "/get-province-seeker-app?";

//Work Preferences
const addWorkPreferenceSeekerApi =
    globalURL + "/add-seeker-work-preferences-app";

//Benefits
const benefitsSeekerApi = globalURL + "/get-seeker-benefit-app?";
const getJobFunctionsSeekerApi = globalURL + "/jobfunction-in-seeker-app";

//Upload file CV
const uploadFileCVApiSeeker = globalURL + "/upload-resume-app";
const uploadOrUpdateCVApiSeeker = globalURL + "/create-cv-seeker-app";
const deleteCVApiSeeker = globalURL + "/delete-cv-seeker-app";

//Skill
const addSkillSeekerApi = globalURL + "/add-skill-seeker-app";
const deleteSkillSeekerApi = globalURL + "/delete-skill-seeker-app/";

//Language
const getKeySkillSeekerApi = globalURL + "/get-keyskills-job-seeker-new-app";
const addLanguageSeekerApi = globalURL + "/add-languageskill-seeker-app";
const deleteLanguageSeekerApi = globalURL + "/delete-languageskill-seeker-app/";

//Education
const addEducationSeekerApi = globalURL + "/create-educations-seeker-app";
const deleteEducationSeekerApi = globalURL + "/delete-educations-seeker-app/";

//Work history
const addWorkHistorySeekerApi = globalURL + "/create-workhistory-seeker-app";
const deleteWorkHistorySeekerApi =
    globalURL + "/delete-workhistory-seeker-app/";

//No Experience
const noExperienceSeekerApi = globalURL + "/update-no-experience-seeker-app";

//Event
const getEventAvailableSeekerApi = globalURL + "/get-event-available-app";
const applyEventSeekerApi = globalURL + "/apply-event-app";
const applyJobIdSeekerApi = globalURL + "/apply-job-wii-app";
const getStatisticEventSeekerApi = globalURL + "/get-statistic-event-app";
const getCompanyAvailableEventSeekerApi =
    globalURL + "/get-event-company-job-available-app";
const getCompanyIdAvailableEventSeekerApi =
    globalURL + "/get-event-company-job-list-app";
//get-event-company-job-list-app

//Get reuse type
const getReuseTypeApiSeeker = globalURL + "/get-reuse-in-seeker-app?";
//Type Api reuse
// 'Degree', 'Gender', 'Industry', 'SkillLevel', 'KeySkills',
// 'Language', 'LanguageLevel', 'MaritalStatus',
// 'SalaryRange', 'Education', 'WorkingExperience', 'Nationality', 'CurrentResidence',
// 'KeySkill', 'PreviousEmployerIndustry', 'PreviousEmployers', 'JobFunction',
// 'PreviousJobTitles', 'EducationStatic', 'IndustryStatic', 'JobFunctionStatic', 'KeySkillStatic',
// 'JobLevel', 'Province', 'BlogType', 'District'

fetchData(url) async {
  // final prefs = await SharedPreferences.getInstance();
  // var employeeToken = prefs.getString('employeeToken');
  String? employeeToken = await SharedPrefsHelper.getString("employeeToken");

  var res = await http.get(Uri.parse(url), headers: {
    "content-type": "application/json",
    "authorization":
        employeeToken == null || employeeToken == "" ? "" : employeeToken,
  });
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  } else if (res.statusCode == 201) {
    return jsonDecode(res.body);
  } else if (res.statusCode == 409) {
    return jsonDecode(res.body);
  } else if (res.statusCode == 401) {
    return jsonDecode(res.statusCode.toString());
  } else {
    return jsonDecode(res.body);
  }
}

postData(url, bodyJsonDecode) async {
  // final prefs = await SharedPreferences.getInstance();
  // var employeeToken = prefs.getString('employeeToken');
  String? employeeToken = await SharedPrefsHelper.getString("employeeToken");

  var res = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      "content-type": "application/json",
      "authorization":
          employeeToken == null || employeeToken == "" ? "" : employeeToken,
    },
    body: jsonEncode(bodyJsonDecode),
  );
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  } else if (res.statusCode == 201) {
    return jsonDecode(res.body);
  } else if (res.statusCode == 409) {
    return jsonDecode(res.body);
  } else if (res.statusCode == 401) {
    return jsonDecode(res.statusCode.toString());
  } else {
    return jsonDecode(res.body);
  }
}

// postData(url, bodyJsonDecode) async {
//   final prefs = await SharedPreferences.getInstance();
//   var employeeToken = prefs.getString('accessToken');
//   var managerToken = prefs.getString('managerToken');

//   var res = await http.post(
//     Uri.parse(url),
//     headers: <String, String>{
//       "content-type": "application/json",
//       "authorization": "$employeeToken" == null ? "" : "$employeeToken",
//     },
//     body: jsonEncode(bodyJsonDecode),
//   );
//   return jsonDecode(res.body);
// }

putData(url, bodyJsonDecode) async {
  // final prefs = await SharedPreferences.getInstance();
  // var employeeToken = prefs.getString("employeeToken");
  String? employeeToken = await SharedPrefsHelper.getString("employeeToken");

  var res = await http.put(
    Uri.parse(url),
    headers: <String, String>{
      "content-type": "application/json",
      "authorization": "$employeeToken" ?? "",
    },
    body: jsonEncode(bodyJsonDecode),
  );
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  } else if (res.statusCode == 201) {
    return jsonDecode(res.body);
  } else if (res.statusCode == 409) {
    return jsonDecode(res.body);
  } else {
    return jsonDecode(res.body);
  }
}

deleteData(url) async {
  // final prefs = await SharedPreferences.getInstance();
  // var employeeToken = prefs.getString("employeeToken");
  String? employeeToken = await SharedPrefsHelper.getString("employeeToken");

  var res = await http.delete(
    Uri.parse(url),
    headers: <String, String>{
      "content-type": "application/json",
      "authorization": "$employeeToken" ?? "",
    },
  );
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  } else if (res.statusCode == 201) {
    return jsonDecode(res.body);
  } else if (res.statusCode == 409) {
    return jsonDecode(res.body);
  } else {
    return jsonDecode(res.body);
  }
}

upLoadFile(String fileName, String url) async {
  // Dio dio = new Dio();

  // final prefs = await SharedPreferences.getInstance();
  // var employeeToken = prefs.getString("employeeToken");
  String? employeeToken = await SharedPrefsHelper.getString("employeeToken");

  FormData formData = FormData.fromMap({
    "file": await MultipartFile.fromFile(
      fileName,
      filename: fileName.split('/').last,
      contentType: MediaType('file', fileName.split('.').last),
    ),
  });

  print(formData);

  try {
    Response res = await Dio().post(
      url,
      data: formData,
      options: Options(headers: {
        "content-type": "application/json",
        "authorization": "$employeeToken" ?? "",
      }),
    );
    if (res.statusCode == 201) {
      return res.data;
    } else if (res.statusCode == 200) {
      return res.data;
    } else if (res.statusCode == 409) {
      return jsonDecode(res.data);
    } else {
      return jsonDecode(res.data);
    }
  } catch (e) {
    // if (e is DioException &&
    //     e.response != null &&
    //     e.response?.statusCode == 413) {
    //   // Handle 413 error (Payload Too Large)
    //   // ignore: avoid_print
    //   print('File size exceeds the allowed limit: ');
    // }
  }
}
