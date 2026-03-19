// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use, sized_box_for_whitespace

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class DialogSingleImage extends StatelessWidget {
  const DialogSingleImage({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String imagePath;

  Widget _buildBase64Image(String base64String) {
    try {
      // Extract the base64 part from the data URL
      final base64Data = base64String.split(',')[1];
      return Image.memory(
        base64.decode(base64Data),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/image/no-image-available.png',
            fit: BoxFit.contain,
          );
        },
      );
    } catch (e) {
      // If there's any error parsing the base64, show the no-image placeholder
      return Image.asset(
        'assets/image/no-image-available.png',
        fit: BoxFit.contain,
      );
    }
  }

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
                    : imagePath.startsWith('data:')
                        ? _buildBase64Image(imagePath)
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
