import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/categories.dart';

class CategoryNotifier extends StateNotifier<PagingController<int, Category>> {
  CategoryNotifier() : super(PagingController<int, Category>(firstPageKey: 0)) {
    _fetchCategories();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _fetchCategories() {
    state.addPageRequestListener((pageKey) {
      Query query = _firestore.collection('categories').orderBy('name');

      query = query.limit(20);

      if (pageKey != 0) {
        final lastCategory = state.itemList?.isNotEmpty ?? false ? state.itemList!.last.name : null;
        query = query.startAfter([lastCategory]);
      }

      query.get().then((snapshot) {
        final categories = snapshot.docs.map((doc) {
          return Category.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        final isLastPage = categories.length < 20;

        if (isLastPage) {
          state.appendLastPage(categories);
        } else {
          state.appendPage(categories, pageKey + 1);
        }
      }).catchError((error) {
        state.error = error;
      });
    });
  }
}

final categoryProviderState = StateNotifierProvider<CategoryNotifier, PagingController<int, Category>>(
  (ref) => CategoryNotifier(),
);
