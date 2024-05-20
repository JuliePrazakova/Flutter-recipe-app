import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:second_project/pages/recipe_page.dart';
import '../models/categories.dart';
import './list_page.dart';
import './category_page.dart';
import '../providers/recipe_provider.dart';
import '../providers/category_provider.dart';
import 'app_bar.dart';
import 'breakpoints.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeProvider = ref.watch(recipeProviderState);
    final pagingController = ref.watch(categoryProviderState);

    return Scaffold(
      appBar: const MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () {
                  if (recipeProvider.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RecipePage(recipe: recipeProvider.first),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 400,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: recipeProvider.isEmpty
                      ? const Center(child: Text('No recipes found'))
                      : Card(
                          margin: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: const Placeholder(
                                  fallbackHeight: 330,
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    recipeProvider.first.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),

            // Explore Categories button
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoryPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Explore All Categories',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors
                            .blue, // Change color to indicate it's clickable text
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Explore Categories section
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double screenWidth = MediaQuery.of(context).size.width;
                  final double itemWidth;
                  final crossAxisCount;

                  if (screenWidth > Breakpoints.xl) {
                    crossAxisCount = 5;
                    itemWidth = screenWidth / crossAxisCount - 12;
                  } else if (screenWidth > Breakpoints.md) {
                    crossAxisCount = 3;
                    itemWidth = screenWidth / crossAxisCount - 12;
                  } else {
                    crossAxisCount = 2;
                    itemWidth = screenWidth / crossAxisCount - 12;
                  }

                  return PagedGridView<int, Category>(
                    physics:
                        const NeverScrollableScrollPhysics(), // Zamezí scrollování
                    pagingController: pagingController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: itemWidth / (itemWidth * 1.2),
                    ),
                    builderDelegate: PagedChildBuilderDelegate<Category>(
                      itemBuilder: (context, category, index) {
                        if (index >= crossAxisCount) {
                          return const SizedBox
                              .shrink(); // Skrýt kategorie po prvních 'crossAxisCount' položkách
                        }
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
            ),
          ],
        ),
      ),
    );
  }
}
