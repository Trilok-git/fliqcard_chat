import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

showAwesomeNotifications(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  if(notification != null){
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: Random().nextInt(1000),
          channelKey: '10000',
          title: notification!.title ?? "title",
          body: notification!.body ?? "body"),
    );
  }

}
