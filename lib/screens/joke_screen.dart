import 'package:flutter/material.dart';
import '../models/joke.dart';
import '../service/ApiService.dart';
import '../widgets/jokes/jokes_grid.dart';

class JokesScreen extends StatefulWidget {
  final String jokeType;

  const JokesScreen({super.key, required this.jokeType});

  @override
  State<StatefulWidget> createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  List<Joke> jokes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJokes();
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
          : JokesGrid(jokes: jokes),
    );
  }
}
