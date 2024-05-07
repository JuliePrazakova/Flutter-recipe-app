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
        title: const Text('Welcome to our recipe application!s'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display featured recipe
            FutureBuilder<List<Recipe>>(
              future: RecipeService.getRecipes(), // Fetch recipes
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading recipes: ${snapshot.error}');
                } else {
                  final List<Recipe> recipes = snapshot.data!;
                  final Recipe featuredRecipe = recipes.isNotEmpty ? recipes[0] : Recipe(id: -1, name: 'No recipes found', category: '', image: '', ingredients: [], steps: []);
                  return Card(
                    margin: const EdgeInsets.all(16.0),
                    child: ListTile(
                      title:const  Text('Featured Recipe'),
                      subtitle: Text(featuredRecipe.name),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => RecipePage(recipe: featuredRecipe)));
                      },
                    ),
                  );
                }
              },
            ),

            // Display subset of recipe categories
            FutureBuilder<List<Category>>(
              future: RecipeService.getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); 
                } else if (snapshot.hasError) {
                  return Text('Error loading categories: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Wrap(
                    spacing: 8.0,
                    children: snapshot.data!.map((category) {
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListPage(category: category),
                            ),
                          );                        },
                        child: Text(category.name),
                      );
                    }).toList(),
                  );
                } else {
                  return const Text('No categories found');
                }
              },
            ),

            // link to the category page
             TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryPage()));
              },
              child: const Text('Explore Categories'),
            ),
          ],
        ),
      ),
    );
  }
}
