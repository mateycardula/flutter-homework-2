import 'package:flutter/material.dart';
import 'package:jokes_homework/service/favorites_service.dart';
import 'package:jokes_homework/models/joke.dart';
import 'package:jokes_homework/widgets/jokes/jokes_grid.dart';
import '../service/ApiService.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool isLoading = true;
  List<Joke> favoriteJokes = [];

  @override
  void initState() {
    super.initState();
    _fetchFavoriteJokes(); // Fetch favorite jokes when the screen is initialized
  }

  // Fetch the favorite jokes for the logged-in user
  Future<void> _fetchFavoriteJokes() async {
    try {
      final favoriteIds = await FavoritesService().getFavoriteJokes();
      final List<Joke> jokes = [];

      for (var jokeId in favoriteIds) {
        final joke = await ApiService.getJokeById(jokeId); // Fetch the joke using its ID
        jokes.add(joke);
      }

      setState(() {
        favoriteJokes = jokes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle any error that occurs while fetching favorite jokes
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load favorite jokes')),
      );
    }
  }

  // Method to remove joke from favorites
  Future<void> _removeFromFavorites(Joke joke) async {
    try {
      // Remove joke from Firestore
      await FavoritesService().toggleFavorite(joke.id, true);

      // Remove joke from the local list (UI update)
      setState(() {
        favoriteJokes.remove(joke); // Remove joke from the list
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from favorites')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove from favorites')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Text(
          "Favorite Jokes",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.indigoAccent,
        ),
      )
          : favoriteJokes.isEmpty
          ? const Center(
        child: Text(
          'No favorite jokes yet.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : JokesGrid(
        jokes: favoriteJokes, // Pass the updated jokes list here
        favoriteJokes: favoriteJokes.map((joke) => joke.id).toList(),
        onFavoriteToggle: (jokeId, isFavorite) {
          // When toggling off (isFavorite is false), remove the joke
          if (!isFavorite) {
            final jokeToRemove =
            favoriteJokes.firstWhere((joke) => joke.id == jokeId);
            _removeFromFavorites(jokeToRemove); // Remove joke from the list
          }
        },
        onRemove: (jokeId) {
          // OnRemove callback is to remove the joke from the grid
          final jokeToRemove =
          favoriteJokes.firstWhere((joke) => joke.id == jokeId);
          _removeFromFavorites(jokeToRemove); // Remove joke from the list
        },
      ),
    );
  }
}
