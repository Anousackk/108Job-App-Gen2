// ignore_for_file: prefer_const_constructors, file_names, prefer_typing_uninitialized_variables

import 'package:app/functions/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sizer/sizer.dart';

class PhotViewDetail extends StatefulWidget {
  const PhotViewDetail({
    Key? key,
    this.image,
  }) : super(key: key);

  final image;

  @override
  State<PhotViewDetail> createState() => _PhotViewDetailState();
}

class _PhotViewDetailState extends State<PhotViewDetail> {
  @override
  Widget build(BuildContext context) {
    String img = widget.image;
    dynamic splitImage;
    if (widget.image != "") {
      splitImage = img.split(",");
    } else {
      splitImage = ['assets/image/def-profile.png'];
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 15.w,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: AppColors.dark,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 5.w,
          icon: Icon(Icons.arrow_back),
          color: AppColors.white,
        ),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            PhotoViewGallery.builder(
              itemCount: splitImage.length,
              builder: (context, index) {
                return img != ""
                    ? PhotoViewGalleryPageOptions(
                        //ມີຮູບແລ້ວສະແດງຮູບປະຈຸບັນ
                        imageProvider: NetworkImage(
                          splitImage[index],
                        ),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.contained * 3,
                      )
                    : PhotoViewGalleryPageOptions(
                        //
                        //ບໍ່ມີຮູບສະແດງຮູບ Default
                        imageProvider: AssetImage(
                          splitImage[index],
                        ),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.contained * 4,
                      );
              },
              backgroundDecoration: BoxDecoration(color: AppColors.dark),
            ),
            // Container(
            //   margin: EdgeInsets.all(2.5.w),
            //   child: GestureDetector(
            //     onTap: () {
            //       Navigator.pop(context);
            //     },
            //     child: Text(
            //       'circle-xmark',
            //       style: mIcon('FontAwesomePro-Solid', AppColors.fontGrey),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
