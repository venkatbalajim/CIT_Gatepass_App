// ignore_for_file: unused_local_variable

import '../utils/imports.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {

    // To get the FCM Token
    final fCMtoken = await _firebaseMessaging.getToken();

    // Request permission to send notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

  }
}
