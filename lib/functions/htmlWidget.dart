// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, unnecessary_brace_in_string_interps, avoid_unnecessary_containers

//HtmlWidget
import 'package:app/functions/colors.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/dialogDisplayImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

Widget buildScrollableHtmlWidget(
    String data, void Function(ImageMetadata)? pressImage) {
  print("use HtmlWidget()");
  return Container(
    // color: AppColors.red,
    child: InteractiveViewer(
      minScale: 0.5, // how much user can zoom out
      maxScale: 3.0, // how much user can zoom in
      panEnabled: true,
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: HtmlWidget(
            data,
            onTapUrl: (url) {
              print("onTapUrl tag link: ${url}");
              launchInBrowser(Uri.parse(url));
              return true;
            },
            onTapImage: pressImage,
            customStylesBuilder: (element) {
              // print(element.localName.toString());
              if (element.localName == 'table') {
                return {'border': '1px solid #000', 'width': '100%'};
              }
              if (element.localName == 'th' || element.localName == 'td') {
                return {'border': '1px solid #000', 'padding': '8px'};
              }
              if (element.localName == 'figure') {
                print("element.localName == figure");

                return {
                  'margin': '0',
                  'padding': '0',
                  'width': '100%',
                  'max-width': '100%',
                  'display': 'block',
                };
              }
              // if (element.localName == 'img') {
              //   print("tag image");
              //   return {
              //     'width': '100%',
              //     'max-width': '100%',
              //     'height': 'auto',
              //     'display': 'block',
              //   };
              // }
              return null;
            },
            textStyle: bodyTextMaxSmall(null, null, null),
          ),
        ),
      ),
    ),
  );
}
