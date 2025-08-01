// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'dart:convert';
import 'package:app/functions/colors.dart';
import 'package:app/functions/launchInBrowser.dart';
import 'package:app/functions/textSize.dart';
import 'package:app/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HybridHtmlViewer extends StatefulWidget {
  final String htmlContent;

  const HybridHtmlViewer({Key? key, required this.htmlContent})
      : super(key: key);

  @override
  State<HybridHtmlViewer> createState() => _HybridHtmlViewerState();
}

class _HybridHtmlViewerState extends State<HybridHtmlViewer> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final uri = Uri.parse(request.url);
            //Link http
            if (uri.scheme.startsWith('http')) {
              launchInBrowser(uri);
              return NavigationDecision.prevent;
            }
            //Email
            if (uri.scheme == 'mailto') {
              launchUrl(uri);
              return NavigationDecision.prevent;
            }
            //Tel
            if (uri.scheme == 'tel') {
              launchUrl(uri);
              return NavigationDecision.prevent;
            }
            //SMS
            if (uri.scheme == 'sms') {
              launchUrl(uri);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.dataFromString(
          _wrapHtml(widget.htmlContent),
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ),
      );
  }

  String _wrapHtml(String html) => """
  <html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
      body { background: #fff; color: #000; font-family: NotoSansLaoLoopedRegular, SatoshiRegular; margin: 8px; }
      table { border-collapse: collapse; width: 100%; }
      th, td { border: 1px solid #000; padding: 8px; text-align: left; }
    </style>
  </head>
  <body>$html</body>
  </html>
  """;

  bool _containsComplexTable(String html) {
    final lower = html.toLowerCase();
    return lower.contains('<table') &&
        (lower.contains('colspan') ||
            lower.contains('rowspan') ||
            lower.contains('style=') ||
            lower.length > 1000);
  }

  @override
  Widget build(BuildContext context) {
    final useWebView = _containsComplexTable(widget.htmlContent);

    return Scaffold(
      appBar: AppBarDefault(
        backgroundColor: AppColors.backgroundWhite,
        textTitle: "job_detail".tr,
        textColor: AppColors.fontDark,
        leadingIcon: Icon(
          Icons.arrow_back,
          color: AppColors.iconDark,
        ),
        leadingPress: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        color: AppColors.backgroundWhite,
        height: double.infinity,
        width: double.infinity,
        child: useWebView
            ? _buildScrollableWebView()
            : _buildScrollableHtmlWidget(),
      ),
    );
  }

  //HtmlWidget
  Widget _buildScrollableHtmlWidget() {
    print("use HtmlWidget()");
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 3.0,
      panEnabled: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: HtmlWidget(
            widget.htmlContent,
            onTapUrl: (url) {
              launchInBrowser(Uri.parse(url));
              return true;
            },
            customStylesBuilder: (element) {
              // print(element.localName.toString());
              if (element.localName == 'table') {
                return {'border': '1px solid #000', 'width': '100%'};
              }
              if (element.localName == 'th' || element.localName == 'td') {
                return {'border': '1px solid #000', 'padding': '8px'};
              }
              if (element.localName == 'figure') {
                return {
                  'margin': '0',
                  'padding': '0',
                  'width': '100%',
                  'max-width': '100%',
                  'display': 'block',
                };
              }
              if (element.localName == 'img') {
                print("tag image");
                return {
                  'width': '100%',
                  'max-width': '100%',
                  'height': 'auto',
                  'display': 'block',
                };
              }
              return null;
            },
            textStyle: bodyTextMaxSmall(null, null, null),
          ),
        ),
      ),
    );
  }

  //WebView
  Widget _buildScrollableWebView() {
    print("use WebView()");

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: WebViewWidget(controller: _webViewController),
    );
  }
}
