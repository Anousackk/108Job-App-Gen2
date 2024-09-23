// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearchDetail.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinkService {
  static Future<void> dynamicLinkPushScreen(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      print("dynamicLinkPushScreen eiei");
      print("${dynamicLinkData}");
      final Uri deepLink = dynamicLinkData.link;

      // Extract jobId from the deep link
      final jobSearchId = deepLink.pathSegments.last;

      // Navigate to JobSearchDetail with jobId
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobSearchDetail(
            jobId: "66ea4c62967693c7e23114a8",
          ),
        ),
      );
    }).onError((error) {
      print('Dynamic Link Failed: $error');
    });
  }

  ///66ea4c62967693c7e23114a8

  static Future<dynamic> createDynamicLink(jobSearchId) async {
    final parameters = await DynamicLinkParameters(
      uriPrefix:
          'https://app108jobsjobsearchdetail.page.link', // Replace with your Firebase Dynamic Link URI
      link: Uri.parse(
        // 'https://app108jobsjobsearchdetail.page.link/app-site-afk/job_detail/${jobSearchId}',
        // 'https://108.jobs/job_detail/${jobSearchId}',
        'https://app108jobsjobsearchdetail.page.link/app-site-afk',
      ), // Link to specific content
      androidParameters: AndroidParameters(
        packageName:
            "com.onehundredeightjobs.app", // Replace with your app package name
        minimumVersion: 23,
      ),
      iosParameters: IOSParameters(
        bundleId:
            "org.cenixoft.OneHundredEightJobs", //org.cenixoft.OneHundredEightJobs // Replace with your iOS app bundle ID
        minimumVersion: "2.3.1",
      ),
    );

    try {
      // Try to build a short link from parameters
      final ShortDynamicLink shortLink =
          await FirebaseDynamicLinks.instance.buildShortLink(parameters);

      // Return the short URL as a string
      return shortLink.shortUrl.toString();
    } catch (e) {
      // If there’s an error, print it and return a long URL instead
      print('Error generating short link: $e');

      // https://app108jobsjobsearchdetail.page.link
      //Return long URL if short URL generation fails
      return parameters.link.toString();
    }
  }
}

//Error generating short link: [firebase_dynamic_links/unknown] com.google.android.gms.common.api.ApiException: 400: 