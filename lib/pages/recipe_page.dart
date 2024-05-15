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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () async {
                    if (!isUserLoggedIn) return;                  
                    recipeProvider.updateFavourite(recipe);
                  },
                ),
                Text('$favCount'),
                Text(
                  recipe.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 48),
              ],
            ),
            SizedBox(height: 16),
            Placeholder(
              fallbackHeight: 200,
              fallbackWidth: double.infinity,
            ),
            SizedBox(height: 16),
            const Text(
              'Ingredients:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.ingredients.map((ingredient) {
                return Text('- $ingredient');
              }).toList(),
            ),
            SizedBox(height: 16),
            const Text(
              'Steps:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.steps.asMap().entries.map((entry) {
                int index = entry.key + 1;
                String step = entry.value;
                return Text('$index. $step');
              }).toList(),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
