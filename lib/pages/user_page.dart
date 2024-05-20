import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:second_project/pages/app_bar.dart';
import '../providers/recipe_provider.dart';
import 'add_recipe.dart';
import 'recipe_detail.dart';
import 'recipe_page.dart';
import 'breakpoints.dart';

class UserPage extends ConsumerWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final recipeProvider = ref.watch(recipeProviderState);
    final userRecipes =
        recipeProvider.where((recipe) => recipe.userId == user?.uid).toList();
    final favoriteRecipes = recipeProvider
        .where((recipe) => recipe.fav.contains(user?.uid))
        .toList();

    if (size.width > Breakpoints.xl) {
      return Scaffold(
        appBar: const MyAppBar(),
        body: Column(
          children: [
            const SizedBox(height: 150),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 150),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 60),
                  const SizedBox(width: 20),
                  Text(
                    'Welcome user number ${user?.uid ?? 'Unknown'}!',
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(height: 16),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text('Logout'),
                    onPressed: () async {
                      await auth.signOut();
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 180),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'My Recipes',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: userRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = userRecipes[index];
                            return ListTile(
                              title: Text(recipe.name),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  ref
                                      .read(recipeProviderState.notifier)
                                      .deleteRecipe(recipe.id);
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RecipeDetailsPage(recipe: recipe),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )),
                  const VerticalDivider(),
                  Expanded(
                      child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Favorite Recipes',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: favoriteRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = favoriteRecipes[index];
                            return ListTile(
                              title: Text(recipe.name),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RecipePage(recipe: recipe),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ],
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
    } else if (size.width < Breakpoints.md) {
      return Scaffold(
        appBar: const MyAppBar(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.person, size: 40),
                  const SizedBox(width: 20),
                  Text(
                    'Welcome user number ${user?.uid ?? 'Unknown'}!',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'My Recipes',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: userRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = userRecipes[index];
                            return ListTile(
                              title: Text(recipe.name),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  ref
                                      .read(recipeProviderState.notifier)
                                      .deleteRecipe(recipe.id);
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RecipeDetailsPage(recipe: recipe),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )),
                  const VerticalDivider(),
                  Expanded(
                      child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Favorite Recipes',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: favoriteRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = favoriteRecipes[index];
                            return ListTile(
                              title: Text(recipe.name),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RecipePage(recipe: recipe),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ],
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
    } else {
      return Scaffold(
        appBar: const MyAppBar(),
        body: Column(
          children: [
            const SizedBox(height: 100),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Expanded(
                    child: SizedBox(height: 6),
                  ),
                  const Icon(Icons.person, size: 50),
                  const SizedBox(width: 20),
                  Text(
                    'Welcome user number ${user?.uid ?? 'Unknown'}!',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(height: 6),
                  ),
                ],
              ),
            ),
            SizedBox(height: 150),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'My Recipes',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: userRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = userRecipes[index];
                            return ListTile(
                              title: Text(recipe.name),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  ref
                                      .read(recipeProviderState.notifier)
                                      .deleteRecipe(recipe.id);
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RecipeDetailsPage(recipe: recipe),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )),
                  const VerticalDivider(),
                  Expanded(
                      child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Favorite Recipes',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: favoriteRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = favoriteRecipes[index];
                            return ListTile(
                              title: Text(recipe.name),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RecipePage(recipe: recipe),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ],
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
}
