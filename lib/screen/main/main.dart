// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, avoid_unnecessary_containers, unnecessary_brace_in_string_interps, prefer_adjacent_string_concatenation, avoid_print, prefer_final_fields, unused_field

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

  checkTokenLogin() async {
    final prefs = await SharedPreferences.getInstance();
    //
    //get token from shared preferences.
    var employeeToken = prefs.getString('employeeToken');

    if (employeeToken != null) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Home()), (route) => false);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkTokenLogin();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imageSlideCarousel = [
      'assets/image/Typeso-black.jpeg',
      'assets/image/Typeso-green.jpeg',
      'assets/image/Typeso-white.jpeg',
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
                    flex: 1,
                    child: ChangeLanguage(),
                  ),

                  //
                  //
                  //Logo 108Jobs
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 120,
                      width: 120,
                      child:
                          Image(image: AssetImage('assets/image/Logo108.png')),
                    ),
                  ),

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
                            items: imageSlideCarousel.map((String imagePath) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Image(
                                      image: AssetImage(imagePath),
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          Positioned(
                            bottom: 30,
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
