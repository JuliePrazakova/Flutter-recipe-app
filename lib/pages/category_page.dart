import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/category_provider.dart'; // Import CategoryProvider
import 'app_bar.dart';
import './list_page.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProviderState); // Watch CategoryNotifier provider

    return Scaffold(
      appBar: const MyAppBar(),
      body: categories.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(categories[index].name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListPage(category: categories[index]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
