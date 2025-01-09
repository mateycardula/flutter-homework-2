import 'package:flutter/material.dart';
import '../../models/joke.dart';
import '../../service/favorites_service.dart';

class JokeCard extends StatefulWidget {
  final Joke joke;

  const JokeCard({
    super.key,
    required this.joke, required bool isFavorite, required Null Function() onFavoriteToggle,
  });

  @override
  _JokeCardState createState() => _JokeCardState();
}

class _JokeCardState extends State<JokeCard> {
  bool _isFavorite = false;
  bool _isPunchlineVisible = false;
  final FavoritesService _favoritesService = FavoritesService();

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  // Check if the current joke is favorited by the user
  Future<void> _checkIfFavorite() async {
    final isFavorite = await _favoritesService.isFavorite(widget.joke.id as String);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  // Toggle the favorite status
  void _toggleFavorite() async {
    try {
      await _favoritesService.toggleFavorite(widget.joke.id, _isFavorite);
      setState(() {
        _isFavorite = !_isFavorite;
      });
    } catch (e) {
      print('Error toggling favorite: ${e.toString()}');
    }
  }

  // Toggle the punchline visibility
  void _togglePunchline() {
    setState(() {
      _isPunchlineVisible = !_isPunchlineVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePunchline,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.joke.setup,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: _toggleFavorite, // Toggle favorite status
                  ),
                ],
              ),
              SizedBox(height: 8),
              if (_isPunchlineVisible)
                Text(
                  widget.joke.punchline,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
