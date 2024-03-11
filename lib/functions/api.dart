// ignore_for_file: prefer_typing_uninitialized_variabimport 'dart:convert' as convert;, unnecessary_null_comparison, prefer_if_null_operators, unused_local_variable, await_only_futures, unnecessary_new
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Url Server
const String globalURL = 'https://db.dev.108.jobs/application-api';

//Login with google && facebook
const apiLoginWithGoogle = globalURL + "/seeker-signup-google-app";
const apiLoginWithFacebook = globalURL + "/seeker-signup-facebook-app";

//Register
var apiRegisterSeeker = globalURL + '/register-basic-member-seeker-app';
var apiVerifyCodeSeeker = globalURL + '/verify-register-code-seeker-app';

//Set Password
var setPasswordSeeker = globalURL + "/seeker-reset-password-app";

//Sign In
var apiSigInSeeker = globalURL + "/seeker-login-app";

//Login Information
var informationApiSeeker = globalURL + "/seeker-login-information-app";
var changePasswordApiSeeker = globalURL + "/seeker-change-password-app";
var addPhoneNumEmailPassApiSeeker = globalURL + "/seeker-set-mobile-email-app";

//Forgot Password
var requestOTPCodeApiSeeker = globalURL + "/seeker-request-verification-app";
var resendOTPCodeApiSeeker = globalURL + "/seeker-resend-verification-app";

//
//Job Search
var getJobsSearchSeekerApi = globalURL + "/get-job-search-app";

//
//My Profile
var getProfileSeekerApi = globalURL + "/seeker-profile-app";

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

//Skill
var addSkillSeekerApi = globalURL + "/add-skill-seeker-app";
var deleteSkillSeekerApi = globalURL + "/delete-skill-seeker-app/";

//Language
var getKeySkillSeekerApi = globalURL + "/get-keyskills-job-seeker-app?";
var addLanguageSeekerApi = globalURL + "/add-languageskill-seeker-app";
var deleteLanguageSeekerApi = globalURL + "/delete-languageskill-seeker-app/";

//Education
var addEducationSeekerApi = globalURL + "/create-educations-seeker-app";
var deleteEducationSeekerApi = globalURL + "/delete-educations-seeker-app/";

//Work history
var addWorkHistorySeekerApi = globalURL + "/create-workhistory-seeker-app";
var deleteWorkHistorySeekerApi = globalURL + "/delete-workhistory-seeker-app/";

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
  final prefs = await SharedPreferences.getInstance();
  var employeeToken = prefs.getString('employeeToken');

  var res = await http.get(Uri.parse(url), headers: {
    "content-type": "application/json",
    "authorization": "$employeeToken" == null ? "" : "$employeeToken",
  });
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  }
}

postData(url, bodyJsonDecode) async {
  final prefs = await SharedPreferences.getInstance();
  var employeeToken = prefs.getString('employeeToken');

  var res = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      "content-type": "application/json",
      "authorization": "$employeeToken" == null ? "" : "$employeeToken",
    },
    body: jsonEncode(bodyJsonDecode),
  );
  return jsonDecode(res.body);
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
  final prefs = await SharedPreferences.getInstance();
  var employeeToken = prefs.getString("employeeToken");

  var res = await http.put(
    Uri.parse(url),
    headers: <String, String>{
      "content-type": "application/json",
      "authorization": "$employeeToken" == null ? "" : "$employeeToken",
    },
    body: jsonEncode(bodyJsonDecode),
  );
  return jsonDecode(res.body);
}

deleteData(url) async {
  final prefs = await SharedPreferences.getInstance();
  var employeeToken = prefs.getString("employeeToken");

  var res = await http.delete(
    Uri.parse(url),
    headers: <String, String>{
      "content-type": "application/json",
      "authorization": "$employeeToken" == null ? "" : "$employeeToken",
    },
  );
  if (res.statusCode == 201) {
    return jsonDecode(res.body);
  }
}

upLoadFile(String fileName, String url) async {
  Dio dio = new Dio();

  final prefs = await SharedPreferences.getInstance();
  var employeeToken = prefs.getString("employeeToken");

  FormData formData = FormData.fromMap({
    "file": await MultipartFile.fromFile(
      fileName,
      filename: fileName.split('/').last,
      contentType: MediaType('file', fileName.split('.').last),
    ),
  });

  Response res = await dio.post(
    url,
    data: formData,
    options: Options(
      headers: <String, String>{
        "content-type": "application/json",
        "authorization": "$employeeToken" == null ? "" : "$employeeToken",
      },
    ),
  );
  return res.data;
}
