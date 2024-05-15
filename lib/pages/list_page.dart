import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/categories.dart';
import '../models/recipe.dart';
import '../providers/user_provider.dart';
import './recipe_page.dart';
import 'app_bar.dart';
import '../providers/recipe_provider.dart'; 

class ListPage extends ConsumerWidget {
  final Category? category;
 
  const ListPage({Key? key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final isUserLoggedIn = ref.watch(userProvider).value != null;
    final String? searchTerm = ref.watch(searchTermProvider);
    
    if (category != null) {
      return Scaffold(
        appBar: const MyAppBar(),
        body: PagedListView<int, Recipe>(
          pagingController: ref.watch(recipeProviderState.notifier).getRecipesForCategory(category!),
          builderDelegate: PagedChildBuilderDelegate<Recipe>(
            itemBuilder: (context, recipe, index) {
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

              return ListTile(
                title: Row(
                  children: [
                    Text(recipe.name),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        if (!isUserLoggedIn) return;
                        ref.read(recipeProviderState.notifier).updateFavourite(recipe);
                        Navigator.pushNamed(context, '/user'); 
                      },
                    ),
                    Text('$favCount'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipePage(recipe: recipe),
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
    } else if (searchTerm != null && searchTerm.isNotEmpty) {
      final recipes = ref.watch(recipeProviderState.notifier).searchRecipes(searchTerm);
      return Scaffold(
        appBar: const MyAppBar(),
        body: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
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

            return ListTile(
              title: Row(
                children: [
                  Text(recipe.name),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      if (!isUserLoggedIn) return;
                      ref.watch(recipeProviderState.notifier).updateFavourite(recipe);
                    },
                  ),
                  Text('$favCount'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipePage(recipe: recipe),
                  ),
                );
              },
            );
          },
        ),
      );
    } else {
      return const Scaffold(
        appBar: MyAppBar(),
        body: Center(
          child: Text('No recipes found'),
        ),
      );
    }
  }
}
