import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestWebView extends StatefulWidget {
  const TestWebView({Key? key}) : super(key: key);

  @override
  State<TestWebView> createState() => _TestWebViewState();
}

class _TestWebViewState extends State<TestWebView> {

  final String pageUrl = "https://fliqcard-chat-test.techgeekdeveloper.com/?id=343&type=oneToOne&sId=695";

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  final GlobalKey webViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Chat"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        child: InAppWebView(
          key: webViewKey,
          initialUrlRequest:
          URLRequest(url: Uri.parse(pageUrl)),
          initialOptions: options,
          // pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStop: (controller,url){
          },
          // onLoadStart: (controller, url) {
          //   setState(() {
          //     this.url = url.toString();
          //     urlController.text = this.url;
          //   });
          // },
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url!;

            if (![ "http", "https", "file", "chrome",
              "data", "javascript", "about"].contains(uri.scheme)) {
              if (await canLaunchUrl(Uri.parse(pageUrl))) {
                // Launch the App
                await launchUrl(
                    Uri.parse(pageUrl)
                );
                // and cancel the request
                return NavigationActionPolicy.CANCEL;
              }
            }

            return NavigationActionPolicy.ALLOW;
          },
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage);
          },
        ),
      ),
    );
  }
}

