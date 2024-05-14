import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe_provider.dart';
import 'add_recipe.dart';
import 'recipe_detail.dart';

class UserPage extends ConsumerWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
 final user = FirebaseAuth.instance.currentUser;
    final recipeProvider = ref.watch(recipeProviderState); 
    final userRecipes = recipeProvider.where((recipe) => recipe.userId == user?.uid).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Recipes'),
      ),
      body: ListView.builder(
        itemCount: userRecipes.length,
        itemBuilder: (context, index) {
          final recipe = userRecipes[index];
          return ListTile(
            title: Text(recipe.name),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref.read(recipeProviderState.notifier).deleteRecipe(recipe.id);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailsPage(recipe: recipe),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRecipePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
