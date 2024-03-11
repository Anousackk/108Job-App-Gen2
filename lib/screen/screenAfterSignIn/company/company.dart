// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:app/functions/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Company extends StatefulWidget {
  const Company({Key? key}) : super(key: key);

  @override
  State<Company> createState() => _CompanyState();
}

class _CompanyState extends State<Company> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: AppColors.white,
        ),
        body: SafeArea(
          child: Container(
            color: AppColors.background,
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Company"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
