import 'package:flutter/material.dart';
import 'package:jokes_homework/widgets/types/type_item.dart';

// Sample joke types
class JokeTypesGrid extends StatelessWidget {
  final List<String> jokeTypes;

  const JokeTypesGrid({super.key, required this.jokeTypes});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,  // Number of columns
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3,
      ),
      itemCount: jokeTypes.length,
      itemBuilder: (context, index) {
        return JokeTypeItem(
          type: jokeTypes[index],
          onTap: () {
            print('Selected Joke Type: ${jokeTypes[index]}');
          },
        );
      },
    );
  }
}