import 'dart:convert';
import '../models/joke.dart';
import '../models/joke_type.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://official-joke-api.appspot.com';

  // Fetch jokes by type
  static Future<List<Joke>> getJokesByType(String type) async {
    final response = await http.get(Uri.parse('$_baseUrl/jokes/$type/ten'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map<Joke>((json) => Joke.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load jokes');
    }
  }

  // Fetch joke types
  static Future<JokeType> fetchJokeTypes() async {
    final response = await http.get(Uri.parse('$_baseUrl/types'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return JokeType.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load joke types');
    }
  }

  static Future<Joke> getRandomJoke() async {
    final response = await http.get(Uri.parse('$_baseUrl/random_joke'));

    if (response.statusCode == 200) {
      var jokeJson = jsonDecode(response.body);
      return Joke.fromJson(jokeJson);
    } else {
      throw Exception('Failed to load random joke');
    }
  }
}
