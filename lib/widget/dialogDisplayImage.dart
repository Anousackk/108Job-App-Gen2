// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use, sized_box_for_whitespace

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DialogSingleImage extends StatelessWidget {
  const DialogSingleImage({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: AppColors.backgroundWhite,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // AspectRatio(
          //   aspectRatio: 4 / 5,
          // child:
          InteractiveViewer(
            child: Container(
              child: ClipRRect(
                child: imagePath == "" || imagePath.isEmpty
                    ? Image.asset(
                        'assets/image/no-image-available.png',
                        // 'assets/image/popup04.jpg',

                        fit: BoxFit.contain,
                      )
                    : Image.network(
                        imagePath,
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

          // ),
          Positioned(
            top: -50,
            right: 5,
            child: Container(
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text(
                  "\uf00d",
                  style: fontAwesomeRegular(null, 30, null, null),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
