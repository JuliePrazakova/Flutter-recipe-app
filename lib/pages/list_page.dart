import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/categories.dart';
import '../models/recipe.dart';
import './recipe_page.dart';
import 'app_bar.dart';
import '../providers/recipe_provider.dart'; // Import RecipeProvider

class ListPage extends ConsumerWidget {
  final Category category;

  const ListPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeProvider = ref.watch(recipeProviderState); // Watch RecipeNotifier provider

    // Function to filter recipes based on category
    List<Recipe> _getRecipesForCategory() {
      return recipeProvider.where((recipe) => recipe.category == category.name).toList();
    }

    return Scaffold(
      appBar: const MyAppBar(),
      body: FutureBuilder<List<Recipe>>(
        future: Future.value(_getRecipesForCategory()), // Use Future.value() to simulate immediate future completion
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading recipes: ${snapshot.error}'),
            );
          } else {
            Text(category.name);
            final List<Recipe> recipes = snapshot.data!;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(recipes[index].name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipePage(recipe: recipes[index]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
