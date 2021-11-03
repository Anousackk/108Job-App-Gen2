import 'package:app/function/pluginfunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/constant/userdata.dart';
import 'package:app/function/sized.dart';
import 'package:app/screen/AuthenScreen/verify_register_page.dart';
import 'package:app/screen/widget/alertdialog.dart';
import 'package:app/screen/widget/button.dart';
import 'package:app/screen/widget/input_text_field.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  QueryInfo queryInfo = QueryInfo();
  TextEditingController disable = TextEditingController();
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    disable.text = '020';

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil(ModalRoute.withName("/login"));
        return false;
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
                l.forgotpassword,
                style: TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    color: Colors.black,
                    fontSize: appbarTextSize(context)),
              ),
              // Text('Recipes',style: TextStyle(),),
              // elevation: 0,
            ),
            preferredSize: Size.fromHeight(appbarsize(context))),
        body: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width / 20,
                ),
                Text(
                  'mobile-android',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 3.5,
                      color: AppColors.blue,
                      fontFamily: 'FontAwesomeProLight'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 25,
                ),
                // Row(
                //   children: [
                //     SizedBox(
                //       width: 20,
                //     ),
                Text(
                  l.enterYourNumber,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.greyOpacity,
                    fontFamily: 'PoppinsRegular',
                    fontSize: MediaQuery.of(context).size.width / 25,
                  ),
                ),
                //   ],
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 10,
                ),
                PhoneTextField(
                  title: l.mobileNumber,
                  hintText: l.number,
                  disablecontroller: disable,
                  controller: controller,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 25,
                ),
                Mutation(
                  options: MutationOptions(
                    onError: (error) {
                      if (error?.graphqlErrors[0].message.toString() ==
                          'Mobile does not exist: Undefined location') {
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
                              content: 'Phone number does not exist',
                            );
                          },
                        );
                      }
                    },
                    document: gql(queryInfo.sendOTP),
                    onCompleted: (data) {
                      Map<String, dynamic> result = data;
                      User user = User();
                      SmartDialog.dismiss();
                      Future.delayed(const Duration(milliseconds: 50))
                          .then((value) {
                        if (data != null) {
                          user.token = result['sendVerificationCode'];
                          user.setToken();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerifyRegisterPage(
                                  number: controller.text,
                                  justverify: false,
                                ),
                              ));
                        }
                      });
                    },
                  ),
                  builder: (runMutation, result) {
                    return BlueButton(
                      onPressed: () {
                        if (controller.text.length == 8) {
                          showDialogLoading(context);
                          runMutation({
                            "mobile": controller.text,
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertPlainDialog(
                                title: l.wrongmobile,
                                actions: [
                                  AlertAction(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    title: 'Ok',
                                  )
                                ],
                                content: l.numberMust,
                              );
                            },
                          );
                        }
                      },
                      title: l.confirmMATION,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
