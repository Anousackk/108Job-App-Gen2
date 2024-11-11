// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, unnecessary_brace_in_string_interps, avoid_print, unused_local_variable, prefer_const_constructors, await_only_futures

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
      uriPrefix: 'https://108jobs.page.link',
      link: Uri.parse('https://108.jobs/job_detail/${jobSearchId}'),
      androidParameters: AndroidParameters(
        packageName: "com.onehundredeightjobs.app",
        minimumVersion: 23,
      ),
      iosParameters: IOSParameters(
        bundleId: "org.cenixoft.OneHundredEightJobs",
        // minimumVersion: '3.3.1',
        appStoreId: '1169598302',
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

      // https://108jobs.page.link.page.link
      //Return long URL if short URL generation fails
      return parameters.link.toString();
    }
  }
}

//Error generating short link: [firebase_dynamic_links/unknown] com.google.android.gms.common.api.ApiException: 400: 