import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:omanizz/HomePage2.dart';
import 'package:omanizz/showAwesomeNotifications.dart';

import 'NotificationsInit.dart';
import 'helper/constants.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  showAwesomeNotifications(message);
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  NotificatiosnInit() async {


    await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus==AuthorizationStatus.denied){

    }else if(settings.authorizationStatus==AuthorizationStatus.authorized){
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      awesome_notification_init();

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        showAwesomeNotifications(message);
      });


      String? fcmtoken = await FirebaseMessaging.instance.getToken();
      print("fcmtoken");
      print(fcmtoken);
    }


  }



  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(COLOR_PRIMARY),
        body: Center(
          child: HomePage2(),
        ),
      ),
      routes: {
        "/home": (context) => HomePage2(),
      },
    );
  }

}
