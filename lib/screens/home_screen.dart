import 'package:flutter/material.dart';
import 'package:jokes_homework/screens/random_joke_screen.dart';

import '../service/ApiService.dart';
import '../widgets/types/types_grid.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  List<String> jokeTypes = []; // List to hold joke types
  bool isLoading = true; // To manage loading state

  @override
  void initState() {
    super.initState();
    FetchJokeTypesAsync();
  }

  // Fetch joke types asynchronously
  void FetchJokeTypesAsync() async {
    try {
      var fetchedJokeTypes = await ApiService.fetchJokeTypes(); // Adjust this method to get joke types
      setState(() {
        jokeTypes = fetchedJokeTypes.jokeTypes;
        isLoading = false; // Set loading to false once joke types are fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle any error that occurs while fetching joke types (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load joke types')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Text(
          "Joke Types",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined, color: Colors.yellow, size: 40,),  // Икона за случајна шега
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RandomJokeScreen(),
                ),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.indigoAccent,
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: JokeTypesGrid(jokeTypes: jokeTypes), // Pass joke types to the grid widget
      ),
    );
  }
}
