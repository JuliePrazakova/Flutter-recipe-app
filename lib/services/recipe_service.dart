import 'dart:convert';
import 'package:flutter/services.dart';

class Recipe {
  final int id;
  final String name;
  final String category;
  final String image;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.ingredients,
    required this.steps,
  });
}

class Category {
  final int id;
  final String name;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.image,
  });
}

class RecipeService {
  static Future<List<Recipe>> getRecipes() async {
    try {
      final String recipesJson = await rootBundle.loadString('data/recipes.json');
      final List<dynamic> recipesData = jsonDecode(recipesJson);
      return recipesData.map((data) {
        return Recipe(
          id: data['id'],
          name: data['name'],
          category: data['category'],
          image: data['image'],
          ingredients: List<String>.from(data['ingredients']),
          steps: List<String>.from(data['steps']),
        );
      }).toList();
    } catch (e) {
      // Error handling
      print('Error loading recipes: $e');
      return [];
    }
  }

  static Future<List<Category>> getCategories() async {
    try {
      final String categoriesJson = await rootBundle.loadString('data/categories.json');
      final List<dynamic> categoriesData = jsonDecode(categoriesJson);
      return categoriesData.map((data) {
        return Category(
          id: data['id'],
          name: data['name'],
          image: data['image'],
        );
      }).toList();
    } catch (e) {
      // Error handling
      print('Error loading categories: $e');
      return [];
    }
  }
}
