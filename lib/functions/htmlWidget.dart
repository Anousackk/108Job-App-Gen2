// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, unnecessary_brace_in_string_interps, avoid_unnecessary_containers

//HtmlWidget
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/textSize.dart';
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth,
                ),
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
                    if (element.localName == 'div') {
                      return {
                        'max-width': '100%',
                        'word-wrap': 'break-word',
                        'overflow-wrap': 'break-word',
                        'overflow': 'hidden',
                      };
                    }
                    if (element.localName == 'table') {
                      return {
                        'border': '1px solid #000',
                        'width': '100%',
                        'max-width': '100%',
                        'table-layout': 'fixed',
                        'word-wrap': 'break-word',
                      };
                    }
                    if (element.localName == 'th' ||
                        element.localName == 'td') {
                      return {
                        'border': '1px solid #000',
                        'padding': '8px',
                        'word-wrap': 'break-word',
                        'max-width': '100%',
                        'overflow': 'hidden',
                      };
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
                    //     'object-fit': 'contain',
                    //   };
                    // }
                    return null;
                  },
                  textStyle: bodyTextMaxSmall(null, null, null),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}
