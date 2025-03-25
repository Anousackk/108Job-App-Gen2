// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:app/functions/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 150),
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
                  child: Image.asset('assets/image/duckvipo.jpg', width: 80),
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
    );
  }
}
