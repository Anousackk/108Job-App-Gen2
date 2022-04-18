import 'package:flutter/material.dart';
// import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:app/api/auth.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/animationfade.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/constant/userdata.dart';
import 'package:app/function/pluginfunction.dart';
import 'package:app/function/sized.dart';
import 'package:app/screen/AuthenScreen/verify_register_page.dart';
import 'package:app/screen/ControlScreen/bottom_navigation.dart';
import 'package:app/screen/widget/alertdialog.dart';
import 'package:app/screen/widget/button.dart';
import 'package:app/screen/widget/input_text_field.dart';

import 'forgot_password_page.dart';
import 'register_page.dart';
// import 'new_register_page.dart';
// import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  QueryInfo queryInfo = QueryInfo();
  TextEditingController disableController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool loginWithEmail = false;

  bool obscure = true;
  @override
  void initState() {
    SharedPref().read('loginnumber').then((value) {
      numberController.text = value ?? '';
      setState(() {});
    });
    SharedPref().read('loginemail').then((value) {
      emailController.text = value ?? '';
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    disableController.text = '020';
    FocusScopeNode currentFocus = FocusScopeNode();
    return GestureDetector(
      onTap: () {
        currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
            child: AppBar(
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: Text(
                      'times',
                      style: TextStyle(
                          fontSize: mediaWidthSized(context, 17),
                          color: Colors.black,
                          fontFamily: 'FontAwesomeProLight'),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.white,
              iconTheme: const IconThemeData(
                color: AppColors.blue, //change your color here
              ),
              // Text('Recipes',style: TextStyle(),),
              elevation: 0,
            ),
            preferredSize: Size.fromHeight(appbarsize(context))),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 90,
            child: Mutation(
                options: MutationOptions(
                  onError: (error) {
                    debugPrint(
                        error?.graphqlErrors[0].message.toString().toString());

                    Future.delayed(const Duration(seconds: 1)).then((value) {
                      SmartDialog.dismiss();
                      switch (error?.graphqlErrors[0].message.toString()) {
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
                                content: 'Email or Mobile does not exist!',
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
                        case 'Password Incorrect ':
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
                        case 'You have not verified your account':
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertPlainDialog(
                                title: 'Cannot login',
                                content:
                                    'Your account is not verify\ndo you want to verify your account?',
                                actions: [
                                  Mutation(
                                    options: MutationOptions(
                                      document: gql(queryInfo.sendOTP),
                                      onCompleted: (data) {
                                        Future.delayed(
                                                const Duration(seconds: 1))
                                            .then((value) {
                                          SmartDialog.dismiss();
                                          Map<String, dynamic> result = data;
                                          User user = User();

                                          if (data != null) {
                                            user.token =
                                                result['sendVerificationCode'];
                                            user.setToken();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      VerifyRegisterPage(
                                                    fromLoginPage: true,
                                                    number:
                                                        numberController.text,
                                                    justverify: true,
                                                    email: emailController.text,
                                                    password:
                                                        passwordController.text,
                                                  ),
                                                ));
                                          }
                                        });
                                      },
                                    ),
                                    builder: (runMutation2, result) {
                                      return AlertAction(
                                        title: 'Yes',
                                        onTap: () {
                                          showDialogLoading(context);
                                          runMutation2({
                                            "mobile": numberController.text,
                                          });
                                        },
                                      );
                                    },
                                  ),
                                  AlertAction(
                                    title: 'No',
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            },
                          );
                          break;
                      }
                    });
                    // Your account was Rejected
                  },
                  onCompleted: (data) {
                    Future.delayed(const Duration(seconds: 1)).then((value) {
                      SmartDialog.dismiss();
                      debugPrint(data.toString());
                      if (numberController.text == '') {
                      } else {
                        SharedPref().save('loginnumber', numberController.text);
                      }
                      if (emailController.text == '') {
                      } else {
                        SharedPref().save('loginemail', emailController.text);
                      }
                      debugPrint(data.toString());

                      Future.delayed(const Duration(milliseconds: 750))
                          .then((value) {
                        Map<String, dynamic>? result = data;

                        if (result != null) {
                          AuthUtil.setToken(result['seekerLogin'])
                              .then((value) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (Route<dynamic> route) => false);
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
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/image/Logo108.png',
                            width: mediaWidthSized(context, 3.2),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 40),
                          Text(
                            l.loginWithyour,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'PoppinsRegular',
                              fontSize: indexL == 0
                                  ? mediaWidthSized(context, 28)
                                  : mediaWidthSized(context, 26),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: mediaWidthSized(context, 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          loginWithEmail = !loginWithEmail;
                                        });
                                      },
                                      child: Text(
                                        indexL == 0
                                            ? 'Login with email'
                                            : 'ເຂົ້າສູ່ລະບົບດ້ວຍອີເມລ',
                                        style: TextStyle(
                                          fontFamily: 'PoppinsRegular',
                                          color: AppColors.greyOpacity,
                                          fontSize: indexL == 0
                                              ? mediaWidthSized(context, 30)
                                              : mediaWidthSized(context, 32),
                                        ),
                                      ),
                                    ),
                                    Checkbox(
                                      value: loginWithEmail,
                                      onChanged: (value) {
                                        setState(() {
                                          loginWithEmail = !loginWithEmail;
                                        });
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ),
                              Fade(
                                visible: !loginWithEmail,
                                child: PhoneTextField(
                                  title: l.mobileNumber,
                                  hintText: l.number,
                                  controller: numberController,
                                  disablecontroller: disableController,
                                ),
                              ),
                              Fade(
                                visible: loginWithEmail,
                                child: NormalTextField(
                                  title: indexL == 0 ? 'Email' : 'ອີເມລ',
                                  hintText: indexL == 0 ? 'Email' : 'ອີເມລ',
                                  controller: emailController,
                                  hintIcon: 'envelope',
                                  obscure: false,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 50),
                              NormalTextField(
                                title: l.password,
                                controller: passwordController,
                                obscure: obscure,
                                onSubmitted: (v) {
                                  currentFocus = FocusScope.of(context);

                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }

                                  showDialogLoading(context);
                                  runMutation({
                                    'email': loginWithEmail == true
                                        ? emailController.text
                                        : numberController.text,
                                    'password': passwordController.text
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                    if (obscure) {
                                      obscure = false;
                                    } else {
                                      obscure = true;
                                    }
                                  });
                                },
                                hintIcon: 'eye',
                                hintText: l.password,
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 30),
                              BlueButton(
                                // marginx2: 75,
                                onPressed: () {
                                  currentFocus = FocusScope.of(context);

                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }

                                  showDialogLoading(context);
                                  runMutation({
                                    'email': loginWithEmail == true
                                        ? emailController.text
                                        : numberController.text,
                                    'password': passwordController.text
                                  });
                                },
                                title: l.login,
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      currentFocus = FocusScope.of(context);

                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgetPassword(
                                                  fromLoginPage: true,
                                                )),
                                      );
                                    },
                                    child: Text(
                                      l.forgotpassword,
                                      style: TextStyle(
                                        color: AppColors.greyOpacity,
                                        decoration: TextDecoration.underline,
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: indexL == 0
                                            ? mediaWidthSized(context, 30)
                                            : mediaWidthSized(context, 27),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 40),
                              Row(
                                children: <Widget>[
                                  const Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 60),
                                          child:
                                              Divider(color: AppColors.grey))),
                                  const SizedBox(width: 5),
                                  Text(
                                    l.newUser,
                                    style: TextStyle(
                                      color: AppColors.greyOpacity,
                                      fontFamily: 'PoppinsRegular',
                                      fontSize: mediaWidthSized(context, 30),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.only(right: 60),
                                          child:
                                              Divider(color: AppColors.grey))),
                                ],
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 40),
                              BlueButton(
                                margin: 240,
                                height: 12,
                                onPressed: () {
                                  currentFocus = FocusScope.of(context);

                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage(
                                              isOlduser: false,
                                            )),
                                  );
                                },
                                title: l.register,
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                }
                //     ;
                //   },
                // ),
                ),
          ),
        ),
      ),
    );
  }
}
