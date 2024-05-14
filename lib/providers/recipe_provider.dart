import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/categories.dart';
import '../models/recipe.dart';
import './user_provider.dart';

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
    final recipeRef = await _firestore.collection('recipes').add(recipeData);
    final newRecipeId = recipeRef.id;

    final newRecipe = Recipe(
      id: newRecipeId,
      name: recipe.name,
      categoryId: recipe.categoryId,
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
    return state.where((recipe) => recipe.categoryId == category.id).toList();
  }
}

final recipeProviderState = StateNotifierProvider.autoDispose<RecipeNotifier, List<Recipe>>(
  (ref) {
    final asyncUser = ref.watch(userProvider);
    return asyncUser.when(data: (user) {
      return RecipeNotifier(userId: user?.uid ?? '');
    }, loading: () {
      return RecipeNotifier(userId: '');
    }, error: (error, stackTrace) {
      return RecipeNotifier(userId: '');
    });
  },
);



