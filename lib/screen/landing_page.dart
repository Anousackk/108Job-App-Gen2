// import 'Widget/Morebutton.dart';

import 'package:carousel_slider/carousel_slider.dart';
// import 'package:fade/fade.dart';
// import 'package:fade/fade.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:new_version/new_version.dart';
import 'package:app/api/auth.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/animationfade.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/data_app.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/calculated.dart';
import 'package:app/function/pluginfunction.dart';
import 'package:app/function/sized.dart';
import 'package:app/screen/widget/image_network_retry.dart';
import 'package:app/screen/widget/job_list_view.dart';
import 'package:shimmer/shimmer.dart';

import 'ControlScreen/bottom_navigation.dart';
import 'Shimmer/listcompanyshimmer.dart';
import 'Shimmer/listjobshimmer.dart';
import 'company_detail.dart';
import 'job_detail_page.dart';
import 'search_job_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

bool isShowedUpdate = false;
CutDateString convertDate = CutDateString();

class _LandingPageState extends State<LandingPage> {
  ScrollController scrollController = ScrollController();

  QueryInfo queryInfo = QueryInfo();
  String? checkConnect;
  int? item = 20;
  List? dataBottomJob;
  bool? districtButton = false;
  bool? oneTimeFetch = true;
  List<bool?>? isSavejobList = [];
  bool? refetchjob = false;
  // int moreItem = 0,
  //     moreFetch = 0,
  //     baseitem = 10,
  //     increaseitem = 10,
  //     baseFetch = 60;
  // bool morebutton = true;
  bool languageShow = true;
  // bool fetchmore = false;
  List<Widget> caroselslide = [];
  List<Widget> caroselslide2 = [];
  // @override
  // void initState() {
  //   super.initState();

  // }

  dosomething() {
    if (dataBottomJob?.length == item) {
      item = (item! + 20);
      debugPrint(item.toString());
      oneTimeFetch = true;
      // fetchmore = true;
      setState(() {});
    } else {
      debugPrint(
          'debugPrint' + dataBottomJob!.length.toString() + item.toString());
    }
  }

  // jobListInBottom(isload, refetch) {

  // }

  Future getlang() async {
    try {
      var reading = await SharedPref().read('indexL');
      indexL = reading;
      changLanguage();
    } catch (e) {
      indexL = 0;
      changLanguage();
    }
  }

  bannerShimmer() {
    return Shimmer.fromColors(
      child: Container(
        color: AppColors.white,
        height: MediaQuery.of(context).size.width * 9 / 16,
      ),
      baseColor: AppColors.greyWhite,
      highlightColor: AppColors.greyShimmer,
    );
  }

  Future<void> checkForUpdate() async {
    if (isShowedUpdate == false) {
      var newVersion = NewVersion(
        androidId: "com.onehundredeightjobs.app",
        iOSId: "org.cenixoft.OneHundredEightJobs",
        // dialogText: indexL == 0
        //     ? "You can update this app for get new feature"
        //     : 'ເຈົ້າສາມາດອັບເດດແອັບໄດ້ແລ້ວ',
        // dismissText: indexL == 0 ? 'Dismiss' : 'ພາຍຫຼັງ',
        // updateText: indexL == 0 ? 'Update' : 'ອັບເດດ',
        // dialogTitle: indexL == 0 ? 'Update available' : "ອັບເດດແອັບຂອງທ່ານ",
      );
      VersionStatus? status = await newVersion.getVersionStatus();
      try {
        debugPrint('local version: ' + status!.localVersion);
        debugPrint('store version: ' + status.storeVersion);
        if (status.localVersion != status.storeVersion) {
          newVersion.showUpdateDialog(
            context: context,
            versionStatus: status,
            dialogText: indexL == 0
                ? "You can update this app for get new feature"
                : 'ເຈົ້າສາມາດອັບເດດແອັບໄດ້ແລ້ວ',
            dismissButtonText: indexL == 0 ? 'Dismiss' : 'ພາຍຫຼັງ',
            updateButtonText: indexL == 0 ? 'Update' : 'ອັບເດດ',
            dialogTitle: indexL == 0 ? 'Update available' : "ອັບເດດແອັບຂອງທ່ານ",
          );
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  void initState() {
    getlang().then((value) {
      changLanguage();
      checkForUpdate().then((value) {
        isShowedUpdate = true;
      });
      setState(() {});
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        debugPrint('overscroll');
        dosomething();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (checkConnect ==
    //    "ClientException: Failed to connect to ${QueryInfo().host}: Failed host lookup: '${QueryInfo().hostError}'") {
    //  debugPrint('no Internet');
    //   Future.delayed(Duration(milliseconds: 300)).then((value) {
    //     setState(() {});
    //    debugPrint('refresh state');
    //   });
    // }

    caroselslide = [];

    // Screen
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                height: mediaHeightSized(context, 4.8),
                padding: EdgeInsets.all(mediaWidthSized(context, 18)),
                child: Image.asset(
                  'assets/image/Logo108.png',
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //       border: Border(
              //           top: BorderSide(width: 0.3, color: AppColors.grey),
              //           bottom:
              //               BorderSide(width: 0.3, color: AppColors.grey))),
              //   child: ListTile(
              //     onTap: () {},
              //     title: Text(
              //       'Help Center',
              //       style: TextStyle(
              //           fontFamily: 'PoppinsMedium',
              //           fontSize: mediaWidthSized(context, 23)),
              //     ),
              //   ),
              // ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 0.3, color: AppColors.grey))),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      if (languageShow == false) {
                        languageShow = true;
                      } else {
                        languageShow = false;
                      }
                    });
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Language',
                        style: TextStyle(
                            fontFamily: 'PoppinsMedium',
                            fontSize: mediaWidthSized(context, 23)),
                      ),
                      Text(
                        languageShow == true ? 'chevron-up' : 'chevron-down',
                        style: TextStyle(
                            fontFamily: 'FontAwesomeProRegular',
                            fontSize: mediaWidthSized(context, 23)),
                      )
                    ],
                  ),
                ),
              ),
              Fade(
                  child: Container(
                    color: AppColors.greyWhite,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (indexL != 0) {
                              await SharedPref().save('indexL', 0);
                            }
                            indexL = 0;
                            changLanguage();
                            // Phoenix.rebirth(context);
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (Route<dynamic> route) => false);
                            pageIndex = 0;
                          },
                          child: Container(
                            height: mediaWidthSized(context, 10),
                            // height: mediaWidthSized(context, 23),
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        width: 0.3, color: AppColors.grey),
                                    bottom: BorderSide(
                                        width: 0.3, color: AppColors.grey))),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'English',
                                  style: TextStyle(
                                      fontFamily: 'PoppinsMedium',
                                      fontSize: mediaWidthSized(context, 26)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (indexL != 1) {
                              await SharedPref().save('indexL', 1);
                            }
                            indexL = 1;
                            changLanguage();
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (Route<dynamic> route) => false);
                            pageIndex = 0;
                            // Phoenix.rebirth(context);
                          },
                          child: Container(
                            height: mediaWidthSized(context, 10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        width: 0.3, color: AppColors.grey),
                                    bottom: BorderSide(
                                        width: 0.3, color: AppColors.grey))),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Lao',
                                  style: TextStyle(
                                      fontFamily: 'PoppinsMedium',
                                      fontSize: mediaWidthSized(context, 26)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Container(
                        //   // height: mediaWidthSized(context, 23),
                        //   decoration: BoxDecoration(
                        //       border: Border(
                        //           bottom: BorderSide(
                        //               width: 0.3, color: AppColors.grey))),
                        //   child: ListTile(
                        //     onTap: () async {
                        //       if (indexL != 1) {
                        //         await SharedPref().save('indexL', 1);
                        //       }
                        //       indexL = 1;
                        //       l.change();
                        //       Phoenix.rebirth(context);
                        //     },
                        //     title: Text(
                        //       'Laos',
                        //       style: TextStyle(
                        //           fontFamily: 'PoppinsMedium',
                        //           fontSize: mediaWidthSized(context, 26)),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  visible: languageShow),
              // Container(
              //   decoration: BoxDecoration(
              //       border: Border(
              //           bottom:
              //               BorderSide(width: 0.3, color: AppColors.grey))),
              //   child: ListTile(
              //     onTap: () {},
              //     title: Text(
              //       'About us',
              //       style: TextStyle(
              //           fontFamily: 'PoppinsMedium',
              //           fontSize: mediaWidthSized(context, 23)),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
            child: AppBar(
              iconTheme: const IconThemeData(color: AppColors.grey),
              backgroundColor: AppColors.white,
              centerTitle: true,
              title: Image.asset('assets/image/Logo108.png', width: 70),
              // Text('Recipes',style: TextStyle(),),
              elevation: 2.0,
            ),
            preferredSize: Size.fromHeight(appbarsize(context))),
        body: SingleChildScrollView(
          controller: scrollController,
          child: ListBody(
            children: [
              Query(
                  options: QueryOptions(
                      document: gql(queryInfo.topBanner),
                      variables: <String, dynamic>{"variables": "Top Banner"}),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      debugPrint(result.exception?.graphqlErrors[0].toString());
                      if (result.exception?.graphqlErrors[0].toString() ==
                          'Context creation failed: TokenExpiredError: jwt expired: Undefined location') {
                        AuthUtil().removeToken().then((value) {
                          currentToken = null;
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (Route<dynamic> route) => false);
                          pageIndex = 0;
                          // Phoenix.rebirth(context);
                        });
                      }
                      // AuthUtil().removeToken();
                      // pageIndex = 0;
                      // currentToken = null;
                      // Phoenix.rebirth(context);
                      // checkConnect = result.exception.toString();
                      if (result.exception?.linkException?.originalException
                              .toString()
                              .substring(0, 50) ==
                          "SocketException: Failed host lookup: '${QueryInfo().baseHost}'") {
                        Future.delayed(const Duration(milliseconds: 3000))
                            .then((value) {
                          try {
                            refetch!();
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        });
                      }
                      return bannerShimmer();
                    }

                    if (result.isLoading) {
                      return bannerShimmer();
                    }
                    checkConnect = null;
                    List banners = result.data?['bannerslide'];
                    caroselslide = [];
                    for (var element in banners) {
                      caroselslide.add(GestureDetector(
                        onTap: () {
                          launchURL(element['url']);
                        },
                        child: Container(
                            color: AppColors.white,
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            child: Image(
                              fit: BoxFit.fitWidth,
                              image: imageNetworkBuild(
                                element['image']['src'],
                              ),
                            )

                            //  Image.network(
                            //   element['image']['src'],
                            //   fit: BoxFit.fitWidth,
                            // ),
                            ),
                      ));
                    }

                    if (caroselslide.isEmpty) {
                      return Container();
                    } else {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CarouselSlider(
                            items: caroselslide,
                            options: CarouselOptions(
                              height:
                                  MediaQuery.of(context).size.width * 9 / 16,
                              aspectRatio: 16 / 9,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: caroselslide.length == 1 ? false : true,
                              autoPlayInterval: const Duration(seconds: 4),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              scrollDirection: Axis.horizontal,
                            )),
                      );
                    }
                  }),
              Container(
                margin: const EdgeInsets.only(top: 27.5, left: 17, bottom: 17),
                child: Text(
                  l.featureCom,
                  style: TextStyle(
                      fontFamily: 'PoppinsSemiBold',
                      color: Colors.black,
                      fontSize: hometitleSize(context)),
                ),
              ),
              Query(
                options: QueryOptions(document: gql(queryInfo.featureCompany)),
                builder: (result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    if (result.exception?.linkException?.originalException
                            .toString()
                            .substring(0, 50) ==
                        "SocketException: Failed host lookup: '${QueryInfo().baseHost}'") {
                      Future.delayed(const Duration(milliseconds: 3000))
                          .then((value) {
                        try {
                          refetch!();
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      });
                    }
                    return const CompanyFeatureShimmer();
                  }
                  if (result.isLoading) {
                    return const CompanyFeatureShimmer();
                  }
                  dataFI?.homeFeatureCom = result.data!['getCompanyFeature'];
                  return Container(
                    height: mediaWidthSized(context, 1.76),
                    margin: const EdgeInsets.only(),
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: dataFI?.homeFeatureCom.length,
                        itemBuilder: (context, index) {
                          var repository = dataFI?.homeFeatureCom[index];
                          // List<String> indusList = [];
                          // repository['industryId'].forEach((element) {
                          //   indusList.add(element['name']);
                          // });
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CompanyDetailPage(
                                          repository['empId'],
                                        )),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: mediaWidthSized(context, 30)),
                              width: mediaWidthSized(context, 1.5),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(3)),
                                  border: Border.all(
                                    color: AppColors.greyOpacity,
                                    width: 0.5,
                                  )),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: mediaWidthSized(context, 1.5),
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0)),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        vertical: mediaWidthSized(context, 45),
                                        horizontal:
                                            mediaWidthSized(context, 45),
                                      ),
                                      height: mediaWidthSized(context, 2.6),
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image: imageNetworkBuild(
                                          '${queryInfo.pictureBase}${repository['profile']}',
                                        ),
                                      )
                                      //  Image.network(
                                      //   '${queryInfo.pictureBase}${repository['profile']}',
                                      //   fit: BoxFit.cover,
                                      // ),
                                      ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      bottom: mediaWidthSized(context, 45),
                                      left: mediaWidthSized(context, 45),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                            height: mediaWidthSized(context, 9),
                                            width: mediaWidthSized(context, 9),
                                            color: AppColors.white,
                                            child: Image(
                                              // fit: BoxFit.cover,
                                              image: imageNetworkBuild(
                                                '${queryInfo.pictureBase}${repository['logo']}',
                                              ),
                                            )

                                            // Image.network(
                                            //   '${queryInfo.pictureBase}${repository['logo']}',
                                            // ),
                                            ),
                                        SizedBox(
                                          width: mediaWidthSized(context, 55),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: mediaWidthSized(context, 9),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${repository['companyName']}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'PoppinsSemiBold',
                                                      fontSize: mediaWidthSized(
                                                          context, 28)),
                                                ),
                                                Text(
                                                  '${repository['industry']}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'PoppinsRegular',
                                                      fontSize: mediaWidthSized(
                                                          context, 35)),
                                                ),
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
                },
              ),

              Container(
                margin: const EdgeInsets.only(top: 27.5, left: 17, bottom: 17),
                child: Text(
                  l.positionAvai,
                  style: TextStyle(
                      fontFamily: 'PoppinsSemiBold',
                      color: Colors.black,
                      fontSize: hometitleSize(context)),
                ),
              ),
              Query(
                  options: QueryOptions(
                      document: gql(queryInfo.positionAvailable),
                      variables: <String, dynamic>{
                        "options": indexL == 0 ? "EN" : "LA"
                      }),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      if (result.exception?.linkException?.originalException
                              .toString()
                              .substring(0, 50) ==
                          "SocketException: Failed host lookup: '${QueryInfo().baseHost}'") {
                        Future.delayed(const Duration(milliseconds: 3000))
                            .then((value) {
                          try {
                            refetch!();
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        });
                      }
                      return const ProvinceOpeningShimmer();
                    }
                    if (result.isLoading) {
                      return const ProvinceOpeningShimmer();
                    }
                    dataFI?.homeProviceJob =
                        result.data?['countJobByLocat']['getprovice'];
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: districtButton == false &&
                              dataFI?.homeProviceJob.length > 5
                          ? 5
                          : dataFI?.homeProviceJob.length,
                      itemBuilder: (context, index) {
                        final repository = dataFI?.homeProviceJob[index];
                        return InkWell(
                          onTap: () {
                            //debugPrint(dataFI.homeProviceJob['_id']);
                            provinceIDselect.add(repository['_id']);
                            provinceselect.add(repository['name']);
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    const SearchJobPage(true),
                                transitionDuration: const Duration(seconds: 0),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(),
                            padding: EdgeInsets.symmetric(
                                horizontal: mediaWidthSized(context, 23)),
                            height: mediaWidthSized(context, 9),
                            decoration: BoxDecoration(
                                // borderRadius:
                                //     BorderRadius.all(Radius.circular(3)),
                                border: Border(
                                    top: index == 0
                                        ? const BorderSide(
                                            color: AppColors.greyWhite,
                                            width: 1,
                                          )
                                        : BorderSide.none,
                                    bottom: const BorderSide(
                                      color: AppColors.greyWhite,
                                      width: 1,
                                    ))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  repository['name'].toString(),
                                  style: TextStyle(
                                    fontFamily: 'PoppinsMedium',
                                    fontSize: indexL == 0
                                        ? mediaWidthSized(context, 28)
                                        : mediaWidthSized(context, 25),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      repository['jobsCount'].toString(),
                                      style: TextStyle(
                                        color: AppColors.blue,
                                        fontFamily: 'PoppinsSemiBold',
                                        fontSize: mediaWidthSized(context, 28),
                                      ),
                                    ),
                                    Text(
                                      ' ${l.jobs}',
                                      style: TextStyle(
                                        fontFamily: 'PoppinsMedium',
                                        fontSize: indexL == 0
                                            ? mediaWidthSized(context, 28)
                                            : mediaWidthSized(context, 25),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
              const SizedBox(
                height: 5,
              ),
              Visibility(
                visible: dataFI != null ||
                    (dataFI?.homeProviceJob.length > 5 &&
                        districtButton == false),
                child: SizedBox(
                  height: 20,
                  // color: AppColors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          districtButton = !districtButton!;
                          setState(() {});
                        },
                        child: Container(
                          height: 20,
                          color: AppColors.white,
                          child: Row(
                            children: [
                              Text(
                                  districtButton == false
                                      ? 'chevron-down '
                                      : 'chevron-up ',
                                  style: TextStyle(
                                      color: AppColors.grey,
                                      fontFamily: 'FontAwesomeProRegular',
                                      fontSize: mediaWidthSized(context, 30))),
                              Text(
                                  districtButton == false
                                      ? indexL == 0
                                          ? 'View more'
                                          : 'ເບິ່ງເພີ່ມ'
                                      : indexL == 0
                                          ? 'Hide'
                                          : 'ເຊື່ອງ',
                                  style: TextStyle(
                                      color: AppColors.grey,
                                      fontFamily: 'PoppinsRegular',
                                      fontSize: mediaWidthSized(context, 30)))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  width: 20,
                ),
              ),

              Query(
                options: QueryOptions(document: gql(queryInfo.staticBanner)),
                builder: (resultBanner, {fetchMore, refetch}) {
                  if (resultBanner.hasException) {
                    debugPrint(
                        resultBanner.exception?.graphqlErrors[0].toString());
                    return Container();
                  }
                  if (resultBanner.isLoading) {
                    return Container();
                  }
                  var banners = resultBanner.data?['getSingleBanner'];
                  caroselslide2 = [];
                  banners.forEach((element) {
                    caroselslide2.add(GestureDetector(
                      onTap: () {
                        launchURL(element['url']);
                      },
                      child: Container(
                          color: AppColors.white,
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: Image(
                            fit: BoxFit.fitWidth,
                            image: imageNetworkBuild(
                              queryInfo.pictureBase + element['image'],
                            ),
                          )

                          //  Image.network(
                          //   element['image']['src'],
                          //   fit: BoxFit.fitWidth,
                          // ),
                          ),
                    ));
                  });

                  return Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      CarouselSlider(
                          items: caroselslide2,
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.width * 32 / 85,
                            aspectRatio: 85 / 32,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: caroselslide2.length == 1 ? false : true,
                            autoPlayInterval: const Duration(seconds: 4),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            scrollDirection: Axis.horizontal,
                          )),
                    ],
                  );
                },
              ),
              Query(
                  options: QueryOptions(
                      document: gql(queryInfo.featureJobRecommend),
                      variables: {
                        "page": 1,
                        "perPage": 100,
                        "typeR": "Recommended",
                        "verifyToken": currentToken ?? ''
                      }),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.isLoading) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          )
                        ],
                      );
                    }
                    if (result.hasException) {
                      debugPrint(result.exception.toString());
                      if (result.exception?.linkException?.originalException
                              .toString()
                              .substring(0, 50) ==
                          "SocketException: Failed host lookup: '${QueryInfo().baseHost}'") {
                        Future.delayed(const Duration(milliseconds: 3000))
                            .then((value) {
                          try {
                            refetch!();
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        });
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          )
                        ],
                      );
                    }
                    //debugPrint(result.data['getFeatureJob']);
                    dataFI?.homeFeatureJob = result.data?['getFeatureJob'];
                    if (dataFI?.homeFeatureJob.length == 0) {
                      return Container(
                          // height: 200,
                          // width: 200,
                          // color: AppColors.blue,
                          // child: Text(
                          //   'ຍັງບໍ່ທັນມີ',
                          //   style: TextStyle(
                          //       fontFamily: 'PoppinsMedium',
                          //       fontSize: mediaWidthSized(context, 28)),
                          // ),
                          );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: 27.5, left: 17, bottom: 17),
                            child: Text(
                              l.hotjob,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'PoppinsSemiBold',
                                  fontSize: hometitleSize(context)),
                            ),
                          ),
                          Container(
                            height: mediaWidthSized(context, 1.35),
                            margin: const EdgeInsets.only(),
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: dataFI?.homeFeatureJob.length,
                                itemBuilder: (context, index) {
                                  final repository =
                                      dataFI?.homeFeatureJob[index];
                                  // List<String> locateList = [];
                                  // dataFI.homeFeatureJob['workingLocationId']
                                  //     .forEach((element) {
                                  //   locateList.add(indexL == 0
                                  //       ? element['name']
                                  //       : TranslateQuery.translateProvince(
                                  //           element['name']));
                                  // });
                                  //debugPrint(repository['image']);
                                  return featureJobWidget(
                                      repository, context, index);
                                }),
                          ),
                        ],
                      );
                    }
                  }),
              Container(
                margin: const EdgeInsets.only(
                    top: 27.5, left: 17, bottom: 17, right: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      l.featureJob,
                      style: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          color: Colors.black,
                          fontSize: hometitleSize(context)),
                    ),
                    // Text(
                    //   l.seeall,
                    //   style: TextStyle(
                    //     fontFamily: 'PoppinsSemiBold',
                    //     fontSize: mediaWidthSized(context, 30),
                    //   ),
                    // )
                  ],
                ),
              ),
              // QueryGraphQL(
              //   queryInfo: queryInfo.featuredJob,
              //   variables: {"page": 1, "perPage": 100},
              //   whenLoad: ListJobLoad(),
              //   result
              // ),
              Query(
                  options: QueryOptions(
                      document: gql(queryInfo.featuredJob),
                      variables: <String, dynamic>{
                        "page": 1,
                        "perPage": item,
                        //  baseFetch + moreFetch,
                        "typeR": "",
                        "verifyToken": currentToken ?? "",
                      }),
                  builder: (QueryResult result, {refetch, fetchMore}) {
                    if (result.hasException) {
                      if (result.exception?.linkException?.originalException
                              .toString()
                              .substring(0, 50) ==
                          "SocketException: Failed host lookup: '${QueryInfo().baseHost}'") {
                        Future.delayed(const Duration(milliseconds: 3000))
                            .then((value) {
                          try {
                            refetch!();
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        });
                      }
                      return const ListJobLoad();
                    }
                    if (result.isLoading) {
                      // morebutton = true;
                      if (dataBottomJob == null) {
                        return const ListJobLoad();
                      } else {
                        return Column(
                          children: [
                            Mutation(
                              options: MutationOptions(
                                document: gql(QueryInfo().seekerSavejob),
                                onCompleted: (data) {
                                  debugPrint('completed: ' + data.toString());

                                  setState(() {
                                    try {
                                      refetch!();
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
                                  });
                                },
                                onError: (error) {
                                  debugPrint('error ' + error.toString());
                                },
                              ),
                              builder: (runMutationSave, result) {
                                return Mutation(
                                  options: MutationOptions(
                                    document: gql(QueryInfo().seekerunSave),
                                    onCompleted: (data) {
                                      debugPrint(
                                          'completed: ' + data.toString());
                                      //debugPrint();

                                      setState(() {
                                        try {
                                          refetch!();
                                        } catch (e) {
                                          debugPrint(e.toString());
                                        }
                                      });
                                    },
                                    onError: (error) {
                                      debugPrint('error ' + error.toString());
                                    },
                                  ),
                                  builder: (runMutationUnSave, result) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: dataBottomJob?.length,
                                      //  baseitem >= repositories.length
                                      // ? repositories.length
                                      // : baseitem + moreItem,
                                      itemBuilder: (context, index) {
                                        final repository =
                                            dataBottomJob?[index];
                                        List<String> locateList = [];
                                        repository['location']
                                            .forEach((element) {
                                          locateList.add(element['name']);
                                        });
                                        String jobID = repository['id'];
                                        // bool isSaved = repository['isSaved'];
                                        if (index == 0) {
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                      color: AppColors.white,
                                                      // borderRadius: BorderRadius.all(Radius.circular(3)),
                                                      border: Border(
                                                          top: BorderSide(
                                                        color:
                                                            AppColors.greyWhite,
                                                        width: 1,
                                                      ))),
                                                  child: WidgetAllJobListView(
                                                    jobTag:
                                                        repository['jobTag'],
                                                    onTapIcon: () {
                                                      setState(() {
                                                        if (isSavejobList?[
                                                                index] ==
                                                            true) {
                                                          runMutationUnSave(
                                                              {"JobId": jobID});
                                                        } else {
                                                          runMutationSave(
                                                              {"JobId": jobID});
                                                        }

                                                        isSavejobList?[index] =
                                                            !isSavejobList![
                                                                index]!;
                                                        debugPrint(
                                                            isSavejobList?[
                                                                    index]
                                                                .toString());
                                                      });
                                                    },
                                                    isSaved:
                                                        isSavejobList?[index],

                                                    picture: repository['logo'],
                                                    // location: repository['location'],
                                                    // locat: repository['location'],
                                                    location: locateList,
                                                    position:
                                                        repository['title'],
                                                    dateStart: convertDate
                                                        .cutDateString(
                                                            repository[
                                                                'openDate']),
                                                    dateEnd: convertDate
                                                        .cutDateString(
                                                            repository[
                                                                'closeDate']),
                                                    company: repository[
                                                        'companyName'],
                                                    onTap: () async {
                                                      debugPrint(
                                                          repository['id']);

                                                      await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                JobDetailPage(
                                                                  jobID: jobID,
                                                                )),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 5),
                                              child: WidgetAllJobListView(
                                                onTapIcon: () {
                                                  setState(() {
                                                    if (isSavejobList?[index] ==
                                                        true) {
                                                      runMutationUnSave(
                                                          {"JobId": jobID});
                                                    } else {
                                                      runMutationSave(
                                                          {"JobId": jobID});
                                                    }

                                                    isSavejobList?[index] =
                                                        !isSavejobList![index]!;
                                                    debugPrint(
                                                        isSavejobList![index]
                                                            .toString());
                                                  });
                                                },
                                                isSaved: isSavejobList?[index],
                                                jobTag: repository['jobTag'],
                                                picture: repository['logo'],
                                                // location: repository['location'],
                                                // locat: repository['location'],
                                                location: locateList,
                                                position: repository['title'],
                                                dateStart:
                                                    convertDate.cutDateString(
                                                        repository['openDate']),
                                                dateEnd: convertDate
                                                    .cutDateString(repository[
                                                        'closeDate']),
                                                company:
                                                    repository['companyName'],
                                                onTap: () async {
                                                  debugPrint(repository['id']);

                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            JobDetailPage(
                                                              jobID: jobID,
                                                            )),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              l.loading,
                              style: TextStyle(
                                color: AppColors.grey,
                                fontFamily: 'PoppinsRegular',
                                fontSize: mediaWidthSized(context, 31),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      }
                    }
                    if (refetchjob == true) {
                      debugPrint('refetch job');
                      try {
                        refetch!();
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                      refetchjob = false;
                    }
                    dataBottomJob = result.data?['getFeatureJob'];
                    if (oneTimeFetch == true) {
                      debugPrint('onetimeFetch');

                      debugPrint(isSavejobList?.length.toString());
                      if (isSavejobList!.length != dataBottomJob!.length) {
                        isSavejobList = [];

                        dataBottomJob?.forEach((element) {
                          debugPrint('add ' + element['isSaved'].toString());
                          isSavejobList?.add(element['isSaved']);
                        });
                        oneTimeFetch = false;
                      }
                      debugPrint('ending onetimeFetch');
                    }

                    return Column(
                      children: [
                        Mutation(
                          options: MutationOptions(
                            document: gql(QueryInfo().seekerSavejob),
                            onCompleted: (data) {
                              debugPrint('completed: ' + data.toString());

                              setState(() {
                                try {
                                  refetch!();
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                              });
                            },
                            onError: (error) {
                              debugPrint('error ' + error.toString());
                            },
                          ),
                          builder: (runMutationSave, result) {
                            return Mutation(
                              options: MutationOptions(
                                document: gql(QueryInfo().seekerunSave),
                                onCompleted: (data) {
                                  debugPrint('completed: ' + data.toString());
                                  //debugPrint();

                                  setState(() {
                                    try {
                                      refetch!();
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
                                  });
                                },
                                onError: (error) {
                                  debugPrint('error ' + error.toString());
                                },
                              ),
                              builder: (runMutationUnSave, result) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: dataBottomJob?.length,
                                  //  baseitem >= repositories.length
                                  // ? repositories.length
                                  // : baseitem + moreItem,
                                  itemBuilder: (context, index) {
                                    final repository = dataBottomJob?[index];
                                    List<String> locateList = [];
                                    repository['location'].forEach((element) {
                                      locateList.add(element['name']);
                                    });
                                    String jobID = repository['id'];
                                    // bool isSaved = repository['isSaved'];
                                    if (index == 0) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return Container(
                                            decoration: const BoxDecoration(
                                                color: AppColors.white,
                                                // borderRadius: BorderRadius.all(Radius.circular(3)),
                                                border: Border(
                                                    top: BorderSide(
                                                  color: AppColors.greyWhite,
                                                  width: 1,
                                                ))),
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: WidgetAllJobListView(
                                              jobTag: repository['jobTag'],
                                              onTapIcon: () {
                                                setState(() {
                                                  if (isSavejobList?[index] ==
                                                      true) {
                                                    runMutationUnSave(
                                                        {"JobId": jobID});
                                                  } else {
                                                    runMutationSave(
                                                        {"JobId": jobID});
                                                  }

                                                  isSavejobList?[index] =
                                                      !isSavejobList![index]!;
                                                  debugPrint(
                                                      isSavejobList![index]!
                                                          .toString());
                                                });
                                              },
                                              isSaved: isSavejobList?[index],

                                              picture: repository['logo'],
                                              // location: repository['location'],
                                              // locat: repository['location'],
                                              location: locateList,
                                              position: repository['title'],
                                              dateStart:
                                                  convertDate.cutDateString(
                                                      repository['openDate']),
                                              dateEnd:
                                                  convertDate.cutDateString(
                                                      repository['closeDate']),
                                              company:
                                                  repository['companyName'],
                                              onTap: () async {
                                                debugPrint(repository['id']);

                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          JobDetailPage(
                                                            jobID: jobID,
                                                          )),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    }
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 5),
                                          child: WidgetAllJobListView(
                                            jobTag: repository['jobTag'],
                                            onTapIcon: () {
                                              setState(() {
                                                if (isSavejobList?[index] ==
                                                    true) {
                                                  runMutationUnSave(
                                                      {"JobId": jobID});
                                                } else {
                                                  runMutationSave(
                                                      {"JobId": jobID});
                                                }

                                                isSavejobList?[index] =
                                                    !isSavejobList![index]!;
                                                debugPrint(isSavejobList![index]
                                                    .toString());
                                              });
                                            },
                                            isSaved: isSavejobList?[index],

                                            picture: repository['logo'],
                                            // location: repository['location'],
                                            // locat: repository['location'],
                                            location: locateList,
                                            position: repository['title'],
                                            dateStart:
                                                convertDate.cutDateString(
                                                    repository['openDate']),
                                            dateEnd: convertDate.cutDateString(
                                                repository['closeDate']),
                                            company: repository['companyName'],
                                            onTap: () async {
                                              debugPrint(repository['id']);

                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        JobDetailPage(
                                                          jobID: jobID,
                                                        )),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          l.loading,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'PoppinsRegular',
                            fontSize: mediaWidthSized(context, 31),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  }),

              SizedBox(
                height: MediaQuery.of(context).size.height / 28,
              ),
            ],
          ),
        ));
  }
}

//////////////// function 2 widget //////////////////
///
///
///

featureJobWidget(repository, context, index) {
  List<String> locateList = [];
  repository['location'].forEach((element) {
    locateList.add(element['name']);
  });
  String joinlocat;

  List translateLocate = [];

  joinlocat = locateList.join(', ');

  for (var element in locateList) {
    translateLocate.add(TranslateQuery.translateProvince(element));
  }

  return Container(
    margin: EdgeInsets.only(left: index == 0 ? 5 : 0),
    child: GestureDetector(
      onTap: () {
        String jobID = repository['id'];

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => JobDetailPage(
                    jobID: jobID,
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
            left: mediaWidthSized(context, 55),
            right: index == dataFI?.homeFeatureJob.length - 1
                ? mediaWidthSized(context, 55)
                : 0),
        width: mediaWidthSized(context, 1.4),
        decoration: BoxDecoration(
            // color: AppColors.blueSky,
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            border: Border.all(
              color: AppColors.greyOpacity,
              width: 0.5,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: mediaWidthSized(context, 55),
                  left: mediaWidthSized(context, 55)),
              child: Row(
                children: [
                  Container(
                      height: mediaWidthSized(context, 10),
                      width: mediaWidthSized(context, 10),
                      color: AppColors.white,
                      child: Image(
                        fit: BoxFit.cover,
                        image: imageNetworkBuild(
                          '${QueryInfo().pictureBase}${repository['logo']}',
                        ),
                      )
                      // child: Image.network(
                      //   '${QueryInfo().pictureBase}${repository['logo']}',
                      //   // fit: BoxFit.cover,
                      // ),
                      ),
                  SizedBox(
                    width: mediaWidthSized(context, 55),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(right: 10),
                      height: mediaWidthSized(context, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${repository['title']}',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'PoppinsMedium',
                                  fontSize: mediaWidthSized(context, 28)))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(

                    // borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                margin: EdgeInsets.only(
                  top: mediaWidthSized(context, 50),
                ),
                height: mediaWidthSized(context, 2.65),
                child: Image(
                  // fit: BoxFit.cover,
                  width: mediaWidthSized(context, 1.3),
                  fit: BoxFit.fitWidth,
                  image: imageNetworkBuild(
                    '${repository['image']}',
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer.fromColors(
                      child: Container(
                        color: AppColors.white,
                      ),
                      baseColor: AppColors.greyWhite,
                      highlightColor: AppColors.greyShimmer,
                    );
                  },
                )
                // child: Image.network(
                //   '${repository['image']}',
                //   loadingBuilder:
                //       (context, child, ImageChunkEvent loadingProgress) {
                //     if (loadingProgress == null) return child;
                //     return Shimmer.fromColors(
                //       child: Container(
                //         color: AppColors.white,
                //       ),
                //       baseColor: AppColors.greyWhite,
                //       highlightColor: AppColors.greyShimmer,
                //     );
                //   },
                //   width: mediaWidthSized(context, 1.3),
                //   fit: BoxFit.fitWidth,
                // ),
                ),
            Container(
              height: mediaWidthSized(context, 5.7),
              // color: AppColors.blue,
              margin: EdgeInsets.only(
                  left: mediaWidthSized(context, 50),
                  top: mediaWidthSized(context, 80)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Container(
                        margin: EdgeInsets.only(
                            bottom: mediaWidthSized(context, 180)),
                        child: Text('${repository['title']}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'PoppinsSemiBold',
                                fontSize: mediaWidthSized(context, 28)))),
                  ),
                  Text(
                      indexL == 0
                          ? '${l.location}: $joinlocat'
                          : '${l.location}: ${translateLocate.join(', ')}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'PoppinsRegular',
                          fontSize: mediaWidthSized(context, 33))),
                  Text(
                      '${TranslateQuery.translateMonthByFullDateString(convertDate.cutDateString(repository['openDate']).replaceAll('-', ' '))} - ${TranslateQuery.translateMonthByFullDateString(convertDate.cutDateString(repository['closeDate']).replaceAll('-', ' '))}',
                      // '${convertDate.cutDateString(repository['openDate'])} ${l.to} ${convertDate.cutDateString(repository['closeDate'])}',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'PoppinsRegular',
                          fontSize: mediaWidthSized(context, 33))),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
