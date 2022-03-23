import 'dart:io';

import 'package:app/constant/registerdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/graphqlapi.dart';
import '../../constant/colors.dart';
import '../../constant/languagedemo.dart';
import '../../function/pluginfunction.dart';
import '../../function/sized.dart';
import '../widget/alertdialog.dart';
import '../widget/avatar.dart';
import '../widget/input_text_field.dart';
import 'package:validators/validators.dart';

import '../widget/resume_tab.dart';
import 'register_widget_input.dart';

class NewRegisterPage extends StatefulWidget {
  const NewRegisterPage({Key? key, required this.isOlduser}) : super(key: key);
  final bool isOlduser;
  @override
  State<NewRegisterPage> createState() => _NewRegisterPageState();
}

class _NewRegisterPageState extends State<NewRegisterPage> {
  late ScrollController scroll;

  bool? isLoading = false;
  File? picture;
  bool? alertprofile = false,
      alertemail = false,
      alertnumber = false,
      alertpassword = false,
      alertfullname = false;
  Register register = Register();
  bool? obscurePassword = true;
  ImagePicker picker = ImagePicker();
  QueryInfo queryInfo = QueryInfo();
  TextEditingController emailControl = TextEditingController();
  TextEditingController numberControl = TextEditingController();
  TextEditingController passwordControl = TextEditingController();
  @override
  void initState() {
    scroll = ScrollController();

    super.initState();
  }

//////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  Future selectImage(ImageSource imageSource) async {
    final img = await picker.pickImage(source: imageSource);
    if (img != null) {
      int sizeInBytes = File(img.path).lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      if (sizeInMb > 15) {
        showDialog<String>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertPlainDialog(
                title: l.cannotUpload,
                actions: [
                  AlertAction(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: l.ok,
                  )
                ],
                content: l.thisImageSizelarge,
              );
            });
      } else {
        setState(() {
          picture = File(img.path);
          alertprofile = picture == null;
        });
      }
    }
  }

  Future selectpicturefrom(BuildContext context, {onPress1, onPress2}) async {
    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(l.choosepic,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'PoppinsSemiBold')),
            cancelButton: CupertinoActionSheetAction(
              child: Text(l.cancel,
                  style: const TextStyle(
                    // fontSize: 20,
                    color: Colors.red,
                    // fontFamily: 'PoppinsSemiBold'
                  )),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              CupertinoActionSheetAction(
                  onPressed: onPress1,
                  child: Text(l.camera,
                      style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.blue,
                          fontFamily: 'PoppinsMedium'))),
              CupertinoActionSheetAction(
                  onPressed: onPress2,
                  child: Text(l.gallery,
                      style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.blue,
                          fontFamily: 'PoppinsMedium'))),
            ],
          );
        });
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
///////////////////

  FocusScopeNode currentFocus = FocusScopeNode();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isLoading == true) {
          return false;
        } else {
          return true;
        }
      },
      child: Container(
        color: AppColors.white,
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Stack(
              children: [
                Scaffold(
                  backgroundColor: AppColors.white,
                  appBar: PreferredSize(
                      child: AppBar(
                        backgroundColor: AppColors.white,
                        iconTheme: const IconThemeData(
                          color: AppColors.grey,
                        ),
                        elevation: 0,
                      ),
                      preferredSize: Size.fromHeight(appbarsize(context))),
                  body: SingleChildScrollView(
                    controller: scroll,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width),
                          const SizedBox(
                            height: 20,
                          ),
                          Avatar(
                            ontap: () {
                              currentFocus = FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              selectpicturefrom(
                                context,
                                onPress1: () {
                                  selectImage(ImageSource.camera);

                                  Navigator.pop(context);
                                },
                                onPress2: () {
                                  selectImage(ImageSource.gallery);
                                  Navigator.pop(context, 'Cancel');
                                },
                              ).then((value) {
                                setState(() {});
                              });
                            },
                            picture: picture,
                          ),
                          Visibility(
                            visible: alertprofile!,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(l.enterProfile,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize:
                                              mediaWidthSized(context, 40),
                                          color: Colors.red,
                                          fontFamily: 'PoppinsRegular')),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Visibility(
                            visible: !widget.isOlduser,
                            child: Column(
                              children: [
                                TextTitle(
                                  title: l.loginConfidential,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                NormalTextField(
                                  autofocus: false,
                                  onChanged: (value) {
                                    register.email = value;
                                    alertemail = register.email == null ||
                                        !(isEmail(register.email!));

                                    setState(() {});
                                  },
                                  obscure: false,
                                  controller: emailControl,
                                  hintIcon: 'envelope',
                                  hintText: l.emailAdd,
                                  title: l.email,
                                ),
                                Visibility(
                                  visible: alertemail!,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Text(l.entervalidEmail,
                                          style: TextStyle(
                                              fontSize:
                                                  mediaWidthSized(context, 40),
                                              color: Colors.red,
                                              fontFamily: 'PoppinsRegular')),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                PhoneTextField(
                                  title: l.mobileNumber,
                                  hintText: l.number,
                                  onChanged: (value) {
                                    register.number = value;
                                    alertnumber = register.number == null ||
                                        register.number!.length != 8;

                                    setState(() {});
                                  },
                                  controller: numberControl,
                                ),
                                Visibility(
                                  visible: alertnumber!,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Text(l.numberMust,
                                          style: TextStyle(
                                              fontSize:
                                                  mediaWidthSized(context, 40),
                                              color: Colors.red,
                                              fontFamily: 'PoppinsRegular')),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                NormalTextField(
                                  autofocus: false,
                                  title: l.password,
                                  obscure: obscurePassword,
                                  onTap: () {
                                    setState(() {
                                      if (obscurePassword!) {
                                        obscurePassword = false;
                                      } else {
                                        obscurePassword = true;
                                      }
                                    });
                                  },
                                  hintIcon: 'eye',
                                  hintText: l.password,
                                  onChanged: (value) {
                                    register.password = value;
                                    alertpassword = register.password == null ||
                                        value.length < 8;
                                    setState(() {});
                                  },
                                  controller: passwordControl,
                                ),
                                Visibility(
                                  visible: alertpassword!,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Text(l.passwordMust,
                                          style: TextStyle(
                                              fontSize:
                                                  mediaWidthSized(context, 40),
                                              color: Colors.red,
                                              fontFamily: 'PoppinsRegular')),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextTitle(
                                  title: l.personalinfo,
                                ),
                                WidgetTabInfo(
                                  alertvisible: alertfullname,
                                  alertText: l.enterValidfulname,
                                  onTap: () {
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const InputFullName(true)),
                                    ).then((value) {
                                      register.getFirstName();
                                      register.getLastName().then((value) {
                                        alertfullname = isEmptyString(
                                                register.firstname) ||
                                            isEmptyString(register.lastname);
                                        setState(() {});
                                      });
                                    });
                                  },
                                  icon: 'chevron-right ',
                                  header: l.fullname,
                                  showField: (!isEmptyString(
                                              register.firstname) &&
                                          !isEmptyString(register.firstname))
                                      ? '${register.firstname} ${register.lastname}'
                                      : !isEmptyString(register.firstname)
                                          ? '${register.firstname}'
                                          : !isEmptyString(register.lastname)
                                              ? '${register.lastname}'
                                              : null,
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
