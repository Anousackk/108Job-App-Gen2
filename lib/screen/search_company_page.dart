import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/pluginfunction.dart';
import 'package:app/function/sized.dart';

import 'Shimmer/listjobshimmer.dart';
import 'companies_page.dart';
import 'company_detail.dart';
import 'widget/search_widget.dart';

class SearchCompanyPage extends StatefulWidget {
  const SearchCompanyPage(this.repositories, {Key? key}) : super(key: key);
  final dynamic repositories;
  @override
  _SearchCompanyPageState createState() => _SearchCompanyPageState();
}

bool loadingSearchcom = false;
bool refec = false;

class _SearchCompanyPageState extends State<SearchCompanyPage> {
  // _SearchCompanyPageState(this.repositories);
  late final dynamic repositories = widget.repositories;
  List<dynamic> recentsearch = [];
  FocusNode focusText = FocusNode();
  TextEditingController searchComcontroller = TextEditingController();
  int item = 20;
  ScrollController scrollController = ScrollController();
  List? dataCompany;
  // bool morebutton = true;

  //// Fetch its doesnot show but have data
  // int moreItem = 0,
  //     moreFetch = 0,
  //     baseitem = 10,
  //     increaseitem = 10,
  //     baseFetch = 60;
  String searchtext = '';
  bool recentshow = false;
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
        // SizedBox(
        //   height: 20,
        // ),
        ListView.builder(
            itemCount: dataCompany!.length,

            // baseitem >= repositories.length
            //     ? repositories.length
            //     : baseitem + moreItem,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var repository = dataCompany?[index];
              if (index == 0) {
                return Container(
                    decoration: const BoxDecoration(
                        // color: AppColors.white,
                        border: Border(
                            top: BorderSide(
                                width: 0.5, color: AppColors.greyOpacity))),
                    child: CompanyListTab(
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
                        industry: '${repository['industryId'].join(', ')}'));
              } else {
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
              }
            }),
        // GridView.builder(
        //   padding: EdgeInsets.symmetric(
        //       horizontal:
        //           MediaQuery.of(context).size.width / 40),
        //   gridDelegate:
        //       SliverGridDelegateWithFixedCrossAxisCount(
        //           crossAxisCount: 2,
        //           crossAxisSpacing:
        //               MediaQuery.of(context).size.width / 40,
        //           mainAxisSpacing: 10.0,
        //           childAspectRatio: 1.3),
        //   physics: NeverScrollableScrollPhysics(),
        //   shrinkWrap: true,
        //   itemCount: baseitem >= repositories.length
        //       ? repositories.length
        //       : baseitem + moreItem,
        //   itemBuilder: (context, index) {
        //     var repository = repositories[index];
        //     return GestureDetector(
        //       onTap: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => CompanyDetailPage(
        //                     repository['_id'],
        //                   )),
        //         );
        //       },
        //       child: Container(
        //         decoration: BoxDecoration(
        //             color: AppColors.white,
        //             borderRadius:
        //                 BorderRadius.all(Radius.circular(3)),
        //             border: Border.all(
        //               color: AppColors.greyOpacity,
        //               width: 0.5,
        //             )),
        //         child: Column(
        //           children: [
        //             Column(
        //               children: [
        //                 SizedBox(
        //                   height: MediaQuery.of(context)
        //                           .size
        //                           .width /
        //                       35,
        //                 ),
        //                 Container(
        //                   // color: AppColors.blue,
        //                   height: MediaQuery.of(context)
        //                           .size
        //                           .width /
        //                       4.6,
        //                   width: MediaQuery.of(context)
        //                           .size
        //                           .width /
        //                       4.6,
        //                   child: Image.network(
        //                     '${QueryInfo().pictureBase}${repository['logo']}',
        //                     loadingBuilder: (context,
        //                         child,
        //                         ImageChunkEvent
        //                             loadingProgress) {
        //                       if (loadingProgress == null)
        //                         return child;
        //                       return Shimmer.fromColors(
        //                         child: Container(
        //                           height:
        //                               MediaQuery.of(context)
        //                                       .size
        //                                       .width /
        //                                   4.6,
        //                           width:
        //                               MediaQuery.of(context)
        //                                       .size
        //                                       .width /
        //                                   4.6,
        //                           color: AppColors.white,
        //                         ),
        //                         baseColor:
        //                             AppColors.greyWhite,
        //                         highlightColor:
        //                             AppColors.greyShimmer,
        //                       );
        //                     },
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             SizedBox(
        //               height:
        //                   MediaQuery.of(context).size.width /
        //                       30,
        //             ),
        //             Row(
        //               mainAxisAlignment:
        //                   MainAxisAlignment.center,
        //               children: [
        //                 Expanded(
        //                   child: Container(
        //                     // color: Colors.blue,
        //                     child: Text(
        //                       '${repository['companyName']}',
        //                       overflow: TextOverflow.ellipsis,
        //                       textAlign: TextAlign.center,
        //                       style: TextStyle(
        //                         color: AppColors.blue,
        //                         fontFamily: 'PoppinsSemiBold',
        //                         fontSize:
        //                             MediaQuery.of(context)
        //                                     .size
        //                                     .width /
        //                                 30,
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             )
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        // ),
        const SizedBox(
          height: 10,
        ),
        // ListView.builder(
        //   shrinkWrap: true,
        //   physics: NeverScrollableScrollPhysics(),
        //   itemCount: baseitem >= repositories.length
        //       ? repositories.length
        //       : baseitem + moreItem,
        //   itemBuilder: (context, index) {
        //     var repository = repositories[index];
        //     return WidgetCompanyListView(
        //       picture: '${repository['logo']}',
        //       onTap: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => CompanyPage(
        //                     companyID: repository['_id'],
        //                   )),
        //         );
        //       },
        //       companyName: '${repository['companyName']}',
        //       bio: '${repository['industryId']['name']}',
        //       location:
        //           '${repository['districtId']['provinceId']['name']}',
        //       // openingAmount: null,
        //       openingAmount: '${repository['jobsCount']}' == null
        //           ? '${repository['jobsCount']}'
        //           : '0',
        //     );
        //   },
        // ),
        // MoreButton(
        //   onTap: () {
        //     setState(() {
        //       if (baseFetch + moreFetch ==
        //               repositories.length &&
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
        // Visibility(
        //   visible:
        //       baseitem >= repositories.length ? false : morebutton,
        //   child: InkWell(
        //     splashColor: AppColors.blue,
        //     child: Container(
        //       decoration: BoxDecoration(
        //           color: AppColors.blue,
        //           borderRadius:
        //               BorderRadius.all(Radius.circular(20)),
        //           border: Border.all(
        //             color: AppColors.greyOpacity,
        //             width: 0.5,
        //           )),
        //       padding: EdgeInsets.symmetric(horizontal: 10),
        //       margin:
        //           EdgeInsets.only(left: 30, right: 30, bottom: 5),
        //       child: SizedBox(
        //         height: 30,
        //         child: Center(
        //           child: Text(
        //             'More companies',
        //             style: TextStyle(
        //               fontFamily: 'PoppinsRegular',
        //               color: AppColors.white,
        //               fontSize: 15,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
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

  manageRecent(String value) {
    if (searchComcontroller.text.trim().isNotEmpty) {
      if (recentsearch.isNotEmpty && recentsearch.contains(value)) {
        recentsearch.remove(value);
        recentsearch.insert(0, value);
      } else {
        recentsearch.insert(0, value);
      }
      if (recentsearch.isNotEmpty && recentsearch.length > 5) {
        recentsearch.removeLast();
      }
      SharedPref().save('recentcomsearch', recentsearch);
    }
  }

  Future getRecent() async {
    var read = await SharedPref().read('recentcomsearch');
    recentsearch = read;
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
  void dispose() {
    industselect = [];
    indusIDselect = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (focusText.hasFocus) {
      recentshow = true;
    } else {
      recentshow = false;
    }
    return SafeArea(
        child: GestureDetector(
      onTap: () {
        if (focusText.hasFocus) {
          focusText.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            Container(
              height: appbarsize(context) + mediaWidthSized(context, 65),
              width: MediaQuery.of(context).size.width,
              color: AppColors.blue,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.white),
                    onPressed: () {
                      if (focusText.hasFocus) {
                        focusText.unfocus();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          height: mediaWidthSized(context, 10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: AppColors.white,
                            // border: Border.all(
                            //   color: AppColors.greyOpacity,
                            //   width: 0.5,
                            // )
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: mediaWidthSized(context, 23),
                                ),
                                child: TextField(
                                    onSubmitted: (value) {
                                      manageRecent(value);
                                      searchtext = value;
                                      refec = true;
                                      setState(() {});
                                    },
                                    focusNode: focusText,
                                    autofocus: true,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    controller: searchComcontroller,
                                    style: TextStyle(
                                      fontFamily: 'PoppinsMedium',
                                      fontSize: mediaWidthSized(context, 25),
                                      // color: AppColors.blueSky
                                    ),
                                    decoration: InputDecoration(
                                        hintText: l.searchCompany,
                                        fillColor: AppColors.white,
                                        border: InputBorder.none,
                                        hintStyle: const TextStyle(
                                            color: AppColors.greyOpacity))),
                              ),
                            ),
                            Visibility(
                              visible:
                                  searchComcontroller.text.trim().isNotEmpty,
                              child: IconButton(
                                  icon: Text(
                                    'times-circle',
                                    style: TextStyle(
                                      fontFamily: 'FontAwesomeProSolid',
                                      fontSize: mediaWidthSized(context, 23),
                                      color: AppColors.greyOpacity,
                                    ),
                                  ),
                                  color: AppColors.white,
                                  onPressed: () {
                                    searchComcontroller.text = '';

                                    setState(() {});
                                    // Navigator.push(
                                    //   context,
                                    //   PageRouteBuilder(
                                    //     pageBuilder: (_, __, ___) => SearchPage(),
                                    //     transitionDuration: Duration(seconds: 0),
                                    //   ),
                                    // )
                                  }),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: mediaWidthSized(context, 80),
                  ),
                  IconButton(
                      icon: Text(
                        'search',
                        style: TextStyle(
                          fontFamily: 'FontAwesomeProRegular',
                          fontSize: mediaWidthSized(context, 23),
                          color: AppColors.white,
                        ),
                      ),
                      color: AppColors.white,
                      onPressed: () {
                        if (focusText.hasFocus) {
                          focusText.unfocus();
                        }
                        manageRecent(searchComcontroller.text);
                        searchtext = searchComcontroller.text;
                        refec = true;
                        setState(() {});

                        // Navigator.push(
                        //   context,
                        //   PageRouteBuilder(
                        //     pageBuilder: (_, __, ___) => SearchPage(),
                        //     transitionDuration: Duration(seconds: 0),
                        //   ),
                        // )
                      }),
                  SizedBox(
                    width: mediaWidthSized(context, 80),
                  ),
                ],
              ),
            ),
            Visibility(
                visible: recentshow && recentsearch.isNotEmpty,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: const Offset(
                                0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          HeaderSortbyAndSelect(
                            title: l.recentSearch,
                            height: 10,
                            onTap: () {
                              recentsearch = [];
                              SharedPref().save('recentsearch', recentsearch);
                              setState(() {});
                            },
                          ),
                          Container(
                            decoration: const BoxDecoration(

                                // color: AppColors.blueSky,
                                // border: Border(
                                //     bottom: BorderSide(
                                //         width: 0.3, color: AppColors.grey)),
                                ),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: recentsearch.contains(null) ||
                                      recentsearch.isEmpty
                                  ? 0
                                  : recentsearch.length,
                              itemBuilder: (context, index) {
                                return ListItemForSearch(
                                  onTap: () {
                                    if (focusText.hasFocus) {
                                      focusText.unfocus();
                                    }
                                    setState(() {
                                      searchComcontroller.text =
                                          recentsearch[index];
                                      manageRecent(searchComcontroller.text);
                                    });
                                  },
                                  height: 10,
                                  onTapIcon: () {
                                    recentsearch.removeAt(index);
                                    SharedPref()
                                        .save('recentsearch', recentsearch);

                                    setState(() {});
                                  },
                                  title: recentsearch[index],
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchByIndustry(
                        repositories: repositories,
                      ),
                    )).then((value) {
                  setState(() {});
                });
              },
              child: Container(
                height: mediaWidthSized(context, 8),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      '  building  ',
                      style: TextStyle(
                        fontFamily: 'FontAwesomeProRegular',
                        fontSize: mediaWidthSized(context, 18),
                        color: industselect.isEmpty ||
                                industselect.join('').trim().isEmpty
                            ? AppColors.grey
                            : AppColors.blue,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        industselect.isEmpty ||
                                industselect.join('').trim().isEmpty
                            ? '  ${l.sortbyindustry}'
                            : '  ${industselect.join(', ')}',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          color: AppColors.grey,
                          fontSize: mediaWidthSized(context, 30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Query(
                  options: QueryOptions(
                      document: gql(QueryInfo().allCompany),
                      variables: <String, dynamic>{
                        "companyName": searchtext,
                        "page": 1,
                        "perPage": item,
                        "industryId": indusIDselect,
                        "types": "AllCompanies"
                      }),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }
                    if (result.isLoading) {
                      // morebutton = true;
                      if (dataCompany == null) {
                        return const ListJobLoad();
                      } else {
                        return bodyListCompany(true);
                      }
                    }
                    if (searchtext.trim().isEmpty && indusIDselect.isEmpty) {
                      return Container();
                    }
                    if (refec == true) {
                      loadingSearchcom = true;
                      Future.delayed(const Duration(milliseconds: 300))
                          .then((value) {
                        loadingSearchcom = false;
                        setState(() {});
                        try {
                          refetch!();
                        } catch (e) {
                          debugPrint(e.toString());
                        }

                        refec = false;
                      });
                    }
                    if (loadingSearchcom == true) {
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 40,
                          ),
                          const SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    }
                    dataCompany =
                        result.data?['searchEmployerAllFunction']['employers'];
                    return bodyListCompany(false);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

List industselect = [];
List indusIDselect = [];

class SearchByIndustry extends StatefulWidget {
  const SearchByIndustry({Key? key, required this.repositories})
      : super(key: key);
  final List repositories;
  @override
  _SearchByIndustryState createState() => _SearchByIndustryState();
}

class _SearchByIndustryState extends State<SearchByIndustry> {
  // _SearchByIndustryState(this.repositories);
  late final List repositories = widget.repositories;
  @override
  void dispose() {
    refec = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          child: ListBody(children: [
        Container(
          height: appbarsize(context) + mediaWidthSized(context, 65),
          width: MediaQuery.of(context).size.width,
          color: AppColors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              InkWell(
                onTap: () {
                  refec = true;
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: mediaWidthSized(context, 25),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${l.finish} ',
                        style: TextStyle(
                          fontFamily: 'PoppinsRegular',
                          fontSize: mediaWidthSized(context, 28),
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        'check ',
                        style: TextStyle(
                          fontFamily: 'FontAwesomeProRegular',
                          fontSize: mediaWidthSized(context, 28),
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: industselect.isNotEmpty,
          child: HeaderSortbyAndSelect(
              height: 8,
              onTap: () {
                indusIDselect = [];
                industselect = [];
                setState(() {});
              },
              title: l.selectedCAP),
        ),
        ListView.builder(
          itemCount: (industselect.isEmpty ? 0 : industselect.length),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListItemForSearch(
              height: 8,
              title: '${industselect[index]}',
              onTapIcon: () {
                indusIDselect.removeAt(index);
                industselect.removeAt(index);

                setState(() {});
              },
            );
          },
        ),
        ListBody(
          children: [
            Container(
              // margin: EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.only(left: 20),
              decoration: const BoxDecoration(
                  color: AppColors.grey,
                  border: Border(
                      top: BorderSide(width: 0.3, color: AppColors.grey))),
              height: mediaWidthSized(context, 8),
              width: mediaWidthSized(context, 1) - 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l.industryCAP,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.white,
                      fontFamily: 'PoppinsSemiBold',
                      fontSize: indexL == 0
                          ? mediaWidthSized(context, 30)
                          : mediaWidthSized(context, 27),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              itemCount: repositories.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Visibility(
                  visible: !industselect.contains(repositories[index]['name']),
                  child: InkWell(
                    splashColor: AppColors.greyWhite,
                    onTap: () {
                      industselect.add(repositories[index]['name']);
                      indusIDselect.add(repositories[index]['_id']);

                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.only(left: 10),
                      decoration: const BoxDecoration(
                          // color: AppColors.blueSky,
                          border: Border(
                              top: BorderSide(
                                  width: 0.3, color: AppColors.grey))),
                      height: mediaWidthSized(context, 8),
                      width: mediaWidthSized(context, 1) - 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              repositories[index]['name'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.grey,
                                fontFamily: 'PoppinsRegular',
                                fontSize: mediaWidthSized(context, 30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        )
      ])),
    ));
  }
}
