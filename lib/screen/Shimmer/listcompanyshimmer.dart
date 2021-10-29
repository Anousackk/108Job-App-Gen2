import 'package:flutter/material.dart';
import 'package:app/constant/colors.dart';

import 'package:app/function/sized.dart';
import 'package:shimmer/shimmer.dart';

class CompanyListLoad extends StatelessWidget {
  const CompanyListLoad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        GridView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: mediaWidthSized(context, 40),
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: mediaWidthSized(context, 40),
              mainAxisSpacing: 10.0,
              childAspectRatio: 1.3),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 16,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: AppColors.greyWhite,
              highlightColor: AppColors.greyShimmer,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  // border: Border.all(
                  //   color: AppColors.greyOpacity,
                  //   width: 0.5,
                  // ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CompanyFeatureShimmer extends StatelessWidget {
  const CompanyFeatureShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mediaWidthSized(context, 1.76),
      margin: const EdgeInsets.only(),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: 2,
          itemBuilder: (context, index) {
            // List<String> indusList = [];
            // repository['industryId'].forEach((element) {
            //   indusList.add(element['name']);
            // });
            return Container(
              margin: EdgeInsets.only(
                left: mediaWidthSized(context, 30),
              ),
              width: mediaWidthSized(context, 1.5),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                  border: Border.all(
                    color: AppColors.greyOpacity,
                    width: 0.5,
                  )),
              child: Shimmer.fromColors(
                baseColor: AppColors.greyWhite,
                highlightColor: AppColors.greyShimmer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: mediaWidthSized(context, 1.5),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      margin: EdgeInsets.symmetric(
                        vertical: mediaWidthSized(context, 45),
                        horizontal: mediaWidthSized(context, 45),
                      ),
                      height: mediaWidthSized(context, 2.6),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: mediaWidthSized(context, 45),
                        left: mediaWidthSized(context, 45),
                      ),
                      child: Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: AppColors.greyWhite,
                            highlightColor: AppColors.greyShimmer,
                            child: Container(
                              height: mediaWidthSized(context, 9),
                              width: mediaWidthSized(context, 9),
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(
                            width: mediaWidthSized(context, 55),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: mediaWidthSized(context, 9),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: mediaWidthSized(context, 60),
                                  ),
                                  Container(
                                    height: 10,
                                    width: mediaWidthSized(context, 10),
                                    color: AppColors.greyShimmer,
                                  ),
                                  SizedBox(
                                    height: mediaWidthSized(context, 45),
                                  ),
                                  Container(
                                    height: 10,
                                    width: mediaWidthSized(context, 20),
                                    color: AppColors.greyShimmer,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
//  ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: 14,
//       itemBuilder: (context, index) {
//         return Container(
//           margin: EdgeInsets.only(left: 17, right: 17, bottom: 5),
//           padding: EdgeInsets.symmetric(horizontal: 10),
//           height: 70,
//           decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.all(Radius.circular(3)),
//               border: Border.all(
//                 color: AppColors.greyOpacity,
//                 width: 0.5,
//               )),
//           child: Row(
//             children: [
//               Shimmer.fromColors(
//                 baseColor: AppColors.greyWhite,
//                 highlightColor: AppColors.greyShimmer,
//                 child: Container(
//                   height: 50,
//                   width: 50,
//                   color: AppColors.white,
//                 ),
//               ),
//               SizedBox(
//                 width: 12,
//               ),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Shimmer.fromColors(
//                       baseColor: AppColors.greyWhite,
//                       highlightColor: AppColors.greyShimmer,
//                       child: Container(
//                         color: AppColors.white,
//                         height: 14,
//                         width: 130,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Shimmer.fromColors(
//                       baseColor: AppColors.greyWhite,
//                       highlightColor: AppColors.greyShimmer,
//                       child: Container(
//                         color: AppColors.white,
//                         height: 12,
//                         width: 80,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Shimmer.fromColors(
//                       baseColor: AppColors.greyWhite,
//                       highlightColor: AppColors.greyShimmer,
//                       child: Container(
//                         color: AppColors.white,
//                         height: 12,
//                         width: 150,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     ),
