// ignore_for_file: file_names, unused_local_variable, unused_element, deprecated_member_use, prefer_const_constructors, avoid_print

import 'package:url_launcher/url_launcher.dart';

Future<void> launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}

Future<void> launchPhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

Future<void> launchUniversalLinkIOS(Uri url) async {
  final bool nativeAppLaunchSucceeded = await launchUrl(
    url,
    mode: LaunchMode.externalNonBrowserApplication,
  );
  if (!nativeAppLaunchSucceeded) {
    await launchUrl(url, mode: LaunchMode.inAppWebView);
  }
}

Future<void> launchInBrowserView(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.inAppBrowserView,
  )) {
    throw Exception('Could not launch $url');
  }
}

Future<void> launchInWebView(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.inAppWebView,
  )) {
    throw Exception('Could not launch $url');
  }
}
