import 'package:flutter/material.dart';
import 'package:app/constant/colors.dart';
import 'package:app/function/sized.dart';

import 'package:shimmer/shimmer.dart';

class JobDetailLoad extends StatelessWidget {
  const JobDetailLoad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: AppColors.blue,

            centerTitle: true,
            title: Text(
              'Job Detail',
              style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  fontSize: appbarTextSize(context)),
            ),
            // Text('Recipes',style: TextStyle(),),
            elevation: 0.0,
            bottomOpacity: 0.0,
          ),
          preferredSize: Size.fromHeight(appbarsize(context))),
      body: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 17),
          Container(
            margin: const EdgeInsets.only(left: 17, right: 17, bottom: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 70,
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                border: Border.all(
                  color: AppColors.greyOpacity,
                  width: 0.5,
                )),
            child: Row(
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.greyWhite,
                  highlightColor: AppColors.greyShimmer,
                  child: Container(
                    height: 50,
                    width: 50,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: AppColors.greyWhite,
                        highlightColor: AppColors.greyShimmer,
                        child: Container(
                          color: AppColors.white,
                          height: 14,
                          width: 130,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Shimmer.fromColors(
                        baseColor: AppColors.greyWhite,
                        highlightColor: AppColors.greyShimmer,
                        child: Container(
                          color: AppColors.white,
                          height: 12,
                          width: 80,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Shimmer.fromColors(
                        baseColor: AppColors.greyWhite,
                        highlightColor: AppColors.greyShimmer,
                        child: Container(
                          color: AppColors.white,
                          height: 12,
                          width: 150,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 17, right: 17, bottom: 5),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                border: Border.all(
                  color: AppColors.greyOpacity,
                  width: 0.5,
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.greyWhite,
                      highlightColor: AppColors.greyShimmer,
                      child: Container(
                        height: 19,
                        width: MediaQuery.of(context).size.width / 1.5,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Shimmer.fromColors(
                      baseColor: AppColors.greyWhite,
                      highlightColor: AppColors.greyShimmer,
                      child: Container(
                        height: 15,
                        color: AppColors.white,
                        width: MediaQuery.of(context).size.width / 1.3,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Shimmer.fromColors(
                      baseColor: AppColors.greyWhite,
                      highlightColor: AppColors.greyShimmer,
                      child: Container(
                        height: 15,
                        color: AppColors.white,
                        width: MediaQuery.of(context).size.width / 1.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Shimmer.fromColors(
                  baseColor: AppColors.greyWhite,
                  highlightColor: AppColors.greyShimmer,
                  child: Container(
                    height: 15,
                    color: AppColors.white,
                    width: MediaQuery.of(context).size.width / 1.5,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Shimmer.fromColors(
                  baseColor: AppColors.greyWhite,
                  highlightColor: AppColors.greyShimmer,
                  child: Container(
                    height: 15,
                    color: AppColors.white,
                    width: MediaQuery.of(context).size.width / 1.9,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Shimmer.fromColors(
                  baseColor: AppColors.greyWhite,
                  highlightColor: AppColors.greyShimmer,
                  child: Container(
                    height: 15,
                    color: AppColors.white,
                    width: MediaQuery.of(context).size.width / 1.8,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.greyWhite,
                      highlightColor: AppColors.greyShimmer,
                      child: Container(
                        height: 35,
                        color: AppColors.white,
                        width: MediaQuery.of(context).size.width / 4.5,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Shimmer.fromColors(
                      baseColor: AppColors.greyWhite,
                      highlightColor: AppColors.greyShimmer,
                      child: Container(
                        height: 35,
                        color: AppColors.white,
                        width: MediaQuery.of(context).size.width / 4.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2.5,
            margin: const EdgeInsets.only(left: 17, right: 17, bottom: 5),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                border: Border.all(
                  color: AppColors.greyOpacity,
                  width: 0.5,
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Shimmer.fromColors(
                  baseColor: AppColors.greyWhite,
                  highlightColor: AppColors.greyShimmer,
                  child: Container(
                    height: 19,
                    color: AppColors.white,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Shimmer.fromColors(
                  baseColor: AppColors.greyWhite,
                  highlightColor: AppColors.greyShimmer,
                  child: Container(
                    height: 15,
                    color: AppColors.white,
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Shimmer.fromColors(
                  baseColor: AppColors.greyWhite,
                  highlightColor: AppColors.greyShimmer,
                  child: Container(
                    height: 15,
                    color: AppColors.white,
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Shimmer.fromColors(
                  baseColor: AppColors.greyWhite,
                  highlightColor: AppColors.greyShimmer,
                  child: Container(
                    height: 15,
                    color: AppColors.white,
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Shimmer.fromColors(
                  baseColor: AppColors.greyWhite,
                  highlightColor: AppColors.greyShimmer,
                  child: Container(
                    height: 15,
                    color: AppColors.white,
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Shimmer.fromColors(
                  baseColor: AppColors.greyWhite,
                  highlightColor: AppColors.greyShimmer,
                  child: Container(
                    height: 15,
                    color: AppColors.white,
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Shimmer.fromColors(
                  baseColor: AppColors.greyWhite,
                  highlightColor: AppColors.greyShimmer,
                  child: Container(
                    height: 15,
                    color: AppColors.white,
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Shimmer.fromColors(
                  baseColor: AppColors.greyWhite,
                  highlightColor: AppColors.greyShimmer,
                  child: Container(
                    height: 15,
                    color: AppColors.white,
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
