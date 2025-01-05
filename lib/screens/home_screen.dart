import 'package:flutter/material.dart';
import 'package:jokes_homework/screens/random_joke_screen.dart';
import 'package:jokes_homework/screens/favorites_screen.dart'; // Import FavoritesScreen
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

import '../service/ApiService.dart';
import '../widgets/types/types_grid.dart';
import 'auth/login_page.dart';

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
  bool isLoggedIn = false; // To track user login status

  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // Check login status on initialization
    FetchJokeTypesAsync();
  }

  // Check if the user is logged in
  void checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    setState(() {
      isLoggedIn = user != null; // If user is not null, they are logged in
    });
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
            icon: const Icon(Icons.favorite, color: Colors.red, size: 40), // Favorites icon
            onPressed: () {
              if (isLoggedIn) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesScreen(favoriteJokes: []), // Replace with your favorites list
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(), // Redirect to LoginPage if not logged in
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined, color: Colors.yellow, size: 40),  // Random joke icon
            onPressed: () {
              if (isLoggedIn) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RandomJokeScreen(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(), // Redirect to LoginPage if not logged in
                  ),
                );
              }
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
