// ignore_for_file: prefer_const_constructors, avoid_print, prefer_final_fields

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class WidgetVipoPoint extends StatefulWidget {
  const WidgetVipoPoint({
    Key? key,
    this.press,
  }) : super(key: key);

  final Function()? press;

  @override
  State<WidgetVipoPoint> createState() => _WidgetVipoPointState();
}

class _WidgetVipoPointState extends State<WidgetVipoPoint> {
  bool isVisible = true; // Track visibility

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 100,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 300), // Smooth animation
            curve: Curves.easeInOut,

            left: isVisible ? 0 : -100.w, // Slide left when hidden
            child: Container(
              width: 70.w,
              // margin: EdgeInsets.only(right: 30.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.press,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(80),
                    bottomRight: Radius.circular(80),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Image.asset('assets/image/duckvipo.jpg',
                              width: 80),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            "click_mee_get_it".tr,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isVisible)
            Positioned(
              top: 0,
              bottom: 0,
              right: 25.w,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isVisible = false; // Hide widget on close
                  });
                },
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.dark100,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "\uf053",
                    style: fontAwesomeRegular(null, 25, null, null),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
