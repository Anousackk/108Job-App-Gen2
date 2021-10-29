import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:app/api/auth.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/calculated.dart';
import 'package:app/function/sized.dart';
import 'package:app/screen/search_job_page.dart';
import 'package:app/screen/widget/empty_query.dart';
import 'package:app/screen/widget/job_list_view.dart';

import 'ControlScreen/bottom_navigation.dart';
import 'Shimmer/listjobshimmer.dart';
import 'job_detail_page.dart';

// import 'Widget/Morebutton.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({Key? key}) : super(key: key);

  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  Drag? drag;
  DragStartDetails? dragStartDetails;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
            child: AppBar(
              actions: [
                IconButton(
                    icon: const Text(
                      'search',
                      style: TextStyle(
                        fontFamily: 'FontAwesomeProRegular',
                        fontSize: 18.5,
                        color: AppColors.white,
                      ),
                    ),
                    color: AppColors.white,
                    onPressed: () => {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const SearchJobPage(false),
                              transitionDuration: const Duration(seconds: 0),
                            ),
                          )
                        })
              ],
              backgroundColor: AppColors.blue,

              centerTitle: true,
              title: Text(
                l.alljob,
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
                  horizontal: MediaQuery.of(context).size.width / 38),
              child: TabBar(
                unselectedLabelColor: AppColors.grey,
                // isScrollable: true,
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
                        l.alljob,
                      )),
                  // Container(
                  //     height: tabContainer(context),
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: tabbarheight(context)),
                  //     child: Text(
                  //       l.newGrad,
                  //     )),
                  Container(
                      height: tabContainer(context),
                      padding:
                          EdgeInsets.symmetric(vertical: tabbarheight(context)),
                      child: Text(
                        l.endingSoon,
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
                  children: [
                    JobTabView(type: 'allJobs'),
                    // JobTabView(type: 'NewGrad'),
                    JobTabView(type: 'EndingSoon')
                    // AllJobTabView(),
                    // NewGradTabView(),
                    // EndingSoonTabView()
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

class JobTabView extends StatefulWidget {
  final String type;

  const JobTabView({Key? key, required this.type}) : super(key: key);
  @override
  _JobTabViewState createState() => _JobTabViewState();
}

class _JobTabViewState extends State<JobTabView> {
  ScrollController scrollController = ScrollController();
  bool? morebutton = true;
  List<bool?>? isSavejobList = [];
  //// Fetch its doesnot show but have data
  int? moreItem = 0,
      moreFetch = 0,
      baseitem = 20,
      increaseitem = 10,
      baseFetch = 10;
  int item = 20;
  late String type = widget.type;

  QueryInfo queryInfo = QueryInfo();
  CutDateString convertDate = CutDateString();
  String? amount;
  List? dataJob;
  bool? fetchmore = false;
  bool? oneTimeFetch = true;
  dosomething() {
    if (dataJob?.length == item) {
      item = item + 20;
      debugPrint(item.toString());
      oneTimeFetch = true;
      // fetchmore = true;
      setState(() {});
    } else {}
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

  // bodyListWidget(bool isload) {
  //   return
  // }

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
            Query(
                options: QueryOptions(
                    document: gql(queryInfo.allJobs),
                    variables: <String, dynamic>{
                      "typeApp": type,
                      "page": 1,
                      "perPage": item,
                      "verifyToken": currentToken ?? ''
                      // baseFetch + moreFetch
                    }),
                builder: (QueryResult result, {refetch, fetchMore}) {
                  if (result.hasException) {
                    debugPrint(result.exception?.graphqlErrors[0].toString());
                    if (result.exception?.linkException?.originalException
                            .toString()
                            .substring(0, 50) ==
                        "SocketException: Failed host lookup: '${QueryInfo().baseHost}'") {
                      Future.delayed(const Duration(milliseconds: 3000))
                          .then((value) {
                        try {
                          try {
                            refetch!();
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      });
                    }
                    return const ListJobLoad();
                  }
                  if (result.isLoading) {
                    debugPrint('loading');
                    // morebutton = true;
                    if (dataJob == null) {
                      return const ListJobLoad();
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Mutation(
                                  options: MutationOptions(
                                    document: gql(QueryInfo().seekerSavejob),
                                    onCompleted: (data) {
                                      debugPrint(
                                          'completed: ' + data.toString());

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
                                          document:
                                              gql(QueryInfo().seekerunSave),
                                          onCompleted: (data) {
                                            debugPrint('completed: ' +
                                                data.toString());
                                            // debugPrint();

                                            setState(() {
                                              try {
                                                refetch!();
                                              } catch (e) {
                                                debugPrint(e.toString());
                                              }
                                            });
                                          },
                                          onError: (error) {
                                            debugPrint(
                                                'error ' + error.toString());
                                          },
                                        ),
                                        builder: (runMutationUnSave, result) {
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                // baseitem >= dataJob.length ? dataJob.length : baseitem + moreItem,
                                                dataJob?.length,
                                            itemBuilder: (context, index) {
                                              final repository =
                                                  dataJob?[index];
                                              List<String> locateList = [];
                                              repository['workingLocationId']
                                                  .forEach((element) {
                                                locateList.add(element['name']);
                                              });
                                              String jobID = repository['_id'];
                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return WidgetAllJobListView(
                                                    isSaved:
                                                        isSavejobList?[index],
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
                                                    jobTag:
                                                        repository['jobTag'],
                                                    picture: repository['logo'],
                                                    location: locateList,
                                                    position:
                                                        repository['title'],
                                                    dateStart: convertDate
                                                        .cutDateString(
                                                            repository[
                                                                'openingDate']),
                                                    dateEnd: convertDate
                                                        .cutDateString(
                                                            repository[
                                                                'closingDate']),
                                                    company: repository[
                                                        'companyName'],
                                                    onTap: () async {
                                                      await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                JobDetailPage(
                                                                  jobID: jobID,
                                                                )),
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        });
                                  }),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                l.loading,
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: mediaWidthSized(context, 31),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 12,
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  }

                  dataJob = result.data?['getJobAPP']['allJobs'];
                  if (oneTimeFetch == true) {
                    debugPrint('onetimeFetch');
                    if (dataJob!.length != isSavejobList!.length) {
                      isSavejobList = [];
                      debugPrint(dataJob?.length.toString());
                      dataJob?.forEach((element) {
                        debugPrint(element.toString());
                        isSavejobList?.add(element['isSaved']);
                      });
                      oneTimeFetch = false;
                    }
                  }
                  debugPrint(dataJob.toString());
                  amount = result.data?['getJobAPP']['totals'].toString();
                  if (dataJob != null && dataJob!.isEmpty) {
                    return const EmptyQuery();
                  }

                  return Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
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
                                    // debugPrint();

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
                                    itemCount:
                                        // baseitem >= dataJob.length ? dataJob.length : baseitem + moreItem,
                                        dataJob?.length,
                                    itemBuilder: (context, index) {
                                      final repository = dataJob?[index];
                                      List<String> locateList = [];
                                      repository['workingLocationId']
                                          .forEach((element) {
                                        locateList.add(element['name']);
                                      });
                                      String jobID = repository['_id'];
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return WidgetAllJobListView(
                                            isSaved: isSavejobList?[index],
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
                                                debugPrint(isSavejobList?[index]
                                                    .toString());
                                              });
                                            },
                                            jobTag: repository['jobTag'],
                                            picture: repository['logo'],
                                            location: locateList,
                                            position: repository['title'],
                                            dateStart:
                                                convertDate.cutDateString(
                                                    repository['openingDate']),
                                            dateEnd: convertDate.cutDateString(
                                                repository['closingDate']),
                                            company: repository['companyName'],
                                            onTap: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        JobDetailPage(
                                                          jobID: jobID,
                                                        )),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  );
                                });
                          }),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        l.loading,
                        style: TextStyle(
                          color: AppColors.white,
                          fontFamily: 'PoppinsRegular',
                          fontSize: mediaWidthSized(context, 31),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 12,
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
