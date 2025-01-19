// import 'dart:developer';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';

// class NotificationController with ChangeNotifier {
//   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     await Firebase.initializeApp();
//     log("Handling background message: ${message.messageId}");
//   }

//   static Future<void> initializeNotifications() async {
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     log("Notification permission status: ${settings.authorizationStatus}");

//     String? apnsToken;
//     int retries = 5;
//     while (apnsToken == null && retries > 0) {
//       apnsToken = await _messaging.getAPNSToken();
//       if (apnsToken == null) {
//         log("APNS token not available yet. Retrying...");
//         await Future.delayed(Duration(seconds: 2));
//       }
//       retries--;
//     }

//     if (apnsToken == null) {
//       log("Error: APNS token is still null. Ensure iOS setup is correct.");
//       return;
//     } else {
//       log("APNS Token: $apnsToken");
//     }
//     String? token = await _messaging.getToken();
//     log("FCM Token: $token");

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       log("Foreground message received: ${message.notification?.title}");
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       log("Notification tapped: ${message.notification?.title}");
//     });
//   }
// }
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationController with ChangeNotifier {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    log("Handling background message: ${message.messageId}");
  }

  static Future<void> initializeNotifications() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log("Notification permission status: ${settings.authorizationStatus}");

    String? apnsToken;
    int retries = 5;
    while (apnsToken == null && retries > 0) {
      apnsToken = await _messaging.getAPNSToken();
      if (apnsToken == null) {
        log("APNS token not available yet. Retrying...");
        await Future.delayed(Duration(seconds: 2));
      }
      retries--;
    }

    if (apnsToken == null) {
      log("Error: APNS token is still null. Ensure iOS setup is correct.");
      return;
    } else {
      log("APNS Token: $apnsToken");
    }

    String? token = await _messaging.getToken();
    log("FCM Token: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Foreground message received: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Notification tapped: ${message.notification?.title}");
    });
  }
}
