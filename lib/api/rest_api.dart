import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/api/auth.dart';

String baseURL = "https://db.108.jobs";
String addtoken = "/application-api/add-token";
String logout = "/application-api/logout";

Future postAPI(String api, Map<String, dynamic>? map) async {
  debugPrint(currentToken);
  dynamic response = await http.post(
    Uri.parse(baseURL + api),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': currentToken ?? '',
    },
    body: jsonEncode(map),
  );
  debugPrint(response.body);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return json.decode(response.body);
  }
}
