import 'package:flutter/material.dart';
import '../models/recipe.dart';
import './app_bar.dart';

class RecipePage extends StatelessWidget {
  final Recipe recipe; // Přijímáme recept jako vstupní argument

  const RecipePage({required this.recipe, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Center(
        child: Column(
          children: [
            Text(
              recipe.name, 
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16), 
            const Placeholder(
              fallbackHeight: 200, 
              fallbackWidth: double.infinity,
            ),
            const SizedBox(height: 16), 
            const Text(
              'Ingredients:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.ingredients.map((ingredient) {
                return Text('- $ingredient');
              }).toList(),
            ),
            const SizedBox(height: 16), 
            const Text(
              'Steps:', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8), 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.steps.asMap().entries.map((entry) {
                int index = entry.key + 1;
                String step = entry.value;
                return Text('$index. $step'); 
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
