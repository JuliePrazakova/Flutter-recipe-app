import 'package:flutter/material.dart';
import 'package:second_project/pages/recipe_page.dart';
import '../services/recipe_service.dart';
import './list_page.dart';
import './category_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to our recipe application!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display featured recipe
            Container(
              width: 300,
              margin: const EdgeInsets.all(10),
              child: FutureBuilder<List<Recipe>>(
                future: RecipeService.getRecipes(), // Fetch recipes
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While data is loading
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // If there's an error
                    return Text('Error loading recipes: ${snapshot.error}');
                  } else {
                    // Once data is loaded, display the first recipe as the featured recipe
                    final List<Recipe> recipes = snapshot.data!;
                    final Recipe featuredRecipe = recipes.isNotEmpty ? recipes[0] : Recipe(id: -1, name: 'No recipes found', category: '', image: '', ingredients: [], steps: []);
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Featured Recipe',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8), // Spacing below the "Featured Recipe" title
                            ListTile(
                              title: Text(featuredRecipe.name),
                              subtitle: Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[300], // Placeholder color
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => RecipePage(recipe: featuredRecipe)));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),

            // Explore Categories section
            Container(
              width: 300,
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryPage()));
                    },
                    child: const Text(
                      'Explore All Categories',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 16), // Spacing below Explore Categories title
                  // Display 3 categories
                  FutureBuilder<List<Category>>(
                    future: RecipeService.getCategories(), // Fetch categories
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // While data is loading
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // If there's an error
                        return Text('Error loading categories: ${snapshot.error}');
                      } else {
                        // Once data is loaded, display the first 3 categories
                        final List<Category> categories = snapshot.data!;
                        final List<Category> firstThreeCategories = categories.length >= 3 ? categories.sublist(0, 3) : categories;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: firstThreeCategories.map((category) {
                            return ListTile(
                              title: Text(category.name),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => ListPage(category: category)));
                              },
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
