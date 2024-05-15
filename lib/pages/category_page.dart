import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/categories.dart';
import '../providers/category_provider.dart'; 
import 'app_bar.dart';
import './list_page.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagingController = ref.watch(categoryProviderState);

    return Scaffold(
      appBar: const MyAppBar(),
      body: PagedListView<int, Category>(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Category>(
          itemBuilder: (context, category, index) {
            return ListTile(
              title: Text(category.name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListPage(category: category),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
