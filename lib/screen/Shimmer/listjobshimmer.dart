import 'package:flutter/material.dart';
import 'package:app/constant/colors.dart';
import 'package:app/function/sized.dart';
import 'package:shimmer/shimmer.dart';

class ListJobLoad extends StatefulWidget {
  const ListJobLoad({Key? key}) : super(key: key);

  @override
  _ListJobLoadState createState() => _ListJobLoadState();
}

class _ListJobLoadState extends State<ListJobLoad> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(left: 17, right: 17, bottom: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: mediaWidthSized(context, 4),
              decoration: BoxDecoration(
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
                      height: mediaWidthSized(context, 5),
                      width: mediaWidthSized(context, 5),
                      color: AppColors.white,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: mediaWidthSized(context, 50),
                          top: mediaWidthSized(context, 50),
                          bottom: mediaWidthSized(context, 50)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Shimmer.fromColors(
                            baseColor: AppColors.greyWhite,
                            highlightColor: AppColors.greyShimmer,
                            child: Container(
                              height: mediaWidthSized(context, 27.2),
                              color: AppColors.white,
                              width: mediaWidthSized(context, 3),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: AppColors.greyWhite,
                                highlightColor: AppColors.greyShimmer,
                                child: Container(
                                  height: 12.5,
                                  color: AppColors.white,
                                  width: 180,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Shimmer.fromColors(
                                baseColor: AppColors.greyWhite,
                                highlightColor: AppColors.greyShimmer,
                                child: Container(
                                  height: 12.5,
                                  color: AppColors.white,
                                  width: 150,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Shimmer.fromColors(
                                baseColor: AppColors.greyWhite,
                                highlightColor: AppColors.greyShimmer,
                                child: Container(
                                  height: 12.5,
                                  color: AppColors.white,
                                  width: 80,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
