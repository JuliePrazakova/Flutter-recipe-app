import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import './app_bar.dart';
import '../providers/recipe_provider.dart';

class RecipePage extends ConsumerWidget {
  final Recipe recipe;

  const RecipePage({required this.recipe, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final isUserLoggedIn = user != null;
    final recipeProvider = ref.watch(recipeProviderState.notifier);

    final isFavorite = ref
        .watch(recipeProviderState)
        .firstWhere((r) => r.id == recipe.id)
        .fav
        .contains(user?.uid);

    final favCount = ref
        .watch(recipeProviderState)
        .firstWhere((r) => r.id == recipe.id)
        .fav
        .length;

    return Scaffold(
      appBar: const MyAppBar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  const Spacer(), // Pushes the name to the center
                  Text(
                    recipe.name,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const Spacer(), // Pushes the icon and count to the right
                  Row(
                    children: [
                      Text('$favCount'),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          if (!isUserLoggedIn) return;
                          recipeProvider.updateFavourite(recipe);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Placeholder(
              fallbackHeight: 400,
              fallbackWidth: double.infinity,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Ingredients:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: recipe.ingredients.map((ingredient) {
                            return Text(
                              '- $ingredient',
                              style: const TextStyle(fontSize: 20),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Steps:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: recipe.steps.asMap().entries.map((entry) {
                            int index = entry.key + 1;
                            String step = entry.value;
                            return Text(
                              '$index. $step',
                              style: const TextStyle(fontSize: 20),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
