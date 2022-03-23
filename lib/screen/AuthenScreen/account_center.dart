import 'package:flutter/material.dart';
// import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:app/api/auth.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/pluginfunction.dart';
import 'package:app/function/sized.dart';
import 'package:app/screen/ControlScreen/bottom_navigation.dart';
import 'package:app/screen/widget/alertdialog.dart';
import 'package:app/screen/widget/button.dart';
import 'package:app/screen/widget/image_network_retry.dart';
import 'package:app/screen/widget/input_text_field.dart';
import 'package:app/screen/widget/resume_tab.dart';

import 'package:validators/validators.dart';

import '../my_profile.dart';

String? newNumber, newEmail;

class AccountCenterPage extends StatefulWidget {
  const AccountCenterPage(
      {Key? key,
      @required this.name,
      this.surname,
      this.email,
      this.number,
      this.picture})
      : super(key: key);
  final String? name, surname, email, number, picture;
  @override
  _AccountCenterPageState createState() => _AccountCenterPageState();
}

class _AccountCenterPageState extends State<AccountCenterPage> {
  late final String? name = widget.name;
  late final String? surname = widget.surname;
  late final String? email = widget.email;
  late final String? number = widget.number;
  Widget taginfo(String icon, String info) {
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: mediaWidthSized(context, 130),
            ),
            child: Text(icon,
                style: TextStyle(
                    fontSize: mediaWidthSized(context, 25),
                    // color:  AppColors.blue,
                    fontFamily: 'FontAwesomeProRegular')),
          ),
          Expanded(
            child: Text(': $info',
                style: TextStyle(
                    fontSize: mediaWidthSized(context, 25),
                    fontFamily: 'PoppinsSemiBold')),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    reloadprofilePage = true;
    newEmail = null;
    newNumber = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: AppColors.white,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              elevation: 0,
            ),
            preferredSize: Size.fromHeight(appbarsize(context))),
        body: SingleChildScrollView(
          child: ListBody(
            children: [
              SizedBox(
                height: mediaWidthSized(context, 50),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: mediaWidthSized(context, 3.3),
                    width: mediaWidthSized(context, 3.3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      // border:
                      //     Border.all(color: AppColors.Yellow_COLOR, width: 2.0)),
                    ),
                    child: ClipOval(
                      child: Container(
                          height: mediaWidthSized(context, 3.3),
                          width: mediaWidthSized(context, 3.3),
                          color: AppColors.greyWhite,
                          child: widget.picture == null
                              ? Icon(
                                  Icons.person,
                                  size: mediaWidthSized(context, 6),
                                  color: AppColors.greyOpacity,
                                )
                              : Image(
                                  fit: BoxFit.cover,
                                  // fit: BoxFit.cover,
                                  image: imageNetworkBuild(
                                    widget.picture,
                                  ),
                                )
                          //  Image.network(
                          //     widget.picture,
                          //     fit: BoxFit.cover,
                          //   ),
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: mediaWidthSized(context, 28),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$name $surname',
                      style: TextStyle(
                          fontSize: mediaWidthSized(context, 24),
                          color: Colors.black,
                          fontFamily: 'PoppinsSemiBold')),
                ],
              ),
              SizedBox(
                height: mediaWidthSized(context, 28),
              ),
              // taginfo('user ', '$name $surname'),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 30),
              //   child: Column(
              //     children: [
              //       Container(
              //         decoration: BoxDecoration(),
              //         margin: EdgeInsets.only(left: 0, bottom: 5),
              //         child: Row(
              //           children: [
              //             // Text('user ',
              //             //     style: TextStyle(
              //             //         fontSize:
              //             //             MediaQuery.of(context).size.width / 19,
              //             //         color:  AppColors.blue,
              //             //         fontFamily: 'FontAwesomeProSolid')),

              //             Container(
              //               padding: EdgeInsets.symmetric(
              //                   horizontal: 20, vertical: 5),
              //               decoration: BoxDecoration(
              //                 color:  AppColors.blue,
              //                 borderRadius:
              //                     BorderRadius.all(Radius.circular(10)),
              //                 // border: Border.all(
              //                 //   color: AppColors.greyOpacity,
              //                 //   width: 0.5,
              //                 // ),
              //               ),
              //               child: Text('$name $surname',
              //                   style: TextStyle(
              //                       fontSize: mediaWidthSized(context, 22),
              //                       color: AppColors.white,
              //                       fontFamily: 'PoppinsSemiBold')),
              //             ),
              //           ],
              //         ),
              //       ),
              //       // Container(
              //       //   padding: EdgeInsets.symmetric(vertical: 10),
              //       //   decoration: BoxDecoration(
              //       //       borderRadius: BorderRadius.all(Radius.circular(10)),
              //       //       border: Border.all(
              //       //         color: AppColors.greyOpacity,
              //       //         width: 0.5,
              //       //       )),
              //       //   child: Column(
              //       //     children: [
              //       //       taginfo('envelope ',
              //       //           newEmail == null ? '$email' : '$newEmail'),
              //       //       taginfo(
              //       //           'mobile ',
              //       //           newNumber == null
              //       //               ? '020 $number'
              //       //               : '020 $newNumber'),
              //       //     ],
              //       //   ),
              //       // ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: mediaWidthSized(context, 28),
              ),
              WidgetTabInfo(
                alertText: '',
                icon: '',
                alertvisible: false,
                header: l.number,
                showField: newNumber == null ? '020 $number' : '020 $newNumber',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePhoneNumberPage(
                            newNumber == null ? '$number' : '$newNumber',
                            newEmail == null ? '$email' : '$newEmail')),
                  );
                },
              ),
              // WidgetListTile(
              //   caption: '  ${l.changphone}',
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => ChangePhoneNumberPage(
              //               newNumber == null ? '$number' : '$newNumber',
              //               newEmail == null ? '$email' : '$newEmail')),
              //     );
              //   },
              // ),
              WidgetTabInfo(
                alertText: '',
                icon: '',
                alertvisible: false,
                header: l.email,
                showField: newEmail == null ? '$email' : '$newEmail',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeEmailPage(
                            newEmail == null ? '$email' : '$newEmail',
                            newNumber == null ? '$number' : '$newNumber')),
                  );
                },
              ),
              // WidgetListTile(
              //   caption: '  ${l.changeEmail}',
              //   onTap: () {

              //   },
              // ),
              WidgetTabInfo(
                alertText: '',
                icon: '',
                alertvisible: false,
                header: l.password,
                showField: "********",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePasswordPage()),
                  );
                },
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: InkWell(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: AppColors.orange)),
                        child: Text(
                          " ${l.logout} ",
                          style: textStyleMedium(
                              color: Colors.orange, context: context, size: 24),
                        ),
                      ),
                      onTap: () {
                        showDialogLoading(context);
                        AuthUtil().removeToken();
                        Future.delayed(const Duration(milliseconds: 1000))
                            .then((value) {
                          SmartDialog.dismiss();
                          pageIndex = 0;
                          currentToken = null;
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (Route<dynamic> route) => false);
                          pageIndex = 0;
                          // Phoenix.rebirth(context);
                        });
                      },
                    ),
                  ),
                ],
              ),
              // WidgetListTile(
              //   caption: '  ${l.changepassword}',
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => ChangePasswordPage()),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePhoneNumberPage extends StatefulWidget {
  const ChangePhoneNumberPage(this.phone, this.email, {Key? key})
      : super(key: key);
  final String email;
  final String phone;
  @override
  _ChangePhoneNumberPageState createState() => _ChangePhoneNumberPageState();
}

class _ChangePhoneNumberPageState extends State<ChangePhoneNumberPage> {
  TextEditingController controller = TextEditingController();
  late final String email = widget.email;
  late final String phone = widget.phone;
  String? past;
  @override
  void initState() {
    past = phone;
    controller.text = phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(
              top: 10, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
          child: Mutation(
            options: MutationOptions(
              document: gql(queryInfo.changEmailandNumber),
              onCompleted: (data) {
                if (data == null) {
                } else {
                  debugPrint(data.toString());
                  SmartDialog.dismiss();
                  newNumber = controller.text;
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertPlainDialog(
                          title: l.successful,
                          color: AppColors.blue,
                          content: l.yourmobilehaschange,
                          actions: [
                            AlertAction(
                              title: l.ok,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      });
                }
              },
              onError: (error) {
                Future.delayed(const Duration(seconds: 1)).then((value) {
                  SmartDialog.dismiss();
                  if (error != null) {
                    if (error.graphqlErrors[0].toString() ==
                        'This mobile already registered: Undefined location') {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertPlainDialog(
                              title: l.alert,
                              // color: AppColors,
                              content: l.thisNumberAlready,
                              actions: [
                                AlertAction(
                                  title: l.ok,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertPlainDialog(
                            title: 'Problem',
                            actions: [
                              AlertAction(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                title: 'Ok',
                              )
                            ],
                            content: error.graphqlErrors[0].message.toString(),
                          );
                        },
                      );
                    }
                  }

                  debugPrint(error.toString());
                });
              },
            ),
            builder: (runMutation, result) {
              return BlueButton(
                  onPressed: () {
                    if (controller.text.length == 8) {
                      if (past != controller.text) {
                        showDialogLoading(context);
                        runMutation(
                            {"email": email, "mobile": controller.text});
                      } else {
                        Navigator.pop(context);
                      }
                      // Navigator.pop(context);
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
                                l.numberMust,
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
                                            fontSize:
                                                mediaWidthSized(context, 29),
                                          ),
                                        )))
                              ],
                            );
                          });
                    }
                  },
                  title: l.save);
            },
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
                l.changphone,
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
              PhoneTextField(
                title: l.mobileNumber,
                hintText: l.mobileNumber,
                controller: controller,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController currentpass = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool alertNewPassword = false;
  bool alertConfirmPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(
              top: 10, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
          child: Mutation(
            options: MutationOptions(
              document: gql(queryInfo.changepassword),
              onError: (error) {
                debugPrint(error.toString());
                if (error != null) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertPlainDialog(
                        title: 'Problem',
                        actions: [
                          AlertAction(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            title: 'Ok',
                          )
                        ],
                        content: error.graphqlErrors[0].message.toString(),
                      );
                    },
                  );
                }
              },
              onCompleted: (data) {
                debugPrint(data.toString());
                SmartDialog.dismiss();
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertPlainDialog(
                        title: l.successful,
                        color: AppColors.blue,
                        content: l.yourpasswordhasChange,
                        actions: [
                          AlertAction(
                            title: l.ok,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    });
              },
            ),
            builder: (runMutation, result) {
              return BlueButton(
                // marginx2: 0,
                onPressed: () {
                  alertNewPassword = newPassword.text.length < 8;
                  alertConfirmPassword =
                      confirmPassword.text != newPassword.text;
                  if (currentpass.text.isNotEmpty &&
                      !alertConfirmPassword &&
                      !alertNewPassword) {
                    showDialogLoading(context);

                    runMutation({
                      "oldPassword": currentpass.text,
                      "newPassword": newPassword.text,
                      "confirmPasswords": confirmPassword.text
                    });
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
                                          fontSize:
                                              mediaWidthSized(context, 29),
                                        ),
                                      )))
                            ],
                          );
                        });
                  }
                },
                title: l.save,
              );
            },
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
              elevation: 1,
              title: Text(
                l.changepassword,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              NormalTextField(
                title: l.currentpassword,
                obscure: true,
                hintText: l.currentpassword,
                hintIcon: '',
                controller: currentpass,
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 0.7,
                width: mediaWidthSized(context, 30),
                decoration: const BoxDecoration(
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              NormalTextField(
                onChanged: (val) {
                  setState(() {
                    alertNewPassword = newPassword.text.length < 8;
                  });
                  if (confirmPassword.text.isNotEmpty) {
                    setState(() {
                      alertConfirmPassword =
                          confirmPassword.text != newPassword.text;
                    });
                  }
                },
                title: l.newpassword,
                obscure: true,
                hintText: l.newpassword,
                hintIcon: '',
                controller: newPassword,
              ),
              Visibility(
                visible: alertNewPassword,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Text(l.passwordMust,
                        style: TextStyle(
                            fontSize: mediaWidthSized(context, 40),
                            color: Colors.red,
                            fontFamily: 'PoppinsRegular')),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              NormalTextField(
                onChanged: (val) {
                  setState(() {
                    alertConfirmPassword =
                        confirmPassword.text != newPassword.text;
                  });
                },
                title: l.confirmpassword,
                obscure: true,
                hintText: l.confirmpassword,
                hintIcon: '',
                controller: confirmPassword,
              ),
              Visibility(
                visible: alertConfirmPassword,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Text(l.notmatch,
                        style: TextStyle(
                            fontSize: mediaWidthSized(context, 40),
                            color: Colors.red,
                            fontFamily: 'PoppinsRegular')),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage(this.email, this.number, {Key? key}) : super(key: key);
  final String email, number;
  @override
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  late final String email = widget.email;
  late final String number = widget.number;
  TextEditingController controller = TextEditingController();
  String? past;
  @override
  void initState() {
    controller.text = email;
    past = email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(
              top: 10, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
          child: Mutation(
            options: MutationOptions(
              document: gql(queryInfo.changEmailandNumber),
              onCompleted: (data) {
                Future.delayed(const Duration(seconds: 1)).then((value) {
                  debugPrint(data.toString());
                  SmartDialog.dismiss();
                  if (data == null) {
                  } else {
                    newEmail = controller.text;
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertPlainDialog(
                            title: l.successful,
                            color: AppColors.blue,
                            content: l.yourEmailhasChanged,
                            actions: [
                              AlertAction(
                                title: l.ok,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                  }
                });
              },
              onError: (error) {
                Future.delayed(const Duration(seconds: 1)).then((value) {
                  SmartDialog.dismiss();
                  if (error != null) {
                    if (error.graphqlErrors[0].toString() ==
                        'This email already registered: Undefined location') {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertPlainDialog(
                              title: l.alert,
                              // color:  AppColors.blue,
                              content: l.thisEmailAlready,
                              actions: [
                                AlertAction(
                                  title: l.ok,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertPlainDialog(
                            title: 'Problem',
                            actions: [
                              AlertAction(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                title: 'Ok',
                              )
                            ],
                            content: error.graphqlErrors[0].message.toString(),
                          );
                        },
                      );
                    }
                  }

                  debugPrint(error.toString());
                  // loading.hide();
                });
              },
            ),
            builder: (runMutation, result) {
              return BlueButton(
                // marginx2: 0,
                onPressed: () {
                  if (isEmail(controller.text)) {
                    if (past != controller.text) {
                      showDialogLoading(context);
                      runMutation({"email": controller.text, "mobile": number});
                    } else {
                      Navigator.pop(context);
                    }
                    // Navigator.pop(context);
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertPlainDialog(
                            title: l.alert,
                            content: l.entervalidEmail,
                            actions: [
                              AlertAction(
                                title: l.ok,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                  }
                },
                title: l.save,
              );
            },
          ),
        ),
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: AppColors.white,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              centerTitle: true,
              title: Text(
                l.changeEmail,
                style: TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    color: Colors.black,
                    fontSize: appbarTextSize(context)),
              ),
            ),
            preferredSize: Size.fromHeight(appbarsize(context))),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              NormalTextField(
                controller: controller,
                title: l.email,
                obscure: false,
                hintText: l.email,
                hintIcon: 'envelope',
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
