import 'package:flutter/material.dart';
import 'package:jokes_homework/screens/auth/login_page.dart';
import 'package:jokes_homework/screens/home_screen.dart';
import 'package:jokes_homework/screens/joke_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
