import 'package:flutter/material.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/sized.dart';

class AlertPlainDialog extends StatelessWidget {
  const AlertPlainDialog(
      {Key? key, this.title, this.content, this.actions, this.color})
      : super(key: key);
  final String? title, content;
  final List<Widget>? actions;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Text(
          "$title",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color ?? Colors.red,
            fontFamily: 'PoppinsSemiBold',
            fontSize: indexL == 0
                ? mediaWidthSized(context, 21)
                : mediaWidthSized(context, 18),
          ),
        ),
        content: Text(
          '$content',
          textAlign: TextAlign.center,
          style: TextStyle(
            // color: Colors.red,
            fontFamily: 'PoppinsMedium',
            fontSize: indexL == 0
                ? mediaWidthSized(context, 27)
                : mediaWidthSized(context, 24),
          ),
        ),
        actions: actions);
  }
}

class AlertAction extends StatelessWidget {
  const AlertAction({Key? key, this.onTap, this.title}) : super(key: key);
  final String? title;
  final GestureTapCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(20),
            child: Text(
              '$title',
              style: TextStyle(
                color: AppColors.blue,
                fontFamily: 'PoppinsSemiBold',
                fontSize: indexL == 0
                    ? mediaWidthSized(context, 27)
                    : mediaWidthSized(context, 24),
              ),
            )));
  }
}
