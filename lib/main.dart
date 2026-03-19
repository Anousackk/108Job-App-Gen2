// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print, unused_element, prefer_adjacent_string_concatenation, unnecessary_new, await_only_futures, prefer_const_declarations, override_on_non_overriding_member, deprecated_member_use, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, non_constant_identifier_names, prefer_const_literals_to_create_immutables, unused_field, unrelated_type_equality_checks, avoid_unnecessary_containers, sized_box_for_whitespace, body_might_complete_normally_nullable, prefer_final_fields, prefer_interpolation_to_compose_strings, unnecessary_import, use_build_context_synchronously
import 'dart:io';
import 'package:app/alertUpgraderMessages.dart';
import 'package:app/customUpgradeAlert.dart';
import 'package:app/firebase_options.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:app/i18n/i18n.dart';
import 'package:app/provider/avatarProvider.dart';
import 'package:app/provider/bannerProvider.dart';
import 'package:app/provider/companyProvider.dart';
import 'package:app/provider/eventAvailableProvider.dart';
import 'package:app/provider/jobSearchProvider.dart';
import 'package:app/provider/localSharePrefsProvider.dart';
import 'package:app/provider/myJobProvider.dart';
import 'package:app/provider/notifierProvider.dart';
import 'package:app/provider/popupBanner.dart';
import 'package:app/provider/profileDashboardStatus.dart';
import 'package:app/provider/profileProvider.dart';
import 'package:app/provider/recommendJobByAI.dart';
import 'package:app/provider/reuseTypeProvider.dart';
import 'package:app/routes.dart';
import 'package:app/screen/ScreenAfterSignIn/Home/home.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/screen/screenAfterSignIn/Notifications/notification.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearchDetail_old.dart';
import 'package:app/screen/screenAfterSignIn/message/message.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:upgrader/upgrader.dart';

//Background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
}

late AndroidNotificationChannel channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//
//
//
//main()
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Upgrader.sharedInstance.initialize();

  //1. Initialize the firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //2. Initialize firebase messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // ✅ ขอ permission จาก FirebaseMessaging โดยตรง (ครั้งเดียว)
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false, // ← false สำคัญมาก
    );
    print('iOS Permission: ${settings.authorizationStatus}');

    // ✅ ขอ permission จาก flutter_local_notifications และตั้งค่า badge
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );

    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         IOSFlutterLocalNotificationsPlugin>()
    //     ?.requestPermissions(
    //       alert: true,
    //       badge: true,
    //       sound: true,
    //       provisional: true,
    //     );
  }

  //Application in foreground(flutter_local_notifications)
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true, // ← เพิ่ม
    requestSoundPermission: true,
  );
  // final DarwinInitializationSettings initializationSettingsDarwin =
  //     DarwinInitializationSettings();

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
  final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  //Lock Portrait Screen
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (Platform.isIOS) {
    print('Running on iOS. iOS version: ${Platform.operatingSystemVersion}');
    // String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    // print("APNs Token: $apnsToken");

    // String? token = await FirebaseMessaging.instance.getToken();
    // print("FCM Token: $token");
  } else if (Platform.isAndroid) {
    print('Running on Android. Android version: ${Platform.version}');

    // String? token = await FirebaseMessaging.instance.getToken();
    // print("FCM Token: $token");
  } else {
    print('Running on neither iOS nor Android.');
  }

  // Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode:
  //       false
  // );

  // Workmanager().registerPeriodicTask(
  //   "ExampleTask",
  //   "ExampleTaskPeriodicTask",
  //   frequency: Duration(minutes: 15),
  //   existingWorkPolicy: ExistingWorkPolicy.append,
  // );

  runApp(MyApp());
}

//MyApp
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String? getLanguageSharePref;
  String? _sharePreEmpToken;
  int _badgeCount = 0; // ✅ เพิ่มตัวแปรนับ badge

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  bool _isDynamicLinkHandled = false;

  Future<void> initializeFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');

        final notification = message.notification;
        final android = message.notification?.android;
        final iOS = message.notification?.apple;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker',
                icon: "@mipmap/ic_launcher",
              ),
            ),
          );
        } else if (notification != null && iOS != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
          );

          // ✅ อัปเดต badge number สำหรับ iOS
          _updateBadgeNumber();
        }
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        // Handle notification when the app is completely closed and opened by the user
        await handleMessage(message);
        // ✅ ล้าง badge เมื่อเปิด app จาก notification
        _clearBadgeNumber();
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // Handle notification when the app is in the background and opened by the user
      await handleMessage(message);
      // ✅ ล้าง badge เมื่อเปิด app จาก notification
      _clearBadgeNumber();
    });
  }

  // ✅ ฟังก์ชันสำหรับจัดการ badge number
  Future<void> _updateBadgeNumber() async {
    if (Platform.isIOS) {
      try {
        setState(() {
          _badgeCount++; // ✅ เพิ่มจำนวน badge
        });

        // ส่ง notification พร้อมตั้งค่า badge number
        await flutterLocalNotificationsPlugin.show(
          DateTime.now().millisecondsSinceEpoch.remainder(100000),
          '',
          '',
          NotificationDetails(
            iOS: DarwinNotificationDetails(
              presentAlert: false,
              presentBadge: true,
              presentSound: false,
              badgeNumber: _badgeCount, // ✅ ใช้จำนวนจริง
            ),
          ),
        );
        print('Badge updated with number: $_badgeCount');
      } catch (e) {
        print('Error updating badge: $e');
      }
    }
  }

  Future<void> _clearBadgeNumber() async {
    if (Platform.isIOS) {
      try {
        setState(() {
          _badgeCount = 0; // ✅ รีเซ็ตจำนวน badge
        });

        // ล้าง badge โดยตั้งค่าเป็น 0
        await flutterLocalNotificationsPlugin.show(
          DateTime.now().millisecondsSinceEpoch.remainder(100000),
          '',
          '',
          NotificationDetails(
            iOS: DarwinNotificationDetails(
              presentAlert: false,
              presentBadge: true,
              presentSound: false,
              badgeNumber: 0, // ✅ ใช้จำนวนจริง
            ),
          ),
        );
        print('Badge cleared (set to 0)');
      } catch (e) {
        print('Error clearing badge: $e');
      }
    }
  }

  // Future<void> firebaseAnalytics() async {
  //   await FirebaseAnalytics.instance.logEvent(
  //     name: "Pao-kun",
  //     parameters: {
  //       "full_text": "Hello World!!!",
  //     },
  //   );
  // }

  handleMessage(RemoteMessage message) async {
    print("message ${message}");
    //Screen: Notification_Page
    //Screen: Messages_Page
    if (message.data['screen'] == 'Notification_Page') {
      // print("Notification_Page:  ${message.data}");

      // dynamic jobId = message.data['id'];
      // print("jobId: ${jobId}");

      // navigatorKey.currentState?.pushNamed(
      //   JobSearchDetail.routeName,
      //   arguments: JobSearchDetail(
      //     jobId: jobId,
      //   ),
      // );

      navigatorKey.currentState?.pushNamed(
        Notifications.routeName,
        arguments: Notifications(),
      );
    } else if (message.data['screen'] == 'Messages_Page') {
      // print("Messages_Page:  ${message.data}");

      // dynamic msgId = message.data['id'];
      // print("msgId: ${msgId}");

      // navigatorKey.currentState?.pushNamed(
      //   JobSearchDetail.routeName,
      //   arguments: JobSearchDetail(
      //     jobId: jobId,
      //   ),
      // );
      navigatorKey.currentState?.pushNamed(
        Messages.routeName,
        arguments: Messages(),
      );
    }
  }

  checkLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    // var employeeToken = prefs.getString('employeeToken');
    // getLanguageSharePref = prefs.getString('setLanguage');

    String? employeeToken = await SharedPrefsHelper.getString("employeeToken");
    getLanguageSharePref = await SharedPrefsHelper.getString("setLanguage");

    if (employeeToken != null) {
      setState(() {
        _sharePreEmpToken = employeeToken.toString();
        print("sharePreEmployeeToken: " + "${_sharePreEmpToken}");
      });
    } else {
      setState(() {
        _sharePreEmpToken = null;
        print("sharePreEmployeeToken: " + "${_sharePreEmpToken}");
      });
    }

    if (getLanguageSharePref == 'lo') {
      var locale = Locale('lo', 'LA');
      Get.updateLocale(locale);
    } else if (getLanguageSharePref == 'en') {
      var locale = Locale('en', 'US');
      Get.updateLocale(locale);
    }

    print('getLanguageSharePref: ' + getLanguageSharePref.toString());
  }

  handleDynamicLinks() async {
    print("Main handleDynamicLinks");

    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData? dynamicLinkData) {
      if (!_isDynamicLinkHandled && dynamicLinkData != null) {
        handleDeepLink(dynamicLinkData);
        setState(() {
          _isDynamicLinkHandled = true; // Mark link as handled
        });
      }
    }).onError((error) {
      print('Dynamic Link Failed: $error');
    });
  }

  handleDeepLink(PendingDynamicLinkData dynamicLinkData) async {
    print("Main handleDeepLink");

    final Uri deepLink = await dynamicLinkData.link;
    // Parse the jobSearchId from the URL, for example: https://108.jobs/job_detail/12345
    final jobSearchId = deepLink.pathSegments.contains('job_detail')
        ? deepLink.pathSegments.last
        : null;
    print(deepLink.toString());
    print(jobSearchId.toString());

    if (jobSearchId != null) {
      print("Have jobSearchId: ${jobSearchId}");
      // Navigate to the job detail screen with the extracted jobSearchId

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => JobSearchDetail(
            jobId: jobSearchId.toString(),
            newJob: false,
            status: false,
          ),
        ),
      );
    }
  }

  //error setState() called after dispose(). it can help!!!
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  //

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    checkLanguage();
    initializeFCM();
    handleDynamicLinks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("Main App Resumed");
      _isDynamicLinkHandled = false;
      handleDynamicLinks();
      // ✅ ล้าง badge เมื่อกลับมาใช้แอป
      _clearBadgeNumber();
    }
  }

  @override
  Widget build(BuildContext context) {
    //Get.deviceLocale
    print("Main locale: " + '${Get.locale}'); //en_US, lo_LA
    print("Main locale: " + '${Get.locale?.languageCode}'); //en, lo

    FocusScopeNode currentFocus = FocusScopeNode();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotifierProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => BannerProvider()),
        ChangeNotifierProvider(create: (_) => AvatarProvider()),
        ChangeNotifierProvider(create: (_) => PopupBannerProvider()),
        ChangeNotifierProvider(create: (_) => EventAvailableProvider()),
        ChangeNotifierProvider(create: (_) => ReuseTypeProvider()),
        ChangeNotifierProvider(create: (_) => LocalSharedPrefsProvider()),
        ChangeNotifierProvider(create: (_) => RecommendJobAIProvider()),
        ChangeNotifierProvider(create: (_) => ProfileDashboardStatusProvider()),
        ChangeNotifierProvider(create: (_) => JobSearchProvider()),
        ChangeNotifierProvider(create: (_) => MyJobProvider()),
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return GestureDetector(
            onTap: () {
              currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: GetMaterialApp(
              translations: LocalString(),
              // locale: Locale('lo', 'LA'),
              // fallbackLocale: Locale('lo', 'LA'),
              locale: Get.locale?.languageCode == 'en'
                  ? Locale('en', 'US')
                  : Locale('lo', 'LA'),
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              theme: ThemeData(
                useMaterial3: false,
                scaffoldBackgroundColor: AppColors.backgroundWhite,
                textTheme: TextTheme(),

                fontFamily:
                    Get.locale == Locale('lo', 'LA') || Get.locale == null
                        ? 'NotoSansLaoLoopedRegular'
                        : Get.locale == Locale('en', 'US')
                            ? 'SatoshiMedium'
                            : 'SatoshiMedium',
                // primaryColor: primaryColor,
                appBarTheme: AppBarTheme(
                  backgroundColor: AppColors.backgroundWhite,
                  elevation: 0,
                  // color: AppColors.red,
                  // systemOverlayStyle: SystemUiOverlayStyle.dark,
                  // systemOverlayStyle: SystemUiOverlayStyle(
                  //     statusBarColor: AppColors.white,
                  //     systemNavigationBarColor: AppColors.black),
                ),
              ),
              home: Scaffold(
                // backgroundColor: AppColors.backgroundWhite,

                // appBar: AppBar(
                //   toolbarHeight: 0,
                //   systemOverlayStyle: SystemUiOverlayStyle.dark,
                //   backgroundColor: AppColors.backgroundAppBar,
                // ),

                body: CustomUpgradeAlert(
                  upgrader: Upgrader(
                    // debugDisplayAlways: true,
                    // debugLogging: true,
                    durationUntilAlertAgain: Duration.zero,
                    messages: MyUpgraderMessages(),
                  ),
                  child: _sharePreEmpToken == null ? Login() : Home(),
                ),
              ),
              localizationsDelegates: [
                // add your localizations delegates here
                // GlobalMaterialLocalizations.delegate,
                // GlobalCupertinoLocalizations.delegate,
                // GlobalWidgetsLocalizations.delegate,
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
                FlutterQuillLocalizations.delegate,
              ],
              routes: routes,
              onGenerateRoute: (settings) {
                print("settings: ${settings}");
                if (settings.name == Notifications.routeName) {
                  final args = settings.arguments as Notifications;

                  print("args: ${args}");
                  return MaterialPageRoute(
                    builder: (context) {
                      return Notifications();
                    },
                  );
                } else {
                  final args = settings.arguments as Messages;

                  print("args: ${args}");
                  return MaterialPageRoute(
                    builder: (context) {
                      return Messages();
                    },
                  );
                }
                // assert(false, 'Need to implement ${settings.name}');
                // return null;
              },
            ),
          );
        },
      ),
    );
  }
}
