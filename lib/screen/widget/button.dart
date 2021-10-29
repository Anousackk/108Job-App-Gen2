import 'package:flutter/material.dart';
import 'package:app/constant/colors.dart';
import 'package:app/function/sized.dart';

class BlueButton extends StatelessWidget {
  const BlueButton({
    Key? key,
    this.onPressed,
    this.title,
    this.margin,
    this.height,
  }) : super(key: key);
  final String? title;
  final GestureTapCallback? onPressed;
  // final double marginx2;
  final double? margin;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.blue,
              ),
              child: Container(
                height: height == null
                    ? mediaWidthSized(context, 10)
                    : mediaWidthSized(context, 1) / height,
                alignment: Alignment.center,
                width: margin == null
                    ? MediaQuery.of(context).size.width - 40
                    : MediaQuery.of(context).size.width - margin!,
                child: Text(
                  '$title',
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: 'PoppinsRegular',
                    fontSize: mediaWidthSized(context, 25),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
