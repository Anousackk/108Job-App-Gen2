import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:app/api/auth.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/animationfade.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/calculated.dart';
import 'package:app/function/sized.dart';

import 'AuthenScreen/login_page.dart';
import 'ControlScreen/bottom_navigation.dart';
import 'Shimmer/listjobshimmer.dart';
import 'job_detail_page.dart';
import 'widget/empty_query.dart';
import 'widget/job_list_view.dart';

class MyJobsPage extends StatefulWidget {
  const MyJobsPage({Key? key}) : super(key: key);

  @override
  _MyJobsPageState createState() => _MyJobsPageState();
}

dynamic dataSavedJob;
dynamic dataAppliedJob;

class _MyJobsPageState extends State<MyJobsPage> {
  @override
  Widget build(BuildContext context) {
    Drag? drag;
    DragStartDetails? dragStartDetails;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
            child: AppBar(
              // actions: [
              //   IconButton(
              //       icon: Text(
              //         'search',
              //         style: TextStyle(
              //           fontFamily: 'FontAwesomeProRegular',
              //           fontSize: 20,
              //           color: Colors.white,
              //         ),
              //       ),
              //       color: Colors.white,
              //       onPressed: () => {
              //             // Navigator.push(
              //             //   context,
              //             //   PageRouteBuilder(
              //             //     pageBuilder: (_, __, ___) => SearchPage(),
              //             //     transitionDuration: Duration(seconds: 0),
              //             //   ),
              //             // )
              //           })
              // ],
              backgroundColor: AppColors.blue,

              centerTitle: true,
              title: Text(
                l.myjob,
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
                // physics: NeverScrollableScrollPhysics(),

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
                        l.savedjob,
                      )),
                  Container(
                      height: tabContainer(context),
                      padding:
                          EdgeInsets.symmetric(vertical: tabbarheight(context)),
                      child: Text(
                        l.appliedjob,
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
                  // physics: NeverScrollableScrollPhysics(),
                  children: [
                    SavedApplyJobTabView('Saved'),
                    SavedApplyJobTabView('Applied')
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

bool myJobsave = false;
bool? myJobload = false;
CutDateString convertDate = CutDateString();
QueryInfo queryInfo = QueryInfo();

class SavedApplyJobTabView extends StatefulWidget {
  const SavedApplyJobTabView(this.type, {Key? key}) : super(key: key);
  final String type;

  @override
  _SavedApplyJobTabViewState createState() => _SavedApplyJobTabViewState();
}

class _SavedApplyJobTabViewState extends State<SavedApplyJobTabView> {
  List? dataJob;

  late final String type = widget.type;
  int? edit;
  bool? onInvisible = false;
  bool? dontfetch = false;
  List? repositories = [];
  List<bool> visible = [];
  // bool whenopen;
  List? check;

  isDif() {
    bool ischeck = true;
    int i = 0;
    repositories?.forEach((element) {
      if (check?[i]['JobId']['_id'] != element['JobId']['_id']) {
        ischeck = false;
      }
      i = i + 1;
    });
    return ischeck;
  }

  @override
  void dispose() {
    super.dispose();
    myJobsave = true;
  }

  @override
  void initState() {
    debugPrint(widget.type);
    super.initState();
    myJobsave = false;
    visible = [];
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
            Query(
              options: QueryOptions(
                document: gql(queryInfo.qeuryAppleSave),
                variables: {
                  "type": widget.type,
                  "page": 1,
                  "perPage": 300,
                  "search": ""
                },
              ),
              builder: (result, {fetchMore, refetch}) {
                if (result.hasException) {
                  debugPrint(result.exception.toString());
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                        ),
                        Text(
                          'user-times',
                          style: TextStyle(
                              fontSize: mediaWidthSized(context, 4),
                              color: AppColors.blue,
                              fontFamily: 'FontAwesomeProSolid'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          l.younotSignin,
                          style: TextStyle(
                            fontFamily: 'PoppinsSemiBold',
                            color: AppColors.blue,
                            fontSize: indexL == 0
                                ? mediaWidthSized(context, 20)
                                : mediaWidthSized(context, 17),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  settings: const RouteSettings(name: "/login"),
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.blue,
                            ),
                            child: Container(
                              height: mediaWidthSized(context, 10),
                              width: mediaWidthSized(context, 2.2),
                              alignment: Alignment.center,
                              child: Text(
                                l.gotoSignin,
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontFamily: 'PoppinsRegular',
                                    fontSize: indexL == 0
                                        ? mediaWidthSized(context, 25)
                                        : mediaWidthSized(context, 22)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  );
                }
                if (result.isLoading && dataJob == null) {
                  return const ListJobLoad();
                }
                debugPrint(result.data.toString());
                // check = result.data['getApplySaveJob']['job'];
                if (currentToken == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                        ),
                        Text(
                          'user-times',
                          style: TextStyle(
                              fontSize: mediaWidthSized(context, 4),
                              color: AppColors.blue,
                              fontFamily: 'FontAwesomeProSolid'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          l.younotSignin,
                          style: TextStyle(
                            fontFamily: 'PoppinsSemiBold',
                            color: AppColors.blue,
                            fontSize: indexL == 0
                                ? mediaWidthSized(context, 20)
                                : mediaWidthSized(context, 17),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  settings: const RouteSettings(name: "/login"),
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.blue,
                            ),
                            child: Container(
                              height: mediaWidthSized(context, 10),
                              width: mediaWidthSized(context, 2.2),
                              alignment: Alignment.center,
                              child: Text(
                                l.gotoSignin,
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontFamily: 'PoppinsRegular',
                                    fontSize: indexL == 0
                                        ? mediaWidthSized(context, 25)
                                        : mediaWidthSized(context, 22)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  );
                }
                if (myJobsave == true) {
                  try {
                    refetch!();
                  } catch (e) {
                    debugPrint(e.toString());
                  }

                  myJobsave = false;
                }
                if (dontfetch == false) {
                  if (widget.type == 'Saved') {
                    dataSavedJob = result.data?['getApplySaveJob']['job'];
                    dataJob = dataSavedJob;
                  } else {
                    dataAppliedJob = result.data?['getApplySaveJob']['job'];
                    dataJob = dataAppliedJob;
                  }
                }
                if (myJobsave == true) {
                  try {
                    refetch!();
                  } catch (e) {
                    debugPrint(e.toString());
                  }

                  myJobsave = false;
                }
                dataJob?.forEach((element) {
                  if (visible.length < dataJob!.length) {
                    visible.add(true);
                  }
                });

                if (dataJob?.length !=
                    result.data?['getApplySaveJob']['job'].length) {
                  visible[edit!] = true;
                  onInvisible = false;
                }
                dataJob = result.data?['getApplySaveJob']['job'];
                if (dataJob!.isEmpty) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          EmptyQuery(),
                        ],
                      ),
                    ],
                  );
                }
                //debugPrint(result.data);
                // dataSavedJob = result.data['appliedJobSaveJob']['job'];

                // return Container();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: dataJob?.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var repository = dataJob?[index];
                    bool fade = true;
                    return StatefulBuilder(builder:
                        (BuildContext context, StateSetter setStateWidget) {
                      return Visibility(
                        visible: visible[index],
                        child: FadeReverse(
                          duration: const Duration(milliseconds: 200),
                          visible: fade,
                          child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                              color: AppColors.greyOpacity,
                              width: 0.5,
                            ))),
                            child: WidgetMyJobListView(
                                location: repository['workingLocation'],
                                position: '${repository['title']}',
                                dateStart: convertDate
                                    .cutDateString(repository['createAt']),
                                dateEnd: convertDate
                                    .cutDateString(repository['closingDate']),
                                picture: '${repository['logo']}',
                                company: '${repository['companyName']}',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => JobDetailPage(
                                              jobID: repository['jobId'],
                                            )),
                                  ).then((value) {
                                    try {
                                      refetch!();
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
                                  });
                                },
                                popupmenu: Mutation(
                                  options: MutationOptions(
                                    document: gql(queryInfo.seekerUndoSaveAppl),
                                    onCompleted: (data) {
                                      dontfetch = true;
                                      try {
                                        refetch!();
                                      } catch (e) {
                                        debugPrint(e.toString());
                                      }
                                      debugPrint(data.toString());
                                    },
                                    onError: (error) {
                                      debugPrint(error.toString());
                                    },
                                  ),
                                  builder: (runMutation, result) {
                                    if (onInvisible!) {
                                      return GestureDetector(
                                        onTap: () {},
                                        child: const SizedBox(
                                            width: 48,
                                            child: Icon(Icons.more_vert)),
                                      );
                                    } else {
                                      return SizedBox(
                                        width: 48,
                                        child: PopupMenuButton(
                                          padding: const EdgeInsets.all(0),
                                          elevation: 1,
                                          shape: Border.all(
                                              width: 0.2,
                                              color: AppColors.grey),
                                          // shape: ShapeBorder(),
                                          onSelected: (value) {
                                            switch (value) {
                                              case 1:
                                                if (onInvisible == false) {
                                                  onInvisible = true;
                                                  setStateWidget(() {
                                                    fade = false;
                                                    edit = index;
                                                  });
                                                  Future.delayed(const Duration(
                                                          milliseconds: 200))
                                                      .then((value) {
                                                    setStateWidget(() {
                                                      visible[index] = false;
                                                    });
                                                    runMutation({
                                                      "type": widget.type,
                                                      "JobId":
                                                          repository['jobId']
                                                    });
                                                  });
                                                }
                                                break;
                                              // default:
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  11,
                                              value: 1,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    ' trash-alt  ',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'FontAwesomeProRegular',
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            24,
                                                        color:
                                                            AppColors.yellow),
                                                  ),
                                                  Text(
                                                    'Remove',
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            26,
                                                        fontFamily:
                                                            'PoppinsMedium'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                )),
                          ),
                        ),
                      );
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
