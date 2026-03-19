// ignore_for_file: avoid_print

import 'package:app/functions/api.dart';
import 'package:flutter/material.dart';

class JobSearchProvider extends ChangeNotifier {
  saveAndUnSaveJob(String jobId) async {
    try {
      final res = await postDataStatusCode(saveJobSeekerApi, {
        "_id": "",
        "JobId": jobId,
      });
      print("Save and unsave job: $res");

      return res;
    } catch (e) {
      print("Save and unsave job error: $e");
      return null;
    }
  }

  hideJob(String jobId) async {
    try {
      final res = await postDataStatusCode(hideJobSeekerApi, {
        "_id": "",
        "JobId": jobId,
      });
      print("Hide job: $res");

      return res;
    } catch (e) {
      print("Hide job error: $e");
      return null;
    }
  }

  applyJobSearch(String jobId) async {
    try {
      final res = await postDataStatusCode(applyJobSeekerApi, {
        "JobId": jobId,
        "isCoverLetter": null,
      });

      print("Apply job search: $res");

      return res;
    } catch (e) {
      print("Apply job search error: $e");
      return null;
    }
  }
}
