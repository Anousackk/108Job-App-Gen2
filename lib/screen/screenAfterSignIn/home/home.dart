// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_print, unnecessary_brace_in_string_interps, prefer_adjacent_string_concatenation, unused_element, prefer_is_empty, sized_box_for_whitespace, unnecessary_import, unnecessary_null_in_if_null_operators, avoid_init_to_null, avoid_unnecessary_containers

import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/screen/screenAfterSignIn/account/account.dart';
import 'package:app/screen/screenAfterSignIn/company/company.dart';
import 'package:app/screen/screenAfterSignIn/company/companyDetail.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearch.dart';
import 'package:app/screen/screenAfterSignIn/myJob/myJob.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  dynamic _topWorkLocation = null;
  String _myJobStatus = "";
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
      if (_currentIndex == 0 ||
          _currentIndex == 2 ||
          _currentIndex == 3 ||
          _currentIndex == 4) {
        _topWorkLocation = null;
      }
      if (_currentIndex == 0 ||
          _currentIndex == 1 ||
          _currentIndex == 2 ||
          _currentIndex == 4) {
        _myJobStatus = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screen = <Widget>[
      MainHome(callBackToJobSearch: (val) {
        setState(() {
          _topWorkLocation = val;
          _currentIndex = 1;
          _onTapBottomNav(1);
        });
      }, callBackToAllCompany: () {
        setState(() {
          _currentIndex = 2;
          _onTapBottomNav(2);
        });
      }),
      JobSearch(topWorkLocation: _topWorkLocation),
      Company(),
      MyJobs(
        myJobStatus: _myJobStatus,
      ),
      Account(callBackToMyJobsSavedJob: () {
        setState(() {
          _currentIndex = 3;
          _onTapBottomNav(3);
        });
      }, callBackToMyJobsAppliedJob: (val) {
        setState(() {
          _myJobStatus = val;
          _currentIndex = 3;
          _onTapBottomNav(3);
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
    this.callBackToAllCompany,
    this.callBackToJobSearch,
  }) : super(key: key);
  final VoidCallback? callBackToAllCompany;
  final Function(dynamic)? callBackToJobSearch;

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final CarouselController _controllerTopBanner = CarouselController();
  int _currentTopBannerIndex = 0;
  final CarouselController _controllerSpotLights = CarouselController();
  int _currentSpotLightsIndex = 0;

  List _listTopBanners = [];
  List _listTopWorkingLocations = [];
  List _listSpotLights = [];
  List _listHirings = [];
  bool _isLoading = true;

  List _selectedWorkLocations = [];

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

  fetchTopBanner() async {
    var res = await postData(getTopBannerEmployee, {});
    _listTopBanners = res['info'];

    if (_listTopBanners.length > 0) {
      _isLoading = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  fetchSpotLight() async {
    var res = await postData(getSpotLightEmployee, {});
    _listSpotLights = res['info'];
    if (_listSpotLights.length > 0) {
      _isLoading = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  fetchHiring() async {
    var res = await postData(getHiringEmployee, {});
    _listHirings = res['info'];
    if (_listHirings.length > 0) {
      _isLoading = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  fetchTopWorkingLocation() async {
    var res = await fetchData(getTopWorkingLocationEmployee);
    _listTopWorkingLocations = res['info'];
    if (_listTopWorkingLocations.length > 0) {
      _isLoading = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  fetchDataApi() {
    getTokenSharedPre();
    getProfileSeeker();
    fetchTopWorkingLocation();
    fetchTopBanner();
    fetchSpotLight();
    fetchHiring();
  }

  @override
  void initState() {
    super.initState();
    fetchDataApi();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        body: SafeArea(
          child: _isLoading
              ? Container(
                  color: AppColors.background,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: AppColors.background,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),

                        //
                        //
                        //Top banner image
                        Container(
                          height: 180,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              CarouselSlider(
                                carouselController: _controllerTopBanner,
                                options: CarouselOptions(
                                  height: double
                                      .infinity, // Set height to occupy full screen height
                                  viewportFraction:
                                      1.0, // Show one item at a time
                                  enlargeCenterPage: true,
                                  enableInfiniteScroll:
                                      _listTopBanners.length > 1 ? true : false,
                                  // autoPlay: true, // Enable auto play if needed
                                  onPageChanged: (index, _) {
                                    setState(() {
                                      _currentTopBannerIndex = index;
                                      // print(_currentImageIndex.toString());
                                    });
                                  },
                                ),
                                items: _listTopBanners.map((imagePath) {
                                  return Builder(builder: (context) {
                                    return Container(
                                      // height: 180,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          launchInBrowser(
                                            Uri.parse(imagePath['url']),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: imagePath['image'] == ""
                                                ? Image.asset(
                                                    'assets/image/no-image-available.png',
                                                    fit: BoxFit.fill,
                                                  )
                                                : Image.network(
                                                    "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${imagePath['image']}",
                                                    fit: BoxFit.fill,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.asset(
                                                        'assets/image/no-image-available.png',
                                                        fit: BoxFit.fill,
                                                      ); // Display an error message
                                                    },
                                                  ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                }).toList(),
                              ),
                              // Positioned(
                              //   bottom: 20,
                              //   left: 0,
                              //   right: 0,
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: _listTopBanners
                              //         .asMap()
                              //         .entries
                              //         .map((entry) {
                              //       return Container(
                              //         width: 8.0,
                              //         height: 8.0,
                              //         margin:
                              //             EdgeInsets.symmetric(horizontal: 4.0),
                              //         decoration: BoxDecoration(
                              //           shape: BoxShape.circle,
                              //           color:
                              //               _currentTopBannerIndex == entry.key
                              //                   ? AppColors.iconSecondary
                              //                   : AppColors.iconLight,
                              //         ),
                              //       );
                              //     }).toList(),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),

                        //
                        //
                        //Top work location
                        Text(
                          "TOP WORK LOCATION",
                          style: bodyTextMaxNormal(null, FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        //
                        //
                        //Wrap List Top WorkLocations
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                              _listTopWorkingLocations.length, (index) {
                            dynamic i = _listTopWorkingLocations[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.callBackToJobSearch!(i);
                                });
                                // setState(() {
                                // //
                                // //ຖ້າໂຕທີ່ເລືອກ _id ກົງກັບ _selectedArray(_id) ແມ່ນລົບອອກ
                                // if (_selectedWorkLocations
                                //     .contains(i['_id'])) {
                                //   _selectedWorkLocations
                                //       .removeWhere((e) => e == i['_id']);

                                //   return;
                                // }
                                // //
                                // //ເອົາຂໍ້ມູນທີ່ເລືອກ Add ເຂົ້າໃນ Array _selectedArray
                                // _selectedWorkLocations.add(i['_id']);
                                // });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration:
                                    // _selectedWorkLocations.contains(i['_id'])
                                    //     ? boxDecoration(
                                    //         null,
                                    //         AppColors.buttonLightPrimary,
                                    //         AppColors.borderPrimary,
                                    //       )
                                    //     :
                                    boxDecoration(
                                  null,
                                  AppColors.buttonWhite,
                                  AppColors.buttonWhite,
                                ),
                                child: Text.rich(
                                  TextSpan(
                                    text: '${i['name']} ',
                                    style: TextStyle(
                                        color:
                                            //  _selectedWorkLocations
                                            //         .contains(i['_id'])
                                            //     ? AppColors.fontPrimary
                                            //     :
                                            AppColors.fontDark),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${i['jobsCount']}',
                                        style: TextStyle(
                                            color: AppColors.fontPrimary),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(
                          height: 30,
                        ),

                        //
                        //
                        //Spotlight image
                        Container(
                          height: 150,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              CarouselSlider(
                                carouselController: _controllerSpotLights,
                                options: CarouselOptions(
                                  height: double
                                      .infinity, // Set height to occupy full screen height
                                  viewportFraction:
                                      1.0, // Show one item at a time
                                  enlargeCenterPage: true,
                                  enableInfiniteScroll:
                                      _listSpotLights.length > 1 ? true : false,
                                  // autoPlay: true, // Enable auto play if needed
                                  onPageChanged: (index, _) {
                                    setState(() {
                                      _currentSpotLightsIndex = index;
                                      // print(_currentImageIndex.toString());
                                    });
                                  },
                                ),
                                items: _listSpotLights.map((imagePath) {
                                  return Builder(builder: (context) {
                                    return Container(
                                      // height: 180,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          launchInBrowser(
                                            Uri.parse(imagePath['url']),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: imagePath['image'] == ""
                                                ? Image.asset(
                                                    'assets/image/no-image-available.png',
                                                    fit: BoxFit.fill,
                                                  )
                                                : Image.network(
                                                    "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${imagePath['image']}",
                                                    fit: BoxFit.fill,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.asset(
                                                        'assets/image/no-image-available.png',
                                                        fit: BoxFit.fill,
                                                      ); // Display an error message
                                                    },
                                                  ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                }).toList(),
                              ),
                              // Positioned(
                              //   bottom: 20,
                              //   left: 0,
                              //   right: 0,
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: _listSpotLights
                              //         .asMap()
                              //         .entries
                              //         .map((entry) {
                              //       return Container(
                              //         width: 8.0,
                              //         height: 8.0,
                              //         margin:
                              //             EdgeInsets.symmetric(horizontal: 4.0),
                              //         decoration: BoxDecoration(
                              //           shape: BoxShape.circle,
                              //           color:
                              //               _currentSpotLightsIndex == entry.key
                              //                   ? AppColors.iconSecondary
                              //                   : AppColors.iconLight,
                              //         ),
                              //       );
                              //     }).toList(),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),

                        //
                        //
                        //Hiring now
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "HIRING NOW",
                              style: bodyTextMaxNormal(null, FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: widget.callBackToAllCompany,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Explore all company",
                                    style: bodyTextNormal(
                                        AppColors.fontPrimary, FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.arrowRight,
                                    color: AppColors.iconPrimary,
                                    size: 15,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        //
                        //
                        //GridView hiring now
                        GridView.count(
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          children: List.generate(_listHirings.length, (index) {
                            dynamic i = _listHirings[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CompanyDetail(
                                      companyId: i['_id'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundWhite,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: i['logo'] == ""
                                        ? Image.asset(
                                            'assets/image/no-image-available.png',
                                            fit: BoxFit.fill,
                                          )
                                        : Image.network(
                                            "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${i['logo']}",
                                            fit: BoxFit.fill,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/image/no-image-available.png',
                                                fit: BoxFit.fill,
                                              ); // Display an error message
                                            },
                                          ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
