import 'package:flutter/material.dart';
import 'package:app/constant/animationfade.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/sized.dart';

class WidgetTabInfo extends StatelessWidget {
  const WidgetTabInfo(
      {Key? key,
      this.showField,
      this.onTap,
      this.header,
      this.icon,
      this.columnField,
      this.color,
      this.alertvisible,
      this.alertText})
      : super(key: key);
  final bool? alertvisible;
  final String? alertText;
  final Color? color;
  final GestureTapCallback? onTap;
  final String? showField, header, icon, columnField;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            padding:
                EdgeInsets.symmetric(vertical: mediaWidthSized(context, 30)),
            decoration: BoxDecoration(
                // color: Colors.grey,
                border: Border(
                    bottom: BorderSide(
                        color: alertvisible == null
                            ? AppColors.grey
                            : alertvisible!
                                ? Colors.red
                                : AppColors.grey,
                        width: 0.5))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$header',
                            style: TextStyle(
                                fontFamily:
                                    //  showField != null || columnField != null
                                    //     ?
                                    'PoppinsRegular'
                                // : 'PoppinsSemiBold'
                                ,
                                fontSize:
                                    // showField != null || columnField != null
                                    // ?
                                    indexL == 0
                                        ? mediaWidthSized(context, 30)
                                        : mediaWidthSized(context, 26),
                                color:
                                    // showField != null || columnField != null
                                    //     ?
                                    AppColors.greyOpacity
                                // : color == null
                                //     ? Colors.black
                                //     : color
                                ),
                          ),
                          Visibility(
                              visible: showField == null || showField == ''
                                  ? false
                                  : true,
                              child: Column(
                                children: [
                                  Text(
                                    showField == null
                                        ? '$columnField'
                                        : '$showField',
                                    style: TextStyle(
                                        fontFamily: 'PoppinsSemiBold',
                                        fontSize: indexL == 0
                                            ? mediaWidthSized(context, 30)
                                            : mediaWidthSized(context, 26),
                                        color: Colors.black),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: alertvisible == null
                          ? false
                          : alertvisible! || showField == null,
                      child: Container(
                        alignment: Alignment.center,
                        child: Fade(
                            child: Text(
                              '$alertText',
                              style: TextStyle(
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: mediaWidthSized(context, 35),
                                  color: Colors.red),
                            ),
                            visible: alertvisible ?? false),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      '$icon',
                      style: TextStyle(
                          fontFamily: 'FontAwesomeProRegular',
                          fontSize: 14,
                          color: alertvisible == null
                              ? Colors.black
                              : alertvisible!
                                  ? Colors.red
                                  : Colors.black),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
