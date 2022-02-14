import 'package:app/screen/widget/apploading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:app/api/auth.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/calculated.dart';
import 'package:app/function/pluginfunction.dart';
import 'package:app/function/sized.dart';
import 'package:shimmer/shimmer.dart';

import 'AuthenScreen/account_center.dart';
import 'go_to_signin.dart';
import 'my_resume.dart';
// import 'widget/apploading.dart';
import 'widget/image_network_retry.dart';
import 'widget/old_user.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

bool? reloadprofilePage;
dynamic findseeker;
dynamic registerSeeker;
dynamic cvStatus;
String? beforeToken;
bool? resumeswitch = false;
bool? resumefirst = true;
bool? resumeRead = true;
bool? pastSwitch;
bool? disposing = false;
dynamic data;

class _MyProfilePageState extends State<MyProfilePage> {
  QueryInfo queryInfo = QueryInfo();
  AuthUtil authUtil = AuthUtil();

  @override
  void dispose() {
    if (mounted) {
      disposing = true;
    }
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1300)).then((value) {
      if (disposing == false) {
        setState(() {
          resumeRead = pastSwitch;
        });
      }
    });
    super.initState();
  }

  checkStatusWidget(cvStatus) {
    String status = cvStatus;
    switch (status) {
      case 'Approved':
        return Container(
          height: mediaWidthSized(context, 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              Text(
                'check-circle',
                style: regularIconFreeSizedColor(
                    context: context, color: AppColors.green, mediasSize: 28),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                indexL == 0
                    ? 'Resume has been verified'
                    : 'ຊີວະປະຫວັດຖືກກວດສອບແລ້ວ',
                style: textStyleRegular(
                    color: AppColors.grey, context: context, size: 34),
              )
            ],
          ),
        );

      case 'Pending':
        return Container(
          height: mediaWidthSized(context, 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              Text(
                'sync-alt',
                style: regularIconFreeSizedColor(
                    context: context, color: AppColors.blueSky, mediasSize: 28),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                indexL == 0 ? 'Processing Resume' : 'ກຳລັງກວດສອບຊີວະປະຫວັດ',
                style: textStyleRegular(
                    color: AppColors.grey, context: context, size: 34),
              )
            ],
          ),
        );

      case 'Rejected':
        return Container(
          height: mediaWidthSized(context, 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              Text(
                'times-circle',
                style: regularIconFreeSizedColor(
                    context: context, color: AppColors.yellow, mediasSize: 28),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                indexL == 0 ? 'Resume Rejected' : 'ຊີວະປະຫວັດຖືກປະຕິເສດ',
                style: textStyleRegular(
                    color: AppColors.grey, context: context, size: 34),
              )
            ],
          ),
        );

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(queryInfo.queryMyProfile),
        // fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.hasException) {
          debugPrint(result.exception?.linkException.toString());
          try {
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
              return const Loading(
                internet: true,
              );
            }
          } catch (e) {
            debugPrint(e.toString());
          }
          try {
            if (result.exception?.graphqlErrors[0].message.toString() ==
                'You must be logged in') {
              return const GotoSignInPage();
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        }
        if (result.isLoading) {
          return Container(
            color: AppColors.white,
          );
        } else {
          debugPrint(result.data.toString());

          // if (currentToken == null) {
          //   return const GotoSignInPage();
          // }

          try {
            findseeker = result.data?['findSeeker'];
          } catch (e) {
            debugPrint(e.toString());
          }
          if (findseeker == null) {
            return const OlduserToRegister();
          }

          try {
            cvStatus = result.data?['findSeeker']['status'];
          } catch (e) {
            debugPrint(e.toString());
          }
          debugPrint(cvStatus);
          try {
            registerSeeker = result.data?['findSeeker']['registerSeeker'];
            beforeToken = result.data?['findSeeker']['authId']['_id'];
          } catch (e) {
            debugPrint(e.toString());
          }
          if (registerSeeker == null) {
            String? userID;
            try {
              beforeToken = result.data?['findSeeker']['authId']['_id'];
            } catch (e) {
              debugPrint(e.toString());
            }
            return OlduserToRegister(
              userID: userID!,
            );
          }

          if (reloadprofilePage != null) {
            if (reloadprofilePage == true) {
              reloadprofilePage = false;
              try {
                try {
                  refetch!();
                } catch (e) {
                  debugPrint(e.toString());
                }
              } catch (e) {
                debugPrint(e.toString());
              }
            }
          }

          if (currentToken != null) {
            data = result.data?['findSeeker'];

            pastSwitch = data['resume']['isSearchable'];

            if (resumeRead == true) {
              resumeswitch = data['resume']['isSearchable'];
              resumeRead = false;
            }
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: AppColors.blue,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                    ),
                    Container(
                      color: AppColors.white,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                    )
                  ],
                ),
                SafeArea(
                  child: Scaffold(
                    backgroundColor: AppColors.white,
                    body: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MyResumePage()),
                                )
                                .then((value) {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                              mediaWidthSized(context, 20),
                            ),
                            height: mediaWidthSized(context, 3.25),
                            color: AppColors.blue,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: mediaWidthSized(context, 40),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: mediaWidthSized(context, 5.5),
                                          width: mediaWidthSized(context, 5.5),
                                          child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              child: Image(
                                                // fit: BoxFit.cover,
                                                // width: mediaWidthSized(context, 1.3),
                                                fit: BoxFit.cover,
                                                image: imageNetworkBuild(
                                                  data['registerSeeker']
                                                      ['fileId']['src'],
                                                ),
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Shimmer.fromColors(
                                                    child: Container(
                                                      height: mediaWidthSized(
                                                          context, 5.5),
                                                      width: mediaWidthSized(
                                                          context, 5.5),
                                                      color: AppColors.white,
                                                    ),
                                                    baseColor:
                                                        AppColors.greyWhite,
                                                    highlightColor:
                                                        AppColors.greyShimmer,
                                                  );
                                                },
                                              )
                                              // child: Image.network(
                                              //   data['registerSeeker']['fileId']
                                              //       ['src'],
                                              //   loadingBuilder: (context,
                                              //       child,
                                              //       ImageChunkEvent
                                              //           loadingProgress) {
                                              //     if (loadingProgress == null)
                                              //       return child;
                                              //     return Shimmer.fromColors(
                                              //       child: Container(
                                              //         height: mediaWidthSized(
                                              //             context, 5.5),
                                              //         width: mediaWidthSized(
                                              //             context, 5.5),
                                              //         color: AppColors.white,
                                              //       ),
                                              //       baseColor:
                                              //           AppColors.greyWhite,
                                              //       highlightColor:
                                              //           AppColors.greyShimmer,
                                              //     );
                                              //   },
                                              //   fit: BoxFit.cover,
                                              // ),
                                              ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              '${data['registerSeeker']['firstName']} ${data['registerSeeker']['lastName']}',
                                              style: TextStyle(
                                                  fontFamily: 'PoppinsSemibold',
                                                  fontSize: mediaWidthSized(
                                                      context, 24),
                                                  color: AppColors.white),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              '${CutDateString().cutDateString(data['registerSeeker']['dateOfBirth'])} | ${data['registerSeeker']['maritalStatusId']['name']}',
                                              style: TextStyle(
                                                  fontFamily: 'PoppinsLight',
                                                  fontSize: mediaWidthSized(
                                                      context, 30),
                                                  color: AppColors.white),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              data['resume'][
                                                          'workingExperience'] ==
                                                      null
                                                  ? l.noEXP
                                                  : '${data['resume']['workingExperience']['LatestJobTitle']}',
                                              style: TextStyle(
                                                  fontFamily: 'PoppinsRegular',
                                                  fontSize: mediaWidthSized(
                                                      context, 30),
                                                  color: AppColors.white),
                                            ),
                                            SizedBox(
                                              height:
                                                  mediaWidthSized(context, 80),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    const Text(
                                      'chevron-right',
                                      style: TextStyle(
                                          fontFamily: 'FontAwesomeProRegular',
                                          fontSize: 13,
                                          color: AppColors.white),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          color: AppColors.greyWhite,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [checkStatusWidget(cvStatus)],
                          ),
                        ),

                        Container(
                          // margin:
                          //     EdgeInsets.only(left: 17, right: 17, bottom: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 17),
                          height: mediaWidthSized(context, 5),
                          decoration: const BoxDecoration(
                              // borderRadius:
                              //     BorderRadius.all(Radius.circular(3)),
                              border: Border(
                                  top: BorderSide(
                                    color: AppColors.greyWhite,
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: AppColors.greyWhite,
                                    width: 1,
                                  ))),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 17,
                              ),
                              Mutation(
                                options: MutationOptions(
                                    onCompleted: (data) {
                                      Map result = data;
                                      debugPrint(result.toString());
                                      try {
                                        // refetch!();
                                      } catch (e) {
                                        debugPrint(e.toString());
                                      }
                                    },
                                    onError: (error) {},
                                    document: gql(queryInfo.mutaSearchable)),
                                builder: (runMutation, result) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return CupertinoSwitch(
                                        activeColor: AppColors.blue,
                                        value: resumeswitch!,
                                        onChanged: (value) {
                                          setState(() {});
                                          if (resumeswitch == false) {
                                            resumeswitch = true;
                                          } else {
                                            resumeswitch = false;
                                          }
                                          runMutation({
                                            "resumeId": data['resume']['_id']
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l.searchCV,
                                      style: TextStyle(
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: indexL == 0
                                            ? mediaWidthSized(context, 27)
                                            : mediaWidthSized(context, 25),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        l.makeYourProfileSearch,
                                        style: TextStyle(
                                          fontFamily: 'PoppinsRegular',
                                          fontSize: indexL == 0
                                              ? mediaWidthSized(context, 33)
                                              : mediaWidthSized(context, 30),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        WidgetListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyResumePage()),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          caption: l.myResume,
                        ),

                        WidgetListTile(
                          caption: l.myaccount,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccountCenterPage(
                                        picture: data['registerSeeker']
                                            ['fileId']['src'],
                                        name: data['registerSeeker']
                                            ['firstName'],
                                        surname: data['registerSeeker']
                                            ['lastName'],
                                        email: data['authId']['email'],
                                        number: data['authId']['mobile'],
                                      )),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                        ),
                        // WidgetListTile(
                        //   caption: l.myjob,
                        //   onTap: () {

                        //   },
                        // ),
                        // WidgetListTile(
                        //   caption: l.helpcenter,
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const GotoSignInPage();
          }
        }
      },
    );
  }
}

class WidgetListTile extends StatelessWidget {
  const WidgetListTile({
    Key? key,
    this.onTap,
    this.caption,
  }) : super(key: key);
  final GestureTapCallback? onTap;
  final String? caption;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.greyOpacity,
      child: Container(
        padding: const EdgeInsets.only(
          left: 17,
          right: 17,
        ),
        decoration: const BoxDecoration(
            // borderRadius: BorderRadius.all(Radius.circular(3)),
            border: Border(
                bottom: BorderSide(
          color: AppColors.greyWhite,
          width: 1,
        ))),
        child: SizedBox(
          height: mediaWidthSized(context, 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "$caption",
                  style: TextStyle(
                    fontFamily: 'PoppinsRegular',
                    fontSize: indexL == 0
                        ? mediaWidthSized(context, 27)
                        : mediaWidthSized(context, 25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
