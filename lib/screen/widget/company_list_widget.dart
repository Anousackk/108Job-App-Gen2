import 'package:flutter/material.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/sized.dart';
import 'package:shimmer/shimmer.dart';

import 'image_network_retry.dart';

class WidgetCompanyListView extends StatelessWidget {
  const WidgetCompanyListView({
    Key? key,
    this.onTap,
    this.picture,
    this.companyName,
    this.bio,
    this.location,
    this.openingAmount,
  }) : super(key: key);
  final GestureTapCallback? onTap;
  final String? picture, companyName, bio, location, openingAmount;
  //final
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: AppColors.grey, width: 0.4))),
      child: Container(
        color: AppColors.white,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                border: Border.all(
                  color: AppColors.white,
                  width: 0.5,
                )),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 7),
                  height: mediaWidthSized(context, 6.8),
                  width: mediaWidthSized(context, 6.8),
                  child: picture != null
                      ? Image(
                          // fit: BoxFit.cover,
                          // width: mediaWidthSized(context, 1.3),
                          // fit: BoxFit.cover,
                          image: imageNetworkBuild(
                            '${QueryInfo().pictureBase}$picture',
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Shimmer.fromColors(
                              child: Container(
                                height: mediaWidthSized(context, 6.8),
                                width: mediaWidthSized(context, 6.8),
                                color: AppColors.white,
                              ),
                              baseColor: AppColors.greyWhite,
                              highlightColor: AppColors.greyShimmer,
                            );
                          },
                        )

                      //  Image.network(
                      //     '${QueryInfo().pictureBase}$picture',
                      //     loadingBuilder: (context, child,
                      //         ImageChunkEvent loadingProgress) {
                      //       if (loadingProgress == null) return child;
                      //       return Shimmer.fromColors(
                      //         child: Container(
                      //           height: mediaWidthSized(context, 6.8),
                      //           width: mediaWidthSized(context, 6.8),
                      //           color: AppColors.white,
                      //         ),
                      //         baseColor: AppColors.greyWhite,
                      //         highlightColor: AppColors.greyShimmer,
                      //       );
                      //     },
                      //   )
                      : null,
                ),
                SizedBox(
                  width: mediaWidthSized(context, 45),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: mediaWidthSized(context, 35),
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$companyName',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'PoppinsSemiBold',
                            fontSize: mediaWidthSized(context, 30),
                          ),
                        ),
                        Visibility(
                          visible: !(bio == null || location == null),
                          child: Text(
                            '$bio$location',
                            style: TextStyle(
                              fontFamily: 'PoppinsRegular',
                              fontSize: mediaWidthSized(context, 33),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Visibility(
                          visible: !(openingAmount == '0'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${l.jobOpening}: ',
                                style: TextStyle(
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: mediaWidthSized(context, 33),
                                ),
                              ),
                              Text(
                                '$openingAmount',
                                style: TextStyle(
                                  color: AppColors.blue,
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: mediaWidthSized(context, 33),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  // height: 20,
                  // width: 20,
                  // color: AppColors.blue,
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(
                    'chevron-right',
                    style: TextStyle(
                      color: AppColors.blue,
                      fontFamily: 'FontAwesomeProRegular',
                      fontSize: mediaWidthSized(context, 24),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
