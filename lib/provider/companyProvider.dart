// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings

import 'package:app/functions/api.dart';
import 'package:flutter/material.dart';

class CompanyProvider extends ChangeNotifier {
  followAndUnFollowComapny(String companyId) async {
    try {
      final res = await postDataStatusCode(
          addFollowCompanySeekerApi + "${companyId}", {});
      print("Follow and unFollow company: $res");

      return res;
    } catch (e) {
      print("Follow and unFollow company error: $e");
      return null;
    }
  }

  submitCVCompany(String companyId) async {
    try {
      final res =
          await postDataStatusCode(submitCVSeekerApi + "${companyId}", {});
      print("Submit CV Of Company: $res");

      return res;
    } catch (e) {
      print("Submit CV Of Company error: $e");
      return null;
    }
  }
}
