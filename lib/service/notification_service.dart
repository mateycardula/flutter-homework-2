import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await _messaging.getToken();
    print('FCM token: $token');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message data: ${message.data}');
    });
  }
}