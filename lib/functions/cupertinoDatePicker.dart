// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:app/functions/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

showDialogDateTime(
  BuildContext context,
  Widget textTitle,
  Widget child,
  // Widget buttonClear, Widget buttonOk
) {
  showCupertinoModalPopup<void>(
    semanticsDismissible: true,
    // barrierDismissible: false, //ບໍ່ໃຫ້ສະໄລປິດ ຫຼື ຄິກບ່ອນອື່ນເພື່ອປິດ
    // barrierColor: AppColors.red,
    context: context,
    builder: (BuildContext context) => Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: AppColors.white,
      ),
      child: Scaffold(
        body: Container(
          color: AppColors.white,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Expanded(
                flex: 1,
                child: textTitle,
              ),
              Expanded(
                flex: 5,
                child: child,
              ),
              SizedBox(
                height: 30,
              ),

              //
              //button Confirmed and Cancel
              // Expanded(
              //   flex: 2,
              //   child: Row(
              //     children: [
              // Close the modal
              // CupertinoButton(
              //   child: const Text('OK'),
              //   onPressed: () => Navigator.of(context).pop(),
              // ),

              // Expanded(flex: 1, child: buttonClear),
              // SizedBox(
              //   width: 2.w,
              // ),
              // Expanded(flex: 1, child: buttonOk)
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    ),
  );
}
