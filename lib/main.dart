import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jokes_homework/screens/auth/login_page.dart';
import 'package:jokes_homework/screens/home_screen.dart';
import 'package:jokes_homework/screens/joke_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jokes_homework/service/notification_service.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  NotificationsService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jokes',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/login': (context) => const LoginPage(),
        // Add other routes for navigation if needed
      },
    );
  }
}
