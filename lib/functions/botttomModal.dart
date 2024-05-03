//ເລືອກຮູບແແບບອັບໂຫຼດຮູບ
// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names, prefer_if_null_operators

import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

Widget ModalBottomCameraGallery(
    dynamic pressFirst,
    Widget? widgetFaIconFirst,
    String firstText,
    dynamic pressSecond,
    Widget? widgetFaIconSecond,
    String secondText) {
  return Container(
    // padding: EdgeInsets.only(top: 1.5.h, bottom: 1.5.h),
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(20),
    ),
    padding: EdgeInsets.symmetric(
      vertical: 20,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.all(Radius.circular(64.0)),
          ),
          margin: EdgeInsets.only(
            left: 40.w,
            right: 40.w,
          ),
          height: 1.w,
        ),
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                // color: AppColors.blue,
                child: ListTile(
                  onTap: pressFirst,
                  title: Container(
                    child: Text(firstText),
                  ),
                  leading: Container(
                    // padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      // color: AppColors.greyWhite,
                    ),
                    child: widgetFaIconFirst == null
                        ? FaIcon(
                            FontAwesomeIcons.image,
                            size: IconSize.sIcon,
                            color: AppColors.iconPrimary,
                          )
                        : widgetFaIconFirst,
                  ),
                  textColor: AppColors.primary,
                ),
              ),
              Divider(
                color: AppColors.borderBG,
                height: 2,
              ),
              Container(
                child: ListTile(
                  onTap: pressSecond,
                  title: Text(secondText),
                  leading: Container(
                    // padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      // color: AppColors.greyWhite,
                    ),
                    child: widgetFaIconSecond == null
                        ? FaIcon(
                            FontAwesomeIcons.camera,
                            size: IconSize.sIcon,
                            color: AppColors.iconPrimary,
                          )
                        : widgetFaIconSecond,
                  ),
                  textColor: AppColors.primary,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget ModalBottomUploadCV(
  dynamic pressFirst,
  Widget? widgetFaIconFirst,
  String firstText,
  dynamic pressSecond,
  Widget? widgetFaIconSecond,
  String secondText,
  dynamic pressThird,
  Widget? widgetFaIconThird,
  String thirdText,
) {
  return Container(
    // padding: EdgeInsets.only(top: 1.5.h, bottom: 1.5.h),
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(20),
    ),
    padding: EdgeInsets.symmetric(
      vertical: 20,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //
        //Line on modal bottom
        Container(
          decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.all(Radius.circular(64.0)),
          ),
          margin: EdgeInsets.only(
            left: 40.w,
            right: 40.w,
          ),
          height: 1.w,
        ),

        //
        //Button
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                // color: AppColors.blue,
                child: ListTile(
                  onTap: pressFirst,
                  title: Container(
                    child: Text(firstText),
                  ),
                  leading: Container(
                    // padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // color: AppColors.greyWhite,
                    ),
                    child: widgetFaIconFirst == null
                        ? FaIcon(
                            FontAwesomeIcons.upload,
                            size: IconSize.sIcon,
                            color: AppColors.iconPrimary,
                          )
                        : widgetFaIconFirst,
                  ),
                  textColor: AppColors.primary,
                ),
              ),
              Divider(
                color: AppColors.borderBG,
                height: 2,
              ),
              Container(
                child: ListTile(
                  onTap: pressSecond,
                  title: Text(secondText),
                  leading: Container(
                    // padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // color: AppColors.greyWhite,
                    ),
                    child: widgetFaIconSecond == null
                        ? FaIcon(
                            FontAwesomeIcons.solidEye,
                            size: IconSize.sIcon,
                            color: AppColors.iconPrimary,
                          )
                        : widgetFaIconSecond,
                  ),
                  textColor: AppColors.primary,
                ),
              ),
              Divider(
                color: AppColors.borderBG,
                height: 2,
              ),
              Container(
                child: ListTile(
                  onTap: pressThird,
                  title: Text(thirdText),
                  leading: Container(
                    // padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      // color: AppColors.greyWhite,
                    ),
                    child: widgetFaIconThird == null
                        ? FaIcon(
                            FontAwesomeIcons.download,
                            size: IconSize.sIcon,
                            color: AppColors.iconPrimary,
                          )
                        : widgetFaIconThird,
                  ),
                  textColor: AppColors.primary,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
