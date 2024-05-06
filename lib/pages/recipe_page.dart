import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
      ),
      body: const Center(
        child: Column(
          children: [
            // Display recipe details (name, picture, ingredients, steps)
            // Use Placeholder widget for the picture
          ],
        ),
      ),
    );
  }
}
