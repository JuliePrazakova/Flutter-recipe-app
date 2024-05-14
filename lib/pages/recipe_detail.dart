import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe_provider.dart'; 
import '../models/recipe.dart';

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
            Consumer(
              builder: (context, ref, child) {
                final showErrorMessages = ref.watch(showErrorMessagesProvider);

                if (showErrorMessages) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'You need to fill in all information',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    ingredientsController.text.isEmpty ||
                    stepsController.text.isEmpty) {
                  ref.read(showErrorMessagesProvider.notifier).setTrue();
                  return;
                } else {
                  final updatedRecipe = Recipe(
                    id: recipe.id,
                    name: nameController.text,
                    category: categoryController.text,
                    image: imageController.text,
                    ingredients: ingredientsController.text.split('\n'),
                    steps: stepsController.text.split('\n'),
                    userId: recipe.userId,
                  );
                  ref.read(showErrorMessagesProvider.notifier).setFalse();
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

final showErrorMessagesProvider = StateNotifierProvider<ShowErrorMessages, bool>((ref) => ShowErrorMessages());

class ShowErrorMessages extends StateNotifier<bool> {
  ShowErrorMessages() : super(false);

  void setTrue() {
    state = true;
  }
  void setFalse() {
    state = false;
  }
}
