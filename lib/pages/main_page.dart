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
                                RecipePage(recipe: recipeProvider.first)));
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
                                title: Container(
                                  width: double.infinity,
                                  height: 300, // Placeholder image height
                                  color: Colors.grey[300],
                                ),
                                subtitle: Text(recipeProvider.first.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 28,
                                    )),
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
                              builder: (_) => const CategoryPage()));
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
            SizedBox(
              height: 200, // Adjust height as needed
              child: PagedListView<int, Category>(
                pagingController: pagingController,
                builderDelegate: PagedChildBuilderDelegate<Category>(
                  itemBuilder: (context, category, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ListPage(category: category)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Container(
                              width: 180, // Adjust image width
                              height: 120, // Adjust image height
                              color:
                                  Colors.grey[300], // Placeholder image color
                              // You can add actual images here
                            ),
                            const SizedBox(height: 8),
                            Text(category.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
