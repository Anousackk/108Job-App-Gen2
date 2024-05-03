// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print, unused_element, prefer_adjacent_string_concatenation, unnecessary_new, await_only_futures, prefer_const_declarations, override_on_non_overriding_member, deprecated_member_use, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, non_constant_identifier_names, prefer_const_literals_to_create_immutables, unused_field, unrelated_type_equality_checks, avoid_unnecessary_containers, sized_box_for_whitespace
import 'dart:async';
import 'dart:io';
import 'package:app/functions/colors.dart';
import 'package:app/i18n/i18n.dart';
import 'package:app/routes.dart';
import 'package:app/screen/main/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

//main()
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
              body: MainBody(),
            ),
            localizationsDelegates: [
              // add your localizations delegates here
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            routes: routes,
          ),
        );
      },
    );
  }
}
