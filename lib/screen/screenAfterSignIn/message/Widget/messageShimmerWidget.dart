// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:app/functions/colors.dart';
import 'package:app/functions/shimmerBox.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class MessageShimmerWidget extends StatelessWidget {
  const MessageShimmerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundWhite,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Shimmer.fromColors(
          baseColor: AppColors.dark200,
          highlightColor: AppColors.dark100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              //title1
              shimmerBox(height: 20, width: 70.w),
              SizedBox(height: 10),

              shimmerBox(height: 10, width: 30.w),
              SizedBox(height: 40),

              //tittle2
              shimmerBox(height: 20, width: 50.w),
              SizedBox(height: 10),

              shimmerBox(height: 10, width: 30.w),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
