import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/categories.dart';
import '../models/recipe.dart';
import './recipe_page.dart';
import 'app_bar.dart';
import '../providers/recipe_provider.dart'; 
class ListPage extends ConsumerWidget {
  final Category? category;
 
  const ListPage({super.key, this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Recipe> recipes = [];

    final String? searchTerm = ref.watch(searchTermProvider);

   if (category != null) {
      recipes = ref.watch(recipeProviderState.notifier).getRecipesForCategory(category!);
    } else if (searchTerm != null && searchTerm.isNotEmpty) {
      recipes = ref.watch(recipeProviderState.notifier).searchRecipes(searchTerm);
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