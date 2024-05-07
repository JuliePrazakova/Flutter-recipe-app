import 'package:flutter/material.dart';
import '../services/recipe_service.dart'; 
import 'app_bar.dart';
import './list_page.dart';


class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: FutureBuilder<List<Category>>(
        future: RecipeService.getCategories(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading categories: ${snapshot.error}'),
            );
          } else {
            const Text('Recipe Categories');
            final List<Category> categories = snapshot.data!; 
            return ListView.builder(
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
            );
          }
        },
      ),
    );
  }
}
