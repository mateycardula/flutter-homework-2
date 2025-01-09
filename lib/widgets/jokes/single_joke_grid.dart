import 'package:flutter/material.dart';
import '../../models/joke.dart';
import 'joke_card.dart'; // Import the JokeCard widget

class SingleJokeGrid extends StatelessWidget {
  final Joke joke; // Joke to display

  const SingleJokeGrid({Key? key, required this.joke}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically center the content
          children: [
            JokeCard(joke: joke, isFavorite: false, onFavoriteToggle: () {  },), // Add the joke card to the column
          ],
        ),
      ),
    );
  }
}
