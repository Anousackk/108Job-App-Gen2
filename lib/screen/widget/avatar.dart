import 'dart:io';

import 'package:flutter/material.dart';
import 'package:app/constant/colors.dart';
import 'package:app/function/sized.dart';

import 'image_network_retry.dart';

class Avatar extends StatelessWidget {
  const Avatar(
      {Key? key, required this.picture, this.ontap, this.networkPicture})
      : super(key: key);
  final File? picture;
  final String? networkPicture;
  final GestureTapCallback? ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              // border:
              //     Border.all(color: AppColors.Yellow_COLOR, width: 2.0)),
            ),
            child: ClipOval(
              child: Container(
                height: mediaWidthSized(context, 3.3),
                width: mediaWidthSized(context, 3.3),
                color: AppColors.greyWhite,
                child: picture == null && networkPicture == null
                    ? Icon(
                        Icons.person,
                        size: mediaWidthSized(context, 6),
                        color: AppColors.greyOpacity,
                      )
                    : picture == null
                        ? Image(
                            fit: BoxFit.cover,
                            // fit: BoxFit.cover,
                            image: imageNetworkBuild(
                              networkPicture,
                            ),
                          )
                        : Image.file(
                            picture!,
                            fit: BoxFit.cover,
                          ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.all(
              mediaWidthSized(context, 100),
            ),
            child: Container(
              margin: EdgeInsets.all(
                mediaWidthSized(context, 200),
              ),
              height: mediaWidthSized(context, 14.5),
              width: mediaWidthSized(context, 14.5),
              decoration: const BoxDecoration(
                color: AppColors.greyOpacity,
                shape: BoxShape.circle,
                // border:
                //     Border.all(color: AppColors.Yellow_COLOR, width: 2.0)),
              ),
              child: Icon(
                Icons.camera_alt,
                size: mediaWidthSized(context, 23),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
