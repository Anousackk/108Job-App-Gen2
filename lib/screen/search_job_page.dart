// import 'package:app/function/calculated.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:app/api/auth.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/pluginfunction.dart';
import 'package:app/function/sized.dart';

import 'job_detail_page.dart';
import 'my_jobs_page.dart';
import 'widget/job_list_view.dart';
import 'widget/search_widget.dart';

class SearchJobPage extends StatefulWidget {
  const SearchJobPage(this.formlanding, {Key? key}) : super(key: key);
  final bool? formlanding;
  @override
  _SearchJobPageState createState() => _SearchJobPageState();
}

bool refek = false;
bool loadingSearchjob = false;

class _SearchJobPageState extends State<SearchJobPage> {
  List<dynamic>? recentsearch = [];

  List<bool?>? isSavejobList = [];

  TextEditingController searchcontroller = TextEditingController();
  ScrollController scrollController = ScrollController();
  int? item = 20;
  List? dataJob;
  late final bool? formlanding = widget.formlanding ?? false;
  String? searchtext = '';
  FocusNode focusText = FocusNode();
  bool? recentshow = false;
  bool? oneTimeFetch = true;
  // List searchRepositorie;
  Future getRecent() async {
    var read = await SharedPref().read('recentsearch');
    recentsearch = read;
  }

  dosomething() {
    if (dataJob?.length == item) {
      item = item! + 20;
      debugPrint(item.toString());
      oneTimeFetch = true;
      // fetchmore = true;
      setState(() {});
    } else {}
  }

  manageRecent(String value) {
    if (searchcontroller.text.trim().isNotEmpty) {
      if (recentsearch!.isNotEmpty && recentsearch!.contains(value)) {
        recentsearch?.remove(value);
        recentsearch?.insert(0, value);
      } else {
        recentsearch?.insert(0, value);
      }
      if (recentsearch!.isNotEmpty && recentsearch!.length > 5) {
        recentsearch?.removeLast();
      }
      SharedPref().save('recentsearch', recentsearch);
    }
  }

  @override
  void dispose() {
    super.dispose();

    searchcontroller.text = '';
    jobIDselect = [];
    jobselect = [];
    provinceIDselect = [];
    provinceselect = [];
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
    getRecent().then((value) {
      setState(() {});

      recentsearch ??= [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (focusText.hasFocus) {
      recentshow = true;
    } else {
      recentshow = false;
    }
    return Container(
      color: AppColors.blue,
      child: SafeArea(
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
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.white),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
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
                                        horizontal:
                                            mediaWidthSized(context, 23)),
                                    child: TextField(
                                        onSubmitted: (value) {
                                          manageRecent(value);
                                          searchtext = value;
                                          refek = true;
                                          setState(() {});
                                        },
                                        focusNode: focusText,
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        autofocus:
                                            formlanding == false ? true : false,
                                        controller: searchcontroller,
                                        style: TextStyle(
                                          fontFamily: 'PoppinsMedium',
                                          fontSize:
                                              mediaWidthSized(context, 25),
                                          // color: AppColors.blueSky
                                        ),
                                        decoration: InputDecoration(
                                            hintText: l.searchjob,
                                            fillColor: AppColors.white,
                                            border: InputBorder.none,
                                            hintStyle: const TextStyle(
                                                color: AppColors.greyOpacity))),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      searchcontroller.text.trim().isNotEmpty,
                                  child: IconButton(
                                      icon: Text(
                                        'times-circle',
                                        style: TextStyle(
                                          fontFamily: 'FontAwesomeProSolid',
                                          fontSize:
                                              mediaWidthSized(context, 23),
                                          color: AppColors.greyOpacity,
                                        ),
                                      ),
                                      color: AppColors.white,
                                      onPressed: () {
                                        searchcontroller.text = '';
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
                            manageRecent(searchcontroller.text);

                            searchtext = searchcontroller.text;
                            refek = true;
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
                    visible: recentshow! && recentsearch!.isNotEmpty,
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
                                height: 11,
                                onTap: () {
                                  recentsearch = [];
                                  SharedPref()
                                      .save('recentsearch', recentsearch);
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
                                  itemCount: recentsearch == null ||
                                          recentsearch!.contains(null) ||
                                          recentsearch!.isEmpty
                                      ? 0
                                      : recentsearch!.length,
                                  itemBuilder: (context, index) {
                                    return ListItemForSearch(
                                      onTap: () {
                                        if (focusText.hasFocus) {
                                          focusText.unfocus();
                                        }
                                        setState(() {
                                          refek = true;
                                          searchtext = recentsearch?[index];
                                          searchcontroller.text =
                                              recentsearch?[index];
                                          manageRecent(searchcontroller.text);
                                        });
                                        refek = true;
                                      },
                                      height: 11,
                                      onTapIcon: () {
                                        recentsearch?.removeAt(index);
                                        SharedPref()
                                            .save('recentsearch', recentsearch);

                                        setState(() {});
                                      },
                                      title: recentsearch?[index],
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 2,
                ),
                Column(
                  children: [
                    Container(
                      height: mediaWidthSized(context, 8),
                      width: MediaQuery.of(context).size.width,
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Query(
                                options: QueryOptions(
                                    document: gql(QueryInfo().getjobfunction)),
                                builder: (result, {fetchMore, refetch}) {
                                  if (result.isLoading) {
                                    return SizedBox(
                                      height: mediaWidthSized(context, 8),
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: InkWell(
                                        onTap: () {},
                                        splashColor: AppColors.grey,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '  briefcase',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'FontAwesomeProRegular',
                                                  fontSize: mediaWidthSized(
                                                      context, 18),
                                                  color: jobselect.isEmpty ||
                                                          jobselect
                                                              .join('')
                                                              .trim()
                                                              .isEmpty
                                                      ? AppColors.grey
                                                      : AppColors.blue,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  jobselect.isEmpty ||
                                                          jobselect
                                                              .join('')
                                                              .trim()
                                                              .isEmpty
                                                      ? '  ${l.jobfunction}'
                                                      : '  ${jobselect.join(', ')}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'PoppinsSemiBold',
                                                    color: AppColors.grey,
                                                    fontSize: indexL == 0
                                                        ? mediaWidthSized(
                                                            context, 30)
                                                        : mediaWidthSized(
                                                            context, 27),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '  ',
                                                style: TextStyle(
                                                  fontSize: mediaWidthSized(
                                                      context, 23),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  List repositories =
                                      result.data?['getJobFunction'];
                                  return SizedBox(
                                    height: mediaWidthSized(context, 8),
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: InkWell(
                                      onTap: () {
                                        if (focusText.hasFocus) {
                                          focusText.unfocus();
                                        }
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchSortByPage(
                                                repositories: repositories,
                                                fromJobfunction: true,
                                              ),
                                            )).then((value) {
                                          setState(() {});
                                        });
                                        // Navigator.push(
                                        //   context,
                                        //   PageRouteBuilder(
                                        //     pageBuilder: (_, __, ___) =>

                                        //     transitionDuration:
                                        //         Duration(seconds: 0),
                                        //   ),
                                        // );
                                      },
                                      splashColor: AppColors.grey,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '  briefcase',
                                              style: TextStyle(
                                                fontFamily:
                                                    'FontAwesomeProRegular',
                                                fontSize: mediaWidthSized(
                                                    context, 18),
                                                color: jobselect.isEmpty ||
                                                        jobselect
                                                            .join('')
                                                            .trim()
                                                            .isEmpty
                                                    ? AppColors.grey
                                                    : AppColors.blue,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                jobselect.isEmpty ||
                                                        jobselect
                                                            .join('')
                                                            .trim()
                                                            .isEmpty
                                                    ? '  ${l.jobfunction}'
                                                    : '  ${jobselect.join(', ')}',
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontFamily: 'PoppinsSemiBold',
                                                  color: AppColors.grey,
                                                  fontSize: indexL == 0
                                                      ? mediaWidthSized(
                                                          context, 30)
                                                      : mediaWidthSized(
                                                          context, 27),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '  ',
                                              style: TextStyle(
                                                fontSize: mediaWidthSized(
                                                    context, 23),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Query(
                                options: QueryOptions(
                                    document: gql(QueryInfo().getProvince),
                                    variables: {
                                      'options': indexL == 0 ? 'EN' : 'LA'
                                    }),
                                builder: (result, {fetchMore, refetch}) {
                                  if (result.isLoading) {
                                    return InkWell(
                                      onTap: () {},
                                      splashColor: AppColors.grey,
                                      child: SizedBox(
                                        height: mediaWidthSized(context, 8),
                                        width: mediaWidthSized(context, 2),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '  map-marker-alt',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'FontAwesomeProRegular',
                                                  fontSize: mediaWidthSized(
                                                      context, 18),
                                                  color:
                                                      provinceselect.isEmpty ||
                                                              provinceselect
                                                                  .join('')
                                                                  .trim()
                                                                  .isEmpty
                                                          ? AppColors.grey
                                                          : AppColors.blue,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  provinceselect.isEmpty ||
                                                          provinceselect
                                                              .join('')
                                                              .trim()
                                                              .isEmpty
                                                      ? '  ${l.location}'
                                                      : '  ${seperateTranslate(provinceselect).join(', ')}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'PoppinsSemiBold',
                                                    color: AppColors.grey,
                                                    fontSize: indexL == 0
                                                        ? mediaWidthSized(
                                                            context, 30)
                                                        : mediaWidthSized(
                                                            context, 27),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '  ',
                                                style: TextStyle(
                                                  fontSize: mediaWidthSized(
                                                      context, 23),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // child: Text(

                                          //   overflow: TextOverflow.ellipsis,
                                          //   style: TextStyle(
                                          //     fontFamily: 'PoppinsSemiBold',
                                          //     color: AppColors.grey,
                                          //     fontSize: MediaQuery.of(context)
                                          //             .size
                                          //             .width /
                                          //         30,
                                          //   ),
                                          // ),
                                        ),
                                      ),
                                    );
                                  }
                                  List repositories = result.data?['getFilter'];

                                  return SizedBox(
                                    height: mediaWidthSized(context, 8),
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: InkWell(
                                      onTap: () {
                                        if (focusText.hasFocus) {
                                          focusText.unfocus();
                                        }
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchSortByPage(
                                                repositories: repositories,
                                                fromJobfunction: false,
                                              ),
                                            )).then((value) {
                                          setState(() {});
                                        });
                                        // Navigator.push(
                                        //   context,
                                        //   PageRouteBuilder(
                                        //     pageBuilder: (_, __, ___) =>

                                        //     transitionDuration:
                                        //         Duration(seconds: 0),
                                        //   ),
                                        // );
                                      },
                                      splashColor: AppColors.grey,
                                      child: SizedBox(
                                        height: mediaWidthSized(context, 8),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '  map-marker-alt',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'FontAwesomeProRegular',
                                                  fontSize: mediaWidthSized(
                                                      context, 18),
                                                  color:
                                                      provinceselect.isEmpty ||
                                                              provinceselect
                                                                  .join('')
                                                                  .trim()
                                                                  .isEmpty
                                                          ? AppColors.grey
                                                          : AppColors.blue,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  provinceselect.isEmpty ||
                                                          provinceselect
                                                              .join('')
                                                              .trim()
                                                              .isEmpty
                                                      ? '  ${l.location}'
                                                      : '  ${seperateTranslate(provinceselect).join(', ')}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'PoppinsSemiBold',
                                                    color: AppColors.grey,
                                                    fontSize: indexL == 0
                                                        ? mediaWidthSized(
                                                            context, 30)
                                                        : mediaWidthSized(
                                                            context, 27),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '  ',
                                                style: TextStyle(
                                                  fontSize: mediaWidthSized(
                                                      context, 23),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Container(
                            height: mediaWidthSized(context, 14),
                            width: 1,
                            decoration: const BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                        color: AppColors.greyShimmer,
                                        width: 2))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Query(
                      options: QueryOptions(
                          document: gql(QueryInfo().searchjob),
                          variables: {
                            "title": searchtext,
                            "jobFunctionIds": jobIDselect,
                            "provinceIds": provinceIDselect,
                            "page": 1,
                            "perPage": item,
                            "verifyToken": currentToken ?? ""
                          }),
                      builder: (result, {fetchMore, refetch}) {
                        if (result.isLoading) {
                          if (dataJob == null) {
                            return Container();
                          } else {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 20,
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
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: dataJob?.length,
                                                itemBuilder: (context, index) {
                                                  var repository =
                                                      dataJob?[index];
                                                  String jobID =
                                                      repository['_id'];
                                                  List<String> locateList = [];
                                                  debugPrint(repository[
                                                          'workingLocationId']
                                                      .toString());
                                                  repository[
                                                          'workingLocationId']
                                                      .forEach((element) {
                                                    locateList
                                                        .add(element['name']);
                                                  });
                                                  debugPrint(
                                                      repository['jobTag']);
                                                  return StatefulBuilder(
                                                    builder: (context,
                                                        setStateWidget) {
                                                      return WidgetAllJobListView(
                                                        onTapIcon: () {
                                                          setStateWidget(() {
                                                            if (isSavejobList?[
                                                                    index] ==
                                                                true) {
                                                              runMutationUnSave({
                                                                "JobId": jobID
                                                              });
                                                            } else {
                                                              runMutationSave({
                                                                "JobId": jobID
                                                              });
                                                            }

                                                            isSavejobList?[
                                                                    index] =
                                                                !isSavejobList![
                                                                    index]!;
                                                            debugPrint(
                                                                isSavejobList?[
                                                                        index]
                                                                    .toString());
                                                          });
                                                        },
                                                        isSaved: isSavejobList?[
                                                            index],
                                                        jobTag: repository[
                                                            'jobTag'],
                                                        picture:
                                                            repository['logo'],
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
                                                                builder:
                                                                    (context) =>
                                                                        JobDetailPage(
                                                                          jobID:
                                                                              jobID,
                                                                        )),
                                                          ).then((value) {
                                                            try {
                                                              refetch!();
                                                            } catch (e) {
                                                              debugPrint(
                                                                  e.toString());
                                                            }
                                                          });
                                                        },
                                                      );
                                                    },
                                                  );
                                                });
                                          });
                                    }),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  l.loading,
                                  style: TextStyle(
                                    color: true == true
                                        ? AppColors.grey
                                        : AppColors.white,
                                    fontFamily: 'PoppinsRegular',
                                    fontSize: mediaWidthSized(context, 31),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 12,
                                ),
                              ],
                            );
                          }
                        }
                        if (searchtext!.trim().isEmpty &&
                            jobIDselect.isEmpty &&
                            provinceIDselect.isEmpty) {
                          return Container();
                        }
                        if (refek == true) {
                          loadingSearchjob = true;
                          Future.delayed(const Duration(milliseconds: 300))
                              .then((value) {
                            loadingSearchjob = false;
                            setState(() {});
                            try {
                              refetch!();
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                            oneTimeFetch = true;
                            refek = false;
                          });
                        }
                        if (loadingSearchjob == true) {
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
                        dataJob =
                            result.data?['searchJobAllFunctions']['allJob'];
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
                        if (myJobsave == true) {
                          try {
                            refetch!();
                          } catch (e) {
                            debugPrint(e.toString());
                          }

                          myJobsave = false;
                        }
                        // checkSavedIsChange(isSavejobList!, dataJob!, 'isSaved');
                        if (myJobsave) {
                          Future.delayed(const Duration(milliseconds: 750))
                              .then((value) {
                            isSavejobList = [];
                            debugPrint(dataJob?.length.toString());
                            dataJob?.forEach((element) {
                              debugPrint(element.toString());
                              isSavejobList?.add(element['isSaved']);
                            });
                            setState(() {});
                          });

                          myJobsave = false;
                        }
                        if (dataJob!.isEmpty) {
                          return Column(
                            children: [
                              SizedBox(
                                height: mediaWidthSized(context, 5),
                              ),
                              Text(
                                'file',
                                style: TextStyle(
                                  fontFamily: 'FontAwesomeProlight',
                                  fontSize: mediaWidthSized(context, 6),
                                  color: AppColors.greyShimmer,
                                ),
                              ),
                              Text(
                                l.empty,
                                style: TextStyle(
                                  fontFamily: 'PoppinsSemiBold',
                                  fontSize: mediaWidthSized(context, 15),
                                  color: AppColors.greyShimmer,
                                ),
                              )
                            ],
                          );
                        }
                        return Column(
                          children: [
                            const SizedBox(
                              height: 20,
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
                                          debugPrint(
                                              'completed: ' + data.toString());
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
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: dataJob?.length,
                                            itemBuilder: (context, index) {
                                              var repository = dataJob?[index];
                                              String jobID = repository['_id'];
                                              List<String>? locateList = [];
                                              debugPrint(repository[
                                                      'workingLocationId']
                                                  .toString());
                                              repository['workingLocationId']
                                                  .forEach((element) {
                                                locateList.add(element['name']);
                                              });
                                              debugPrint(repository['jobTag']);
                                              return StatefulBuilder(
                                                builder:
                                                    (context, setStateWidget) {
                                                  return WidgetAllJobListView(
                                                    onTapIcon: () {
                                                      setStateWidget(() {
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
                                                        isSavejobList![index],
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
                                                      ).then((value) {
                                                        try {
                                                          refetch!();
                                                        } catch (e) {
                                                          debugPrint(
                                                              e.toString());
                                                        }
                                                      });
                                                    },
                                                  );
                                                },
                                              );
                                            });
                                      });
                                }),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              l.loading,
                              style: TextStyle(
                                color: false == true
                                    ? AppColors.grey
                                    : AppColors.white,
                                fontFamily: 'PoppinsRegular',
                                fontSize: mediaWidthSized(context, 31),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 12,
                            ),
                          ],
                        );
                      },
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

List jobselect = [];
List jobIDselect = [];
List provinceselect = [];
List provinceIDselect = [];

class SearchSortByPage extends StatefulWidget {
  const SearchSortByPage(
      {Key? key, required this.repositories, required this.fromJobfunction})
      : super(key: key);
  final dynamic repositories;
  final bool? fromJobfunction;
  @override
  _SearchSortByPageState createState() => _SearchSortByPageState();
}

class _SearchSortByPageState extends State<SearchSortByPage> {
  // _SearchSortByPageState(this.repositories, this.fromJobfunction);
  late final List? repositories = widget.repositories;
  late final bool fromJobfunction = widget.fromJobfunction ?? false;

  List<bool> selected = [];
  @override
  void dispose() {
    refek = true;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selected = [];
    repositories?.forEach((element) {
      selected.add(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: appbarsize(context) + mediaWidthSized(context, 65),
                width: MediaQuery.of(context).size.width,
                color: AppColors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_back, color: AppColors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    InkWell(
                      onTap: () {
                        refek = true;
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
                visible: fromJobfunction == true
                    ? jobselect.isNotEmpty
                    : provinceselect.isNotEmpty,
                child: HeaderSortbyAndSelect(
                    height: 8,
                    onTap: () {
                      if (fromJobfunction) {
                        jobselect = [];
                        jobIDselect = [];
                      } else {
                        provinceselect = [];
                        provinceIDselect = [];
                      }
                      setState(() {});
                    },
                    title: l.selectedCAP),
              ),
              ListView.builder(
                itemCount: fromJobfunction
                    ? (jobselect.isEmpty ? 0 : jobselect.length)
                    : (provinceselect.isEmpty ? 0 : provinceIDselect.length),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListItemForSearch(
                    height: 8,
                    title: fromJobfunction
                        ? '${jobselect[index]}'
                        : TranslateQuery.translateProvince(
                            provinceselect[index]),
                    onTapIcon: () {
                      if (fromJobfunction) {
                        jobselect.removeAt(index);
                        jobIDselect.removeAt(index);
                      } else {
                        provinceselect.removeAt(index);
                        provinceIDselect.removeAt(index);
                      }
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
                            top:
                                BorderSide(width: 0.3, color: AppColors.grey))),
                    height: mediaWidthSized(context, 8),
                    width: mediaWidthSized(context, 1) - 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          fromJobfunction ? l.jobFunctionCAP : l.locationCAP,
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
                    itemCount: repositories?.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Visibility(
                        visible: fromJobfunction
                            ? !jobselect.contains(repositories?[index]['name'])
                            : !provinceselect
                                .contains(repositories?[index]['name']),
                        child: InkWell(
                          splashColor: AppColors.greyWhite,
                          onTap: () {
                            if (fromJobfunction) {
                              jobselect.add(repositories?[index]['name']);
                              jobIDselect.add(repositories?[index]['_id']);
                            } else {
                              provinceselect.add(repositories?[index]['name']);
                              provinceIDselect.add(repositories?[index]['_id']);
                            }
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
                                    fromJobfunction == false
                                        ? TranslateQuery.translateProvince(
                                            repositories?[index]['name'])
                                        : repositories?[index]['name'],
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
            ],
          ),
        ),
      ),
    );
  }
}
