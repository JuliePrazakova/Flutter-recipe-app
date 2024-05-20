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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = 180.0;
          final itemCount = constraints.maxWidth ~/ itemWidth;
          final crossAxisCount = itemCount == 0 ? 1 : itemCount;
          return PagedGridView<int, Category>(
            pagingController: pagingController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: itemWidth / (itemWidth * 1.2),
            ),
            builderDelegate: PagedChildBuilderDelegate<Category>(
              itemBuilder: (context, category, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListPage(category: category),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Placeholder(
                          fallbackWidth: 180,
                          fallbackHeight: 120,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
