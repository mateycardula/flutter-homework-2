import 'dart:convert';

class JokeType {
  final List<String> jokeTypes;

  JokeType({
    required this.jokeTypes
  });

  // Factory constructor to create a Product from a JSON map
  factory JokeType.fromJson(List<dynamic> json) {
    return JokeType(
        jokeTypes: List<String>.from(json)
    );
  }
}