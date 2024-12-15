import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../screens/joke_screen.dart';

class JokeTypeItem extends StatelessWidget {
  final String type;
  final VoidCallback onTap;

  const JokeTypeItem({
    Key? key,
    required this.type,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JokesScreen(jokeType: type),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            type.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
