// ignore_for_file: prefer_typing_uninitialized_variabimport 'dart:convert' as convert;, unnecessary_null_comparison, prefer_if_null_operators, unused_local_variable, await_only_futures, unnecessary_new, avoid_print, deprecated_member_use, prefer_if_null_operators, prefer_if_null_operators, deprecated_member_use, avoid_print, avoid_print, avoid_print, deprecated_member_use, avoid_print, avoid_print, avoid_print
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
var apiRegisterSeeker = globalURL + '/new-register-basic-member-seeker-app';
var apiVerifyCodeSeeker = globalURL + '/verify-register-code-seeker-app';
var apiNewVerifyCodeSeeker = globalURL + '/seeker-verify-request-register-app';
var apirequestOTPRegisterSeeker =
    globalURL + '/seeker-request-otp-register-app';

//Reset new Password
var apiResetNewPasswordSeeker = globalURL + "/seeker-reset-password-app";

//Set Password
var apiSetPasswordSeeker = globalURL + "/seeker-set-password-app";

//Delere Account
var apiDeleteAccountSeeker = globalURL + "/seeker-delete-account-app";

//Login
var apiSigInSeeker = globalURL + "/seeker-login-app";
var apiAddTokenSeeker = globalURL + "/add-token";
var apiLogoutSeeker = globalURL + "/logout";

//Information
//['Basic Member', 'Basic Job Seeker', 'Expert Job Seeker']
var informationApiSeeker = globalURL + "/seeker-login-information-app";
var changePasswordApiSeeker = globalURL + "/seeker-change-password-app";
// var addPhoneNumEmailPassApiSeeker = globalURL + "/seeker-set-mobile-email-app";

//
//new add/update phone number/email in Login Infomation screen
var addPhoneEmailRequestOTPSeekerApi =
    globalURL + "/seeker-request-verifycode-app";
var verifyCodeLoginInfoSeekerApi = globalURL + "/seeker-verify-code-app";
var changePhoneEmailLoginInfoSeekerApi = globalURL + "/seeker-change-email-app";
var resendOTPLoginInfoSeekerApi = globalURL + "/seeker-resend-verifycode-app";

//Forgot Password
var requestOTPCodeApiSeeker = globalURL + "/seeker-request-verification-app";
var resendOTPCodeApiSeeker = globalURL + "/seeker-resend-verification-app";
var apiNewResendOTPCodeApiSeeker =
    globalURL + "/seeker-resend-request-otp-register-verify-code-app";

//
//Job Search
var getJobsSearchSeekerApi = globalURL + "/get-job-search-app";
var getJobSearchDetailSeekerApi = globalURL + "/get-job-detail-app/";
var checkNewJobSearchSeekerApi = globalURL + "/save-new-job-app";
var getReuseFilterJobSearchSeekerApi =
    globalURL + "/get-reuse-filter-injob-search-app?";

//
//Company
var getCompaniesSeekerApi = globalURL + "/get-search-employer-seeker-app";
var getCompaniesFeatureApi = globalURL + "/get-employer-feature-seeker-app";
var getCompanyDetailSeekerApi = globalURL + '/get-employer-detail-seeker-app/';
//follow
var addFollowCompanySeekerApi = globalURL + "/add-seeker-follow-employer-app/";
var unFollowCompanySeekerApi = globalURL + "/seeker-unfollow-employer-app/";
//submit
var submitCVSeekerApi = globalURL + "/seeker-submit-cv-employer-app/";
var unSubmitCVSeekerApi = globalURL + "/seeker-unsubmit-cv-employer-app/";
var getSubmitCVSeekerApi = globalURL + "/get-seeker-submit-cv-employer-app";

//
//Home Page
var getTopBannerEmployee = globalURL + "/get-topbanner-seeker";
var getSpotLightEmployee = globalURL + "/get-spotlight-seeker";
var getHiringEmployee = globalURL + "/get-hiring-employer-seeker-app";
var getTopWorkingLocationEmployee = globalURL + "/get-top-workinglocation-app";
var groupIndustryWorkingLocationEmployee =
    globalURL + "/get-grouy-by-industry-workinglocation-app?";
var getPopupBanner = globalURL + "/get-popup-banner-seeker";

//
//Job Search && My Job
var saveJobSeekerApi = globalURL + "/seeker-save-job-app";
var hideJobSeekerApi = globalURL + "/seeker-hide-job-app";
var deleteMyJobSeekerApi = globalURL + "/seeker-delete-my-job-app";
var applyJobSeekerApi = globalURL + "/seeker-apply-job-app";
var catchDuckSeekerApi = globalURL + "/catch-duck-seeker-app";

//
//My Job
var getMyJobSeekerApi = globalURL + "/seeker-get-my-job-app";

//
//Notifications
var getNotificationsSeeker = globalURL + "/notify-historied-app";

//
//Messages
var getMessageDetailSeeker = globalURL + "/message-detail-app/";

//
//My Profile
var getProfileSeekerApi = globalURL + "/seeker-profile-app";
var getTotalMyJobSeekerApi = globalURL + "/seeker-get-totals-myjob-app";

//
//Avatar
var getAvatarSeekerApi = globalURL + "/seeker-get-avatar-app";
var updateAvatarSeekerApi = globalURL + "/seeker-update-avatar-app";

//Profile Setting
var searchableProfileSettingSeeker = globalURL + "/issearchable-seeker-app";
var getCompaniesProfileSetting = globalURL + "/get-employer-list-in-seeker-app";
var getSeekerSearchableCompaniesProfileSetting =
    globalURL + "/get-hide-employer-profile-list-app";
var hideCompanyProfileSetting = globalURL + "/seeker-hide-employer-profile-app";

//Job Aert
var getJobAlertSeekerApi = globalURL + "/seeker-get-job-alert-app";
var addJobAlertSeekerApi = globalURL + "/seeker-create-job-alert-app";

//Personal Information
var addProfileApiSeeker = globalURL + "/add-seeker-profile-app";
var uploadOrUpdateProfileImageApiSeeker =
    globalURL + "/seeker-reupload-profile-app";
var uploadProfileApiSeeker = globalURL + "/upload-seeker-profile-app";

//Province and district
var getProvinceAndDistrictApiSeeker = globalURL + "/get-province-seeker-app?";

//Work Preferences
var addWorkPreferenceSeekerApi = globalURL + "/add-seeker-work-preferences-app";

//Benefits
var benefitsSeekerApi = globalURL + "/get-seeker-benefit-app?";
var getJobFunctionsSeekerApi = globalURL + "/jobfunction-in-seeker-app";

//Upload file CV
var uploadFileCVApiSeeker = globalURL + "/upload-resume-app";
var uploadOrUpdateCVApiSeeker = globalURL + "/create-cv-seeker-app";
var deleteCVApiSeeker = globalURL + "/delete-cv-seeker-app";

//Skill
var addSkillSeekerApi = globalURL + "/add-skill-seeker-app";
var deleteSkillSeekerApi = globalURL + "/delete-skill-seeker-app/";

//Language
var getKeySkillSeekerApi = globalURL + "/get-keyskills-job-seeker-new-app";
var addLanguageSeekerApi = globalURL + "/add-languageskill-seeker-app";
var deleteLanguageSeekerApi = globalURL + "/delete-languageskill-seeker-app/";

//Education
var addEducationSeekerApi = globalURL + "/create-educations-seeker-app";
var deleteEducationSeekerApi = globalURL + "/delete-educations-seeker-app/";

//Work history
var addWorkHistorySeekerApi = globalURL + "/create-workhistory-seeker-app";
var deleteWorkHistorySeekerApi = globalURL + "/delete-workhistory-seeker-app/";

//No Experience
var noExperienceSeekerApi = globalURL + "/update-no-experience-seeker-app";

//Event
var getEventAvailableSeekerApi = globalURL + "/get-event-available-app";
var applyEventSeekerApi = globalURL + "/apply-event-app";
var applyJobIdSeekerApi = globalURL + "/apply-job-wii-app";
var getStatisticEventSeekerApi = globalURL + "/get-statistic-event-app";
var getCompanyAvailableEventSeekerApi =
    globalURL + "/get-event-company-job-available-app";
var getCompanyIdAvailableEventSeekerApi =
    globalURL + "/get-event-company-job-list-app";
//get-event-company-job-list-app

//Get reuse type
var getReuseTypeApiSeeker = globalURL + "/get-reuse-in-seeker-app?";
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
