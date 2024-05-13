import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe_provider.dart';
import '../models/recipe.dart';

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

class RecipeDetailsPage extends ConsumerWidget {
  final Recipe recipe;

  const RecipeDetailsPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController nameController = TextEditingController(text: recipe.name);
    final TextEditingController categoryController = TextEditingController(text: recipe.category);
    final TextEditingController imageController = TextEditingController(text: recipe.image);
    final TextEditingController ingredientsController = TextEditingController(text: recipe.ingredients.join('\n'));
    final TextEditingController stepsController = TextEditingController(text: recipe.steps.join('\n'));

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Recipe Name'),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: ingredientsController,
              decoration: const InputDecoration(labelText: 'Ingredients'),
              maxLines: null,
            ),
            TextField(
              controller: stepsController,
              decoration: const InputDecoration(labelText: 'Steps'),
              maxLines: null,
            ),
            ElevatedButton(
              onPressed: () {
                final updatedRecipe = Recipe(
                  id: recipe.id,
                  name: nameController.text,
                  category: categoryController.text,
                  image: imageController.text,
                  ingredients: ingredientsController.text.split('\n'),
                  steps: stepsController.text.split('\n'),
                  userId: recipe.userId,
                );
                ref.watch(recipeProviderState.notifier).updateRecipe(updatedRecipe);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddRecipePage extends ConsumerWidget {
  const AddRecipePage({super.key});
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final String? userId = auth.currentUser?.uid;
    
    final TextEditingController nameController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    final TextEditingController ingredientsController = TextEditingController();
    final TextEditingController stepsController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Recipe Name'),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: ingredientsController,
              decoration: const InputDecoration(labelText: 'Ingredients'),
              maxLines: null,
            ),
            TextField(
              controller: stepsController,
              decoration: const InputDecoration(labelText: 'Steps'),
              maxLines: null,
            ),
            ElevatedButton(
              onPressed: () {
                final newRecipe = Recipe(
                  id: '',
                  name: nameController.text,
                  category: categoryController.text,
                  image: imageController.text,
                  ingredients: ingredientsController.text.split('\n'),
                  steps: stepsController.text.split('\n'),
                  userId: userId ?? '',
                );
                ref.watch(recipeProviderState.notifier).addRecipe(newRecipe);
                Navigator.pop(context);
              },
              child: const Text('Add Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
