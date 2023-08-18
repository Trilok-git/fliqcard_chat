import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omanizz/test_webview.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'MainScreen.dart';
import 'helper/constants.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => DrawerService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestWebView(),
      // FirstRoute(title: APP_TITLE),
      routes: {
        "/main": (context) => MyApp(),
      },
    );
  }
}

class FirstRoute extends StatefulWidget {
  FirstRoute({Key? key, required this.title}) : super(key: key);
  String title;

  @override
  _FirstRouteState createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {
  bool isprogrssed = true;
  late String APP_STORE_URL, PLAY_STORE_URL;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    versionCheck();
  }

  @override
  void dispose() {
    super.dispose();
  }

  versionCheck() async {
    final SharedPreferences prefs = await _prefs;

    print('Here in version check');
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    print(info.toString());
    double currentVersion =
    double.parse(info.version.trim().replaceAll(".", ""));
    print('currentVersion' + currentVersion.toString());
    final response = await http.post(Uri.parse(initdata), body: {});

    var temp = response.body;
    print("temp" + temp);
    if (temp == "false") {
    } else {
      dynamic map = jsonDecode(response.body);
      prefs.setString("android_min_version", map[0]['android_min_version']);
      prefs.setString("ios_min_version", map[0]['ios_min_version']);
      prefs.setString("play_store_url", map[0]['play_store_url']);
      prefs.setString("app_store_url", map[0]['app_store_url']);
      prefs.setString("facebook", map[0]['facebook']);
      prefs.setString("twitter", map[0]['twitter']);
      prefs.setString("instagram", map[0]['instagram']);
      prefs.setString("linkedin", map[0]['linkedin']);
      prefs.setString("pinterest", map[0]['pinterest']);

      String tempversion = Platform.isAndroid
          ? map[0]['android_min_version']
          : map[0]['ios_min_version'];
      double newVersion = double.parse(tempversion.trim().replaceAll(".", ""));

      print('newVersion' + newVersion.toString());
      if (newVersion > currentVersion) {
        setState(() {
          APP_STORE_URL = map[0]['app_store_url'];
          PLAY_STORE_URL = map[0]['play_store_url'];
          _showVersionDialog(context, tempversion);
        });
      } else {
        setState(() {
          isprogrssed = false;
          APP_STORE_URL = map[0]['app_store_url'];
          PLAY_STORE_URL = map[0]['play_store_url'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isprogrssed == false
        ? MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_TITLE,
      home: splashsc,
      color: Color(COLOR_BACKGROUND),
    )
        : MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_TITLE,
      home: Scaffold(
        backgroundColor: Color(COLOR_PRIMARY),
        body: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ),
        ),
      ),
      color: Color(COLOR_BACKGROUND),
    );
  }

  Widget splashsc = SplashScreenView(
    duration: 3000,
    imageSize: 150,
    imageSrc: APP_LOGO_PATAH,
    text: APP_SUBTITLE,
    textType: TextType.TyperAnimatedText,
    textStyle: TextStyle(
        fontSize: 30.0,
        color: Color(COLOR_PRIMARY),
        fontWeight: FontWeight.bold),
    backgroundColor: Color(COLOR_WHITE),
    navigateRoute: MainScreen(),
  );

  _showVersionDialog(context, String version) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = 'New Update Available';
        String message = "Version " +
            version +
            " is required\n(Clear play/App store applications cache, if you see older version)";
        String btnLabel = 'Update Now';
        return Platform.isIOS
            ? new CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(btnLabel),
              onPressed: () => _launchURL(APP_STORE_URL),
            ),
          ],
        )
            : new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(btnLabel),
              onPressed: () => _launchURL(PLAY_STORE_URL),
            ),
          ],
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class DrawerService {
  StreamController<bool> _statusController = StreamController.broadcast();

  Stream<bool> get status => _statusController.stream;

  setIsOpenStatus(bool openStatus) {
    _statusController.add(openStatus);
  }
}
