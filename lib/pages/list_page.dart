import 'package:flutter/material.dart';
import '../services/recipe_service.dart';
import './recipe_page.dart';
import 'app_bar.dart';

class ListPage extends StatelessWidget {
  final Category category; 

  const ListPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: FutureBuilder<List<Recipe>>(
        future: RecipeService.getRecipesForCategory(category.name),
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