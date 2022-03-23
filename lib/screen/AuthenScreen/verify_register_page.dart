import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:app/api/auth.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/constant/push_page.dart';
import 'package:app/constant/userdata.dart';
import 'package:app/function/pluginfunction.dart';
import 'package:app/function/sized.dart';
import 'package:app/screen/ControlScreen/bottom_navigation.dart';
import 'package:app/screen/widget/alertdialog.dart';
import 'package:app/screen/widget/button.dart';
// import 'package:sms_autofill/sms_autofill.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

import 'change_password.dart';

class VerifyRegisterPage extends StatefulWidget {
  const VerifyRegisterPage(
      {Key? key, this.number, this.justverify, this.email, this.password})
      : super(key: key);
  final String? number;
  final bool? justverify;
  final String? email;
  final String? password;
  @override
  _VerifyRegisterPageState createState() => _VerifyRegisterPageState();
}

class _VerifyRegisterPageState extends State<VerifyRegisterPage> {
  TextEditingController otpController = TextEditingController();
  late final String? number = widget.number;
  int? otp;
  late final bool justverify = widget.justverify ?? false;

  User user = User();
  QueryInfo queryInfo = QueryInfo();
  bool sending = false;

  @override
  void initState() {
    debugPrint(justverify.toString());
    // ignore: todo
    // TODO: implement initState
    super.initState();
    user.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // int count = 0;
        if (justverify == true) {
          pushBottomNavigation(0, context);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: AppColors.white,
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              centerTitle: true,
              title: Text(
                l.verifyphone,
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
              SizedBox(
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              Container(
                margin: const EdgeInsets.only(right: 17),
                child: Text(
                  'sms',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 3.5,
                      color: AppColors.blue,
                      fontFamily: 'FontAwesomeProSolid'),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    '${l.enterOTPCode} ',
                    style: TextStyle(
                        fontFamily: 'PoppinsRegular',
                        fontSize: MediaQuery.of(context).size.width / 26,
                        color: AppColors.greyOpacity),
                  ),
                  Text(
                    '$number',
                    style: TextStyle(
                        fontFamily: 'PoppinsRegular',
                        fontSize: MediaQuery.of(context).size.width / 26,
                        color: AppColors.blue),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              // PinCodeTextField(
              //   length: 6,
              //   obscureText: false,
              //   animationType: AnimationType.fade,
              //   pinTheme: PinTheme(
              //     shape: PinCodeFieldShape.box,
              //     borderRadius: BorderRadius.circular(5),
              //     fieldHeight: 50,
              //     fieldWidth: 40,
              //     activeFillColor: Colors.white,
              //   ),
              //   animationDuration: Duration(milliseconds: 300),
              //   // backgroundColor: Colors.blue.shade50,
              //   enableActiveFill: false,

              //   // controller: textEditingController,
              //   onCompleted: (pin) {
              //     otp = int.parse(pin);
              //   },
              //   onChanged: (pin) {
              //     otp = int.parse(pin);
              //   },
              //   // beforeTextPaste: (text) {
              //   //  debugPrint("Allowing to paste $text");
              //   //   //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //   //   //but you can show anything you want here, like your pop up saying wrong paste format or etc
              //   //   return true;
              //   // },
              //   appContext: null,
              // ),

              Container(
                  margin: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: mediaHeightSized(context, 20)),
                  height: mediaWidthSized(context, 11),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                                color: AppColors.greyWhite.withOpacity(0.50),
                                width: mediaWidthSized(context, 1.5),
                                height: mediaWidthSized(context, 11),
                                child: TextField(
                                  onChanged: (value) {
                                    otp = int.parse(value);
                                  },
                                  textAlign: TextAlign.center,
                                  controller: otpController,
                                  maxLength: 6,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]')),
                                  ],
                                  keyboardType: TextInputType.number,
                                  style: textStyleMedium(
                                      context: context, size: 20),
                                  decoration: const InputDecoration(
                                    counterText: '',
                                    fillColor: AppColors.greyWhite,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () async {
                            try {
                              ClipboardData? data =
                                  await Clipboard.getData('text/plain');
                              if (6 < data!.text!.trim().length) {
                                throw Exception('Error length');
                              }
                              otp = int.parse(data.text?.trim() ?? '');
                              otpController.text = data.text?.trim() ?? '';
                              setState(() {});
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg:
                                    'OTP must be numberic and length must equal 6, check clipboard again',
                                gravity: ToastGravity.BOTTOM,
                              );
                              debugPrint(e.toString());
                            }
                          },
                          child: Container(
                            color: AppColors.white,
                            child: Text(
                              'Paste',
                              style: textStyleBold(
                                  context: context,
                                  size: 24,
                                  color: AppColors.yellow),
                            ),
                          ))
                    ],
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              Mutation(
                options: MutationOptions(
                  onError: (error) {
                    debugPrint(error?.graphqlErrors.toString());
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
                  document: justverify
                      ? gql(queryInfo.verifyOTP)
                      : gql(queryInfo.verifyOTPforgot),
                  update: (cache, result) {},
                  onCompleted: (data) {
                    debugPrint(data.toString());
                    Map<String, dynamic>? result = data;

                    SmartDialog.dismiss();
                    if (result == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertPlainDialog(
                            title: l.cannotverify,
                            content: l.pleasecheckotp,
                            actions: [
                              AlertAction(
                                title: l.ok,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        },
                      );
                    } else {
                      if (justverify == true) {
                        // AuthUtil.setToken(user.token);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertPlainDialog(
                              title: l.successful,
                              color: AppColors.blue,
                              content: l.hasVerify,
                              actions: [
                                Mutation(
                                  options: MutationOptions(
                                    onError: (error) {
                                      debugPrint(error.toString());
                                      Future.delayed(const Duration(seconds: 1))
                                          .then((value) {
                                        SmartDialog.dismiss();
                                        switch (error?.graphqlErrors[0].message
                                            .toString()) {
                                          case 'Please fill out your E-mail or Mobile':
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertPlainDialog(
                                                  title: 'Empty Email',
                                                  content:
                                                      'Please fill out your E-mail or Mobile',
                                                  actions: [
                                                    AlertAction(
                                                      title: 'Ok',
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                            break;
                                          case 'Your account was Rejected':
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertPlainDialog(
                                                  title: 'Alert',
                                                  content:
                                                      'Your account was Rejected, please contact us',
                                                  actions: [
                                                    AlertAction(
                                                      title: 'Ok',
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                            break;
                                          case 'Email or Mobile does not exist!':
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertPlainDialog(
                                                  title: 'Cannot login',
                                                  content:
                                                      'Mobile does not exist!',
                                                  actions: [
                                                    AlertAction(
                                                      title: 'Ok',
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                            break;
                                          case 'Password Incorrect':
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertPlainDialog(
                                                  title: 'Cannot login',
                                                  content: 'Password Incorrect',
                                                  actions: [
                                                    AlertAction(
                                                      title: 'Ok',
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                            break;
                                          // case 'You have not verified your account':
                                          //   showDialog(
                                          //     context: context,
                                          //     builder: (context) {
                                          //       return AlertPlainDialog(
                                          //         title: 'Cannot login',
                                          //         content:
                                          //             'Your account is not verify\ndo you want to verify your account?',
                                          //         actions: [
                                          //           Mutation(
                                          //             options: MutationOptions(
                                          //               documentNode: gql(
                                          //                   queryInfo.sendOTP),
                                          //               onCompleted: (data) {
                                          //                 loading.hide();
                                          //                 Map<String, dynamic>
                                          //                     result = data;
                                          //                 User user = User();

                                          //                 if (data != null) {
                                          //                   user.token = result[
                                          //                       'sendVerificationCode'];
                                          //                   user.setToken();
                                          //                   Navigator.push(
                                          //                       context,
                                          //                       MaterialPageRoute(
                                          //                         builder:
                                          //                             (context) =>
                                          //                                 VerifyRegisterPage(
                                          //                           number:
                                          //                               numberController
                                          //                                   .text,
                                          //                           justverify:
                                          //                               true,
                                          //                         ),
                                          //                       ));
                                          //                 }
                                          //               },
                                          //             ),
                                          //             builder: (runMutation,
                                          //                 result) {
                                          //               return AlertAction(
                                          //                 title: 'Yes',
                                          //                 onTap: () {
                                          //                   loading.show();
                                          //                   runMutation({
                                          //                     "mobile":
                                          //                         numberController,
                                          //                   });
                                          //                 },
                                          //               );
                                          //             },
                                          //           ),
                                          //           AlertAction(
                                          //             title: 'No',
                                          //             onTap: () {
                                          //               Navigator.pop(context);
                                          //             },
                                          //           )
                                          //         ],
                                          //       );
                                          //     },
                                          //   );
                                        }
                                      });
                                      // Your account was Rejected: Undefined location
                                    },
                                    onCompleted: (data) {
                                      Future.delayed(const Duration(seconds: 1))
                                          .then((value) {
                                        SmartDialog.dismiss();
                                        debugPrint(data.toString());
                                        if (widget.number == null ||
                                            widget.number?.trim() == null ||
                                            widget.number == '') {
                                        } else {
                                          SharedPref()
                                              .save('number', widget.number);
                                        }
                                        if (widget.email == null ||
                                            widget.email?.trim() == null ||
                                            widget.email == '') {
                                        } else {
                                          SharedPref()
                                              .save('email', widget.number);
                                        }
                                        // debugPrint(data.toString());
                                        Future.delayed(
                                                const Duration(seconds: 1))
                                            .then((value) {
                                          SmartDialog.dismiss();
                                          Map<String, dynamic>? result = data;

                                          if (result != null) {
                                            AuthUtil.setToken(
                                                    result['seekerLogin'])
                                                .then((value) {
                                              pageIndex = 0;
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  '/',
                                                  (Route<dynamic> route) =>
                                                      false);
                                              pageIndex = 0;
                                              // Phoenix.rebirth(context);
                                            });
                                          }
                                        });
                                      });
                                    },
                                    document: gql(queryInfo.login),
                                  ),
                                  builder: (runMutation, result) {
                                    return AlertAction(
                                      title: l.ok,
                                      onTap: () {
                                        showDialogLoading(context);
                                        runMutation({
                                          'email': widget.number == null ||
                                                  widget.number?.trim() ==
                                                      null ||
                                                  widget.number == ''
                                              ? widget.email
                                              : widget.number,
                                          'password': widget.password
                                        });
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        User user = User();
                        user.changepassToken = result['verifyCode'];
                        user.setPassToken();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChangePasswordPage()),
                        );
                      }
                    }
                  },
                ),
                builder: (RunMutation runMutation, result) {
                  return BlueButton(
                    onPressed: () {
                      if (otp.toString().length == 6) {
                        showDialogLoading(context);
                        runMutation({
                          "verifyToken": user.token,
                          "verifyCode":
                              justverify ? otp.toString() : otp.toString()
                        });
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertPlainDialog(
                              title: l.pleaseEnterOTP,
                              content: l.correctINfo,
                              actions: [
                                AlertAction(
                                  title: l.ok,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                    title: l.confirmMATION,
                  );
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              Text(
                '${l.dontReciv}?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'PoppinsRegular',
                    fontSize: MediaQuery.of(context).size.width / 26,
                    color: AppColors.greyOpacity),
              ),
              Mutation(
                options: MutationOptions(
                  document: gql(queryInfo.resendOTP),
                  update: (cache, result) {},
                  onCompleted: (data) {},
                ),
                builder: (RunMutation runMutation, result) {
                  return Column(
                    children: [
                      Visibility(
                        visible: sending,
                        child: InkWell(
                          splashColor: AppColors.opacityBlue,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              l.recendCode,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'PoppinsRegular',
                                  fontSize:
                                      MediaQuery.of(context).size.width / 26,
                                  color: AppColors.grey),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !sending,
                        child: InkWell(
                          onTap: () {
                            runMutation({"verifyToken": user.token});
                            sending = true;
                            setState(() {});
                            Fluttertoast.showToast(
                              backgroundColor: Colors.black87,
                              msg: l.wealreadysent,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                            );
                            Future.delayed(const Duration(milliseconds: 60000),
                                () {
                              setState(() {
                                sending = false;
                              });
                            });
                          },
                          splashColor: AppColors.opacityBlue,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              l.recendCode,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'PoppinsRegular',
                                  fontSize:
                                      MediaQuery.of(context).size.width / 26,
                                  color: AppColors.blue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
