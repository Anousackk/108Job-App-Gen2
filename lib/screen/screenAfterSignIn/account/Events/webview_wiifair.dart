import 'package:app/functions/alert_dialog.dart';
import 'package:app/functions/colors.dart';
import 'package:app/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWiiFair extends StatefulWidget {
  const WebViewWiiFair({Key? key}) : super(key: key);

  @override
  State<WebViewWiiFair> createState() => _WebViewWiiFairState();
}

class _WebViewWiiFairState extends State<WebViewWiiFair> {
  late final WebViewController _controller;
  bool _isLoading = true;

  initWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      // ..loadRequest(Uri.parse('http://192.168.68.103:3000/wii-fair'));
      ..loadRequest(Uri.parse("https://108.jobs/wii-fair"));
  }

  @override
  void initState() {
    super.initState();
    initWebViewController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarAddAction(
        systemOverlayStyleColor: SystemUiOverlayStyle.light,
        backgroundColor: AppColors.teal,
        leadingIcon: Icon(Icons.close),
        leadingPress: () {
          Navigator.pop(context);
        },
        textTitle: '',
        action: [],
      ),
      body: SafeArea(
        child: _isLoading
            ? Container(
                color: AppColors.backgroundWhite,
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: CustomLoadingLogoCircle(),
                ),
              )
            : Container(
                color: AppColors.backgroundWhite,
                width: double.infinity,
                height: double.infinity,
                child: WebViewWidget(controller: _controller),
                // child: RefreshIndicator(
                //   onRefresh: () async {
                //     _controller.reload();
                //   },
                //   child: WebViewWidget(controller: _controller),
                // ),
              ),
      ),
    );
  }
}
