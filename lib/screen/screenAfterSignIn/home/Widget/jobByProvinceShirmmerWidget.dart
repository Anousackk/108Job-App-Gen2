// ignore_for_file: prefer_const_constructors, camel_case_types, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:app/functions/colors.dart';
import 'package:app/functions/shimmerBox.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class JobByProvinceShirmmerWidget extends StatelessWidget {
  const JobByProvinceShirmmerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.dark200,
      highlightColor: AppColors.dark100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              shimmerBox(
                height: 20,
                width: 40.w,
                borderRadius: BorderRadius.circular(10),
              ),
              shimmerBox(
                height: 10,
                width: 10.w,
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          ),
          SizedBox(height: 10),
          shimmerBox(
            height: 140,
            width: 100.w,
            borderRadius: BorderRadius.circular(10),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
