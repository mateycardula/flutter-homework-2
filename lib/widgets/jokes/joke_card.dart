import 'package:flutter/material.dart';
import '../../models/joke.dart';

class JokeCard extends StatefulWidget {
  final Joke joke;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const JokeCard({
    super.key,
    required this.joke,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  _JokeCardState createState() => _JokeCardState();
}

class _JokeCardState extends State<JokeCard> {
  bool _isPunchlineVisible = false;

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
                      widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: widget.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: widget.onFavoriteToggle, // Toggle favorite state
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
