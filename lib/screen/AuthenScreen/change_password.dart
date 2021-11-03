import 'package:app/function/pluginfunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:app/api/graphqlapi.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/constant/userdata.dart';
import 'package:app/function/sized.dart';
import 'package:app/screen/widget/alertdialog.dart';
import 'package:app/screen/widget/button.dart';
import 'package:app/screen/widget/input_text_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

bool? forgetpassRoute;

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool alertpassword = false;
  User user = User();
  QueryInfo queryInfo = QueryInfo();
  bool obscurePassword = true;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    user.getPassToken();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil(ModalRoute.withName("/login"));
        return false;
      },
      child: Scaffold(
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              NormalTextField(
                autofocus: false,
                obscure: obscurePassword,
                title: l.newpassword,
                hintIcon: 'eye',
                hintText: l.newpassword,
                controller: controller,
                onChanged: (val) {
                  alertpassword = val.length < 8;
                  setState(() {});
                },
                onTap: () {
                  setState(() {
                    if (obscurePassword) {
                      obscurePassword = false;
                    } else {
                      obscurePassword = true;
                    }
                  });
                },
              ),
              Visibility(
                visible: alertpassword,
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
                height: 20,
              ),
              Mutation(
                options: MutationOptions(
                    onError: (error) {},
                    onCompleted: (data) {
                      SmartDialog.dismiss();
                      Map<String, dynamic>? result = data;
                      if (result != null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertPlainDialog(
                              title: l.successful,
                              color: AppColors.blue,
                              content: l.yourpasswordhasChange,
                              actions: [
                                AlertAction(
                                  title: 'Ok',
                                  onTap: () {
                                    forgetpassRoute = true;
                                    Navigator.of(context).popUntil(
                                        ModalRoute.withName("/login"));
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                    document: gql(queryInfo.changepass)),
                builder: (runMutation, result) {
                  return BlueButton(
                    onPressed: () {
                      if (!alertpassword) {
                        showDialogLoading(context);
                        runMutation({
                          "changePassToken": user.changepassToken,
                          "newPassword": controller.text
                        });
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertPlainDialog(
                              title: l.cannotResetThisPass,
                              content: l.newPassmust,
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
            ],
          ),
        ),
      ),
    );
  }
}
