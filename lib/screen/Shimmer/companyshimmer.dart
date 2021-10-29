import 'package:flutter/material.dart';
import 'package:app/constant/colors.dart';

import 'package:shimmer/shimmer.dart';

class CompanyPageLoad extends StatelessWidget {
  const CompanyPageLoad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blue,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 6 + 40,
                color: AppColors.blue,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: AppColors.greyWhite,
                          highlightColor: AppColors.greyShimmer,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            ),
                            margin: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.height / 50,
                                left: MediaQuery.of(context).size.height / 50),
                            height: MediaQuery.of(context).size.height / 8,
                            width: MediaQuery.of(context).size.height / 8,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          // color: Colors.amberAccent,
                          margin: const EdgeInsets.only(),
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
                                  decoration: const BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                  ),
                                  height: 20,
                                  width:
                                      MediaQuery.of(context).size.width / 2.4,
                                  child: const Text(
                                    '',
                                    style: TextStyle(
                                      fontFamily: '',
                                      color: AppColors.white,
                                      fontSize: 15,
                                    ),
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
                                  decoration: const BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                  ),
                                  height: 15,
                                  width: MediaQuery.of(context).size.width / 2,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Shimmer.fromColors(
                                baseColor: AppColors.greyWhite,
                                highlightColor: AppColors.greyShimmer,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                  ),
                                  height: 15,
                                  width: MediaQuery.of(context).size.width / 2,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Shimmer.fromColors(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      height: 30,
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                    baseColor: AppColors.greyWhite,
                    highlightColor: AppColors.greyShimmer,
                  ),
                  Shimmer.fromColors(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      height: 30,
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                    baseColor: AppColors.greyWhite,
                    highlightColor: AppColors.greyShimmer,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Shimmer.fromColors(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                    height: 15,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                  baseColor: AppColors.greyWhite,
                  highlightColor: AppColors.greyShimmer,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Shimmer.fromColors(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                    height: 15,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                  baseColor: AppColors.greyWhite,
                  highlightColor: AppColors.greyShimmer,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Shimmer.fromColors(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                    height: 15,
                    width: MediaQuery.of(context).size.width / 2.4,
                  ),
                  baseColor: AppColors.greyWhite,
                  highlightColor: AppColors.greyShimmer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
