// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_if_null_operators, unnecessary_null_comparison

import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

BoxDecoration boxDecorationAlert(Color color) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(2.5.w),
    color: color,
  );
}

class SimpleAlertDialog extends StatefulWidget {
  const SimpleAlertDialog({
    Key? key,
    this.title,
    this.contentText,
    this.textLeft,
    this.textRight,
    this.colorTextLeft,
    this.colorTextRight,
  }) : super(key: key);
  final String? title;
  final String? contentText;
  final String? textLeft;
  final String? textRight;
  final Color? colorTextLeft, colorTextRight;

  @override
  State<SimpleAlertDialog> createState() => _SimpleAlertDialogState();
}

class _SimpleAlertDialogState extends State<SimpleAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: AlertDialog(
        backgroundColor: AppColors.background,
        // titlePadding: EdgeInsets.zero,
        // contentPadding: EdgeInsets.zero,
        // insetPadding: EdgeInsets.zero,
        // contentPadding: EdgeInsets.zero,
        title: Text(
          '${widget.title}',
          style: bodyTextMedium(null, FontWeight.bold),
        ),
        // content: Text(
        //   '${widget.contentText}',
        //   style: bodyTextNormal(null, null),
        // ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('This is a custom AlertDialog.'),
            // SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                '${widget.contentText}',
                style: bodyTextNormal(null, null),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop('Cancel');
            },
            child: Text(
              '${widget.textLeft}',
              style: bodyTextNormal(
                  widget.colorTextLeft == null
                      ? AppColors.fontGrey
                      : widget.colorTextLeft,
                  FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop('Ok');
            },
            child: Text(
              '${widget.textRight}',
              style: bodyTextNormal(
                  widget.colorTextRight == null
                      ? AppColors.primary
                      : widget.colorTextRight,
                  FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class AlertDialogButtonConfirmCancelBetween extends StatefulWidget {
  const AlertDialogButtonConfirmCancelBetween({
    Key? key,
    this.title,
    this.contentText,
    this.textLeft,
    this.textRight,
    this.colorTilte,
    this.colorTextLeft,
    this.colorTextRight,
  }) : super(key: key);
  final String? title;
  final Color? colorTilte, colorTextLeft, colorTextRight;
  final String? contentText;
  final String? textLeft;
  final String? textRight;

  @override
  State<AlertDialogButtonConfirmCancelBetween> createState() =>
      _AlertDialogButtonConfirmCancelBetweenState();
}

class _AlertDialogButtonConfirmCancelBetweenState
    extends State<AlertDialogButtonConfirmCancelBetween> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: AlertDialog(
        //
        //
        // titlePadding: EdgeInsets.zero,
        // contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.all(20),
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        //contentPadding: EdgeInsets.zero,

        //
        //
        //Title
        title: Container(
          child: Text(
            '${widget.title}',
            style: bodyTextMedium(
                widget.colorTilte == null ? AppColors.black : widget.colorTilte,
                FontWeight.bold),
            // textAlign: TextAlign.center,
          ),
        ),

        //
        //
        //Content
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: MediaQuery.of(context).size.width,
          child: Text(
            '${widget.contentText}',
            style: TextStyle(fontSize: 10.sp),
            // textAlign: TextAlign.center,
          ),
        ),

        //
        //
        //Action
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Button(
                  colorButton: AppColors.buttonBG,
                  buttonBorderColor: AppColors.borderBG,
                  press: () {
                    Navigator.of(context).pop('Cancel');
                  },
                  text: '${widget.textLeft}',
                  colorText: widget.colorTextLeft == null
                      ? AppColors.fontGrey
                      : widget.colorTextLeft,
                ),
              ),

              SizedBox(
                width: 10,
              ),

              Expanded(
                flex: 1,
                child: Button(
                  colorButton: AppColors.buttonWhite,
                  buttonBorderColor: AppColors.borderDanger,
                  press: () {
                    Navigator.of(context).pop('Ok');
                  },
                  text: '${widget.textRight}',
                  colorText: widget.colorTextRight == null
                      ? AppColors.fontDark
                      : widget.colorTextRight,
                ),
              ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).pop('Cancel');
              //   },
              //   child: Text(
              //     '${widget.textLeft}',
              //     style: TextStyle(
              //         fontSize: 10.sp,
              //         color: widget.colorTextLeft == null
              //             ? AppColors.fontGrey
              //             : widget.colorTextLeft),
              //   ),
              // ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).pop('Ok');
              //   },
              //   child: Text(
              //     '${widget.textRight}',
              //     style: TextStyle(
              //         fontSize: 10.sp,
              //         color: widget.colorTextRight == null
              //             ? AppColors.primary
              //             : widget.colorTextRight),
              //   ),
              // ),
            ],
          )
        ],
      ),
    );
  }
}

class CupertinoAlertDialogOkCancel extends StatefulWidget {
  const CupertinoAlertDialogOkCancel({
    Key? key,
    this.title,
    this.contentText,
    this.textLeft,
    this.textRight,
    this.colorTilte,
    this.colorTextLeft,
    this.colorTextRight,
  }) : super(key: key);
  final String? title;
  final Color? colorTilte, colorTextLeft, colorTextRight;
  final String? contentText;
  final String? textLeft;
  final String? textRight;

  @override
  State<CupertinoAlertDialogOkCancel> createState() =>
      _CupertinoAlertDialogOkCancelState();
}

class _CupertinoAlertDialogOkCancelState
    extends State<CupertinoAlertDialogOkCancel> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: CupertinoAlertDialog(
        title: Text(
          '${widget.title}',
          style: TextStyle(
              fontSize: 15.sp,
              color: widget.colorTilte == null
                  ? AppColors.black
                  : widget.colorTilte),
          textAlign: TextAlign.center,
        ),
        content: Text(
          '${widget.contentText}',
          style: TextStyle(fontSize: 10.sp),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop('Cancel');
            },
            child: Text(
              '${widget.textLeft}',
              style: TextStyle(
                  fontSize: 10.sp,
                  color: widget.colorTextLeft == null
                      ? AppColors.fontGrey
                      : widget.colorTextLeft),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop('Ok');
            },
            child: Text(
              '${widget.textRight}',
              style: TextStyle(
                  fontSize: 10.sp,
                  color: widget.colorTextRight == null
                      ? AppColors.fontPrimary
                      : widget.colorTextRight),
            ),
          ),
        ],
      ),
    );
  }
}

class CupertinoAlertDialogOk extends StatefulWidget {
  const CupertinoAlertDialogOk({
    Key? key,
    this.title,
    this.contentText,
    this.text,
    this.colorTilte,
    this.colorText,
  }) : super(key: key);
  final String? title;
  final Color? colorTilte, colorText;
  final String? contentText;
  final String? text;

  @override
  State<CupertinoAlertDialogOk> createState() => _CupertinoAlertDialogOkState();
}

class _CupertinoAlertDialogOkState extends State<CupertinoAlertDialogOk> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: CupertinoAlertDialog(
        title: Text(
          '${widget.title}',
          style: TextStyle(
              fontSize: 15.sp,
              color: widget.colorTilte == null
                  ? AppColors.black
                  : widget.colorTilte),
        ),
        content: Text(
          '${widget.contentText}',
          style: TextStyle(fontSize: 10.sp),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop('Ok');
            },
            child: Text(
              '${widget.text}',
              style: TextStyle(
                  fontSize: 10.sp,
                  color: widget.colorText == null
                      ? AppColors.fontPrimary
                      : widget.colorText),
            ),
          ),
        ],
      ),
    );
  }
}

class AlertDialogBoxDecoration extends StatefulWidget {
  const AlertDialogBoxDecoration({
    Key? key,
    this.title,
    this.contentText,
    this.textLeft,
    this.textRight,
    this.colorTilte,
    this.content,
    this.pressRight,
    this.pressLeft,
    this.colorTextLeft,
    this.colorTextRight,
  }) : super(key: key);
  final String? title;
  final Color? colorTilte, colorTextLeft, colorTextRight;
  final String? contentText;
  final String? textLeft;
  final String? textRight;
  final Widget? content;
  final Function()? pressRight, pressLeft;

  @override
  State<AlertDialogBoxDecoration> createState() =>
      _AlertDialogBoxDecorationState();
}

class _AlertDialogBoxDecorationState extends State<AlertDialogBoxDecoration> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        title: Text(
          '${widget.title}',
          style: TextStyle(
              fontSize: 15.sp,
              color: widget.colorTilte == null
                  ? AppColors.black
                  : widget.colorTilte),
        ),
        insetPadding: EdgeInsets.zero,
        content: widget.content,
        actions: [
          TextButton(
            onPressed: widget.pressLeft,
            child: Text(
              '${widget.textLeft}',
              style: TextStyle(
                  fontSize: 10.sp,
                  color: widget.colorTextLeft == null
                      ? AppColors.fontGrey
                      : widget.colorTextLeft),
            ),
          ),
          TextButton(
            onPressed: widget.pressRight,
            child: Text(
              '${widget.textRight}',
              style: TextStyle(
                  fontSize: 10.sp,
                  color: widget.colorTextRight == null
                      ? AppColors.primary
                      : widget.colorTextRight),
            ),
          )
        ],
      ),
    );
  }
}
// Future<dynamic> CustomAlertDialogSuccessButtonConfirm(BuildContext context) {
//   return showDialog(
//       context: context,
//       builder: (context) {
//         Future.delayed(Duration(seconds: 1), () {
//           Navigator.of(context).pop(true);
//         });
//         return AlertDialog(
//           title: Text(
//             'Success',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: AppColors.green),
//           ),
//         );
//       });
// }

class CustomAlertDialogSuccessButtonConfirm extends StatefulWidget {
  const CustomAlertDialogSuccessButtonConfirm({
    Key? key,
    this.text,
    this.title,
    this.textButton,
    this.press,
    this.colorButton,
    this.colorTextButton,
  }) : super(key: key);
  final String? text, title, textButton;
  final Color? colorButton, colorTextButton;
  final Function()? press;

  @override
  State<CustomAlertDialogSuccessButtonConfirm> createState() =>
      _CustomAlertDialogSuccessButtonConfirmState();
}

class _CustomAlertDialogSuccessButtonConfirmState
    extends State<CustomAlertDialogSuccessButtonConfirm> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Dialog(
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              height: 220,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(),
                    // SizedBox(height: MediaQuery.of(context).size.height / 50),

                    Column(
                      children: [
                        //
                        //
                        //Title
                        Text(
                          '${widget.title}',
                          style: bodyTextMedium(
                              AppColors.fontSuccess, FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),

                        //
                        //
                        //Text
                        Text(
                          '${widget.text}',
                          style: bodyTextNormal(null, null),
                          textAlign: TextAlign.center,
                          // style: TextStyle(fontSize: 10.sp),
                        ),
                      ],
                    ),

                    // SizedBox(
                    //   width: 40.w,
                    //   child: Button(
                    //     press: widget.press,
                    //     text: "${widget.textButton}",
                    //   ),
                    // )

                    //
                    //
                    //Button
                    GestureDetector(
                      onTap: widget.press,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        decoration: BoxDecoration(
                          color: widget.colorButton == null
                              ? AppColors.buttonPrimary
                              : widget.colorButton,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          "${widget.textButton}",
                          style: bodyTextNormal(
                              widget.colorTextButton == null
                                  ? AppColors.white
                                  : widget.colorTextButton,
                              null),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              child: CircleAvatar(
                backgroundColor: AppColors.lightGreen,
                radius: 40,
                child: FaIcon(
                  FontAwesomeIcons.check,
                  size: IconSize.lIcon,
                  color: AppColors.iconSuccess,
                ),
              ),
              top: -40,
            )
          ],
        ),
      ),
    );
  }
}

class CustomAlertDialogWarningWithoutButton extends StatefulWidget {
  const CustomAlertDialogWarningWithoutButton({
    Key? key,
    this.text,
    this.title,
    this.press,
    this.colorButton,
    this.colorTextButton,
    this.textButton,
  }) : super(key: key);
  final String? text, textButton;
  final String? title;
  final Color? colorButton, colorTextButton;
  final Function()? press;

  @override
  State<CustomAlertDialogWarningWithoutButton> createState() =>
      _CustomAlertDialogWarningWithoutButtonState();
}

class _CustomAlertDialogWarningWithoutButtonState
    extends State<CustomAlertDialogWarningWithoutButton> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Dialog(
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${widget.title}',
                      style:
                          bodyTextMedium(AppColors.fontWaring, FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${widget.text}',
                      style: bodyTextNormal(null, null),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              child: CircleAvatar(
                backgroundColor: AppColors.lightOrange,
                radius: 40,
                // child: Text(
                //   'exclamation',
                //   style: lIcon('FontAwesomePro-Solid', AppColors.fontWhite),
                // ),
                child: FaIcon(
                  FontAwesomeIcons.exclamation,
                  size: IconSize.lIcon,
                  color: AppColors.iconWarning,
                ),
              ),
              top: -40,
            )
          ],
        ),
      ),
    );
  }
}

class newAlertDialogWarningConfirmCancelBetween extends StatefulWidget {
  const newAlertDialogWarningConfirmCancelBetween({
    Key? key,
    this.text,
    this.title,
    this.press,
    this.colorButton,
    this.textTop,
    this.textLeft,
    this.textRight,
    this.colorTilte,
    this.colorTextLeft,
    this.colorTextRight,
  }) : super(key: key);

  final String? textTop, text, title, textLeft, textRight;
  final Color? colorButton, colorTilte, colorTextLeft, colorTextRight;
  final Function()? press;

  @override
  State<newAlertDialogWarningConfirmCancelBetween> createState() =>
      _newAlertDialogWarningConfirmCancelBetweenState();
}

class _newAlertDialogWarningConfirmCancelBetweenState
    extends State<newAlertDialogWarningConfirmCancelBetween> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Dialog(
        backgroundColor: AppColors.backgroundWhite,
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              height: 260,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(),
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        //
                        //
                        //TextTop
                        Text(
                          '${widget.textTop}',
                          style: bodyTextNormal(null, null),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        //
                        //
                        //Title
                        Text(
                          '${widget.title}',
                          style: bodyTextMedium(
                              AppColors.fontPrimary, FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        //
                        //
                        //Text
                        Text(
                          '${widget.text}',
                          style: bodyTextNormal(null, null),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    //
                    //
                    //Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Button(
                            colorButton: AppColors.buttonBG,
                            buttonBorderColor: AppColors.borderBG,
                            press: () {
                              Navigator.of(context).pop('Cancel');
                            },
                            text: '${widget.textLeft}',
                            colorText: widget.colorTextLeft == null
                                ? AppColors.fontDark
                                : widget.colorTextLeft,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: Button(
                            colorButton: AppColors.buttonPrimary,
                            buttonBorderColor: AppColors.borderPrimary,
                            press: () {
                              Navigator.of(context).pop('Ok');
                            },
                            text: '${widget.textRight}',
                            colorText: widget.colorTextRight == null
                                ? AppColors.fontWhite
                                : widget.colorTextRight,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              child: CircleAvatar(
                backgroundColor: AppColors.lightOrange,
                radius: 40,
                child: FaIcon(
                  FontAwesomeIcons.ban,
                  size: IconSize.lIcon,
                  color: AppColors.iconWarning,
                ),
              ),
              top: -40,
            )
          ],
        ),
      ),
    );
  }
}

class CustomAlertDialogErrorWithoutButton extends StatefulWidget {
  const CustomAlertDialogErrorWithoutButton({
    Key? key,
    this.text,
    this.title,
  }) : super(key: key);
  final String? text;
  final String? title;

  @override
  State<CustomAlertDialogErrorWithoutButton> createState() =>
      _CustomAlertDialogErrorWithoutButtonState();
}

class _CustomAlertDialogErrorWithoutButtonState
    extends State<CustomAlertDialogErrorWithoutButton> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Dialog(
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${widget.title}',
                      style:
                          bodyTextMedium(AppColors.fontDanger, FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${widget.text}',
                      style: bodyTextNormal(null, null),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              child: CircleAvatar(
                backgroundColor: AppColors.red,
                radius: 40,
                child: FaIcon(
                  FontAwesomeIcons.xmark,
                  size: IconSize.lIcon,
                  color: AppColors.iconLight,
                ),
                // child: Text(
                //   'xmark',
                //   style: lIcon('FontAwesomePro-Solid', AppColors.fontWhite),
                // ),
              ),
              top: -40,
            )
          ],
        ),
      ),
    );
  }
}

Future<dynamic> CustomAlertDialogLoading(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      // Future.delayed(Duration(seconds: 2), () {
      //   Navigator.of(context).pop(true);
      // });
      return MediaQuery(
        data:
            MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
        child: AlertDialog(
          content: Container(
            height: 50.w,
            decoration: boxDecoration(
                null, AppColors.white, AppColors.white.withOpacity(0), null),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 5.w,
                ),
                Container(
                  child: Text(
                    'Please wait...',
                    // textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 3.5.w),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

class CustomAlertLoading extends StatefulWidget {
  const CustomAlertLoading({Key? key}) : super(key: key);

  @override
  State<CustomAlertLoading> createState() => _CustomAlertLoadingState();
}

class _CustomAlertLoadingState extends State<CustomAlertLoading> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: AlertDialog(
        backgroundColor: AppColors.backgroundWhite,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        // insetPadding: EdgeInsets.zero,
        content: Container(
          height: 25.w,
          decoration: boxDecoration(null, AppColors.backgroundWhite,
              AppColors.borderWhite.withOpacity(0), null),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 5.w,
              ),
              Container(
                child: Text(
                  // 'ກະລຸນາລໍຖ້າ...',
                  'waiting'.tr,
                  // textAlign: TextAlign.center,
                  style: bodyTextNormal(null, null),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
