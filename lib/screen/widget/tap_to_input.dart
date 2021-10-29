import 'package:flutter/material.dart';
import 'package:app/function/sized.dart';

class TaptoInput extends StatelessWidget {
  const TaptoInput({Key? key, this.onTap, this.color, this.title})
      : super(key: key);
  final GestureTapCallback? onTap;
  final Color? color;
  final String? title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: color,
          height: 50,
          child: Text(
            '$title',
            style: TextStyle(
                fontFamily: 'PoppinsSemiBold',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: mediaWidthSized(context, 25)),
          ),
        ));
  }
}
