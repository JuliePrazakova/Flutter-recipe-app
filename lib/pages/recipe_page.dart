import 'package:flutter/material.dart';
import '../services/recipe_service.dart';
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
              recipe.name, // Zobrazíme název receptu
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16), // Oddělovač
            const Placeholder(
              fallbackHeight: 200, // Placeholder pro obrázek receptu
              fallbackWidth: double.infinity,
            ),
            const SizedBox(height: 16), // Oddělovač
            const Text(
              'Ingredients:', // Nadpis pro ingredience
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8), // Oddělovač
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.ingredients.map((ingredient) {
                return Text('- $ingredient'); // Zobrazíme každou ingredienci
              }).toList(),
            ),
            const SizedBox(height: 16), // Oddělovač
            const Text(
              'Steps:', // Nadpis pro kroky
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8), // Oddělovač
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.steps.asMap().entries.map((entry) {
                int index = entry.key + 1;
                String step = entry.value;
                return Text('$index. $step'); // Zobrazíme každý krok
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
