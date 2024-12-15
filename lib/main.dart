import 'package:flutter/material.dart';
import 'package:jokes_homework/screens/home_screen.dart';
import 'package:jokes_homework/screens/joke_screen.dart';

void main() {
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
        '/' : (context) => const Home(),
      },
    );
  }
}
