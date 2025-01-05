import 'package:flutter/material.dart';
import '../models/joke.dart';
import '../service/ApiService.dart';
import '../widgets/jokes/jokes_grid.dart';
import '../service/favorites_service.dart';

class JokesScreen extends StatefulWidget {
  final String jokeType;

  const JokesScreen({super.key, required this.jokeType});

  @override
  State<StatefulWidget> createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  List<Joke> jokes = [];
  bool isLoading = true;
  List<String> favoriteJokes = []; // Track the favorite jokes list

  @override
  void initState() {
    super.initState();
    fetchJokes();
    _loadFavorites(); // Load the favorite jokes when the screen is initialized
  }

  // Fetch jokes based on selected type
  void fetchJokes() async {
    try {
      var fetchedJokes = await ApiService.getJokesByType(widget.jokeType); // Fetch jokes using the jokeType
      setState(() {
        jokes = fetchedJokes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load jokes')),
      );
    }
  }

  // Fetch the favorite jokes from Firebase
  Future<void> _loadFavorites() async {
    try {
      List<String> favoriteIds = await FavoritesService().getFavoriteJokes();
      setState(() {
        favoriteJokes = favoriteIds; // Update the list of favorite jokes
      });
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  // Toggle the favorite state for a joke
  void _toggleFavorite(String jokeId, bool isFavorite) async {
    try {
      await FavoritesService().toggleFavorite(jokeId, isFavorite);
      _loadFavorites();  // Refresh favorite jokes list
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text("${widget.jokeType.toUpperCase()} JOKES",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : JokesGrid(
        jokes: jokes,
        favoriteJokes: favoriteJokes,
        onFavoriteToggle: _toggleFavorite, onRemove: (String ) {  },
      ),  // Pass favoriteJokes and onFavoriteToggle callback
    );
  }
}
