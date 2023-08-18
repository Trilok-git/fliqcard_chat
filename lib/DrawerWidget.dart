import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'HomePage2.dart';
import 'helper/constants.dart';
import 'main.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late DrawerService _drawerService;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _drawerService = Provider.of(context, listen: false);
    _drawerService.setIsOpenStatus(true);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(APP_LOGO_PATAH),
                      fit: BoxFit.fitHeight)),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  global_url = mainUrl;
                });
              },
              leading:
              Icon(Icons.home_outlined, color: Color(COLOR_TEXT_PRIMARY)),
              title: Text(
                'Home',
                style:
                TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {},
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  global_url = mainUrl + 'account/';
                });
              },
              leading: Icon(Icons.account_circle_outlined,
                  color: Color(COLOR_TEXT_PRIMARY)),
              title: Text(
                'Account',
                style:
                TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {},
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  global_url = mainUrl + 'posts/create';
                });
              },
              leading: Icon(Icons.post_add_rounded,
                  color: Color(COLOR_TEXT_PRIMARY)),
              title: Text(
                'Add A Post',
                style:
                TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {},
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  global_url = mainUrl + 'contact';
                });
              },
              leading:
              Icon(Icons.mail_outline, color: Color(COLOR_TEXT_PRIMARY)),
              title: Text(
                'Contact Us',
                style:
                TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {},
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  global_url = mainUrl + 'page/about-us';
                });
              },
              leading:
              Icon(Icons.info_outline, color: Color(COLOR_TEXT_PRIMARY)),
              title: Text(
                'About Us',
                style:
                TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {},
            child: ListTile(
              onTap: () {
                //Navigator.pop(context);
                Share.share(Platform.isIOS
                    ? app_store_url
                    : play_store_url);
              },
              leading:
              Icon(Icons.share_outlined, color: Color(COLOR_TEXT_PRIMARY)),
              title: Text(
                'Share App',
                style:
                TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {},
            child: ListTile(
              onTap: () {
                // Navigator.pop(context);
                _launchURL(facebook);
              },
              leading: Icon(Icons.facebook_rounded,
                  color: Color(COLOR_TEXT_PRIMARY)),
              title: Text(
                'Facebook',
                style:
                TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {},
            child: ListTile(
              onTap: () {
                // Navigator.pop(context);
                _launchURL(twitter);
              },
              leading: Icon(FontAwesomeIcons.twitter,
                  color: Color(COLOR_TEXT_PRIMARY)),
              title: Text(
                'Twitter',
                style:
                TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {},
            child: ListTile(
              onTap: () {
                //  Navigator.pop(context);
                _launchURL(instagram);
              },
              leading: Icon(FontAwesomeIcons.instagram,
                  color: Color(COLOR_TEXT_PRIMARY)),
              title: Text(
                'Instagram',
                style:
                TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {},
            child: ListTile(
              onTap: () {
                //  Navigator.pop(context);
                _launchURL(linkedin);
              },
              leading: Icon(FontAwesomeIcons.linkedinIn,
                  color: Color(COLOR_TEXT_PRIMARY)),
              title: Text(
                'LinkedIn',
                style:
                TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {},
            child: ListTile(
              onTap: () {
                //   Navigator.pop(context);
                _launchURL(pinterest);
              },
              leading: Icon(FontAwesomeIcons.pinterestP,
                  color: Color(COLOR_TEXT_PRIMARY)),
              title: Text(
                'Pinterest',
                style:
                TextStyle(fontSize: 17.0, color: Color(COLOR_TEXT_PRIMARY)),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              onTap: () {
                //   Navigator.pop(context);
                launchUrl(emailLaunchUri);
              },
              title: Text(
                'V. ' +
                    app_version ,
                style: TextStyle(fontSize: 12.0, color: Colors.blue),
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _drawerService.setIsOpenStatus(false);
  }
}
