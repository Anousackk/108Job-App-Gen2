// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, avoid_unnecessary_containers, unnecessary_brace_in_string_interps, prefer_adjacent_string_concatenation, avoid_print, prefer_final_fields, unused_field, prefer_const_literals_to_create_immutables

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/screen/screenAfterSignIn/home/home.dart';
import 'package:app/screen/login/login.dart';
import 'package:app/screen/main/changeLanguage.dart';
import 'package:app/screen/register/register.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

//
//
//Main Body
class MainBody extends StatefulWidget {
  const MainBody({Key? key}) : super(key: key);
  static String routeName = '/MainBody';

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  final CarouselController _controller = CarouselController();

  int _currentImageIndex = 0;
  bool _isLoading = true;

  //error setState() called after dispose(). it can help!!!
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  //

  checkTokenLogin() async {
    final prefs = await SharedPreferences.getInstance();
    //
    //get token from shared preferences.
    var employeeToken = prefs.getString('employeeToken');

    if (employeeToken != null) {
      // _isLoading = false;
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Home()), (route) => false);
    } else {
      _isLoading = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    checkTokenLogin();

    // Future.delayed(Duration(seconds: 1), () {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List imageSlideCarousel = [
      {
        "title": 'Hide Job',
        "text":
            'If you are focusing on relevant experience, you can simply leave off the unrelated job entirely.',
        "image": 'assets/image/Typeso-black.jpeg',
      },
      {
        "title": 'Save Job',
        "text":
            'Provide you with the capability to shortlist this role for your consideration in the future.',
        "image": 'assets/image/Typeso-green.jpeg',
      },
      {
        "title": 'Job Alert',
        "text":
            'Job alerts deliver relevant opportunities directly to your inbox, saving you valuable time and effort.',
        "image": 'assets/image/Typeso-white.jpeg',
      },
      {
        "title": 'Instant Apply',
        "text":
            "Increase your chances of landing an interview by applying instantly to relevant jobs. Instant Apply saves you time and ensures your application is received by the employer promptly.",
        "image": 'assets/image/Typeso-black.jpeg',
      }
    ];

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: _isLoading
          ? Container(
              color: AppColors.white,
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: AppColors.white,
              child: SafeArea(
                  child: Column(
                children: [
                  //
                  //
                  //Change Language Lao-Eng
                  Expanded(
                    flex: 2,
                    child: ChangeLanguage(),
                  ),

                  //
                  //
                  //Logo 108Jobs
                  // Expanded(
                  //   flex: 3,
                  //   child: Container(
                  //     height: 120,
                  //     width: 120,
                  //     child:
                  //         Image(image: AssetImage('assets/image/Logo108.png')),
                  //   ),
                  // ),

                  //
                  //
                  //Images Slide Carousel
                  Expanded(
                    flex: 12,
                    child: Container(
                      // color: AppColors.grey,
                      child: Stack(
                        children: [
                          CarouselSlider(
                            carouselController: _controller,
                            options: CarouselOptions(
                              height: double
                                  .infinity, // Set height to occupy full screen height
                              viewportFraction: 1.0, // Show one item at a time
                              enlargeCenterPage: true,
                              autoPlay: true, // Enable auto play if needed
                              onPageChanged: (index, _) {
                                setState(() {
                                  _currentImageIndex = index;
                                  // print(_currentImageIndex.toString());
                                });
                              },
                            ),
                            items: imageSlideCarousel.map((imagePath) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Image(
                                          image: AssetImage(imagePath['image']),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          // color: AppColors.green,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                imagePath['title'],
                                                style: bodyTextMedium(
                                                    null, FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                imagePath['text'],
                                                style: bodyTextMaxNormal(
                                                    null, null),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          // Positioned(
                          //   bottom: 5,
                          //   child: Column(
                          //     children: [
                          //       Text("Hide Job - ເຊື່ອງວຽກທີ່ບໍ່ມັກ"),
                          //       Text(
                          //           "If you are focusing on relevant experience, you can simply leave off the unrelated job entirely."),
                          //     ],
                          //   ),
                          // ),
                          Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: imageSlideCarousel
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                return Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == entry.key
                                        ? AppColors.iconPrimary
                                        : AppColors.greyOpacity,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  //
                  //
                  //Create Account and Sign In Account
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        SimpleButton(
                          text: "createAccount".tr,
                          fontWeight: FontWeight.bold,
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Register(
                                  statusButotn: "fromMain",
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            );
                          },
                          child: Text(
                            "alreadyHaveAccount".tr,
                            style:
                                bodyTextMaxNormal(AppColors.fontPrimary, null),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
            ),
    );
  }
}
