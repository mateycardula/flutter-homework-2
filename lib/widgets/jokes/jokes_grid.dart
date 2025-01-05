import 'package:flutter/material.dart';
import '../../models/joke.dart';
import '../../service/favorites_service.dart';
import 'joke_card.dart';

class JokesGrid extends StatelessWidget {
  final List<Joke> jokes;
  final List<String> favoriteJokes;
  final Function(String) onRemove;
  final Function(String, bool) onFavoriteToggle;

  const JokesGrid({
    super.key,
    required this.jokes,
    required this.favoriteJokes,
    required this.onRemove,
    required this.onFavoriteToggle,
  });

  // Toggle the favorite state for a joke
  void _toggleFavorite(String jokeId, bool isFavorite) async {
    await FavoritesService().toggleFavorite(jokeId, isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Use SingleChildScrollView for vertical scrolling
      child: Center( // Center the joke content in the middle of the screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically center the content
          children: jokes.map((joke) {
            final isFavorite = favoriteJokes.contains(joke.id);

            return JokeCard(
              joke: joke,
              isFavorite: isFavorite,
              onFavoriteToggle: () {
                _toggleFavorite(joke.id, !isFavorite);
                if (!isFavorite) {
                  onRemove(joke.id);
                }
              },
            );
          }).toList(), // Map through jokes and display each in a centered column
        ),
      ),
    );
  }
}
