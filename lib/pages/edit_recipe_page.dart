import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../providers/user_provider.dart';

class RecipeNotifier extends StateNotifier<List<Recipe>> {
  final String userId;

  RecipeNotifier({required this.userId}) : super([]) {
    _fetchRecipes();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _fetchRecipes() async {
    if (userId == '') {
      return;
    }

    final snapshot = await _firestore
        .collection('recipes')
        .where('userId', isEqualTo: userId)
        .get();
    final recipes = snapshot.docs.map((doc) {
      return Recipe.fromFirestore(doc.data(), doc.id);
    }).toList();

    state = recipes;
  }

  void addRecipe(Recipe recipe) async {
    if (userId == '') {
      return;
    }

    final recipeData = recipe.toFirestore();

    final recipeRef =
        await _firestore.collection('recipes').add(recipeData);
    final newRecipe = Recipe.fromFirestore(recipeData, recipeRef.id);
    state = [...state, newRecipe];
  }

  void deleteRecipe(int id) async {
    await _firestore.collection('recipes').doc(id.toString()).delete();
    state = state.where((recipe) => recipe.id != id).toList();
  }
}

final recipeProvider =
    StateNotifierProvider<RecipeNotifier, List<Recipe>>((ref) {
  final asyncUser = ref.watch(userProvider);
  return asyncUser.when(data: (user) {
    return RecipeNotifier(userId: user!.uid);
  }, loading: () {
    return RecipeNotifier(userId: '');
  }, error: (error, stackTrace) {
    return RecipeNotifier(userId: '');
  });
});
