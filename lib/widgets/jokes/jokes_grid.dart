import 'package:flutter/material.dart';

import '../../models/joke.dart';
import 'joke_card.dart';

class JokesGrid extends StatelessWidget {
  final List<Joke> jokes;

  const JokesGrid({super.key, required this.jokes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: jokes.length,
      itemBuilder: (context, index) {
        return JokeCard(joke: jokes[index]);
      },
    );
  }
}