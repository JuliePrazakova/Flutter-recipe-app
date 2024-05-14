import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe_provider.dart'; 
import '../models/recipe.dart';

class RecipeDetailsPage extends ConsumerWidget {
  final Recipe recipe;

  const RecipeDetailsPage({Key? key, required this.recipe}) : super(key: key);

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
                if (updatedRecipe.name == '' || updatedRecipe.ingredients.isEmpty || updatedRecipe.steps.isEmpty) {
                  print('Fill in all information please!');
                  const Text('Fill in all information please!');
                } else {
                    ref.watch(recipeProviderState.notifier).updateRecipe(updatedRecipe);
                    Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
