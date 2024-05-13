import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final categoryProvider = ref.watch(categoryProviderState); 

    return Scaffold(
      appBar: const MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            // Display featured recipe
            Container(
              width: 300,
              margin: const EdgeInsets.all(10),
              child: recipeProvider.isEmpty
                ? const Text('No recipes found')
                : Card(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Featured Recipe',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8), 
                          ListTile(
                            title: Text(recipeProvider.first.name),
                            subtitle: Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                            ),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => RecipePage(recipe: recipeProvider.first)));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
            ),

            // Explore Categories section
            Container(
              width: 300,
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryPage()));
                    },
                    child: const Text(
                      'Explore All Categories',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16), 

                  // Display 3 categories
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: categoryProvider.length,
                    itemBuilder: (context, index) {
                      final Category category = categoryProvider[index];
                      return ListTile(
                        title: Text(category.name),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ListPage(category: category)));
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
