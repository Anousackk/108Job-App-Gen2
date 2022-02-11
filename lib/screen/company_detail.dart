import 'package:flutter/material.dart';

import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/colors.dart';
import 'package:app/function/calculated.dart';
import 'package:app/function/pluginfunction.dart';
import 'package:app/function/sized.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

import 'Shimmer/companyshimmer.dart';
import 'job_detail_page.dart';
import 'widget/image_network_retry.dart';
import 'widget/job_list_view.dart';

class CompanyDetailPage extends StatefulWidget {
  const CompanyDetailPage(this.companyID, {Key? key}) : super(key: key);
  final String companyID;
  @override
  _CompanyDetailPageState createState() => _CompanyDetailPageState();
}

class _CompanyDetailPageState extends State<CompanyDetailPage> {
  // _CompanyDetailPageState(this.companyID);
  late final String companyID = widget.companyID;
  @override
  void initState() {
    debugPrint(companyID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: gql(QueryInfo().featuredCompanyDetail),
            variables: {"employerId": companyID}),
        builder: (result, {fetchMore, refetch}) {
          //// is loading get data company detail
          if (result.isLoading) {
            return const CompanyPageLoad();
          }
          //// Exception API
          if (result.hasException) {
            debugPrint(result.exception.toString());
            if (result.exception?.linkException?.originalException
                    .toString()
                    .substring(0, 50) ==
                "SocketException: Failed host lookup: '${QueryInfo().baseHost}'") {
              Future.delayed(const Duration(milliseconds: 3000)).then((value) {
                try {
                  refetch!();
                } catch (e) {
                  debugPrint(e.toString());
                }
              });
            }
            return const CompanyPageLoad();
          }
          debugPrint(result.data.toString());

          if (result.data?['findEmployerId']['getemp']['isFeature'] == false) {
            dynamic employerInfo = result.data?['findEmployerId']['getemp'];
            dynamic employerJob = result.data?['findEmployerId']['getJob'];
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      color: AppColors.blue,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      color: AppColors.white,
                    ),
                  ],
                ),
                Scaffold(
                    backgroundColor: AppColors.white,
                    body: SafeArea(
                      child: DefaultTabController(
                        length: 2,
                        child: NestedScrollView(
                          headerSliverBuilder: (context, _) {
                            return [
                              SliverList(
                                  delegate: SliverChildListDelegate([
                                Container(
                                  decoration: const BoxDecoration(
                                      color: AppColors.blue),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      // SizedBox(
                                      //   height: 20,
                                      // ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.arrow_back,
                                                color: AppColors.white),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            50,
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        50),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    8,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    8,
                                                color: AppColors.white,
                                                child: Image(
                                                  image: imageNetworkBuild(
                                                      '${QueryInfo().pictureBase}${employerInfo['logo']}'),
                                                )

                                                //  Image.network(
                                                //     '${QueryInfo().pictureBase}${employerInfo['logo']}'),
                                                ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Container(
                                              // color: Colors.amberAccent,
                                              margin: const EdgeInsets.only(),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '${employerInfo['companyName']}',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'PoppinsSemiBold',
                                                      color: AppColors.white,
                                                      fontSize: mediaWidthSized(
                                                          context, 24.5),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${employerInfo['industry']}',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'PoppinsRegular',
                                                        fontSize:
                                                            mediaWidthSized(
                                                                context, 29.5),
                                                        color: AppColors.white),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      launchURL(employerInfo[
                                                          'website']);
                                                    },
                                                    child: Text(
                                                      employerInfo['website']
                                                                      .length >
                                                                  8 &&
                                                              employerInfo[
                                                                          'website']
                                                                      .substring(
                                                                          0,
                                                                          8) ==
                                                                  'https://'
                                                          ? employerInfo[
                                                                  'website']
                                                              .substring(8)
                                                          : '${employerInfo['website']}',
                                                      style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontFamily:
                                                              'PoppinsRegular',
                                                          fontSize:
                                                              mediaWidthSized(
                                                                  context,
                                                                  29.5),
                                                          color:
                                                              AppColors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ]))
                            ];
                          },
                          body: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: mediaWidthSized(context, 38),
                                ),
                                child: TabBar(
                                  unselectedLabelColor: AppColors.grey,
                                  indicatorColor: AppColors.blue,
                                  labelColor: AppColors.blue,
                                  labelStyle: TextStyle(
                                    fontFamily: 'PoppinsSemiBold',
                                    fontSize: mediaWidthSized(context, 28),
                                  ),
                                  unselectedLabelStyle: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    fontSize: mediaWidthSized(context, 28),
                                  ),
                                  indicatorWeight: 1.5,
                                  tabs: [
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: tabbarheight(context)),
                                        child: const Text(
                                          'About Company',
                                        )),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: tabbarheight(context)),
                                        child: const Text(
                                          'Job Opening',
                                        )),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    AboutCompanyTabView(
                                        employerInfo['aboutCompany']),
                                    OpeningJobTabView(
                                      employerJob,
                                      employerInfo['logo'],
                                      '${employerInfo['companyName']}',
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            );
          }
          var employerInfo = result.data?['findEmployerId']['getemp'];
          var employerJob = result.data?['findEmployerId']['getJob'];
          dynamic album;
          dynamic link;
          try {
            link = employerInfo['isLink'];
          } catch (e) {
            debugPrint(e.toString());
          }
          try {
            album = employerInfo['Gallerys'];
          } catch (e) {
            debugPrint(e.toString());
          }
          debugPrint("this Feature Company");
          return Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    color: AppColors.blue,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    color: AppColors.white,
                  ),
                ],
              ),
              SafeArea(
                child: Scaffold(
                  body: DefaultTabController(
                      length: 4,
                      child: NestedScrollView(
                          headerSliverBuilder: (context, _) {
                            return [
                              SliverList(
                                  delegate: SliverChildListDelegate([
                                Container(
                                  decoration: const BoxDecoration(
                                      color: AppColors.blue),
                                  // height:
                                  //     MediaQuery.of(context).size.height / 7 +
                                  //         65,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      // SizedBox(
                                      //   height: 25,
                                      // ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.arrow_back,
                                                color: AppColors.white),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            50,
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        50),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    8,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    8,
                                                color: AppColors.white,
                                                child: Image(
                                                  image: imageNetworkBuild(
                                                      '${QueryInfo().pictureBase}${employerInfo['logo']}'),
                                                )
                                                //  Image.network(
                                                //     '${QueryInfo().pictureBase}${employerInfo['logo']}'),
                                                ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Container(
                                              // color: Colors.amberAccent,
                                              margin: const EdgeInsets.only(),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '${employerInfo['companyName']}',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'PoppinsSemiBold',
                                                      color: AppColors.white,
                                                      fontSize: mediaWidthSized(
                                                          context, 24.5),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${employerInfo['industry']}',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'PoppinsRegular',
                                                        fontSize:
                                                            mediaWidthSized(
                                                                context, 29.5),
                                                        color: AppColors.white),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      launchURL(employerInfo[
                                                          'website']);
                                                    },
                                                    child: Text(
                                                      employerInfo['website']
                                                                  .substring(
                                                                      0, 8) !=
                                                              'https://'
                                                          ? '${employerInfo['website']}'
                                                          : employerInfo[
                                                                  'website']
                                                              .substring(8),
                                                      style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontFamily:
                                                              'PoppinsRegular',
                                                          fontSize:
                                                              mediaWidthSized(
                                                                  context,
                                                                  29.5),
                                                          color:
                                                              AppColors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ]))
                            ];
                          },
                          body: Column(
                            children: [
                              TabBar(
                                isScrollable: true,
                                unselectedLabelColor: AppColors.grey,
                                indicatorColor: AppColors.blue,
                                labelColor: AppColors.blue,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                labelStyle: TextStyle(
                                  fontFamily: 'PoppinsSemiBold',
                                  fontSize: mediaWidthSized(context, 28),
                                ),
                                unselectedLabelStyle: TextStyle(
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: mediaWidthSized(context, 28),
                                ),
                                indicatorWeight: 1.5,
                                tabs: const [
                                  Text(
                                    'About Company',
                                  ),
                                  Text(
                                    'Job Opening',
                                  ),
                                  Text(
                                    'Gallerys',
                                  ),
                                  Text(
                                    'People',
                                  ),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    AboutCompanyTabView(
                                        employerInfo['aboutCompany']),
                                    OpeningJobTabView(
                                      employerJob,
                                      employerInfo['logo'],
                                      '${employerInfo['companyName']}',
                                    ),
                                    Gallery(
                                      repoPic: album,
                                      repoLink: link,
                                    ),
                                    People(employerInfo['Peoples'])
                                  ],
                                ),
                              )
                            ],
                          ))),
                ),
              ),
            ],
          );
        });
  }
}

class AboutCompanyTabView extends StatefulWidget {
  final String aboutComInfo;

  const AboutCompanyTabView(this.aboutComInfo, {Key? key}) : super(key: key);

  @override
  _AboutCompanyTabViewState createState() => _AboutCompanyTabViewState();
}

class _AboutCompanyTabViewState extends State<AboutCompanyTabView> {
  QueryInfo queryInfo = QueryInfo();
  late String aboutComInfo = widget.aboutComInfo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: HtmlWidget(
              '''
              $aboutComInfo
              ''',
              textStyle: TextStyle(
                fontSize: mediaWidthSized(context, 30),
              ),
              onTapUrl: (url) {
                launchURL(url);
                return false;
              },
            ),
          )
        ],
      ),
    );
  }
}

class OpeningJobTabView extends StatefulWidget {
  final dynamic jobOpen;
  final String logo;
  final String comName;

  const OpeningJobTabView(this.jobOpen, this.logo, this.comName, {Key? key})
      : super(key: key);
  @override
  _OpeningJobTabViewState createState() => _OpeningJobTabViewState();
}

class _OpeningJobTabViewState extends State<OpeningJobTabView> {
  CutDateString convertDate = CutDateString();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.jobOpen.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final repository = widget.jobOpen[index];
              List<String> locateList = ['${repository['workingLocation']}'];

              return WidgetJobListView(
                picture: widget.logo,
                noSaved: true,
                location: locateList,
                position: repository['title'],
                dateStart: convertDate.cutDateString(repository['openingDate']),
                dateEnd: convertDate.cutDateString(repository['closingDate']),
                company: widget.comName,
                onTap: () async {
                  String jobID = repository['jobId'];

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JobDetailPage(
                              jobID: jobID,
                            )),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class People extends StatefulWidget {
  const People(this.people, {Key? key}) : super(key: key);
  final dynamic people;
  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  late final dynamic people = widget.people;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: people.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.3, color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(3))),
                child: Column(
                  children: [
                    SizedBox(
                      height: mediaWidthSized(context, 100),
                    ),
                    Container(
                        margin: const EdgeInsets.all(20),
                        height: mediaWidthSized(context, 1.5),
                        width: mediaWidthSized(context, 1.5),
                        child: Image(
                          image: imageNetworkBuild(
                              "${QueryInfo().pictureBase}${people[index]['img']}"),
                        )
                        //  Image.network(
                        //   "${QueryInfo().pictureBase}${people[index]['img']}",
                        // ),
                        ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Name: ${people[index]['name']}',
                                  style: TextStyle(
                                    fontFamily: 'PoppinsMedium',
                                    color: AppColors.blue,
                                    fontSize: mediaWidthSized(context, 25),
                                  ),
                                ),
                                Text(
                                  '  Position:  ${people[index]['position']}',
                                  style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    fontSize: mediaWidthSized(context, 30),
                                  ),
                                ),
                                Text(
                                  '  Duty:  ${people[index]['duty']}',
                                  style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    fontSize: mediaWidthSized(context, 30),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class Gallery extends StatefulWidget {
  const Gallery({Key? key, this.repoPic, this.repoLink}) : super(key: key);
  final String? repoLink;
  final List? repoPic;

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  // ignore: close_sinks
  YoutubePlayerController? _controller;
  List<String> pictureAddedSource = [];

  String getVideoID(String url) {
    debugPrint(url);
    url = url.replaceAll("https://www.youtube.com/watch?v=", "");
    url = url.replaceAll("https://m.youtube.com/watch?v=", "");
    url = url.replaceAll("https://m.youtu.be/watch?v=", "");
    url = url.replaceAll("https://www.youtube.com/embed/", "");
    return url;
  }

  @override
  void initState() {
    widget.repoPic?.forEach((element) {
      pictureAddedSource.add(QueryInfo().pictureBase + element);
    });
    if (widget.repoLink == null || widget.repoLink == '') {
    } else {
      _controller = YoutubePlayerController(
        initialVideoId: getVideoID(widget.repoLink!),
        params: const YoutubePlayerParams(
          autoPlay: false,
          mute: false,
        ),
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.repoLink == null || widget.repoLink == '') {}
    super.dispose();
  }
// ignore: close_sinks

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Visibility(
              visible: widget.repoLink != null,
              child: YoutubePlayerIFrame(
                controller: _controller,
                aspectRatio: 16 / 9,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: mediaWidthSized(context, 50),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: mediaWidthSized(context, 80),
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.23),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.repoPic?.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  pushPage(context, ViewPhoto(pictureAddedSource, index));
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image(
                      fit: BoxFit.cover,
                      image: imageNetworkBuild(
                        QueryInfo().pictureBase + widget.repoPic?[index],
                      ),
                    )

                    //  Image.network(
                    //   QueryInfo().pictureBase + widget.repoPic[index],
                    //   fit: BoxFit.cover,
                    // ),
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ViewPhoto extends StatefulWidget {
  const ViewPhoto(this.picture, this.index, {Key? key}) : super(key: key);
  final dynamic picture;
  final dynamic index;

  @override
  _ViewPhotoState createState() => _ViewPhotoState();
}

class _ViewPhotoState extends State<ViewPhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.picture[index]),
              initialScale: PhotoViewComputedScale.contained * 0.8,
              // heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
            );
          },
          itemCount: widget.picture.length,
          loadingBuilder: (context, event) => Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
          // backgroundDecoration: widget.backgroundDecoration,
          pageController: PageController(initialPage: widget.index),
          // onPageChanged: onPageChanged,
        ));
  }
}
