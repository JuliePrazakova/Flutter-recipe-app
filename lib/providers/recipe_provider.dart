import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/categories.dart';
import '../models/recipe.dart';

class RecipeNotifier extends StateNotifier<List<Recipe>> {
  RecipeNotifier() : super([]) {
    _fetchRecipes();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static RecipeNotifier get notifier => RecipeNotifier();

  void _fetchRecipes() async {
    final snapshot = await _firestore.collection('recipes').get();
    final recipes = snapshot.docs.map((doc) {
      return Recipe.fromFirestore(doc.data(), doc.id);
    }).toList();

    state = recipes;
    print(recipes);
  }

  void addRecipe(Recipe recipe) async {
    final recipeData = recipe.toFirestore();

    final recipeRef = await _firestore.collection('recipes').add(recipeData);
    final newRecipe = Recipe.fromFirestore(recipeData, recipeRef.id);
    state = [...state, newRecipe];
  }

  void deleteRecipe(int id) async {
    await _firestore.collection('recipes').doc(id.toString()).delete();
    state = state.where((recipe) => recipe.id != id).toList();
  }

  List<Recipe> searchRecipes(String searchTerm) {
    final List<Recipe> filteredRecipes = state
        .where((recipe) => recipe.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();

    print('Tady je print:');
    print('tady je searchTerm:' + searchTerm);
    print(filteredRecipes);

    return filteredRecipes;
  }


  List<Recipe> getRecipesForCategory(Category category) {
    return state.where((recipe) => recipe.category == category.name).toList();
  }
}

final recipeProviderState =
    StateNotifierProvider<RecipeNotifier, List<Recipe>>((ref) => RecipeNotifier());
