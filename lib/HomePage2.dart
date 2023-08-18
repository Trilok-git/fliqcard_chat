import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'DrawerWidget.dart';
import 'helper/constants.dart';
import 'main.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports



String global_url = mainUrl;
late String play_store_url,
    app_store_url,
    facebook,
    twitter,
    instagram,
    linkedin,
    pinterest;
late String app_version;
final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'sohelpathan6411@gmail.com',
    queryParameters: {'subject': 'Query For Application'});


class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {

  bool isLoaded = false;
  List<bool> isSelected = [true, false];
  DrawerService _drawerService = DrawerService();
  bool drawerIsopen = false;
  late SharedPreferences prefs;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late final WebViewController controller;
  late final WebViewController _controller;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    initialTask();
    _drawerService = Provider.of(context, listen: false);

  }



  Future<void> initialTask() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    prefs = await _prefs;
    setState(() {
      app_version = info.version;

      play_store_url = prefs.getString('play_store_url')!;
      app_store_url = prefs.getString('app_store_url')!;
      facebook = prefs.getString('facebook')!;
      twitter = prefs.getString('twitter')!;
      instagram = prefs.getString('instagram')!;
      linkedin = prefs.getString('linkedin')!;
      pinterest = prefs.getString('pinterest')!;
      isLoaded = true;
    });

    // #docregion platform_features
    // late final PlatformWebViewControllerCreationParams params;
    // if (WebViewPlatform.instance is WebKitWebViewPlatform) {
    //   params = WebKitWebViewControllerCreationParams(
    //     allowsInlineMediaPlayback: false,
    //     mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
    //   );
    // } else {
    //   params = const PlatformWebViewControllerCreationParams();
    // }

    // final WebViewController controller =
    // WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features











    final WebViewController controller = WebViewController();

    controller
      ..enableZoom(true)
      ..canGoBack()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            _controller.enableZoom(true);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(global_url));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;


  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: isLoaded == false
          ?
      Scaffold(
        backgroundColor: Color(COLOR_PRIMARY),
        resizeToAvoidBottomInset: false,
        body: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ),
        ),
      )
          :
      Scaffold(
        backgroundColor: Color(COLOR_BACKGROUND),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: 56,
          elevation: 0,
          backgroundColor: Color(COLOR_PRIMARY),
          actions: [
            // InkWell(
            //   child: Icon(Icons.post_add_rounded, size: 40, color: Colors.yellow),
            //   onTap: () {
            //     setState(() {
            //       drawerIsopen = true;
            //     });
            //     Future.delayed(const Duration(milliseconds: 500), () {
            //       setState(() {
            //         global_url = mainUrl + 'posts/create';
            //         drawerIsopen = false;
            //         // streamBuildsAgain();
            //       });
            //     });
            //   },
            // ),
            // SizedBox(
            //   width: 10,
            // ),
            // ToggleButtons(
            //   borderColor: Color(COLOR_BACKGROUND),
            //   fillColor: Colors.grey,
            //   borderWidth: 1,
            //   selectedBorderColor: Color(COLOR_BACKGROUND),
            //   selectedColor: Color(COLOR_BACKGROUND),
            //   borderRadius: BorderRadius.circular(10),
            //   children: <Widget>[
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text(
            //         'English',
            //         style: TextStyle(
            //             fontSize: 16, fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text(
            //         'عربي',
            //         style: TextStyle(
            //             fontSize: 16, fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ],
            //   onPressed: (int index) {
            //     setState(() {
            //       for (int i = 0; i < isSelected.length; i++) {
            //         isSelected[i] = i == index;
            //       }
            //       drawerIsopen = true;
            //     });
            //     print('switched to: $index');
            //     Future.delayed(const Duration(milliseconds: 500), () {
            //       setState(() {
            //         if (index == 0) {
            //           global_url = "https://omanizz.com/lang/en";
            //         } else {
            //           global_url = "https://omanizz.com/lang/ar";
            //         }
            //         drawerIsopen = false;
            //         // streamBuildsAgain();
            //       });
            //     });
            //   },
            //   isSelected: isSelected,
            // ),
            // SizedBox(
            //   width: 10,
            // ),

          ],
        ),
        drawer: DrawerWidget(),
        body: Container(
          child: drawerIsopen == true
              ? Scaffold(
            backgroundColor: Color(COLOR_BACKGROUND),
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(COLOR_PRIMARY),
              ),
            ),
          )
              :
          InAppWebView(
            key: webViewKey,
            initialUrlRequest:
            URLRequest(url: Uri.parse(global_url)),
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
                if (await canLaunchUrl(Uri.parse(global_url))) {
                  // Launch the App
                  await launchUrl(
                    Uri.parse(global_url)
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

            // WebViewWidget(controller: _controller,)


          // WebviewScaffold(
          //   url: global_url,
          //   withZoom: true,
          //   withJavascript: true,
          //   withLocalStorage: true,
          //   hidden: true,
          //   initialChild: Container(
          //     color: Color(COLOR_BACKGROUND),
          //     child: Center(
          //       child: CircularProgressIndicator(
          //         backgroundColor: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}
