// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_print, unnecessary_brace_in_string_interps, prefer_adjacent_string_concatenation

import 'package:app/functions/colors.dart';
import 'package:app/screen/screenAfterSignIn/account/account.dart';
import 'package:app/screen/screenAfterSignIn/company/company.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearch.dart';
import 'package:app/screen/screenAfterSignIn/myJob/myJob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _screen = <Widget>[
    MainHome(),
    JobSearch(),
    Company(),
    MyJobs(),
    Account(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: _currentIndex == 4
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          backgroundColor: _currentIndex == 4
              ? AppColors.backgroundAppBar
              : AppColors.backgroundWhite,
        ),
        body: SafeArea(
          child: _screen[_currentIndex],
        ),

        //
        //
        //BottomNavigatorBar
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.backgroundWhite,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels:
              true, // Set to true to show labels for selected tabs
          showUnselectedLabels:
              true, // Set to true to show labels for unselected tabs
          selectedItemColor: AppColors.blue,
          iconSize: 20,
          currentIndex: _currentIndex,
          onTap: (int index) {
            // Update the selected tab index when a tab is tapped
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: FaIcon(
                  FontAwesomeIcons.house,
                  color: _currentIndex == 0
                      ? AppColors.iconPrimary
                      : AppColors.iconGrayOpacity,
                ),
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: FaIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  color: _currentIndex == 1
                      ? AppColors.iconPrimary
                      : AppColors.iconGrayOpacity,
                ),
              ),
              label: "Job Search",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: FaIcon(
                  FontAwesomeIcons.solidBuilding,
                  color: _currentIndex == 2
                      ? AppColors.iconPrimary
                      : AppColors.iconGrayOpacity,
                ),
              ),
              label: "Company",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: FaIcon(
                  FontAwesomeIcons.briefcase,
                  color: _currentIndex == 3
                      ? AppColors.iconPrimary
                      : AppColors.iconGrayOpacity,
                ),
              ),
              label: "My Job",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: FaIcon(
                  FontAwesomeIcons.solidUser,
                  color: _currentIndex == 4
                      ? AppColors.iconPrimary
                      : AppColors.iconGrayOpacity,
                ),
              ),
              label: "Account",
            )
          ],
        ),
      ),
    );
  }
}

//
//
// Main Home
class MainHome extends StatefulWidget {
  const MainHome({
    Key? key,
  }) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  getTokenSharedPre() async {
    final prefs = await SharedPreferences.getInstance();
    var employeeToken = prefs.getString("employeeToken");
    print("employeeToken: " + "${employeeToken}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getTokenSharedPre();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Home"),
        ],
      ),
    );
  }
}
