// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print, unused_element, prefer_adjacent_string_concatenation, unnecessary_new, await_only_futures, prefer_const_declarations, override_on_non_overriding_member, deprecated_member_use, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, non_constant_identifier_names, prefer_const_literals_to_create_immutables, unused_field, unrelated_type_equality_checks, avoid_unnecessary_containers, sized_box_for_whitespace, body_might_complete_normally_nullable
import 'dart:io';
import 'package:app/MyUpgraderMessages.dart';
import 'package:app/firebase_options.dart';
import 'package:app/functions/colors.dart';
import 'package:app/i18n/i18n.dart';
import 'package:app/routes.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/screen/screenAfterSignIn/jobSearch/jobSearchDetail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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

class MyAppState extends State<MyApp> {
  Future<void> _initializeFCM() async {
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

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // Handle notification when the app is completely closed and opened by the user
        _handleMessage(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification when the app is in the background and opened by the user
      _handleMessage(message);
    });
  }

  void _handleMessage(RemoteMessage message) {
    print("message ${message}");
    if (message.data['screen'] == 'Jobpage') {
      print("message.data ${message.data}");

      String jobId = message.data['id'];
      print("jobId ${jobId}");

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) =>
      //         JobSearchDetail(jobId: message.data['id'].toString()),
      //   ),
      // );
      navigatorKey.currentState?.pushNamed(
        JobSearchDetail.routeName,
        arguments: JobSearchDetail(
          jobId: jobId,
        ),
      );
    }
  }

  checkLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    var getLanguageSharePref = prefs.getString('setLanguage');

    if (getLanguageSharePref == 'lo') {
      Get.updateLocale(Locale('lo', 'LA'));
    } else if (getLanguageSharePref == 'en') {
      Get.updateLocale(Locale('en', 'US'));
    }

    print('getLanguageSharePref: ' + getLanguageSharePref.toString());
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
    checkLanguage();
    _initializeFCM();

    // foregroundLocalNoti();
  }

  @override
  Widget build(BuildContext context) {
    //Get.deviceLocale
    print("Main locale: " + '${Get.locale}');

    const primaryColor = Color(0xFF151026);
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
            translations: LocalString(),
            locale: Locale('lo', 'LA'),
            fallbackLocale: Locale('lo', 'LA'),
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            theme: ThemeData(
              // scaffoldBackgroundColor: AppColors.dark,
              fontFamily: 'NotoSansLaoRegular',
              primaryColor: primaryColor,
              appBarTheme: AppBarTheme(
                // color: AppColors.dark,
                elevation: 0,

                // systemOverlayStyle: SystemUiOverlayStyle.dark,
                // systemOverlayStyle: SystemUiOverlayStyle(
                //     statusBarColor: AppColors.white,
                //     systemNavigationBarColor: AppColors.black),
              ),
            ),
            home: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                backgroundColor: AppColors.white,
              ),
              // body: Login(),
              body: UpgradeAlert(
                upgrader: Upgrader(
                  showIgnore: false,
                  showLater: false,
                  canDismissDialog: false,
                  showReleaseNotes: false,
                  // shouldPopScope: () => false,
                  durationUntilAlertAgain: Duration(days: 1),
                  dialogStyle: Platform.isIOS
                      ? UpgradeDialogStyle.cupertino
                      : UpgradeDialogStyle.material,
                  // messages: UpgraderMessages(),
                  messages: MyUpgraderMessages(),
                ),
                child: Login(),
              ),
            ),
            localizationsDelegates: [
              // add your localizations delegates here
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            routes: routes,
            onGenerateRoute: (settings) {
              print("settings: ${settings}");
              if (settings.name == JobSearchDetail.routeName) {
                final args = settings.arguments as JobSearchDetail;

                print("args: ${args}");
                return MaterialPageRoute(
                  builder: (context) {
                    return JobSearchDetail(
                      jobId: args.jobId.toString(),
                    );
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
