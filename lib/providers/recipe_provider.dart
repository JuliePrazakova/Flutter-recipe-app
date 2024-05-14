import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/categories.dart';
import '../models/recipe.dart';

class RecipeNotifier extends StateNotifier<List<Recipe>> {
  final String userId;
  RecipeNotifier({required this.userId}) : super([]) {
    _fetchRecipes();
  }
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _fetchRecipes() async {
    final snapshot = await _firestore.collection('recipes').get();
    final recipes = snapshot.docs.map((doc) {
      return Recipe.fromFirestore(doc.data(), doc.id);
    }).toList();

    state = recipes;
  }

  void updateRecipe(Recipe updatedRecipe) async {
    if (userId == '') {
      return;
    }

    final recipeData = updatedRecipe.toFirestore();

  await _firestore.collection('recipes').doc(updatedRecipe.id).update(recipeData);

  state = state.map((recipe) {
    if (recipe.id == updatedRecipe.id) {
      return updatedRecipe;
    } else {
      return recipe;
    }
  }).toList();
}


 void addRecipe(Recipe recipe) async {
  if (userId == '') {
      return;
  }
  final recipeData = recipe.toFirestore();

  // Přidání receptu do kolekce 'recipes' ve Firestore a získání ID nového dokumentu
  final recipeRef = await _firestore.collection('recipes').add(recipeData);

  // Získání ID nového dokumentu
  final newRecipeId = recipeRef.id;

  // Vytvoření nového receptu s ID a uložení do stavu
  final newRecipe = Recipe(
    id: newRecipeId,
    name: recipe.name,
    category: recipe.category,
    image: recipe.image,
    ingredients: recipe.ingredients,
    steps: recipe.steps,
    userId: recipe.userId,
  );
  state = [...state, newRecipe];
}


  void deleteRecipe(String id) async {
    if (userId == '') {
      return;
    }

    await _firestore.collection('recipes').doc(id).delete();
    state = state.where((recipe) => recipe.id != id).toList();
  }

  List<Recipe> searchRecipes(String searchTerm) {
    final List<Recipe> filteredRecipes = state
        .where((recipe) => recipe.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
    return filteredRecipes;
  }


  List<Recipe> getRecipesForCategory(Category category) {
    return state.where((recipe) => recipe.category == category.name).toList();
  }
}

final recipeProviderState = StateNotifierProvider.autoDispose<RecipeNotifier, List<Recipe>>(
  (ref) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';
    
    return RecipeNotifier(userId: userId);
  },
);


