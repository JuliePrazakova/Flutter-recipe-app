import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/categories.dart';
import '../models/recipe.dart';
import './recipe_page.dart';
import 'app_bar.dart';
import '../providers/recipe_provider.dart'; 
class ListPage extends ConsumerWidget {
  final Category? category;
  final String? searchTerm;

  const ListPage({super.key, this.category, this.searchTerm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Recipe> recipes = [];

    if (searchTerm != null && searchTerm!.isNotEmpty) {
      recipes = ref.watch(recipeProviderState.notifier).searchRecipes(searchTerm!);
    } else if (category != null) {
      recipes = ref.watch(recipeProviderState.notifier).getRecipesForCategory(category!);
    }

     return Scaffold(
      appBar: const MyAppBar(),
      body: ListView.builder(
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
      ),
    );
  }
}