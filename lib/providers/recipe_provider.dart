import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
      fav: recipe.fav,
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

PagingController<int, Recipe> getRecipesForCategory(Category category) {
  final pagingController = PagingController<int, Recipe>(firstPageKey: 0);

  pagingController.addPageRequestListener((pageKey) {
    Query query = _firestore.collection('recipes').where('categoryId', isEqualTo: category.id);

    // Pouze jedno volání limit(20)
    if (pageKey != 0) {
      final lastRecipe = pagingController.itemList?.isNotEmpty ?? false ? pagingController.itemList!.last.name : null;
      query = query.where(FieldPath.documentId, isGreaterThan: lastRecipe);
    }

    query.get().then((snapshot) {
      final recipes = snapshot.docs.map((doc) {
        return Recipe.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      final isLastPage = recipes.length < 20;

      if (isLastPage) {
        pagingController.appendLastPage(recipes);
      } else {
        pagingController.appendPage(recipes, pageKey + 1);
      }
    }).catchError((error) {
      print(error);
    });
  });

  return pagingController;
}



  void updateRecipe(Recipe updatedRecipe) async {
    if (userId == '' || userId != updatedRecipe.userId) {
      return;
    } else if(userId == updatedRecipe.userId) {
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
  }

  void updateFavourite(Recipe recipe) async {
    if (userId == '') {
      return;
    }

    final List<String> favorites = List<String>.from(recipe.fav);

    if (favorites.contains(userId)) {
      favorites.remove(userId);
    } else {
      favorites.add(userId);
    }

    final updatedRecipe = Recipe(
      id: recipe.id,
      name: recipe.name,
      categoryId: recipe.categoryId,
      image: recipe.image,
      ingredients: recipe.ingredients,
      steps: recipe.steps,
      userId: recipe.userId,
      fav: favorites,
    );
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



