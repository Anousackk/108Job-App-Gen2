// ignore_for_file: prefer_const_constructors, camel_case_types, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:app/functions/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TopBannerShirmmerWidget extends StatelessWidget {
  const TopBannerShirmmerWidget({
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
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
