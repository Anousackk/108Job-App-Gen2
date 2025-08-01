// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_if_null_operators, unnecessary_null_comparison, camel_case_types, unnecessary_null_in_if_null_operators, use_key_in_widget_constructors, unused_field, sort_child_properties_last

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
          style: bodyTextMedium(null, null, FontWeight.bold),
        ),
        // content: Text(
        //   '${widget.contentText}',
        //   style: bodyTextNormal(null,null, null),
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
                style: bodyTextNormal(null, null, null),
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
                  null,
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
                  null,
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

class AlertDialogBtnConfirmCancelBetween extends StatefulWidget {
  const AlertDialogBtnConfirmCancelBetween({
    Key? key,
    this.title,
    this.contentText,
    this.textLeft,
    this.textRight,
    this.colorTilte,
    this.colorTextLeft,
    this.colorTextRight,
    this.borderColorButtonRight,
  }) : super(key: key);
  final String? title;
  final Color? colorTilte,
      colorTextLeft,
      colorTextRight,
      borderColorButtonRight;
  final String? contentText;
  final String? textLeft;
  final String? textRight;

  @override
  State<AlertDialogBtnConfirmCancelBetween> createState() =>
      _AlertDialogBtnConfirmCancelBetweenState();
}

class _AlertDialogBtnConfirmCancelBetweenState
    extends State<AlertDialogBtnConfirmCancelBetween> {
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

        //
        //
        //Title
        title: Container(
          child: Text(
            '${widget.title}',
            style: bodyTextMedium(
                null,
                widget.colorTilte == null ? AppColors.black : widget.colorTilte,
                FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),

        //
        //
        //Content
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: MediaQuery.of(context).size.width,
          child: Text('${widget.contentText}',
              style: bodyTextMaxSmall(null, null, null)
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
                  buttonColor: AppColors.buttonBG,
                  buttonBorderColor: AppColors.borderBG,
                  press: () {
                    Navigator.of(context).pop('Cancel');
                  },
                  text: '${widget.textLeft}',
                  textColor: widget.colorTextLeft == null
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
                  buttonColor: AppColors.buttonWhite,
                  buttonBorderColor: widget.borderColorButtonRight == null
                      ? AppColors.borderDanger
                      : widget.borderColorButtonRight,
                  press: () {
                    Navigator.of(context).pop('Ok');
                  },
                  text: '${widget.textRight}',
                  textColor: widget.colorTextRight == null
                      ? AppColors.fontDark
                      : widget.colorTextRight,
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

//
//
//
//
//
//Alert Success
class CustAlertDialogSuccessBtnConfirm extends StatefulWidget {
  const CustAlertDialogSuccessBtnConfirm({
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
  State<CustAlertDialogSuccessBtnConfirm> createState() =>
      _CustAlertDialogSuccessBtnConfirmState();
}

class _CustAlertDialogSuccessBtnConfirmState
    extends State<CustAlertDialogSuccessBtnConfirm> {
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    // SizedBox(height: MediaQuery.of(context).size.height / 50),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              //
                              //
                              //Title
                              Text(
                                '${widget.title}',
                                style: bodyTextMedium(null,
                                    AppColors.fontSuccess, FontWeight.bold),
                              ),

                              //
                              //
                              //Text
                              Text(
                                '${widget.text}',
                                style: bodyTextNormal(null, null, null),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),

                          //
                          //
                          //Button
                          GestureDetector(
                            onTap: widget.press,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10),
                              decoration: BoxDecoration(
                                color: widget.colorButton == null
                                    ? AppColors.buttonPrimary
                                    : widget.colorButton,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                "${widget.textButton}",
                                style: bodyTextNormal(
                                    null,
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

class CustAlertDialogSuccessWithoutBtn extends StatefulWidget {
  const CustAlertDialogSuccessWithoutBtn({
    Key? key,
    this.contentText,
    this.title,
    this.colorButton,
    this.colorTextButton,
    this.textButton,
    this.boxCircleColor,
    this.iconColor,
    this.strIcon,
  }) : super(key: key);
  final String? strIcon, contentText, textButton;
  final String? title;
  final Color? boxCircleColor, iconColor, colorButton, colorTextButton;

  @override
  State<CustAlertDialogSuccessWithoutBtn> createState() =>
      _CustAlertDialogSuccessWithoutBtnState();
}

class _CustAlertDialogSuccessWithoutBtnState
    extends State<CustAlertDialogSuccessWithoutBtn> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Dialog(
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    // height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderWhite),
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                          ),

                          //
                          //
                          //Title
                          Text(
                            "${widget.title}",
                            style: bodyTextMedium(
                                "NotoSansLaoLoopedBold", null, FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          //
                          //
                          //Text
                          Text(
                            "${widget.contentText}",
                            style: bodyTextMiniMedium(
                                "NotoSansLaoLoopedMedium", null, null),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: widget.boxCircleColor == null
                                ? AppColors.primary200
                                : widget.boxCircleColor),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.strIcon ?? "\uf00c",
                            style: fontAwesomeSolid(
                                null,
                                36,
                                widget.iconColor == null
                                    ? AppColors.primary600
                                    : widget.iconColor,
                                null),
                          ),
                        ),
                      ),
                    ),
                    top: -50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
//
//
//
//
//New Alert Success
class NewVer2CustAlertDialogSuccessBtnConfirm extends StatefulWidget {
  const NewVer2CustAlertDialogSuccessBtnConfirm({
    Key? key,
    this.contentText,
    this.title,
    this.textButton,
    this.press,
    this.buttonColor,
    this.textButtonColor,
    this.boxCircleColor,
    this.iconColor,
    this.widgetBottomColor,
    this.strIcon,
    this.fontFamilyIcon,
  }) : super(key: key);
  final String? strIcon, fontFamilyIcon, title, contentText, textButton;
  final Color? boxCircleColor,
      iconColor,
      buttonColor,
      textButtonColor,
      widgetBottomColor;
  final Function()? press;

  @override
  State<NewVer2CustAlertDialogSuccessBtnConfirm> createState() =>
      _NewVer2CustAlertDialogSuccessBtnConfirmState();
}

class _NewVer2CustAlertDialogSuccessBtnConfirmState
    extends State<NewVer2CustAlertDialogSuccessBtnConfirm> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Dialog(
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    // height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderWhite),
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: SizedBox(
                              height:
                                  30, //15 ຄວາມຫ່າງລະວ່າງ top box alert & bottom circle
                            ),
                          ),

                          //
                          //
                          //Title
                          Text(
                            "${widget.title}",
                            style: bodyTextMedium(
                                "NotoSansLaoLoopedBold", null, FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //
                          //
                          //Text
                          Text(
                            "${widget.contentText}",
                            style: bodyTextMiniMedium(
                                "NotoSansLaoLoopedMedium", null, null),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //
                          //
                          //Button
                          GestureDetector(
                            onTap: widget.press,
                            child: Container(
                              width: 170,
                              height: 50,
                              decoration: BoxDecoration(
                                color: widget.buttonColor == null
                                    ? AppColors.primary200
                                    : widget.buttonColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "${widget.textButton}",
                                  style: bodyTextMaxNormal(
                                      "NotoSansLaoLoopedMedium",
                                      widget.textButtonColor == null
                                          ? AppColors.primary600
                                          : widget.textButtonColor,
                                      null),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: widget.boxCircleColor == null
                                ? AppColors.primary200
                                : widget.boxCircleColor),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.strIcon ?? "\uf00c",
                            style: fontAwesomeSolid(
                                widget.fontFamilyIcon ?? null,
                                36,
                                widget.iconColor == null
                                    ? AppColors.primary600
                                    : widget.iconColor,
                                null),
                          ),
                        ),
                      ),
                    ),
                    top: -50,
                  ),
                  Positioned(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      child: Container(
                        width: 70.w,
                        height: 10,
                        decoration: BoxDecoration(
                            color: widget.widgetBottomColor == null
                                ? AppColors.primary200
                                : widget.widgetBottomColor),
                      ),
                    ),
                    bottom: -10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
//
//
//
//
//Alert Warning
class CustAlertDialogWarningWithoutBtn extends StatefulWidget {
  const CustAlertDialogWarningWithoutBtn({
    Key? key,
    this.contentText,
    this.title,
    this.colorButton,
    this.colorTextButton,
    this.textButton,
    this.boxCircleColor,
    this.iconColor,
    this.strIcon,
    this.fontFamilyIcon,
  }) : super(key: key);
  final String? strIcon, fontFamilyIcon, title, contentText, textButton;

  final Color? boxCircleColor, iconColor, colorButton, colorTextButton;

  @override
  State<CustAlertDialogWarningWithoutBtn> createState() =>
      _CustAlertDialogWarningWithoutBtnState();
}

class _CustAlertDialogWarningWithoutBtnState
    extends State<CustAlertDialogWarningWithoutBtn> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Dialog(
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    // height: 150,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderWhite),
                        borderRadius: BorderRadius.circular(30)),
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                          ),

                          //
                          //
                          //Title
                          Text(
                            "${widget.title}",
                            style: bodyTextMedium(
                                "NotoSansLaoLoopedBold", null, FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          //
                          //
                          //Text
                          Text(
                            "${widget.contentText}",
                            style: bodyTextMiniMedium(
                                "NotoSansLaoLoopedMedium", null, null),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  //
                  //
                  //Box circle with icon
                  Positioned(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color:
                                widget.boxCircleColor ?? AppColors.warning200),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.strIcon ?? "\u0021",
                            style: fontAwesomeSolid(
                                widget.fontFamilyIcon ?? null,
                                36,
                                widget.iconColor == null
                                    ? AppColors.warning600
                                    : widget.iconColor,
                                null),
                          ),
                        ),
                      ),
                    ),
                    top: -50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
//
//
//
//
//New Alert Warning
class NewVer2CustAlertDialogWarningBtnConfirmCancel extends StatefulWidget {
  const NewVer2CustAlertDialogWarningBtnConfirmCancel({
    Key? key,
    this.contentText,
    this.title,
    this.press,
    this.textButtonLeft,
    this.textButtonRight,
    this.boxCircleColor,
    this.iconColor,
    this.titleColor,
    this.textColor,
    this.buttonLeftColor,
    this.buttonRightColor,
    this.textButtonLeftColor,
    this.textButtonRightColor,
    this.widgetBottomColor,
    this.strIcon,
    this.fontFamilyIcon,
  }) : super(key: key);
  final String? strIcon,
      fontFamilyIcon,
      title,
      contentText,
      textButtonLeft,
      textButtonRight;
  final Color? boxCircleColor,
      iconColor,
      titleColor,
      textColor,
      buttonLeftColor,
      buttonRightColor,
      textButtonLeftColor,
      textButtonRightColor,
      widgetBottomColor;
  final Function()? press;

  @override
  State<NewVer2CustAlertDialogWarningBtnConfirmCancel> createState() =>
      _NewVer2CustAlertDialogWarningBtnConfirmCancelState();
}

class _NewVer2CustAlertDialogWarningBtnConfirmCancelState
    extends State<NewVer2CustAlertDialogWarningBtnConfirmCancel> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Dialog(
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    // height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderWhite),
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height:
                                30, //10 ຄວາມຫ່າງລະວ່າງ top box alert & bottom circle
                          ),
                          //
                          //
                          //Title
                          Text(
                            '${widget.title}',
                            style: bodyTextMedium("NotoSansLaoLoopedBold",
                                widget.titleColor ?? null, FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //
                          //
                          //Text
                          Text(
                            "${widget.contentText}",
                            style: bodyTextMiniMedium("NotoSansLaoLoopedMedium",
                                widget.textColor ?? null, null),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //
                          //
                          //Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //
                              //
                              //Button left
                              Expanded(
                                flex: 1,
                                child: Button(
                                  boxHeight: 50,
                                  buttonColor: widget.buttonLeftColor ??
                                      AppColors.buttonBG,
                                  press: () {
                                    Navigator.of(context).pop('Cancel');
                                  },
                                  text: '${widget.textButtonLeft}',
                                  textFontFamily: "NotoSansLaoLoopedMedium",
                                  textColor: widget.textButtonLeftColor == null
                                      ? AppColors.fontDark
                                      : widget.textButtonLeftColor,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              //
                              //
                              //Button right
                              Expanded(
                                flex: 1,
                                child: Button(
                                  boxHeight: 50,
                                  buttonColor: widget.buttonRightColor ??
                                      AppColors.warning600,
                                  press: () {
                                    Navigator.of(context).pop('Ok');
                                  },
                                  text: '${widget.textButtonRight}',
                                  textFontFamily: "NotoSansLaoLoopedMedium",
                                  textColor: widget.textButtonRightColor == null
                                      ? AppColors.fontWhite
                                      : widget.textButtonRightColor,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  //
                  //
                  //Box circle with icon
                  Positioned(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color:
                                widget.boxCircleColor ?? AppColors.warning200),
                        child: Align(
                          alignment: Alignment.center,
                          // child: FaIcon(
                          //   FontAwesomeIcons.exclamation,
                          //   size: 36,
                          //   color: widget.iconColor ?? AppColors.warning600,
                          // ),
                          child: Text(
                            widget.strIcon ?? "\u0021",
                            style: fontAwesomeSolid(
                                widget.fontFamilyIcon ?? null,
                                36,
                                widget.iconColor == null
                                    ? AppColors.warning600
                                    : widget.iconColor,
                                null),
                          ),
                        ),
                      ),
                    ),
                    top: -50,
                  ),

                  //
                  //
                  //Widget bottom
                  Positioned(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      child: Container(
                        width: 70.w,
                        height: 10,
                        decoration: BoxDecoration(
                            color: widget.widgetBottomColor ??
                                AppColors.warning200),
                      ),
                    ),
                    bottom: -10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NewVer3CustAlertDialogWarningPictrueBtnConfirmCancel
    extends StatefulWidget {
  const NewVer3CustAlertDialogWarningPictrueBtnConfirmCancel({
    Key? key,
    this.contentText,
    this.title,
    this.press,
    this.logo,
    this.textButtonLeft,
    this.textButtonRight,
    this.boxCircleBorderColor,
    this.titleColor,
    this.textColor,
    this.buttonLeftColor,
    this.buttonRightColor,
    this.textButtonLeftColor,
    this.textButtonRightColor,
    this.widgetBottomColor,
    this.statusLogo,
  }) : super(key: key);
  final String? logo,
      statusLogo,
      title,
      contentText,
      textButtonLeft,
      textButtonRight;
  final Color? boxCircleBorderColor,
      titleColor,
      textColor,
      buttonLeftColor,
      buttonRightColor,
      textButtonLeftColor,
      textButtonRightColor,
      widgetBottomColor;
  final Function()? press;

  @override
  State<NewVer3CustAlertDialogWarningPictrueBtnConfirmCancel> createState() =>
      _NewVer3CustAlertDialogWarningPictrueBtnConfirmCancelState();
}

class _NewVer3CustAlertDialogWarningPictrueBtnConfirmCancelState
    extends State<NewVer3CustAlertDialogWarningPictrueBtnConfirmCancel> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Dialog(
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    // height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderWhite),
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: SizedBox(
                              height:
                                  30, //15 ຄວາມຫ່າງລະວ່າງ top box alert & bottom circle
                            ),
                          ),
                          //
                          //
                          //Title
                          Text(
                            '${widget.title}',
                            style: bodyTextMedium("NotoSansLaoLoopedBold",
                                widget.titleColor ?? null, FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //
                          //
                          //Text
                          Text(
                            "${widget.contentText}",
                            style: bodyTextMiniMedium("NotoSansLaoLoopedMedium",
                                widget.textColor ?? null, null),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //
                          //
                          //Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //
                              //
                              //Button left
                              Expanded(
                                flex: 1,
                                child: Button(
                                  boxHeight: 50,
                                  buttonColor: widget.buttonLeftColor ??
                                      AppColors.buttonBG,
                                  press: () {
                                    Navigator.of(context).pop('Cancel');
                                  },
                                  text: "${widget.textButtonLeft}",
                                  textFontFamily: "NotoSansLaoLoopedMedium",
                                  textColor: widget.textButtonLeftColor == null
                                      ? AppColors.fontDark
                                      : widget.textButtonLeftColor,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),

                              //
                              //
                              //Button right
                              Expanded(
                                flex: 1,
                                child: Button(
                                  boxHeight: 50,
                                  buttonColor: widget.buttonRightColor ??
                                      AppColors.primary200,
                                  press: () {
                                    Navigator.of(context).pop('Ok');
                                  },
                                  text: "${widget.textButtonRight}",
                                  textFontFamily: "NotoSansLaoLoopedMedium",
                                  textColor: widget.textButtonRightColor == null
                                      ? AppColors.primary600
                                      : widget.textButtonRightColor,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  //
                  //
                  //Box circle logo image
                  Positioned(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        border: Border.all(
                            color: widget.boxCircleBorderColor ??
                                AppColors.primary200,
                            width: 5),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Center(
                            child: widget.statusLogo == "ImageAsset"
                                ? Image.asset(
                                    "${widget.logo}",
                                    fit: BoxFit.contain,
                                  )
                                : Image.network(
                                    "https://storage.googleapis.com/108-bucket/${widget.logo}",
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/image/no-image-available.png',
                                        fit: BoxFit.contain,
                                      ); // Display an error message
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ),
                    top: -50,
                  ),

                  //
                  //
                  //Widget bottom
                  Positioned(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Container(
                        width: 70.w,
                        height: 10,
                        decoration: BoxDecoration(
                            color: widget.widgetBottomColor ??
                                AppColors.primary200),
                      ),
                    ),
                    bottom: -10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewVer4CustAlertDialogWarning3TxtBtnConfirmCancel extends StatefulWidget {
  const NewVer4CustAlertDialogWarning3TxtBtnConfirmCancel({
    Key? key,
    this.contentText,
    this.title,
    this.press,
    this.textButtonLeft,
    this.textButtonRight,
    this.smallText,
    this.buttonLeftColor,
    this.buttonRightColor,
    this.boxCircleColor,
    this.iconColor,
    this.widgetBottomColor,
    this.titleColor,
    this.textButtonLeftColor,
    this.textButtonRightColor,
    this.strIcon,
    this.fontFamilyIcon,
  }) : super(key: key);
  final String? strIcon,
      fontFamilyIcon,
      contentText,
      smallText,
      title,
      textButtonLeft,
      textButtonRight;
  final Color? boxCircleColor,
      titleColor,
      iconColor,
      buttonLeftColor,
      buttonRightColor,
      textButtonLeftColor,
      textButtonRightColor,
      widgetBottomColor;
  final Function()? press;

  @override
  State<NewVer4CustAlertDialogWarning3TxtBtnConfirmCancel> createState() =>
      _NewVer4CustAlertDialogWarning3TxtBtnConfirmCancelState();
}

class _NewVer4CustAlertDialogWarning3TxtBtnConfirmCancelState
    extends State<NewVer4CustAlertDialogWarning3TxtBtnConfirmCancel> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Dialog(
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    // height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderWhite),
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: SizedBox(
                              height:
                                  30, //10 ຄວາມຫ່າງລະວ່າງ top box alert & bottom circle
                            ),
                          ),
                          //
                          //
                          //Title
                          Text(
                            '${widget.title}',
                            style: bodyTextMedium(
                                "NotoSansLaoLoopedBold", null, FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),

                          //
                          //
                          //Small Text
                          Text(
                            "${widget.smallText}",
                            style: bodyTextMinNormal("NotoSansLaoLoopedMedium",
                                AppColors.dark500, null),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //
                          //
                          //Text
                          Text(
                            "${widget.contentText}",
                            style: bodyTextMiniMedium(
                                "NotoSansLaoLoopedMedium", null, null),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //
                          //
                          //Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //
                              //
                              //Button left
                              Expanded(
                                flex: 1,
                                child: Button(
                                  boxHeight: 50,
                                  buttonColor: widget.buttonLeftColor == null
                                      ? AppColors.buttonBG
                                      : widget.buttonLeftColor,
                                  // buttonBorderColor: AppColors.borderBG,
                                  press: () {
                                    Navigator.of(context).pop('Cancel');
                                  },
                                  text: '${widget.textButtonLeft}',
                                  textFontFamily: "NotoSansLaoLoopedMedium",
                                  textColor: widget.textButtonLeftColor == null
                                      ? AppColors.fontDark
                                      : widget.textButtonLeftColor,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),

                              //
                              //
                              //Button right
                              Expanded(
                                flex: 1,
                                child: Button(
                                  boxHeight: 50,
                                  buttonColor: widget.buttonRightColor == null
                                      ? AppColors.warning600
                                      : widget.buttonRightColor,
                                  press: () {
                                    Navigator.of(context).pop('Ok');
                                  },
                                  text: '${widget.textButtonRight}',
                                  textFontFamily: "NotoSansLaoLoopedMedium",
                                  textColor: widget.textButtonRightColor == null
                                      ? AppColors.fontWhite
                                      : widget.textButtonRightColor,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  //
                  //
                  //Box circle icon
                  Positioned(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: widget.boxCircleColor == null
                                ? AppColors.warning200
                                : widget.boxCircleColor),
                        child: Align(
                          alignment: Alignment.center,
                          // child: FaIcon(
                          //   FontAwesomeIcons.exclamation,
                          //   size: 36,
                          //   color: widget.iconColor == null
                          //       ? AppColors.warning600
                          //       : widget.iconColor,
                          // ),
                          child: Text(
                            widget.strIcon ?? "\u0021",
                            style: fontAwesomeSolid(
                                widget.fontFamilyIcon ?? null,
                                36,
                                widget.iconColor == null
                                    ? AppColors.warning600
                                    : widget.iconColor,
                                null),
                          ),
                        ),
                      ),
                    ),
                    top: -50,
                  ),

                  //
                  //
                  //Widget bottom
                  Positioned(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      child: Container(
                        width: 70.w,
                        height: 10,
                        decoration: BoxDecoration(
                            color: widget.widgetBottomColor == null
                                ? AppColors.warning200
                                : widget.widgetBottomColor),
                      ),
                    ),
                    bottom: -10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NewVer5CustAlertDialogWarningBtnConfirm extends StatefulWidget {
  const NewVer5CustAlertDialogWarningBtnConfirm({
    Key? key,
    this.contentText,
    this.title,
    this.colorButton,
    this.colorTextButton,
    this.textButton,
    this.boxCircleColor,
    this.iconColor,
    this.buttonColor,
    this.textButtonColor,
    this.press,
    this.strIcon,
    this.fontFamilyIcon,
  }) : super(key: key);
  final String? strIcon, fontFamilyIcon, title, contentText, textButton;
  final Color? boxCircleColor,
      iconColor,
      colorButton,
      colorTextButton,
      buttonColor,
      textButtonColor;
  final Function()? press;

  @override
  State<NewVer5CustAlertDialogWarningBtnConfirm> createState() =>
      _NewVer5CustAlertDialogWarningBtnConfirmState();
}

class _NewVer5CustAlertDialogWarningBtnConfirmState
    extends State<NewVer5CustAlertDialogWarningBtnConfirm> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Dialog(
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    // height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderWhite),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                          ),

                          //
                          //
                          //Title
                          Text(
                            "${widget.title}",
                            style: bodyTextMedium(
                                "NotoSansLaoLoopedBold", null, FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          //
                          //
                          //Text
                          Text(
                            "${widget.contentText}",
                            style: bodyTextMiniMedium(
                                "NotoSansLaoLoopedMedium", null, null),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //
                          //
                          //Button
                          GestureDetector(
                            onTap: widget.press,
                            child: Container(
                              width: 170,
                              height: 50,
                              decoration: BoxDecoration(
                                color: widget.buttonColor == null
                                    ? AppColors.warning200
                                    : widget.buttonColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "${widget.textButton}",
                                  style: bodyTextMaxNormal(
                                      "NotoSansLaoLoopedMedium",
                                      widget.textButtonColor == null
                                          ? AppColors.warning600
                                          : widget.textButtonColor,
                                      null),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //
                  //
                  //Box circle with icon
                  Positioned(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color:
                                widget.boxCircleColor ?? AppColors.warning200),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.strIcon ?? "\u0021",
                            style: fontAwesomeSolid(
                                widget.fontFamilyIcon ?? null,
                                36,
                                widget.iconColor == null
                                    ? AppColors.warning600
                                    : widget.iconColor,
                                null),
                          ),
                        ),
                      ),
                    ),
                    top: -50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
//
//
//
//
//Alert Error
class CustAlertDialogErrorWithoutBtn extends StatefulWidget {
  const CustAlertDialogErrorWithoutBtn({
    Key? key,
    this.text,
    this.title,
    this.boxCircleColor,
    this.iconColor,
    this.titleColor,
    this.textColor,
    this.strIcon,
    this.fontFamilyIcon,
  }) : super(key: key);
  final String? strIcon, fontFamilyIcon, title, text;
  final Color? boxCircleColor, iconColor, titleColor, textColor;

  @override
  State<CustAlertDialogErrorWithoutBtn> createState() =>
      _CustAlertDialogErrorWithoutBtnState();
}

class _CustAlertDialogErrorWithoutBtnState
    extends State<CustAlertDialogErrorWithoutBtn> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Dialog(
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    // height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderWhite),
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height:
                                30, //10 ຄວາມຫ່າງລະວ່າງ top box alert & bottom circle
                          ),
                          //
                          //
                          //Title
                          Text(
                            '${widget.title}',
                            style: bodyTextMedium(
                                null,
                                widget.titleColor ?? AppColors.fontDanger,
                                FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          //
                          //
                          //Text
                          Text(
                            '${widget.text}',
                            style: bodyTextNormal(
                                null, widget.textColor ?? null, null),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //
                  //
                  //Box circle with icon
                  Positioned(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color:
                                widget.boxCircleColor ?? AppColors.warning200),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.strIcon ?? "\uf00d",
                            style: fontAwesomeSolid(
                                widget.fontFamilyIcon ?? null,
                                36,
                                widget.iconColor == null
                                    ? AppColors.warning600
                                    : widget.iconColor,
                                null),
                          ),
                        ),
                      ),
                    ),
                    top: -50,
                  )
                ],
              ),
            ),
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

class CustAlertLoading extends StatefulWidget {
  const CustAlertLoading({Key? key}) : super(key: key);

  @override
  State<CustAlertLoading> createState() => _CustAlertLoadingState();
}

class _CustAlertLoadingState extends State<CustAlertLoading> {
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
                  style: bodyTextNormal(null, null, null),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomLoadingStackLogo extends StatefulWidget {
  @override
  _CustomLoadingStackLogoState createState() => _CustomLoadingStackLogoState();
}

class _CustomLoadingStackLogoState extends State<CustomLoadingStackLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Repeats the animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          //
          //
          //Center image
          Image.asset(
            "assets/image/Logo108.png", // Replace with your image asset
            width: 50,
            height: 50,
          ),
          //
          //
          //Rotating circle
          Positioned(
            left: 5,
            bottom: 12,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary600, width: 10),
              ),
            ),
          ),
          //
          //
          //Rotating circle
          Positioned(
            right: 10,
            bottom: 15,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cyan600, width: 10),
              ),
            ),
          ),
          //
          //
          //Rotating circle
          Positioned(
            right: 10,
            bottom: 5,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cyan400, width: 10),
              ),
            ),
          ),

          //
          //
          //Rotating circle
          Positioned(
            // left: 0,
            // bottom: 0,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary600, width: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomLoadingLogoCircle extends StatefulWidget {
  @override
  _CustomLoadingLogoCircleState createState() =>
      _CustomLoadingLogoCircleState();
}

class _CustomLoadingLogoCircleState extends State<CustomLoadingLogoCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Time for one full rotation
    )..repeat(); // Repeat the animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          //
          //
          //Box circle
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            width: 150,
            height: 150,
          ),
          //
          //
          //Background box circle color withOpacity
          Positioned(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                shape: BoxShape.circle,
              ),
            ),
          ),
          //
          //
          //image 108job text
          Positioned(
            child: Container(
              child: Image.asset(
                "assets/image/108job-logo-text.png",
                width: 50,
                height: 50,
              ),
            ),
          ),
          //
          //
          //image circle
          Positioned(
            child: RotationTransition(
              turns: _controller,
              child: Image.asset(
                "assets/image/logo-circle.png",
                width: 150,
                height: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
