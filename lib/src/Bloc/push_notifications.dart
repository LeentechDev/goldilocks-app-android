import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      /// This is for on receive notification
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      /// This is for Launching the app
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      /// This is
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }
}