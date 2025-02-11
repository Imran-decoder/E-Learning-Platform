import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'main.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications(String userId) async {
    // Request user permissions for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('Notification permissions denied.');
      return;
    }

    // Get the FCM token for the device
    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');

    if (fcmToken != null) {
      // Store the FCM token in Firestore under the current user
      await FirebaseFirestore.instance.collection('Users').doc(userId).set({
        'fcm_token': fcmToken,
      }, SetOptions(merge: true));  // Merge to update the token if it already exists
      print('FCM Token stored in Firestore');
    }

    // Subscribe to the 'allUsers' topic for push notifications
    await _firebaseMessaging.subscribeToTopic('allUsers');
    print('Device subscribed to allUsers topic');

    // Handle background and terminated state notifications
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

    // Handle when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received: ${message.notification?.title} - ${message.notification?.body}");
      handleMessage(message);
    });

    // Handle when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message opened from background: ${message.notification?.title} - ${message.notification?.body}");
      handleMessage(message);
    });
  }

  // Function to handle navigation when a notification is received
  void handleMessage(RemoteMessage message) {
    if (message.notification != null) {
      // Navigate to the notification screen, passing the message as an argument
      navigatorKey.currentState?.pushNamed(
        '/notifications',
        arguments: message,
      );
    }
  }

  // Background message handler
  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    print("Background Message received: ${message.notification?.title} - ${message.notification?.body}");
    // You can process the notification or data here
  }
}
