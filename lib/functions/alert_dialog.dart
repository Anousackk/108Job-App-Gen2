// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_if_null_operators, unnecessary_null_comparison

import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/outlineBorder.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: AlertDialog(
        title: Text(
          '${widget.title}',
          // style: TextStyle(fontSize: 15.sp),
        ),
        content: Text(
          '${widget.contentText}',
          style: bodyTextNormal(null, null),
          // style: TextStyle(fontSize: 10.sp),
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
                  null),
              // style: TextStyle(
              //     fontSize: 10.sp,
              //     color: widget.colorTextLeft == null
              //         ? AppColors.fontGrey
              //         : widget.colorTextLeft),
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
                  null),
              // style: TextStyle(
              //     fontSize: 10.sp,
              //     color: widget.colorTextRight == null
              //         ? AppColors.primary
              //         : widget.colorTextRight),
            ),
          ),
        ],
      ),
    );
  }
}

class AlertDialogOkCancelBetween extends StatefulWidget {
  const AlertDialogOkCancelBetween({
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
  State<AlertDialogOkCancelBetween> createState() =>
      _AlertDialogOkCancelBetweenState();
}

class _AlertDialogOkCancelBetweenState
    extends State<AlertDialogOkCancelBetween> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: AlertDialog(
        title: Text(
          '${widget.title}',
          style: TextStyle(
              fontSize: 15.sp,
              color: widget.colorTilte == null
                  ? AppColors.black
                  : widget.colorTilte),
          // textAlign: TextAlign.center,
        ),
        content: Text(
          '${widget.contentText}',
          style: TextStyle(fontSize: 10.sp),
          // textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                          ? AppColors.primary
                          : widget.colorTextRight),
                ),
              ),
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
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: AlertDialog(
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
// Future<dynamic> CustomAlertDialogSuccess(BuildContext context) {
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

class CustomAlertDialogSuccess extends StatefulWidget {
  const CustomAlertDialogSuccess({
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
  State<CustomAlertDialogSuccess> createState() =>
      _CustomAlertDialogSuccessState();
}

class _CustomAlertDialogSuccessState extends State<CustomAlertDialogSuccess> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.5.w),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              height: 50.w,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(2.5.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(height: 2.h),
                    SizedBox(height: MediaQuery.of(context).size.height / 25),
                    Column(
                      children: [
                        Text(
                          '${widget.title}',
                          style: bodyTextMedium(
                              AppColors.fontSuccess, FontWeight.bold),
                          // style:
                          //     TextStyle(fontSize: 15.sp, color: AppColors.green),
                        ),
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

                    GestureDetector(
                      onTap: widget.press,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: widget.colorButton == null
                              ? AppColors.buttonPrimary
                              : widget.colorButton,
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        child: Text(
                          "${widget.textButton}",
                          style: bodyTextNormal(
                              widget.colorTextButton == null
                                  ? AppColors.white
                                  : widget.colorTextButton,
                              null),
                          // style: TextStyle(
                          //   fontSize: 10.sp,
                          //   color: widget.colorTextButton == null
                          //       ? AppColors.white
                          //       : widget.colorTextButton,
                          // ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              child: CircleAvatar(
                backgroundColor: AppColors.green,
                radius: 12.w,
                child: Text(
                  'check',
                  style: lIcon('FontAwesomePro-Solid', AppColors.fontWhite),
                  // style: TextStyle(
                  //     fontFamily: 'FontAwesomePro-Solid',
                  //     fontSize: 25.sp,
                  //     color: AppColors.white),
                ),
              ),
              top: -12.w,
            )
          ],
        ),
      ),
    );
  }
}

class CustomAlertDialogWarning extends StatefulWidget {
  const CustomAlertDialogWarning({
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
  State<CustomAlertDialogWarning> createState() =>
      _CustomAlertDialogWarningState();
}

class _CustomAlertDialogWarningState extends State<CustomAlertDialogWarning> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.5.w),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              height: 50.w,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(2.5.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(height: 2.h),
                    SizedBox(height: MediaQuery.of(context).size.height / 25),
                    Column(
                      children: [
                        Text(
                          '${widget.title}',
                          style: bodyTextMedium(
                              AppColors.fontInfo, FontWeight.bold),
                          // style: TextStyle(
                          //     fontSize: 15.sp, color: AppColors.warning),
                        ),
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
                    GestureDetector(
                      onTap: widget.press,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: widget.colorButton == null
                              ? AppColors.buttonPrimary
                              : widget.colorButton,
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        child: Text(
                          "${widget.textButton}",
                          style: bodyTextNormal(
                              widget.colorTextButton == null
                                  ? AppColors.white
                                  : widget.colorTextButton,
                              null),
                          // style: TextStyle(
                          //   fontSize: 10.sp,
                          //   color: widget.colorTextButton == null
                          //       ? AppColors.white
                          //       : widget.colorTextButton,
                          // ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              child: CircleAvatar(
                backgroundColor: AppColors.warning,
                radius: 12.w,
                child: Text(
                  'exclamation',
                  style: lIcon('FontAwesomePro-Solid', AppColors.fontWhite),
                  // style: TextStyle(
                  //     fontFamily: 'FontAwesomePro-Solid',
                  //     fontSize: 25.sp,
                  //     color: AppColors.white),
                ),
              ),
              top: -12.w,
            )
          ],
        ),
      ),
    );
  }
}

class CustomAlertDialogError extends StatelessWidget {
  const CustomAlertDialogError({
    Key? key,
    this.text,
    this.title,
  }) : super(key: key);
  final String? text;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.5.w),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              height: 50.w,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 20),
                    Text(
                      '$title',
                      style: TextStyle(fontSize: 6.w, color: AppColors.red),
                    ),
                    Text(
                      '$text',
                      style: TextStyle(fontSize: 3.5.w),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 20),
                    // SimpleButton(
                    //   press: () {
                    //     Navigator.of(context).pop(true);
                    //   },
                    //   text: "OK",
                    // )
                  ],
                ),
              ),
            ),
            Positioned(
              child: CircleAvatar(
                backgroundColor: AppColors.red,
                radius: 12.w,
                child: Text(
                  'xmark',
                  style: lIcon('FontAwesomePro-Solid', AppColors.fontWhite),
                  // style: TextStyle(
                  //     fontFamily: 'FontAwesomePro-Solid',
                  //     fontSize: 25.sp,
                  //     color: AppColors.white),
                ),
              ),
              top: -12.w,
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
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: AlertDialog(
          content: Container(
            height: 50.w,
            decoration:
                boxDecoration(AppColors.white, AppColors.white.withOpacity(0)),
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
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: AlertDialog(
        content: Container(
          height: 25.w,
          decoration:
              boxDecoration(AppColors.white, AppColors.white.withOpacity(0)),
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
