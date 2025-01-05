import 'package:flutter/material.dart';
import '../models/joke.dart';
import '../widgets/jokes/jokes_grid.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Joke> favoriteJokes;

  const FavoritesScreen({super.key, required this.favoriteJokes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text(
          "Favorite Jokes",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: favoriteJokes.isEmpty
          ? Center(
        child: Text(
          'No favorite jokes yet.',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      )
          : JokesGrid(jokes: favoriteJokes),
    );
  }
}
