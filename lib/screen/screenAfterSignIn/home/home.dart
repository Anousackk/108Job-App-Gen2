// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_print, unnecessary_brace_in_string_interps, prefer_adjacent_string_concatenation, unused_element

import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/screen/screenAfterSignIn/account/account.dart';
import 'package:app/screen/screenAfterSignIn/company/company.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearch.dart';
import 'package:app/screen/screenAfterSignIn/myJob/myJob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  SystemUiOverlayStyle _systemOverlayStyle = SystemUiOverlayStyle.dark;
  Color _backgroundColor = AppColors.backgroundWhite;

  _onTapBottomNav(int index) {
    // Update the selected tab index when a tab is tapped
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 4) {
        _systemOverlayStyle = SystemUiOverlayStyle.light;
        _backgroundColor = AppColors.backgroundAppBar;
      } else {
        // Reset the style and color if index is not 4
        _systemOverlayStyle = SystemUiOverlayStyle.dark;
        _backgroundColor = AppColors.backgroundWhite;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screen = <Widget>[
      MainHome(),
      JobSearch(),
      Company(),
      MyJobs(),
      Account(callback: () {
        setState(() {
          _currentIndex = 3;
        });
      }),
    ];
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: _systemOverlayStyle,
          backgroundColor: _backgroundColor,
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
          selectedItemColor: AppColors.primary,
          iconSize: 20,
          currentIndex: _currentIndex,
          onTap: _onTapBottomNav,
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

  getProfileSeeker() async {
    var res = await fetchData(getProfileSeekerApi);
    // print(res);
    if (res == null) {
      removeSharedPreToken();
    }

    if (mounted) {
      setState(() {});
    }
  }

  removeSharedPreToken() async {
    final prefs = await SharedPreferences.getInstance();
    var removeEmployeeToken = await prefs.remove('employeeToken');
    await GoogleSignIn().signOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getTokenSharedPre();
    getProfileSeeker();
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
