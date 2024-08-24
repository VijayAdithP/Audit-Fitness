import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print(message.notification?.title);
  print(message.notification?.body);
}

class FirebaseApi {
  final box = GetStorage();
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    "high_importance_channel",
    "High Importance Notification",
    description: "This channel is used for important notifications",
    importance: Importance.defaultImportance,
  );

  final _localNotification = FlutterLocalNotificationsPlugin();

  bool _isPermissionRequested = false;

  Future initLocalNotification() async {
    const android = AndroidInitializationSettings('@drawable/bit');
    const settings = InitializationSettings(android: android);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/bit',
          ),
        ),
      );
    });
    await _localNotification.initialize(settings);
    final platform = _localNotification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform!.createNotificationChannel(_androidChannel);
  }

  Future<void> initNotifications() async {
    if (!_isPermissionRequested) {
      _isPermissionRequested = true;

      // Check current permission status
      NotificationSettings settings =
          await _firebaseMessaging.getNotificationSettings();
      if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        // Request permission if it has not been determined yet
        await _firebaseMessaging.requestPermission();
      }
    }

    final fCMToken = await _firebaseMessaging.getToken();
    box.write("FCMtoken", fCMToken);
    print("User specific token: $fCMToken");

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    initLocalNotification();

    // Listen to token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print("FCM token refreshed: $newToken");
      box.write("FCMtoken", newToken);
      // Handle the new token as needed, e.g., update it on your server
    });
  }
}
