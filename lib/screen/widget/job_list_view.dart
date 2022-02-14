import 'package:flutter/material.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/pluginfunction.dart';
import 'package:app/function/sized.dart';
import 'package:app/screen/AuthenScreen/login_page.dart';
import 'package:shimmer/shimmer.dart';

import 'alertdialog.dart';
import 'image_network_retry.dart';

class WidgetJobListView extends StatelessWidget {
  const WidgetJobListView(
      {Key? key,
      this.isSaved,
      this.onTap,
      this.picture,
      this.position,
      this.noSaved,
      this.company,
      this.location,
      this.dateStart,
      this.dateEnd,
      this.locat,
      this.onTapIcon,
      this.jobTag})
      : super(key: key);

  final GestureTapCallback? onTap;
  final String? picture, position, company, dateStart, dateEnd;
  final List<String>? location;
  final String? locat;
  final bool? isSaved;
  final GestureTapCallback? onTapIcon;
  final String? jobTag;
  final bool? noSaved;

  @override
  Widget build(BuildContext context) {
    // debugPrint('location : $location');
    // debugPrint('locat : $locat');
    String? joinlocat;
    List? translateLocate = [];
    if (location != null) {
      joinlocat = location!.join(', ');

      location?.forEach((element) {
        translateLocate.add(TranslateQuery.translateProvince(element));
      });
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: 17, right: 17, bottom: mediaWidthSized(context, 180)),
            padding: EdgeInsets.symmetric(
                horizontal: mediaWidthSized(context, 46.44)),
            height: mediaWidthSized(context, 3.9),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                border: Border.all(
                  color: AppColors.greyWhite,
                  width: 1,
                )),
            child: Row(
              children: [
                Container(
                    height: mediaWidthSized(context, 5),
                    width: mediaWidthSized(context, 5),
                    color: AppColors.white,
                    child: picture == null || picture == ''
                        ? null
                        : Image(
                            // fit: BoxFit.cover,
                            // width: mediaWidthSized(context, 1.3),
                            // fit: BoxFit.cover,
                            image: imageNetworkBuild(
                              QueryInfo().pictureBase + '$picture',
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Shimmer.fromColors(
                                child: Container(
                                  height: mediaWidthSized(context, 5),
                                  width: mediaWidthSized(context, 5),
                                  color: AppColors.white,
                                ),
                                baseColor: AppColors.greyWhite,
                                highlightColor: AppColors.greyShimmer,
                              );
                            },
                          )

                    // Image.network(
                    //     QueryInfo().pictureBase + '$picture',
                    //     loadingBuilder:
                    //         (context, child, ImageChunkEvent loadingProgress) {
                    //       if (loadingProgress == null) return child;
                    //       return Shimmer.fromColors(
                    //         child: Container(
                    //           height: mediaWidthSized(context, 5),
                    //           width: mediaWidthSized(context, 5),
                    //           color: AppColors.white,
                    //         ),
                    //         baseColor: AppColors.greyWhite,
                    //         highlightColor: AppColors.greyShimmer,
                    //       );
                    //     },
                    //   ),
                    ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: mediaWidthSized(context, 40),
                        top: mediaWidthSized(context, 50),
                        bottom: mediaWidthSized(context, 50)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$position",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'PoppinsSemiBold',
                            color: jobTag != null && jobTag == 'Highlight'
                                ? AppColors.red
                                : Colors.black,
                            fontSize: mediaWidthSized(context, 29.5),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$company",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'PoppinsRegular',
                                fontSize: mediaWidthSized(context, 33),
                              ),
                            ),
                            locat != null
                                ? Text(
                                    indexL == 0 ? '$locat' : '$locat',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'PoppinsRegular',
                                      fontSize: mediaWidthSized(context, 33),
                                    ),
                                  )
                                : Text(
                                    indexL == 0
                                        ? '$joinlocat '
                                        : '${translateLocate.join(', ')} ',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'PoppinsRegular',
                                      fontSize: mediaWidthSized(context, 33),
                                    ),
                                  ),
                            Text(
                              '${TranslateQuery.translateMonthByFullDateString(dateStart!.replaceAll('-', ' '))} - ${TranslateQuery.translateMonthByFullDateString(dateEnd!.replaceAll('-', ' '))}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'PoppinsRegular',
                                fontSize: mediaWidthSized(context, 33),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: noSaved == null,
                    child: isSaved != null
                        ? GestureDetector(
                            onTap: onTapIcon,
                            child: Container(
                              width: mediaWidthSized(context, 10),
                              decoration: const BoxDecoration(
                                  // color: AppColors.blue,
                                  // border: Border(
                                  //     left: BorderSide(
                                  //   color: AppColors.GreyOpacity,
                                  //   width: 0.5,
                                  // )),
                                  ),
                              height: mediaWidthSized(context, 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  isSaved == true
                                      ? const Icon(
                                          Icons.star,
                                          color: AppColors.blue,
                                        )
                                      : const Icon(
                                          Icons.star_border_outlined,
                                          color: AppColors.blue,
                                        ),
                                  Text(
                                    isSaved == true ? 'Saved' : 'Save',
                                    style: TextStyle(
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: mediaWidthSized(context, 35)),
                                  )
                                ],
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertPlainDialog(
                                    color: AppColors.blue,
                                    title: l.youareNotSignIn,
                                    content: l.doyouwanttoSignin,
                                    actions: [
                                      AlertAction(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                settings: const RouteSettings(
                                                    name: "/login"),
                                                builder: (context) =>
                                                    const LoginPage()),
                                          );
                                        },
                                        title: l.yes,
                                      ),
                                      AlertAction(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        title: l.no,
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: mediaWidthSized(context, 10),
                              decoration: const BoxDecoration(
                                  // color: AppColors.blue,
                                  // border: Border(
                                  //     left: BorderSide(
                                  //   color: AppColors.GreyOpacity,
                                  //   width: 0.5,
                                  // )),
                                  ),
                              height: mediaWidthSized(context, 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.star_border_outlined,
                                    color: AppColors.blue,
                                  ),
                                  Text(
                                    'Save',
                                    style: TextStyle(
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: mediaWidthSized(context, 35)),
                                  )
                                ],
                              ),
                            ),
                          ))
              ],
            ),
          ),
          jobTag != null && jobTag == 'Highlight'
              ? Container(
                  margin: EdgeInsets.only(
                      left: 17,
                      right: 17,
                      bottom: mediaWidthSized(context, 180)),
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaWidthSized(context, 46.44)),
                  height: mediaWidthSized(context, 3.9),
                  decoration: BoxDecoration(
                      // color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                      border: Border.all(
                        color: AppColors.red,
                        width: 0.5,
                      )),
                  alignment: Alignment.topLeft,
                )
              : Container(),
          jobTag != null && jobTag == 'Highlight'
              ? Container(
                  margin: EdgeInsets.only(
                      left: 17,
                      right: 17,
                      bottom: mediaWidthSized(context, 180)),
                  // width: mediaWidthSized(context, 7),
                  height: mediaWidthSized(context, 20),
                  child: Text(
                    ' Apply now ',
                    style: textStyleRegular(
                        context: context, color: AppColors.white, size: 35),
                  ),
                  decoration: const BoxDecoration(
                      color: AppColors.red,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(5))),
                )
              : Container()
        ],
      ),
    );
  }
}

class WidgetAllJobListView extends StatelessWidget {
  const WidgetAllJobListView(
      {Key? key,
      this.onTap,
      this.picture,
      this.position,
      this.company,
      this.location,
      this.dateStart,
      this.dateEnd,
      this.isSaved,
      this.jobTag,
      this.onTapIcon})
      : super(key: key);
  final String? jobTag;
  final bool? isSaved;
  final GestureTapCallback? onTapIcon;
  final GestureTapCallback? onTap;
  final String? picture, position, company, dateStart, dateEnd;
  final List<String>? location;

  @override
  Widget build(BuildContext context) {
    String joinlocat = location!.join(', ');
    List translateLocate = [];
    location?.forEach((element) {
      translateLocate.add(TranslateQuery.translateProvince(element));
    });

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            // margin: EdgeInsets.only(
            //     // left: 17,
            //     // right: 17,
            //     bottom: mediaWidthSized(context, 180)),
            padding: EdgeInsets.symmetric(
                horizontal: mediaWidthSized(context, 46.44)),
            height: mediaWidthSized(context, 3.9),
            decoration: const BoxDecoration(
                color: AppColors.white,
                // borderRadius: BorderRadius.all(Radius.circular(3)),
                border: Border(
                    bottom: BorderSide(
                  color: AppColors.greyWhite,
                  width: 1,
                ))),
            child: Container(
              margin: const EdgeInsets.only(
                left: 12,
                right: 12,
              ),
              child: Row(
                children: [
                  Container(
                      height: mediaWidthSized(context, 5),
                      width: mediaWidthSized(context, 5),
                      color: Colors.white,
                      child: picture == null || picture == ''
                          ? null
                          : Image(
                              // fit: BoxFit.cover,
                              // width: mediaWidthSized(context, 1.3),
                              // fit: BoxFit.cover,
                              image: imageNetworkBuild(
                                '${QueryInfo().pictureBase}$picture',
                              ),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Shimmer.fromColors(
                                  child: Container(
                                    height: mediaWidthSized(context, 5),
                                    width: mediaWidthSized(context, 5),
                                    color: AppColors.white,
                                  ),
                                  baseColor: AppColors.greyWhite,
                                  highlightColor: AppColors.greyShimmer,
                                );
                              },
                            )
                      // Image.network(
                      //   '${QueryInfo().pictureBase}$picture',
                      //   loadingBuilder:
                      //       (context, child, ImageChunkEvent loadingProgress) {
                      //     if (loadingProgress == null) return child;
                      //     return Shimmer.fromColors(
                      //       child: Container(
                      //         height: mediaWidthSized(context, 5),
                      //         width: mediaWidthSized(context, 5),
                      //         color: AppColors.white,
                      //       ),
                      //       baseColor: Colors.grey[100],
                      //       highlightColor: AppColors.greyShimmer,
                      //     );
                      //   },
                      //   fit: BoxFit.contain,
                      // ),
                      ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: mediaWidthSized(context, 40),
                          top: mediaWidthSized(context, 50),
                          bottom: mediaWidthSized(context, 50)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$position",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'PoppinsSemiBold',
                              color: jobTag != null && jobTag == 'Highlight'
                                  ? AppColors.red
                                  : Colors.black,
                              fontSize: mediaWidthSized(context, 28),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$company",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: mediaWidthSized(context, 33),
                                ),
                              ),
                              Text(
                                indexL == 0
                                    ? '$joinlocat '
                                    : '${translateLocate.join(', ')} ',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: mediaWidthSized(context, 33),
                                ),
                              ),
                              Text(
                                '${TranslateQuery.translateMonthByFullDateString(dateStart!.replaceAll('-', ' '))} - ${TranslateQuery.translateMonthByFullDateString(dateEnd!.replaceAll('-', ' '))}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: mediaWidthSized(context, 33),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  isSaved != null
                      ? GestureDetector(
                          onTap: onTapIcon,
                          child: Container(
                            width: mediaWidthSized(context, 10),
                            decoration: const BoxDecoration(
                                // color: AppColors.blue,
                                // border: Border(
                                //     left: BorderSide(
                                //   color: AppColors.GreyOpacity,
                                //   width: 0.5,
                                // )),
                                ),
                            height: mediaWidthSized(context, 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isSaved == true
                                    ? const Icon(
                                        Icons.star,
                                        color: AppColors.blue,
                                      )
                                    : const Icon(
                                        Icons.star_border_outlined,
                                        color: AppColors.blue,
                                      ),
                                Text(
                                  'Save',
                                  style: TextStyle(
                                      fontFamily: 'PoppinsRegular',
                                      fontSize: mediaWidthSized(context, 35)),
                                )
                              ],
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertPlainDialog(
                                  color: AppColors.blue,
                                  title: l.youareNotSignIn,
                                  content: l.doyouwanttoSignin,
                                  actions: [
                                    AlertAction(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              settings: const RouteSettings(
                                                  name: "/login"),
                                              builder: (context) =>
                                                  const LoginPage()),
                                        );
                                      },
                                      title: l.yes,
                                    ),
                                    AlertAction(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      title: l.no,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            width: mediaWidthSized(context, 10),
                            decoration: const BoxDecoration(
                                // color: AppColors.blue,
                                // border: Border(
                                //     left: BorderSide(
                                //   color: AppColors.GreyOpacity,
                                //   width: 0.5,
                                // )),
                                ),
                            height: mediaWidthSized(context, 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.star_border_outlined,
                                  color: AppColors.blue,
                                ),
                                Text(
                                  isSaved == true ? 'Saved' : 'Save',
                                  style: TextStyle(
                                      fontFamily: 'PoppinsRegular',
                                      fontSize: mediaWidthSized(context, 35)),
                                )
                              ],
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
          // jobTag != null && jobTag == 'Highlight'
          //     ? Container(
          //         padding: EdgeInsets.symmetric(
          //             horizontal: mediaWidthSized(context, 46.44)),
          //         height: mediaWidthSized(context, 3.9),
          //         decoration: const BoxDecoration(
          //             // color: AppColors.white,
          //             // borderRadius: BorderRadius.all(Radius.circular(3)),
          //             border: Border(
          //                 top: BorderSide(
          //                   color: AppColors.red,
          //                   width: 0.5,
          //                 ),
          //                 bottom: BorderSide(
          //                   color: AppColors.red,
          //                   width: 0.5,
          //                 ))),
          //       )
          //     : Container(),
          jobTag != null && jobTag == 'Highlight'
              ? Container(
                  margin: EdgeInsets.only(
                      // left: 17,
                      right: 17,
                      bottom: mediaWidthSized(context, 180)),
                  // width: mediaWidthSized(context, 7),
                  height: mediaWidthSized(context, 20),
                  child: Text(
                    ' Apply now ',
                    style: textStyleRegular(
                        context: context, color: AppColors.white, size: 35),
                  ),
                  decoration: const BoxDecoration(
                      color: AppColors.red,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(5))),
                )
              : Container()
        ],
      ),
    );
  }
}

class WidgetMyJobListView extends StatelessWidget {
  const WidgetMyJobListView({
    Key? key,
    this.onTap,
    this.picture,
    this.position,
    this.company,
    this.location,
    this.dateStart,
    this.dateEnd,
    this.popupmenu,
  }) : super(key: key);

  final GestureTapCallback? onTap;
  final String? picture, position, company, dateStart, dateEnd;
  final String? location;
  final Widget? popupmenu;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          left: 17,
          right: 17,
        ),
        padding:
            EdgeInsets.symmetric(horizontal: mediaWidthSized(context, 46.44)),
        height: mediaWidthSized(context, 3.9),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        child: Row(
          children: [
            Container(
                height: mediaWidthSized(context, 5),
                width: mediaWidthSized(context, 5),
                color: AppColors.white,
                child: picture == null || picture == ''
                    ? null
                    : Image(
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
                              height: mediaWidthSized(context, 5),
                              width: mediaWidthSized(context, 5),
                              color: AppColors.white,
                            ),
                            baseColor: AppColors.greyWhite,
                            highlightColor: AppColors.greyShimmer,
                          );
                        },
                      )),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    left: mediaWidthSized(context, 40),
                    top: mediaWidthSized(context, 50),
                    bottom: mediaWidthSized(context, 50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$position",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'PoppinsSemiBold',
                              color: Colors.black,
                              fontSize: mediaWidthSized(context, 28),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$company",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: mediaWidthSized(context, 33),
                                ),
                              ),
                              Text(
                                '$location',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: mediaWidthSized(context, 33),
                                ),
                              ),
                              Text(
                                '${TranslateQuery.translateMonthByFullDateString(dateStart!.replaceAll('-', ' '))} - ${TranslateQuery.translateMonthByFullDateString(dateEnd!.replaceAll('-', ' '))}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: mediaWidthSized(context, 33),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                        height: mediaWidthSized(context, 3.9),
                        child: popupmenu),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProvinceOpeningShimmer extends StatelessWidget {
  const ProvinceOpeningShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(
              left: mediaWidthSized(context, 36),
              right: mediaWidthSized(context, 36),
              bottom: mediaWidthSized(context, 90)),
          padding:
              EdgeInsets.symmetric(horizontal: mediaWidthSized(context, 45)),
          height: mediaWidthSized(context, 10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              border: Border.all(
                color: AppColors.greyWhite,
                width: 1,
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: mediaWidthSized(context, 45),
                width: mediaWidthSized(context, 10),
                color: AppColors.greyShimmer,
              ),
              Container(
                height: 10,
                width: mediaWidthSized(context, 16),
                color: AppColors.greyShimmer,
              ),
            ],
          ),
        );
      },
    );
  }
}
