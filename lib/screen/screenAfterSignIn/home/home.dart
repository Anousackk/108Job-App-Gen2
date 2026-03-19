// ignore_for_file: prefer_final_fields, unused_local_variable, avoid_print, prefer_interpolation_to_compose_strings, unused_field, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, prefer_is_empty, use_build_context_synchronously, deprecated_member_use, prefer_adjacent_string_concatenation, sized_box_for_whitespace

import 'dart:async';
import 'dart:io';

import 'package:app/screen/ScreenAfterSignIn/Account/MyProfile/myProfile.dart';
import 'package:app/screen/screenAfterSignIn/home/Widget/topbannerShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app/firebase_options.dart';
import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/api.dart';
import 'package:app/functions/auth_service.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/internetDisconnected.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/parsDateTime.dart';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/provider/bannerProvider.dart';
import 'package:app/provider/eventAvailableProvider.dart';
import 'package:app/provider/localSharePrefsProvider.dart';
import 'package:app/provider/popupBanner.dart';
import 'package:app/provider/profileDashboardStatus.dart';
import 'package:app/provider/profileProvider.dart';
import 'package:app/provider/recommendJobByAI.dart';
import 'package:app/provider/reuseTypeProvider.dart';
import 'package:app/screen/Main/changeLanguage.dart';
import 'package:app/screen/ScreenAfterSignIn/Account/Events/registerEvent.dart';
import 'package:app/screen/ScreenAfterSignIn/Message/message.dart';
import 'package:app/screen/ScreenAfterSignIn/Notifications/notification.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/screen/screenAfterSignIn/account/account.dart';
import 'package:app/screen/screenAfterSignIn/company/company.dart';
import 'package:app/screen/screenAfterSignIn/home/Widget/profileShimmerWidget.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearch.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearchDetail.dart';
import 'package:app/screen/screenAfterSignIn/myJob/myJob.dart';
import 'package:app/widget/button.dart';
import 'package:apple_product_name/apple_product_name.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CarouselSliderController _controllerTopBanner =
      CarouselSliderController();
  late final StreamSubscription<InternetStatus> _subscription;
  late final AppLifecycleListener _listener;
  final ScrollController _scrollController = ScrollController();
  // Focus node for search input
  final FocusNode _searchFocusNode = FocusNode();

  dynamic _fcmToken;
  // dynamic _seekerProfile;
  // dynamic _workPreferences;
  // dynamic _eventInfo;

  // List _listTopBanners = [];
  // List _listPopupBanner = [];

  String _modelName = "";

  // String _totalNotiUnRead = "";
  // String _totalMessageUnRead = "";
  String _localeLanguageApi = "EN";
  String _myJobStatus = "SeekerSaveJob";

  int _currentTopBannerIndex = 0;
  int _currentIndex = 0;

  // Controller for search input
  final TextEditingController _searchController = TextEditingController();

  Timer? _disconnectTimer;
  bool _hasShownDisconnectedDialog = false;

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
    // final prefs = await SharedPreferences.getInstance();
    await logOut();

    // var removeEmployeeToken = await prefs.remove('employeeToken');
    var removeEmployeeToken = await SharedPrefsHelper.remove("employeeToken");
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
    // final prefs = await SharedPreferences.getInstance();
    // var employeeToken = prefs.getString("employeeToken");
    var employeeToken = await SharedPrefsHelper.getString("employeeToken");
    fcm();

    print("employeeToken: " + "${employeeToken}");
  }

  showDialogPopupBanner(
    BuildContext context,
    String imagePopupBanner,
    String urlPopupBanner,
  ) async {
    final popupProvider = context.read<PopupBannerProvider>();
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
                // AspectRatio(
                //   aspectRatio: 4 / 5,
                // child:
                GestureDetector(
                  onTap: () {
                    print("url popup banner: " + "${urlPopupBanner}");
                    launchInBrowser(
                      Uri.parse(urlPopupBanner),
                    );
                  },
                  child: Container(
                    child: ClipRRect(
                      child: imagePopupBanner == ""
                          ? Image.asset(
                              'assets/image/no-image-available.png',
                              fit: BoxFit.contain,
                            )
                          : Image.network(
                              "${imagePopupBanner}",
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
                // ),
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
                          popupProvider.setIsShowPopupBanner(false);
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

  loadPopupBanner() async {
    final popupProvider = context.read<PopupBannerProvider>();

    var statusCode = await popupProvider.fetchPopupBanner();

    // Token expired → logout + redirect
    if (statusCode == 401) {
      await removeSharedPreTokenAndLogOut();
    }

    print(
        "popupProvider.isShowPopupBanner: + ${popupProvider.isShowPopupBanner}");

    // Display popup banner
    if (popupProvider.isShowPopupBanner &&
        popupProvider.imagePopupBanner.isNotEmpty) {
      showDialogPopupBanner(
        context,
        popupProvider.imagePopupBanner,
        popupProvider.urlPopupBanner,
      );
    }
  }

  internetConnectionChecker() async {
    final topBannerProvider = context.read<BannerProvider>();
    _subscription = InternetConnection().onStatusChange.listen((status) {
      print("status internet connection: " + status.toString());

      if (status == InternetStatus.disconnected) {
        // Cancel any existing timer
        _disconnectTimer?.cancel();

        // Start a 10-second timer
        _disconnectTimer = Timer(Duration(seconds: 10), () {
          // Check if still disconnected and dialog hasn't been shown
          if (!_hasShownDisconnectedDialog) {
            showInternetDisconnected(context);
            _hasShownDisconnectedDialog = true;
            setState(() {
              // _isLoadingNotification = true;
            });
            topBannerProvider.setIsLoadingBanner(true);
          }
        });
      } else if (status == InternetStatus.connected) {
        // Cancel the disconnect timer if internet reconnects
        _disconnectTimer?.cancel();

        // Reset the dialog flag when reconnected
        _hasShownDisconnectedDialog = false;

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
    await getTokenSharedPre();

    Future.delayed(Duration(seconds: 1), () {
      context.read<BannerProvider>().fetchTopBanner();
      context.read<EventAvailableProvider>().fetchStatisticEvent();
      context.read<EventAvailableProvider>().fetchEventAvailable();
      context.read<ProfileProvider>().fetchProfileSeeker();
      context.read<RecommendJobAIProvider>().fetchRecommendJobAI();
      context
          .read<ProfileDashboardStatusProvider>()
          .fetchProfileDashboardStatus();
    });
  }

  openWhatsApp({required String phone, String message = ''}) async {
    final url =
        Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  pullDownRefreshScreen() async {
    final profileProvider = context.read<ProfileProvider>();
    final topBannerProvider = context.read<BannerProvider>();

    setState(() {
      // _isLoadingNotification = true;
    });

    profileProvider.setPercentage(0);
    profileProvider.setPercentageUse(0.0);

    profileProvider.setIsLoadingProfile(true);
    topBannerProvider.setIsLoadingBanner(true);

    Future.delayed(Duration(seconds: 2), () {
      fetchDataApi();
    });
  }

  // localLanguage from share prefs and fetch api reuse, province
  loadLanguageSharedPrefs() async {
    final localLanguage = await context
        .read<LocalSharedPrefsProvider>()
        .localLanguageFromSharedPreference();

    final reuseTypeProvider = context.read<ReuseTypeProvider>();

    await context
        .read<ProfileProvider>()
        .fetchProvinceAndDistrict(localLanguage);

    await context.read<ProfileProvider>().fetchBennefit(localLanguage);
    await context.read<ProfileProvider>().fetchJobFunction();

    await reuseTypeProvider.fetchReuseTypeSeeker(localLanguage, 'Nationality');
    await reuseTypeProvider.fetchReuseTypeSeeker(
        localLanguage, 'CurrentResidence');
    await reuseTypeProvider.fetchReuseTypeSeeker(localLanguage, 'Gender');
    await reuseTypeProvider.fetchReuseTypeSeeker(
        localLanguage, 'MaritalStatus');
    await reuseTypeProvider.fetchReuseTypeSeeker(localLanguage, 'SkillLevel');
    await reuseTypeProvider.fetchReuseTypeSeeker(
        localLanguage, 'LanguageLevel');
    await reuseTypeProvider.fetchReuseTypeSeeker(localLanguage, 'Language');
    await reuseTypeProvider.fetchReuseTypeSeeker(
        _localeLanguageApi, 'JobLevel');
    await reuseTypeProvider.fetchReuseTypeSeeker(
        _localeLanguageApi, 'Province');
    await reuseTypeProvider.fetchReuseTypeSeeker(
        _localeLanguageApi, 'Industry');
  }

  onTapBottomNav(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("New refresh fcmToken: $newToken");
    });

    internetConnectionChecker();
    loadPopupBanner();
    loadLanguageSharedPrefs();
  }

  @override
  void dispose() {
    _disconnectTimer?.cancel();
    _subscription.cancel();
    _listener.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final topBannerProvider = context.watch<BannerProvider>();
    final eventAvailableProvider = context.watch<EventAvailableProvider>();
    final statisticEventProvider = context.watch<EventAvailableProvider>();
    final recommendJobByAI = context.watch<RecommendJobAIProvider>();
    final profileDashboardStatusProvider =
        context.watch<ProfileDashboardStatusProvider>();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        // ====================================================================
        // APP BAR
        // ====================================================================
        appBar: AppBar(
          toolbarHeight: 0,
          // systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: _currentIndex == 0
              ? AppColors.primaryCustom
              : AppColors.backgroundWhite,
        ),
        backgroundColor: AppColors.backgroundWhite,

        // ====================================================================
        // BODY
        // ====================================================================
        body: IndexedStack(
          index: _currentIndex,
          children: [
            // Tab 0 Home
            _buildHomeBottomNavigationBar(
              profileProvider: profileProvider,
              topBannerProvider: topBannerProvider,
              eventAvailableProvider: eventAvailableProvider,
              statisticEventProvider: statisticEventProvider,
              recommendJobByAI: recommendJobByAI,
              profileDashboardStatusProvider: profileDashboardStatusProvider,
            ),

            // Tab 1 Job Search
            JobSearch(
              topWorkLocation: null,
              topIndustry: null,
              type: "",
              selectedListItem: null,
            ),

            // Tab 2 Company
            Company(companyType: ""),

            // Tab 3 Account
            Account(),
          ],
        ),

        // ====================================================================
        // BOTTOM NAVIGATION BAR
        // ====================================================================
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.backgroundWhite,
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: 12,
          selectedFontSize: 12,
          showSelectedLabels:
              true, // Set to true to show labels for selected tabs
          showUnselectedLabels:
              true, // Set to true to show labels for unselected tabs
          selectedItemColor: AppColors.primaryCustom,

          // iconSize: 25,
          currentIndex: _currentIndex,
          onTap: (index) => onTapBottomNav(index),
          items: [
            // Home
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

            // Job Search
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

            // Company
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

            // Account
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                ),
                child: _currentIndex == 3
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

  Widget _buildHomeBottomNavigationBar({
    required ProfileProvider profileProvider,
    required BannerProvider topBannerProvider,
    required EventAvailableProvider eventAvailableProvider,
    required EventAvailableProvider statisticEventProvider,
    required RecommendJobAIProvider recommendJobByAI,
    required ProfileDashboardStatusProvider profileDashboardStatusProvider,
  }) {
    return SafeArea(
      child: Stack(
        children: [
          // ====================================================================
          // BACKGROUND COLOR BAR (behind header)
          // ====================================================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.primaryCustom,
              height: 50.h,
            ),
          ),

          // ====================================================================
          // MAIN CONTENT WITH PULL-TO-REFRESH
          // ====================================================================
          RefreshIndicator(
            onRefresh: () async {
              await pullDownRefreshScreen();
              _scrollController.animateTo(
                0,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                // ====================================================================
                // HEADER APP BAR WITH LOGO & ACTIONS
                // ====================================================================
                SliverAppBar(
                  pinned: false,
                  floating: true,
                  snap: false,
                  backgroundColor: AppColors.primaryCustom,
                  elevation: 0,
                  toolbarHeight: 70,
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      // 108jobs Logo
                      Container(
                        height: 70,
                        width: 70,
                        alignment: Alignment.centerLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: SvgPicture.asset(
                            'assets/svg/108jobs_logo_white.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // Header Actions (Language, WhatsApp, Message)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Language Switcher
                            ChangeLanguage(callBackSetLanguage: (val) {}),
                            SizedBox(width: 25),

                            // WhatsApp Contact
                            GestureDetector(
                              onTap: () async {
                                var result = await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return NewVer2CustAlertDialogWarningBtnConfirmCancel(
                                      boxCircleColor: AppColors.success200,
                                      strIcon: "\uf232",
                                      fontFamilyIcon: "FontAwesomeBrands",
                                      iconColor: AppColors.success600,
                                      title: "open_whatsapp".tr,
                                      contentText: "contact_us_whatsapp".tr,
                                      textButtonLeft: "cancel".tr,
                                      textButtonRight: "confirm".tr,
                                      buttonRightColor: AppColors.success200,
                                      textButtonRightColor:
                                          AppColors.success600,
                                      widgetBottomColor: AppColors.success200,
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
                                style: fontAwesomeSolid(
                                    null, 20, AppColors.iconLight, null),
                              ),
                            ),
                            SizedBox(width: 30),

                            // Messages with Badge
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Messages(),
                                  ),
                                );
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: AlignmentDirectional.center,
                                children: [
                                  // Message Icon
                                  Text(
                                    "\uf27a",
                                    style: fontAwesomeSolid(
                                        null, 20, AppColors.iconLight, null),
                                  ),
                                  // Unread Message Badge
                                  if (profileDashboardStatusProvider
                                          .totalMessages !=
                                      0)
                                    Positioned(
                                      top: -12,
                                      right: -15,
                                      child: Container(
                                        height: 22,
                                        width: 22,
                                        decoration: BoxDecoration(
                                          color: AppColors.danger,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              profileDashboardStatusProvider
                                                          .totalMessages >=
                                                      100
                                                  ? "10+"
                                                  : "${profileDashboardStatusProvider.totalMessages}",
                                              style: bodyTextMiniSmall(
                                                  null,
                                                  AppColors.fontWhite,
                                                  FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),

                // ====================================================================
                // BANNER & SEARCH SECTION
                // ====================================================================
                SliverToBoxAdapter(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      color: AppColors.primaryCustom,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ====================================================================
                          // PROMOTIONAL BANNER CAROUSEL
                          // ====================================================================
                          // if (topBannerProvider.isLoadingTopBanner) ...[
                          //   TopBannerShirmmerWidget()
                          // ] else
                          if (topBannerProvider.listTopBanners.isNotEmpty) ...[
                            Container(
                              child: Stack(
                                children: [
                                  // Banner Carousel Slider
                                  CarouselSlider(
                                    carouselController: _controllerTopBanner,
                                    options: CarouselOptions(
                                      aspectRatio: 16 / 6,
                                      viewportFraction: 1.0,
                                      enlargeCenterPage: true,
                                      enableInfiniteScroll: topBannerProvider
                                              .listTopBanners.length >
                                          1,
                                      autoPlay: topBannerProvider
                                              .listTopBanners.length >
                                          1,
                                      autoPlayInterval: Duration(seconds: 10),
                                      onPageChanged: (index, _) {
                                        setState(() {
                                          _currentTopBannerIndex = index;
                                        });
                                      },
                                    ),
                                    items: topBannerProvider.listTopBanners
                                        .map((objTopBanner) {
                                      return Builder(builder: (context) {
                                        return Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              // Open banner URL if available
                                              if (objTopBanner["url"] != null &&
                                                  objTopBanner["url"]
                                                      .toString()
                                                      .isNotEmpty) {
                                                String urlString =
                                                    objTopBanner["url"]
                                                        .toString()
                                                        .trim();
                                                launchInBrowser(
                                                    Uri.parse(urlString));
                                              }
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: objTopBanner['image']
                                                          .toString()
                                                          .isEmpty ||
                                                      objTopBanner['image'] ==
                                                          null
                                                  ? Container(
                                                      color: AppColors
                                                          .backgroundWhite,
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Image.asset(
                                                        "assets/image/108job-logo-text.png",
                                                        fit: BoxFit.contain,
                                                      ),
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl:
                                                          "https://storage.googleapis.com/108-bucket/${objTopBanner['image']}",
                                                      fit: BoxFit.contain,
                                                      placeholder: (context,
                                                              url) =>
                                                          TopBannerShirmmerWidget(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                        "assets/image/108job-logo-text.png",
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        );
                                      });
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(height: 20),
                          ],

                          // ====================================================================
                          // SEARCH BAR WITH INPUT AND BUTTON
                          // ====================================================================

                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 15, vertical: 5),
                          //   decoration: BoxDecoration(
                          //     color: AppColors.inputWhite,
                          //     borderRadius: BorderRadius.circular(15),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       // Search Icon
                          //       Icon(
                          //         Icons.search,
                          //         color: AppColors.iconSecondary,
                          //         size: 22,
                          //       ),
                          //       SizedBox(width: 10),
                          //       // Search Input Field
                          //       Expanded(
                          //         child: TextField(
                          //           controller: _searchController,
                          //           focusNode: _searchFocusNode,
                          //           decoration: InputDecoration(
                          //             hintText: "Job title or company...",
                          //             hintStyle: bodyTextNormal(
                          //                 null, AppColors.secondary, null),
                          //             border: InputBorder.none,
                          //           ),
                          //         ),
                          //       ),
                          //       // Search Button
                          //       GestureDetector(
                          //         onTap: () {
                          //           _searchFocusNode.unfocus();
                          //           Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //               builder: (context) => JobSearch(
                          //                 topWorkLocation: null,
                          //                 topIndustry: null,
                          //                 type: "",
                          //                 selectedListItem: null,
                          //                 initialSearchQuery:
                          //                     _searchController.text.trim(),
                          //               ),
                          //             ),
                          //           ).then((val) {
                          //             _searchController.text = "";
                          //           });
                          //         },
                          //         child: Container(
                          //           padding: EdgeInsets.symmetric(
                          //               horizontal: 20, vertical: 10),
                          //           decoration: BoxDecoration(
                          //             color: AppColors.primaryCustom,
                          //             borderRadius:
                          //                 BorderRadius.circular(10),
                          //           ),
                          //           child: Text(
                          //             "search".tr,
                          //             style: bodyTextNormal(
                          //                 null, AppColors.fontWhite, null),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: AppColors.backgroundWhite,
                    child: Column(
                      children: [
                        // ====================================================================
                        // EVENT INFORMATION BOX
                        // ====================================================================
                        if (eventAvailableProvider.eventInfo != null)
                          Padding(
                            padding:
                                EdgeInsets.only(top: 15, left: 20, right: 20),
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: AppColors.teal,
                                border: Border.all(color: AppColors.teal),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Event Name
                                  Text(
                                    "${eventAvailableProvider.eventInfoName}",
                                    style: bodyTextMaxNormal(null,
                                        AppColors.fontWhite, FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  // Event Time
                                  Text(
                                    "${eventAvailableProvider.eventInfoOpeningTime}",
                                    style: bodyTextNormal(
                                        null, AppColors.fontWhite, null),
                                  ),
                                  SizedBox(height: 15),

                                  // ====================================================================
                                  // EVENT STATISTICS (Candidates / Companies / Positions)
                                  // ====================================================================
                                  // This section displays the event statistics, including the number of candidates, companies, and positions.
                                  Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColors.dark,
                                    ),
                                    child: Row(
                                      children: [
                                        // Candidates Count
                                        // This section displays the number of candidates attending the event.
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${statisticEventProvider.candidateTotals}",
                                                  style: bodyTextMedium(
                                                      "SatoshiBlack",
                                                      AppColors.fontWhite,
                                                      FontWeight.bold),
                                                ),
                                                Text(
                                                  "candidates".tr,
                                                  style: bodyTextMaxSmall(
                                                      null,
                                                      AppColors.fontWhite,
                                                      FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Divider
                                        Container(
                                            width: 1,
                                            color: AppColors.borderWhite,
                                            height: 40),

                                        // Companies Count
                                        // This section displays the number of companies attending the event.
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${statisticEventProvider.companyTotals}",
                                                  style: bodyTextMedium(
                                                      "SatoshiBlack",
                                                      AppColors.fontWhite,
                                                      FontWeight.bold),
                                                ),
                                                Text(
                                                  "companies".tr,
                                                  style: bodyTextMaxSmall(
                                                      null,
                                                      AppColors.fontWhite,
                                                      FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Divider
                                        Container(
                                            width: 1,
                                            color: AppColors.borderWhite,
                                            height: 40),

                                        // Positions Count
                                        // This section displays the number of positions available at the event.
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${statisticEventProvider.jobTotals}",
                                                  style: bodyTextMedium(
                                                      "SatoshiBlack",
                                                      AppColors.fontWhite,
                                                      FontWeight.bold),
                                                ),
                                                Text(
                                                  "positions".tr,
                                                  style: bodyTextMaxSmall(
                                                      null,
                                                      AppColors.fontWhite,
                                                      FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 15),

                                  Button(
                                    buttonColor: AppColors.info,
                                    text: "event_detail".tr,
                                    textColor: AppColors.fontDark,
                                    textFontWeight: FontWeight.bold,
                                    press: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RegisterEvent(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Category Cards
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30, left: 20, right: 20),
                          child: Column(
                            children: [
                              // Row 1: Jobsearch, Company, Notification
                              Row(
                                children: [
                                  Expanded(
                                    child: BoxCardCategoryV1(
                                      backgroundIconColor: AppColors.success100,
                                      iconText: "\uf002",
                                      iconColor: AppColors.teal,
                                      title: "job search".tr,
                                      total:
                                          "${profileDashboardStatusProvider.totalJobSearchs}+",
                                      totalColor: AppColors.teal,
                                      press: () {
                                        onTapBottomNav(1);
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => JobSearch(
                                        //       topWorkLocation: null,
                                        //       topIndustry: null,
                                        //       type: "",
                                        //       selectedListItem: null,
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: BoxCardCategoryV1(
                                      backgroundIconColor:
                                          AppColors.orange.withOpacity(0.1),
                                      iconText: "\uf1ad",
                                      iconColor: AppColors.orange,
                                      title: "company".tr,
                                      total:
                                          "${profileDashboardStatusProvider.totalCompanies}+",
                                      totalColor: AppColors.orange,
                                      press: () {
                                        onTapBottomNav(2);
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         Company(companyType: ""),
                                        //   ),
                                        // );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: BoxCardCategoryV1(
                                      backgroundIconColor: AppColors.danger100,
                                      iconText: "\uf0f3",
                                      iconColor: AppColors.danger,
                                      title: "notification".tr,
                                      total:
                                          "${profileDashboardStatusProvider.totalNotifications} " +
                                              "new".tr,
                                      totalColor: AppColors.danger,
                                      press: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Notifications(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 15),

                              // Row 2: Save Job Hide Job & Applied Job
                              Row(
                                children: [
                                  Expanded(
                                    child: BoxCardCategoryV1(
                                      backgroundIconColor: AppColors.primary100,
                                      iconText: "\uf02e",
                                      iconColor: AppColors.primary600,
                                      title: "save job".tr,
                                      total:
                                          "${profileDashboardStatusProvider.totalSavedJobs} " +
                                              "saved".tr,
                                      totalColor: AppColors.primary600,
                                      press: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyJobs(
                                                myJobStatus: "SeekerSaveJob"),
                                          ),
                                        ).then((val) {
                                          if (val == "next_jobsearch") {
                                            onTapBottomNav(1);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: BoxCardCategoryV1(
                                      backgroundIconColor: AppColors.warning100,
                                      iconText: "\uf05e",
                                      iconColor: AppColors.warning600,
                                      title: "hide job".tr,
                                      total:
                                          "${profileDashboardStatusProvider.totalHiddenJobs} " +
                                              "hidded".tr,
                                      totalColor: AppColors.warning600,
                                      press: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyJobs(
                                                myJobStatus: "SeekerHideJob"),
                                          ),
                                        ).then((val) {
                                          if (val == "next_jobsearch") {
                                            onTapBottomNav(1);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: BoxCardCategoryV1(
                                      backgroundIconColor: AppColors.success100,
                                      iconText: "\uf1d8",
                                      iconColor: AppColors.teal,
                                      title: "applied_job".tr,
                                      total:
                                          "${profileDashboardStatusProvider.totalAppliedJobs} " +
                                              "applied".tr,
                                      totalColor: AppColors.teal,
                                      press: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyJobs(
                                                myJobStatus: "AppliedJob"),
                                          ),
                                        ).then((val) {
                                          if (val == "next_jobsearch") {
                                            onTapBottomNav(1);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              // SizedBox(height: 15),
                              // Notifications Card - Full Width
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => Notifications(),
                              //       ),
                              //     );
                              //   },
                              //   child: Container(
                              //     width: double.infinity,
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal: 20, vertical: 15),
                              //     decoration: BoxDecoration(
                              //       color: AppColors.backgroundWhite,
                              //       borderRadius: BorderRadius.circular(15),
                              //       border: Border.all(
                              //           color: AppColors.dark
                              //               .withOpacity(0.05)),
                              //       boxShadow: [
                              //         BoxShadow(
                              //           color: AppColors.dark
                              //               .withOpacity(0.05),
                              //           blurRadius: 5,
                              //           spreadRadius: 0,
                              //           offset: Offset(2, 3),
                              //         ),
                              //       ],
                              //     ),
                              //     child: Row(
                              //       children: [
                              //         Container(
                              //           padding: EdgeInsets.all(12),
                              //           decoration: BoxDecoration(
                              //             color: AppColors.danger100,
                              //             borderRadius:
                              //                 BorderRadius.circular(12),
                              //           ),
                              //           child: Text(
                              //             "\uf0f3",
                              //             style: fontAwesomeRegular(null,
                              //                 20, AppColors.danger, null),
                              //           ),
                              //         ),
                              //         SizedBox(width: 15),
                              //         Expanded(
                              //           child: Text(
                              //             "notification".tr,
                              //             style: bodyTextNormal(
                              //                 null,
                              //                 AppColors.dark,
                              //                 FontWeight.bold),
                              //           ),
                              //         ),
                              //         if (profileDashboardStatusProvider
                              //                 .totalNotifications >
                              //             0)
                              //           Container(
                              //             padding: EdgeInsets.symmetric(
                              //                 horizontal: 12, vertical: 6),
                              //             decoration: BoxDecoration(
                              //               color: AppColors.danger,
                              //               borderRadius:
                              //                   BorderRadius.circular(20),
                              //             ),
                              //             child: Text(
                              //               "${profileDashboardStatusProvider.totalNotifications}" +
                              //                   " " +
                              //                   "new".tr,
                              //               style: bodyTextSmall(
                              //                   null,
                              //                   AppColors.fontWhite,
                              //                   FontWeight.bold),
                              //             ),
                              //           ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),

                        // Profile Box
                        profileProvider.isLoadingProfile
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top: 30, left: 20, right: 20),
                                child: BoxContainProfileShirmmerWidget(),
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                    top: 30, left: 20, right: 20),
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              profileProvider.isProfileVerified
                                                  ? AppColors.borderPrimary
                                                  : AppColors.borderGreyOpacity,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Stack(
                                                clipBehavior: Clip.none,
                                                alignment: Alignment.center,
                                                children: [
                                                  CircularPercentIndicator(
                                                    radius: 40.0,
                                                    lineWidth: 4.0,
                                                    animation: true,
                                                    percent: profileProvider
                                                        .percentageUsed,
                                                    animationDuration: 500,
                                                    startAngle: 140.0,
                                                    linearGradient: AppColors
                                                        .primaryRingGradient,
                                                    backgroundColor:
                                                        AppColors.primary200,
                                                    center: Container(
                                                      width: 60,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .backgroundWhite,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: profileProvider
                                                                .imageSrc
                                                                .isEmpty
                                                            ? Image.asset(
                                                                'assets/image/defprofile.jpg',
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : CachedNetworkImage(
                                                                imageUrl:
                                                                    "${profileProvider.imageSrc}",
                                                                fit: BoxFit
                                                                    .cover,
                                                                // placeholder: (context,
                                                                //         url) =>
                                                                //     TopBannerShirmmerWidget(),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Image.asset(
                                                                  "assets/image/defprofile.jpg",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5,
                                                              vertical: 3),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        border: Border.all(
                                                            color: AppColors
                                                                .borderWhite),
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                      child: Text(
                                                        "${(profileProvider.percentageUsed * 100).round()}%",
                                                        style: bodyTextCustom(
                                                            9,
                                                            null,
                                                            AppColors.fontWhite,
                                                            FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 15),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${profileProvider.firstName} ${profileProvider.lastName}",
                                                      style: bodyTextNormal(
                                                          null,
                                                          null,
                                                          FontWeight.bold),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      "${profileProvider.currentJobTitle}",
                                                      style: bodyTextSmall(
                                                          null,
                                                          AppColors.fontGrey,
                                                          null),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      "status".tr +
                                                          ": ${profileProvider.memberLevel}",
                                                      style: bodyTextSmall(
                                                          null,
                                                          AppColors.fontGrey,
                                                          null),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Button(
                                            buttonColor:
                                                AppColors.primaryCustom,
                                            text: "button_update_profile".tr,
                                            textFontWeight: FontWeight.bold,
                                            press: () {
                                              // onTapBottomNav(3);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyProfile(),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Verified Badge
                                    if (profileProvider.isProfileVerified)
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                "\uf2f7",
                                                style: fontAwesomeSolid(
                                                    null,
                                                    13,
                                                    AppColors.iconLight,
                                                    null),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                "verified".tr,
                                                style: bodyTextSmall(
                                                    null,
                                                    AppColors.fontWhite,
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                        // Recommended Jobs / AI Matching Jobs
                        if (recommendJobByAI.listRecommendJobs.isNotEmpty)
                          Padding(
                            padding:
                                EdgeInsets.only(top: 30, left: 20, right: 20),
                            child: Column(
                              children: [
                                // Header
                                Container(
                                  padding: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: AppColors.borderSecondary),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 4,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(5),
                                                bottomRight: Radius.circular(5),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "recommend_job".tr,
                                            style: bodyTitleNormal(
                                                null, FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Job List
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      recommendJobByAI.listRecommendJobs.length,
                                  itemBuilder: (context, indexRecommend) {
                                    dynamic i = recommendJobByAI
                                        .listRecommendJobs[indexRecommend];

                                    String logoCompany =
                                        i['employerId']?['logo'] ?? "";
                                    String jobTitle = i['title'] ?? "";
                                    String companyName =
                                        i['employerId']?['companyName'] ?? "";

                                    List? workingLocation =
                                        i['workingLocationId'];
                                    String workLocation =
                                        (workingLocation != null &&
                                                workingLocation.isNotEmpty)
                                            ? workingLocation[0]['name'] ?? ""
                                            : "";

                                    dynamic openDate = i['openingDate'];
                                    dynamic closeDate = i['closingDate'];

                                    String openDateStr = "";
                                    String closeDateStr = "";

                                    if (openDate != null) {
                                      try {
                                        DateTime openDateConvert = parsDateTime(
                                            value: openDate,
                                            currentFormat:
                                                "yyyy-MM-ddTHH:mm:ssZ",
                                            desiredFormat:
                                                "yyyy-MM-dd HH:mm:ss");
                                        openDateStr = DateFormat('dd MMM yyyy')
                                            .format(openDateConvert);
                                      } catch (e) {
                                        print("Parse openDate error: $e");
                                      }
                                    }

                                    if (closeDate != null) {
                                      try {
                                        DateTime closeDateConvert =
                                            parsDateTime(
                                                value: closeDate,
                                                currentFormat:
                                                    "yyyy-MM-ddTHH:mm:ssZ",
                                                desiredFormat:
                                                    "yyyy-MM-dd HH:mm:ss");
                                        closeDateStr = DateFormat('dd MMM yyyy')
                                            .format(closeDateConvert);
                                      } catch (e) {
                                        print("Parse closeDate error: $e");
                                      }
                                    }

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                JobSearchDetail(
                                              jobId: i['_id'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                color:
                                                    AppColors.borderSecondary),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Company Logo
                                                Container(
                                                  width: 65,
                                                  height: 65,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColors
                                                            .borderSecondary),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: AppColors
                                                        .backgroundWhite,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Center(
                                                        child: logoCompany == ""
                                                            ? Image.asset(
                                                                'assets/image/available-image-none-background.png',
                                                                fit: BoxFit
                                                                    .contain,
                                                              )
                                                            : CachedNetworkImage(
                                                                imageUrl:
                                                                    "https://storage.googleapis.com/108-bucket/${logoCompany}",
                                                                fit: BoxFit
                                                                    .contain,
                                                                // placeholder: (context,
                                                                //         url) =>
                                                                //     TopBannerShirmmerWidget(),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Image.asset(
                                                                  "assets/image/available-image-none-background.png",
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                              ),
                                                        // Image.network(
                                                        //     "https://storage.googleapis.com/108-bucket/${logoCompany}",
                                                        //     fit: BoxFit
                                                        //         .contain,
                                                        //     errorBuilder:
                                                        //         (context,
                                                        //             error,
                                                        //             stackTrace) {
                                                        //       return Image
                                                        //           .asset(
                                                        //         'assets/image/available-image-none-background.png',
                                                        //         fit: BoxFit
                                                        //             .contain,
                                                        //       );
                                                        //     },
                                                        //   ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 15),

                                                // Company Info
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${companyName}",
                                                        style: bodyTextSmall(
                                                            null, null, null),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        "${workLocation}",
                                                        style: bodyTextSmall(
                                                            null, null, null),
                                                      ),
                                                      SizedBox(height: 3),
                                                      Text(
                                                        "$openDateStr - $closeDateStr",
                                                        style: bodyTextSmall(
                                                            null, null, null),
                                                      ),
                                                      // Text(
                                                      //   "${openDate} - ${closeDate}",
                                                      //   style: bodyTextSmall(
                                                      //       null, null, null),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 10),

                                                // AI Icon
                                                Container(
                                                  height: 15,
                                                  width: 15,
                                                  child: Image.asset(
                                                    'assets/image/ai.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                            Text(
                                              "${jobTitle}",
                                              style: bodyTextSuperMaxNormal(
                                                  null, null, FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BoxCardCategoryV1 extends StatefulWidget {
  const BoxCardCategoryV1({
    Key? key,
    required this.iconText,
    required this.title,
    required this.total,
    required this.backgroundIconColor,
    required this.iconColor,
    required this.totalColor,
    this.press,
  }) : super(key: key);

  final String iconText, title, total;
  final Color backgroundIconColor, iconColor, totalColor;
  final Function()? press;

  @override
  State<BoxCardCategoryV1> createState() => _BoxCardCategoryV1State();
}

class _BoxCardCategoryV1State extends State<BoxCardCategoryV1> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.dark.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: AppColors.dark.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon + Background
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.backgroundIconColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "${widget.iconText}",
                style: fontAwesomeRegular(null, 15, widget.iconColor, null),
              ),
            ),
            SizedBox(height: 10),

            // Title
            Text(
              "${widget.title}",
              style: bodyTextMaxSmall(null, null, FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),

            // Number
            Text(
              "${widget.total}",
              style: bodyTextSmall(
                  "SatoshiBold", widget.totalColor, FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class BoxContainCategory extends StatefulWidget {
  const BoxContainCategory({
    Key? key,
    this.boxColor,
    this.borderColor,
    this.iconColor,
    this.textColor,
    this.numTotalColor,
    this.icon,
    this.text,
    this.numTotal,
    this.press,
  }) : super(key: key);
  final Color? boxColor, borderColor, iconColor, textColor, numTotalColor;
  final String? icon, text, numTotal;
  final Function()? press;

  @override
  State<BoxContainCategory> createState() => _BoxContainCategoryState();
}

class _BoxContainCategoryState extends State<BoxContainCategory> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.boxColor ?? AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: widget.borderColor ?? AppColors.primary400),
        ),
        child: Column(
          children: [
            Text(
              "${widget.icon}",
              style: fontAwesomeSolid(
                  null, 20, widget.iconColor ?? AppColors.iconPrimary, null),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.text}",
                  style: bodyTextMaxSmall(null,
                      widget.textColor ?? AppColors.dark, FontWeight.bold),
                ),
                if (widget.numTotal != null && widget.numTotal != "")
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      "${widget.numTotal}",
                      style: bodyTextMaxSmall(
                          "SatoshiBold",
                          widget.numTotalColor ?? AppColors.primary,
                          FontWeight.bold),
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
