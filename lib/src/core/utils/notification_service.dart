import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overidea_assignment/firebase_options.dart';
import 'package:overidea_assignment/src/core/utils/app_constant.dart';

class NotificationService {
  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notification',
      description: 'This channel is used for important notifications',
      importance: Importance.defaultImportance);
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  Future<void> initialise() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: const DarwinInitializationSettings());
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin?.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      log('Payload:::::${payload.payload}');
      final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
      handleMessage(message);
    });
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      _showNotification(flutterLocalNotificationsPlugin!,
          title: event.notification?.title ?? '', message: event);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
    // request notification permission for android 13 or above
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin!
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    }
    try {
      if (DefaultFirebaseOptions.currentPlatform ==
          DefaultFirebaseOptions.web) {
        AppConstant.firebaseToken = await FirebaseMessaging.instance.getToken(
          vapidKey:
              'BDwKvrM766AbJEZaJ-d95bLUzrhfa_aejpavrxQ6yBA1g_k-75QBtN5jb6okCygaKArYNEOuKFIyNigl4w9dPww',
        );
      } else {
        var firebaseToken = Platform.isAndroid
            ? (await FirebaseMessaging.instance.getToken())!
            : await FirebaseMessaging.instance.getAPNSToken();
        log("FirebaseToken >> $firebaseToken");
        AppConstant.firebaseToken = firebaseToken;
      }
    } catch (e) {
      log("ERR >> $e");
    }
  }

  Future _showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      {required String title,
      required RemoteMessage message}) async {
    final notification = message.notification;
    if (notification == null) return;
    var androidDetails = AndroidNotificationDetails(
        _androidChannel.id, _androidChannel.name,
        importance: Importance.max);
    var generalNotificationDetails = NotificationDetails(
        android: androidDetails, iOS: const DarwinNotificationDetails());

    await flutterLocalNotificationsPlugin.show(
        message.hashCode, title, "$message", generalNotificationDetails,
        payload: jsonEncode(message.toMap()));

    await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@mipmap/ic_launcher',
        )),
        payload: jsonEncode(message.toMap()));
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // take user to notification page
  }
}
