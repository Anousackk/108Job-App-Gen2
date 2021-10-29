import 'package:flutter/material.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/sized.dart';

import '../all_job_page.dart';
import '../companies_page.dart';
import '../landing_page.dart';
import '../my_jobs_page.dart';
import '../my_profile.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

int pageIndex = 0;
PageController pageController = PageController(
  initialPage: 0,
  keepPage: true,
);

class _BottomNavigationState extends State<BottomNavigation> {
  final List<Widget> page = [
    const LandingPage(),
    const CompaniesPage(),
    const JobsPage(),
    const MyJobsPage(),
    // SaveJobPage(),
    const MyProfilePage()
  ];
  onSlide(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  void bottomTapped(int index) {
    pageIndex = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 1), curve: Curves.ease);
    // Future.delayed(Duration(milliseconds: 200)).then((value) {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.5),
              //     spreadRadius: 3,
              //     blurRadius: 5,
              //     offset: Offset(0, 0), // changes position of shadow
              //   ),
              // ],
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Material(
                color: pageIndex == 2
                    ? AppColors.blue
                    : AppColors.white, // button color
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pageIndex != 2
                          ? AppColors.greyWhite
                          : AppColors.blue),
                  child: InkWell(
                    splashColor: AppColors.blue,
                    child: SizedBox(
                        width: mediaWidthSized(context, 6.7),
                        height: mediaWidthSized(context, 6.7),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'megaphone',
                              style: TextStyle(
                                fontFamily: pageIndex == 2
                                    ? 'FontAwesomeProSolid'
                                    : 'FontAwesomeProLight',
                                fontSize: mediaWidthSized(context, 18),
                                color: pageIndex == 2
                                    ? AppColors.white
                                    : AppColors.grey,
                              ),
                            ),
                            Text(
                              indexL == 0 ? 'Jobs' : 'ວຽກ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PoppinsMedium',
                                fontSize: mediaWidthSized(context, 35),
                                color: pageIndex == 2
                                    ? AppColors.white
                                    : AppColors.grey,
                              ),
                            )
                          ],
                        )),
                    onTap: () {
                      bottomTapped(2);
                    },
                  ),
                ),
              ),
            )),
      ),
      body: PageView(
          controller: pageController,
          children: page,
          onPageChanged: (index) {
            onSlide(index);
          }),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, -3), // changes position of shadow
              ),
            ],
            color: AppColors.white,
          ),
          height: mediaWidthSized(context, 7.5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              WidgetNavigationButton(
                onPressed: () {
                  bottomTapped(0);
                },
                icon: 'home-lg-alt',
                fontFamily: pageIndex == 0
                    ? 'FontAwesomeProSolid'
                    : 'FontAwesomeProLight',
                color: pageIndex == 0 ? AppColors.blue : AppColors.grey,
                description: l.home,
              ),
              WidgetNavigationButton(
                onPressed: () {
                  bottomTapped(1);
                },
                icon: 'building',
                fontFamily: pageIndex == 1
                    ? 'FontAwesomeProSolid'
                    : 'FontAwesomeProLight',
                color: pageIndex == 1 ? AppColors.blue : AppColors.grey,
                description: indexL == 0 ? 'Companies' : 'ບໍລິສັດ',
              ),
              SizedBox(width: mediaWidthSized(context, 5.5)),
              WidgetNavigationButton(
                onPressed: () {
                  bottomTapped(3);
                },
                icon: 'folder',
                fontFamily: pageIndex == 3
                    ? 'FontAwesomeProSolid'
                    : 'FontAwesomeProLight',
                color: pageIndex == 3 ? AppColors.blue : AppColors.grey,
                description: indexL == 0 ? 'My job' : 'ວຽກຂອງຂ້ອຍ',
              ),
              WidgetNavigationButton(
                onPressed: () {
                  bottomTapped(4);
                },
                icon: 'user',
                fontFamily: pageIndex == 4
                    ? 'FontAwesomeProSolid'
                    : 'FontAwesomeProLight',
                color: pageIndex == 4 ? AppColors.blue : AppColors.grey,
                description: indexL == 0 ? 'My profile' : 'ຂໍ້ມູນສ່ວນຕົວ',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WidgetNavigationButton extends StatelessWidget {
  const WidgetNavigationButton({
    Key? key,
    required this.onPressed,
    required this.fontFamily,
    required this.icon,
    required this.description,
    required this.color,
  }) : super(key: key);
  final GestureTapCallback onPressed;
  final String fontFamily, icon, description;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mediaWidthSized(context, 5),
      // color: Colors.red,
      child: InkWell(
        splashColor: AppColors.greyOpacity,
        onTap: onPressed,
        child: SizedBox(
          width: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                icon,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: mediaWidthSized(context, 18),
                  color: color,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                    fontFamily: 'PoppinsRegular',
                    fontWeight: FontWeight.bold,
                    fontSize: mediaWidthSized(context, 38),
                    color: color),
              )
            ],
          ),
        ),
      ),
    );
  }
}
