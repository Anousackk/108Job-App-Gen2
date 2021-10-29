import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:app/constant/colors.dart';

class DottedContainer extends StatelessWidget {
  const DottedContainer(
      {Key? key,
      this.title,
      this.description,
      this.addCaption,
      this.onTap,
      this.alert})
      : super(key: key);
  final String? title, description, addCaption;
  final GestureTapCallback? onTap;
  final bool? alert;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: DottedBorder(
            dashPattern: const [5, 5],
            color: alert == null
                ? AppColors.blue
                : alert!
                    ? Colors.red
                    : AppColors.blue,
            child: Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width - 40,
              color: alert == null
                  ? AppColors.opacityBlue
                  : alert!
                      ? Colors.red[100]
                      : AppColors.opacityBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title',
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 18),
                  ),
                  Text(
                    '$description',
                    style: TextStyle(
                        color: alert == null
                            ? AppColors.greyOpacity
                            : alert!
                                ? AppColors.grey
                                : AppColors.greyOpacity,
                        fontFamily: 'PoppinsRegular',
                        fontSize: 15),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'plus-circle',
                        style: TextStyle(
                            color: alert == null
                                ? AppColors.blue
                                : alert!
                                    ? Colors.red
                                    : AppColors.blue,
                            fontFamily: 'FontAwesomeProRegular',
                            fontSize: 15),
                      ),
                      Text(
                        ' $addCaption',
                        style: TextStyle(
                            color: alert == null
                                ? AppColors.blue
                                : alert!
                                    ? Colors.red
                                    : AppColors.blue,
                            fontFamily: 'PoppinsRegular',
                            fontSize: 15),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
