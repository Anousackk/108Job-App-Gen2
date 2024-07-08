// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_print, unnecessary_brace_in_string_interps, prefer_adjacent_string_concatenation, unused_element, prefer_is_empty, sized_box_for_whitespace, unnecessary_import, unnecessary_null_in_if_null_operators, avoid_init_to_null, avoid_unnecessary_containers, unnecessary_string_interpolations

import 'package:app/firebase_options.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/screen/main/changeLanguage.dart';
import 'package:app/screen/screenAfterSignIn/Notifications/notification.dart';
import 'package:app/screen/screenAfterSignIn/account/account.dart';
import 'package:app/screen/screenAfterSignIn/company/company.dart';
import 'package:app/screen/screenAfterSignIn/company/companyDetail.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearch.dart';
import 'package:app/screen/screenAfterSignIn/myJob/myJob.dart';
import 'package:app/widget/listMultiSelectedAlertDialog.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic _topWorkLocation = null;
  dynamic _topIndustry = null;
  dynamic _selectedListItem = null;
  String _myJobStatus = "";
  String _companyType = "";
  String _typeString = "";
  String _totalNotiUnRead = "";

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
        _topIndustry = null;
        _typeString = "";
        _selectedListItem = null;
      }
      if (_currentIndex == 0 ||
          _currentIndex == 1 ||
          _currentIndex == 2 ||
          _currentIndex == 4) {
        _myJobStatus = "";
      }
      if (_currentIndex == 0 ||
          _currentIndex == 1 ||
          _currentIndex == 3 ||
          _currentIndex == 4) {
        _companyType = "";
      }
    });
  }

  fetchNotifications() async {
    var res =
        await postData(getNotificationsSeeker, {"page": 1, "perPage": 10});
    _totalNotiUnRead = res['unreadTotals'].toString();

    print("${_totalNotiUnRead}");

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications();
    // print("${_totalNotiUnRead}");
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screen = <Widget>[
      MainHome(callBackToJobSearchProvince: (val) {
        setState(() {
          _topWorkLocation = val;
          _currentIndex = 1;
          _onTapBottomNav(1);
        });
      }, callBackToJobSearchTopIndustry: (val) {
        setState(() {
          _topIndustry = val;
          _currentIndex = 1;
          _onTapBottomNav(1);
        });
      }, callBackToHiringCompany: (valHiring) {
        setState(() {
          _companyType = valHiring;
          _currentIndex = 2;
          _onTapBottomNav(2);
        });
      }, callBackSelectedIndustryProvince: (valString, valSelectedItems) {
        _typeString = valString;
        _selectedListItem = valSelectedItems;
        _currentIndex = 1;
        _onTapBottomNav(1);
      }),
      JobSearch(
        topWorkLocation: _topWorkLocation,
        topIndustry: _topIndustry,
        type: _typeString,
        selectedListItem: _selectedListItem,
      ),
      Company(companyType: _companyType),
      MyJobs(
        myJobStatus: _myJobStatus,
      ),
      // Notifications(
      //   callbackTotalNoti: (value) {
      //     setState(() {
      //       _totalNotiUnRead = value;
      //     });
      //   },
      // ),
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
        //
        //BottomNavigatorBar
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.backgroundWhite,
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: 14,
          showSelectedLabels:
              true, // Set to true to show labels for selected tabs
          showUnselectedLabels:
              true, // Set to true to show labels for unselected tabs
          selectedItemColor: AppColors.primary,

          iconSize: 25,
          currentIndex: _currentIndex,
          onTap: _onTapBottomNav,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: _currentIndex == 0
                    ? Text(
                        "\uf015",
                        style: fontAwesomeSolid(
                            null, 22, AppColors.iconPrimary, null),
                      )
                    : Text(
                        "\uf015",
                        style: fontAwesomeRegular(
                            null, 22, AppColors.iconGrayOpacity, null),
                      ),
              ),
              label: "home".tr,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: _currentIndex == 1
                    ? Text(
                        "\uf002",
                        style: fontAwesomeSolid(
                            null, 22, AppColors.iconPrimary, null),
                      )
                    : Text(
                        "\uf002",
                        style: fontAwesomeRegular(
                            null, 22, AppColors.iconGrayOpacity, null),
                      ),
              ),
              label: "job search".tr,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: _currentIndex == 2
                    ? Text(
                        "\uf1ad",
                        style: fontAwesomeSolid(
                            null, 22, AppColors.iconPrimary, null),
                      )
                    : Text(
                        "\uf1ad",
                        style: fontAwesomeRegular(
                            null, 22, AppColors.iconGrayOpacity, null),
                      ),
              ),
              label: "company".tr,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: _currentIndex == 3
                    ? Text(
                        "\uf0b1",
                        style: fontAwesomeSolid(
                            null, 22, AppColors.iconPrimary, null),
                      )
                    : Text(
                        "\uf0b1",
                        style: fontAwesomeRegular(
                            null, 22, AppColors.iconGrayOpacity, null),
                      ),
              ),
              label: "my job".tr,
            ),
            // BottomNavigationBarItem(
            //   backgroundColor: AppColors.grey,
            //   icon: Padding(
            //     padding: const EdgeInsets.only(top: 10,),
            //     child: Container(
            //       // color: AppColors.primary,
            //       child: Stack(
            //         clipBehavior: Clip.none,
            //         alignment: AlignmentDirectional.center,
            //         children: [
            //           FaIcon(
            //             FontAwesomeIcons.solidBell,
            //             color: _currentIndex == 4
            //                 ? AppColors.iconPrimary
            //                 : AppColors.iconGrayOpacity,
            //           ),
            //           if (_totalNotiUnRead != "0" &&
            //               _totalNotiUnRead.isNotEmpty)
            //             Positioned(
            //               top: -8,
            //               right: -10,
            //               child: Container(
            //                 height: 20,
            //                 width: 20,
            //                 decoration: BoxDecoration(
            //                   color: AppColors.danger,
            //                   shape: BoxShape.circle,
            //                 ),
            //                 child: Center(
            //                   child: Text(
            //                     "${_totalNotiUnRead}",
            //                     style: TextStyle(
            //                         fontSize: 10, color: AppColors.fontWhite),
            //                   ),
            //                 ),
            //               ),
            //             )
            //         ],
            //       ),
            //     ),
            //   ),
            //   label: "notification".tr,
            // ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: _currentIndex == 4
                    ? Text(
                        "\uf007",
                        style: fontAwesomeSolid(
                            null, 22, AppColors.iconPrimary, null),
                      )
                    : Text(
                        "\uf007",
                        style: fontAwesomeRegular(
                            null, 22, AppColors.iconGrayOpacity, null),
                      ),
              ),
              label: "account".tr,
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
    this.callBackToHiringCompany,
    this.callBackToJobSearchProvince,
    this.callBackToJobSearchTopIndustry,
    this.callBackSelectedIndustryProvince,
  }) : super(key: key);
  final Function(dynamic)? callBackToHiringCompany;
  final Function(dynamic)? callBackToJobSearchProvince;
  final Function(dynamic)? callBackToJobSearchTopIndustry;
  final Function(String, dynamic)? callBackSelectedIndustryProvince;

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final CarouselController _controllerTopBanner = CarouselController();
  int _currentTopBannerIndex = 0;
  final CarouselController _controllerSpotLights = CarouselController();
  int _currentSpotLightsIndex = 0;

  //
  //Get list items all
  List _listTopBanners = [];
  List _listTopIndustry = [];
  List _listCompaniesAssignedTopIndustry = [];
  List _listProvince = [];
  List _listCompaniesAssignedProvince = [];
  List _listSpotLights = [];
  List _listHirings = [];
  List _listProvinces = [];
  List _listIndustries = [];
  bool _isLoading = true;

  List _selectedWorkLocations = [];

  //
  //Selected list item(ສະເພາະເຂົ້າ Database)
  List _selectedProvincesListItem = [];
  List _selectedIndustryListItem = [];

  //
  //value display(ສະເພາະສະແດງ)
  List _provinceName = [];
  List _industryName = [];

  String _companyName = "";
  String _industry = "";
  String _address = "";
  String _logo = "";
  String _jobsOpening = "";
  String _follower = "";
  dynamic _fcmToken;
  String _localeLanguageApi = "EN";
  String _totalNotiUnRead = "";

  //error setState() called after dispose(). it can help!!!
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  fcm() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _fcmToken = await FirebaseMessaging.instance.getToken();
    print("fcmToken: " + "${_fcmToken}");

    if (mounted) {
      setState(() {});
    }
  }

  // refreshFCM() async {
  //   var value = await putData(refreshFCMToken, {
  //     "employeeToken": _employeeToken,
  //     "managerToken": _managerToken,
  //     "fcmToken": _fcmToken,
  //   });
  //   var messages = value["messages"];
  // }

  getTokenSharedPre() async {
    final prefs = await SharedPreferences.getInstance();
    var employeeToken = prefs.getString("employeeToken");
    fcm();

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

    if (mounted) {
      setState(() {});
    }
  }

  fetchSpotLight() async {
    var res = await postData(getSpotLightEmployee, {});
    _listSpotLights = res['info'];

    if (mounted) {
      setState(() {});
    }
  }

  fetchHiring() async {
    var res = await postData(getHiringEmployee, {});
    _listHirings = res['info'];

    if (mounted) {
      setState(() {});
    }
  }

  fetchProvince(String lang) async {
    var res = await fetchData(groupIndustryWorkingLocationEmployee +
        "lang=${lang}&type=WorkingLocation");
    _listProvince = res['info'];

    if (_listProvince.isNotEmpty) {
      _isLoading = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  fetchTopIndustry(String lang) async {
    var res = await fetchData(
        groupIndustryWorkingLocationEmployee + "lang=${lang}&type=Industry");
    _listTopIndustry = res['info'];

    if (mounted) {
      setState(() {});
    }
  }

  getReuseFilterJobSearchSeeker(
      String lang, List listValue, String resValue) async {
    var res =
        await fetchData(getReuseFilterJobSearchSeekerApi + "lang=${lang}");

    if (mounted) {
      setState(() {
        listValue.clear(); // Clear the existing list
        listValue.addAll(res[resValue]); // Add elements from the response
      });
    }
  }

  getSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    var getLanguageSharePref = prefs.getString('setLanguage');
    var getLanguageApiSharePref = prefs.getString('setLanguageApi');
    // print("local " + getLanguageSharePref.toString());
    // print("api " + getLanguageApiSharePref.toString());

    setState(() {
      _localeLanguageApi = getLanguageApiSharePref.toString();
    });

    fetchTopIndustry(_localeLanguageApi);
    fetchProvince(_localeLanguageApi);
    getReuseFilterJobSearchSeeker(
        _localeLanguageApi, _listProvinces, "workLocation");
    getReuseFilterJobSearchSeeker(
        _localeLanguageApi, _listIndustries, "industry");
  }

  fetchDataApi() {
    getSharedPreferences();
    getTokenSharedPre();
    getProfileSeeker();
    fetchTopBanner();
    fetchSpotLight();
    fetchHiring();
    fetchNotifications();
  }

  fetchNotifications() async {
    var res =
        await postData(getNotificationsSeeker, {"page": 1, "perPage": 10});
    _totalNotiUnRead = res['unreadTotals'].toString();

    print("${_totalNotiUnRead}");

    if (mounted) {
      setState(() {});
    }
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
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: AppColors.backgroundWhite,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 10 / 2,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    // color: AppColors.red,
                                    child: Image.asset(
                                      'assets/image/Logo108.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ChangeLanguage(),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Notifications(
                                                        callbackTotalNoti:
                                                            (value) {
                                                          setState(() {
                                                            _totalNotiUnRead =
                                                                value;
                                                          });
                                                        },
                                                        statusFromScreen:
                                                            "HomeScreen"),
                                              ));
                                        },
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          alignment:
                                              AlignmentDirectional.center,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.solidBell,
                                              color: AppColors.primary,
                                              size: 25,
                                            ),
                                            if (_totalNotiUnRead != "0" &&
                                                _totalNotiUnRead.isNotEmpty)
                                              Positioned(
                                                top: -8,
                                                right: -10,
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.danger,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "${_totalNotiUnRead}",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: AppColors
                                                              .fontWhite),
                                                    ),
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        //
                        //
                        //
                        //
                        //
                        //
                        //
                        //
                        //
                        //
                        //
                        //
                        //
                        //
                        //
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              //
                              //
                              //Top banner image
                              if (_listTopBanners.length > 0)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // height: 100.0,
                                      //  width: 1280.8,
                                      // height: 180,
                                      // width: double.infinity,
                                      child: Stack(
                                        children: [
                                          //
                                          //
                                          //CarouselSlider top banner image
                                          CarouselSlider(
                                            carouselController:
                                                _controllerTopBanner,
                                            options: CarouselOptions(
                                              aspectRatio: 16 / 9,
                                              // height: 120,
                                              //     .infinity, // Set height to occupy full screen height
                                              viewportFraction:
                                                  1.0, // Show one item at a time
                                              enlargeCenterPage: true,
                                              enableInfiniteScroll:
                                                  _listTopBanners.length > 1
                                                      ? true
                                                      : false,
                                              autoPlay:
                                                  _listTopBanners.length > 1
                                                      ? true
                                                      : false,
                                              onPageChanged: (index, _) {
                                                setState(() {
                                                  _currentTopBannerIndex =
                                                      index;
                                                });
                                              },
                                            ),
                                            items: _listTopBanners
                                                .map((imagePath) {
                                              return Builder(
                                                  builder: (context) {
                                                return Container(
                                                  // height: 100,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      launchInBrowser(
                                                        Uri.parse(
                                                            imagePath['url']),
                                                      );
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child:
                                                          imagePath['image'] ==
                                                                  ""
                                                              ? Image.asset(
                                                                  'assets/image/no-image-available.png',
                                                                  fit: BoxFit
                                                                      .fill,
                                                                )
                                                              : Image.network(
                                                                  "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${imagePath['image']}",
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  errorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return Image
                                                                        .asset(
                                                                      'assets/image/no-image-available.png',
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ); // Display an error message
                                                                  },
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
                                  ],
                                ),

                              //
                              //
                              //Top industry hiring now
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //
                                  //
                                  //title top industry hiring now
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "job by industry".tr,
                                        style: bodyTextMaxNormal(
                                            null, FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          var result = await showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return ListMultiSelectedAlertDialog(
                                                  title: "job by industry".tr,
                                                  listItems: _listIndustries,
                                                  selectedListItem:
                                                      _selectedIndustryListItem,
                                                );
                                              }).then(
                                            (value) {
                                              setState(() {
                                                //value = []
                                                //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                                if (value.length > 0) {
                                                  _selectedIndustryListItem =
                                                      value;
                                                  _industryName =
                                                      []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                                  for (var item
                                                      in _listIndustries) {
                                                    //
                                                    //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedIndustryListItem ກົງກັບ _listIndustries ບໍ່
                                                    if (_selectedIndustryListItem
                                                        .contains(
                                                            item['_id'])) {
                                                      //
                                                      //add Language Name ເຂົ້າໃນ _industryName
                                                      setState(() {
                                                        _industryName
                                                            .add(item['name']);
                                                      });
                                                    }
                                                  }
                                                  widget.callBackSelectedIndustryProvince!(
                                                      'Industry',
                                                      _selectedIndustryListItem);

                                                  print(_industryName);
                                                }
                                              });
                                            },
                                          );
                                        },
                                        child: Text(
                                          "seemore".tr,
                                          style: bodyTextNormal(
                                              AppColors.fontPrimary, null),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  //
                                  //
                                  //list card industry hiring now
                                  if (_listTopIndustry.length > 0)
                                    Container(
                                      height: 160,
                                      width: double.infinity,
                                      child: ListView.builder(
                                          physics: ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _listTopIndustry.length,
                                          itemBuilder: (context, index) {
                                            double spacing = 10;
                                            dynamic i = _listTopIndustry[index];
                                            _listCompaniesAssignedTopIndustry =
                                                i['companiesAssigned'] ?? [];

                                            return Padding(
                                              padding: EdgeInsets.only(
                                                left: index == 0 ? 0 : spacing,
                                                right: index == 9 ? 0 : 0,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    widget.callBackToJobSearchTopIndustry!(
                                                        i);
                                                  });
                                                },
                                                child: Container(
                                                  width: 300,
                                                  padding: EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                      color: AppColors
                                                          .backgroundWhite,
                                                      // border: Border.all(
                                                      //     color: AppColors
                                                      //         .borderGreyOpacity),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          "${i['name']}",
                                                          style: bodyTextNormal(
                                                              null,
                                                              FontWeight.bold),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "${i['jobArvairiable'].toString()} ",
                                                            style:
                                                                bodyTextSmall(
                                                              AppColors
                                                                  .fontPrimary,
                                                            ),
                                                          ),
                                                          Text(
                                                            "job available".tr,
                                                            style:
                                                                bodyTextSmall(
                                                                    null),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),

                                                      //
                                                      //
                                                      //GridView.count Image Card
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              height: 60,
                                                              child: GridView
                                                                  .count(
                                                                crossAxisCount:
                                                                    _listCompaniesAssignedTopIndustry.length >
                                                                            3
                                                                        ? 3
                                                                        : 4,
                                                                crossAxisSpacing:
                                                                    _listCompaniesAssignedTopIndustry.length >
                                                                            3
                                                                        ? 10
                                                                        : 10,
                                                                mainAxisSpacing:
                                                                    15,
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    NeverScrollableScrollPhysics(),
                                                                children: List.generate(
                                                                    _listCompaniesAssignedTopIndustry
                                                                        .length,
                                                                    (index) {
                                                                  dynamic c =
                                                                      _listCompaniesAssignedTopIndustry[
                                                                          index];

                                                                  return Container(
                                                                    width: 55,
                                                                    height: 55,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: AppColors
                                                                            .borderGreyOpacity,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: AppColors
                                                                          .backgroundWhite,
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        child:
                                                                            Center(
                                                                          child: c['logo'] == ""
                                                                              ? Image.asset(
                                                                                  'assets/image/no-image-available.png',
                                                                                  fit: BoxFit.contain,
                                                                                )
                                                                              : Image.network(
                                                                                  "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${c['logo']}",
                                                                                  fit: BoxFit.contain,
                                                                                  errorBuilder: (context, error, stackTrace) {
                                                                                    return Image.asset(
                                                                                      'assets/image/no-image-available.png',
                                                                                      fit: BoxFit.contain,
                                                                                    ); // Display an error message
                                                                                  },
                                                                                ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }),
                                                              ),
                                                            ),
                                                          ),
                                                          //
                                                          //
                                                          //ຖ້າ _listCompaniesAssignedTopIndustry ຫຼາຍກວ່າ 3 ໃຫ້ສະແດງ Card Count ໂຕເລກ
                                                          if (_listCompaniesAssignedTopIndustry
                                                                  .length >
                                                              3)
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10),
                                                              child: Container(
                                                                height: 55,
                                                                width: 55,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: AppColors
                                                                        .borderGreyOpacity,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: AppColors
                                                                      .backgroundWhite,
                                                                ),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "${_listCompaniesAssignedTopIndustry.length - 3}",
                                                                      style: bodyTextMaxNormal(
                                                                          AppColors
                                                                              .fontPrimary,
                                                                          null),
                                                                    ),
                                                                    FaIcon(
                                                                      FontAwesomeIcons
                                                                          .plus,
                                                                      size: 15,
                                                                      color: AppColors
                                                                          .iconPrimary,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                        ],
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
                                ],
                              ),

                              //
                              //
                              //Province hiring now
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //
                                  //
                                  //title province hiring now
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "job by province".tr,
                                        style: bodyTextMaxNormal(
                                            null, FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          var result = await showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return ListMultiSelectedAlertDialog(
                                                  title: "job by province".tr,
                                                  listItems: _listProvinces,
                                                  selectedListItem:
                                                      _selectedProvincesListItem,
                                                );
                                              }).then(
                                            (value) {
                                              setState(() {
                                                //value = []
                                                //ຕອນປິດ showDialog ຖ້າວ່າມີຄ່າໃຫ້ເຮັດຟັງຊັນນີ້
                                                if (value.length > 0) {
                                                  _selectedProvincesListItem =
                                                      value;
                                                  _provinceName =
                                                      []; //ເຊັດໃຫ້ເປັນຄ່າວ່າງກ່ອນທຸກເທື່ອທີ່ເລີ່ມເຮັດຟັງຊັນນີ້

                                                  for (var item
                                                      in _listProvinces) {
                                                    //
                                                    //ກວດວ່າຂໍ້ມູນທີ່ເລືອກຕອນສົ່ງກັບມາ _selectedProvincesListItem ກົງກັບ _listProvinces ບໍ່
                                                    if (_selectedProvincesListItem
                                                        .contains(
                                                            item['_id'])) {
                                                      //
                                                      //add Provinces Name ເຂົ້າໃນ _provinceName
                                                      setState(() {
                                                        _provinceName
                                                            .add(item['name']);
                                                      });
                                                    }
                                                  }

                                                  widget.callBackSelectedIndustryProvince!(
                                                      'Province',
                                                      _selectedProvincesListItem);
                                                  print(_provinceName);
                                                }
                                              });
                                            },
                                          );
                                        },
                                        child: Text(
                                          "seemore".tr,
                                          style: bodyTextNormal(
                                              AppColors.fontPrimary, null),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  //
                                  //
                                  //list card province
                                  if (_listProvince.length > 0)
                                    Container(
                                      height: 160,
                                      width: double.infinity,
                                      child: ListView.builder(
                                          physics: ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _listProvince.length,
                                          itemBuilder: (context, index) {
                                            double spacing = 10;
                                            dynamic i = _listProvince[index];
                                            _listCompaniesAssignedProvince =
                                                i['companiesAssigned'] ?? [];

                                            return Padding(
                                              padding: EdgeInsets.only(
                                                left: index == 0 ? 0 : spacing,
                                                right: index == 9 ? 0 : 0,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    widget.callBackToJobSearchProvince!(
                                                        i);
                                                  });
                                                },
                                                child: Container(
                                                  width: 300,
                                                  padding: EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                      color: AppColors
                                                          .backgroundWhite,
                                                      // border: Border.all(
                                                      //     color: AppColors
                                                      //         .borderGreyOpacity),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          "${i['name']}",
                                                          style:
                                                              bodyTextMaxNormal(
                                                                  null,
                                                                  FontWeight
                                                                      .bold),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "${i['jobArvairiable'].toString()} ",
                                                            style: bodyTextSmall(
                                                                AppColors
                                                                    .fontPrimary),
                                                          ),
                                                          Text(
                                                            "job available".tr,
                                                            style:
                                                                bodyTextSmall(
                                                                    null),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),

                                                      //
                                                      //
                                                      //GridView.count Image Card
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              height: 60,
                                                              child: GridView
                                                                  .count(
                                                                crossAxisCount:
                                                                    _listCompaniesAssignedProvince.length >
                                                                            3
                                                                        ? 3
                                                                        : 4,
                                                                crossAxisSpacing:
                                                                    _listCompaniesAssignedProvince.length >
                                                                            3
                                                                        ? 10
                                                                        : 10,
                                                                mainAxisSpacing:
                                                                    15,
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    NeverScrollableScrollPhysics(),
                                                                children: List.generate(
                                                                    _listCompaniesAssignedProvince
                                                                        .length,
                                                                    (index) {
                                                                  dynamic c =
                                                                      _listCompaniesAssignedProvince[
                                                                          index];

                                                                  return Container(
                                                                    width: 55,
                                                                    height: 55,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: AppColors
                                                                            .borderGreyOpacity,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: AppColors
                                                                          .backgroundWhite,
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        child:
                                                                            Center(
                                                                          child: c['logo'] == ""
                                                                              ? Image.asset(
                                                                                  'assets/image/no-image-available.png',
                                                                                  fit: BoxFit.contain,
                                                                                )
                                                                              : Image.network(
                                                                                  "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${c['logo']}",
                                                                                  fit: BoxFit.contain,
                                                                                  errorBuilder: (context, error, stackTrace) {
                                                                                    return Image.asset(
                                                                                      'assets/image/no-image-available.png',
                                                                                      fit: BoxFit.contain,
                                                                                    ); // Display an error message
                                                                                  },
                                                                                ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }),
                                                              ),
                                                            ),
                                                          ),
                                                          //
                                                          //
                                                          //ຖ້າ _listCompaniesAssignedProvince ຫຼາຍກວ່າ 3 ໃຫ້ສະແດງ Card Count ໂຕເລກ
                                                          if (_listCompaniesAssignedProvince
                                                                  .length >
                                                              3)
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10),
                                                              child: Container(
                                                                height: 55,
                                                                width: 55,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: AppColors
                                                                        .borderGreyOpacity,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: AppColors
                                                                      .backgroundWhite,
                                                                ),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "${_listCompaniesAssignedProvince.length - 3}",
                                                                      style: bodyTextMaxNormal(
                                                                          AppColors
                                                                              .fontPrimary,
                                                                          null),
                                                                    ),
                                                                    FaIcon(
                                                                      FontAwesomeIcons
                                                                          .plus,
                                                                      size: 15,
                                                                      color: AppColors
                                                                          .iconPrimary,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                        ],
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
                                ],
                              ),
                              //
                              //
                              //Wrap List Top WorkLocations
                              // Wrap(
                              //   spacing: 10,
                              //   runSpacing: 10,
                              //   children: List.generate(
                              //       _listProvince.length, (index) {
                              //     dynamic i = _listProvince[index];
                              //     return GestureDetector(
                              //       onTap: () {
                              //         setState(() {
                              //           widget.callBackToJobSearchProvince!(i);
                              //         });
                              //         // setState(() {
                              //         // //
                              //         // //ຖ້າໂຕທີ່ເລືອກ _id ກົງກັບ _selectedArray(_id) ແມ່ນລົບອອກ
                              //         // if (_selectedWorkLocations
                              //         //     .contains(i['_id'])) {
                              //         //   _selectedWorkLocations
                              //         //       .removeWhere((e) => e == i['_id']);

                              //         //   return;
                              //         // }
                              //         // //
                              //         // //ເອົາຂໍ້ມູນທີ່ເລືອກ Add ເຂົ້າໃນ Array _selectedArray
                              //         // _selectedWorkLocations.add(i['_id']);
                              //         // });
                              //       },
                              //       child: Container(
                              //         padding: EdgeInsets.symmetric(
                              //             horizontal: 15, vertical: 10),
                              //         decoration:
                              //             // _selectedWorkLocations.contains(i['_id'])
                              //             //     ? boxDecoration(
                              //             //         null,
                              //             //         AppColors.buttonLightPrimary,
                              //             //         AppColors.borderPrimary,
                              //             //       )
                              //             //     :
                              //             boxDecoration(
                              //           null,
                              //           AppColors.buttonWhite,
                              //           AppColors.buttonWhite,
                              //         ),
                              //         child: Text.rich(
                              //           TextSpan(
                              //             text: '${i['name']} ',
                              //             style: TextStyle(
                              //                 color:
                              //                     //  _selectedWorkLocations
                              //                     //         .contains(i['_id'])
                              //                     //     ? AppColors.fontPrimary
                              //                     //     :
                              //                     AppColors.fontDark),
                              //             children: <TextSpan>[
                              //               TextSpan(
                              //                 text: '${i['jobsCount']}',
                              //                 style: TextStyle(
                              //                     color: AppColors.fontPrimary),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     );
                              //   }),
                              // ),

                              //
                              //
                              //Spotlight
                              if (_listSpotLights.length > 0)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Stack(
                                        children: [
                                          //
                                          //
                                          //CarouselSlider spotlight image
                                          CarouselSlider(
                                            carouselController:
                                                _controllerSpotLights,
                                            options: CarouselOptions(
                                              // height: double
                                              //     .infinity, // Set height to occupy full screen height
                                              viewportFraction:
                                                  1.0, // Show one item at a time
                                              enlargeCenterPage: true,
                                              enableInfiniteScroll:
                                                  _listSpotLights.length > 1
                                                      ? true
                                                      : false,
                                              autoPlay:
                                                  _listSpotLights.length > 1
                                                      ? true
                                                      : false,
                                              onPageChanged: (index, _) {
                                                setState(() {
                                                  _currentSpotLightsIndex =
                                                      index;
                                                });
                                              },
                                            ),
                                            items: _listSpotLights
                                                .map((imagePath) {
                                              return Builder(
                                                  builder: (context) {
                                                return Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      launchInBrowser(
                                                        Uri.parse(
                                                            imagePath['url']),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: imagePath[
                                                                    'image'] ==
                                                                ""
                                                            ? Image.asset(
                                                                'assets/image/no-image-available.png',
                                                                fit:
                                                                    BoxFit.fill,
                                                              )
                                                            : Image.network(
                                                                "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${imagePath['image']}",
                                                                fit:
                                                                    BoxFit.fill,
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return Image
                                                                      .asset(
                                                                    'assets/image/no-image-available.png',
                                                                    fit: BoxFit
                                                                        .fill,
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
                                  ],
                                ),

                              //
                              //
                              //Companies actively hiring
                              if (_listHirings.length > 0)
                                //
                                //
                                //List companies actively hiring
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //
                                        //
                                        //title hiring now
                                        Flexible(
                                          child: Text(
                                            "company hiring now".tr,
                                            style: bodyTextMaxNormal(
                                                null, FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),

                                        //
                                        //
                                        //text Explore all company
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              widget.callBackToHiringCompany!(
                                                  "Hiring");
                                            });
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "seemore".tr,
                                                style: bodyTextNormal(
                                                    AppColors.fontPrimary,
                                                    null),
                                              ),
                                              // Text(
                                              //   "all company".tr,
                                              //   style: bodyTextNormal(
                                              //       AppColors.fontPrimary,
                                              //       FontWeight.bold),
                                              // ),
                                              // SizedBox(
                                              //   width: 5,
                                              // ),
                                              // FaIcon(
                                              //   FontAwesomeIcons.arrowRight,
                                              //   color: AppColors.iconPrimary,
                                              //   size: 15,
                                              // )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 340,
                                      width: double.infinity,
                                      child: ListView.builder(
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _listHirings.length,
                                        itemBuilder: (context, index) {
                                          double spacing = 10;

                                          dynamic i = _listHirings[index];
                                          _companyName = i['companyName'];
                                          _industry = i['industry'];
                                          _address = i['address'] ?? "--";
                                          _logo = i['logo'];
                                          _follower =
                                              i['followerTotals'].toString();
                                          _jobsOpening =
                                              i['jobsCount'].toString();

                                          //
                                          //
                                          //hiring card
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CompanyDetail(
                                                    companyId: i['_id'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: index == 0 ? 0 : spacing,
                                                right: index == 9 ? 0 : 0,
                                              ),
                                              child: Container(
                                                height: 340,
                                                width: 260,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Column(
                                                  children: [
                                                    //
                                                    //
                                                    //hiring cover image
                                                    Expanded(
                                                        flex: 2,
                                                        child: Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .greyShimmer,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          8),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          8),
                                                                ),
                                                              ),
                                                            ),
                                                            // Positioned(
                                                            //   right: -0,
                                                            //   child: Container(
                                                            //     padding: EdgeInsets
                                                            //         .symmetric(
                                                            //             horizontal:
                                                            //                 15,
                                                            //             vertical: 10),
                                                            //     decoration:
                                                            //         BoxDecoration(
                                                            //       color: AppColors
                                                            //           .lightPrimary,
                                                            //       borderRadius:
                                                            //           BorderRadius
                                                            //               .only(
                                                            //         bottomLeft: Radius
                                                            //             .circular(8),
                                                            //       ),
                                                            //     ),
                                                            //     child: Row(children: [
                                                            //       Text(
                                                            //         "${_jobsOpening}",
                                                            //         style: bodyTextNormal(
                                                            //             AppColors
                                                            //                 .fontPrimary,
                                                            //             FontWeight
                                                            //                 .bold),
                                                            //       ),
                                                            //       SizedBox(
                                                            //         width: 5,
                                                            //       ),
                                                            //       Text(
                                                            //         "job open".tr,
                                                            //         style: bodyTextNormal(
                                                            //             AppColors
                                                            //                 .fontPrimary,
                                                            //             null),
                                                            //       )
                                                            //     ]),
                                                            //   ),
                                                            // )
                                                          ],
                                                        )),

                                                    //
                                                    //
                                                    //hiring details
                                                    Expanded(
                                                      flex: 4,
                                                      child: Stack(
                                                        clipBehavior: Clip.none,
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .backgroundWhite,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        8),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              // border: Border(
                                                              //   left: BorderSide(
                                                              //       color: AppColors
                                                              //           .borderGreyOpacity),
                                                              //   right: BorderSide(
                                                              //       color: AppColors
                                                              //           .borderGreyOpacity),
                                                              //   bottom: BorderSide(
                                                              //       color: AppColors
                                                              //           .borderGreyOpacity),
                                                              // ),
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  height: 40,
                                                                ),
                                                                Container(
                                                                  child: Column(
                                                                    children: [
                                                                      //
                                                                      //
                                                                      //Company Name
                                                                      Text(
                                                                        "${_companyName}",
                                                                        style: bodyTextMaxNormal(
                                                                            null,
                                                                            FontWeight.bold),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),

                                                                Column(
                                                                  children: [
                                                                    //
                                                                    //
                                                                    //Industry
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        FaIcon(
                                                                          FontAwesomeIcons
                                                                              .solidUser,
                                                                          size:
                                                                              IconSize.xsIcon,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Flexible(
                                                                          child:
                                                                              Text(
                                                                            "${_industry}",
                                                                            style:
                                                                                bodyTextSmall(null),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),

                                                                    //
                                                                    //
                                                                    //Address
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        FaIcon(
                                                                          FontAwesomeIcons
                                                                              .locationDot,
                                                                          size:
                                                                              IconSize.xsIcon,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Flexible(
                                                                          child:
                                                                              Text(
                                                                            "${_address}",
                                                                            style:
                                                                                bodyTextSmall(null),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              12),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: AppColors
                                                                        .lightPrimary,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  child: Text(
                                                                    "view".tr +
                                                                        " ${_jobsOpening} " +
                                                                        "position"
                                                                            .tr,
                                                                    style: bodyTextNormal(
                                                                        AppColors
                                                                            .fontPrimary,
                                                                        null),
                                                                  ),
                                                                ),

                                                                //
                                                                //
                                                                //Follower
                                                                // Row(
                                                                //   mainAxisAlignment:
                                                                //       MainAxisAlignment
                                                                //           .spaceBetween,
                                                                //   children: [
                                                                //     Row(
                                                                //       children: [
                                                                //         Text(
                                                                //           "${_follower} ",
                                                                //           style:
                                                                //               bodyTextSmall(
                                                                //                   null),
                                                                //         ),
                                                                //         Text(
                                                                //           "follower"
                                                                //               .tr,
                                                                //           style:
                                                                //               bodyTextSmall(
                                                                //                   null),
                                                                //         ),
                                                                //       ],
                                                                //     ),
                                                                //   ],
                                                                // )
                                                              ],
                                                            ),
                                                          ),

                                                          //
                                                          //
                                                          //Featured company logo
                                                          Positioned(
                                                            top: -40,
                                                            child: Container(
                                                              height: 90,
                                                              width: 90,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: AppColors
                                                                      .borderSecondary,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: AppColors
                                                                    .backgroundWhite,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  child: _logo ==
                                                                          ""
                                                                      ? Image
                                                                          .asset(
                                                                          'assets/image/no-image-available.png',
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        )
                                                                      : Image
                                                                          .network(
                                                                          "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${_logo}",
                                                                          fit: BoxFit
                                                                              .contain,
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Image.asset(
                                                                              'assets/image/no-image-available.png',
                                                                              fit: BoxFit.contain,
                                                                            ); // Display an error message
                                                                          },
                                                                        ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                )
                              // Column(
                              //   children: [
                              //     Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         //
                              //         //
                              //         //title hiring now
                              //         Text(
                              //           "HIRING NOW",
                              //           style: bodyTextMaxNormal(
                              //               null, FontWeight.bold),
                              //         ),

                              //         //
                              //         //
                              //         //text Explore all company
                              //         GestureDetector(
                              //           onTap: () {
                              //             setState(() {
                              //               widget
                              //                   .callBackToHiringCompany!("Hiring");
                              //             });
                              //           },
                              //           child: Row(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.center,
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.center,
                              //             children: [
                              //               Text(
                              //                 "Explore all company",
                              //                 style: bodyTextNormal(
                              //                     AppColors.fontPrimary,
                              //                     FontWeight.bold),
                              //               ),
                              //               SizedBox(
                              //                 width: 5,
                              //               ),
                              //               FaIcon(
                              //                 FontAwesomeIcons.arrowRight,
                              //                 color: AppColors.iconPrimary,
                              //                 size: 15,
                              //               )
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //     SizedBox(
                              //       height: 10,
                              //     ),

                              //     //
                              //     //
                              //     //GridView hiring now
                              //     GridView.count(
                              //       mainAxisSpacing: 8,
                              //       crossAxisSpacing: 8,
                              //       shrinkWrap: true,
                              //       physics: NeverScrollableScrollPhysics(),
                              //       crossAxisCount: 4,
                              //       children:
                              //           List.generate(_listHirings.length, (index) {
                              //         dynamic i = _listHirings[index];
                              //         return GestureDetector(
                              //           onTap: () {
                              //             Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                 builder: (context) => CompanyDetail(
                              //                   companyId: i['_id'],
                              //                 ),
                              //               ),
                              //             );
                              //           },
                              //           child: Container(
                              //             decoration: BoxDecoration(
                              //               color: AppColors.backgroundWhite,
                              //               borderRadius: BorderRadius.circular(10),
                              //             ),
                              //             child: Padding(
                              //               padding: EdgeInsets.all(5),
                              //               child: ClipRRect(
                              //                 borderRadius:
                              //                     BorderRadius.circular(8),
                              //                 child: i['logo'] == ""
                              //                     ? Image.asset(
                              //                         'assets/image/no-image-available.png',
                              //                         fit: BoxFit.contain,
                              //                       )
                              //                     : Image.network(
                              //                         "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/${i['logo']}",
                              //                         fit: BoxFit.contain,
                              //                         errorBuilder: (context, error,
                              //                             stackTrace) {
                              //                           return Image.asset(
                              //                             'assets/image/no-image-available.png',
                              //                             fit: BoxFit.contain,
                              //                           ); // Display an error message
                              //                         },
                              //                       ),
                              //               ),
                              //             ),
                              //           ),
                              //         );
                              //       }),
                              //     ),
                              //     SizedBox(
                              //       height: 30,
                              //     )
                              //   ],
                              // )
                            ],
                          ),
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
