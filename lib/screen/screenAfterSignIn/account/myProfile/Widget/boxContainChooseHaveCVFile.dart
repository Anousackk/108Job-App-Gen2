import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';

class BoxContainChooseHaveCVFile extends StatefulWidget {
  const BoxContainChooseHaveCVFile({
    Key? key,
    required this.icon,
    required this.text,
    required this.boxColor,
    required this.iconColor,
    required this.circleIconColor,
    required this.textColor,
    required this.borderColor,
    this.press,
  }) : super(key: key);

  final String icon, text;
  final Color borderColor, boxColor, iconColor, circleIconColor, textColor;
  final Function()? press;

  @override
  State<BoxContainChooseHaveCVFile> createState() =>
      _BoxContainChooseHaveCVFileState();
}

class _BoxContainChooseHaveCVFileState
    extends State<BoxContainChooseHaveCVFile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: widget.borderColor),
            color: widget.boxColor,
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: widget.circleIconColor, shape: BoxShape.circle),
              child: Text(
                "${widget.icon}",
                style: fontAwesomeSolid(null, null, widget.iconColor, null),
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                "${widget.text}",
                style: bodyTextNormal(null, widget.textColor, FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
