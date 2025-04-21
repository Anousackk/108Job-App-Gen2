// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_print, unnecessary_brace_in_string_interps, prefer_adjacent_string_concatenation, unused_element, prefer_is_empty, sized_box_for_whitespace, unnecessary_import, unnecessary_null_in_if_null_operators, avoid_init_to_null, avoid_unnecessary_containers, unnecessary_string_interpolations, prefer_typing_uninitialized_variables, await_only_futures

import 'dart:async';
import 'dart:io';

import 'package:app/firebase_options.dart';
import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/auth_service.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/internetDisconnected.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/ScreenAfterSignIn/Company/company.dart';
import 'package:app/screen/ScreenAfterSignIn/Company/companyDetail.dart';
import 'package:app/screen/ScreenAfterSignIn/Home/Widget/companyHiringShirmmerWidget.dart';
import 'package:app/screen/ScreenAfterSignIn/Home/Widget/homeHeaderShirmmerWidget.dart';
import 'package:app/screen/ScreenAfterSignIn/Home/Widget/jobByIndustryShimmerWidget.dart';
import 'package:app/screen/ScreenAfterSignIn/Home/Widget/jobByProvinceShirmmerWidget.dart';
import 'package:app/screen/ScreenAfterSignIn/Home/Widget/topbannerShimmerWidget.dart';
import 'package:app/screen/ScreenAfterSignIn/JobSearch/jobSearch.dart';
import 'package:app/screen/ScreenAfterSignIn/Message/message.dart';
import 'package:app/screen/ScreenAfterSignIn/MyJob/myJob.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/screen/Main/changeLanguage.dart';
import 'package:app/screen/ScreenAfterSignIn/Notifications/notification.dart';
import 'package:app/screen/ScreenAfterSignIn/account/account.dart';
import 'package:app/widget/listMultiSelectedAlertDialog.dart';
import 'package:apple_product_name/apple_product_name.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic _topWorkLocation = null;
  dynamic _topIndustry = null;
  dynamic _selectedListItem = null;
  dynamic _hasInternet = null;

  String _myJobStatus = "";
  String _companyType = "";
  String _typeString = "";
  String _totalNotiUnRead = "";
  String _totalMessageUnRead = "";
  bool _isShowBannerHome = true;
  String _modelName = "";

  int _currentIndex = 0;

  SystemUiOverlayStyle _systemOverlayStyle = SystemUiOverlayStyle.dark;
  Color _backgroundColor = AppColors.backgroundWhite;

  static const appcastURL =
      'https://raw.githubusercontent.com/larryaasen/upgrader/master/test/testappcast.xml';

  _onTapBottomNav(int index) async {
    print("_onTapBottomNav: " + '${index}');
    _hasInternet = await InternetConnection().hasInternetAccess;
    print("press tapp bottom check hasInternetAccess: " +
        _hasInternet.toString());
    // if (!hasInternet) {
    //   showInternetDisconnected(context);
    //   return;
    // }

    // await getProfileSeeker();

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
      if (_currentIndex == 0) {
        _isShowBannerHome = false;
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

  loadInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('iOS-running name: ${iosInfo.name}');
      print('iOS-running systemVersion: '
              '${iosInfo.systemName}' +
          ' ' +
          '${iosInfo.systemVersion}');
      var name = iosInfo.name;
      var systemName = iosInfo.systemName;
      var systemVersion = iosInfo.systemVersion;
      var productName = iosInfo.utsname.productName;
      setState(() {
        _modelName = productName.toString();
      });
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on version.release: ${androidInfo.version.release}');
      print('Running on model: ' "${androidInfo.brand}" +
          ' ' +
          "${androidInfo.model}");

      var brand = androidInfo.brand.toString();
      var model = androidInfo.model.toString();
      var versionRelease = androidInfo.version.release.toString();
      setState(() {
        _modelName = brand.toString() + ' ' + model.toString();
      });
    }
  }

  logOut() async {
    await loadInfo();
    var res = await postData(apiLogoutSeeker, {
      "notifyToken": [
        {"model": _modelName}
      ]
    });

    print("logout: " + res);
  }

  removeSharedPreTokenAndLogOut() async {
    final prefs = await SharedPreferences.getInstance();
    await logOut();

    var removeEmployeeToken = await prefs.remove('employeeToken');
    AuthService().facebookSignOut();
    AuthService().googleSignOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  getProfileSeeker() async {
    var res = await fetchData(getProfileSeekerApi);

    if (res == 401) {
      print("statusCode == 401");
      await removeSharedPreTokenAndLogOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getProfileSeeker();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screen = <Widget>[
      MainHome(
        callBackToJobSearchProvince: (val) {
          setState(() {
            _topWorkLocation = val;
            _currentIndex = 1;
            _onTapBottomNav(1);
          });
        },
        callBackToJobSearchTopIndustry: (val) {
          setState(() {
            _topIndustry = val;
            _currentIndex = 1;
            _onTapBottomNav(1);
          });
        },
        callBackToHiringCompany: (valHiring) {
          setState(() {
            _companyType = valHiring;
            _currentIndex = 2;
            _onTapBottomNav(2);
          });
        },
        callBackSelectedIndustryProvince: (valString, valSelectedItems) {
          _typeString = valString;
          _selectedListItem = valSelectedItems;
          _currentIndex = 1;
          _onTapBottomNav(1);
        },
        isShowBanner: _isShowBannerHome,
      ),
      JobSearch(
        topWorkLocation: _topWorkLocation,
        topIndustry: _topIndustry,
        type: _typeString,
        selectedListItem: _selectedListItem,
        hasInternet: _hasInternet,
      ),
      Company(
        companyType: _companyType,
        hasInternet: _hasInternet,
      ),
      MyJobs(
        myJobStatus: _myJobStatus,
        hasInternet: _hasInternet,
      ),
      Account(
        callBackToMyJobsSavedJob: () {
          setState(() {
            _currentIndex = 3;
            _onTapBottomNav(3);
          });
        },
        callBackToMyJobsAppliedJob: (val) {
          setState(() {
            _myJobStatus = val;
            _currentIndex = 3;
            _onTapBottomNav(3);
          });
        },
        hasInternet: _hasInternet,
      ),
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
          unselectedFontSize: 12,
          selectedFontSize: 12,
          showSelectedLabels:
              true, // Set to true to show labels for selected tabs
          showUnselectedLabels:
              true, // Set to true to show labels for unselected tabs
          selectedItemColor: AppColors.primary,

          // iconSize: 25,
          currentIndex: _currentIndex,
          onTap: _onTapBottomNav,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                ),
                child: _currentIndex == 0
                    ? Text(
                        "\uf015",
                        style: fontAwesomeSolid(
                            null, 18, AppColors.iconPrimary, null),
                      )
                    : Text(
                        "\uf015",
                        style: fontAwesomeRegular(
                            null, 18, AppColors.iconGrayOpacity, null),
                      ),
              ),
              label: "home".tr,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                ),
                child: _currentIndex == 1
                    ? Text(
                        "\uf002",
                        style: fontAwesomeSolid(
                            null, 18, AppColors.iconPrimary, null),
                      )
                    : Text(
                        "\uf002",
                        style: fontAwesomeRegular(
                            null, 18, AppColors.iconGrayOpacity, null),
                      ),
              ),
              label: "job search".tr,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                ),
                child: _currentIndex == 2
                    ? Text(
                        "\uf1ad",
                        style: fontAwesomeSolid(
                            null, 18, AppColors.iconPrimary, null),
                      )
                    : Text(
                        "\uf1ad",
                        style: fontAwesomeRegular(
                            null, 18, AppColors.iconGrayOpacity, null),
                      ),
              ),
              label: "company".tr,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                ),
                child: _currentIndex == 3
                    ? Text(
                        "\uf0b1",
                        style: fontAwesomeSolid(
                            null, 18, AppColors.iconPrimary, null),
                      )
                    : Text(
                        "\uf0b1",
                        style: fontAwesomeRegular(
                            null, 18, AppColors.iconGrayOpacity, null),
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
                  top: 0,
                ),
                child: _currentIndex == 4
                    ? Text(
                        "\uf007",
                        style: fontAwesomeSolid(
                            null, 18, AppColors.iconPrimary, null),
                      )
                    : Text(
                        "\uf007",
                        style: fontAwesomeRegular(
                            null, 18, AppColors.iconGrayOpacity, null),
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
    this.isShowBanner,
  }) : super(key: key);
  final Function(dynamic)? callBackToHiringCompany;
  final Function(dynamic)? callBackToJobSearchProvince;
  final Function(dynamic)? callBackToJobSearchTopIndustry;
  final Function(String, dynamic)? callBackSelectedIndustryProvince;
  final isShowBanner;

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final CarouselSliderController _controllerTopBanner =
      CarouselSliderController();
  int _currentTopBannerIndex = 0;
  final CarouselSliderController _controllerSpotLights =
      CarouselSliderController();
  int _currentSpotLightsIndex = 0;
  late final StreamSubscription<InternetStatus> _subscription;
  late final AppLifecycleListener _listener;

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
  List _listPopupBanner = [];

  bool _isLoading = true;
  bool _isLoadingTopBanner = true;
  bool _isLoadingJobByProvince = true;
  bool _isLoadingJobByIndustry = true;
  bool _isLoadingCompanyHiring = true;
  bool _isLoadingNotification = true;

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
  String _totalMessageUnRead = "";
  String _imagePopupBanner = "";
  String _urlPopupBanner = "";
  String _modelName = "";
  bool _showBanner = true;

  //error setState() called after dispose(). it can help!!!
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  loadInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('iOS-running name: ${iosInfo.name}');
      print('iOS-running systemVersion: '
              '${iosInfo.systemName}' +
          ' ' +
          '${iosInfo.systemVersion}');
      var name = iosInfo.name;
      var systemName = iosInfo.systemName;
      var systemVersion = iosInfo.systemVersion;
      var productName = iosInfo.utsname.productName;
      setState(() {
        _modelName = productName.toString();
      });
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on version.release: ${androidInfo.version.release}');
      print('Running on model: ' "${androidInfo.brand}" +
          ' ' +
          "${androidInfo.model}");

      var brand = androidInfo.brand.toString();
      var model = androidInfo.model.toString();
      var versionRelease = androidInfo.version.release.toString();
      setState(() {
        _modelName = brand.toString() + ' ' + model.toString();
      });
    }
  }

  logOut() async {
    await loadInfo();
    var res = await postData(apiLogoutSeeker, {
      "notifyToken": [
        {"model": _modelName}
      ]
    });

    print("logout: " + res.toString());
  }

  removeSharedPreTokenAndLogOut() async {
    final prefs = await SharedPreferences.getInstance();
    await logOut();

    var removeEmployeeToken = await prefs.remove('employeeToken');
    AuthService().facebookSignOut();
    AuthService().googleSignOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()), (route) => false);
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

  getTokenSharedPre() async {
    final prefs = await SharedPreferences.getInstance();
    var employeeToken = prefs.getString("employeeToken");
    fcm();

    print("employeeToken: " + "${employeeToken}");
  }

  fetchTopBanner() async {
    var res = await postData(getTopBannerEmployee, {});
    _listTopBanners = res['info'];

    if (_listTopBanners.isNotEmpty) {
      _isLoadingTopBanner = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  fetchPopupBanner() async {
    var res = await postData(getPopupBanner, {});
    if (res == 401) {
      print("statusCode == 401");
      await removeSharedPreTokenAndLogOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    }
    _listPopupBanner = res['info'];
    print("List popup banner " + _listPopupBanner.toString());
    if (_listPopupBanner.length > 0) {
      _imagePopupBanner = _listPopupBanner[0]['image'];
      _urlPopupBanner = _listPopupBanner[0]['url'].toString().trim();

      if (_showBanner && _imagePopupBanner != "") {
        showFullScreenDialogBanner(context);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  fetchSpotLight() async {
    var res = await postData(getSpotLightEmployee, {});
    if (res == 401) {
      print("statusCode == 401");
      await removeSharedPreTokenAndLogOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    }
    _listSpotLights = res['info'];

    if (mounted) {
      setState(() {});
    }
  }

  fetchHiring() async {
    var res = await postData(getHiringEmployee, {});
    if (res == 401) {
      print("statusCode == 401");
      await removeSharedPreTokenAndLogOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    }
    _listHirings = res['info'];

    if (_listHirings.isNotEmpty) {
      _isLoadingCompanyHiring = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  fetchProvince(String lang) async {
    var res = await fetchData(groupIndustryWorkingLocationEmployee +
        "lang=${lang}&type=WorkingLocation");
    _listProvince = res['info'];

    if (_listProvince.isNotEmpty) {
      _isLoadingJobByProvince = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  fetchTopIndustry(String lang) async {
    var res = await fetchData(
        groupIndustryWorkingLocationEmployee + "lang=${lang}&type=Industry");
    _listTopIndustry = res['info'];

    if (_listTopIndustry.isNotEmpty) {
      _isLoadingJobByIndustry = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  getReuseFilterJobSearchSeeker(
      String lang, List listValue, String resValue) async {
    var res =
        await fetchData(getReuseFilterJobSearchSeekerApi + "lang=${lang}");
    if (res == 401) {
      print("statusCode == 401");
      await removeSharedPreTokenAndLogOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    }
    if (mounted) {
      setState(() {
        Iterable<dynamic> iterableRes = res[resValue.toString()] ?? [];
        listValue.clear(); // Clear the existing list
        listValue.addAll(iterableRes); // Add elements from the response
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

  fetchNotifications() async {
    var res = await postData(getNotificationsSeeker,
        {"page": 1, "perPage": 10, "type": "Notification_Page"});
    if (res == 401) {
      print("statusCode == 401");
      await removeSharedPreTokenAndLogOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    }

    _totalNotiUnRead = res['unreadTotals'].toString();
    _isLoadingNotification = false;

    print("Noti page: ${_totalNotiUnRead}");

    if (mounted) {
      setState(() {});
    }
  }

  fetchMessages() async {
    var res = await postData(getNotificationsSeeker,
        {"page": 1, "perPage": 10, "type": "Messages_Page"});
    _totalMessageUnRead = res['unreadTotals'].toString();

    print("Mess page: ${_totalMessageUnRead}");

    if (mounted) {
      setState(() {});
    }
  }

  showFullScreenDialogBanner(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.backgroundWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Container(
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 3 / 5,
                  child: GestureDetector(
                    onTap: () {
                      print("url popup banner: " + "${_urlPopupBanner}");
                      launchInBrowser(
                        Uri.parse(_urlPopupBanner),
                      );
                    },
                    child: Container(
                      child: ClipRRect(
                        child: _imagePopupBanner == ""
                            ? Image.asset(
                                'assets/image/no-image-available.png',
                                fit: BoxFit.contain,
                              )
                            : Image.network(
                                "${_imagePopupBanner}",
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
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    height: 35,
                    width: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        // SharedPreferences prefs =
                        //     await SharedPreferences.getInstance();
                        // await prefs.setBool('hasShownDialog', false);
                        setState(() {
                          _showBanner = false;
                        });
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        "\uf00d",
                        style: fontAwesomeRegular(null, 30, null, null),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  internetConnectionChecker() async {
    _subscription = InternetConnection().onStatusChange.listen((status) {
      print("status internet connection: " + status.toString());

      if (status == InternetStatus.disconnected) {
        showInternetDisconnected(context);
        setState(() {
          _isLoadingTopBanner = true;
          _isLoadingJobByProvince = true;
          _isLoadingJobByIndustry = true;
          _isLoadingCompanyHiring = true;
          _isLoadingNotification = true;
        });
      } else if (status == InternetStatus.connected) {
        fetchDataApi();
        print('initState called');
      }
    });
    _listener = AppLifecycleListener(
      onResume: _subscription.resume,
      onHide: _subscription.pause,
      onPause: _subscription.pause,
    );
  }

  fetchDataApi() async {
    _showBanner = widget.isShowBanner ?? true;

    fetchPopupBanner();
    getSharedPreferences();
    getTokenSharedPre();
    fetchNotifications();
    fetchMessages();
    fetchTopBanner();
    fetchSpotLight();
    fetchHiring();
  }

  void openWhatsApp({required String phone, String message = ''}) async {
    final url =
        Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("New refresh fcmToken: $newToken");
    });

    internetConnectionChecker();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        body:
            // _isLoading
            //     ? Container(
            //         color: AppColors.backgroundWhite,
            //         width: double.infinity,
            //         height: double.infinity,
            //         child: Center(child: CustomLoadingLogoCircle()),
            //       )
            //     :
            SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.background,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  //Section Home Header
                  Container(
                    color: AppColors.backgroundWhite,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Row(
                      children: [
                        //
                        //
                        //Logo image
                        Expanded(
                          child: Container(
                            height: 30,
                            width: 30,
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              'assets/image/Logo108.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        //
                        //
                        //Home Header
                        Container(
                          child: _isLoadingNotification
                              //
                              //
                              //loading notification and message shirmmer
                              ? HomeHeaderShirmmerWidget()
                              : Container(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      //
                                      //
                                      //ChangeLanguage
                                      ChangeLanguage(
                                          callBackSetLanguage: (val) {
                                        if (val == "Set Language Success") {
                                          getSharedPreferences();
                                        }
                                      }),
                                      SizedBox(
                                        width: 25,
                                      ),

                                      //
                                      //
                                      //Call center
                                      GestureDetector(
                                        onTap: () async {
                                          var result = await showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                                boxCircleColor:
                                                    AppColors.success200,
                                                strIcon: "\uf232",
                                                fontFamilyIcon:
                                                    "FontAwesomeBrands",
                                                iconColor: AppColors.success600,
                                                title: "open_whatsapp".tr,
                                                contentText:
                                                    "contact_us_whatsapp".tr,
                                                textButtonLeft: "cancel".tr,
                                                textButtonRight: "confirm".tr,
                                                buttonRightColor:
                                                    AppColors.success200,
                                                textButtonRightColor:
                                                    AppColors.success600,
                                                widgetBottomColor:
                                                    AppColors.success200,
                                              );
                                            },
                                          );

                                          if (result == "Ok") {
                                            openWhatsApp(
                                              phone: '8562028034426',
                                              message: '',
                                            );
                                          }
                                        },
                                        child: Text(
                                          "\uf590",
                                          style: fontAwesomeLight(null, 20,
                                              AppColors.iconDark, null),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),

                                      //
                                      //
                                      //Notication
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Notifications(
                                                callbackTotalNoti: (value) {
                                                  setState(() {
                                                    _totalNotiUnRead = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          alignment:
                                              AlignmentDirectional.center,
                                          children: [
                                            Text(
                                              "\uf0f3",
                                              style: fontAwesomeLight(null, 20,
                                                  AppColors.iconDark, null),
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
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        int.parse(_totalNotiUnRead) >=
                                                                1000
                                                            ? "1..."
                                                            : "${_totalNotiUnRead}",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: AppColors
                                                                .fontWhite),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),

                                      //
                                      //
                                      //Message
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Messages(
                                                callbackTotalNoti: (value) {
                                                  setState(() {
                                                    _totalMessageUnRead = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ).then((value) {
                                            setState(() {
                                              _totalMessageUnRead = value;
                                            });
                                          });
                                        },
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          alignment:
                                              AlignmentDirectional.center,
                                          children: [
                                            Text(
                                              "\uf27a",
                                              style: fontAwesomeLight(null, 20,
                                                  AppColors.iconDark, null),
                                            ),
                                            if (_totalMessageUnRead != "0" &&
                                                _totalMessageUnRead.isNotEmpty)
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
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        int.parse(_totalMessageUnRead) >=
                                                                1000
                                                            ? "1..."
                                                            : "${_totalMessageUnRead}",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: AppColors
                                                                .fontWhite),
                                                      ),
                                                    ],
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
                  //Section body content
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        //
                        //
                        //
                        //
                        //
                        //
                        //
                        //Top banner image
                        //if(_listTopBanners.length > 0)
                        _isLoadingTopBanner
                            //
                            //
                            //loading topbanner shirmmer
                            ? TopBannerShirmmerWidget()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_listTopBanners.length > 0)
                                    Container(
                                      padding: EdgeInsets.only(bottom: 30),
                                      // height: 180,
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
                                                .map((objTopBanner) {
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
                                                  //
                                                  //
                                                  //press top banner url
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print("url top banner" +
                                                          "${objTopBanner["url"]}");

                                                      final urlString =
                                                          objTopBanner["url"]
                                                              .toString()
                                                              .trim();
                                                      launchInBrowser(
                                                        Uri.parse(urlString),
                                                      );
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: objTopBanner[
                                                                      'image'] ==
                                                                  "" ||
                                                              objTopBanner[
                                                                      'image'] ==
                                                                  null
                                                          ? Image.asset(
                                                              'assets/image/no-image-available.png',
                                                              fit: BoxFit
                                                                  .contain,
                                                            )
                                                          : Image.network(
                                                              "https://storage.googleapis.com/108-bucket/${objTopBanner['image']}",
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
                                                                      .contain,
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
                                  // SizedBox(
                                  //   height: 30,
                                  // ),
                                ],
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
                        //job by province
                        // if (_listProvince.length > 0)
                        _isLoadingJobByProvince
                            ? JobByProvinceShirmmerWidget()
                            : Column(
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
                                        style: bodyTitleNormal(
                                            null, FontWeight.bold),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
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
                                                          _provinceName.add(
                                                              item['name']);
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
                                            style: bodyTextMinNormal(null,
                                                AppColors.fontPrimary, null),
                                          ),
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
                                  Container(
                                    height: 140,
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
                                              width: 220,
                                              padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                  color:
                                                      AppColors.backgroundWhite,
                                                  // border: Border.all(
                                                  //     color: AppColors
                                                  //         .borderGreyOpacity),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      "${i['name']}",
                                                      style: bodyTextMaxNormal(
                                                          null,
                                                          null,
                                                          FontWeight.bold),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${i['jobArvairiable'].toString()} ",
                                                        style: bodyTextMinNormal(
                                                            null,
                                                            AppColors
                                                                .fontPrimary,
                                                            null),
                                                      ),
                                                      Text(
                                                        "job available".tr,
                                                        style:
                                                            bodyTextMinNormal(
                                                                null,
                                                                null,
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
                                                          // color:
                                                          //     AppColors.red,
                                                          height: 40,
                                                          child: GridView.count(
                                                            crossAxisCount: 4,
                                                            crossAxisSpacing: 8,
                                                            mainAxisSpacing: 10,
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            children: List.generate(
                                                                _listCompaniesAssignedProvince
                                                                    .length,
                                                                (index) {
                                                              dynamic
                                                                  logoProvince =
                                                                  _listCompaniesAssignedProvince[
                                                                      index];

                                                              return Container(
                                                                width: 40,
                                                                height: 40,
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
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    child:
                                                                        Center(
                                                                      child: logoProvince['logo'] == "" ||
                                                                              logoProvince['logo'] ==
                                                                                  null
                                                                          ? Image
                                                                              .asset(
                                                                              'assets/image/no-image-available.png',
                                                                              fit: BoxFit.contain,
                                                                            )
                                                                          : Image
                                                                              .network(
                                                                              "https://storage.googleapis.com/108-bucket/${logoProvince['logo']}",
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

                                                      //ຖ້າ _listCompaniesAssignedProvince ຫຼາຍກວ່າ 3 ໃຫ້ສະແດງ Card Count ໂຕເລກ
                                                      // if (_listCompaniesAssignedProvince
                                                      //         .length >
                                                      //     3)
                                                      //   Padding(
                                                      //     padding:
                                                      //         const EdgeInsets
                                                      //             .only(
                                                      //             left: 10),
                                                      //     child: Container(
                                                      //       height: 55,
                                                      //       width: 55,
                                                      //       decoration:
                                                      //           BoxDecoration(
                                                      //         border:
                                                      //             Border.all(
                                                      //           color: AppColors
                                                      //               .borderGreyOpacity,
                                                      //         ),
                                                      //         borderRadius:
                                                      //             BorderRadius
                                                      //                 .circular(
                                                      //                     10),
                                                      //         color: AppColors
                                                      //             .backgroundWhite,
                                                      //       ),
                                                      //       child: Row(
                                                      //         crossAxisAlignment:
                                                      //             CrossAxisAlignment
                                                      //                 .center,
                                                      //         mainAxisAlignment:
                                                      //             MainAxisAlignment
                                                      //                 .center,
                                                      //         children: [
                                                      //           Text(
                                                      //             "${_listCompaniesAssignedProvince.length - 3}",
                                                      //             style: bodyTextMaxNormal(null,
                                                      //                 AppColors
                                                      //                     .fontPrimary,
                                                      //                 null),
                                                      //           ),
                                                      //           FaIcon(
                                                      //             FontAwesomeIcons
                                                      //                 .plus,
                                                      //             size: 15,
                                                      //             color: AppColors
                                                      //                 .iconPrimary,
                                                      //           ),
                                                      //         ],
                                                      //       ),
                                                      //     ),
                                                      //   )
                                                    ],
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
                                    height: 30,
                                  ),
                                ],
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
                        //job by industry
                        // if (_listTopIndustry.length > 0)
                        _isLoadingJobByIndustry
                            ? JobByIndeustryShirmmerWidget()
                            : Column(
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
                                        style: bodyTitleNormal(
                                            null, FontWeight.bold),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
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
                                                          _industryName.add(
                                                              item['name']);
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
                                            style: bodyTextMinNormal(null,
                                                AppColors.fontPrimary, null),
                                          ),
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
                                  Container(
                                    height: 140,
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
                                                width: 220,
                                                padding: EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.backgroundWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        "${i['name']}",
                                                        style: bodyTextNormal(
                                                            null,
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
                                                          style: bodyTextMinNormal(
                                                              null,
                                                              AppColors
                                                                  .fontPrimary,
                                                              null),
                                                        ),
                                                        Text(
                                                          "job available".tr,
                                                          style:
                                                              bodyTextMinNormal(
                                                                  null,
                                                                  null,
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
                                                            height: 40,
                                                            child:
                                                                GridView.count(
                                                              crossAxisCount: 4,
                                                              crossAxisSpacing:
                                                                  8,
                                                              mainAxisSpacing:
                                                                  10,
                                                              shrinkWrap: true,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              children:
                                                                  List.generate(
                                                                _listCompaniesAssignedTopIndustry
                                                                    .length,
                                                                (index) {
                                                                  dynamic
                                                                      logoTopIndustry =
                                                                      _listCompaniesAssignedTopIndustry[
                                                                          index];

                                                                  return Container(
                                                                    width: 40,
                                                                    height: 40,
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
                                                                          child: logoTopIndustry['logo'] == "" || logoTopIndustry['logo'] == null
                                                                              ? Image.asset(
                                                                                  'assets/image/no-image-available.png',
                                                                                  fit: BoxFit.contain,
                                                                                )
                                                                              : Image.network(
                                                                                  "https://storage.googleapis.com/108-bucket/${logoTopIndustry['logo']}",
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
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        //ຖ້າ _listCompaniesAssignedTopIndustry ຫຼາຍກວ່າ 3 ໃຫ້ສະແດງ Card Count ໂຕເລກ
                                                        // if (_listCompaniesAssignedTopIndustry
                                                        //         .length >
                                                        //     3)
                                                        //   Padding(
                                                        //     padding:
                                                        //         const EdgeInsets
                                                        //             .only(
                                                        //             left: 10),
                                                        //     child: Container(
                                                        //       height: 55,
                                                        //       width: 55,
                                                        //       decoration:
                                                        //           BoxDecoration(
                                                        //         border: Border
                                                        //             .all(
                                                        //           color: AppColors
                                                        //               .borderGreyOpacity,
                                                        //         ),
                                                        //         borderRadius:
                                                        //             BorderRadius
                                                        //                 .circular(
                                                        //                     10),
                                                        //         color: AppColors
                                                        //             .backgroundWhite,
                                                        //       ),
                                                        //       child: Row(
                                                        //         crossAxisAlignment:
                                                        //             CrossAxisAlignment
                                                        //                 .center,
                                                        //         mainAxisAlignment:
                                                        //             MainAxisAlignment
                                                        //                 .center,
                                                        //         children: [
                                                        //           Text(
                                                        //             "${_listCompaniesAssignedTopIndustry.length - 3}",
                                                        //             style: bodyTextMaxNormal(null,
                                                        //                 AppColors
                                                        //                     .fontPrimary,
                                                        //                 null),
                                                        //           ),
                                                        //           FaIcon(
                                                        //             FontAwesomeIcons
                                                        //                 .plus,
                                                        //             size: 15,
                                                        //             color: AppColors
                                                        //                 .iconPrimary,
                                                        //           ),
                                                        //         ],
                                                        //       ),
                                                        //     ),
                                                        //   )
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
                        //
                        //
                        //
                        //
                        //
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
                                      carouselController: _controllerSpotLights,
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
                                        autoPlay: _listSpotLights.length > 1
                                            ? true
                                            : false,
                                        onPageChanged: (index, _) {
                                          setState(() {
                                            _currentSpotLightsIndex = index;
                                          });
                                        },
                                      ),
                                      items: _listSpotLights.map((imagePath) {
                                        return Builder(builder: (context) {
                                          return Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                  child: imagePath['image'] ==
                                                              "" ||
                                                          imagePath['image'] ==
                                                              null
                                                      ? Image.asset(
                                                          'assets/image/no-image-available.png',
                                                          fit: BoxFit.fill,
                                                        )
                                                      : Image.network(
                                                          "https://storage.googleapis.com/108-bucket/${imagePath['image']}",
                                                          fit: BoxFit.fill,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
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
                            ],
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
                        //Companies actively hiring
                        // if (_listHirings.length > 0)
                        _isLoadingCompanyHiring
                            ? CompanyHiringShirmmerWidget()
                            : Column(
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
                                          style: bodyTitleNormal(
                                              null, FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      //
                                      //
                                      //text explore all company
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
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
                                                style: bodyTextMinNormal(
                                                    null,
                                                    AppColors.fontPrimary,
                                                    null),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 320,
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
                                                  //hiring card cover
                                                  Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .greyShimmer,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8),
                                                            topRight:
                                                                Radius.circular(
                                                                    8),
                                                          ),
                                                        ),
                                                        child: AspectRatio(
                                                          aspectRatio: 5 / 2,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(8),
                                                              topRight: Radius
                                                                  .circular(8),
                                                            ),
                                                            child: i['cardCover'] ==
                                                                        "" ||
                                                                    i['cardCover'] ==
                                                                        null
                                                                ? Center(
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              30),
                                                                      child:
                                                                          FaIcon(
                                                                        FontAwesomeIcons
                                                                            .image,
                                                                        size:
                                                                            40,
                                                                        color: AppColors
                                                                            .secondary,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Image.network(
                                                                    "https://storage.googleapis.com/108-bucket/${i['cardCover']}",
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    errorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return Center(
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.only(bottom: 30),
                                                                          child:
                                                                              FaIcon(
                                                                            FontAwesomeIcons.image,
                                                                            size:
                                                                                40,
                                                                            color:
                                                                                AppColors.secondary,
                                                                          ),
                                                                        ),
                                                                      ); // Display an error message
                                                                    },
                                                                  ),
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
                                                      //         style: bodyTextNormal(null,
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
                                                      //         style: bodyTextNormal(null,
                                                      //             AppColors
                                                      //                 .fontPrimary,
                                                      //             null),
                                                      //       )
                                                      //     ]),
                                                      //   ),
                                                      // )
                                                    ],
                                                  ),

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
                                                                  .circular(8),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                height: 20,
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
                                                                          null,
                                                                          FontWeight
                                                                              .bold),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
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
                                                                      Text(
                                                                        "\uf275",
                                                                        style: fontAwesomeRegular(
                                                                            null,
                                                                            12,
                                                                            AppColors.iconDark,
                                                                            null),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Flexible(
                                                                        child:
                                                                            Text(
                                                                          "${_industry}",
                                                                          style: bodyTextSmall(
                                                                              null,
                                                                              null,
                                                                              null),
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
                                                                      Text(
                                                                        "\uf007",
                                                                        style: fontAwesomeRegular(
                                                                            null,
                                                                            12,
                                                                            AppColors.iconDark,
                                                                            null),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Flexible(
                                                                        child:
                                                                            Text(
                                                                          "${_address}",
                                                                          style: bodyTextSmall(
                                                                              null,
                                                                              null,
                                                                              null),
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

                                                              //
                                                              //
                                                              //Button view positions
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColors
                                                                      .lightPrimary,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              CompanyDetail(
                                                                            companyId:
                                                                                i['_id'],
                                                                            typeTapCompany:
                                                                                "jobOpening",
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              12),
                                                                      child:
                                                                          Text(
                                                                        "view".tr +
                                                                            " ${_jobsOpening} " +
                                                                            "position".tr,
                                                                        style: bodyTextNormal(
                                                                            null,
                                                                            AppColors.fontPrimary,
                                                                            null),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),

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
                                                              //               bodyTextSmall(null,null,
                                                              //                   null),
                                                              //         ),
                                                              //         Text(
                                                              //           "follower"
                                                              //               .tr,
                                                              //           style:
                                                              //               bodyTextSmall(null,null,
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
                                                            height: 70,
                                                            width: 70,
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
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                child: i['logo'] ==
                                                                            "" ||
                                                                        i['logo'] ==
                                                                            null
                                                                    ? Image
                                                                        .asset(
                                                                        'assets/image/no-image-available.png',
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      )
                                                                    : Image
                                                                        .network(
                                                                        "https://storage.googleapis.com/108-bucket/${i['logo']}",
                                                                        fit: BoxFit
                                                                            .contain,
                                                                        errorBuilder: (context,
                                                                            error,
                                                                            stackTrace) {
                                                                          return Image
                                                                              .asset(
                                                                            'assets/image/no-image-available.png',
                                                                            fit:
                                                                                BoxFit.contain,
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
                        //           style: bodyTextMaxNormal(null,
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
                        //                 style: bodyTextNormal(null,
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
                        //                         "https://storage.googleapis.com/108-bucket/${i['logo']}",
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
