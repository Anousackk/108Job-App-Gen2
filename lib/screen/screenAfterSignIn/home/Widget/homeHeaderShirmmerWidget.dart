// ignore_for_file: prefer_const_constructors, camel_case_types, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:app/functions/colors.dart';
import 'package:app/functions/shimmerBox.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeHeaderShirmmerWidget extends StatelessWidget {
  const HomeHeaderShirmmerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.dark200,
      highlightColor: AppColors.dark100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            shimmerBox(
              height: 30,
              width: 30,
              borderRadius: BorderRadius.circular(100),
            ),
            SizedBox(
              width: 20,
            ),
            shimmerBox(
              height: 30,
              width: 30,
              borderRadius: BorderRadius.circular(100),
            ),
            SizedBox(
              width: 20,
            ),
            shimmerBox(
              height: 30,
              width: 30,
              borderRadius: BorderRadius.circular(100),
            ),
            SizedBox(
              width: 20,
            ),
            shimmerBox(
              height: 30,
              width: 30,
              borderRadius: BorderRadius.circular(100),
            ),
          ],
        ),
      ),
    );
  }
}
