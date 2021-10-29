import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/constant/registerdata.dart';
import 'package:app/function/sized.dart';
import 'package:app/screen/widget/button.dart';
import 'package:app/screen/widget/input_text_field.dart';
import 'package:app/screen/widget/tap_to_input.dart';

// class BlueSafeArea extends StatelessWidget {
//   BlueSafeArea({this.child});
//   final Widget child;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color:  AppColors.blue,
//       child: SafeArea(
//         child: child,
//       ),
//     );
//   }
// }

class InputFullName extends StatefulWidget {
  const InputFullName(this.fromRegister, {Key? key}) : super(key: key);
  final bool fromRegister;
  @override
  _InputFullNameState createState() => _InputFullNameState();
}

class _InputFullNameState extends State<InputFullName> {
  late final bool fromRegister = widget.fromRegister;
  TextEditingController fn = TextEditingController(),
      ln = TextEditingController();
  Register register = Register();

  @override
  void initState() {
    super.initState();
    if (fromRegister) {
      register.getFirstName();
      register.getLastName().then((value) {
        setState(() {
          fn.text = register.firstname ?? '';
          ln.text = register.lastname ?? '';
        });
      });
    } else {
      fn.text = myResume.firstname ?? '';
      ln.text = myResume.lastname ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(
              top: 10, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
          child: BlueButton(
            // marginx2: 0,
            onPressed: () {
              if (fn.text.trim().isNotEmpty && ln.text.trim().isNotEmpty) {
                if (fromRegister) {
                  register.firstname = fn.text;
                  register.lastname = ln.text;
                  register.setFirstName();
                  register.setLastname();
                } else {
                  myResume.firstname = fn.text;
                  myResume.lastname = ln.text;
                }
                Navigator.pop(context);
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        title: Text(
                          l.alert,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'PoppinsSemiBold',
                            fontSize: mediaWidthSized(context, 22),
                          ),
                        ),
                        content: Text(
                          l.correctINfo,
                          style: TextStyle(
                            // color: Colors.red,
                            fontFamily: 'PoppinsMedium',
                            fontSize: mediaWidthSized(context, 28),
                          ),
                        ),
                        actions: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  color: AppColors.white,
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    l.ok,
                                    style: TextStyle(
                                      color: AppColors.blue,
                                      fontFamily: 'PoppinsSemiBold',
                                      fontSize: mediaWidthSized(context, 29),
                                    ),
                                  )))
                        ],
                      );
                    });
              }
            },
            title: l.save,
          ),
        ),
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: AppColors.white,
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              centerTitle: true,
              title: Text(
                l.fullname,
                style: TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    color: Colors.black,
                    fontSize: appbarTextSize(context)),
              ),
              // Text('Recipes',style: TextStyle(),),
              // elevation: 0,
            ),
            preferredSize: Size.fromHeight(appbarsize(context))),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              NormalTextField(
                controller: fn,
                hintIcon: '',
                obscure: false,
                title: l.firstname,
                hintText: l.firstname,
              ),
              const SizedBox(
                height: 10,
              ),
              NormalTextField(
                controller: ln,
                hintIcon: '',
                obscure: false,
                title: l.lastname,
                hintText: l.lastname,
              ),
            ],
          ),
        ));
  }
}

class InputDrivingLicense extends StatefulWidget {
  const InputDrivingLicense(this.formRegister, {Key? key}) : super(key: key);
  final bool formRegister;

  @override
  _InputDrivingLicenseState createState() => _InputDrivingLicenseState();
}

class _InputDrivingLicenseState extends State<InputDrivingLicense> {
  late final bool frommRegister = widget.formRegister;
  List<String> license = [];
  Register register = Register();
  bool onSelectA = false,
      onSelectB = false,
      onSelectC = false,
      onSelectD = false,
      cancel = false;

  @override
  void initState() {
    super.initState();
    if (frommRegister) {
      register.getDrivingLicense().then((value) {
        if (register.drivingLicense != null) {
          register.drivingLicense?.forEach((element) {
            if (element == 'A') {
              onSelectA = true;
            }
            if (element == 'B') {
              onSelectB = true;
            }
            if (element == 'C') {
              onSelectC = true;
            }
            if (element == 'D') {
              onSelectD = true;
            }
          });
        }

        setState(() {});
      });
    } else {
      if (myResume.drivingLicense != null) {
        myResume.drivingLicense?.forEach((element) {
          if (element == 'A') {
            onSelectA = true;
          }
          if (element == 'B') {
            onSelectB = true;
          }
          if (element == 'C') {
            onSelectC = true;
          }
          if (element == 'D') {
            onSelectD = true;
          }
        });
      }

      setState(() {});
    }
  }

  // @override
  // void dispose() {
  //   if (cancel == false) {
  //     licenseEx = pastlicense;
  //   }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: BlueButton(
          onPressed: () {
            if (onSelectA) {
              license.add('A');
            }
            if (onSelectB) {
              license.add('B');
            }
            if (onSelectC) {
              license.add('C');
            }
            if (onSelectD) {
              license.add('D');
            }
            // if (!onSelectA && !onSelectB && !onSelectC && !onSelectD) {
            //   showDialog(
            //       context: context,
            //       builder: (context) {
            //         return AlertDialog(
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(15.0),
            //           ),
            //           title: Text(
            //             l.alert,
            //             textAlign: TextAlign.center,
            //             style: TextStyle(
            //               color: Colors.red,
            //               fontFamily: 'PoppinsSemiBold',
            //               fontSize: mediaWidthSized(context, 22),
            //             ),
            //           ),
            //           content: Text(
            //             l.cannotSaveEmpty,
            //             style: TextStyle(
            //               // color: Colors.red,
            //               fontFamily: 'PoppinsMedium',
            //               fontSize: mediaWidthSized(context, 28),
            //             ),
            //           ),
            //           actions: [
            //             GestureDetector(
            //                 onTap: () {
            //                   Navigator.pop(context);
            //                 },
            //                 child: Container(
            //                     color:  AppColors.white,
            //                     padding: EdgeInsets.all(20),
            //                     child: Text(
            //                       l.ok,
            //                       style: TextStyle(
            //                         color:  AppColors.blue,
            //                         fontFamily: 'PoppinsSemiBold',
            //                         fontSize: mediaWidthSized(context, 29),
            //                       ),
            //                     )))
            //           ],
            //         );
            //       });
            // } else {
            if (frommRegister) {
              register.drivingLicense = license;
              register.setDrivingLicense();
            } else {
              myResume.drivingLicense = license;
            }

            Navigator.pop(context);
            // }
          },
          title: l.save,
        ),
      ),
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: AppColors.white,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            centerTitle: true,
            title: Text(
              l.drivinglic,
              style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  color: Colors.black,
                  fontSize: appbarTextSize(context)),
            ),
            // Text('Recipes',style: TextStyle(),),
            // elevation: 0,
          ),
          preferredSize: Size.fromHeight(appbarsize(context))),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListBody(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l.selectLicense,
                      style: TextStyle(
                        fontFamily: 'PoppinsMedium',
                        fontSize: mediaWidthSized(context, 25),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                TabLicense(
                  border: const Border(
                      top: BorderSide(color: AppColors.grey, width: 0.5),
                      bottom: BorderSide(color: AppColors.grey, width: 0.5)),
                  licenseType: 'A',
                  select: onSelectA,
                  onTap: () {
                    setState(() {
                      if (onSelectA == false) {
                        onSelectA = true;
                      } else {
                        onSelectA = false;
                      }
                    });
                  },
                ),
                TabLicense(
                  border: const Border(
                      bottom: BorderSide(color: AppColors.grey, width: 0.5)),
                  licenseType: 'B',
                  select: onSelectB,
                  onTap: () {
                    setState(() {
                      if (onSelectB == false) {
                        onSelectB = true;
                      } else {
                        onSelectB = false;
                      }
                    });
                  },
                ),
                TabLicense(
                  border: const Border(
                      bottom: BorderSide(color: AppColors.grey, width: 0.5)),
                  licenseType: 'C',
                  select: onSelectC,
                  onTap: () {
                    setState(() {
                      if (onSelectC == false) {
                        onSelectC = true;
                      } else {
                        onSelectC = false;
                      }
                    });
                  },
                ),
                TabLicense(
                  border: const Border(
                      bottom: BorderSide(color: AppColors.grey, width: 0.5)),
                  licenseType: 'D',
                  select: onSelectD,
                  onTap: () {
                    setState(() {
                      if (onSelectD == false) {
                        onSelectD = true;
                      } else {
                        onSelectD = false;
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}

class TabLicense extends StatelessWidget {
  const TabLicense(
      {Key? key, this.licenseType, this.select, this.onTap, this.border})
      : super(key: key);
  final String? licenseType;
  final bool? select;
  final GestureTapCallback? onTap;
  final BoxBorder? border;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.greyShimmer,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
              // color: Colors.red,
              border: border),
          height: mediaWidthSized(context, 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "$licenseType",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'PoppinsSemiBold',
                    fontSize: mediaWidthSized(context, 25),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Visibility(
                    visible: select ?? false,
                    child: Text(
                      'check',
                      style: TextStyle(
                          color: AppColors.blue,
                          fontSize: mediaWidthSized(context, 25),
                          fontFamily: 'FontAwesomeProRegular'),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class InputProvinceState extends StatefulWidget {
  const InputProvinceState(this.result, this.fromRegister, {Key? key})
      : super(key: key);
  final dynamic result;
  final bool? fromRegister;
  @override
  _InputProvinceStateState createState() => _InputProvinceStateState();
}

class _InputProvinceStateState extends State<InputProvinceState> {
  Register register = Register();

  late final bool? fromRegister = widget.fromRegister ?? false;
  late final dynamic result = widget.result;
  dynamic tocheck;
  // Register register = Register();
  @override
  void initState() {
    super.initState();
    if (fromRegister!) {
      register.getProvinceOrState();
      register
          .getProvinceOrStateID()
          .then((value) => tocheck = register.provinceOrState);
    } else {
      tocheck = register.provinceOrState;
    }
  }

  @override
  Widget build(BuildContext context) {
    List repositories = result?.data['getProvinces'];
    // QueryInfo queryInfo = QueryInfo();
    return Scaffold(
      backgroundColor: AppColors.white,
      // bottomNavigationBar: Container(
      //   margin: EdgeInsets.only(top: 10, bottom: 20),
      //   child: BlueButton(
      //
      //     onPressed: () {},
      //     title: 'Save',
      //   ),
      // ),
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: AppColors.white,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            centerTitle: true,
            title: Text(
              l.province,
              style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  color: Colors.black,
                  fontSize: appbarTextSize(context)),
            ),

            // Text('Recipes',style: TextStyle(),),
            // elevation: 0,
          ),
          preferredSize: Size.fromHeight(appbarsize(context))),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: repositories.length,
              itemBuilder: (context, index) {
                final repository = repositories[index];
                // List<String> locateList = [];
                // repository['workingLocationId'].forEach((element) {
                //   locateList.add(element['name']);
                // });

                return TaptoInput(
                  title:
                      '${TranslateQuery.translateProvince(repository['name'])}',
                  color: AppColors.white,
                  onTap: () {
                    if (fromRegister!) {
                      register.districtRepoindex = index;
                      register.provinceOrState = repository['name'];
                      register.provinceOrStateID = repository['_id'];
                      register.setDistrictRepoindex();
                      register.setProvinceOrState();
                      register.setprovinceOrStateID();
                      if (register.provinceOrState != tocheck) {
                        register.districtOrCity = null;
                        register.districtOrCityID = null;
                        register.setDistrictOrCity();
                        register.setDistrictOrCityID();
                      }
                    } else {
                      myResume.districtRepoindex = index;
                      myResume.provinceOrState = repository['name'];
                      myResume.provinceOrStateID = repository['_id'];
                      if (myResume.provinceOrState != tocheck) {
                        myResume.districtOrCity = null;
                        myResume.districtOrCityID = null;
                      }
                    }

                    Navigator.pop(context);
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

class InputDistrictCity extends StatefulWidget {
  const InputDistrictCity(this.repoDistrict, this.fromRegister, {Key? key})
      : super(key: key);
  final dynamic repoDistrict;
  final bool? fromRegister;
  @override
  _InputDistrictCityState createState() => _InputDistrictCityState();
}

class _InputDistrictCityState extends State<InputDistrictCity> {
  Register register = Register();
  // _InputDistrictCityState(this.repodistrict, this.fromRegister);
  late final dynamic repodistrict = widget.repoDistrict;
  late final bool fromRegister = widget.fromRegister ?? false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        // bottomNavigationBar: Container(
        //   margin: EdgeInsets.only(
        //       top: 10, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
        //   child: BlueButton(
        //
        //     onPressed: () {},
        //     title: 'Save',
        //   ),
        // ),
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: AppColors.white,
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              centerTitle: true,
              title: Text(
                l.district,
                style: TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    color: Colors.black,
                    fontSize: appbarTextSize(context)),
              ),
              // Text('Recipes',style: TextStyle(),),
              // elevation: 0,
            ),
            preferredSize: Size.fromHeight(appbarsize(context))),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: repodistrict['districts'].length,
            itemBuilder: (context, index) {
              final repository = repodistrict['districts'][index];
              // List<String> locateList = [];
              // repository['workingLocationId'].forEach((element) {
              //   locateList.add(element['name']);
              // });

              return TaptoInput(
                title: '${repository['name']}',
                color: AppColors.white,
                onTap: () {
                  if (fromRegister) {
                    register.districtOrCity = repository['name'];
                    register.districtOrCityID = repository['_id'];
                    register.setDistrictOrCity();
                    register.setDistrictOrCityID();
                  } else {
                    myResume.districtOrCity = repository['name'];
                    myResume.districtOrCityID = repository['_id'];
                  }
                  Navigator.pop(context);
                },
              );
            },
          ),
        ])));
  }
}

class InputPrfSummary extends StatefulWidget {
  const InputPrfSummary(this.fromRegister, {Key? key}) : super(key: key);
  final bool? fromRegister;
  @override
  _InputPrfSummaryState createState() => _InputPrfSummaryState();
}

class _InputPrfSummaryState extends State<InputPrfSummary> {
  // _InputPrfSummaryState(this.fromRegister);
  late final bool fromRegister = widget.fromRegister ?? false;
  Register register = Register();
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (fromRegister) {
      register.getProfSummary().then((value) {
        setState(() {
          controller.text = register.profSummary ?? '';
        });
      });
    } else {
      controller.text = myResume.profSummary ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
            top: 10, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
        child: BlueButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              if (fromRegister) {
                register.profSummary = controller.text;
                register.setProfSummary();
              } else {
                myResume.profSummary = controller.text;
              }
              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    title: Text(
                      l.alert,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: mediaWidthSized(context, 22),
                      ),
                    ),
                    content: Text(
                      l.correctINfo,
                      style: TextStyle(
                        // color: Colors.red,
                        fontFamily: 'PoppinsMedium',
                        fontSize: mediaWidthSized(context, 28),
                      ),
                    ),
                    actions: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                l.ok,
                                style: TextStyle(
                                  color: AppColors.blue,
                                  fontFamily: 'PoppinsSemiBold',
                                  fontSize: mediaWidthSized(context, 29),
                                ),
                              )))
                    ],
                  );
                },
              );
            }
          },
          title: l.save,
        ),
      ),
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: AppColors.white,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            centerTitle: true,
            title: Text(
              l.profesSum,
              style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  color: Colors.black,
                  fontSize: appbarTextSize(context)),
            ),
            // Text('Recipes',style: TextStyle(),),
            // elevation: 0,
          ),
          preferredSize: Size.fromHeight(appbarsize(context))),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                l.tellusAboutU,
                style: TextStyle(
                  fontFamily: 'PoppinsMedium',
                  fontSize: mediaWidthSized(context, 25),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                  controller: controller,
                  style: TextStyle(
                    fontFamily: 'PoppinsRegular',
                    fontSize: mediaWidthSized(context, 28),
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 4,
                  maxLines: 10,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: AppColors.greyWhite,
                      filled: true,
                      hintStyle: TextStyle(
                        fontFamily: 'PoppinsRegular',
                        fontSize: mediaWidthSized(context, 28),
                      ),
                      hintText: l.prosumDetail)),
            ),
          ],
        ),
      ),
    );
  }
}

///
///
///
///
///
/// Working Experience
///
///
///
///
///

class InputLatestJobTitle extends StatefulWidget {
  const InputLatestJobTitle(this.fromRegister, {Key? key}) : super(key: key);
  final bool? fromRegister;
  @override
  _InputLatestJobTitleState createState() => _InputLatestJobTitleState();
}

class _InputLatestJobTitleState extends State<InputLatestJobTitle> {
  late final bool fromRegister = widget.fromRegister ?? false;
  Register register = Register();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (fromRegister) {
      register.getLatestJobTitle().then((value) {
        setState(() {
          controller.text = register.latestJobTitle ?? '';
        });
      });
    } else {
      controller.text = myResume.latestJobTitle ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: AppColors.white,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            centerTitle: true,
            title: Text(
              l.latestjob,
              style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  color: Colors.black,
                  fontSize: appbarTextSize(context)),
            ),
            // Text('Recipes',style: TextStyle(),),
            // elevation: 0,
          ),
          preferredSize: Size.fromHeight(appbarsize(context))),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
            top: 10, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
        child: BlueButton(
          onPressed: () {
            if (controller.text.trim().isEmpty) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      title: Text(
                        l.alert,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: mediaWidthSized(context, 22),
                        ),
                      ),
                      content: Text(
                        l.correctINfo,
                        style: TextStyle(
                          // color: Colors.red,
                          fontFamily: 'PoppinsMedium',
                          fontSize: mediaWidthSized(context, 28),
                        ),
                      ),
                      actions: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                color: AppColors.white,
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  l.ok,
                                  style: TextStyle(
                                    color: AppColors.blue,
                                    fontFamily: 'PoppinsSemiBold',
                                    fontSize: mediaWidthSized(context, 29),
                                  ),
                                )))
                      ],
                    );
                  });
            } else {
              if (fromRegister) {
                register.latestJobTitle = controller.text;
                register.setLatestJobTitle();
              } else {
                myResume.latestJobTitle = controller.text;
              }

              Navigator.pop(context);
            }
          },
          title: l.save,
        ),
      ),
      body: SingleChildScrollView(
        child: ListBody(
          children: [
            const SizedBox(
              height: 30,
            ),
            NormalTextField(
              controller: controller,
              autofocus: true,
              title: l.latestjob,
              hintText: l.latestjob,
              obscure: false,
              hintIcon: '',
            )
          ],
        ),
      ),
    );
  }
}

class InputSalaryRange extends StatefulWidget {
  const InputSalaryRange(this.repository, this.fromRegister, {Key? key})
      : super(key: key);
  final dynamic repository;
  final bool? fromRegister;
  @override
  _InputSalaryRangeState createState() => _InputSalaryRangeState();
}

class _InputSalaryRangeState extends State<InputSalaryRange> {
  // _InputSalaryRangeState(this.repository, this.fromRegister);
  Register register = Register();
  late final dynamic repository = widget.repository;
  late final bool fromRegister = widget.fromRegister ?? false;
  String? salaryID;
  String? salary;
  Future addNameInDropdown() async {
    repository.forEach((element) {
      // getDegreeID.add(element['_id']);
      toList.add(DropdownMenuItem(
        value: '${element['name']}',
        child: Text(
          '${element['name']}',
          style: const TextStyle(
              fontSize: 17, fontFamily: 'PoppinsRegular', color: Colors.black),
        ),
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    if (fromRegister) {
      addNameInDropdown().then((value) {
        register.getSalary();
        register.getSalaryID().then((value) {
          salary = register.salary;
          salaryID = register.salaryID;
          setState(() {});
        });
      });
    } else {
      addNameInDropdown().then((value) {
        salary = myResume.salary;
        salaryID = myResume.salaryID;
        setState(() {});
      });
    }
  }

  List<DropdownMenuItem<String>> toList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
            top: 10, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
        child: BlueButton(
          onPressed: () {
            if (salary != null && salaryID != null) {
              if (fromRegister) {
                register.salary = salary;
                register.salaryID = salaryID;
                register.setSalary();
                register.setSalaryID();
              } else {
                myResume.salaryID = salaryID;
                myResume.salary = salary;
              }

              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    title: Text(
                      l.alert,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: mediaWidthSized(context, 22),
                      ),
                    ),
                    content: Text(
                      l.correctINfo,
                      style: TextStyle(
                        // color: Colors.red,
                        fontFamily: 'PoppinsMedium',
                        fontSize: mediaWidthSized(context, 28),
                      ),
                    ),
                    actions: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                l.ok,
                                style: TextStyle(
                                  color: AppColors.blue,
                                  fontFamily: 'PoppinsSemiBold',
                                  fontSize: mediaWidthSized(context, 29),
                                ),
                              )))
                    ],
                  );
                },
              );
            }
          },
          title: l.save,
        ),
      ),
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: AppColors.white,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            centerTitle: true,
            title: Text(
              l.salaryRange,
              style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  color: Colors.black,
                  fontSize: appbarTextSize(context)),
            ),
            // Text('Recipes',style: TextStyle(),),
            // elevation: 0,
          ),
          preferredSize: Size.fromHeight(appbarsize(context))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    l.salaryRange,
                    style: TextStyle(
                        fontFamily: 'PoppinsRegular',
                        fontSize: mediaWidthSized(context, 28)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SingleDropdown(
              width: 0,
              dropdownHint: l.selectsalary,
              icon: '',
              dropdownItems: toList,
              dropdownValue: salary,
              color: AppColors.grey,
              dropdownOnchanged: (value) {
                setState(() {
                  salary = value;
                  repository.forEach((element) {
                    if (element['name'] == value) {
                      salaryID = element['_id'];
                    }
                  });
                });
              },
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}

class InputPreviousJob extends StatefulWidget {
  const InputPreviousJob(this.fromRegister, {Key? key}) : super(key: key);
  final bool? fromRegister;
  @override
  _InputPreviousJobState createState() => _InputPreviousJobState();
}

class _InputPreviousJobState extends State<InputPreviousJob> {
  // _InputPreviousJobState(this.fromRegister);
  late final bool fromRegister = widget.fromRegister ?? false;
  Register register = Register();

  // Widget textfield = OnlyTextField();
  // TextEditingController controller = TextEditingController();
  // List<Widget> listTextField = [];
  // int listIndex;
  List<TextEditingController> listController = [];
  @override
  void initState() {
    super.initState();
    if (fromRegister) {
      register.getPreviousJobTitle().then((value) {
        int i = 0;

        try {
          register.previousJobTitle?.forEach((element) {
            addTextField();
            listController[i].text = element;
            i = i + 1;
          });
        } catch (e) {
          debugPrint(e.toString());
        }

        if (listController.isEmpty) {
          addTextField();
        }
        setState(() {});
      });
    } else {
      int i = 0;
      try {
        myResume.previousJobTitle?.forEach((element) {
          addTextField();
          listController[i].text = element;
          i = i + 1;
        });
        if (myResume.previousJobTitle!.isEmpty) {
          addTextField();
        }
        setState(() {});
      } catch (e) {
        setState(() {});
      }
    }
  }

  addTextField() {
    listController.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
            top: 10, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
        child: BlueButton(
          onPressed: () {
            bool showdia = false;

            for (var element in listController) {
              if (element.text.trim().isEmpty) {
                showdia = true;
              }
            }
            if (showdia) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      title: Text(
                        l.alert,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: mediaWidthSized(context, 22),
                        ),
                      ),
                      content: Text(
                        l.correctINfo,
                        style: TextStyle(
                          // color: Colors.red,
                          fontFamily: 'PoppinsMedium',
                          fontSize: mediaWidthSized(context, 28),
                        ),
                      ),
                      actions: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                color: AppColors.white,
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  l.ok,
                                  style: TextStyle(
                                    color: AppColors.blue,
                                    fontFamily: 'PoppinsSemiBold',
                                    fontSize: mediaWidthSized(context, 29),
                                  ),
                                )))
                      ],
                    );
                  });
            } else {
              if (fromRegister) {
                register.previousJobTitle = [];
                for (var element in listController) {
                  register.previousJobTitle?.add(element.text);
                }
                register.setPreviousJobTitle();
              } else {
                myResume.previousJobTitle = [];
                for (var element in listController) {
                  myResume.previousJobTitle?.add(element.text);
                }
              }
              Navigator.pop(context);
            }
          },
          title: l.save,
        ),
      ),
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: AppColors.white,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            centerTitle: true,
            title: Text(
              l.previousJobTitle,
              style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  color: Colors.black,
                  fontSize: appbarTextSize(context)),
            ),
            // Text('Recipes',style: TextStyle(),),
            // elevation: 0,
          ),
          preferredSize: Size.fromHeight(appbarsize(context))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    l.previousJobTitle,
                    style: TextStyle(
                        fontFamily: 'PoppinsRegular',
                        fontSize: mediaWidthSized(context, 28)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: listController.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: OnlyTextField(
                    obscure: false,
                    autofocus: true,
                    hintIcon: 'trash',
                    color: listController.length > 1
                        ? AppColors.yellow
                        : AppColors.grey,
                    controller: listController[index],
                    hintText: l.previousJobTitle,
                    onTap: listController.length > 1
                        ? () {
                            setState(() {
                              listController.removeAt(index);
                            });
                          }
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    addTextField();
                  });
                },
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: AppColors.white,
                    child: Row(
                      children: [
                        const Text(
                          'plus-circle',
                          style: TextStyle(
                              color: AppColors.blue,
                              fontFamily: 'FontAwesomeProRegular',
                              fontSize: 15),
                        ),
                        Text(
                          l.addjobtitle,
                          style: const TextStyle(
                              color: AppColors.blue,
                              fontFamily: 'PoppinsRegular',
                              fontSize: 15),
                        ),
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}

class InputPreviousEMP extends StatefulWidget {
  const InputPreviousEMP(this.fromRegister, {Key? key}) : super(key: key);
  final bool? fromRegister;
  @override
  _InputPreviousEMPState createState() => _InputPreviousEMPState();
}

class _InputPreviousEMPState extends State<InputPreviousEMP> {
  // _InputPreviousEMPState(this.fromRegister);
  late final bool fromRegister = widget.fromRegister ?? false;
  List<TextEditingController> listController = [];
  Register register = Register();

  @override
  void initState() {
    super.initState();
    if (fromRegister) {
      register.getPreviousEmployer().then((value) {
        int i = 0;

        try {
          register.previousEmployer?.forEach((element) {
            addTextField();
            listController[i].text = element;
            i = i + 1;
          });
        } catch (e) {
          debugPrint(e.toString());
        }

        if (listController.isEmpty) {
          addTextField();
        }
        setState(() {});
      });
    } else {
      int i = 0;
      try {
        myResume.previousEmployer?.forEach((element) {
          addTextField();
          listController[i].text = element;
          i = i + 1;
        });
        if (myResume.previousEmployer!.isEmpty) {
          addTextField();
        }
        setState(() {});
      } catch (e) {
        setState(() {});
      }
    }
  }

  addTextField() {
    listController.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
            top: 10, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
        child: BlueButton(
          onPressed: () {
            bool showdia = false;

            for (var element in listController) {
              if (element.text.trim().isEmpty) {
                showdia = true;
              }
            }
            if (showdia) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      title: Text(
                        l.alert,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: mediaWidthSized(context, 22),
                        ),
                      ),
                      content: Text(
                        l.correctINfo,
                        style: TextStyle(
                          // color: Colors.red,
                          fontFamily: 'PoppinsMedium',
                          fontSize: mediaWidthSized(context, 28),
                        ),
                      ),
                      actions: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                color: AppColors.white,
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  l.ok,
                                  style: TextStyle(
                                    color: AppColors.blue,
                                    fontFamily: 'PoppinsSemiBold',
                                    fontSize: mediaWidthSized(context, 29),
                                  ),
                                )))
                      ],
                    );
                  });
            } else {
              if (fromRegister) {
                register.previousEmployer = [];
                for (var element in listController) {
                  register.previousEmployer?.add(element.text);
                }
                register.setPreviousEmployer();
              } else {
                myResume.previousEmployer = [];
                for (var element in listController) {
                  myResume.previousEmployer?.add(element.text);
                }
              }
              Navigator.pop(context);
            }
          },
          title: l.save,
        ),
      ),
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: AppColors.white,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            centerTitle: true,
            title: Text(
              l.previousEmployer,
              style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  color: Colors.black,
                  fontSize: appbarTextSize(context)),
            ),
            // Text('Recipes',style: TextStyle(),),
            // elevation: 0,
          ),
          preferredSize: Size.fromHeight(appbarsize(context))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    l.previousEmployer,
                    style: TextStyle(
                        fontFamily: 'PoppinsRegular',
                        fontSize: mediaWidthSized(context, 28)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: listController.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: OnlyTextField(
                    obscure: false,
                    autofocus: true,
                    hintIcon: 'trash',
                    color: listController.length > 1
                        ? AppColors.yellow
                        : AppColors.grey,
                    controller: listController[index],
                    hintText: l.previousEmployer,
                    onTap: listController.length > 1
                        ? () {
                            setState(() {
                              listController.removeAt(index);
                            });
                          }
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    addTextField();
                  });
                },
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: AppColors.white,
                    child: Row(
                      children: [
                        const Text(
                          'plus-circle',
                          style: TextStyle(
                              color: AppColors.blue,
                              fontFamily: 'FontAwesomeProRegular',
                              fontSize: 15),
                        ),
                        Text(
                          l.addemployer,
                          style: const TextStyle(
                              color: AppColors.blue,
                              fontFamily: 'PoppinsRegular',
                              fontSize: 15),
                        ),
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}

class InputPreEmpIndustry extends StatefulWidget {
  const InputPreEmpIndustry(this.repositories, this.fromRegister, {Key? key})
      : super(key: key);
  final List repositories;
  final bool? fromRegister;
  @override
  _InputPreEmpIndustryState createState() => _InputPreEmpIndustryState();
}

class _InputPreEmpIndustryState extends State<InputPreEmpIndustry> {
  // _InputPreEmpIndustryState(this.repositories, this.fromRegister);

  late final List repositories = widget.repositories;
  late final bool fromRegister = widget.fromRegister ?? false;

  List<String?>? listindusID = [];
  List<String?>? listselectedfield = [];
  List<DropdownMenuItem<String>>? toList = [];
  Register register = Register();
  Future addNameInDropdown() async {
    for (var element in repositories) {
      // getDegreeID.add(element['_id']);
      toList?.add(DropdownMenuItem(
        value: '${element['name']}',
        child: Text(
          '${element['name']}',
          style: const TextStyle(
              fontSize: 17, fontFamily: 'PoppinsRegular', color: Colors.black),
        ),
      ));
    }
  }

  isNotEmpty() {
    bool check = true;

    listindusID?.forEach((element) {
      if (element == null) {
        check = false;
      }
    });
    return check;
  }

  addingDropdown() {
    listindusID?.add(null);
    listselectedfield?.add(null);
  }

  @override
  void initState() {
    super.initState();
    if (fromRegister) {
      addNameInDropdown().then((value) {
        register.getPreviousIndID();
        register.getPreviousIndustry().then((value) {
          if (register.previousIndustry != null) {
            int i = 0;
            register.previousIndustry?.forEach((element) {
              addingDropdown();
              listselectedfield![i] = element;
              listindusID![i] = register.previousIndID![i];
              i = i + 1;
            });
            setState(() {});
          } else {
            addingDropdown();
            setState(() {});
          }
        });
        setState(() {});
      });
    } else {
      addNameInDropdown().then((value) {
        try {
          int i = 0;
          myResume.previousIndustry?.forEach((element) {
            addingDropdown();
            listselectedfield?[i] = element;
            listindusID?[i] = myResume.previousIndID?[i];
            i = i + 1;
          });
          if (myResume.previousIndustry!.isEmpty) {
            addingDropdown();
          }
          setState(() {});
        } catch (e) {
          setState(() {});
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
            top: 10, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
        child: BlueButton(
          onPressed: () {
            if (isNotEmpty()) {
              if (fromRegister) {
                register.previousIndID = listindusID;
                register.previousIndustry = listselectedfield;
                register.setPreviousIndustry();
                register.setPreviousIndID();
              } else {
                myResume.previousIndID = listindusID;
                myResume.previousIndustry = listselectedfield;
              }

              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    title: Text(
                      l.alert,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: mediaWidthSized(context, 22),
                      ),
                    ),
                    content: Text(
                      l.correctINfo,
                      style: TextStyle(
                        // color: Colors.red,
                        fontFamily: 'PoppinsMedium',
                        fontSize: mediaWidthSized(context, 28),
                      ),
                    ),
                    actions: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                l.ok,
                                style: TextStyle(
                                  color: AppColors.blue,
                                  fontFamily: 'PoppinsSemiBold',
                                  fontSize: mediaWidthSized(context, 29),
                                ),
                              )))
                    ],
                  );
                },
              );
            }
          },
          title: l.save,
        ),
      ),
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: AppColors.white,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            centerTitle: true,
            title: Text(
              l.previousIndustry,
              style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  color: Colors.black,
                  fontSize: appbarTextSize(context)),
            ),
            // Text('Recipes',style: TextStyle(),),
            // elevation: 0,
          ),
          preferredSize: Size.fromHeight(appbarsize(context))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    l.previousIndustry,
                    style: TextStyle(
                        fontFamily: 'PoppinsRegular',
                        fontSize: mediaWidthSized(context, 28)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: listselectedfield?.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SingleDropdown(
                      onTap: listselectedfield!.length > 1
                          ? () {
                              setState(() {
                                listselectedfield?.removeAt(index);
                                listindusID?.removeAt(index);
                              });
                            }
                          : null,
                      dropdownHint: l.selectindus,
                      dropdownValue: listselectedfield?[index],
                      dropdownItems: toList,
                      icon: 'trash',
                      color: listselectedfield!.length > 1
                          ? AppColors.yellow
                          : AppColors.grey,
                      dropdownOnchanged: (value) {
                        setState(() {
                          listselectedfield?[index] = value;
                          for (var element in repositories) {
                            if (element['name'] == value) {
                              listindusID?[index] = element['_id'];
                            }
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    addingDropdown();
                  });
                },
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: AppColors.white,
                    child: Row(
                      children: [
                        const Text(
                          'plus-circle',
                          style: TextStyle(
                              color: AppColors.blue,
                              fontFamily: 'FontAwesomeProRegular',
                              fontSize: 15),
                        ),
                        Text(
                          l.addindustry,
                          style: const TextStyle(
                              color: AppColors.blue,
                              fontFamily: 'PoppinsRegular',
                              fontSize: 15),
                        ),
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}

class InputTotalWorkEXP extends StatefulWidget {
  const InputTotalWorkEXP(this.fromRegister, {Key? key}) : super(key: key);
  final bool? fromRegister;
  @override
  _InputTotalWorkEXPState createState() => _InputTotalWorkEXPState();
}

class _InputTotalWorkEXPState extends State<InputTotalWorkEXP> {
  // _InputTotalWorkEXPState(this.fromRegister);
  late final bool fromRegister = widget.fromRegister ?? false;
  Register register = Register();
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (fromRegister) {
      register.getTotalWorkEXP().then((value) {
        controller.text = register.totalWorkEXP ?? '';
        setState(() {});
      });
    } else {
      controller.text = myResume.totalWorkEXP ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: AppColors.white,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            centerTitle: true,
            title: Text(
              l.totalWorkingExperience,
              style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  color: Colors.black,
                  fontSize: appbarTextSize(context)),
            ),
            // Text('Recipes',style: TextStyle(),),
            // elevation: 0,
          ),
          preferredSize: Size.fromHeight(appbarsize(context))),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
            top: 10, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
        child: BlueButton(
          onPressed: () {
            if (controller.text.trim().isEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    title: Text(
                      l.alert,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: mediaWidthSized(context, 22),
                      ),
                    ),
                    content: Text(
                      l.correctINfo,
                      style: TextStyle(
                        // color: Colors.red,
                        fontFamily: 'PoppinsMedium',
                        fontSize: mediaWidthSized(context, 28),
                      ),
                    ),
                    actions: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                l.ok,
                                style: TextStyle(
                                  color: AppColors.blue,
                                  fontFamily: 'PoppinsSemiBold',
                                  fontSize: mediaWidthSized(context, 29),
                                ),
                              )))
                    ],
                  );
                },
              );
            } else {
              if (fromRegister) {
                register.totalWorkEXP = controller.text;
                register.setTotalWorkEXP();
              } else {
                myResume.totalWorkEXP = controller.text;
              }
              Navigator.pop(context);
            }
          },
          title: l.save,
        ),
      ),
      body: SingleChildScrollView(
        child: ListBody(
          children: [
            const SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    l.totalWorkingExperience,
                    style: TextStyle(
                        fontFamily: 'PoppinsRegular',
                        fontSize: mediaWidthSized(context, 28)),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      SizedBox(
                        height: mediaWidthSized(context, 10),
                        child: TextField(
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            controller: controller,
                            obscureText: false,
                            style: const TextStyle(
                              fontFamily: 'PoppinsRegular',
                              color: Colors.black,
                              fontSize: 17,
                              // color:  AppColors.blueSky
                            ),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(5.0)),
                                filled: true,
                                fillColor: AppColors.greyWhite,
                                labelStyle: const TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    color: Colors.black),
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, top: 4, right: 45),
                                focusColor: AppColors.blue,
                                hintStyle: const TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'PoppinsRegular',
                                    color: AppColors.greyOpacity),
                                hintText: l.totalWorkingExperience)),
                      ),
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(
                              right: mediaWidthSized(context, 30)),
                          width: mediaWidthSized(context, 9),
                          height: (mediaWidthSized(context, 10)) - 10,
                          color: AppColors.greyWhite,
                          child: const Text(
                            '',
                            style: TextStyle(
                                fontSize: 17,
                                color: AppColors.greyOpacity,
                                fontFamily: 'FontAwesomeProSolid'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

///
///
///
///
///
/// Education
///
///
///
///
///

class InputFieldStudy extends StatefulWidget {
  const InputFieldStudy(this.repositories, this.fromRegister, {Key? key})
      : super(key: key);
  final dynamic repositories;
  final bool? fromRegister;
  @override
  _InputFieldStudyState createState() => _InputFieldStudyState();
}

class _InputFieldStudyState extends State<InputFieldStudy> {
  // _InputFieldStudyState(this.repositories, this.fromRegister);
  late final List repositories = widget.repositories;
  late final bool fromRegister = widget.fromRegister ?? false;

  Register register = Register();
  List<String?>? listselectedfield = [];
  List<TextEditingController>? listcontroller = [];
  // List<String> getDegreeID = [];
  List<String?>? listDegreeID = [];
  List<DropdownMenuItem<String>>? toList = [];
  List<String?>? listNameInDropdown = [];
  addingTextField() {
    listcontroller?.add(TextEditingController());
    listDegreeID?.add(null);
    listselectedfield?.add(null);
  }

  isNotEmpty() {
    bool check = true;
    listcontroller?.forEach((element) {
      if (element.text.trim().isEmpty) {
        check = false;
      }
    });
    listDegreeID?.forEach((element) {
      if (element == null) {
        check = false;
      }
    });
    return check;
  }

  Future addNameInDropdown() async {
    for (var element in repositories) {
      // getDegreeID.add(element['_id']);
      toList?.add(DropdownMenuItem(
        value: '${element['name']}',
        child: Text(
          '${element['name']}',
          style: const TextStyle(
              fontSize: 17, fontFamily: 'PoppinsRegular', color: Colors.black),
        ),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    if (fromRegister) {
      addNameInDropdown().then((value) {
        register.getdegreeID();
        register.getFieldstudyDegree();
        register.getFieldstudyName().then((value) {
          if (register.fieldstudyName != null) {
            int i = 0;
            register.fieldstudyName?.forEach((element) {
              addingTextField();
              listcontroller?[i].text = element;
              listselectedfield?[i] = register.fieldstudyDegree?[i];
              listDegreeID?[i] = register.degreeID?[i];
              i = i + 1;
            });
          } else {
            addingTextField();
            setState(() {});
          }
        });

        setState(() {});
      });
    } else {
      addNameInDropdown().then((value) {
        try {
          int i = 0;
          myResume.fieldstudyName?.forEach((element) {
            addingTextField();
            listcontroller?[i].text = element;
            listselectedfield?[i] = myResume.fieldstudyDegree?[i];
            listDegreeID?[i] = myResume.degreeID?[i];
            i = i + 1;
          });
        } catch (e) {
          debugPrint(e.toString());
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(
              top: 10, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
          child: BlueButton(
            onPressed: () {
              if ((listcontroller?.length == listDegreeID?.length &&
                  listselectedfield?.length == listcontroller?.length &&
                  isNotEmpty())) {
                if (fromRegister) {
                  register.degreeID = listDegreeID;
                  register.fieldstudyDegree = listselectedfield;
                  register.fieldstudyName = [];
                  listcontroller?.forEach((element) {
                    register.fieldstudyName?.add(element.text);
                  });
                  register.setDegreeID();
                  register.setFieldstudyDegree();
                  register.setFieldstudyName();
                } else {
                  myResume.degreeID = listDegreeID;
                  myResume.fieldstudyDegree = listselectedfield;
                  myResume.fieldstudyName = [];
                  listcontroller?.forEach((element) {
                    myResume.fieldstudyName?.add(element.text);
                  });
                }

                Navigator.pop(context);
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      title: Text(
                        l.alert,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: mediaWidthSized(context, 22),
                        ),
                      ),
                      content: Text(
                        l.correctINfo,
                        style: TextStyle(
                          // color: Colors.red,
                          fontFamily: 'PoppinsMedium',
                          fontSize: mediaWidthSized(context, 28),
                        ),
                      ),
                      actions: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  l.ok,
                                  style: TextStyle(
                                    color: AppColors.blue,
                                    fontFamily: 'PoppinsSemiBold',
                                    fontSize: mediaWidthSized(context, 29),
                                  ),
                                )))
                      ],
                    );
                  },
                );
              }
            },
            title: l.save,
          ),
        ),
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: AppColors.white,
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              centerTitle: true,
              title: Text(
                l.fieldofStudy,
                style: TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    color: Colors.black,
                    fontSize: appbarTextSize(context)),
              ),
              // Text('Recipes',style: TextStyle(),),
              // elevation: 0,
            ),
            preferredSize: Size.fromHeight(appbarsize(context))),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listcontroller?.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              l.fieldofStudy,
                              style: TextStyle(
                                color: AppColors.grey,
                                fontFamily: 'PoppinsRegular',
                                fontSize: mediaWidthSized(context, 28),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      DropdownTextField(
                        controller: listcontroller?[index],
                        dropdownHint: l.selectDegree,
                        onTap: listcontroller!.length > 1
                            ? () {
                                setState(() {
                                  listcontroller?.removeAt(index);
                                  listselectedfield?.removeAt(index);
                                  listDegreeID?.removeAt(index);
                                });
                              }
                            : null,
                        dropdownOnchanged: (value) {
                          setState(() {
                            listselectedfield?[index] = value;
                            for (var element in repositories) {
                              if (element['name'] == value) {
                                listDegreeID?[index] = element['_id'];
                              }
                            }
                          });
                        },
                        dropdownValue: listselectedfield?[index],
                        dropdownItems: toList,
                        icon: 'trash',
                        color: listcontroller!.length > 1
                            ? AppColors.yellow
                            : AppColors.grey,
                        autofocus: false,
                        obscure: false,
                        hintText: l.fieldofStudy,
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  );
                },
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      addingTextField();
                    });
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      color: AppColors.white,
                      child: Row(
                        children: [
                          const Text(
                            'plus-circle',
                            style: TextStyle(
                                color: AppColors.blue,
                                fontFamily: 'FontAwesomeProRegular',
                                fontSize: 15),
                          ),
                          Text(
                            l.addFieldStudy,
                            style: const TextStyle(
                                color: AppColors.blue,
                                fontFamily: 'PoppinsRegular',
                                fontSize: 15),
                          ),
                        ],
                      )))
            ],
          ),
        ));
  }
}

class InputLanguage extends StatefulWidget {
  const InputLanguage(
      {Key? key,
      this.repositoriesLang,
      this.repositoriesLangLevel,
      this.fromRegister})
      : super(key: key);

  final dynamic repositoriesLang;
  final dynamic repositoriesLangLevel;
  final bool? fromRegister;
  @override
  _InputLanguageState createState() => _InputLanguageState();
}

class _InputLanguageState extends State<InputLanguage> {
  // _InputLanguageState(
  //     this.repositorieslang, this.repositoriesLangLevel, this.fromRegister);
  late final List? repositorieslang = widget.repositoriesLang;
  late final List? repositoriesLangLevel = widget.repositoriesLangLevel;
  late final bool? fromRegister = widget.fromRegister ?? false;
  Register register = Register();
  List<String?>? langID = [];
  List<String?>? langlevelID = [];

  List<String?>? listTopselectedfield = [];
  List<String?>? listBottomselectedfield = [];

  List<DropdownMenuItem<String>> listtopDropdown = [];
  List<DropdownMenuItem<String>> listbottomDropdown = [];

  addingDropdown() {
    listTopselectedfield?.add(null);
    listBottomselectedfield?.add(null);
    langID?.add(null);
    langlevelID?.add(null);
  }

  Future addNameTodropDown() async {
    repositorieslang?.forEach((element) {
      listtopDropdown.add(DropdownMenuItem(
        value: '${element['name']}',
        child: Text(
          '${element['name']}',
          style: const TextStyle(
              fontSize: 17, fontFamily: 'PoppinsRegular', color: Colors.black),
        ),
      ));
    });
    repositoriesLangLevel?.forEach((element) {
      listbottomDropdown.add(DropdownMenuItem(
        value: '${element['name']}',
        child: Text(
          '${element['name']}',
          style: const TextStyle(
              fontSize: 17, fontFamily: 'PoppinsRegular', color: Colors.black),
        ),
      ));
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (fromRegister!) {
      addNameTodropDown().then((value) {
        register.getLangLevel();
        register.getLangLevelID();

        register.getLangNameID();
        register.getLangName().then((value) {
          if (register.langName != null) {
            int i = 0;
            register.langName?.forEach((element) {
              addingDropdown();
              listTopselectedfield?[i] = element;
              listBottomselectedfield?[i] = register.langLevel?[i];
              langID?[i] = register.langNameID?[i];
              langlevelID?[i] = register.langLevelID?[i];
              i = i + 1;
              setState(() {});
            });
          } else {
            addingDropdown();
            setState(() {});
          }
        });
      });
    } else {
      addNameTodropDown().then((value) {
        try {
          int i = 0;
          myResume.langName?.forEach((element) {
            addingDropdown();
            listTopselectedfield?[i] = element;
            listBottomselectedfield?[i] = myResume.langLevel?[i];
            langID?[i] = myResume.langNameID?[i];
            langlevelID?[i] = myResume.langLevelID?[i];
            i = i + 1;
            setState(() {});
          });
        } catch (e) {
          debugPrint(e.toString());
        }
      });
    }
  }

  isNotEmpty() {
    bool check = true;
    listTopselectedfield?.forEach((element) {
      if (element == null) {
        check = false;
      }
    });
    listBottomselectedfield?.forEach((element) {
      if (element == null) {
        check = false;
      }
    });
    return check;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(
              top: 10, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
          child: BlueButton(
            onPressed: () {
              if ((listTopselectedfield?.length ==
                          listBottomselectedfield?.length &&
                      langID!.length == listTopselectedfield?.length &&
                      langlevelID!.length == langID?.length) &&
                  isNotEmpty()) {
                if (fromRegister!) {
                  register.langName = listTopselectedfield;
                  register.langLevel = listBottomselectedfield;
                  register.langNameID = langID;
                  register.langLevelID = langlevelID;
                  register.setLangName();
                  register.setLangNameID();
                  register.setLangLevel();
                  register.setLangLevelID();
                } else {
                  myResume.langName = listTopselectedfield;
                  myResume.langLevel = listBottomselectedfield;
                  myResume.langNameID = langID;
                  myResume.langLevelID = langlevelID;
                }
                Navigator.pop(context);
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      title: Text(
                        l.alert,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: mediaWidthSized(context, 22),
                        ),
                      ),
                      content: Text(
                        l.correctINfo,
                        style: TextStyle(
                          // color: Colors.red,
                          fontFamily: 'PoppinsMedium',
                          fontSize: mediaWidthSized(context, 28),
                        ),
                      ),
                      actions: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                color: AppColors.white,
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  l.ok,
                                  style: TextStyle(
                                    color: AppColors.blue,
                                    fontFamily: 'PoppinsSemiBold',
                                    fontSize: mediaWidthSized(context, 29),
                                  ),
                                )))
                      ],
                    );
                  },
                );
              }
            },
            title: l.save,
          ),
        ),
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: AppColors.white,
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              centerTitle: true,
              title: Text(
                l.language,
                style: TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    color: Colors.black,
                    fontSize: appbarTextSize(context)),
              ),
              // Text('Recipes',style: TextStyle(),),
              // elevation: 0,
            ),
            preferredSize: Size.fromHeight(appbarsize(context))),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listTopselectedfield?.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              l.language,
                              style: TextStyle(
                                color: AppColors.grey,
                                fontFamily: 'PoppinsRegular',
                                fontSize: mediaWidthSized(context, 28),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      MultiDropdown(
                        bottomdropdownHint: l.selectlevel,
                        bottomdropdownItems: listbottomDropdown,
                        bottomdropdownOnchanged: (value) {
                          listBottomselectedfield?[index] = value;
                          repositoriesLangLevel?.forEach((element) {
                            if (element['name'] == value) {
                              langlevelID?[index] = element['_id'];
                            }
                          });

                          setState(() {});
                        },
                        bottomdropdownValue: listBottomselectedfield?[index],
                        topdropdownHint: l.selectLang,
                        topdropdownItems: listtopDropdown,
                        topdropdownOnchanged: (value) {
                          listTopselectedfield?[index] = value;
                          repositorieslang?.forEach((element) {
                            if (element['name'] == value) {
                              langID?[index] = element['_id'];
                            }
                          });

                          setState(() {});
                        },
                        icon: 'trash',
                        color: listTopselectedfield!.length > 1
                            ? AppColors.yellow
                            : AppColors.grey,
                        onTap: listTopselectedfield!.length > 1
                            ? () {
                                setState(() {
                                  listBottomselectedfield?.removeAt(index);
                                  listTopselectedfield?.removeAt(index);
                                  langID?.removeAt(index);
                                  langlevelID?.removeAt(index);
                                });
                              }
                            : null,
                        topdropdownValue: listTopselectedfield?[index],
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  );
                },
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      addingDropdown();
                    });
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      color: AppColors.white,
                      child: Row(
                        children: [
                          const Text(
                            'plus-circle',
                            style: TextStyle(
                                color: AppColors.blue,
                                fontFamily: 'FontAwesomeProRegular',
                                fontSize: 15),
                          ),
                          Text(
                            l.addlanguage,
                            style: const TextStyle(
                                color: AppColors.blue,
                                fontFamily: 'PoppinsRegular',
                                fontSize: 15),
                          ),
                        ],
                      )))
            ],
          ),
        ));
  }
}

class InputKeySkill extends StatefulWidget {
  const InputKeySkill(this.fromRegister, {Key? key}) : super(key: key);
  final bool? fromRegister;
  @override
  _InputKeySkillState createState() => _InputKeySkillState();
}

class _InputKeySkillState extends State<InputKeySkill> {
  // _InputKeySkillState(this.fromRegister);
  late final bool fromRegister = widget.fromRegister ?? false;
  Register register = Register();

  List<TextEditingController> listController = [];
  @override
  void initState() {
    if (fromRegister) {
      register.getkeySkill().then((value) {
        int i = 0;
        try {
          register.keySkill?.forEach((element) {
            addTextField();
            listController[i].text = element;
            i = i + 1;
          });
          if (register.keySkill!.isEmpty) {
            addTextField();
          }
          setState(() {});
        } catch (e) {
          addTextField();
          setState(() {});
        }
      });
    } else {
      try {
        int i = 0;
        myResume.keySkill?.forEach((element) {
          addTextField();
          listController[i].text = element;
          i = i + 1;
        });
        setState(() {});
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    super.initState();
  }

  addTextField() {
    listController.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
            top: 10, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
        child: BlueButton(
          onPressed: () {
            bool showdia = false;

            for (var element in listController) {
              if (element.text.trim().isEmpty) {
                showdia = true;
              }
            }
            if (showdia) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      title: Text(
                        l.alert,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: mediaWidthSized(context, 22),
                        ),
                      ),
                      content: Text(
                        l.correctINfo,
                        style: TextStyle(
                          // color: Colors.red,
                          fontFamily: 'PoppinsMedium',
                          fontSize: mediaWidthSized(context, 28),
                        ),
                      ),
                      actions: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                color: AppColors.white,
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  l.ok,
                                  style: TextStyle(
                                    color: AppColors.blue,
                                    fontFamily: 'PoppinsSemiBold',
                                    fontSize: mediaWidthSized(context, 29),
                                  ),
                                )))
                      ],
                    );
                  });
            } else {
              if (fromRegister) {
                register.keySkill = [];
                for (var element in listController) {
                  register.keySkill?.add(element.text);
                }
                register.setKeySkill();
              } else {
                myResume.keySkill = [];
                for (var element in listController) {
                  myResume.keySkill?.add(element.text);
                }
              }
              Navigator.pop(context);
            }
          },
          title: l.save,
        ),
      ),
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: AppColors.white,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            centerTitle: true,
            title: Text(
              l.keySkill,
              style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  color: Colors.black,
                  fontSize: appbarTextSize(context)),
            ),
            // Text('Recipes',style: TextStyle(),),
            // elevation: 0,
          ),
          preferredSize: Size.fromHeight(appbarsize(context))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    l.keySkill,
                    style: TextStyle(
                        fontFamily: 'PoppinsRegular',
                        fontSize: mediaWidthSized(context, 28)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: listController.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: OnlyTextField(
                    obscure: false,
                    autofocus: true,
                    hintIcon: 'trash',
                    color: listController.length > 1
                        ? AppColors.yellow
                        : AppColors.grey,
                    controller: listController[index],
                    hintText: l.keySkill,
                    onTap: listController.length > 1
                        ? () {
                            setState(() {
                              listController.removeAt(index);
                            });
                          }
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    addTextField();
                  });
                },
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: AppColors.white,
                    child: Row(
                      children: [
                        const Text(
                          'plus-circle',
                          style: TextStyle(
                              color: AppColors.blue,
                              fontFamily: 'FontAwesomeProRegular',
                              fontSize: 15),
                        ),
                        Text(
                          l.addKeySkill,
                          style: const TextStyle(
                              color: AppColors.blue,
                              fontFamily: 'PoppinsRegular',
                              fontSize: 15),
                        ),
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
