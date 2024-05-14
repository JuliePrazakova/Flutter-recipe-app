import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe_provider.dart';
import '../models/recipe.dart';

class AddRecipePage extends ConsumerWidget {
  const AddRecipePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    final TextEditingController ingredientsController = TextEditingController();
    final TextEditingController stepsController = TextEditingController();
    final String? userId = _auth.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer(
          builder: (context, ref, child) {
            final showErrorMessages = ref.watch(showErrorMessagesProvider);

            return Column(
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
                if (showErrorMessages)
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'You need to fill in all information',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        ingredientsController.text.isEmpty ||
                        stepsController.text.isEmpty) {
                      ref.read(showErrorMessagesProvider.notifier).toggle();
                      return;
                    }
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
            );
          },
        ),
      ),
    );
  }
}

final showErrorMessagesProvider = StateNotifierProvider<ShowErrorMessages, bool>((ref) => ShowErrorMessages());

class ShowErrorMessages extends StateNotifier<bool> {
  ShowErrorMessages() : super(false);

  void toggle() {
    state = !state;
  }
}
