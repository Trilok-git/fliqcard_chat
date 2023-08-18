// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'package:share/share.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:provider/provider.dart';
// // import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:back_button_interceptor/back_button_interceptor.dart';
// import 'package:package_info_plus/package_info_plus.dart';
//
// import 'helper/constants.dart';
// import 'main.dart';
//
// BuildContext initialformContext;
// String global_url = mainUrl;
// late String play_store_url,
//     app_store_url,
//     facebook,
//     twitter,
//     instagram,
//     linkedin,
//     pinterest;
// late String app_version;
// // StreamSubscription<String> _onUrlChanged;
// late StreamSubscription<WebViewStateChanged> _onStateChanged;
//
// final Uri _emailLaunchUri = Uri(
//     scheme: 'mailto',
//     path: 'sohelpathan6411@gmail.com',
//     queryParameters: {'subject': 'Query For Application'});
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
//   bool _isloaded = false;
//   late SharedPreferences prefs;
//   late List<bool> isSelected;
//
//   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//
//   Future<void> initialTask() async {
//     final PackageInfo info = await PackageInfo.fromPlatform();
//     prefs = await _prefs;
//     setState(() {
//       app_version = info.version;
//
//       play_store_url = prefs.getString('play_store_url')!;
//       app_store_url = prefs.getString('app_store_url')!;
//       facebook = prefs.getString('facebook')!;
//       twitter = prefs.getString('twitter')!;
//       instagram = prefs.getString('instagram')!;
//       linkedin = prefs.getString('linkedin')!;
//       pinterest = prefs.getString('pinterest')!;
//       _isloaded = true;
//     });
//   }
//
//   DrawerService _drawerService = DrawerService();
//   bool drawerIsopen = false;
//
//   Future<void> streamBuildsAgain() async {
//     final flutterWebviewPlugin = FlutterWebviewPlugin();
//
//     flutterWebviewPlugin.close();
//
//     /* _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
//       setState(() {
//         //_history.add('onUrlChanged: $url');
//         if (url.contains('api.whatsapp.com') ||
//             url.contains('web.whatsapp') ||
//             url.contains('whatsapp://send') ||
//             url.contains('//wa.me/')) {
//         } else {
//           global_url = url;
//         }
//       });
//     });
// */
//
//     _onStateChanged =
//         flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
//       setState(() {
//         print('whatsapplink2: ${state.type} ${state.url}');
//         if (state.type == WebViewState.shouldStart) {
//           if (state.url.contains('api.whatsapp.com') ||
//               state.url.contains('web.whatsapp') ||
//               state.url.contains('whatsapp://send') ||
//               state.url.contains('//wa.me/')) {
//             flutterWebviewPlugin.reload();
//             _launchURL(state.url);
//           }
//           /* else if (state.url.contains('omanizz.com/register')) {
//             drawerIsopen = true;
//             //flutterWebviewPlugin.reload();
//             _showRegisterDialog(context, state.url);
//           } else {
//             print("isit3" + state.url);
//             if (state.url != "about:blank") {
//               if (state.url.contains('omanizz.com/register')) {
//               } else {
//                 global_url = state.url;
//               }
//             }
//           }*/
//         }
//       });
//     });
//   }
//
//   _showRegisterDialog(context, String url) async {
//     await showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         String title = 'Create account';
//         String message =
//             "Registration can be done from browser only. After account verification login to app again!";
//         String btnLabel = 'Launch Brawser';
//         String btnBack = 'BACK';
//         return Platform.isIOS
//             ? new CupertinoAlertDialog(
//                 title: Text(title),
//                 content: Text(message),
//                 actions: <Widget>[
//                   TextButton(
//                     child: Text(btnLabel),
//                     onPressed: () {
//                       Navigator.pop(context);
//                       Navigator.pop(context);
//                       _drawerService.setIsOpenStatus(false);
//                       _launchURL(url);
//                     },
//                   ),
//                 ],
//               )
//             : new AlertDialog(
//                 title: Text(title),
//                 content: Text(message),
//                 actions: <Widget>[
//                   TextButton(
//                     child: Text(btnLabel),
//                     onPressed: () {
//                       Navigator.pop(context);
//                       _drawerService.setIsOpenStatus(false);
//                       _launchURL(url);
//                     },
//                   ),
//                 ],
//               );
//       },
//     );
//   }
//
//   bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
//     bool flag = false;
//     setState(() {
//       drawerIsopen = false;
//       streamBuildsAgain();
//     });
//     return flag;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initialTask();
//     isSelected = [true, false];
//     _drawerService = Provider.of(context, listen: false);
//     _listenDrawerService();
//     BackButtonInterceptor.add(myInterceptor);
//     streamBuildsAgain();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     BackButtonInterceptor.remove(myInterceptor);
//     _onStateChanged.cancel();
//   }
//
//   _listenDrawerService() {
//     _drawerService.status.listen((status) {
//       setState(() {
//         if (status) {
//           drawerIsopen = true;
//         } else {
//           drawerIsopen = false;
//           streamBuildsAgain();
//         }
//       });
//     });
//   }
//
//   _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//
//     setState(() {
//       initialformContext = context;
//     });
//
//     return Container(
//       child: _isloaded == false
//           ? Scaffold(
//               backgroundColor: Color(COLOR_PRIMARY),
//               body: Center(
//                 child: CircularProgressIndicator(
//                   backgroundColor: Colors.white,
//                 ),
//               ),
//             )
//           : Scaffold(
//               backgroundColor: Color(COLOR_BACKGROUND),
//               appBar: AppBar(
//                 toolbarHeight: 56,
//                 elevation: 0,
//                 backgroundColor: Color(COLOR_PRIMARY),
//                 actions: [
//                   InkWell(
//                     child: Icon(Icons.post_add_rounded, size: 40, color: Colors.yellow),
//                     onTap: () {
//                       setState(() {
//                         drawerIsopen = true;
//                       });
//                       Future.delayed(const Duration(milliseconds: 500), () {
//                         setState(() {
//                           global_url = mainUrl + 'posts/create';
//                           drawerIsopen = false;
//                           streamBuildsAgain();
//                         });
//                       });
//                     },
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   ToggleButtons(
//                     borderColor: Color(COLOR_BACKGROUND),
//                     fillColor: Colors.grey,
//                     borderWidth: 1,
//                     selectedBorderColor: Color(COLOR_BACKGROUND),
//                     selectedColor: Color(COLOR_BACKGROUND),
//                     borderRadius: BorderRadius.circular(10),
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           'English',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           'عربي',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                     onPressed: (int index) {
//                       setState(() {
//                         for (int i = 0; i < isSelected.length; i++) {
//                           isSelected[i] = i == index;
//                         }
//                         drawerIsopen = true;
//                       });
//                       print('switched to: $index');
//                       Future.delayed(const Duration(milliseconds: 500), () {
//                         setState(() {
//                           if (index == 0) {
//                             global_url = "https://omanizz.com/lang/en";
//                           } else {
//                             global_url = "https://omanizz.com/lang/ar";
//                           }
//                           drawerIsopen = false;
//                           streamBuildsAgain();
//                         });
//                       });
//                     },
//                     isSelected: isSelected,
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//
//                 ],
//               ),
//               drawer: DrawerWidget(),
//               body: Container(
//                 child: drawerIsopen == true
//                     ? Scaffold(
//                         backgroundColor: Color(COLOR_BACKGROUND),
//                         body: Center(
//                           child: CircularProgressIndicator(
//                             backgroundColor: Color(COLOR_PRIMARY),
//                           ),
//                         ),
//                       )
//                     : WebviewScaffold(
//                         url: global_url,
//                         withZoom: true,
//                         withJavascript: true,
//                         withLocalStorage: true,
//                         hidden: true,
//                         initialChild: Container(
//                           color: Color(COLOR_BACKGROUND),
//                           child: Center(
//                             child: CircularProgressIndicator(
//                               backgroundColor: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//               ),
//             ),
//     );
//   }
// }
//
// class DrawerWidget extends StatefulWidget {
//   @override
//   _DrawerWidgetState createState() => _DrawerWidgetState();
// }
//
// class _DrawerWidgetState extends State<DrawerWidget> {
//   late DrawerService _drawerService;
//   late SharedPreferences prefs;
//   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//
//   @override
//   void initState() {
//     super.initState();
//     _drawerService = Provider.of(context, listen: false);
//     _drawerService.setIsOpenStatus(true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: <Widget>[
//           DrawerHeader(
//             child: Container(
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage(APP_LOGO_PATAH),
//                       fit: BoxFit.fitHeight)),
//             ),
//           ),
//           InkWell(
//             onTap: () {},
//             child: ListTile(
//               onTap: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   global_url = mainUrl;
//                 });
//               },
//               leading:
//                   Icon(Icons.home_outlined, color: Color(COLOR_TEXT_PRIMARY)),
//               title: Text(
//                 'Home',
//                 style:
//                     TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
//               ),
//             ),
//           ),
//           Divider(),
//           InkWell(
//             onTap: () {},
//             child: ListTile(
//               onTap: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   global_url = mainUrl + 'account/';
//                 });
//               },
//               leading: Icon(Icons.account_circle_outlined,
//                   color: Color(COLOR_TEXT_PRIMARY)),
//               title: Text(
//                 'Account',
//                 style:
//                     TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
//               ),
//             ),
//           ),
//           Divider(),
//           InkWell(
//             onTap: () {},
//             child: ListTile(
//               onTap: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   global_url = mainUrl + 'posts/create';
//                 });
//               },
//               leading: Icon(Icons.post_add_rounded,
//                   color: Color(COLOR_TEXT_PRIMARY)),
//               title: Text(
//                 'Add A Post',
//                 style:
//                     TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
//               ),
//             ),
//           ),
//           Divider(),
//           InkWell(
//             onTap: () {},
//             child: ListTile(
//               onTap: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   global_url = mainUrl + 'contact';
//                 });
//               },
//               leading:
//                   Icon(Icons.mail_outline, color: Color(COLOR_TEXT_PRIMARY)),
//               title: Text(
//                 'Contact Us',
//                 style:
//                     TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
//               ),
//             ),
//           ),
//           Divider(),
//           InkWell(
//             onTap: () {},
//             child: ListTile(
//               onTap: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   global_url = mainUrl + 'page/about-us';
//                 });
//               },
//               leading:
//                   Icon(Icons.info_outline, color: Color(COLOR_TEXT_PRIMARY)),
//               title: Text(
//                 'About Us',
//                 style:
//                     TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
//               ),
//             ),
//           ),
//           Divider(),
//           InkWell(
//             onTap: () {},
//             child: ListTile(
//               onTap: () {
//                 //Navigator.pop(context);
//                 Share.share(Platform.isIOS
//                     ? app_store_url
//                     : play_store_url);
//               },
//               leading:
//                   Icon(Icons.share_outlined, color: Color(COLOR_TEXT_PRIMARY)),
//               title: Text(
//                 'Share App',
//                 style:
//                     TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
//               ),
//             ),
//           ),
//           Divider(),
//           InkWell(
//             onTap: () {},
//             child: ListTile(
//               onTap: () {
//                // Navigator.pop(context);
//                 _launchURL(facebook);
//               },
//               leading: Icon(Icons.facebook_rounded,
//                   color: Color(COLOR_TEXT_PRIMARY)),
//               title: Text(
//                 'Facebook',
//                 style:
//                     TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
//               ),
//             ),
//           ),
//           Divider(),
//           InkWell(
//             onTap: () {},
//             child: ListTile(
//               onTap: () {
//                // Navigator.pop(context);
//                 _launchURL(twitter);
//               },
//               leading: Icon(FontAwesomeIcons.twitter,
//                   color: Color(COLOR_TEXT_PRIMARY)),
//               title: Text(
//                 'Twitter',
//                 style:
//                     TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
//               ),
//             ),
//           ),
//           Divider(),
//           InkWell(
//             onTap: () {},
//             child: ListTile(
//               onTap: () {
//               //  Navigator.pop(context);
//                 _launchURL(instagram);
//               },
//               leading: Icon(FontAwesomeIcons.instagram,
//                   color: Color(COLOR_TEXT_PRIMARY)),
//               title: Text(
//                 'Instagram',
//                 style:
//                     TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
//               ),
//             ),
//           ),
//           Divider(),
//           InkWell(
//             onTap: () {},
//             child: ListTile(
//               onTap: () {
//               //  Navigator.pop(context);
//                 _launchURL(linkedin);
//               },
//               leading: Icon(FontAwesomeIcons.linkedinIn,
//                   color: Color(COLOR_TEXT_PRIMARY)),
//               title: Text(
//                 'LinkedIn',
//                 style:
//                     TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
//               ),
//             ),
//           ),
//           Divider(),
//           InkWell(
//             onTap: () {},
//             child: ListTile(
//               onTap: () {
//              //   Navigator.pop(context);
//                 _launchURL(pinterest);
//               },
//               leading: Icon(FontAwesomeIcons.pinterestP,
//                   color: Color(COLOR_TEXT_PRIMARY)),
//               title: Text(
//                 'Pinterest',
//                 style:
//                     TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20.0,
//           ),
//          InkWell(
//             onTap: () {},
//             child: ListTile(
//               onTap: () {
//              //   Navigator.pop(context);
//                 launch(_emailLaunchUri.toString());
//               },
//               title: Text(
//                 'V. ' +
//                     app_version ,
//                 style: TextStyle(fontSize: 12.0, color: Colors.blue),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 50.0,
//           ),
//         ],
//       ),
//     );
//   }
//
//   _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _drawerService.setIsOpenStatus(false);
//   }
// }
