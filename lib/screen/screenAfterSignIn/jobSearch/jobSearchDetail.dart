// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, avoid_unnecessary_containers

import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class JobSearchDetail extends StatefulWidget {
  const JobSearchDetail({Key? key}) : super(key: key);

  @override
  State<JobSearchDetail> createState() => _JobSearchDetailState();
}

class _JobSearchDetailState extends State<JobSearchDetail> {
  String _imageSrc = "";

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBarDefault(
          textTitle: "Personal Information",
          fontWeight: FontWeight.bold,
          leadingIcon: Icon(Icons.arrow_back),
          leadingPress: () {
            Navigator.pop(context);
          },
        ),
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: AppColors.backgroundWhite,
            child: Column(
              children: [
                //
                //Section1 Profile image, Company name
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    color: AppColors.red,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            // border: Border.all(
                            //   color: AppColors.borderSecondary,
                            // ),
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.greyWhite,
                            image: _imageSrc == ""
                                ? DecorationImage(
                                    image: AssetImage(
                                        'assets/image/def-profile.png'),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: NetworkImage(_imageSrc),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Container(
                            color: AppColors.blue,
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Semicolon",
                                  style:
                                      bodyTextMaxNormal(null, FontWeight.bold),
                                ),
                                Text("Others"),
                                Text("Job Opening: 10"),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: FaIcon(
                            FontAwesomeIcons.chevronRight,
                            size: IconSize.sIcon,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
