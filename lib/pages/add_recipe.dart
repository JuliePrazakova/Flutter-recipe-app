import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/categories.dart';
import '../providers/category_provider.dart';
import '../providers/recipe_provider.dart';
import '../models/recipe.dart';
import 'app_bar.dart';

class AddRecipePage extends ConsumerWidget {
  const AddRecipePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    final TextEditingController ingredientsController = TextEditingController();
    final TextEditingController stepsController = TextEditingController();
    final String? userId = _auth.currentUser?.uid;
    final TextEditingController categoryTextController =
        TextEditingController();

    final categoryController = StateController<String>('');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 160.0),
        child: Consumer(
          builder: (context, ref, child) {
            final showErrorMessages = ref.watch(showErrorMessagesProvider);
            final pagingController = ref.watch(categoryProviderState);
            final selectedCategoryProvider =
                StateProvider<String>((ref) => '-1');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Recipe Name'),
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
                TextField(
                  readOnly: true,
                  controller: categoryTextController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                if (showErrorMessages)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'You need to fill in all information',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                Flexible(
                  child: PagedListView<int, Category>(
                    pagingController: pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Category>(
                      itemBuilder: (context, category, index) {
                        return ListTile(
                          title: Text(category.name),
                          tileColor:
                              ref.watch(selectedCategoryProvider) == category.id
                                  ? Colors.blue.withOpacity(0.5)
                                  : null,
                          onTap: () {
                            categoryController.state = category.id;
                            categoryTextController.text = category.name;
                          },
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        ingredientsController.text.isEmpty ||
                        stepsController.text.isEmpty) {
                      ref.read(showErrorMessagesProvider.notifier).setTrue();
                      return;
                    }
                    final newRecipe = Recipe(
                      id: '',
                      name: nameController.text,
                      categoryId: categoryController.state,
                      image: imageController.text,
                      ingredients: ingredientsController.text.split('\n'),
                      steps: stepsController.text.split('\n'),
                      userId: userId ?? '',
                      fav: [],
                    );
                    ref.read(showErrorMessagesProvider.notifier).setFalse();
                    ref
                        .watch(recipeProviderState.notifier)
                        .addRecipe(newRecipe);
                    Navigator.pop(context);
                  },
                  child: const Text('Add Recipe'),
                ),
                const Expanded(
                  child: SizedBox(height: 16),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

final showErrorMessagesProvider =
    StateNotifierProvider<ShowErrorMessages, bool>(
        (ref) => ShowErrorMessages());

class ShowErrorMessages extends StateNotifier<bool> {
  ShowErrorMessages() : super(false);

  void setTrue() {
    state = true;
  }

  void setFalse() {
    state = false;
  }
}
