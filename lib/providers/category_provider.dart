import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/categories.dart';

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super([]) {
    _fetchCategories();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _fetchCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    final categories = snapshot.docs.map((doc) {
      return Category.fromFirestore(doc.data(), doc.id);
    }).toList();

    state = categories;
  }

  void addCategory(Category category) async {
    final categoryData = category.toFirestore();

    final categoryRef = await _firestore.collection('categories').add(categoryData);
    final newCategory = Category.fromFirestore(categoryData, categoryRef.id);
    state = [...state, newCategory];
  }

  void deleteCategory(String id) async {
    await _firestore.collection('categories').doc(id).delete();
    state = state.where((category) => category.id != id).toList();
  }
}

final categoryProviderState =
    StateNotifierProvider<CategoryNotifier, List<Category>>((ref) => CategoryNotifier());
