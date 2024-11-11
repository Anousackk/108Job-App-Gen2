// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print, unused_element, prefer_adjacent_string_concatenation, unnecessary_new, await_only_futures, prefer_const_declarations, override_on_non_overriding_member, deprecated_member_use, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, non_constant_identifier_names, prefer_const_literals_to_create_immutables, unused_field, unrelated_type_equality_checks, avoid_unnecessary_containers, sized_box_for_whitespace, body_might_complete_normally_nullable, prefer_final_fields
import 'dart:io';
import 'package:app/firebase_options.dart';
import 'package:app/functions/colors.dart';
import 'package:app/i18n/i18n.dart';
import 'package:app/routes.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/screen/screenAfterSignIn/Notifications/notification.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearchDetail.dart';
import 'package:app/screen/screenAfterSignIn/message/message.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//
//
//
//main()
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      description: 'This channel is used for important .', // description
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

    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         IOSFlutterLocalNotificationsPlugin>()
    //     ?.requestPermissions(
    //       alert: true,
    //       badge: true,
    //       sound: true,
    //     );
  }

  //Application in foreground(flutter_local_notifications)
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

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
  } else if (Platform.isAndroid) {
    print('Running on Android. Android version: ${Platform.version}');
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
              iOS: DarwinNotificationDetails(),
            ),
          );
        }
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        // Handle notification when the app is completely closed and opened by the user
        await handleMessage(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // Handle notification when the app is in the background and opened by the user
      await handleMessage(message);
    });
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
    getLanguageSharePref = prefs.getString('setLanguage');

    if (getLanguageSharePref == 'lo') {
      Get.updateLocale(Locale('lo', 'LA'));
    } else if (getLanguageSharePref == 'en') {
      Get.updateLocale(Locale('en', 'US'));
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
    // DynamicLinkService.dynamicLinkPushScreen;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    //Get.deviceLocale
    print("Main locale: " + '${Get.locale}');
    FocusScopeNode currentFocus = FocusScopeNode();

    return Sizer(
      builder: (context, orientation, deviceType) {
        return GestureDetector(
          onTap: () {
            currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: GetMaterialApp(
            // color: AppColors.backgroundWhite,
            translations: LocalString(),
            locale: Locale('lo', 'LA'),
            fallbackLocale: Locale('lo', 'LA'),
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            theme: ThemeData(
              useMaterial3: false,
              scaffoldBackgroundColor: AppColors.backgroundWhite,
              textTheme: TextTheme(),

              fontFamily: Get.locale == Locale('lo', 'LA') || Get.locale == null
                  ? 'NotoSansLaoLoopedRegular'
                  : 'SatoshiMedium',
              // primaryColor: primaryColor,
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.backgroundWhite,

                // color: AppColors.red,
                elevation: 0,

                // systemOverlayStyle: SystemUiOverlayStyle.dark,
                // systemOverlayStyle: SystemUiOverlayStyle(
                //     statusBarColor: AppColors.white,
                //     systemNavigationBarColor: AppColors.black),
              ),
            ),
            home: Scaffold(
              // backgroundColor: AppColors.backgroundWhite,
              appBar: AppBar(
                toolbarHeight: 0,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                // backgroundColor: AppColors.backgroundWhite,
              ),
              body: Login(),
              // body: UpgradeAlert(
              //   upgrader: Upgrader(
              //     // showIgnore: false,
              //     // showLater: false,
              //     // canDismissDialog: false,
              //     // showReleaseNotes: false,
              //     // shouldPopScope: () => false,
              //     durationUntilAlertAgain: Duration(days: 1),
              //     storeController: UpgraderStoreController(
              //       onAndroid: () => UpgraderPlayStore(),
              //       oniOS: () => UpgraderAppStore(),
              //     ),
              //     // dialogStyle: Platform.isIOS
              //     //     ? UpgradeDialogStyle.cupertino
              //     //     : UpgradeDialogStyle.material,
              //     // messages: UpgraderMessages(),
              //     messages: MyUpgraderMessages(),
              //   ),
              //   child: Login(),
              // ),
            ),
            localizationsDelegates: [
              // add your localizations delegates here
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
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
    );
  }
}
