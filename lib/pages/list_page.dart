import 'package:flutter/material.dart';
import '../services/recipe_service.dart';
import './recipe_page.dart';
import 'app_bar.dart';

class ListPage extends StatelessWidget {
  final Category category; // Přijímáme kategorii jako vstupní argument

  const ListPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: FutureBuilder<List<Recipe>>(
        future: RecipeService.getRecipesForCategory(category.name), // Získáme recepty pro danou kategorii
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), // Indikátor načítání
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading recipes: ${snapshot.error}'), // Chybová zpráva při načítání receptů
            );
          } else {
            Text(category.name);
            final List<Recipe> recipes = snapshot.data!; // Seznam receptů
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(recipes[index].name), // Název receptu
                  onTap: () {
                    // Při kliknutí na recept navigujeme na stránku s detaily receptu
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