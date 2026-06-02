import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../main.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    if (isFirebaseMocked) {
      debugPrint("Notifications: Running in mock mode (FCM bypassed)");
      return;
    }

    try {
      // Request permission
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );

      debugPrint('User granted notification permissions: ${settings.authorizationStatus}');

      // Configure foreground message presentation
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Listen for foreground alerts
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Received foreground notification: ${message.notification?.title}');
      });

      // Handle notification clicks
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('Opened app from notification: ${message.data}');
      });
    } catch (e) {
      debugPrint("FCM initialization error: $e");
    }
  }

  /// Subscribe to a specific geographic region topic (e.g. leader_district_chennai)
  Future<void> subscribeToRegion(String level, String value) async {
    if (isFirebaseMocked) return;
    
    final topic = 'leader_${level.toLowerCase()}_${value.replaceAll(' ', '_').toLowerCase()}';
    try {
      await _fcm.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Failed to subscribe to topic $topic: $e');
    }
  }

  /// Unsubscribe when logging out
  Future<void> unsubscribeFromRegion(String level, String value) async {
    if (isFirebaseMocked) return;

    final topic = 'leader_${level.toLowerCase()}_${value.replaceAll(' ', '_').toLowerCase()}';
    try {
      await _fcm.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Failed to unsubscribe from topic $topic: $e');
    }
  }
}
