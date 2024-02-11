// ignore_for_file: unused_local_variable, avoid_print

import '../utils/imports.dart';

class FirebaseMessagingService {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {

    // To get the user authentication details
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) return;

    // To get the FCM Token
    final fCMtoken = await _firebaseMessaging.getToken();

    // Update the FCM Token in Firestore if necessary
    UserDetails userDetails = UserDetails();
    String? currentUserEmail = user.email;
    final result = await userDetails.getUserDetails(currentUserEmail!);
    if (result!.exists) {
      final userData = result.data();
      String currentFCMToken = userData['fcm_token'];
      if (currentFCMToken != fCMtoken) {
        final userDocumentReference = result.reference;
          userDocumentReference.update({
            'fcm_token': fCMtoken
          });
      }
    }

    // Request permission to send notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    // Handle incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: $message");
    });

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Opened app from notification: $message");
      _handleNotification(message);
    });
  }

  void _handleNotification(RemoteMessage message) {
    
  }
}
