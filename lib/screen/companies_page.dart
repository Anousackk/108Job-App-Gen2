import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/calculated.dart';
import 'package:app/function/sized.dart';
import 'package:app/screen/ControlScreen/bottom_navigation.dart';
import 'package:app/screen/widget/image_network_retry.dart';

import 'Shimmer/listjobshimmer.dart';
import 'company_detail.dart';
import 'search_company_page.dart';
import 'widget/empty_query.dart';

class CompaniesPage extends StatefulWidget {
  const CompaniesPage({Key? key}) : super(key: key);

  @override
  _CompaniesPageState createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {
  @override
  Widget build(BuildContext context) {
    Drag? drag;
    DragStartDetails? dragStartDetails;
    // Current drag instance - should be instantiated on overscroll and updated alongside.

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
            child: AppBar(
              actions: [
                Query(
                  options: QueryOptions(
                      document: gql(QueryInfo().getReuse),
                      variables: <String, dynamic>{
                        "types": "Industry",
                        "lanOption": indexL == 0 ? "EN" : "LA"
                      }),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      return const Text('Error');
                    }
                    if (result.isLoading) {
                      return IconButton(
                          icon: Text(
                            'search',
                            style: TextStyle(
                              fontFamily: 'FontAwesomeProRegular',
                              fontSize: appbarTextSize(context),
                              color: AppColors.white,
                            ),
                          ),
                          color: AppColors.white,
                          onPressed: () {});
                    }
                    List repositories = result.data?["getReuseList"];
                    return IconButton(
                        icon: Text(
                          'search',
                          style: TextStyle(
                            fontFamily: 'FontAwesomeProRegular',
                            fontSize: appbarTextSize(context),
                            color: AppColors.white,
                          ),
                        ),
                        color: AppColors.white,
                        onPressed: () => {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      SearchCompanyPage(repositories),
                                  transitionDuration:
                                      const Duration(seconds: 0),
                                ),
                              )
                            });
                  },
                ),
              ],
              backgroundColor: AppColors.blue,

              centerTitle: true,
              title: Text(
                l.companies,
                style: TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    fontSize: appbarTextSize(context)),
              ),
              // Text('Recipes',style: TextStyle(),),
              elevation: 0.0,
              bottomOpacity: 0.0,
            ),
            preferredSize: Size.fromHeight(appbarsize(context))),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 24.5),
              child: TabBar(
                unselectedLabelColor: AppColors.grey,
                indicatorColor: AppColors.blue,
                labelColor: AppColors.blue,
                labelStyle: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  fontSize: tabSelectTitle(context),
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: 'PoppinsRegular',
                  fontSize: tabUnselectTitle(context),
                ),
                indicatorWeight: 1.5,
                tabs: [
                  Container(
                      height: tabContainer(context),
                      padding:
                          EdgeInsets.symmetric(vertical: tabbarheight(context)),
                      child: Text(
                        l.allCompanies,
                      )),
                  Container(
                      height: tabContainer(context),
                      padding:
                          EdgeInsets.symmetric(vertical: tabbarheight(context)),
                      child: Text(
                        l.hiring,
                      )),
                ],
              ),
            ),
            Expanded(
              child: NotificationListener(
                onNotification: (notification) {
                  if (notification is ScrollStartNotification) {
                    dragStartDetails = notification.dragDetails;
                  }
                  if (notification is OverscrollNotification) {
                    try {
                      drag = pageController.position
                          .drag(dragStartDetails!, () {});
                      drag?.update(notification.dragDetails!);
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  }
                  if (notification is ScrollEndNotification) {
                    drag?.cancel();
                  }
                  return true;
                },
                child: const TabBarView(
                  children: [AllCompaniesTabView(), HiringNowTabView()],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AllCompaniesTabView extends StatefulWidget {
  const AllCompaniesTabView({Key? key}) : super(key: key);

  @override
  _AllCompaniesTabViewState createState() => _AllCompaniesTabViewState();
}

class _AllCompaniesTabViewState extends State<AllCompaniesTabView> {
  ScrollController scrollController = ScrollController();
  int item = 20;
  List? dataCompany;

  // bool morebutton = true;

  // //// Fetch its doesnot show but have data
  // int moreItem = 0,
  //     moreFetch = 0,
  //     baseitem = 10,
  //     increaseitem = 10,
  //     baseFetch = 60;
  CutDateString convertDate = CutDateString();
  QueryInfo queryInfo = QueryInfo();
  dosomething() {
    if (dataCompany?.length == item) {
      item = item + 20;
      debugPrint(item.toString());
      // fetchmore = true;
      setState(() {});
    } else {}
  }

  bodyCompanyList(isLoad) {
    return Column(
      children: [
        ListView.builder(
          itemCount: dataCompany?.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var repository = dataCompany?[index];
            return CompanyListTab(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompanyDetailPage(
                              repository['_id'],
                            )),
                  );
                },
                imageSrc: '${repository['logo']}',
                companyName: '${repository['companyName']}',
                jobOpenAmount: '${repository['jobsCount']}',
                industry: '${repository['industryId'].join(', ')}');
          },
        ),
        const SizedBox(
          height: 10,
        ),
        // MoreButton(
        //   onTap: () {
        //     setState(() {
        //       if (baseFetch + moreFetch == repositories.length &&
        //           moreItem + baseitem + increaseitem >=
        //               repositories.length) {
        //         moreFetch = moreFetch + 50;
        //       }
        //       if ((moreItem + baseitem + increaseitem) >=
        //           repositories.length) {
        //         if ((moreItem + baseitem + increaseitem) <=
        //             repositories.length) {
        //           moreItem = moreItem + increaseitem;
        //         }
        //         if ((moreItem + baseitem + increaseitem) >=
        //             repositories.length) {
        //           moreItem = repositories.length - baseitem;
        //           morebutton = false;
        //         }
        //       }
        //       if (moreItem + baseitem + increaseitem <=
        //           repositories.length) {
        //         setState(() {
        //           moreItem = moreItem + increaseitem;
        //         });
        //       }
        //     });
        //   },
        //   visible: baseitem >= repositories.length
        //       ? false
        //       : morebutton,
        //   title: l.moreCompanies,
        // ),
        const SizedBox(
          height: 5,
        ),
        Text(
          l.loading,
          style: TextStyle(
            color: isLoad == true ? AppColors.grey : AppColors.white,
            fontFamily: 'PoppinsRegular',
            fontSize: mediaWidthSized(context, 31),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 12,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        debugPrint('overscroll');
        dosomething();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is OverscrollNotification) {}

        return true;
      },
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Query(
                options: QueryOptions(
                    document: gql(queryInfo.allCompany),
                    variables: <String, dynamic>{
                      "companyName": "",
                      "industryId": [],
                      "page": 1,
                      "perPage": item,
                      "types": "AllCompanies"
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
                    // return Text(result.exception.toString());
                  }
                  if (result.isLoading) {
                    // morebutton = true;
                    if (dataCompany == null) {
                      return const ListJobLoad();
                    } else {
                      return bodyCompanyList(true);
                    }
                  }
                  dataCompany =
                      result.data?['searchEmployerAllFunction']['employers'];
                  if (dataCompany!.isEmpty) {
                    return const EmptyQuery();
                  }

                  return bodyCompanyList(false);
                }),
          ],
        ),
      ),
    );
  }
}

class HiringNowTabView extends StatefulWidget {
  const HiringNowTabView({Key? key}) : super(key: key);

  @override
  _HiringNowTabViewState createState() => _HiringNowTabViewState();
}

class _HiringNowTabViewState extends State<HiringNowTabView> {
  ScrollController scrollController = ScrollController();
  int item = 20;
  List? dataCompany;
  // bool morebutton = true;
  // int moreItem = 0,
  //     moreFetch = 0,
  //     baseitem = 10,
  //     increaseitem = 10,
  //     baseFetch = 60;
  CutDateString convertDate = CutDateString();
  QueryInfo queryInfo = QueryInfo();
  dosomething() {
    if (dataCompany?.length == item) {
      item = item + 20;
      debugPrint(item.toString());
      // fetchmore = true;
      setState(() {});
    } else {}
  }

  bodyListCompany(isLoad) {
    return Column(
      children: [
        ListView.builder(
          itemCount: dataCompany?.length,
          // baseitem >= repositories.length
          //     ? repositories.length
          //     : baseitem + moreItem,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var repository = dataCompany?[index];
            return CompanyListTab(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompanyDetailPage(
                              repository['_id'],
                            )),
                  );
                },
                imageSrc: '${repository['logo']}',
                companyName: '${repository['companyName']}',
                jobOpenAmount: '${repository['jobsCount']}',
                industry: '${repository['industryId'].join(', ')}');
          },
        ),

        const SizedBox(
          height: 10,
        ),
        // MoreButton(
        //   onTap: () {
        //     setState(() {
        //       if (baseFetch + moreFetch == repositories.length &&
        //           moreItem + baseitem + increaseitem >=
        //               repositories.length) {
        //         moreFetch = moreFetch + 50;
        //       }
        //       if ((moreItem + baseitem + increaseitem) >=
        //           repositories.length) {
        //         if ((moreItem + baseitem + increaseitem) <=
        //             repositories.length) {
        //           moreItem = moreItem + increaseitem;
        //         }
        //         if ((moreItem + baseitem + increaseitem) >=
        //             repositories.length) {
        //           moreItem = repositories.length - baseitem;
        //           morebutton = false;
        //         }
        //       }
        //       if (moreItem + baseitem + increaseitem <=
        //           repositories.length) {
        //         setState(() {
        //           moreItem = moreItem + increaseitem;
        //         });
        //       }
        //     });
        //   },
        //   visible: baseitem >= repositories.length
        //       ? false
        //       : morebutton,
        //   title: l.moreCompanies,
        // ),
        const SizedBox(
          height: 5,
        ),
        Text(
          l.loading,
          style: TextStyle(
            color: isLoad == true ? AppColors.grey : AppColors.white,
            fontFamily: 'PoppinsRegular',
            fontSize: mediaWidthSized(context, 31),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 12,
        ),
        // SizedBox(
        //   height: MediaQuery.of(context).size.height / 28,
        // ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    debugPrint(item.toString());
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        debugPrint('overscroll');
        dosomething();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is OverscrollNotification) {}

        return true;
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Query(
                options: QueryOptions(
                    document: gql(queryInfo.allCompany),
                    variables: <String, dynamic>{
                      "companyName": "",
                      "industryId": [],
                      "page": 1,
                      "perPage": item,
                      "types": "Hiring"
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
                    if (dataCompany == null) {
                      return const ListJobLoad();
                    } else {
                      return bodyListCompany(true);
                    }
                  }
                  dataCompany =
                      result.data?['searchEmployerAllFunction']['employers'];
                  debugPrint(dataCompany?.length.toString());
                  if (dataCompany!.isEmpty) {
                    return const EmptyQuery();
                  }
                  return bodyListCompany(false);
                }),
          ],
        ),
      ),
    );
  }
}

class CompanyListTab extends StatelessWidget {
  const CompanyListTab(
      {Key? key,
      this.companyName,
      this.industry,
      this.jobOpenAmount,
      this.imageSrc,
      this.onTap})
      : super(key: key);
  final String? companyName;
  final String? industry;
  final String? jobOpenAmount;
  final String? imageSrc;
  final GestureTapCallback? onTap;
  final sizeheight = 3.6;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 15),
        height: mediaWidthSized(context, sizeheight),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(
                bottom: BorderSide(width: 0.5, color: AppColors.greyOpacity))),
        child: Row(
          children: [
            SizedBox(
                height: mediaWidthSized(context, sizeheight) - 24,
                width: mediaWidthSized(context, sizeheight) - 24,
                // color: AppColors.blue,
                child: Image(
                  image:
                      imageNetworkBuild('${QueryInfo().pictureBase}$imageSrc'),
                )

                // Image.network('${QueryInfo().pictureBase}$imageSrc'),
                ),
            // SizedBox(
            //   width: 12,
            // ),
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
                      "$companyName",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'PoppinsSemiBold',
                        color: Colors.black,
                        fontSize: mediaWidthSized(context, 26),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$industry",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'PoppinsRegular',
                            fontSize: mediaWidthSized(context, 31),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Job opening: ',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'PoppinsRegular',
                                fontSize: mediaWidthSized(context, 31),
                              ),
                            ),
                            Text(
                              jobOpenAmount == 'null'
                                  ? 'ບໍ່ມີຂໍ້ມູນ'
                                  : '$jobOpenAmount',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'PoppinsRegular',
                                fontSize: mediaWidthSized(context, 31),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
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
